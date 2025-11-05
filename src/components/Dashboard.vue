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
        <input v-model="mealName" placeholder="Meal Name" />
        <input
          v-model.number="mealCalories"
          type="number"
          placeholder="Calories"
        />
        <button @click="addMeal">Submit</button>
        <button @click="showMealForm = false">Cancel</button>
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

      <NutritionPieChart
        v-if="dataFetched"
        :carbs="totalCarbs"
        :protein="totalProtein"
        :fat="totalFat"
      />
    </section>

    <!-- AI Recommendations -->
    <section class="recommendations-section">
      <h2>AI Nutrition Recommendations</h2>
      <p class="recommendations-subtitle">
        Get personalized advice based on your daily intake
      </p>
      <div class="rec-controls">
        <button @click="getRecommendation" :disabled="loading || !dataFetched">
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
import { ref, watchEffect, onMounted } from "vue";
import { supabase } from "@/supabase";
import { userState } from "@/state/userState";
import NutritionPieChart from "@/components/NutritionPieChart.vue";
import Navbar from "@/components/Navbar.vue";
import { useRouter } from "vue-router";

const router = useRouter();

// User
const user = userState.user;

// Totals
const totalCalories = ref(0);
const totalWater = ref(0);
const totalCarbs = ref(0);
const totalProtein = ref(0);
const totalFat = ref(0);
const dataFetched = ref(false);

// AI Recommendations
const recommendation = ref(null);
const loading = ref(false);
const error = ref(null);

// Backend API URL - use relative path for Vercel, absolute for local dev
const API_URL = import.meta.env.VITE_API_URL || (import.meta.env.MODE === 'production' ? '' : 'http://localhost:3000');

// Form visibility
const showMealForm = ref(false);
const showWaterForm = ref(false);
const showNutritionForm = ref(false);

// Form inputs
const mealName = ref("");
const mealCalories = ref(null);
const waterAmount = ref(null);
const nutritionCarbs = ref(null);
const nutritionProtein = ref(null);
const nutritionFat = ref(null);

// Get today's date
function getToday() {
  const now = new Date();
  return now.toISOString().split("T")[0];
}

// Fetch data from Supabase
async function fetchData() {
  if (!user) return;

  const today = getToday();

  // Fetch meals
  const { data: meals } = await supabase
    .from("meals")
    .select("*")
    .eq("user_id", user.id)
    .gte("date", today);
  const mealCalories = meals?.reduce((sum, m) => sum + m.calories, 0) || 0;

  // Fetch water
  const { data: water } = await supabase
    .from("water_logs")
    .select("*")
    .eq("user_id", user.id)
    .gte("date", today);
  totalWater.value = water?.reduce((sum, w) => sum + w.amount, 0) || 0;

  // Fetch nutrition
  const { data: nutrition } = await supabase
    .from("nutrition")
    .select("*")
    .eq("user_id", user.id)
    .gte("date", today);
  const nutritionCalories =
    nutrition?.reduce((sum, n) => sum + n.calories, 0) || 0;
  totalCarbs.value = nutrition?.reduce((sum, n) => sum + n.carbs, 0) || 0;
  totalProtein.value = nutrition?.reduce((sum, n) => sum + n.protein, 0) || 0;
  totalFat.value = nutrition?.reduce((sum, n) => sum + n.fat, 0) || 0;

  // Total calories = meals + nutrition
  totalCalories.value = mealCalories + nutritionCalories;

  dataFetched.value = true;
}

// Add entries
async function addMeal() {
  if (!mealName.value || !mealCalories.value) return;
  await supabase
    .from("meals")
    .insert([
      { user_id: user.id, name: mealName.value, calories: mealCalories.value },
    ]);
  mealName.value = "";
  mealCalories.value = null;
  showMealForm.value = false;
  fetchData();
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
  const calories =
    (nutritionCarbs.value || 0) * 4 +
    (nutritionProtein.value || 0) * 4 +
    (nutritionFat.value || 0) * 9;
  await supabase.from("nutrition").insert([
    {
      user_id: user.id,
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

// AI Recommendation
async function getRecommendation() {
  loading.value = true;
  error.value = null;
  recommendation.value = null;

  const today = getToday();

  try {
    // Fetch all data from today for more detailed recommendations
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

    const response = await fetch(`${API_URL}/api/recommendation`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ summary }),
    });

    if (!response.ok) {
      const errorData = await response.json();
      console.error('API Error Response:', errorData);
      throw new Error(errorData.message || errorData.error || "Failed to get recommendation");
    }

    const data = await response.json();
    recommendation.value = data.recommendation;
  } catch (err) {
    console.error("Recommendation error:", err);
    error.value =
      err.message ||
      "Failed to get recommendation. Make sure the server is running.";
  } finally {
    loading.value = false;
  }
}

function clearRecommendation() {
  recommendation.value = null;
  error.value = null;
}

// Fetch data on mount
watchEffect(() => {
  if (user) {
    fetchData();
  }
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
  width: 300px;
}
.form-container input {
  padding: 0.5rem;
  border-radius: 8px;
  border: 1px solid #ccc;
}
.form-container button {
  padding: 0.5rem;
  border: none;
  border-radius: 8px;
  cursor: pointer;
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
}

.recommendations-section h2 {
  margin-bottom: 0.5rem;
  font-size: 1.8rem;
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
  font-size: 0.95rem;
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
