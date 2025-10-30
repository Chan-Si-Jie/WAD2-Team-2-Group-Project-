<script setup>
import { ref } from "vue";
import { useRouter } from "vue-router";
import { userState } from "@/state/userState";
import { supabase } from "@/supabase";

const router = useRouter();
const mobileMenu = ref(false);

const toggleMenu = () => {
  mobileMenu.value = !mobileMenu.value;
};

// Logout function
const logout = async () => {
  await supabase.auth.signOut();
  userState.loggedIn = false;
  userState.user = null;
  router.push("/");
};
</script>

<template>
  <nav class="navbar">
    <div class="nav-container">
      <!-- Logo -->
      <h1 class="logo" @click="$router.push('/')">SmartCal</h1>

      <!-- Hamburger Menu (Mobile) -->
      <div class="menu-toggle" @click="toggleMenu">
        <i :class="mobileMenu ? 'fas fa-times' : 'fas fa-bars'"></i>
      </div>

      <!-- Navigation Links -->
      <ul :class="['nav-links', { active: mobileMenu }]">
        <li><a href="#">Home</a></li>
        <li><a href="#features">Features</a></li>
        <li><a href="#about">About</a></li>
        <li><a href="#contact">Contact</a></li>

        <!-- Dynamic Login/Profile -->
        <li v-if="!userState.loggedIn">
          <button class="login-btn" @click="router.push('/login')">
            Login
          </button>
        </li>

        <li v-else class="profile-container">
          <button class="login-btn" @click="router.push('/profile')">
            Profile
          </button>
          <button class="login-btn logout-btn" @click="logout">Logout</button>
        </li>
      </ul>
    </div>
  </nav>
</template>

<style scoped>
@import url("https://fonts.googleapis.com/css2?family=Poppins:wght@500;600;700&display=swap");

/* NAVBAR BASE */
.navbar {
  background: linear-gradient(90deg, #27ae60, #20c997);
  color: white;
  position: sticky;
  top: 0;
  width: 100%;
  z-index: 1000;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}

.nav-container {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0.8rem 2rem;
  max-width: 1200px;
  margin: 0 auto;
  font-family: "Poppins", sans-serif;
}

/* LOGO */
.logo {
  font-size: 1.6rem;
  font-weight: 700;
  letter-spacing: 0.5px;
  cursor: pointer;
}

/* NAV LINKS */
.nav-links {
  list-style: none;
  display: flex;
  align-items: center;
  gap: 1rem;
  transition: all 0.3s ease;
}

.nav-links li a {
  color: white;
  text-decoration: none;
  font-weight: 500;
  position: relative;
}

.nav-links li a::after {
  content: "";
  display: block;
  width: 0%;
  height: 2px;
  background-color: white;
  transition: 0.3s;
  margin-top: 4px;
}

.nav-links li a:hover::after {
  width: 100%;
}

/* LOGIN / PROFILE / LOGOUT BUTTONS */
.login-btn {
  background-color: white;
  color: #27ae60;
  border: none;
  padding: 0.5rem 1.2rem;
  border-radius: 25px;
  cursor: pointer;
  font-weight: 600;
  transition: all 0.3s ease;
  margin-left: 0.5rem;
}

.login-btn:hover {
  background-color: #f0f9ff;
  transform: translateY(-2px);
}

.profile-container {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

/* HAMBURGER MENU */
.menu-toggle {
  display: none;
  cursor: pointer;
  font-size: 1.5rem;
}

/* MOBILE RESPONSIVENESS */
@media (max-width: 900px) {
  .menu-toggle {
    display: block;
    color: white;
  }

  .nav-links {
    position: absolute;
    top: 64px;
    left: 0;
    right: 0;
    background-color: #27ae60;
    flex-direction: column;
    gap: 1.5rem;
    padding: 2rem 0;
    opacity: 0;
    transform: translateY(-20px);
    pointer-events: none;
    transition: all 0.3s ease;
  }

  .nav-links.active {
    opacity: 1;
    transform: translateY(0);
    pointer-events: auto;
  }

  .nav-links li {
    width: 100%;
    text-align: center;
  }

  .login-btn {
    width: 80%;
    margin-top: 0.5rem;
  }

  .profile-container {
    flex-direction: column;
  }
}
</style>
