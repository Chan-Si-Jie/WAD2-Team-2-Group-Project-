<template>
  <div>
    <Navbar />
    
    <div class="gamification-dashboard-page">
      <div class="dashboard">
        <header class="dashboard-header">
          <h1>🏆 Gamification Dashboard</h1>
          <p>Track your achievements, points, and challenges</p>
          <button @click="refreshAllData" class="refresh-btn">🔄 Refresh Stats</button>
        </header>

      <!-- Tabs -->
      <div class="tabs">
        <button
          :class="{ active: activeTab === 'overview' }"
          @click="activeTab = 'overview'"
        >
          📊 Overview
        </button>
      </div>

      <!-- Overview Tab -->
      <div v-show="activeTab === 'overview'" class="tab-content">
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
            <h3>Daily Streak</h3>
            <p>🔥 {{ dailyStreak }} days</p>
          </div>
          <div class="card">
            <h3>Total Meals</h3>
            <p>🍽️ {{ totalMealsLogged }}</p>
          </div>
        </div>
      </div>
    </div>

    <!-- Challenge Modal -->
    <div
      v-if="viewingChallenge"
      class="modal-overlay"
      @click="closeChallengeView"
    >
      <div class="modal-content" @click.stop>
        <h2>{{ viewingChallenge.name }}</h2>
        <p>{{ viewingChallenge.description }}</p>
        <div class="challenge-progress">
          Progress: {{ viewingChallenge.progress }}%
        </div>
        <span
          >Reward: {{ viewingChallenge.rewardPoints }} pts |
          {{ viewingChallenge.rewardXP }} XP</span
        >
        <button
          @click="completeChallenge(viewingChallenge.id)"
          class="complete-btn"
        >
          Complete Challenge
        </button>
        <button @click="closeChallengeView" class="close-btn">Close</button>
      </div>
    </div>

    <!-- Achievement Modal -->
    <div
      v-if="viewingAchievement"
      class="modal-overlay"
      @click="closeAchievementView"
    >
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
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from "vue";
import Navbar from "@/components/Navbar.vue";
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
  return challenges.value.filter((c) => c.category === challengeFilter.value);
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

const viewChallenge = (c) => (viewingChallenge.value = c);
const closeChallengeView = () => (viewingChallenge.value = null);
const viewAchievement = (a) => (viewingAchievement.value = a);
const closeAchievementView = () => (viewingAchievement.value = null);

// Level XP calculation - 100 points per level
const xpForNextLevel = computed(() => 100);

// Fetch user stats from Supabase
const fetchUserStats = async () => {
  if (!userState.user) {
    console.log('No user logged in');
    return;
  }

  console.log('Fetching stats for user:', userState.user.id);

  const { data, error } = await supabase
    .from('user_stats')
    .select('*')
    .eq('user_id', userState.user.id)
    .maybeSingle();

  if (error) {
    console.error('Error fetching user stats:', error);
    // Create initial stats if they don't exist
    await initializeUserStats();
  } else if (data) {
    console.log('✅ User stats loaded:', data);
    userPoints.value = data.points || 0;
    dailyStreak.value = data.current_streak || 0;
    totalMealsLogged.value = data.total_meals || 0;
    
    // Calculate level based on points (100 points per level)
    userLevel.value = Math.floor((data.points || 0) / 100) + 1;
    
    // Calculate XP (points within current level)
    userXP.value = (data.points || 0) % 100;
  } else {
    console.log('No stats found, initializing...');
    await initializeUserStats();
  }
};

