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
            :class="{ me: player.id === userState.user?.id }"
          >
            <span>{{ player.rank }}. {{ player.name }} {{ player.id === userState.user?.id ? '(You)' : '' }}</span>
            <span>{{ player.points }} pts - Lv. {{ player.level }}</span>
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
import { supabase } from "@/supabase";
import { userState } from "@/state/userState";

// Tabs
const activeTab = ref("overview");

// User Data - fetched from Supabase
const currentUser = computed(() => ({
  id: userState.user?.id,
  name: userState.user?.email?.split('@')[0] || "You"
}));
const userPoints = ref(0);
const userLevel = ref(1);
const userXP = ref(0);
const badges = ref([]);
const dailyStreak = ref(0);
const totalMealsLogged = ref(0);

// Challenges
const challengeFilter = ref("all");
const challenges = ref([]);
const userChallenges = ref([]);

const filteredChallenges = computed(() => {
  if (challengeFilter.value === "all") return challenges.value;
  return challenges.value.filter(c => c.category === challengeFilter.value);
});

// Achievements
const achievements = ref([]);
const unlockedAchievements = ref([]);

// Leaderboard
const leaderboard = ref([]);
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

// Fetch user stats from Supabase
const fetchUserStats = async () => {
  if (!userState.user) return;

  const { data, error } = await supabase
    .from('user_stats')
    .select('*')
    .eq('user_id', userState.user.id)
    .single();

  if (error) {
    console.error('Error fetching user stats:', error);
    // Create initial stats if they don't exist
    await initializeUserStats();
  } else if (data) {
    userPoints.value = data.total_points;
    userLevel.value = data.level;
    dailyStreak.value = data.current_streak;
    totalMealsLogged.value = data.total_meals_logged;
    
    // Calculate XP (simplified - you can adjust this formula)
    userXP.value = data.total_points % (500 * data.level);
  }
};

// Initialize user stats for new users
const initializeUserStats = async () => {
  if (!userState.user) return;

  const { error } = await supabase
    .from('user_stats')
    .insert([{
      user_id: userState.user.id,
      total_points: 0,
      level: 1,
      current_streak: 0,
      longest_streak: 0,
      total_meals_logged: 0
    }]);

  if (!error) {
    userPoints.value = 0;
    userLevel.value = 1;
    dailyStreak.value = 0;
    totalMealsLogged.value = 0;
  }
};

// Fetch all achievements
const fetchAchievements = async () => {
  const { data, error } = await supabase
    .from('achievements')
    .select('*')
    .order('id');

  if (!error && data) {
    // Fetch user's unlocked achievements
    const { data: userAchievements } = await supabase
      .from('user_achievements')
      .select('achievement_id, unlocked_at')
      .eq('user_id', userState.user?.id);

    const unlockedIds = new Set(userAchievements?.map(ua => ua.achievement_id) || []);

    achievements.value = data.map(achievement => ({
      id: achievement.id,
      title: achievement.name,
      description: achievement.description,
      condition: achievement.requirement,
      unlocked: unlockedIds.has(achievement.id),
      icon: achievement.icon || '🏅'
    }));

    badges.value = achievements.value.filter(a => a.unlocked).map(a => a.title);
  }
};

// Fetch challenges and user progress
const fetchChallenges = async () => {
  const { data, error } = await supabase
    .from('challenges')
    .select('*')
    .order('id');

  if (!error && data) {
    // Fetch user challenge progress
    const { data: userChallengeData } = await supabase
      .from('user_challenges')
      .select('*')
      .eq('user_id', userState.user?.id);

    const userProgressMap = new Map(
      userChallengeData?.map(uc => [uc.challenge_id, uc]) || []
    );

    challenges.value = data.map(challenge => {
      const userProgress = userProgressMap.get(challenge.id);
      const progress = userProgress 
        ? Math.min(100, Math.round((userProgress.current_progress / challenge.target_value) * 100))
        : 0;

      return {
        id: challenge.id,
        name: challenge.name,
        description: challenge.description,
        category: challenge.challenge_type,
        progress: progress,
        rewardPoints: challenge.reward_points,
        rewardXP: challenge.reward_points, // Using points as XP
        isCompleted: userProgress?.is_completed || false,
        currentProgress: userProgress?.current_progress || 0,
        targetValue: challenge.target_value
      };
    });
  }
};

