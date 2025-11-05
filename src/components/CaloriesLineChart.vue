<template>
  <div class="chart-card">
    <h3>Calories (Last 7 Days)</h3>
    <Line :data="chartData" :options="chartOptions" />
  </div>
</template>

<script setup>
import { Line } from "vue-chartjs";
import { Chart as ChartJS, Title, Tooltip, Legend, LineElement, CategoryScale, LinearScale, PointElement } from "chart.js";
ChartJS.register(Title, Tooltip, Legend, LineElement, CategoryScale, LinearScale, PointElement);

const props = defineProps({ data: Array });
const chartData = {
  labels: props.data.map(d => d.date.slice(5)),
  datasets: [
    {
      label: "Calories",
      data: props.data.map(d => d.value),
      borderColor: "#FFD166",
      backgroundColor: "rgba(255,209,102,0.3)",
      tension: 0.4,
      fill: true,
    },
  ],
};
const chartOptions = { responsive: true, plugins: { legend: { display: false } } };
</script>

<style scoped>
.chart-card {
  background: white;
  color: #333;
  padding: 1.5rem;
  border-radius: 15px;
  box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
}
</style>
