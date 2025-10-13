<template>
  <div class="home-page">
    <!-- NAVBAR -->
    <Navbar />

    <!-- HERO SECTION -->
    <section class="hero">
      <div class="hero-text">
        <h2>Track Your Calories Easily</h2>
        <p>
          SmartCal makes logging meals, tracking macros, and achieving your
          health goals simple, fun, and visual. Start building healthier habits
          today!
        </p>
        <button @click="$router.push('/log')">Get Started</button>
      </div>
      <div class="hero-img">
        <img
          src="https://cdn-icons-png.flaticon.com/512/3075/3075977.png"
          alt="Healthy food"
          class="hero-image"
        />
      </div>
    </section>

    <!-- FEATURES SECTION -->
    <section class="features" id="features">
      <div class="card">
        <img
          src="https://cdn-icons-png.flaticon.com/512/1046/1046784.png"
          alt="Food logging"
        />
        <h3>Easy Food Logging</h3>
        <p>Log your meals quickly, using common foods or your own recipes.</p>
      </div>

      <div class="card">
        <img
          src="https://cdn-icons-png.flaticon.com/512/1046/1046790.png"
          alt="Progress"
        />
        <h3>Visual Progress</h3>
        <p>
          See your weekly calorie and macronutrient breakdown in clear charts.
        </p>
      </div>

      <div class="card">
        <img
          src="https://cdn-icons-png.flaticon.com/512/1046/1046786.png"
          alt="Goal setting"
        />
        <h3>Set Goals</h3>
        <p>
          Stay on track with personalized weekly calorie and nutrition goals.
        </p>
      </div>

      <div class="card">
        <img
          src="https://cdn-icons-png.flaticon.com/512/1046/1046796.png"
          alt="Secure accounts"
        />
        <h3>Secure Accounts</h3>
        <p>
          All your logs and progress are safely stored and accessible anytime.
        </p>
      </div>
    </section>

    <!-- FOOTER -->
    <footer>&copy; 2025 SmartCal. All rights reserved.</footer>
  </div>
</template>

<script setup>
import Navbar from "../components/Navbar.vue";
</script>

<style src="../assets/index.css"></style>
