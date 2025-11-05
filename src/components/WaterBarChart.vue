<template>
  <div class="chart-card">
    <h3>Water Intake (ml, Last 7 Days)</h3>
    <Bar :data="chartData" :options="chartOptions" />
  </div>
</template>

<script setup>
import { Bar } from "vue-chartjs";
import { Chart as ChartJS, Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale } from "chart.js";
ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale);

const props = defineProps({ data: Array });
const chartData = {
  labels: props.data.map(d => d.date.slice(5)),
  datasets: [
    {
      label: "Water (ml)",
      data: props.data.map(d => d.value),
      backgroundColor: "rgba(91, 141, 239, 0.6)",
      borderRadius: 8,
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
