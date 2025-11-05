<template>
  <div>
    <!-- Navbar -->
    <Navbar />
    
    <div class="fitness-page">
      <!-- Animated Header -->
      <div class="header-section">
        <h1 class="main-title">
          <span class="emoji-float">🏋️‍♂️</span>
          Fitness Tracker
        <span class="emoji-float">💪</span>
      </h1>
      <div class="header-glow"></div>
    </div>

    <!-- Login Prompt -->
    <div v-if="!userState.user" class="login-card">
      <div class="login-icon">🔐</div>
      <h2>Welcome Back, Champion!</h2>
      <p>Log in to crush your fitness goals and track your progress.</p>
      <button @click="$router.push('/login')" class="login-btn">
        <span>🚀 Start Your Journey</span>
      </button>
      <div class="login-particles">
        <div class="particle"></div>
        <div class="particle"></div>
        <div class="particle"></div>
      </div>
    </div>

    <div v-else class="main-content">
      <!-- Goals Section -->
      <div class="goals-section">
        <div class="section-header">
          <h2>🎯 Your Goals</h2>
          <p class="subtitle">Set your targets and watch yourself grow</p>
        </div>

        <div class="goal-cards">
          <div class="goal-card calories-card">
            <div class="card-icon">🔥</div>
            <h3>Daily Calories</h3>
            <div class="input-wrapper">
              <input type="number" v-model="dailyGoal" min="100" />
              <span class="unit">kcal</span>
            </div>
            <div class="progress-info">
              <p class="progress-text">Weekly Progress</p>
              <p class="progress-value">{{ weeklyCaloriesPercent }}%</p>
            </div>
            <ApexChart
              type="radialBar"
              :series="[weeklyCaloriesPercent]"
              :options="goalRingOptions('Calories', '#ff6b6b')"
              height="200"
            />
            <div class="card-shimmer"></div>
          </div>

          <div class="goal-card workouts-card">
            <div class="card-icon">💪</div>
            <h3>Weekly Workouts</h3>
            <div class="input-wrapper">
              <input type="number" v-model="weeklyGoal" min="1" />
              <span class="unit">workouts</span>
            </div>
            <div class="progress-info">
              <p class="progress-text">Progress</p>
              <p class="progress-value">{{ weeklyWorkoutsPercent }}%</p>
            </div>
            <ApexChart
              type="radialBar"
              :series="[weeklyWorkoutsPercent]"
              :options="goalRingOptions('Workouts', '#4ade80')"
              height="200"
            />
            <div class="card-shimmer"></div>
          </div>
        </div>

        <button @click="saveGoals" class="save-btn">
          <span class="btn-icon">💾</span>
          <span>Save Goals</span>
          <span class="btn-shine"></span>
        </button>
      </div>

      <!-- Weekly Bar Chart -->
      <div class="bar-chart-section">
        <div class="section-header">
          <h2>📊 This Week's Daily Calories</h2>
          <p class="subtitle">Track your weekly burn rate</p>
        </div>
        <div class="chart-container">
          <ApexChart
            type="bar"
            :series="[{ name: 'Calories Burnt', data: weeklyDailyCalories }]"
            :options="weeklyBarOptions"
            height="320"
          />
        </div>
      </div>

      <!-- Workout Log Section -->
      <div class="log-section">
        <div class="section-header">
          <h2>✍️ Log a Workout</h2>
          <p class="subtitle">Record your sweat session</p>
        </div>

        <div class="log-card">
          <div class="input-group">
            <label>🏃 Workout Type</label>
            <select v-model="workoutType" class="log-input">
              <option disabled value="">Select Workout</option>
              <option v-for="(rate, name) in calorieRates" :key="name">
                {{ name }}
              </option>
            </select>
          </div>

          <div class="input-group">
            <label>⏱️ Duration</label>
            <div class="input-with-unit">
              <input
                type="number"
                v-model="minutes"
                min="1"
                placeholder="30"
                class="log-input"
              />
              <span class="input-unit">min</span>
            </div>
          </div>

          <button @click="addWorkout" class="add-btn">
            <span class="btn-icon">➕</span>
            <span>Add Workout</span>
            <span class="btn-ripple"></span>
          </button>
        </div>
      </div>

      <!-- Workout History -->
      <div class="history-section">
        <div class="section-header">
          <h2>📜 Workout History</h2>
          <p class="subtitle">Your fitness journey timeline</p>
        </div>

        <transition-group name="workout" tag="div" class="history-cards">
          <div v-for="w in workouts" :key="w.id" class="history-card">
            <div class="card-badge">{{ getWorkoutEmoji(w.workout_type) }}</div>
            <div class="history-content">
              <div class="history-header">
                <span class="workout-type">{{ w.workout_type }}</span>
                <span class="date">{{ formatDate(w.date) }}</span>
              </div>
              <div class="history-details">
                <div class="detail-item">
                  <span class="detail-icon">⏱️</span>
                  <span class="detail-value">{{ w.minutes }} min</span>
                </div>
                <div class="detail-item">
                  <span class="detail-icon">🔥</span>
                  <span class="detail-value">{{ w.calories_burnt }} kcal</span>
                </div>
              </div>
            </div>
            <div class="mini-chart">
              <ApexChart
                type="radialBar"
                :series="[
                  Math.min(
                    Math.round((w.calories_burnt / dailyGoal) * 100),
                    100
                  ),
                ]"
                :options="goalRingOptions('', '#fbbf24', 0.5)"
                height="70"
                width="70"
              />
            </div>
          </div>
        </transition-group>

        <div v-if="!workouts.length" class="empty-state">
          <div class="empty-icon">🏃‍♂️</div>
          <p class="empty-text">No workouts logged yet.</p>
          <p class="empty-subtext">Start your fitness journey today!</p>
        </div>
      </div>
    </div>
  </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from "vue";
