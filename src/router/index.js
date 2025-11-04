import { createRouter, createWebHistory } from "vue-router";
import Home from "../components/Home.vue";
import Login from "../components/Login.vue";
import Register from "../components/Register.vue";
import Profile from "../components/Profile.vue";
import Dashboard from "@/components/Dashboard.vue";
import MealPlanner from "@/components/MealPlanner.vue";
import { userState } from "@/state/userState";
import SocialGamification from "@/components/SocialGamification.vue";

const routes = [
  {
    path: "/",
    name: "Home",
    component: Home,
  },
  {
    path: "/login",
    name: "Login",
    component: Login,
  },
  {
    path: "/register",
    name: "Register",
    component: Register,
  },
  {
    path: "/profile",
    name: "Profile",
    component: Profile,
    meta: { requiresAuth: true },
  },
  {
    path: "/dashboard",
    name: "Dashboard",
    component: Dashboard,
    meta: { requiresAuth: true },
  },
  {
    path: "/fitness",
    name: "Fitness",
    component: () => import("@/components/Fitness.vue"),
    meta: { requiresAuth: true },
  },
  {
    path: "/meal-planner",
    name: "MealPlanner",
    component: MealPlanner,
    meta: { requiresAuth: true },
  },
  {
    path: "/social",
    name: "SocialGamification",
    component: SocialGamification,
    meta: { requiresAuth: true },
  }
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

// 🔒 Global navigation guard
router.beforeEach((to, from, next) => {
  if (to.meta.requiresAuth && !userState.loggedIn) {
    next("/login"); // Redirect to login if not authenticated
  } else {
    next();
  }
});

export default router;
