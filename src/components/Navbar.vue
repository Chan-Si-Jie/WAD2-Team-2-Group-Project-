<script setup>
import { ref, computed, onMounted, onUnmounted } from "vue";
import { useRouter, useRoute } from "vue-router";
import { userState } from "@/state/userState";
import { supabase } from "@/supabase";

const router = useRouter();
const route = useRoute();
const mobileMenu = ref(false);

// Check if user is on homepage
const isHomePage = computed(() => route.path === "/");

const toggleMenu = () => {
  mobileMenu.value = !mobileMenu.value;
};

const closeMenu = () => {
  mobileMenu.value = false;
};

// Close menu when clicking outside
const handleClickOutside = (event) => {
  const navContainer = document.querySelector('.nav-container');
  if (navContainer && !navContainer.contains(event.target) && mobileMenu.value) {
    closeMenu();
  }
};

// Close menu on route change
const unwatchRoute = router.afterEach(() => {
  closeMenu();
});

onMounted(() => {
  document.addEventListener('click', handleClickOutside);
});

onUnmounted(() => {
  document.removeEventListener('click', handleClickOutside);
  unwatchRoute();
});

// Logout function
const logout = async () => {
  await supabase.auth.signOut();
  userState.loggedIn = false;
  userState.user = null;
  closeMenu();
  router.push("/");
};

// Navigation with menu close
const navigateTo = (path) => {
  router.push(path);
  closeMenu();
};
</script>

<template>
  <nav class="navbar">
    <div class="nav-container">
      <!-- LEFT: Logo -->
      <h1 class="logo" @click="navigateTo('/')">SmartCal</h1>

      <!-- CENTER: flexible spacer -->
      <div class="nav-center"></div>

      <!-- RIGHT: nav links + buttons -->
      <div class="nav-right">
        <!-- Hamburger Menu (Mobile) -->
        <div class="menu-toggle" @click.stop="toggleMenu">
          <i :class="mobileMenu ? 'fas fa-times' : 'fas fa-bars'"></i>
        </div>

        <!-- Navigation Links -->
        <ul :class="['nav-links', { active: mobileMenu }]" @click.stop>
          <!-- Always visible: Home -->
          <li>
            <a @click="navigateTo('/')">
              <i class="fas fa-home"></i> Home
            </a>
          </li>

          <!-- Logged in user navigation -->
          <li v-if="userState.loggedIn">
            <a @click="navigateTo('/dashboard')">
              <i class="fas fa-chart-line"></i> Dashboard
            </a>
          </li>

          <li v-if="userState.loggedIn">
            <a @click="navigateTo('/fitness')">
              <i class="fas fa-dumbbell"></i> Fitness Tracker
            </a>
          </li>

          <li v-if="userState.loggedIn">
            <a @click="navigateTo('/meal-planner')">
              <i class="fas fa-utensils"></i> Meal Planner
            </a>
          </li>

          <li v-if="userState.loggedIn">
            <a @click="navigateTo('/social')">
              <i class="fas fa-trophy"></i> Social & Rewards
            </a>
          </li>

          <!-- Auth buttons -->
          <li v-if="!userState.loggedIn" class="auth-item">
            <button class="login-btn" @click="navigateTo('/login')">
              <i class="fas fa-sign-in-alt"></i> Login
            </button>
          </li>
          
          <li v-if="userState.loggedIn" class="profile-container">
            <button class="login-btn profile-btn" @click="navigateTo('/profile')">
              <i class="fas fa-user"></i> Profile
            </button>
            <button class="login-btn logout-btn" @click="logout">
              <i class="fas fa-sign-out-alt"></i> Logout
            </button>
          </li>
        </ul>
      </div>
    </div>

    <!-- Mobile Menu Backdrop -->
    <div v-if="mobileMenu" class="menu-backdrop" @click="closeMenu"></div>
  </nav>
</template>

<style scoped>
@import url("https://fonts.googleapis.com/css2?family=Poppins:wght@500;600;700&display=swap");

