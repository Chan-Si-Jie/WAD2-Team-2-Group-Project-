<template>
  <div>
    <Navbar />
    <div class="dashboard">
      <header class="dashboard-header">
        <h1>Welcome, {{ user?.email }}</h1>
        <p>Track your meals, water, and nutrition today!</p>
      </header>

      <section class="rings">
        <div class="ring">
          <h3>Calories Today</h3>
          <div class="value">{{ totalCalories }} kcal</div>
        </div>
        <div class="ring">
          <h3>Water Today</h3>
          <div class="value">{{ totalWater }} ml</div>
        </div>
      </section>

      <section class="quick-actions">
        <h2>Quick Actions</h2>
        <button @click="showMealForm = true">Add Meal</button>
        <button @click="showWaterForm = true">Add Water</button>
        <button @click="showNutritionForm = true">Add Nutrition</button>
        <button @click="$router.push('/meal-planner')">📅 Meal Planner</button>
      </section>

      <!-- Forms -->
      <div v-if="showMealForm" class="form-overlay">
        <div class="form-container">
          <h3>Add Meal</h3>

          <!-- Food Search -->
          <div class="food-search">
            <input
              v-model="foodQuery"
              @input="searchFood"
              placeholder="Search for food (e.g., apple, chicken breast)"
              class="search-input"
            />
            <div v-if="searchingFood" class="search-loading">Searching...</div>

            <!-- Search Results -->
            <div v-if="foodResults.length > 0" class="food-results">
              <div class="results-header">Select a food:</div>
              <div
                v-for="(food, index) in foodResults"
                :key="index"
                @click="selectFood(food)"
                class="food-result-item"
              >
                <div class="food-name">{{ food.name }}</div>
                <div class="food-calories">
                  {{ Math.round(food.calories) }} kcal per {{ food.serving }}
                </div>
              </div>
            </div>
          </div>

          <!-- Manual Entry -->
          <div class="manual-entry">
            <div class="or-divider">OR enter manually</div>
            <input v-model="mealName" placeholder="Meal Name" />

            <!-- Meal Type Selector -->
            <div class="meal-type-selector">
              <label>Meal Type:</label>
              <select v-model="mealType">
                <option v-for="type in mealTypes" :key="type" :value="type">
                  {{ type }}
                </option>
              </select>
            </div>

            <input
              v-model.number="mealCalories"
              type="number"
              placeholder="Calories"
            />

            <!-- Show nutrition data if available -->
            <div v-if="selectedFoodData" class="nutrition-preview">
              <div class="nutrition-preview-title">
                📊 Nutrition Information:
              </div>
              <div class="nutrition-preview-grid">
                <div class="nutrition-item">
                  <span class="nutrition-label">Carbs:</span>
                  <span class="nutrition-value">{{ mealCarbs }}g</span>
                </div>
                <div class="nutrition-item">
                  <span class="nutrition-label">Protein:</span>
                  <span class="nutrition-value">{{ mealProtein }}g</span>
                </div>
                <div class="nutrition-item">
                  <span class="nutrition-label">Fat:</span>
                  <span class="nutrition-value">{{ mealFat }}g</span>
                </div>
              </div>
              <div class="nutrition-note">
                ✨ Nutrition data will be saved automatically
              </div>
            </div>
          </div>

          <div class="form-buttons">
            <button @click="addMeal" :disabled="!mealName || !mealCalories">
              Submit
            </button>
            <button @click="closeMealForm" class="cancel-btn">Cancel</button>
          </div>
        </div>
      </div>

      <div v-if="showWaterForm" class="form-overlay">
        <div class="form-container">
          <h3>Add Water (ml)</h3>
          <input
            v-model.number="waterAmount"
            type="number"
            placeholder="Amount (ml)"
          />
          <button @click="addWater">Submit</button>
          <button @click="showWaterForm = false">Cancel</button>
        </div>
      </div>

      <div v-if="showNutritionForm" class="form-overlay">
        <div class="form-container">
          <h3>Add Nutrition</h3>
          <input
            v-model.number="nutritionCarbs"
            type="number"
            placeholder="Carbs (g)"
          />
          <input
            v-model.number="nutritionProtein"
            type="number"
            placeholder="Protein (g)"
          />
          <input
            v-model.number="nutritionFat"
            type="number"
            placeholder="Fat (g)"
          />
          <button @click="addNutrition">Submit</button>
          <button @click="showNutritionForm = false">Cancel</button>
        </div>
      </div>

      <!-- Nutrition Breakdown -->
      <section class="nutrition-breakdown">
        <h2>Nutrition Breakdown Today</h2>
        <div class="breakdown">
          <div>Carbs: {{ totalCarbs }} g</div>
          <div>Protein: {{ totalProtein }} g</div>
          <div>Fat: {{ totalFat }} g</div>
        </div>

        <!-- Pie Chart -->
        <NutritionPieChart
          v-if="dataFetched"
          :carbs="totalCarbs"
          :protein="totalProtein"
          :fat="totalFat"
        />

        <div class="charts-container" v-if="dataFetched">
          <!-- Calories Line Chart -->
          <CaloriesLineChart
            v-if="weeklyCalories.length && dataFetched"
            :data="weeklyCalories"
          />
        </div>
      </section>

      <!-- AI Recommendations -->
      <section class="recommendations-section">
        <h2>AI Nutrition Recommendations</h2>
        <p class="recommendations-subtitle">
          Get personalized advice based on your daily intake
        </p>
        <div class="rec-controls">
          <button
            @click="getRecommendation"
            :disabled="loading || !dataFetched"
          >
            {{ loading ? "Analyzing..." : "Get Daily Recommendation" }}
          </button>
          <button @click="clearRecommendation" v-if="recommendation || error">
            Clear
          </button>
        </div>
        <div class="rec-output" v-if="recommendation || error">
          <div v-if="recommendation" class="recommendation-text">
            <strong>💡 Recommendation:</strong>
            <p>{{ recommendation }}</p>
          </div>
          <p v-if="error" class="error-text">{{ error }}</p>
        </div>
      </section>
    </div>
  </div>
