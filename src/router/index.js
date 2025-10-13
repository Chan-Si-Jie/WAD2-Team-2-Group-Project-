import { createRouter, createWebHistory } from "vue-router";
import Home from "../components/Home.vue";
import Login from "../components/Login.vue";
import Log from "../components/SmartCal.vue"; // main food logging page

const routes = [
  { path: "/", name: "Home", component: Home },
  { path: "/login", name: "Login", component: Login },
  { path: "/log", name: "Log", component: Log },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