import ApexChart from "vue3-apexcharts";
import { supabase } from "@/supabase";
import { userState } from "@/state/userState";
import Navbar from "@/components/Navbar.vue";

const dailyGoal = ref(2000);
const weeklyGoal = ref(5);
const workoutType = ref("");
const minutes = ref("");
const workouts = ref([]);

const calorieRates = {
  Running: 10,
  Cycling: 8,
  Swimming: 9,
  Yoga: 4,
  "Strength Training": 6,
  Walking: 5,
};

const workoutEmojis = {
  Running: "🏃",
  Cycling: "🚴",
  Swimming: "🏊",
  Yoga: "🧘",
  "Strength Training": "🏋️",
  Walking: "🚶",
};

const getWorkoutEmoji = (type) => workoutEmojis[type] || "💪";

const formatDate = (dateStr) => {
  const date = new Date(dateStr);
  return date.toLocaleDateString("en-US", { month: "short", day: "numeric" });
};

const checkUser = () => {
  if (!userState.user) {
    alert("You must be logged in to track your fitness.");
    return false;
  }
  return true;
};

const saveGoals = async () => {
  if (!checkUser()) return;
  const { error } = await supabase.from("fitness_goals").upsert({
    user_id: userState.user.id,
    daily_calorie_goal: dailyGoal.value,
    weekly_workout_goal: weeklyGoal.value,
  });
  if (error) return alert("Error saving goals: " + error.message);
  alert("Goals saved!");
};

const addWorkout = async () => {
  if (!checkUser()) return;
  if (!workoutType.value || !minutes.value)
    return alert("Please select workout and minutes");

  const calories = Math.round(calorieRates[workoutType.value] * minutes.value);
  const today = new Date().toISOString().split("T")[0];

  const { error } = await supabase.from("fitness_logs").insert({
    user_id: userState.user.id,
    date: today,
    workout_type: workoutType.value,
    minutes: minutes.value,
    calories_burnt: calories,
  });

  if (error) return alert("Error logging workout: " + error.message);

  workouts.value.unshift({
    date: today,
    workout_type: workoutType.value,
    minutes: minutes.value,
    calories_burnt: calories,
  });

  workoutType.value = "";
  minutes.value = "";
};

