<template>
  <div class="gamification-dashboard-page">
    <Navbar />

    <div class="dashboard">
      <header class="dashboard-header">
        <h1>🏆 Gamification Dashboard</h1>
        <p>Track your achievements, points, and challenges</p>
      </header>

      <!-- Tabs -->
      <div class="tabs">
        <button :class="{ active: activeTab === 'overview' }" @click="activeTab='overview'">📊 Overview</button>
        <button :class="{ active: activeTab === 'challenges' }" @click="activeTab='challenges'">🎯 Challenges</button>
        <button :class="{ active: activeTab === 'achievements' }" @click="activeTab='achievements'">🏅 Achievements</button>
        <button :class="{ active: activeTab === 'leaderboard' }" @click="activeTab='leaderboard'">🏁 Leaderboard</button>
      </div>

      <!-- Overview Tab -->
      <div v-show="activeTab==='overview'" class="tab-content">
        <div class="overview-cards">
          <div class="card">
            <h3>Points</h3>
            <p>{{ userPoints }}</p>
          </div>
          <div class="card">
            <h3>Level</h3>
            <p>{{ userLevel }}</p>
            <progress :value="userXP" :max="xpForNextLevel"></progress>
            <span>{{ userXP }}/{{ xpForNextLevel }} XP</span>
          </div>
          <div class="card">
            <h3>Badges</h3>
            <p>{{ badges.length }}</p>
          </div>
          <div class="card">
            <h3>Daily Streak</h3>
            <p>🔥 {{ dailyStreak }} days</p>
          </div>
        </div>

        <!-- Chart: Points over last 7 days -->
        <div class="chart-section">
          <h3>Points Over Last 7 Days</h3>
          <canvas id="pointsChart"></canvas>
        </div>
      </div>

      <!-- Challenges Tab -->
      <div v-if="activeTab==='challenges'" class="tab-content">
        <div class="filter-row">
          <label>Filter by category:</label>
          <select v-model="challengeFilter">
            <option value="all">All</option>
            <option value="daily">Daily</option>
            <option value="weekly">Weekly</option>
            <option value="special">Special</option>
          </select>
        </div>

        <div class="challenges-grid">
          <div
            v-for="challenge in filteredChallenges"
            :key="challenge.id"
            class="challenge-card"
            :class="{ completed: challenge.progress === 100 }"
            @click="viewChallenge(challenge)"
          >
            <span class="category-badge" :class="challenge.category">{{ challenge.category.toUpperCase() }}</span>
            <h3>{{ challenge.name }}</h3>
            <p>{{ challenge.description }}</p>

            <div class="progress-wrapper">
              <div class="progress-bar" :class="{ completed: challenge.progress === 100 }" :style="{ width: challenge.progress + '%' }"></div>
            </div>
            <span class="progress-text">{{ challenge.progress }}% Complete</span>

            <div class="reward-section">
              <span class="reward-points">💰 {{ challenge.rewardPoints }} pts</span>
              <span class="reward-xp">⭐ {{ challenge.rewardXP }} XP</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Achievements Tab -->
      <div v-if="activeTab==='achievements'" class="tab-content">
        <h2>🏅 Achievements</h2>
        <div class="achievements-grid">
          <div
            v-for="achievement in achievements"
            :key="achievement.id"
            class="achievement-card"
            :class="{ unlocked: achievement.unlocked }"
            @click="viewAchievement(achievement)"
          >
            <h3>{{ achievement.title }}</h3>
            <p>{{ achievement.description }}</p>
            <small v-if="!achievement.unlocked">Unlock: {{ achievement.condition }}</small>
            <span class="status">{{ achievement.unlocked ? 'Unlocked' : 'Locked' }}</span>
          </div>
        </div>
      </div>

      <!-- Leaderboard Tab -->
      <div v-if="activeTab==='leaderboard'" class="tab-content">
        <h2>🏁 Leaderboard</h2>
        <div class="leaderboard-list">
          <div
            v-for="player in filteredLeaderboard"
            :key="player.id"
            class="leaderboard-item"
            :class="{ me: player.id === currentUser.id }"
          >
            <span>{{ player.rank }}. {{ player.name }}</span>
            <span>{{ player.points }} pts</span>
          </div>
        </div>
      </div>
    </div>

    <!-- Challenge Modal -->
    <div v-if="viewingChallenge" class="modal-overlay" @click="closeChallengeView">
      <div class="modal-content" @click.stop>
        <h2>{{ viewingChallenge.name }}</h2>
        <p>{{ viewingChallenge.description }}</p>
        <div class="challenge-progress">
          Progress: {{ viewingChallenge.progress }}%
        </div>
        <span>Reward: {{ viewingChallenge.rewardPoints }} pts | {{ viewingChallenge.rewardXP }} XP</span>
        <button @click="completeChallenge(viewingChallenge.id)" class="complete-btn">
          Complete Challenge
        </button>
        <button @click="closeChallengeView" class="close-btn">Close</button>
      </div>
    </div>

    <!-- Achievement Modal -->
    <div v-if="viewingAchievement" class="modal-overlay" @click="closeAchievementView">
      <div class="modal-content" @click.stop>
        <h2>{{ viewingAchievement.title }}</h2>
        <p>{{ viewingAchievement.description }}</p>
        <span class="status" :class="{ unlocked: viewingAchievement.unlocked }">
          {{ viewingAchievement.unlocked ? "Unlocked" : "Locked" }}
        </span>
        <button @click="closeAchievementView" class="close-btn">Close</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from "vue";