// Initialize user stats for new users
const initializeUserStats = async () => {
  if (!userState.user) return;

  console.log('Initializing user stats for:', userState.user.id);

  const { data, error } = await supabase
    .from('user_stats')
    .insert([{
      user_id: userState.user.id,
      points: 0,
      current_streak: 0,
      longest_streak: 0,
      total_meals: 0
    }])
    .select()
    .single();

  if (error) {
    console.error('Error initializing user stats:', error);
  } else {
    console.log('✅ User stats initialized:', data);
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

  if (error) {
    console.error('Error fetching achievements:', error);
    return;
  }

  if (!data) return;

  // Fetch user's unlocked achievements
  const { data: userAchievements, error: userAchError } = await supabase
    .from('user_achievements')
    .select('achievement_id, unlocked_at')
    .eq('user_id', userState.user?.id);

  if (userAchError) {
    console.error('Error fetching user achievements:', userAchError);
  }

  const unlockedIds = new Set(userAchievements?.map(ua => ua.achievement_id) || []);

  achievements.value = data.map(achievement => ({
    id: achievement.id,
    title: achievement.name,
    description: achievement.description,
    condition: achievement.description, // Use description since requirement doesn't exist
    unlocked: unlockedIds.has(achievement.id),
    icon: achievement.icon || '🏅'
  }));

  badges.value = achievements.value.filter(a => a.unlocked).map(a => a.title);
  console.log('✅ Achievements loaded:', achievements.value.length, 'total,', badges.value.length, 'unlocked');
};

// Fetch challenges and user progress
const fetchChallenges = async () => {
  const { data, error } = await supabase
    .from('challenges')
    .select('*')
    .order('id');

  if (error) {
    console.error('Error fetching challenges:', error);
    return;
  }

  if (!data) return;

  // Fetch user challenge progress
  const { data: userChallengeData, error: userChalError } = await supabase
    .from('user_challenges')
    .select('*')
    .eq('user_id', userState.user?.id);

  if (userChalError) {
    console.error('Error fetching user challenges:', userChalError);
  }

  const userProgressMap = new Map(
    userChallengeData?.map(uc => [uc.challenge_id, uc]) || []
  );

  challenges.value = data.map(challenge => {
    const userProgress = userProgressMap.get(challenge.id);
    const progress = userProgress 
      ? Math.min(100, Math.round((userProgress.current_progress / challenge.target_value) * 100))
      : 0;

    // Use reward_points from database
    const rewardPoints = challenge.reward_points || 100;

    return {
      id: challenge.id,
      name: challenge.name,
      description: challenge.description,
      category: challenge.challenge_type,
      progress: progress,
      rewardPoints: rewardPoints,
      rewardXP: rewardPoints,
      isCompleted: userProgress?.is_completed || false,
      currentProgress: userProgress?.current_progress || 0,
      targetValue: challenge.target_value
    };
  });

  console.log('✅ Challenges loaded:', challenges.value.length);
};

// Fetch leaderboard
const fetchLeaderboard = async () => {
  // Get all users with stats, sorted by points
  const { data: statsData, error: statsError } = await supabase
    .from('user_stats')
    .select('user_id, points, current_streak, total_meals')
    .order('points', { ascending: false })
    .limit(20);

  if (statsError) {
    console.error('Error fetching leaderboard stats:', statsError);
    // Fallback: create leaderboard with just current user if query fails
    if (userState.user?.id) {
      leaderboard.value = [{
        id: userState.user.id,
        name: 'You',
        points: userPoints.value || 0,
        level: userLevel.value || 1,
        streak: dailyStreak.value || 0,
        rank: 1
      }];
    } else {
      leaderboard.value = [];
    }
    return;
  }

  if (!statsData || statsData.length === 0) {
    console.log('No user stats found in database');
    // If no stats, show current user with 0 points
    if (userState.user?.id) {
      leaderboard.value = [{
        id: userState.user.id,
        name: 'You',
        points: 0,
        level: 1,
        streak: 0,
        rank: 1
      }];
    } else {
      leaderboard.value = [];
    }
    return;
  }

  // Build leaderboard with actual stats
  leaderboard.value = statsData.map((entry, index) => {
    const points = entry.points || 0;
    // Calculate level from points (100 points = level 1, 200 = level 2, etc.)
    const calculatedLevel = Math.floor(points / 100) + 1;
    
    return {
      id: entry.user_id,
      name: entry.user_id === userState.user?.id ? 'You' : `Player ${index + 2}`,
      points: points,
      level: calculatedLevel,
      streak: entry.current_streak || 0,
      rank: index + 1
    };
  });

  console.log('✅ Leaderboard loaded:', leaderboard.value.length, 'players');
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
      points: userPoints.value + ch.rewardPoints
    })
    .eq('user_id', userState.user.id);

  if (!statsError) {
    ch.progress = 100;
    ch.isCompleted = true;
    userPoints.value += ch.rewardPoints;
    userXP.value += ch.rewardXP;

    // Level up logic - recalculate level based on points
    const newLevel = Math.floor(userPoints.value / 100) + 1;
    if (newLevel > userLevel.value) {
      userLevel.value = newLevel;
      alert(`🎉 Level Up! You are now level ${userLevel.value}`);
    }
    
    // Recalculate XP within current level
    userXP.value = userPoints.value % 100;

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

  console.log('🏆 Checking achievements...', {
    totalMealsLogged: totalMealsLogged.value,
    dailyStreak: dailyStreak.value,
    achievements: achievements.value.length
  });

  for (const achievement of achievements.value) {
    if (achievement.unlocked) continue;

    let shouldUnlock = false;

    // Check achievement conditions by name (since IDs are UUIDs)
    switch (achievement.title) {
      case 'First Steps': // Log 1 meal
        shouldUnlock = totalMealsLogged.value >= 1;
        break;
      case 'Week Warrior': // 7 day streak
        shouldUnlock = dailyStreak.value >= 7;
        break;
      case 'Month Master': // 30 day streak
        shouldUnlock = dailyStreak.value >= 30;
        break;
      case 'Century Club': // 100 meals
        shouldUnlock = totalMealsLogged.value >= 100;
        break;
      case 'Consistency King': // 50 day streak
        shouldUnlock = dailyStreak.value >= 50;
        break;
      case 'Nutrition Ninja': // 500 meals
        shouldUnlock = totalMealsLogged.value >= 500;
        break;
    }

    console.log(`Checking achievement ${achievement.id} (${achievement.title}): ${shouldUnlock}`);

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
        console.log(`✅ Achievement unlocked: ${achievement.title}`);
        alert(`🏆 Achievement Unlocked: ${achievement.title}!`);
      } else {
        console.error('Error unlocking achievement:', error);
      }
    }
  }
};