const loadData = async () => {
  if (!userState.user) return;
  const userId = userState.user.id;

  const { data: goalData } = await supabase
    .from("fitness_goals")
    .select("*")
    .eq("user_id", userId)
    .single();
  if (goalData) {
    dailyGoal.value = goalData.daily_calorie_goal;
    weeklyGoal.value = goalData.weekly_workout_goal;
  }

  const weekStart = new Date();
  weekStart.setDate(weekStart.getDate() - 6);

  const { data: logs } = await supabase
    .from("fitness_logs")
    .select("*")
    .eq("user_id", userId)
    .gte("date", weekStart.toISOString().split("T")[0])
    .order("date", { ascending: true });

  workouts.value = logs || [];
};

const weeklyWorkouts = computed(() => workouts.value.length);
const weeklyCalories = computed(() =>
  workouts.value.reduce((sum, w) => sum + w.calories_burnt, 0)
);

const weeklyCaloriesPercent = computed(() =>
  Math.min(
    Math.round((weeklyCalories.value / (dailyGoal.value * 7)) * 100),
    100
  )
);
const weeklyWorkoutsPercent = computed(() =>
  Math.min(Math.round((weeklyWorkouts.value / weeklyGoal.value) * 100), 100)
);

const weeklyDailyCalories = computed(() => {
  const days = [];
  const today = new Date();
  for (let i = 6; i >= 0; i--) {
    const day = new Date();
    day.setDate(today.getDate() - i);
    const dateStr = day.toISOString().split("T")[0];
    const dailyCalories = workouts.value
      .filter((w) => w.date === dateStr)
      .reduce((sum, w) => sum + w.calories_burnt, 0);
    days.push(dailyCalories);
  }
  return days;
});

const goalRingOptions = (label, color, hollowSize = 55) => ({
  chart: {
    type: "radialBar",
    animations: { enabled: true, speed: 1500, easing: "easeinout" },
  },
  plotOptions: {
    radialBar: {
      hollow: { size: `${hollowSize}%` },
      track: { background: "#f0f0f0", strokeWidth: "100%" },
      dataLabels: {
        name: { show: !!label, fontSize: "14px", fontWeight: 600 },
        value: {
          show: true,
          fontSize: "22px",
          fontWeight: "bold",
          color: color,
        },
      },
    },
  },
  labels: label ? [label] : [],
  colors: [color],
  fill: {
    type: "gradient",
    gradient: {
      shade: "dark",
      type: "horizontal",
      shadeIntensity: 0.5,
      gradientToColors: [color],
      inverseColors: true,
      opacityFrom: 1,
      opacityTo: 1,
    },
  },
});

const weeklyBarOptions = {
  chart: {
    animations: { enabled: true, speed: 800 },
    toolbar: { show: false },
    background: "transparent",
  },
  plotOptions: {
    bar: {
      borderRadius: 12,
      columnWidth: "60%",
      distributed: false,
      dataLabels: { position: "top" },
    },
  },
  dataLabels: {
    enabled: true,
    offsetY: -20,
    style: {
      fontSize: "12px",
      colors: ["#304758"],
    },
  },
  xaxis: {
    categories: Array.from({ length: 7 }, (_, i) => {
      const d = new Date();
      d.setDate(d.getDate() - (6 - i));
      return d.toLocaleDateString("en-US", { weekday: "short" });
    }),
    labels: {
      style: {
        fontSize: "13px",
        fontWeight: 600,
      },
    },
  },
  yaxis: {
    title: {
      text: "Calories Burnt",
      style: { fontSize: "14px", fontWeight: 600 },
    },
    labels: {
      style: {
        fontSize: "12px",
      },
    },
  },
  colors: ["#f87171"],
  fill: {
    type: "gradient",
    gradient: {
      shade: "light",
      type: "vertical",
      shadeIntensity: 0.25,
      gradientToColors: ["#ef4444"],
      inverseColors: false,
      opacityFrom: 0.85,
      opacityTo: 0.65,
    },
  },
  grid: {
    borderColor: "#e7e7e7",
    strokeDashArray: 5,
  },
};

