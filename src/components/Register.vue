<template>
  <div class="auth-page">
    <div class="auth-container">
      <!-- BACK BUTTON -->
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
          <label for="phone">Phone Number</label>
          <input
            type="tel"
            id="phone"
            placeholder="+65 9123 4567"
            v-model="phone"
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
import { useRouter } from "vue-router";
import backArrow from "@/assets/back-arrow.png";
import { supabase } from "@/supabase";

const router = useRouter();
const name = ref("");
const email = ref("");
const password = ref("");
const phone = ref("");

const register = async () => {
  if (!name.value || !email.value || !password.value || !phone.value) {
    alert("All fields are required!");
    return;
  }

  // Validate password length
  if (password.value.length < 6) {
    alert("Password must be at least 6 characters long!");
    return;
  }

  console.log('Attempting registration with:', {
    email: email.value,
    passwordLength: password.value.length,
    name: name.value,
    phone: phone.value
  });

  const { data, error } = await supabase.auth.signUp({
    email: email.value,
    password: password.value,
    options: {
      data: {
        full_name: name.value,
        phone: phone.value,
      },
    },
  });

  if (error) {
    console.error('Registration error:', error);
    if (
      error.message.includes("already registered") ||
      error.message.includes("User already exists")
    ) {
      alert(
        "This email is already registered or pending confirmation. Please login or confirm your email."
      );
    } else if (error.message.includes("Email rate limit exceeded")) {
      alert("Too many signup attempts. Please try again later.");
    } else {
      alert(`Registration failed: ${error.message}`);
    }
    return;
  }

  if (data?.user) {
    console.log('Registration successful:', data.user);
    alert(
      "Signup successful! Please check your email to confirm your account before logging in."
    );
    router.push("/login");
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
  padding: 3rem 2rem 2rem 2rem; /* increased top padding to 3rem */
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
