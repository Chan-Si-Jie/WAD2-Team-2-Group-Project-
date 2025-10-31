<template>
  <div>
    <!-- Render chart only when series has data -->
    <ApexChart
      v-if="series.length"
      type="pie"
      :options="chartOptions"
      :series="series"
      height="250"
    />
  </div>
</template>

<script setup>
import { ref, watch } from "vue";
import ApexChart from "vue3-apexcharts"; // import

// Props
const props = defineProps({
  carbs: { type: Number, default: 0 },
  protein: { type: Number, default: 0 },
  fat: { type: Number, default: 0 },
});

// Chart series and options
const series = ref([props.carbs, props.protein, props.fat]);

const chartOptions = {
  labels: ["Carbs", "Protein", "Fat"],
  legend: { position: "bottom" },
  responsive: [
    {
      breakpoint: 480,
      options: { chart: { width: 300 }, legend: { position: "bottom" } },
    },
  ],
};

// Update chart if props change
watch(
  () => [props.carbs, props.protein, props.fat],
  ([c, p, f]) => {
    series.value = [c, p, f];
  }
);
</script>