onMounted(() => loadData());
</script>

<style scoped>
.fitness-page {
  padding: 2rem 2rem 2rem 2rem;
  font-family: "Inter", "Poppins", sans-serif;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  min-height: 100vh;
  position: relative;
  overflow-x: hidden;
}

.fitness-page::before {
  content: "";
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: radial-gradient(
      circle at 20% 50%,
      rgba(255, 107, 107, 0.2) 0%,
      transparent 50%
    ),
    radial-gradient(
      circle at 80% 80%,
      rgba(74, 222, 128, 0.2) 0%,
      transparent 50%
    ),
    radial-gradient(
      circle at 40% 90%,
      rgba(251, 191, 36, 0.2) 0%,
      transparent 50%
    );
  pointer-events: none;
  z-index: 0;
}

/* Header Section */
.header-section {
  position: relative;
  text-align: center;
  margin-bottom: 3rem;
  z-index: 1;
}

.main-title {
  font-size: 3.5rem;
  font-weight: 900;
  color: white;
  text-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
  position: relative;
  display: inline-block;
  animation: titleBounce 2s ease-in-out infinite;
}

@keyframes titleBounce {
  0%,
  100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-10px);
  }
}

.emoji-float {
  display: inline-block;
  animation: float 3s ease-in-out infinite;
  font-size: 3rem;
}

.emoji-float:first-child {
  animation-delay: 0s;
}

.emoji-float:last-child {
  animation-delay: 1.5s;
}

@keyframes float {
  0%,
  100% {
    transform: translateY(0) rotate(0deg);
  }
  25% {
    transform: translateY(-15px) rotate(-5deg);
  }
  75% {
    transform: translateY(-10px) rotate(5deg);
  }
}

.header-glow {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 300px;
  height: 300px;
  background: radial-gradient(
    circle,
    rgba(255, 255, 255, 0.3) 0%,
    transparent 70%
  );
  border-radius: 50%;
  animation: pulse 3s ease-in-out infinite;
  z-index: -1;
}

@keyframes pulse {
  0%,
  100% {
    transform: translate(-50%, -50%) scale(1);
    opacity: 0.5;
  }
  50% {
    transform: translate(-50%, -50%) scale(1.2);
    opacity: 0.8;
  }
}

/* Login Card */
.login-card {
  position: relative;
  max-width: 500px;
  margin: 4rem auto;
  padding: 3rem 2rem;
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
  border-radius: 30px;
  color: white;
  text-align: center;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
  overflow: hidden;
  animation: cardSlideIn 0.8s ease-out;
  z-index: 1;
}

