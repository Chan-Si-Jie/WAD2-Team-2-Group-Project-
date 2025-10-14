<template>
  <div class="register-page">
    <div class="register-container">
      <!-- BACK BUTTON INSIDE CARD -->
      <div class="back-button" @click="$router.push('/login')">
        <img :src="backArrow" alt="Back" />
      </div>

      <h2>Create Account</h2>
      <p>Sign up to start tracking your calories and progress</p>

      <form @submit.prevent="register">
        <div class="input-group">
          <label for="name">Full Name</label>
          <input
            type="text"
            id="name"
            placeholder="John Doe"
            v-model="name"
            required
          />
        </div>

        <div class="input-group">
          <label for="email">Email</label>
          <input
            type="email"
            id="email"
            placeholder="you@example.com"
            v-model="email"
            required
          />
        </div>

        <div class="input-group">
          <label for="password">Password</label>
          <input
            type="password"
            id="password"
            placeholder="Create a password"
            v-model="password"
            required
          />
        </div>

        <button type="submit">Sign Up</button>
      </form>

      <p class="signup-text">
        Already have an account?
        <a href="#" @click.prevent="$router.push('/login')">Login</a>
      </p>
    </div>
  </div>
</template>

<script setup>
import { ref } from "vue";
import backArrow from "@/assets/back-arrow.png";

const name = ref("");
const email = ref("");
const password = ref("");

const register = () => {
  alert(`Welcome ${name.value}! Your account has been created.`);
  // In production: call backend API for signup
};
</script>

<style src="../assets/index.css"></style>

<style scoped>
.register-page {
  background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
  min-height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
}

.register-container {
  position: relative;
  padding: 2rem;
  border-radius: 15px;
  background-color: #ffffff;
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
  max-width: 400px;
  width: 90%;
}

.back-button {
  position: absolute;
  top: 15px;
  left: 15px;
  cursor: pointer;
}

.back-button img {
  width: 25px;
  height: 25px;
  transition: transform 0.3s ease;
}

.back-button:hover img {
  transform: translateX(-3px);
}
</style>