import Navbar from "@/components/Navbar.vue";
import Chart from "chart.js/auto";

// Tabs
const activeTab = ref("overview");

// Dummy Data & User
const currentUser = { id: 9, name: "You" };
const userPoints = ref(1200);
const userLevel = ref(5);
const userXP = ref(450);
const badges = ref(["Beginner", "Explorer"]);
const dailyStreak = ref(3);

// Challenges
const challengeFilter = ref("all");
const challenges = ref([
  // Daily
  { id: 1, name: "Daily Login", description: "Login 7 days in a row", category: "daily", progress: 40, rewardPoints: 50, rewardXP: 50 },
  { id: 2, name: "Complete 5 Tasks", description: "Finish 5 daily tasks", category: "daily", progress: 20, rewardPoints: 100, rewardXP: 80 },
  { id: 3, name: "Morning Stretch", description: "Spend 5 minutes stretching", category: "daily", progress: 0, rewardPoints: 30, rewardXP: 20 },
  { id: 4, name: "Water Tracker", description: "Drink 8 glasses of water", category: "daily", progress: 0, rewardPoints: 40, rewardXP: 25 },
  { id: 5, name: "Check Notifications", description: "Check all app notifications", category: "daily", progress: 0, rewardPoints: 20, rewardXP: 15 },

  // Weekly
  { id: 6, name: "Weekly Marathon", description: "Complete 20 tasks this week", category: "weekly", progress: 50, rewardPoints: 300, rewardXP: 200 },
  { id: 7, name: "Weekly Social", description: "Share your progress on social media", category: "weekly", progress: 0, rewardPoints: 150, rewardXP: 120 },
  { id: 8, name: "Skill Builder", description: "Learn something new this week", category: "weekly", progress: 0, rewardPoints: 200, rewardXP: 150 },
  { id: 9, name: "Weekly Reflection", description: "Write a short reflection about your week", category: "weekly", progress: 0, rewardPoints: 100, rewardXP: 80 },

  // Special
  { id: 10, name: "Holiday Challenge", description: "Complete a festive activity", category: "special", progress: 0, rewardPoints: 500, rewardXP: 300 },
  { id: 11, name: "Monthly Master", description: "Achieve 90% of all weekly goals this month", category: "special", progress: 0, rewardPoints: 600, rewardXP: 400 },
  { id: 12, name: "Community Helper", description: "Help another user complete a challenge", category: "special", progress: 0, rewardPoints: 400, rewardXP: 250 },
  { id: 13, name: "Fitness Fanatic", description: "Complete a full workout session", category: "special", progress: 0, rewardPoints: 350, rewardXP: 220 },
  { id: 14, name: "Eco Warrior", description: "Complete an environmentally friendly task", category: "special", progress: 0, rewardPoints: 300, rewardXP: 200 },
]);

const filteredChallenges = computed(() => {
  if (challengeFilter.value === "all") return challenges.value;
  return challenges.value.filter(c => c.category === challengeFilter.value);
});

