import { createApp } from "vue";
import App from "./App.vue";
import router from "./router";
import "./assets/index.css";
import { initAuth } from "@/auth"; // import the auth initializer
import { inject } from '@vercel/analytics';
import { injectSpeedInsights } from '@vercel/speed-insights';

const app = createApp(App);

// Initialize Supabase auth (checks session and subscribes to login/logout)
initAuth();

// Initialize Vercel Analytics
inject();

// Initialize Vercel Speed Insights
injectSpeedInsights();

app.use(router);
app.mount("#app");