</template>

<script setup>
import { ref, watchEffect } from "vue";
import { supabase } from "@/supabase";
import { userState } from "@/state/userState";
import Navbar from "@/components/Navbar.vue";
import NutritionPieChart from "@/components/NutritionPieChart.vue";
import CaloriesLineChart from "@/components/CaloriesLineChart.vue";
import WaterBarChart from "./WaterBarChart.vue";

const API_URL = import.meta.env.VITE_API_URL || "http://localhost:3000";

const user = userState.user;

// Daily totals
const totalCalories = ref(0);
const totalWater = ref(0);
const totalCarbs = ref(0);
const totalProtein = ref(0);
const totalFat = ref(0);
const dataFetched = ref(false);

// Weekly calories chart
const weeklyCalories = ref([]);

// Forms
const showMealForm = ref(false);
const showWaterForm = ref(false);
const showNutritionForm = ref(false);
const mealName = ref("");
const mealCalories = ref(null);
const mealCarbs = ref(null);
const mealProtein = ref(null);
const mealFat = ref(null);
const mealType = ref("Breakfast"); // For meal planner integration
const waterAmount = ref(null);
const nutritionCarbs = ref(null);
const nutritionProtein = ref(null);
const nutritionFat = ref(null);

// Meal types for planner
const mealTypes = ["Breakfast", "Lunch", "Dinner", "Snack"];

// Food Search
const foodQuery = ref("");
const foodResults = ref([]);
const searchingFood = ref(false);
const selectedFoodData = ref(null);
let searchTimeout = null;