// Refresh all data
const refreshAllData = async () => {
  console.log('🔄 Refreshing all data...');
  await fetchUserStats();
  await fetchAchievements();
  await fetchChallenges();
  await fetchLeaderboard();
  
  // Check for new achievements after fetching data
  await checkAndUnlockAchievements();
  
  console.log('✅ All data refreshed!');
};

// Chart removed - using simple card display instead

onMounted(async () => {
  console.log('🎮 Social Gamification component mounted');
  
  // Fetch all data
  await refreshAllData();
});
</script>

<style scoped>
.gamification-dashboard-page {
  min-height: 100vh;
  background: linear-gradient(135deg, #f5f7fa, #c3cfe2);
  padding: 2rem 2rem 2rem 2rem;
  font-family: "Poppins", sans-serif;
}
.dashboard {
  max-width: 1400px;
  margin: 0 auto;
}
.dashboard-header {
  text-align: center;
  margin-bottom: 2rem;
}
.dashboard-header h1 {
  font-size: 2.5rem;
  margin-bottom: 0.5rem;
  color: #2c3e50;
}
.dashboard-header p {
  color: #7f8c8d;
}
.dashboard { max-width: 1400px; margin:0 auto; }
.dashboard-header { text-align:center; margin-bottom:2rem; position: relative; }
.dashboard-header h1 { font-size:2.5rem; margin-bottom:0.5rem; color:#2c3e50; }
.dashboard-header p { color:#7f8c8d; }
.refresh-btn { 
  margin-top: 1rem;
  padding: 0.5rem 1.5rem; 
  border: none; 
  border-radius: 10px; 
  background: #3498db; 
  color: white; 
  font-weight: 600; 
  cursor: pointer; 
  transition: all 0.3s;
}
.refresh-btn:hover { 
  background: #2980b9; 
  transform: scale(1.05);
}

.tabs {
  display: flex;
  justify-content: center;
  gap: 1rem;
  margin-bottom: 2rem;
}
.tabs button {
  padding: 0.75rem 1.5rem;
  border: none;
  border-radius: 10px;
  cursor: pointer;
  background: #ecf0f1;
  color: #2c3e50;
  font-weight: 500;
}
.tabs button.active {
  background: #3498db;
  color: white;
}

.tab-content {
  display: block;
}
.overview-cards {
  display: flex;
  justify-content: center;
  gap: 2rem;
  margin-bottom: 2rem;
  flex-wrap: wrap;
}

/* Overview Card Colors */
.card {
  background: white;
  padding: 2rem 2.5rem;
  border-radius: 15px;
  text-align: center;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  color: #2c3e50;
  min-width: 220px;
}
.card h3,
.card p,
.card span {
  color: #2c3e50;
}
.card progress {
  width: 100%;
  height: 1rem;
  border-radius: 5px;
  margin-top: 0.5rem;
}

.filter-row {
  margin-bottom: 1rem;
  display: flex;
  align-items: center;
  gap: 1rem;
}

/* Challenge Cards */
.challenges-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
  gap: 1rem;
}
.challenge-card {
  background: white;
  padding: 1rem;
  border-radius: 15px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  cursor: pointer;
  transition: transform 0.2s;
}
.challenge-card:hover {
  transform: translateY(-3px);
}

.category-badge {
  display: inline-block;
  margin-bottom: 0.5rem;
  padding: 0.25rem 0.5rem;
  font-size: 0.7rem;
  font-weight: 600;
  border-radius: 5px;
  background: #ecf0f1;
  color: #2c3e50;
}

.progress-wrapper {
  width: 100%;
  height: 10px;
  background: #ecf0f1;
  border-radius: 5px;
  overflow: hidden;
  margin: 0.5rem 0;
}
.progress-bar {
  height: 100%;
  background: #3498db;
  transition: width 0.5s;
  border-radius: 5px;
}
.progress-bar.completed {
  background: linear-gradient(90deg, #27ae60, #2ecc71);
  box-shadow: 0 0 10px #2ecc71, 0 0 20px #27ae60;
  animation: pulse 1.5s infinite;
}

@keyframes pulse {
  0% {
    box-shadow: 0 0 10px #2ecc71, 0 0 20px #27ae60;
    transform: scaleX(1);
  }
  50% {
    box-shadow: 0 0 15px #2ecc71, 0 0 30px #27ae60;
    transform: scaleX(1.02);
  }
  100% {
    box-shadow: 0 0 10px #2ecc71, 0 0 20px #27ae60;
    transform: scaleX(1);
  }
}

.challenge-card.completed {
  animation: bounce 0.5s ease;
}
@keyframes bounce {
  0% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-5px);
  }
  100% {
    transform: translateY(0);
  }
}
.progress-text {
  font-size: 0.8rem;
  color: #7f8c8d;
}
.reward-section {
  display: flex;
  justify-content: space-between;
  font-size: 0.85rem;
  margin-top: 0.5rem;
}
.reward-points {
  color: #f39c12;
  font-weight: 600;
}
.reward-xp {
  color: #3498db;
  font-weight: 600;
}

/* Achievements */
.achievements-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
  gap: 1rem;
}
.achievement-card {
  background: white;
  padding: 1rem;
  border-radius: 15px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  cursor: pointer;
}
.achievement-card.unlocked {
  border: 2px solid #27ae60;
}
.achievement-card small {
  display: block;
  margin-bottom: 0.5rem;
  color: #7f8c8d;
}
.status {
  font-weight: 600;
  margin-top: 0.5rem;
  display: block;
}
.status.unlocked {
  color: #27ae60;
}

