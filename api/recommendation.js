// Vercel Serverless Function for Gemini AI Recommendations
import { GoogleGenerativeAI } from "@google/generative-ai";

// Initialize Gemini AI
const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);

export default async function handler(req, res) {
  // Set CORS headers
  res.setHeader('Access-Control-Allow-Credentials', true);
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET,OPTIONS,PATCH,DELETE,POST,PUT');
  res.setHeader(
    'Access-Control-Allow-Headers',
    'X-CSRF-Token, X-Requested-With, Accept, Accept-Version, Content-Length, Content-MD5, Content-Type, Date, X-Api-Version'
  );

  // Handle OPTIONS request for CORS
  if (req.method === 'OPTIONS') {
    res.status(200).end();
    return;
  }

  // Only allow POST requests
  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  try {
    // Log API key status (first 10 chars only for security)
    const apiKeyExists = !!process.env.GEMINI_API_KEY;
    const apiKeyPreview = apiKeyExists 
      ? process.env.GEMINI_API_KEY.substring(0, 10) + '...' 
      : 'NOT SET';
    
    console.log('API Key status:', apiKeyExists ? 'EXISTS' : 'MISSING');
    console.log('API Key preview:', apiKeyPreview);

    const { summary } = req.body;

    if (!summary) {
      return res.status(400).json({
        error: "Invalid request. Please provide a summary.",
        debug: {
          apiKeyExists,
          apiKeyPreview
        }
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

Meals logged today: ${
        meals?.map((m) => `${m.name} (${m.calories} kcal)`).join(", ") || "None"
      }
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
      prompt = `User ate these items this week: ${JSON.stringify(
        summary.items
      )}.
Total nutrition for the week: Calories: ${
        summary.totals?.calories || 0
      } kcal, Protein: ${summary.totals?.protein || 0}g, Fats: ${
        summary.totals?.fats || 0
      }g, Carbs: ${summary.totals?.carbs || 0}g.

Please analyze this weekly food intake and provide:
1. A brief assessment of their current eating pattern
2. Specific recommendations on what to eat more or less of
3. Any macro nutrient adjustments needed (protein, fats, carbs)

Keep the response concise (3-4 sentences) and actionable.`;
    } else {
      return res.status(400).json({
        error: "Invalid summary format. Expected either totals or items.",
      });
    }

    // Get the generative model
    const model = genAI.getGenerativeModel({ model: "gemini-pro" });

    // Generate content
    const result = await model.generateContent(prompt);
    const response = await result.response;
    const text = response.text();

    return res.status(200).json({
      recommendation: text,
      success: true,
    });
  } catch (error) {
    console.error("Error generating recommendation:", error);
    console.error("Error stack:", error.stack);
    console.error("API Key exists:", !!process.env.GEMINI_API_KEY);
    
    return res.status(500).json({
      error: "Failed to generate recommendation",
      message: error.message,
      debug: {
        errorType: error.constructor.name,
        apiKeyExists: !!process.env.GEMINI_API_KEY
      }
    });
  }
}
