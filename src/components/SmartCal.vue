<template>
  <div class="log-page">
    <!-- HEADER -->
    <header class="log-header">
      <h1>📊 SmartCal Tracker</h1>
      <p>Track your calories, macros, and progress visually.</p>
    </header>

    <!-- LOG ENTRY SECTION -->
    <section class="log-entry">
      <h2>Log Your Food</h2>
      <div class="input-group">
        <input type="text" placeholder="Search for food or enter custom item..." v-model="newFoodName" />
        <button @click="addFood">Add</button>
      </div>
    </section>

    <!-- FOOD CARDS -->
    <section class="food-cards">
      <div class="food-card" v-for="item in foods" :key="item.name" @click="showChart(item)">
        <h3>{{ item.name }}</h3>
        <p>Calories: {{ item.calories }} kcal</p>
        <p>Protein: {{ item.protein }} g</p>
        <p>Fats: {{ item.fats }} g</p>
        <p>Carbs: {{ item.carbs }} g</p>
      </div>
    </section>

    <!-- PIE CHART -->
    <transition name="fade">
      <section class="chart-section" v-if="selectedFood">
        <h2>Nutrition Breakdown: {{ selectedFood.name }}</h2>
        <div class="chart-wrapper">
          <canvas id="macroChart" width="200" height="200"></canvas>
        </div>
      </section>
    </transition>

    <!-- WEEKLY RECOMMENDATION -->
    <section class="recommendation-section">
      <h2>Weekly Recommendation</h2>
      <div class="rec-controls">
        <button @click="getRecommendation" :disabled="loading">
          {{ loading ? 'Analyzing...' : 'Get Weekly Recommendation' }}
        </button>
        <button @click="clearRecommendation">Clear</button>
      </div>
      <div class="rec-output" v-if="recommendation || error">
        <p v-if="recommendation">{{ recommendation }}</p>
        <p v-if="error" style="color: red">{{ error }}</p>
      </div>
    </section>

    <!-- FOOTER -->
    <footer class="log-footer">
      <button @click="$router.push('/')">Back to Home</button>
    </footer>
  </div>
</template>

<script setup>
import { ref, nextTick } from "vue";
import { GoogleGenAI } from "@google/genai";
import { Chart, PieController, ArcElement, Tooltip, Legend } from "chart.js";
import "../assets/logPage.css"; // import the CSS file

Chart.register(PieController, ArcElement, Tooltip, Legend);

const foods = ref([
  { name: "Apple", calories: 95, protein: 0.5, fats: 0.3, carbs: 25 },
  { name: "Chicken Rice", calories: 400, protein: 20, fats: 10, carbs: 50 },
]);

const newFoodName = ref("");
const selectedFood = ref(null);
const loading = ref(false);
const error = ref(null);
const recommendation = ref(null);
let macroChart = null;

const addFood = () => {
  if (!newFoodName.value) return;
  foods.value.push({
    name: newFoodName.value,
    calories: 100,
    protein: 5,
    fats: 5,
    carbs: 15,
  });
  newFoodName.value = "";
};

const showChart = async (food) => {
  if (food.name !== "Chicken Rice") {
    selectedFood.value = null;
    if (macroChart) macroChart.destroy();
    return;
  }

  selectedFood.value = null;
  await nextTick();

  selectedFood.value = food;
  await nextTick();

  if (macroChart) macroChart.destroy();
  const ctx = document.getElementById("macroChart").getContext("2d");
  macroChart = new Chart(ctx, {
    type: "pie",
    data: {
      labels: ["Protein", "Fats", "Carbs"],
      datasets: [
        {
          label: "Macros",
          data: [food.protein, food.fats, food.carbs],
          backgroundColor: ["#007BFF", "#00C2FF", "#00FFA3"],
          borderWidth: 1,
        },
      ],
    },
    options: {
      responsive: true,
      animation: { animateRotate: true, duration: 1000 },
      plugins: { legend: { position: "bottom" } },
    },
  });
};


const getRecommendation = async () => {
  loading.value = true;
  error.value = null;
  recommendation.value = null;
  const GEMINI_API_KEY = import.meta.env.VITE_GEMINI_API_KEY;

  const ai = new GoogleGenAI({ apiKey: GEMINI_API_KEY });

  const prompt = `User ate these items this week: ${JSON.stringify(foods.value)}.
Give a short plain-text recommendation: what to eat more/less and any macro focus (1-2 sentences).`;

  
  try {
    const response = await ai.models.generateContent({
      model: "gemini-2.5-flash",
      contents: prompt,
    });
    console.log(response.text);
    recommendation.value = response.text;
  } catch (err) {
    error.value = err.message || "Failed to get recommendation";
  } finally {
    loading.value = false;
  }
};

const clearRecommendation = () => {
  recommendation.value = null;
  error.value = null;
};
</script>