/* Leaderboard */
.leaderboard-list {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}
.leaderboard-item {
  display: flex;
  justify-content: space-between;
  padding: 0.5rem 1rem;
  background: white;
  border-radius: 10px;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}
.leaderboard-item.me {
  background: #f1c40f;
  color: white;
  font-weight: 600;
}

/* Modals */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.6);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
  padding: 2rem;
}
.modal-content {
  background: white;
  padding: 2rem;
  border-radius: 20px;
  max-width: 500px;
  width: 100%;
}
.close-btn,
.complete-btn {
  margin-top: 1rem;
  width: 100%;
  padding: 0.75rem;
  border: none;
  border-radius: 10px;
  cursor: pointer;
  font-weight: 600;
}
.close-btn {
  background: #95a5a6;
  color: white;
}
.complete-btn {
  background: #27ae60;
  color: white;
}

/* Chart Section - Removed */

/* RESPONSIVE DESIGN */
@media (max-width: 1200px) {
  .gamification-dashboard-page {
    padding: 1.5rem;
  }

  .dashboard {
    max-width: 100%;
  }

  .overview-cards {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 900px) {
  .overview-cards {
    grid-template-columns: repeat(2, 1fr);
    gap: 1rem;
  }

  .challenges-grid,
  .achievements-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 768px) {
  .gamification-dashboard-page {
    padding: 1rem;
  }

  .dashboard-header h1 {
    font-size: 1.8rem;
  }

  .dashboard-header p {
    font-size: 0.9rem;
  }

  .tabs {
    flex-wrap: wrap;
    gap: 0.5rem;
    justify-content: center;
  }

  .tabs button {
    padding: 0.6rem 1rem;
    font-size: 0.85rem;
    flex: 1 1 auto;
    min-width: 120px;
  }

  .overview-cards {
    grid-template-columns: 1fr;
    gap: 1rem;
  }

  .card {
    padding: 1.2rem;
  }

  .challenges-grid,
  .achievements-grid {
    grid-template-columns: 1fr;
    gap: 1rem;
  }

  .challenge-card,
  .achievement-card {
    padding: 1.2rem;
  }

  .filter-row {
    flex-direction: column;
    align-items: flex-start;
    gap: 0.5rem;
  }

  .filter-row select {
    width: 100%;
    max-width: 250px;
  }

  .leaderboard-item {
    flex-direction: column;
    align-items: flex-start;
    gap: 0.5rem;
    padding: 1rem;
  }

  .modal-content {
    width: 95%;
    max-width: 450px;
    padding: 1.5rem;
  }

  .refresh-btn {
    padding: 0.6rem 1.2rem;
    font-size: 0.9rem;
  }
}

@media (max-width: 480px) {
  .gamification-dashboard-page {
    padding: 0.5rem;
  }

  .dashboard-header h1 {
    font-size: 1.5rem;
  }

  .dashboard-header p {
    font-size: 0.85rem;
  }

  .tabs button {
    padding: 0.5rem 0.8rem;
    font-size: 0.8rem;
    min-width: 100px;
  }

  .card h3 {
    font-size: 1rem;
  }

  .card p {
    font-size: 1.3rem;
  }

  .challenge-card h3,
  .achievement-card h3 {
    font-size: 1rem;
  }

  .challenge-card p,
  .achievement-card p {
    font-size: 0.85rem;
  }

  .category-badge {
    font-size: 0.7rem;
    padding: 0.3rem 0.6rem;
  }

  .progress-text,
  .status {
    font-size: 0.8rem;
  }

  .reward-section {
    flex-direction: column;
    gap: 0.3rem;
  }

  .reward-points,
  .reward-xp {
    font-size: 0.8rem;
  }

  .leaderboard-item span {
    font-size: 0.85rem;
  }

  .modal-content {
    padding: 1rem;
  }

  .modal-content h2 {
    font-size: 1.3rem;
  }

  .close-btn,
  .complete-btn {
    padding: 0.6rem;
    font-size: 0.9rem;
  }
}
</style>
