<template>
  <div class="login-page">
    <div class="login-container">
      <!-- BACK BUTTON INSIDE CARD -->
      <div class="back-button" @click="$router.push('/')">
        <img :src="backArrow" alt="Back" />
      </div>

      <h2>Welcome Back</h2>
      <p>Login to continue tracking your calories</p>

      <form @submit.prevent="login">
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
            placeholder="Enter your password"
            v-model="password"
            required
          />
        </div>

        <button type="submit">Login</button>
      </form>

      <p class="signup-text">
        Don't have an account?
        <a href="#" @click.prevent="$router.push('/register')">Sign Up</a>
      </p>
    </div>
  </div>
</template>

<script setup>
import { ref } from "vue";
import { useRouter } from "vue-router";
import backArrow from "@/assets/back-arrow.png";
import { userState } from "@/state/userState";

const router = useRouter();
const email = ref("");
const password = ref("");

const login = () => {
  if (email.value === "wad2@gmail.com" && password.value === "wad2grp2") {
    alert("Login successful!");
    userState.loggedIn = true; // Update navbar state
    router.push("/"); // Redirect to home
  } else {
    alert("Invalid credentials");
  }
};
</script>

<style src="../assets/index.css"></style>

<style scoped>
.login-container {
  position: relative;
  padding: 2rem;
  border-radius: 15px;
  background-color: #ffffff;
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
  max-width: 400px;
  margin: 5rem auto;
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