// Achievements
const achievements = ref([
  { id: 1, title: "First Steps", description: "Complete your first challenge", condition: "Complete any challenge", unlocked: true },
  { id: 2, title: "Task Master", description: "Complete 50 tasks", condition: "Complete 50 tasks", unlocked: false },
  { id: 3, title: "Streak Keeper", description: "Maintain a 7-day streak", condition: "Login 7 days consecutively", unlocked: false },

  // New Achievements
  { id: 4, title: "Daily Devotee", description: "Complete 5 daily challenges", condition: "Finish 5 daily challenges", unlocked: false },
  { id: 5, title: "Weekly Warrior", description: "Complete 3 weekly challenges", condition: "Finish 3 weekly challenges", unlocked: false },
  { id: 6, title: "Specialist", description: "Complete 2 special challenges", condition: "Finish 2 special challenges", unlocked: false },
  { id: 7, title: "Hydration Hero", description: "Complete the Water Tracker challenge 7 times", condition: "Drink 8 glasses daily for a week", unlocked: false },
  { id: 8, title: "Early Bird", description: "Complete a challenge before 8 AM", condition: "Finish a morning challenge", unlocked: false },
  { id: 9, title: "Social Butterfly", description: "Share your progress 5 times", condition: "Share achievements or challenges on social media", unlocked: false },
  { id: 10, title: "Level Up!", description: "Reach level 10", condition: "Earn enough XP to reach level 10", unlocked: false },
  { id: 11, title: "Explorer", description: "Complete challenges in all categories", condition: "Finish at least one daily, weekly, and special challenge", unlocked: false },
  { id: 12, title: "Marathoner", description: "Complete 20 challenges in total", condition: "Finish 20 challenges", unlocked: false },
  { id: 13, title: "Eco Warrior", description: "Complete all environmentally-friendly challenges", condition: "Finish all eco-related challenges", unlocked: false },
  { id: 14, title: "Community Helper", description: "Assist other players in challenges", condition: "Help other users complete challenges", unlocked: false },
  { id: 15, title: "Ultimate Gamer", description: "Complete every achievement", condition: "Unlock all achievements", unlocked: false },
]);


// Leaderboard
const leaderboard = ref([
  { id: 1, rank: 1, name: "Alice", points: 2500 },
  { id: 2, rank: 2, name: "Bob", points: 2100 },
  { id: 3, rank: 3, name: "Charlie", points: 1800 },
  { id: 4, rank: 4, name: "Diana", points: 1600 },
  { id: 5, rank: 5, name: "Ethan", points: 1400 },
  { id: 6, rank: 6, name: "Fiona", points: 1300 },
  { id: 7, rank: 7, name: "George", points: 1250 },
  { id: 8, rank: 8, name: "Hannah", points: 1200 },
  { id: 9, rank: 9, name: "You", points: userPoints.value }, // current user
  { id: 10, rank: 10, name: "Ian", points: 1100 },
  { id: 11, rank: 11, name: "Jane", points: 1000 },
  { id: 12, rank: 12, name: "Kevin", points: 950 },
  { id: 13, rank: 13, name: "Lily", points: 900 },
  { id: 14, rank: 14, name: "Mike", points: 850 },
  { id: 15, rank: 15, name: "Nina", points: 800 },
]);

const filteredLeaderboard = computed(() => leaderboard.value);

// Modals
const viewingChallenge = ref(null);
const viewingAchievement = ref(null);

const viewChallenge = (c) => viewingChallenge.value = c;
const closeChallengeView = () => viewingChallenge.value = null;
const viewAchievement = (a) => viewingAchievement.value = a;
const closeAchievementView = () => viewingAchievement.value = null;

// Level XP calculation
const xpForNextLevel = computed(() => 500 * userLevel.value);

// Complete Challenge
const completeChallenge = (id) => {
  const ch = challenges.value.find(c => c.id === id);
  if (ch && ch.progress < 100) {
    ch.progress = 100;
    userPoints.value += ch.rewardPoints;
    userXP.value += ch.rewardXP;

    // Level up
    if (userXP.value >= xpForNextLevel.value) {
      userLevel.value++;
      userXP.value -= xpForNextLevel.value;
      alert(`🎉 Level Up! You are now level ${userLevel.value}`);
    }

    // Unlock achievements automatically
    achievements.value.forEach(a => {
      if (!a.unlocked) {
        if (a.id === 2 && userPoints.value >= 500) a.unlocked = true;
        if (a.id === 3 && dailyStreak.value >= 7) a.unlocked = true;
      }
    });

    alert(`Challenge "${ch.name}" completed! 🎉`);
  }
};

// Chart
onMounted(() => {
  const ctx = document.getElementById("pointsChart").getContext("2d");
  new Chart(ctx, {
    type: "line",
    data: {
      labels: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
      datasets: [{
        label: "Points",
        data: [50, 75, 100, 120, 80, 90, userPoints.value],
        borderColor: "#3498db",
        backgroundColor: "rgba(52,152,219,0.2)",
        tension: 0.3
      }]
    },
    options: {
      responsive: true,
      plugins: { legend: { display: false } },
      scales: { y: { beginAtZero: true } }
    }
  });
});
</script>