// Fetch leaderboard
const fetchLeaderboard = async () => {
  const { data, error } = await supabase
    .from('user_stats')
    .select(`
      user_id,
      total_points,
      level,
      users:user_id (email)
    `)
    .order('total_points', { ascending: false })
    .limit(20);

  if (!error && data) {
    leaderboard.value = data.map((entry, index) => ({
      id: entry.user_id,
      rank: index + 1,
      name: entry.users?.email?.split('@')[0] || 'User',
      points: entry.total_points,
      level: entry.level
    }));
  }
};

// Complete Challenge
const completeChallenge = async (id) => {
  const ch = challenges.value.find(c => c.id === id);
  if (!ch || ch.isCompleted) {
    alert('Challenge already completed or not found!');
    return;
  }

  // Update user_challenges
  const { error: challengeError } = await supabase
    .from('user_challenges')
    .upsert({
      user_id: userState.user.id,
      challenge_id: ch.id,
      current_progress: ch.targetValue,
      is_completed: true,
      completed_at: new Date().toISOString()
    });

  if (challengeError) {
    console.error('Error completing challenge:', challengeError);
    alert('Failed to complete challenge');
    return;
  }

  // Update user_stats points
  const { error: statsError } = await supabase
    .from('user_stats')
    .update({
      total_points: userPoints.value + ch.rewardPoints
    })
    .eq('user_id', userState.user.id);

  if (!statsError) {
    ch.progress = 100;
    ch.isCompleted = true;
    userPoints.value += ch.rewardPoints;
    userXP.value += ch.rewardXP;

    // Level up logic
    if (userXP.value >= xpForNextLevel.value) {
      userLevel.value++;
      userXP.value -= xpForNextLevel.value;
      
      await supabase
        .from('user_stats')
        .update({ level: userLevel.value })
        .eq('user_id', userState.user.id);

      alert(`🎉 Level Up! You are now level ${userLevel.value}`);
    }

    // Check for new achievements
    await checkAndUnlockAchievements();

    alert(`Challenge "${ch.name}" completed! 🎉`);
    closeChallengeView();
    
    // Refresh data
    await fetchUserStats();
    await fetchChallenges();
  }
};

// Check and unlock achievements
const checkAndUnlockAchievements = async () => {
  // Fetch current stats
  await fetchUserStats();

  for (const achievement of achievements.value) {
    if (achievement.unlocked) continue;

    let shouldUnlock = false;

    // Check achievement conditions
    switch (achievement.id) {
      case 1: // First Steps - Log 1 meal
        shouldUnlock = totalMealsLogged.value >= 1;
        break;
      case 2: // Week Warrior - 7 day streak
        shouldUnlock = dailyStreak.value >= 7;
        break;
      case 3: // Month Master - 30 day streak
        shouldUnlock = dailyStreak.value >= 30;
        break;
      case 4: // Century Club - 100 meals
        shouldUnlock = totalMealsLogged.value >= 100;
        break;
      case 5: // Consistency King - 50 day streak
        shouldUnlock = dailyStreak.value >= 50;
        break;
      case 6: // Nutrition Ninja - 500 meals
        shouldUnlock = totalMealsLogged.value >= 500;
        break;
    }

    if (shouldUnlock) {
      const { error } = await supabase
        .from('user_achievements')
        .insert({
          user_id: userState.user.id,
          achievement_id: achievement.id
        });

      if (!error) {
        achievement.unlocked = true;
        badges.value.push(achievement.title);
        alert(`🏆 Achievement Unlocked: ${achievement.title}!`);
      }
    }
  }
};

// Chart
onMounted(async () => {
  // Fetch all data
  await fetchUserStats();
  await fetchAchievements();
  await fetchChallenges();
  await fetchLeaderboard();

  // Initialize chart
  const ctx = document.getElementById("pointsChart")?.getContext("2d");
  if (ctx) {
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
  }
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
