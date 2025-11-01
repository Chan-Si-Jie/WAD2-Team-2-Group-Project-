import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import { GoogleGenerativeAI } from '@google/generative-ai';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Initialize Gemini AI
const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);

// Health check endpoint
app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', message: 'Server is running' });
});

// Recommendation endpoint
app.post('/api/recommendation', async (req, res) => {
  try {
    const { summary } = req.body;

    if (!summary) {
      return res.status(400).json({ 
        error: 'Invalid request. Please provide a summary.' 
      });
    }

    let prompt;

    // Check if this is from Dashboard (has totals object) or SmartCal (has items array)
    if (summary.totals && summary.totals.calories !== undefined) {
      // Dashboard format - daily summary
      const { totals, meals, waterLogs, nutritionEntries } = summary;
      
      prompt = `Analyze this user's daily nutrition intake:

Total Calories: ${totals.calories} kcal
Total Water: ${totals.water} ml
Total Carbs: ${totals.carbs}g
Total Protein: ${totals.protein}g
Total Fat: ${totals.fat}g

Meals logged today: ${meals?.map(m => `${m.name} (${m.calories} kcal)`).join(', ') || 'None'}
Water logs: ${waterLogs?.length || 0} entries
Nutrition entries: ${nutritionEntries?.length || 0} entries

Please provide:
1. A brief assessment of their daily intake
2. Specific recommendations for today (what to add/adjust for the rest of the day)
3. Hydration advice if water intake is low
4. Macro balance feedback

Keep the response concise (3-4 sentences) and actionable for today.`;
    } else if (summary.items) {
      // SmartCal format - weekly summary
      prompt = `User ate these items this week: ${JSON.stringify(summary.items)}.
Total nutrition for the week: Calories: ${summary.totals?.calories || 0} kcal, Protein: ${summary.totals?.protein || 0}g, Fats: ${summary.totals?.fats || 0}g, Carbs: ${summary.totals?.carbs || 0}g.

Please analyze this weekly food intake and provide:
1. A brief assessment of their current eating pattern
2. Specific recommendations on what to eat more or less of
3. Any macro nutrient adjustments needed (protein, fats, carbs)

Keep the response concise (3-4 sentences) and actionable.`;
    } else {
      return res.status(400).json({ 
        error: 'Invalid summary format. Expected either totals or items.' 
      });
    }

    // Get the generative model (using the correct model name)
    const model = genAI.getGenerativeModel({ model: 'gemini-2.5-flash' });

    // Generate content
    const result = await model.generateContent(prompt);
    const response = await result.response;
    const text = response.text();

    res.json({ 
      recommendation: text,
      success: true 
    });

  } catch (error) {
    console.error('Error generating recommendation:', error);
    res.status(500).json({ 
      error: 'Failed to generate recommendation',
      message: error.message 
    });
  }
});

// Start server
app.listen(PORT, () => {
  console.log(`🚀 Server running on http://localhost:${PORT}`);
  console.log(`📊 API endpoint: http://localhost:${PORT}/api/recommendation`);
});