@keyframes cardSlideIn {
  from {
    opacity: 0;
    transform: translateY(50px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.login-icon {
  font-size: 4rem;
  margin-bottom: 1rem;
  animation: iconSpin 4s linear infinite;
}

@keyframes iconSpin {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}

.login-card h2 {
  font-size: 2rem;
  margin-bottom: 0.5rem;
  text-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
}

.login-card p {
  font-size: 1.1rem;
  opacity: 0.95;
  margin-bottom: 2rem;
}

.login-btn {
  margin-top: 1rem;
  background: linear-gradient(135deg, #fbbf24 0%, #f59e0b 100%);
  border: none;
  padding: 1rem 2.5rem;
  border-radius: 50px;
  font-weight: 700;
  font-size: 1.1rem;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 8px 20px rgba(245, 158, 11, 0.4);
  position: relative;
  overflow: hidden;
}

.login-btn::before {
  content: "";
  position: absolute;
  top: 50%;
  left: 50%;
  width: 0;
  height: 0;
  background: rgba(255, 255, 255, 0.3);
  border-radius: 50%;
  transform: translate(-50%, -50%);
  transition: width 0.6s, height 0.6s;
}

.login-btn:hover::before {
  width: 300px;
  height: 300px;
}

.login-btn:hover {
  transform: translateY(-3px);
  box-shadow: 0 12px 30px rgba(245, 158, 11, 0.6);
}

.login-particles {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  overflow: hidden;
  z-index: -1;
}

.particle {
  position: absolute;
  width: 20px;
  height: 20px;
  background: rgba(255, 255, 255, 0.3);
  border-radius: 50%;
  animation: particleFloat 10s infinite;
}

.particle:nth-child(1) {
  left: 10%;
  animation-delay: 0s;
}

.particle:nth-child(2) {
  left: 50%;
  animation-delay: 3s;
}

.particle:nth-child(3) {
  left: 80%;
  animation-delay: 6s;
}

@keyframes particleFloat {
  0% {
    bottom: -20px;
    opacity: 0;
  }
  10% {
    opacity: 1;
  }
  90% {
    opacity: 1;
  }
  100% {
    bottom: 110%;
    opacity: 0;
  }
}

/* Main Content */
.main-content {
  position: relative;
  z-index: 1;
  max-width: 1400px;
  margin: 0 auto;
}

.section-header {
  text-align: center;
  margin-bottom: 2rem;
}

.section-header h2 {
  font-size: 2rem;
  color: white;
  margin-bottom: 0.5rem;
  text-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
}

.subtitle {
  color: rgba(255, 255, 255, 0.9);
  font-size: 1rem;
  font-weight: 400;
}

/* Goals Section */
.goals-section {
  margin-bottom: 3rem;
  animation: fadeInUp 0.6s ease-out;
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.goal-cards {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  gap: 2rem;
  margin-bottom: 2rem;
}

.goal-card {
  position: relative;
  background: white;
  border-radius: 25px;
  padding: 2rem;
  width: 300px;
  text-align: center;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15);
  transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
  overflow: hidden;
}

.goal-card:hover {
  transform: translateY(-15px) scale(1.02);
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.25);
}

.calories-card {
  background: linear-gradient(135deg, #ff9a9e 0%, #fad0c4 100%);
}

.workouts-card {
  background: linear-gradient(135deg, #a1c4fd 0%, #c2e9fb 100%);
}

.card-icon {
  font-size: 3rem;
  margin-bottom: 1rem;
  animation: iconBounce 2s ease-in-out infinite;
}

@keyframes iconBounce {
  0%,
  100% {
    transform: scale(1);
  }
  50% {
    transform: scale(1.2);
  }
}

.goal-card h3 {
  font-size: 1.5rem;
  color: #1f2937;
  margin-bottom: 1rem;
  font-weight: 700;
}

.input-wrapper {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  margin-bottom: 1rem;
}

.input-wrapper input {
  width: 100px;
  padding: 0.8rem;
  border-radius: 15px;
  border: 3px solid rgba(255, 255, 255, 0.8);
  background: rgba(255, 255, 255, 0.9);
  font-size: 1.2rem;
  font-weight: 700;
  text-align: center;
  transition: all 0.3s ease;
}

.input-wrapper input:focus {
  outline: none;
  border-color: #667eea;
  transform: scale(1.05);
  box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
}

.unit {
  font-weight: 600;
  color: #1f2937;
  font-size: 0.9rem;
}

.progress-info {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1rem;
  padding: 0 1rem;
}

.progress-text {
  font-size: 0.9rem;
  color: #4b5563;
  font-weight: 600;
}

.progress-value {
  font-size: 1.5rem;
  color: #1f2937;
  font-weight: 800;
}

.card-shimmer {
  position: absolute;
  top: -50%;
  left: -50%;
  width: 200%;
  height: 200%;
  background: linear-gradient(
    45deg,
    transparent 30%,
    rgba(255, 255, 255, 0.3) 50%,
    transparent 70%
  );
  animation: shimmer 3s infinite;
  pointer-events: none;
}

@keyframes shimmer {
  0% {
    transform: translateX(-100%) translateY(-100%) rotate(45deg);
  }
  100% {
    transform: translateX(100%) translateY(100%) rotate(45deg);
  }
}

.save-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  margin: 0 auto;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border: none;
  padding: 1rem 3rem;
  border-radius: 50px;
  cursor: pointer;
  font-weight: 700;
  font-size: 1.1rem;
  transition: all 0.3s ease;
  box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
  position: relative;
  overflow: hidden;
}

.save-btn:hover {
  transform: translateY(-3px);
  box-shadow: 0 12px 35px rgba(102, 126, 234, 0.6);
}

.btn-icon {
  font-size: 1.3rem;
  animation: iconWiggle 1s ease-in-out infinite;
}

@keyframes iconWiggle {
  0%,
  100% {
    transform: rotate(0deg);
  }
  25% {
    transform: rotate(-10deg);
  }
  75% {
    transform: rotate(10deg);
  }
}

.btn-shine {
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(
    90deg,
    transparent,
    rgba(255, 255, 255, 0.3),
    transparent
  );
  transition: left 0.5s;
}

.save-btn:hover .btn-shine {
  left: 100%;
}

/* Bar Chart Section */
.bar-chart-section {
  margin: 3rem auto;
  max-width: 900px;
  background: white;
  border-radius: 30px;
  padding: 2rem;
  box-shadow: 0 15px 50px rgba(0, 0, 0, 0.15);
  animation: fadeInUp 0.8s ease-out 0.2s both;
}

.chart-container {
  background: linear-gradient(135deg, #ffecd2 0%, #fcb69f 100%);
  border-radius: 20px;
  padding: 1.5rem;
}

/* Log Section */
.log-section {
  margin: 3rem 0;
  animation: fadeInUp 0.8s ease-out 0.4s both;
}

.log-card {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  align-items: flex-end;
  gap: 1.5rem;
  padding: 2.5rem;
  background: linear-gradient(135deg, #fdeb71 0%, #f8d800 100%);
  border-radius: 30px;
  box-shadow: 0 15px 50px rgba(248, 216, 0, 0.3);
  transition: all 0.3s ease;
  max-width: 900px;
  margin: 0 auto;
}

.log-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 20px 60px rgba(248, 216, 0, 0.4);
}

.input-group {
  flex: 1;
  min-width: 200px;
}

.input-group label {
  display: block;
  font-weight: 700;
  color: #1f2937;
  margin-bottom: 0.5rem;
  font-size: 1rem;
}

.log-input {
  width: 100%;
  padding: 1rem;
  border-radius: 15px;
  border: 3px solid rgba(255, 255, 255, 0.8);
  background: white;
  font-size: 1rem;
  font-weight: 600;
  transition: all 0.3s ease;
}

.log-input:focus {
  outline: none;
  border-color: #667eea;
  transform: scale(1.02);
  box-shadow: 0 4px 20px rgba(102, 126, 234, 0.3);
}

.input-with-unit {
  position: relative;
  width: 100%;
}

.input-unit {
  position: absolute;
  right: 1rem;
  top: 50%;
  transform: translateY(-50%);
  font-weight: 700;
  color: #6b7280;
  pointer-events: none;
}

.add-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
  color: white;
  border: none;
  padding: 1rem 2.5rem;
  border-radius: 50px;
  cursor: pointer;
  font-weight: 700;
  font-size: 1.1rem;
  transition: all 0.3s ease;
  box-shadow: 0 8px 25px rgba(245, 87, 108, 0.4);
  position: relative;
  overflow: hidden;
  min-width: 200px;
}

.add-btn:hover {
  transform: translateY(-3px) scale(1.05);
  box-shadow: 0 12px 35px rgba(245, 87, 108, 0.6);
}

.btn-ripple {
  position: absolute;
  width: 100%;
  height: 100%;
  top: 0;
  left: 0;
  background: radial-gradient(
    circle,
    rgba(255, 255, 255, 0.3) 0%,
    transparent 70%
  );
  transform: scale(0);
  opacity: 0;
}

.add-btn:active .btn-ripple {
  animation: ripple 0.6s ease-out;
}

@keyframes ripple {
  to {
    transform: scale(2.5);
    opacity: 0;
  }
}

/* History Section */
.history-section {
  margin: 3rem 0;
  animation: fadeInUp 0.8s ease-out 0.6s both;
}

.history-cards {
  display: flex;
  flex-direction: column;
  gap: 1rem;
  max-width: 1000px;
  margin: 0 auto;
}

.history-card {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 1.5rem;
  border-radius: 20px;
  background: white;
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.1);
  transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
  position: relative;
  overflow: hidden;
}

.history-card::before {
  content: "";
  position: absolute;
  left: 0;
  top: 0;
  height: 100%;
  width: 5px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  transition: width 0.3s ease;
}

.history-card:hover::before {
  width: 100%;
  opacity: 0.1;
}

.history-card:hover {
  transform: translateX(10px) scale(1.02);
  box-shadow: 0 12px 40px rgba(0, 0, 0, 0.15);
}

.card-badge {
  font-size: 2.5rem;
  margin-right: 1.5rem;
  animation: badgePulse 2s ease-in-out infinite;
}

@keyframes badgePulse {
  0%,
  100% {
    transform: scale(1);
  }
  50% {
    transform: scale(1.15);
  }
}

.history-content {
  flex: 1;
}

.history-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 0.8rem;
}

.workout-type {
  font-weight: 700;
  font-size: 1.2rem;
  color: #1f2937;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.date {
  font-size: 0.9rem;
  color: #6b7280;
  font-weight: 600;
  background: #f3f4f6;
  padding: 0.3rem 0.8rem;
  border-radius: 20px;
}

.history-details {
  display: flex;
  gap: 1.5rem;
}

.detail-item {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
  padding: 0.5rem 1rem;
  border-radius: 15px;
  transition: all 0.3s ease;
}

.detail-item:hover {
  transform: scale(1.05);
  box-shadow: 0 4px 15px rgba(251, 191, 36, 0.3);
}

.detail-icon {
  font-size: 1.2rem;
}

.detail-value {
  font-weight: 700;
  color: #1f2937;
  font-size: 1rem;
}

.mini-chart {
  margin-left: 1rem;
}

/* Empty State */
.empty-state {
  text-align: center;
  padding: 4rem 2rem;
  background: white;
  border-radius: 30px;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
  max-width: 600px;
  margin: 0 auto;
}

.empty-icon {
  font-size: 5rem;
  margin-bottom: 1rem;
  animation: emptyIconMove 3s ease-in-out infinite;
}

@keyframes emptyIconMove {
  0%,
  100% {
    transform: translateX(0);
  }
  25% {
    transform: translateX(-20px);
  }
  75% {
    transform: translateX(20px);
  }
}

.empty-text {
  font-size: 1.5rem;
  font-weight: 700;
  color: #1f2937;
  margin-bottom: 0.5rem;
}

.empty-subtext {
  font-size: 1.1rem;
  color: #6b7280;
}

/* Workout Transitions */
.workout-enter-active {
  animation: workoutSlideIn 0.5s ease-out;
}

.workout-leave-active {
  animation: workoutSlideOut 0.3s ease-in;
}

@keyframes workoutSlideIn {
  from {
    opacity: 0;
    transform: translateX(-100px) rotateY(-90deg);
  }
  to {
    opacity: 1;
    transform: translateX(0) rotateY(0);
  }
}

@keyframes workoutSlideOut {
  from {
    opacity: 1;
    transform: scale(1);
  }
  to {
    opacity: 0;
    transform: scale(0.8);
  }
}

/* RESPONSIVE DESIGN */
@media (max-width: 1200px) {
  .fitness-page {
    padding: 1.5rem;
  }

  .main-content {
    max-width: 100%;
  }
}

@media (max-width: 900px) {
  .goal-cards {
    grid-template-columns: 1fr;
    max-width: 500px;
    margin: 0 auto;
  }

  .bar-chart-section,
  .workouts-section {
    max-width: 100%;
  }
}

@media (max-width: 768px) {
  .fitness-page {
    padding: 1rem;
  }

  .main-title {
    font-size: 2.5rem;
  }

  .section-header h2 {
    font-size: 1.8rem;
  }

  .subtitle {
    font-size: 0.9rem;
  }

  .goal-cards {
    flex-direction: column;
    align-items: center;
  }

  .goal-card {
    width: 100%;
    max-width: 350px;
  }

  .log-card {
    flex-direction: column;
    align-items: stretch;
    padding: 1.5rem;
  }

  .input-group {
    width: 100%;
  }

  .add-btn {
    width: 100%;
  }

  .history-list {
    gap: 1rem;
  }

  .history-card {
    flex-direction: column;
    text-align: center;
    padding: 1.5rem;
  }

  .card-badge {
    margin-right: 0;
    margin-bottom: 1rem;
  }

  .history-header {
    flex-direction: column;
    gap: 0.5rem;
    text-align: center;
  }

  .history-details {
    justify-content: center;
    flex-wrap: wrap;
  }

  .mini-chart {
    margin-left: 0;
    margin-top: 1rem;
  }

  .chart-container {
    padding: 1rem;
  }

  .save-btn {
    padding: 0.9rem 1.8rem;
    font-size: 1rem;
  }
}

@media (max-width: 480px) {
  .fitness-page {
    padding: 0.75rem;
  }

  .main-title {
    font-size: 2rem;
  }

  .emoji-float {
    font-size: 1.5rem;
  }

  .section-header h2 {
    font-size: 1.5rem;
  }

  .login-card {
    padding: 2rem 1.5rem;
  }

  .login-card h2 {
    font-size: 1.5rem;
  }

  .login-card p {
    font-size: 0.9rem;
  }

  .goal-card {
    padding: 1.5rem;
  }

  .goal-card h3 {
    font-size: 1.1rem;
  }

  .input-wrapper input {
    font-size: 1.5rem;
    padding: 0.6rem;
  }

  .log-card {
    padding: 1.2rem;
  }

  .log-card h3 {
    font-size: 1.1rem;
  }

  .input-group input,
  .input-group select {
    font-size: 0.9rem;
    padding: 0.7rem;
  }

  .add-btn {
    padding: 0.7rem;
    font-size: 0.9rem;
  }

  .history-card {
    padding: 1.2rem;
  }

  .history-header h3 {
    font-size: 1rem;
  }

  .history-stat {
    font-size: 0.8rem;
  }

  .delete-btn {
    padding: 0.4rem 0.8rem;
    font-size: 0.8rem;
  }

  .save-btn {
    padding: 0.8rem 1.5rem;
    font-size: 0.9rem;
  }

  .chart-container {
    padding: 0.75rem;
  }
}

/* Smooth Scrolling */
html {
  scroll-behavior: smooth;
}

/* Selection Color */
::selection {
  background: #fbbf24;
  color: white;
}

/* Custom Scrollbar */
::-webkit-scrollbar {
  width: 12px;
}

::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 10px;
}

::-webkit-scrollbar-thumb {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 10px;
}

::-webkit-scrollbar-thumb:hover {
  background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
}
</style>