// Search food function - now calls backend API
async function searchFood() {
  clearTimeout(searchTimeout);

  if (!foodQuery.value || foodQuery.value.length < 2) {
    foodResults.value = [];
    return;
  }

  searchingFood.value = true;

  searchTimeout = setTimeout(async () => {
    try {
      const query = encodeURIComponent(foodQuery.value);
      const url = `${import.meta.env.VITE_API_URL || "http://localhost:3000"
      }/api/food/search?query=${query}`;

      const response = await fetch(url);

      if (!response.ok) {
        throw new Error(`API Error: ${response.status}`);
      }

      const data = await response.json();

      if (data.foods && data.foods.length > 0) {
        foodResults.value = data.foods;
      } else {
        foodResults.value = [];
      }
    } catch (error) {
      console.error("Error fetching food data:", error);
      foodResults.value = [];
    } finally {
      searchingFood.value = false;
    }
  }, 500);
}

// Select food from search results
function selectFood(food) {
  mealName.value = food.name + " - " + food.serving;
  mealCalories.value = Math.round(food.calories);
  mealCarbs.value = food.carbs;
  mealProtein.value = food.protein;
  mealFat.value = food.fat;
  selectedFoodData.value = food;
  foodQuery.value = "";
  foodResults.value = [];
}

// Close meal form and reset
function closeMealForm() {
  showMealForm.value = false;
  mealName.value = "";
  mealCalories.value = null;
  mealCarbs.value = null;
  mealProtein.value = null;
  mealFat.value = null;
  mealType.value = "Breakfast"; // Reset to default
  selectedFoodData.value = null;
  foodQuery.value = "";
  foodResults.value = [];
}

// Get today's date
function getToday() {
  return new Date().toISOString().split("T")[0];
}

// Fetch daily totals
async function fetchData() {
  if (!user) return;

  const today = getToday();

  // Meals
  const { data: meals } = await supabase
    .from("meals")
    .select("*")
    .eq("user_id", user.id)
    .gte("date", today);
  const mealCal = meals?.reduce((sum, m) => sum + m.calories, 0) || 0;

  // Water
  const { data: water } = await supabase
    .from("water_logs")
    .select("*")
    .eq("user_id", user.id)
    .gte("date", today);
  totalWater.value = water?.reduce((sum, w) => sum + w.amount, 0) || 0;

  // Nutrition
  const { data: nutrition } = await supabase
    .from("nutrition")
    .select("*")
    .eq("user_id", user.id)
    .gte("date", today);
  const nutritionCal = nutrition?.reduce((sum, n) => sum + n.calories, 0) || 0;
  totalCarbs.value = nutrition?.reduce((sum, n) => sum + n.carbs, 0) || 0;
  totalProtein.value = nutrition?.reduce((sum, n) => sum + n.protein, 0) || 0;
  totalFat.value = nutrition?.reduce((sum, n) => sum + n.fat, 0) || 0;

  totalCalories.value = mealCal + nutritionCal;
  dataFetched.value = true;

  await fetchWeeklyCalories();
}

// Fetch weekly calories for chart
async function fetchWeeklyCalories() {
  if (!user) return;

  const startDate = new Date();
  startDate.setDate(startDate.getDate() - 6);
  const formattedStart = startDate.toISOString().split("T")[0];
  const formattedEnd = new Date().toISOString().split("T")[0];

  console.log("Fetching meals from", formattedStart, "to", formattedEnd);

  const { data: meals, error } = await supabase
    .from("meals")
    .select("date, calories")
    .eq("user_id", user.id)
    .gte("date", formattedStart)
    .lte("date", formattedEnd);

  console.log("Fetched meals:", meals);
  if (error) console.error("Error fetching meals:", error);

  const dailyCalories = {};
  for (let i = 0; i < 7; i++) {
    const d = new Date();
    d.setDate(d.getDate() - (6 - i));
    dailyCalories[d.toISOString().split("T")[0]] = 0;
  }

  meals?.forEach((m) => {
    const dateKey = m.date.split('T')[0];
    console.log("Adding meal with date:", dateKey, "calories:", m.calories);
    dailyCalories[dateKey] = (dailyCalories[dateKey] || 0) + m.calories;
  });

  console.log("Daily calories:", dailyCalories);

  weeklyCalories.value = Object.entries(dailyCalories).map(([date, value]) => ({
    date,
    value,
  }));
  
  console.log("Weekly calories for chart:", weeklyCalories.value);
}

