<template>
  <div class="auth-page">
    <div class="auth-container">
      <!-- BACK BUTTON -->
      <div class="back-button" @click="$router.push('/')">
        <img :src="backArrow" alt="Back" />
      </div>

      <h2>Login</h2>
      <p>Enter your email and password to access your dashboard</p>

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
            placeholder="Your password"
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
import { supabase } from "@/supabase";
import { userState } from "@/state/userState";

const router = useRouter();
const email = ref("");
const password = ref("");

const login = async () => {
  if (!email.value || !password.value) {
    alert("All fields are required!");
    return;
  }

  const { data, error } = await supabase.auth.signInWithPassword({
    email: email.value,
    password: password.value,
  });

  if (error) {
    if (error.message.includes("Invalid login credentials")) {
      alert("Incorrect email or password. Please try again.");
    } else if (error.message.includes("email not confirmed")) {
      alert("Please confirm your email before logging in.");
    } else {
      alert(`Login failed: ${error.message}`);
    }
    return;
  }

  if (data?.user) {
    // Save user state
    userState.loggedIn = true;
    userState.user = data.user;

    // Redirect to dashboard/homepage
    router.push("/");
  }
};
</script>

<style scoped>
.auth-page {
  background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
  min-height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
}

.auth-container {
  position: relative;
  width: 400px;
  max-width: 90%;
  padding: 2rem;
  border-radius: 15px;
  background-color: #ffffff;
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
}

.back-button {
  position: absolute;
  top: 15px;
  left: 15px;
  width: 30px;
  height: 30px;
  cursor: pointer;
}

.back-button img {
  width: 100%;
  height: 100%;
  object-fit: contain;
  transition: transform 0.3s ease;
}

.back-button:hover img {
  transform: translateX(-3px);
}

.input-group {
  margin: 1rem 0;
}

input {
  width: 100%;
  padding: 0.5rem;
  border-radius: 8px;
  border: 1px solid #ccc;
}

button {
  width: 100%;
  padding: 0.6rem;
  background-color: #27ae60;
  color: white;
  border: none;
  border-radius: 8px;
  font-weight: 600;
  cursor: pointer;
  margin-top: 1rem;
}

button:hover {
  background-color: #20c997;
}

.signup-text {
  margin-top: 1rem;
  text-align: center;
}
</style>
