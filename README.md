# 🍽️ SmartCal - AI-Powered Nutrition & Meal Planning App

<div align="center">

![Vue.js](https://img.shields.io/badge/Vue.js-3.5-4FC08D?style=for-the-badge&logo=vue.js&logoColor=white)
![Vite](https://img.shields.io/badge/Vite-7.1-646CFF?style=for-the-badge&logo=vite&logoColor=white)
![Supabase](https://img.shields.io/badge/Supabase-2.77-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-20+-339933?style=for-the-badge&logo=node.js&logoColor=white)
![Three.js](https://img.shields.io/badge/Three.js-0.181-000000?style=for-the-badge&logo=three.js&logoColor=white)

**Track your calories effortlessly with AI-powered recommendations and gamified nutrition tracking**

[Features](#-features) • [Tech Stack](#-tech-stack) • [Installation](#-installation) • [Usage](#-usage) • [Database Setup](#-database-setup)

</div>

---

## 📖 About SmartCal

SmartCal is a comprehensive nutrition tracking and meal planning application that combines modern web technologies with AI-powered recommendations. Built with Vue.js and Supabase, it provides users with an intuitive interface to track meals, plan weekly menus, monitor nutrition, and achieve health goals through gamification.

### 🎯 Key Highlights

- **AI-Powered Recommendations**: Get personalized nutrition advice using Google Gemini AI
- **Weekly Meal Planning**: Plan meals across 7 days with drag-and-drop simplicity
- **Gamification System**: Earn points, unlock achievements, and compete on leaderboards
- **Recipe Management**: Create, save, and organize custom recipes
- **Smart Shopping Lists**: Auto-generate shopping lists from meal plans
- **Real-time Analytics**: Visualize nutrition data with interactive charts
- **3D Animations**: Engaging Three.js animated character on homepage

---

## ✨ Features

### 🍴 Meal Planning & Tracking
- **Weekly Meal Planner**: Organize breakfast, lunch, dinner, and snacks for the entire week
- **Recipe Library**: Create and save custom recipes with ingredients and nutrition info
- **Favorites System**: Quick-add favorite meals to today's plan
- **Nutrition Tracking**: Monitor calories, protein, carbs, and fat intake
- **Shopping List Generator**: Automatically create shopping lists from planned meals

### 🤖 AI Integration
- **Gemini AI Recommendations**: Get personalized daily nutrition advice
- **Smart Analysis**: AI analyzes your intake and provides actionable feedback
- **Hydration Advice**: Receive water intake recommendations
- **Macro Balance Feedback**: Get insights on protein, carbs, and fat ratios

### 🏆 Gamification & Social Features
- **Points System**: Earn 10 points for every meal logged
- **Achievements**: Unlock 6 achievements (First Steps, Week Warrior, Century Club, etc.)
- **Daily Streaks**: Track consecutive days of meal logging
- **Leaderboard**: Compete with other users
- **Challenges**: Complete daily, weekly, and special challenges
- **Level System**: Progress through levels (100 points per level)
- **Progress Visualization**: Charts showing points earned over last 7 days

### 📊 Dashboard & Analytics
- **Daily Summary**: View today's total calories and water intake
- **Nutrition Breakdown**: Pie charts for macro distribution
- **Quick Actions**: Fast entry for meals, water, and nutrition
- **Visual Progress Tracking**: Interactive charts powered by Chart.js

### 🎨 User Experience
- **Responsive Design**: Mobile-friendly interface
- **3D Animated Character**: Three.js anime character on homepage
- **Dark/Light Mode Support**: Comfortable viewing in any environment
- **Intuitive Navigation**: Tab-based interface for easy access
- **Real-time Updates**: Instant feedback on actions

---

## 🛠️ Tech Stack

### Frontend
- **Framework**: Vue.js 3.5.22 (Composition API)
- **Build Tool**: Vite 7.1.7
- **Routing**: Vue Router 4.5.1
- **Charts**: Chart.js 4.5.1, ApexCharts 5.3.5, Vue-Chartjs 5.3.3
- **3D Graphics**: Three.js 0.181.0
- **Animations**: Vue Confetti Explosion 1.0.2
- **Analytics**: Vercel Analytics 1.5.0, Vercel Speed Insights 1.2.0

### Backend
- **Runtime**: Node.js 20+
- **Server**: Express.js 4.18.2
- **AI**: Google Generative AI (Gemini) 0.21.0
- **Database**: Supabase PostgreSQL 2.77.0
- **Authentication**: Supabase Auth
- **Environment**: dotenv 16.3.1

### Database Architecture
- **User Stats**: Points, levels, streaks, meals logged
- **Achievements**: 6 unlockable achievements with requirements
- **Challenges**: Daily, weekly, and special challenges
- **Meal Planning**: Weekly meal schedules with nutrition data
- **Recipes**: Custom user recipes with ingredients
- **Favorites**: Quick-access favorite meals
- **Shopping Lists**: Auto-generated from meal plans
- **RLS Policies**: Row-level security for data protection
- **Database Triggers**: Automatic stats updates on meal logging

---

## 🚀 Installation

### Prerequisites
- Node.js 20.19.0 or higher
- npm or yarn
- Supabase account
- Google Gemini API key

### 1. Clone the Repository
```bash
git clone https://github.com/Chan-Si-Jie/WAD2-Team-2-Group-Project-.git
cd WAD2-Team-2-Group-Project-
```

### 2. Install Dependencies

#### Frontend
```bash
npm install
```

#### Backend Server
```bash
cd server
npm install
cd ..
```

### 3. Environment Configuration

Create a `.env` file in the **root directory**:
```env
VITE_SUPABASE_URL=your_supabase_project_url
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
VITE_API_URL=http://localhost:3000
```

Create a `.env` file in the **server directory**:
```env
GEMINI_API_KEY=your_google_gemini_api_key
PORT=3000
```

### 4. Database Setup

Run the following SQL scripts in your Supabase SQL Editor (in order):

1. **setup_gamification.sql** - Creates tables, triggers, and initial data
2. **fix_duplicate_achievements.sql** (optional) - Fixes any duplicate achievements
3. **test_gamification.sql** (optional) - Testing queries for verification

### 5. Start Development Servers

#### Terminal 1: Frontend (Vite)
```bash
npm run dev
```

#### Terminal 2: Backend Server
```bash
cd server
npm run dev
```

The application will be available at:
- **Frontend**: http://localhost:5173
- **Backend API**: http://localhost:3000

---

## 📱 Usage

### Getting Started

1. **Register**: Create an account with email and password (min 6 characters)
2. **Login**: Access your personalized dashboard
3. **Complete Profile**: Set up your nutrition goals

### Dashboard
- View today's calorie and water intake
- Quick add meals, water, and nutrition
- Get AI-powered recommendations
- See macro breakdown in pie charts

### Meal Planner
- **Weekly Plan Tab**: Plan meals for the week
  - Navigate between weeks with arrow buttons
  - Click + button to add meals to specific days/meal types
  - View and remove planned meals
- **Recipes Tab**: Create and manage custom recipes
  - Add ingredients with amounts and units
  - Input total nutrition values
  - View recipe details
- **Favorites Tab**: Save frequently eaten meals
  - Quick add to today's plan
  - Manage favorite meals
- **Shopping List Tab**: Generate shopping lists
  - Auto-populate from meal plan ingredients
  - Check off items as you shop
  - Clear completed items

### Social & Gamification
- **Overview Tab**: View points, level, badges, and streak
- **Challenges Tab**: Complete daily, weekly, and special challenges
- **Achievements Tab**: Track and unlock achievements
- **Leaderboard Tab**: Compare your progress with others

### Achievements to Unlock
1. 🎯 **First Steps** - Log your first meal (1 meal)
2. 🔥 **Week Warrior** - 7-day logging streak
3. 👑 **Month Master** - 30-day logging streak
4. 💯 **Century Club** - Log 100 meals
5. ⭐ **Consistency King** - 50-day streak
6. 🥷 **Nutrition Ninja** - Log 500 meals

---

## 🗄️ Database Setup

### Required Supabase Tables

The application requires the following tables (auto-created by `setup_gamification.sql`):

#### Core Tables
- `meals` - Daily meal entries
- `water_logs` - Water intake tracking
- `nutrition` - Macro nutrition entries
- `planned_meals` - Weekly meal schedule
- `recipes` - User-created recipes
- `favorite_meals` - Saved favorite meals
- `shopping_list` - Generated shopping items

#### Gamification Tables
- `user_stats` - Points, levels, streaks, total meals
- `achievements` - Achievement definitions
- `user_achievements` - Unlocked achievements per user
- `challenges` - Challenge definitions
- `user_challenges` - Challenge progress per user

### Database Triggers

**`update_user_stats_on_meal()`** - Automatically fires when a meal is logged:
- Awards 10 points per meal
- Increments total meals logged
- Updates streak counters
- Calculates longest streak

### Running SQL Setup

1. Open Supabase SQL Editor
2. Copy contents of `setup_gamification.sql`
3. Execute the script
4. Verify with test queries from `test_gamification.sql`

---

## 🔧 Configuration

### Vite Configuration
Located in `vite.config.js`:
```javascript
export default defineConfig({
  plugins: [vue(), vueDevTools()],
  resolve: { alias: { '@': fileURLToPath(new URL('./src', import.meta.url)) } }
})
```

### Router Configuration
Protected routes require authentication:
- `/dashboard` - Main dashboard
- `/profile` - User profile
- `/meal-planner` - Meal planning interface
- `/fitness` - Fitness tracking
- `/social` - Gamification dashboard

Public routes:
- `/` - Homepage
- `/login` - User login
- `/register` - User registration

---

## 📂 Project Structure

```
WAD2-Team-2-Group-Project-/
├── public/                  # Static assets
├── server/                  # Express backend
│   ├── server.js           # API endpoints & Gemini integration
│   ├── package.json        # Server dependencies
│   └── README.md           # Server documentation
├── src/
│   ├── assets/             # CSS and images
│   │   ├── index.css       # Global styles
│   │   └── logPage.css     # Login/register styles
│   ├── components/         # Vue components
│   │   ├── AnimatedModel.vue       # Three.js character
│   │   ├── Dashboard.vue           # Main dashboard
│   │   ├── MealPlanner.vue         # Meal planning interface
│   │   ├── SocialGamification.vue  # Gamification system
│   │   ├── Navbar.vue              # Navigation bar
│   │   ├── Home.vue                # Landing page
│   │   ├── Login.vue               # Authentication
│   │   ├── Register.vue            # User registration
│   │   ├── Profile.vue             # User profile
│   │   ├── Fitness.vue             # Fitness tracking
│   │   └── NutritionPieChart.vue   # Chart component
│   ├── router/
│   │   └── index.js        # Vue Router configuration
│   ├── state/
│   │   └── userState.js    # Global user state
│   ├── App.vue             # Root component
│   ├── main.js             # Application entry point
│   ├── supabase.js         # Supabase client
│   └── auth.js             # Authentication logic
├── index.html              # HTML entry point
├── package.json            # Dependencies
├── vite.config.js          # Vite configuration
├── vercel.json             # Vercel deployment config
├── setup_gamification.sql  # Database setup script
├── fix_duplicate_achievements.sql  # Database fix script
├── test_gamification.sql   # Testing queries
└── README.md               # This file
```

---

## 🔐 Authentication

SmartCal uses Supabase Authentication with:
- Email/password registration
- Email confirmation (configurable)
- Session management
- Protected routes via Vue Router guards
- Row-level security (RLS) policies

---

## 🌐 API Endpoints

### Backend Server (Express)

#### Health Check
```
GET /api/health
Response: { status: "ok", message: "Server is running" }
```

#### AI Recommendation
```
POST /api/recommendation
Body: {
  summary: {
    totals: { calories, water, carbs, protein, fat },
    meals: [...],
    waterLogs: [...],
    nutritionEntries: [...]
  }
}
Response: { recommendation: "..." }
```

---

## 🎨 Key Components

### MealPlanner.vue (1481 lines)
- Weekly calendar view
- Recipe CRUD operations
- Favorites management
- Shopping list generation
- Meal logging with automatic points

### SocialGamification.vue (757 lines)
- Gamification dashboard
- Achievement system
- Challenge tracking
- Leaderboard
- Points visualization with Chart.js

### Dashboard.vue
- Daily nutrition summary
- Quick action buttons
- AI recommendations
- Macro pie charts

### AnimatedModel.vue
- Three.js integration
- Animated 3D character
- WebGL rendering

---

## 🚢 Deployment

### Vercel Deployment

The project is configured for Vercel deployment with:
- `vercel.json` configuration
- Serverless function for backend
- Automatic builds on push
- Environment variables via Vercel dashboard

```bash
# Deploy to Vercel
npm run build
vercel deploy
```

### Environment Variables (Production)
Set in Vercel dashboard:
- `VITE_SUPABASE_URL`
- `VITE_SUPABASE_ANON_KEY`
- `GEMINI_API_KEY`

---

## 🧪 Testing

### Manual Testing Queries
Use `test_gamification.sql` to:
- Verify trigger functionality
- Check user stats
- View achievements
- Test leaderboard
- Validate RLS policies

### Testing Workflow
1. Register a new user
2. Log a meal in Meal Planner
3. Check Dashboard for updated stats
4. Go to Social & Gamification
5. Click "Refresh Stats" button
6. Verify "First Steps" achievement unlocks

---

## 🐛 Troubleshooting

### Duplicate Achievements
**Issue**: Achievements appear multiple times
**Solution**: Run `fix_duplicate_achievements.sql` in Supabase SQL Editor

### Trigger Not Firing
**Issue**: Points not updating after logging meal
**Solution**: 
1. Run TEST 1 in `test_gamification.sql` to verify trigger exists
2. Check RLS policies are enabled
3. Verify user is authenticated

### Achievement Not Unlocking
**Issue**: Achievement doesn't unlock despite meeting requirements
**Solution**:
1. Click "Refresh Stats" button in Social & Gamification
2. Check console for errors
3. Verify achievement checking logic matches achievement titles

### Backend Server Not Connecting
**Issue**: 404 errors when getting AI recommendations
**Solution**:
1. Ensure backend server is running on port 3000
2. Check VITE_API_URL in .env
3. Verify GEMINI_API_KEY is set in server/.env

---

## 👥 Team

**WAD2 Team 2**
- Project Contributors: [Add team member names]

---

## 📄 License

This project is created for educational purposes as part of WAD2 coursework.

---

## 🙏 Acknowledgments

- Vue.js team for the amazing framework
- Supabase for backend infrastructure
- Google Gemini AI for recommendation engine
- Chart.js for data visualization
- Three.js for 3D graphics
- Vercel for hosting platform

---

<div align="center">

**Made with ❤️ using Vue.js and Supabase**

[⬆ Back to Top](#-smartcal---ai-powered-nutrition--meal-planning-app)

</div>