<style scoped>
.gamification-dashboard-page { 
  min-height: 100vh; 
  background: linear-gradient(135deg,#f5f7fa,#c3cfe2); 
  padding: 2rem; 
  font-family:"Poppins",sans-serif; 
}
.dashboard { max-width: 1400px; margin:0 auto; }
.dashboard-header { text-align:center; margin-bottom:2rem; }
.dashboard-header h1 { font-size:2.5rem; margin-bottom:0.5rem; color:#2c3e50; }
.dashboard-header p { color:#7f8c8d; }

.tabs { display:flex; justify-content:center; gap:1rem; margin-bottom:2rem; }
.tabs button { padding:0.75rem 1.5rem; border:none; border-radius:10px; cursor:pointer; background:#ecf0f1; color:#2c3e50; font-weight:500; }
.tabs button.active { background:#3498db; color:white; }

.tab-content { display:block; }
.overview-cards { display:grid; grid-template-columns:repeat(auto-fit,minmax(200px,1fr)); gap:1rem; margin-bottom:2rem; }

/* Overview Card Colors */
.card { 
  background:white; 
  padding:1rem 1.5rem; 
  border-radius:15px; 
  text-align:center; 
  box-shadow:0 4px 8px rgba(0,0,0,0.1); 
  color: #2c3e50; 
}
.card h3, .card p, .card span { color: #2c3e50; }
.card progress { width:100%; height:1rem; border-radius:5px; margin-top:0.5rem; }

.filter-row { margin-bottom:1rem; display:flex; align-items:center; gap:1rem; }

/* Challenge Cards */
.challenges-grid { display:grid; grid-template-columns:repeat(auto-fit,minmax(220px,1fr)); gap:1rem; }
.challenge-card { background:white; padding:1rem; border-radius:15px; box-shadow:0 4px 8px rgba(0,0,0,0.1); cursor:pointer; transition: transform 0.2s; }
.challenge-card:hover { transform: translateY(-3px); }

.category-badge { display:inline-block; margin-bottom:0.5rem; padding:0.25rem 0.5rem; font-size:0.7rem; font-weight:600; border-radius:5px; background:#ecf0f1; color:#2c3e50; }

.progress-wrapper { width:100%; height:10px; background:#ecf0f1; border-radius:5px; overflow:hidden; margin:0.5rem 0; }
.progress-bar { height:100%; background:#3498db; transition: width 0.5s; border-radius:5px; }
.progress-bar.completed { background: linear-gradient(90deg, #27ae60, #2ecc71); box-shadow: 0 0 10px #2ecc71, 0 0 20px #27ae60; animation: pulse 1.5s infinite; }

@keyframes pulse {
  0% { box-shadow:0 0 10px #2ecc71,0 0 20px #27ae60; transform: scaleX(1); }
  50% { box-shadow:0 0 15px #2ecc71,0 0 30px #27ae60; transform: scaleX(1.02); }
  100% { box-shadow:0 0 10px #2ecc71,0 0 20px #27ae60; transform: scaleX(1); }
}

.challenge-card.completed { animation: bounce 0.5s ease; }
@keyframes bounce { 0% { transform: translateY(0); } 50% { transform: translateY(-5px); } 100% { transform: translateY(0); }
}
.progress-text { font-size:0.8rem; color:#7f8c8d; }
.reward-section { display:flex; justify-content:space-between; font-size:0.85rem; margin-top:0.5rem; }
.reward-points { color:#f39c12; font-weight:600; }
.reward-xp { color:#3498db; font-weight:600; }

/* Achievements */
.achievements-grid { display:grid; grid-template-columns:repeat(auto-fit,minmax(220px,1fr)); gap:1rem; }
.achievement-card { background:white; padding:1rem; border-radius:15px; box-shadow:0 4px 8px rgba(0,0,0,0.1); cursor:pointer; }
.achievement-card.unlocked { border:2px solid #27ae60; }
.achievement-card small { display:block; margin-bottom:0.5rem; color:#7f8c8d; }
.status { font-weight:600; margin-top:0.5rem; display:block; }
.status.unlocked { color:#27ae60; }

/* Leaderboard */
.leaderboard-list { display:flex; flex-direction:column; gap:0.5rem; }
.leaderboard-item { display:flex; justify-content:space-between; padding:0.5rem 1rem; background:white; border-radius:10px; box-shadow:0 2px 5px rgba(0,0,0,0.1); }
.leaderboard-item.me { background:#f1c40f; color:white; font-weight:600; }

/* Modals */
.modal-overlay { position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.6); display:flex; justify-content:center; align-items:center; z-index:1000; padding:2rem; }
.modal-content { background:white; padding:2rem; border-radius:20px; max-width:500px; width:100%; }
.close-btn, .complete-btn { margin-top:1rem; width:100%; padding:0.75rem; border:none; border-radius:10px; cursor:pointer; font-weight:600; }
.close-btn { background:#95a5a6; color:white; }
.complete-btn { background:#27ae60; color:white; }

/* Chart Section */
.chart-section { background:white; padding:1rem; border-radius:15px; box-shadow:0 4px 8px rgba(0,0,0,0.1); margin-top:2rem; color:#2c3e50; }
.chart-section h3 { color:#2c3e50; }
</style>
