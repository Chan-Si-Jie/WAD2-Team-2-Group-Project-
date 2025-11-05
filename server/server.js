import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import { GoogleGenerativeAI } from "@google/generative-ai";

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Initialize Gemini AI
const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);

// Health check endpoint
app.get("/api/health", (req, res) => {
  res.json({ status: "ok", message: "Server is running" });
});

// Recommendation endpoint
app.post("/api/recommendation", async (req, res) => {
  try {
    const { summary } = req.body;

    if (!summary) {
      return res.status(400).json({
        error: "Invalid request. Please provide a summary.",
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

    // Get the generative model (using the correct model name)
    const model = genAI.getGenerativeModel({ model: "gemini-2.5-flash" });

    // Generate content
    const result = await model.generateContent(prompt);
    const response = await result.response;
    const text = response.text();

    res.json({
      recommendation: text,
      success: true,
    });
  } catch (error) {
    console.error("Error generating recommendation:", error);
    res.status(500).json({
      error: "Failed to generate recommendation",
      message: error.message,
    });
  }
});

// Food search endpoint using USDA API
app.get("/api/food/search", async (req, res) => {
  try {
    const { query } = req.query;

    if (!query || query.length < 2) {
      return res.status(400).json({
        error: "Query must be at least 2 characters long",
      });
    }

    const USDA_API_KEY = process.env.USDA_API_KEY;
    
    if (!USDA_API_KEY) {
      return res.status(500).json({
        error: "USDA API key not configured",
      });
    }

    const encodedQuery = encodeURIComponent(query);
    const url = `https://api.nal.usda.gov/fdc/v1/foods/search?api_key=${USDA_API_KEY}&query=${encodedQuery}&pageSize=8&dataType=Foundation,SR Legacy`;

    const response = await fetch(url);

    if (!response.ok) {
      throw new Error(`USDA API Error: ${response.status}`);
    }

    const data = await response.json();

    if (data.foods && data.foods.length > 0) {
      const foods = data.foods.map((food) => {
        const nutrients = food.foodNutrients || [];

        const getNutrient = (nutrientId) => {
          const nutrient = nutrients.find((n) => n.nutrientId === nutrientId);
          return nutrient ? Math.round(nutrient.value) : 0;
        };

        return {
          name: food.description || food.lowercaseDescription || "Unknown",
          calories: getNutrient(1008), // Energy (kcal)
          serving: "100g",
          carbs: getNutrient(1005), // Carbohydrate
          protein: getNutrient(1003), // Protein
          fat: getNutrient(1004), // Total lipid (fat)
          foodId: food.fdcId,
        };
      });

      res.json({
        foods,
        success: true,
      });
    } else {
      res.json({
        foods: [],
        success: true,
      });
    }
  } catch (error) {
    console.error("Error searching food:", error);
    res.status(500).json({
      error: "Failed to search food",
      message: error.message,
    });
  }
});

// Spoonacular Recipe API endpoints
// Search recipes
app.get("/api/recipes/search", async (req, res) => {
  try {
    const { query } = req.query;

    if (!query || query.length < 2) {
      return res.status(400).json({
        error: "Query must be at least 2 characters long",
      });
    }

    const SPOONACULAR_API_KEY = process.env.SPOONACULAR_API_KEY;
    
    if (!SPOONACULAR_API_KEY) {
      return res.status(500).json({
        error: "Spoonacular API key not configured",
      });
    }

    const encodedQuery = encodeURIComponent(query);
    const url = `https://api.spoonacular.com/recipes/complexSearch?query=${encodedQuery}&number=12&addRecipeNutrition=true&addRecipeInformation=true&fillIngredients=true&apiKey=${SPOONACULAR_API_KEY}`;

    const response = await fetch(url);

    if (!response.ok) {
      throw new Error(`Spoonacular API Error: ${response.status}`);
    }

    const data = await response.json();

    res.json({
      recipes: data.results || [],
      success: true,
    });
  } catch (error) {
    console.error("Error searching recipes:", error);
    res.status(500).json({
      error: "Failed to search recipes",
      message: error.message,
    });
  }
});

// Get random recipes
app.get("/api/recipes/random", async (req, res) => {
  try {
    const SPOONACULAR_API_KEY = process.env.SPOONACULAR_API_KEY;
    
    if (!SPOONACULAR_API_KEY) {
      return res.status(500).json({
        error: "Spoonacular API key not configured",
      });
    }

    const url = `https://api.spoonacular.com/recipes/random?number=12&apiKey=${SPOONACULAR_API_KEY}`;

    const response = await fetch(url);

    if (!response.ok) {
      throw new Error(`Spoonacular API Error: ${response.status}`);
    }

    const data = await response.json();

    res.json({
      recipes: data.recipes || [],
      success: true,
    });
  } catch (error) {
    console.error("Error fetching random recipes:", error);
    res.status(500).json({
      error: "Failed to fetch random recipes",
      message: error.message,
    });
  }
});

// Get recipe details with nutrition
app.get("/api/recipes/:id", async (req, res) => {
  try {
    const { id } = req.params;

    if (!id) {
      return res.status(400).json({
        error: "Recipe ID is required",
      });
    }

    const SPOONACULAR_API_KEY = process.env.SPOONACULAR_API_KEY;
    
    if (!SPOONACULAR_API_KEY) {
      return res.status(500).json({
        error: "Spoonacular API key not configured",
      });
    }

    const url = `https://api.spoonacular.com/recipes/${id}/information?includeNutrition=true&apiKey=${SPOONACULAR_API_KEY}`;

    const response = await fetch(url);

    if (!response.ok) {
      throw new Error(`Spoonacular API Error: ${response.status}`);
    }

    const data = await response.json();

    res.json({
      recipe: data,
      success: true,
    });
  } catch (error) {
    console.error("Error fetching recipe details:", error);
    res.status(500).json({
      error: "Failed to fetch recipe details",
      message: error.message,
    });
  }
});

// Start server (for local development)
if (process.env.NODE_ENV !== 'production') {
  app.listen(PORT, () => {
    console.log(`🚀 Server running on http://localhost:${PORT}`);
    console.log(`📊 API endpoint: http://localhost:${PORT}/api/recommendation`);
  });
}

// Export for Vercel
export default app;