// Add entries
async function addMeal() {
  if (!mealName.value || !mealCalories.value) return;

  const today = new Date().toISOString().split("T")[0]; // Format: YYYY-MM-DD

  // Add meal to meals table
  await supabase
    .from("meals")
    .insert([
      { 
        user_id: user.id, 
        name: mealName.value, 
        calories: mealCalories.value, 
        date: today, 
        meal_date: today,
        protein: mealProtein.value || 0,
        carbs: mealCarbs.value || 0,
        fat: mealFat.value || 0
      },
    ]);

  // Add meal to planned_meals table for meal planner integration
  await supabase.from("planned_meals").insert([
    {
      user_id: user.id,
      date: today,
      meal_type: mealType.value,
      name: mealName.value,
      calories: mealCalories.value,
      protein: mealProtein.value || 0,
      carbs: mealCarbs.value || 0,
      fat: mealFat.value || 0,
    },
  ]);

  // If we have nutrition data (from food search), add it to nutrition table
  if (
    mealCarbs.value !== null ||
    mealProtein.value !== null ||
    mealFat.value !== null
  ) {
    const nutritionCalories =
      (mealCarbs.value || 0) * 4 +
      (mealProtein.value || 0) * 4 +
      (mealFat.value || 0) * 9;

    await supabase.from("nutrition").insert([
      {
        user_id: user.id,
        date: today,
        carbs: mealCarbs.value || 0,
        protein: mealProtein.value || 0,
        fat: mealFat.value || 0,
        calories: nutritionCalories,
      },
    ]);
  }

  // Reset form
  mealName.value = "";
  mealCalories.value = null;
  mealCarbs.value = null;
  mealProtein.value = null;
  mealFat.value = null;
  mealType.value = "Breakfast"; // Reset to default
  selectedFoodData.value = null;
  foodQuery.value = "";
  foodResults.value = [];
  showMealForm.value = false;
  
  // Refresh dashboard data
  await fetchData();
}

async function addWater() {
  if (!waterAmount.value) return;
  await supabase
    .from("water_logs")
    .insert([{ user_id: user.id, amount: waterAmount.value }]);
  waterAmount.value = null;
  showWaterForm.value = false;
  fetchData();
}

async function addNutrition() {
  if (!nutritionCarbs.value && !nutritionProtein.value && !nutritionFat.value)
    return;
  const today = new Date().toISOString().split("T")[0];
  const calories =
    (nutritionCarbs.value || 0) * 4 +
    (nutritionProtein.value || 0) * 4 +
    (nutritionFat.value || 0) * 9;
  await supabase.from("nutrition").insert([
    {
      user_id: user.id,
      date: today,
      carbs: nutritionCarbs.value || 0,
      protein: nutritionProtein.value || 0,
      fat: nutritionFat.value || 0,
      calories,
    },
  ]);
  nutritionCarbs.value = null;
  nutritionProtein.value = null;
  nutritionFat.value = null;
  showNutritionForm.value = false;
  fetchData();
}

// Reset Daily Calories (today's meals + nutrition)
async function resetDailyCalories() {
  if (!user) return;
  const today = getToday();

  await supabase
    .from("meals")
    .delete()
    .eq("user_id", user.id)
    .gte("date", today);
  await supabase
    .from("nutrition")
    .delete()
    .eq("user_id", user.id)
    .gte("date", today);

  totalCalories.value = 0;
  totalCarbs.value = 0;
  totalProtein.value = 0;
  totalFat.value = 0;
}