/* NAVBAR BASE */
.navbar {
  background: linear-gradient(90deg, #27ae60, #20c997);
  color: white;
  position: relative;
  top: 0;
  width: 100%;
  z-index: 1000;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  min-height: 64px;
}

/* Adjusted so logo is permanently flush to the left edge */
.nav-container {
  display: flex;
  align-items: center;
  justify-content: space-between;
  /* logo left, nav-right right */
  padding: 1rem 1rem;
  /* set left padding as you prefer; use 0 to be flush */
  width: 100%;
  margin: 0;
  font-family: "Poppins", sans-serif;
  min-height: 64px;
}

/* Logo */
.logo {
  font-size: 1.6rem;
  font-weight: 700;
  letter-spacing: 0.5px;
  cursor: pointer;
  margin-right: 3rem;
}

/* Spacer to push nav-right to the far right */
.nav-center {
  flex: 1;
  min-width: 2rem;
}

/* Right-side nav */
.nav-right {
  display: flex;
  align-items: center;
  gap: 1rem;
}

/* Nav links */
.nav-links {
  display: flex;
  align-items: center;
  gap: 2rem;
  list-style: none;
  transition: all 0.3s ease;
  margin: 0;
  padding: 0;
}

.nav-links li {
  display: flex;
  align-items: center;
}

.nav-links li a {
  color: white;
  text-decoration: none;
  font-weight: 500;
  position: relative;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.nav-links li a i {
  font-size: 0.9rem;
}

.nav-links li a::after {
  content: "";
  display: block;
  width: 0%;
  height: 2px;
  background-color: white;
  transition: 0.3s;
  margin-top: 4px;
  position: absolute;
  bottom: -4px;
  left: 0;
}

.nav-links li a:hover::after {
  width: 100%;
}

/* Buttons */
.login-btn {
  background-color: white;
  color: #27ae60;
  border: none;
  padding: 0.5rem 1.2rem;
  border-radius: 25px;
  cursor: pointer;
  font-weight: 600;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  white-space: nowrap;
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

.auth-item {
  display: flex;
  align-items: center;
}

/* Hamburger Menu */
.menu-toggle {
  display: none;
  cursor: pointer;
  font-size: 1.5rem;
  color: white;
  padding: 0.5rem;
  transition: transform 0.3s ease;
  z-index: 1001;
}

.menu-toggle:hover {
  transform: scale(1.1);
}

.menu-toggle:active {
  transform: scale(0.95);
}

/* MOBILE RESPONSIVENESS */
@media (max-width: 900px) {
  .menu-toggle {
    display: block;
  }

  .nav-links {
    position: fixed;
    top: 64px;
    left: 0;
    right: 0;
    background: linear-gradient(135deg, #27ae60, #20c997);
    flex-direction: column;
    gap: 0;
    padding: 0;
    opacity: 0;
    transform: translateY(-20px);
    pointer-events: none;
    transition: all 0.3s ease;
    z-index: 999;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
    max-height: calc(100vh - 64px);
    overflow-y: auto;
  }

  .nav-links.active {
    opacity: 1;
    transform: translateY(0);
    pointer-events: auto;
  }

  .nav-links li {
    width: 100%;
    text-align: center;
    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  }

  .nav-links li:last-child {
    border-bottom: none;
  }

  .nav-links li a {
    display: block;
    padding: 1.2rem 1.5rem;
    width: 100%;
    transition: background 0.2s ease;
  }

  .nav-links li a:hover {
    background: rgba(255, 255, 255, 0.1);
  }

  .nav-links li a::after {
    display: none;
  }

  .login-btn {
    width: 80%;
    margin: 1rem auto;
    display: block;
  }

  .profile-container {
    flex-direction: column;
    gap: 0.8rem;
    padding: 1rem 0;
    width: 100%;
  }

  .profile-container .login-btn {
    margin: 0 auto;
  }

  /* Prevent body scroll when menu is open */
  .navbar:has(.nav-links.active) ~ * {
    overflow: hidden;
  }
}

/* Small mobile optimization */
@media (max-width: 480px) {
  .logo {
    font-size: 1.3rem;
  }

  .menu-toggle {
    font-size: 1.3rem;
  }

  .nav-links li a {
    padding: 1rem;
    font-size: 0.95rem;
  }
}

/* Mobile Menu Backdrop */
.menu-backdrop {
  display: none;
}

@media (max-width: 900px) {
  .menu-backdrop {
    display: block;
    position: fixed;
    top: 64px;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0, 0, 0, 0.5);
    z-index: 998;
    animation: fadeIn 0.3s ease;
  }

  @keyframes fadeIn {
    from {
      opacity: 0;
    }
    to {
      opacity: 1;
    }
  }
}

/* Add icons spacing in mobile menu */
@media (max-width: 900px) {
  .nav-links li a i,
  .login-btn i {
    margin-right: 0.5rem;
  }
}
</style>
