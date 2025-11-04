import { createRouter, createWebHistory } from "vue-router";
import Home from "../components/Home.vue";
import Login from "../components/Login.vue";
import Register from "../components/Register.vue";
import Profile from "../components/Profile.vue";
// import Log from "../components/SmartCal.vue"; // Dashboard
import { userState } from "@/state/userState";
import Dashboard from "@/components/Dashboard.vue";
import MealPlanner from "@/components/MealPlanner.vue";

const routes = [
  { path: "/", name: "Home", component: Home },
  { path: "/login", name: "Login", component: Login },
  { path: "/register", name: "Register", component: Register },
  { path: "/profile", name: "Profile", component: Profile },
  // { path: "/log", name: "Log", component: Log, meta: { requiresAuth: true } },
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

    path: "/meal-planner",
    name: "MealPlanner",
    component: MealPlanner,
    meta: { requiresAuth: true },
    f5c6fcb8b325c37b08da790a6cbaa936e0188f87,
  },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

// Global navigation guard
router.beforeEach((to, from, next) => {
  if (to.meta.requiresAuth && !userState.loggedIn) {
    next("/login"); // redirect to login if not logged in
  } else {
    next();
  }
});

export default router;