// Reset Weekly Chart (last 7 days meals)
async function resetWeeklyChart() {
  if (!user) return;
  const startDate = new Date();
  startDate.setDate(startDate.getDate() - 6);
  const formattedStart = startDate.toISOString().split("T")[0];

  await supabase
    .from("meals")
    .delete()
    .eq("user_id", user.id)
    .gte("date", formattedStart);

  weeklyCalories.value = [];
}

const recommendation = ref(null);
const loading = ref(false);
const error = ref(null);

async function getRecommendation() {
  loading.value = true;
  error.value = null;
  recommendation.value = null;

  try {
    const today = getToday();

    // Fetch daily meals, water, nutrition
    const [mealsRes, waterRes, nutritionRes] = await Promise.all([
      supabase
        .from("meals")
        .select("*")
        .eq("user_id", user.id)
        .gte("date", today),
      supabase
        .from("water_logs")
        .select("*")
        .eq("user_id", user.id)
        .gte("date", today),
      supabase
        .from("nutrition")
        .select("*")
        .eq("user_id", user.id)
        .gte("date", today),
    ]);

    const summary = {
      totals: {
        calories: totalCalories.value,
        water: totalWater.value,
        carbs: totalCarbs.value,
        protein: totalProtein.value,
        fat: totalFat.value,
      },
      meals: mealsRes.data || [],
      waterLogs: waterRes.data || [],
      nutritionEntries: nutritionRes.data || [],
    };

    // Call your backend API for AI recommendation
    const response = await fetch(
      `${
        import.meta.env.VITE_API_URL || "http://localhost:3000"
      }/api/recommendation`,
      {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ summary }),
      }
    );

    if (!response.ok) throw new Error("Failed to get recommendation");
    const data = await response.json();
    recommendation.value = data.recommendation;
  } catch (err) {
    error.value = err.message || "Failed to fetch recommendation";
  } finally {
    loading.value = false;
  }
}

function clearRecommendation() {
  recommendation.value = null;
  error.value = null;
}

// Fetch on mount
watchEffect(() => {
  if (user) fetchData();
});
</script>

<style scoped>
.dashboard {
  max-width: 900px;
  margin: auto;
  padding: 2rem;
  font-family: "Poppins", sans-serif;
}
.dashboard-header {
  text-align: center;
  margin-bottom: 2rem;
}
.rings {
  display: flex;
  justify-content: space-around;
  margin-bottom: 2rem;
}
.ring {
  background: linear-gradient(135deg, #27ae60, #2ecc71);
  color: white;
  padding: 1.5rem;
  border-radius: 20px;
  width: 200px;
  text-align: center;
  box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
}
.value {
  font-size: 1.5rem;
  font-weight: 700;
  margin-top: 0.5rem;
}
.quick-actions {
  text-align: center;
  margin-bottom: 2rem;
}
.quick-actions button {
  margin: 0.5rem;
  padding: 0.75rem 1.5rem;
  border-radius: 25px;
  border: none;
  background: #5b8def;
  color: white;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
}
.quick-actions button:hover {
  background: #4178c7;
}
.quick-actions .reset-btn {
  background: #e74c3c;
}
.quick-actions .reset-btn:hover {
  background: #c0392b;
}
.form-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}
.form-container {
  background: white;
  padding: 2rem;
  border-radius: 20px;
  display: flex;
  flex-direction: column;
  gap: 1rem;
  width: 500px;
  max-width: 90vw;
  max-height: 90vh;
  overflow-y: auto;
}

.form-container h3 {
  margin-bottom: 0.5rem;
  color: #2c3e50;
  font-size: 1.5rem;
}

/* Food Search Styles */
.food-search {
  margin-bottom: 1rem;
}

.search-input {
  width: 100%;
  padding: 0.75rem;
  border-radius: 10px;
  border: 2px solid #5b8def;
  font-size: 1rem;
  transition: all 0.3s ease;
}

