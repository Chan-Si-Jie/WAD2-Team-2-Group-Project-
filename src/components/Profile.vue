<template>
  <div class="profile-page">
    <div class="profile-container" v-if="userState.loggedIn">
      <h2>Welcome, {{ userState.user.user_metadata.full_name || "User" }}!</h2>
      <p>
        Email: <strong>{{ userState.user.email }}</strong>
      </p>

      <button class="logout-btn" @click="logout">Logout</button>
    </div>

    <div v-else class="not-logged-in">
      <p>You are not logged in.</p>
      <button @click="router.push('/login')">Go to Login</button>
    </div>
  </div>
</template>

<script setup>
import { useRouter } from "vue-router";
import { userState } from "@/state/userState";
import { supabase } from "@/supabase";

const router = useRouter();

// Logout function
const logout = async () => {
  await supabase.auth.signOut(); // Log out from Supabase
  userState.loggedIn = false; // Reset reactive state
  userState.user = null;
  router.push("/"); // Redirect to login
};
</script>

<style src="../assets/index.css"></style>

<style scoped>
.profile-container {
  max-width: 400px;
  margin: 5rem auto;
  padding: 2rem;
  border-radius: 15px;
  background-color: #ffffff;
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
  text-align: center;
}

.logout-btn {
  margin-top: 2rem;
  padding: 0.5rem 1.2rem;
  background-color: #007bff;
  color: white;
  border: none;
  border-radius: 8px;
  font-weight: 600;
  cursor: pointer;
}

.logout-btn:hover {
  background-color: #0056b3;
}

.not-logged-in {
  text-align: center;
  margin-top: 5rem;
}

.not-logged-in button {
  margin-top: 1rem;
  padding: 0.5rem 1.2rem;
  background-color: #007bff;
  color: white;
  border: none;
  border-radius: 8px;
  cursor: pointer;
}

.not-logged-in button:hover {
  background-color: #0056b3;
}
</style>
