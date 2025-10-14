<template>
  <div class="profile-page">
    <div class="profile-container">
      <h2>Welcome to your Profile!</h2>
      <p>Email: <strong>wad2@gmail.com</strong></p>

      <button class="logout-btn" @click="logout">Logout</button>
    </div>
  </div>
</template>

<script setup>
import { useRouter } from "vue-router";
import { userState } from "@/state/userState";

const router = useRouter();

const logout = () => {
  userState.loggedIn = false; // Reset login state
  router.push("/");
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
</style>