.search-input:focus {
  outline: none;
  border-color: #4178c7;
  box-shadow: 0 0 0 3px rgba(91, 141, 239, 0.1);
}

.search-loading {
  text-align: center;
  padding: 1rem;
  color: #666;
  font-style: italic;
}

.food-results {
  margin-top: 1rem;
  max-height: 300px;
  overflow-y: auto;
  border: 1px solid #e0e0e0;
  border-radius: 10px;
  background: #f8f9fa;
}

.results-header {
  padding: 0.75rem 1rem;
  background: #5b8def;
  color: white;
  font-weight: 600;
  border-radius: 10px 10px 0 0;
  position: sticky;
  top: 0;
  z-index: 1;
}

.food-result-item {
  padding: 1rem;
  border-bottom: 1px solid #e0e0e0;
  cursor: pointer;
  transition: all 0.2s ease;
  background: white;
}

.food-result-item:hover {
  background: #e3f2fd;
  transform: translateX(5px);
}

.food-result-item:last-child {
  border-bottom: none;
}

.food-name {
  font-weight: 600;
  color: #2c3e50;
  margin-bottom: 0.25rem;
}

.food-calories {
  font-size: 0.9rem;
  color: #666;
}

/* Manual Entry Styles */
.manual-entry {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.meal-type-selector {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  background: #f8f9fa;
  padding: 0.75rem;
  border-radius: 8px;
}

.meal-type-selector label {
  font-weight: 600;
  color: #2c3e50;
  font-size: 0.95rem;
  white-space: nowrap;
}

.meal-type-selector select {
  flex: 1;
  padding: 0.5rem;
  border: 2px solid #ddd;
  border-radius: 8px;
  font-size: 0.95rem;
  background: white;
  cursor: pointer;
  transition: all 0.2s;
}

.meal-type-selector select:hover {
  border-color: #3498db;
}

.meal-type-selector select:focus {
  outline: none;
  border-color: #3498db;
  box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
}

/* Nutrition Preview Styles */
.nutrition-preview {
  background: linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%);
  border-radius: 12px;
  padding: 1rem;
  margin-top: 0.5rem;
  border: 2px solid #27ae60;
}

.nutrition-preview-title {
  font-weight: 700;
  color: #27ae60;
  margin-bottom: 0.75rem;
  font-size: 1rem;
}

.nutrition-preview-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 0.75rem;
  margin-bottom: 0.75rem;
}

.nutrition-item {
  background: white;
  padding: 0.5rem;
  border-radius: 8px;
  text-align: center;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.nutrition-label {
  display: block;
  font-size: 0.8rem;
  color: #666;
  margin-bottom: 0.25rem;
}

.nutrition-value {
  display: block;
  font-size: 1.1rem;
  font-weight: 700;
  color: #27ae60;
}

.nutrition-note {
  text-align: center;
  font-size: 0.85rem;
  color: #27ae60;
  font-style: italic;
  margin-top: 0.5rem;
}

.or-divider {
  text-align: center;
  color: #999;
  font-weight: 600;
  margin: 0.5rem 0;
  position: relative;
}

.or-divider::before,
.or-divider::after {
  content: "";
  position: absolute;
  top: 50%;
  width: 40%;
  height: 1px;
  background: #ddd;
}

.or-divider::before {
  left: 0;
}

.or-divider::after {
  right: 0;
}

.form-buttons {
  display: flex;
  gap: 0.5rem;
  margin-top: 0.5rem;
}

.form-buttons button {
  flex: 1;
  padding: 0.75rem;
  border-radius: 10px;
  font-weight: 600;
  transition: all 0.3s ease;
}

.form-buttons button:first-child {
  background: #27ae60;
  color: white;
}

.form-buttons button:first-child:hover:not(:disabled) {
  background: #229954;
}

.form-buttons button:first-child:disabled {
  background: #ccc;
  cursor: not-allowed;
  opacity: 0.6;
}

.cancel-btn {
  background: #e74c3c !important;
  color: white !important;
}

.cancel-btn:hover {
  background: #c0392b !important;
}

.form-container input {
  padding: 0.75rem;
  border-radius: 10px;
  border: 1px solid #ccc;
  font-size: 1rem;
  transition: border-color 0.3s ease;
}

.form-container input:focus {
  outline: none;
  border-color: #5b8def;
}

.form-container button {
  padding: 0.75rem;
  border: none;
  border-radius: 10px;
  cursor: pointer;
  font-size: 1rem;
  font-weight: 600;
}
.nutrition-breakdown {
  text-align: center;
  margin-top: 2rem;
}
.breakdown div {
  margin: 0.5rem 0;
}

/* AI Recommendations Section */
.recommendations-section {
  margin-top: 3rem;
  padding: 2rem;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 20px;
  color: white;
  box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
  text-align: center;
}

.recommendations-subtitle {
  opacity: 0.9;
  margin-bottom: 1.5rem;
  font-size: 0.95rem;
}

.rec-controls {
  display: flex;
  gap: 1rem;
  justify-content: center;
  margin-bottom: 1.5rem;
}

.rec-controls button {
  padding: 0.75rem 1.5rem;
  border-radius: 25px;
  border: none;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
}

.rec-controls button:first-child {
  background: white;
  color: #667eea;
}

.rec-controls button:first-child:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(255, 255, 255, 0.3);
}

