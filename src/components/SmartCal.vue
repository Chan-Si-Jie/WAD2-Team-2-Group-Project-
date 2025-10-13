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
        <input
          type="text"
          placeholder="Search for food or enter custom item..."
          v-model="newFoodName"
        />
        <button @click="addFood">Add</button>
      </div>
    </section>

    <!-- FOOD CARDS -->
    <section class="food-cards">
      <div
        class="food-card"
        v-for="item in foods"
        :key="item.name"
        @click="showChart(item)"
      >
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

    <!-- FOOTER -->
    <footer class="log-footer">
      <button @click="$router.push('/')">Back to Home</button>
    </footer>
  </div>
</template>

<script setup>
import { ref, nextTick } from "vue";
import { Chart, PieController, ArcElement, Tooltip, Legend } from "chart.js";
import "../assets/logPage.css"; // import the CSS file

Chart.register(PieController, ArcElement, Tooltip, Legend);

const foods = ref([
  { name: "Apple", calories: 95, protein: 0.5, fats: 0.3, carbs: 25 },
  { name: "Chicken Rice", calories: 400, protein: 20, fats: 10, carbs: 50 },
]);

const newFoodName = ref("");
const selectedFood = ref(null);
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
</script>