.rec-controls button:first-child:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.rec-controls button:last-child {
  background: rgba(255, 255, 255, 0.2);
  color: white;
  border: 1px solid rgba(255, 255, 255, 0.3);
}

.rec-controls button:last-child:hover {
  background: rgba(255, 255, 255, 0.3);
}

.rec-output {
  background: rgba(255, 255, 255, 0.15);
  border-radius: 15px;
  padding: 1.5rem;
  backdrop-filter: blur(10px);
}

.recommendation-text {
  text-align: left;
}

.recommendation-text strong {
  display: block;
  margin-bottom: 0.75rem;
  font-size: 1.1rem;
}

.recommendation-text p {
  line-height: 1.6;
  opacity: 0.95;
}

.error-text {
  color: #ffdddd;
  margin: 0;
}

/* RESPONSIVE DESIGN */
@media (max-width: 1024px) {
  .dashboard {
    max-width: 100%;
    padding: 1.5rem;
  }
}

@media (max-width: 768px) {
  .dashboard {
    padding: 1rem;
  }

  .dashboard-header h1 {
    font-size: 1.5rem;
  }

  .dashboard-header p {
    font-size: 0.9rem;
  }

  .rings {
    flex-direction: column;
    gap: 1rem;
    align-items: center;
  }

  .ring {
    width: 100%;
    max-width: 300px;
  }

  .quick-actions h2 {
    font-size: 1.3rem;
  }

  .quick-actions button {
    display: block;
    width: 100%;
    max-width: 300px;
    margin: 0.5rem auto;
  }

  .recommendations-section {
    padding: 1.5rem;
  }

  .recommendations-section h2 {
    font-size: 1.5rem;
  }

  .rec-controls {
    flex-direction: column;
    align-items: center;
  }

  .rec-controls button {
    width: 100%;
    max-width: 250px;
  }
}

@media (max-width: 480px) {
  .dashboard {
    padding: 0.75rem;
  }

  .dashboard-header h1 {
    font-size: 1.3rem;
  }

  .ring {
    padding: 1rem;
  }

  .value {
    font-size: 1.3rem;
  }

  .quick-actions button {
    padding: 0.6rem 1.2rem;
    font-size: 0.9rem;
  }

  .form-container {
    width: 90%;
    max-width: 300px;
    padding: 1.5rem;
  }

  .recommendations-section {
    padding: 1rem;
  }

  .recommendations-section h2 {
    font-size: 1.3rem;
  }

  .rec-output {
    padding: 1rem;
  }
}
</style>
