# 🍽️ SmartCal - AI-Powered Nutrition & Meal Planning App

<div align="center">

![Vue.js](https://img.shields.io/badge/Vue.js-3.5-4FC08D?style=for-the-badge&logo=vue.js&logoColor=white)
![Vite](https://img.shields.io/badge/Vite-7.1-646CFF?style=for-the-badge&logo=vite&logoColor=white)
![Supabase](https://img.shields.io/badge/Supabase-2.77-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-20+-339933?style=for-the-badge&logo=node.js&logoColor=white)
![Three.js](https://img.shields.io/badge/Three.js-0.181-000000?style=for-the-badge&logo=three.js&logoColor=white)
![SendGrid](https://img.shields.io/badge/SendGrid-Email-00B3E6?style=for-the-badge&logo=sendgrid&logoColor=white)

**Track your calories effortlessly with AI-powered recommendations, recipe suggestions, and intelligent email support**

🔗 **[Live Demo](https://wad-2-team-2-group-project.vercel.app/)** | 📦 **[GitHub Repository](https://github.com/Chan-Si-Jie/WAD2-Team-2-Group-Project-)**

[Features](#-features) • [Tech Stack](#-tech-stack) • [Installation](#-installation) • [Usage](#-usage) • [API Integrations](#-api-integrations)

</div>

---

## 🚀 Quick Links

- **Live Application**: https://wad-2-team-2-group-project.vercel.app/
- **GitHub Repository**: https://github.com/Chan-Si-Jie/WAD2-Team-2-Group-Project-
- **Deployed on**: Vercel (Frontend + Serverless Backend)

---

## 📖 About SmartCal

SmartCal is a comprehensive nutrition tracking and meal planning application that combines modern web technologies with multiple AI-powered features. Built with Vue.js and Supabase, it provides users with an intuitive interface to track meals, discover recipes from external APIs, plan weekly menus, monitor nutrition, and achieve health goals through gamification. The app also features an AI-powered email support system for instant customer assistance.

### 🎯 Key Highlights

- **AI-Powered Recommendations**: Get personalized nutrition advice using Google Gemini AI
- **Recipe Discovery**: Browse and save 12+ suggested recipes from Spoonacular API
- **Smart Email Support**: AI-powered contact form with instant confirmation and intelligent responses
- **Weekly Meal Planning**: Plan meals across 7 days with drag-and-drop simplicity
- **Gamification System**: Earn points, unlock achievements, and compete on leaderboards
- **Recipe Management**: Create, save, and organize custom recipes
- **Smart Shopping Lists**: Auto-generate shopping lists from meal plans with quantity aggregation
- **Real-time Analytics**: Visualize nutrition data with interactive charts
- **3D Animations**: Engaging Three.js animated character on homepage
- **Food Search**: Search USDA database for nutritional information

---

## ✨ Features

### 🍴 Meal Planning & Tracking
- **Weekly Meal Planner**: Organize breakfast, lunch, dinner, and snacks for the entire week
- **Recipe Library**: Create and save custom recipes with ingredients and nutrition info
- **Recipe Discovery**: Browse suggested recipes from Spoonacular API
  - Search recipes by keyword
  - Get 12 random recipe suggestions on load
  - View recipe details on Spoonacular website
  - Save API recipes to your personal collection with ingredients and nutrition
- **Favorites System**: Quick-add favorite meals to today's plan
- **Nutrition Tracking**: Monitor calories, protein, carbs, and fat intake
- **Shopping List Generator**: Automatically create shopping lists from planned meals
  - **Smart Quantity Aggregation**: If the same recipe is added twice, ingredients are doubled
  - Separate ingredients by name and unit (e.g., "2 cups flour" vs "200g flour")
  - Check off items as purchased
  - Clear completed items

### 🤖 AI Integration
- **Gemini AI Recommendations**: Get personalized daily nutrition advice
- **Smart Analysis**: AI analyzes your intake and provides actionable feedback
- **Hydration Advice**: Receive water intake recommendations
- **Macro Balance Feedback**: Get insights on protein, carbs, and fat ratios
- **AI-Powered Email Support**: 
  - Instant confirmation email upon contact form submission
  - AI-generated personalized response within minutes
  - Context-aware answers about SmartCal features
  - Professional and helpful customer service

### 📧 Contact & Support
- **Intelligent Contact Form**: 
  - Immediate email confirmation with your message
  - AI processes your inquiry with Gemini
  - Follow-up email with detailed AI-generated response
  - Mentions relevant SmartCal features based on inquiry
- **SendGrid Email Integration**: Professional email delivery
- **Two-email system**: 
  1. Instant confirmation (< 1 second)
  2. AI response (1-2 minutes)

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
- **USDA Food Search**: Search 8 foods with nutritional data per 100g

### 🎨 User Experience
- **Responsive Design**: Mobile-friendly interface
- **3D Animated Character**: Three.js anime character on homepage
- **Centered Homepage**: Hero section and description properly centered
- **Intuitive Navigation**: Tab-based interface for easy access
- **Real-time Updates**: Instant feedback on actions
- **Loading States**: Visual feedback during API calls
- **Error Handling**: User-friendly error messages

---

## 🛠️ Tech Stack

### Frontend
- **Framework**: Vue.js 3.5.22 (Composition API with `<script setup>`)
- **Build Tool**: Vite 7.1.7
- **Routing**: Vue Router 4.5.1
- **Charts**: Chart.js 4.5.1, ApexCharts 5.3.5, Vue-Chartjs 5.3.3
- **3D Graphics**: Three.js 0.181.0
- **Animations**: Vue Confetti Explosion 1.0.2
- **Analytics**: Vercel Analytics 1.5.0, Vercel Speed Insights 1.2.0

### Backend
- **Runtime**: Node.js 20+
- **Server**: Express.js 4.18.2
- **AI**: Google Generative AI (Gemini 2.5 Flash) 0.21.0
- **Email**: SendGrid API v3
- **Database**: Supabase PostgreSQL 2.77.0
- **Authentication**: Supabase Auth
- **Environment**: dotenv 16.3.1
- **CORS**: cors 2.8.5

### External APIs
- **Spoonacular Recipe API**: Recipe search, random recipes, detailed recipe information
- **USDA FoodData Central API**: Nutritional information for 8 foods per search
- **SendGrid Email API**: Transactional email delivery
- **Google Gemini AI**: Natural language processing for recommendations and email responses

### Database Architecture
- **User Stats**: Points, levels, streaks, meals logged
- **Achievements**: 6 unlockable achievements with requirements
- **Challenges**: Daily, weekly, and special challenges
- **Meal Planning**: Weekly meal schedules with nutrition data
- **Recipes**: Custom user recipes with ingredients (JSONB array)
- **Favorites**: Quick-access favorite meals
- **Shopping Lists**: Auto-generated from meal plans with quantity aggregation
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
VITE_GEMINI_API_KEY=your_gemini_api_key
VITE_SUPABASE_URL=your_supabase_project_url
VITE_SUPABASE_KEY=your_supabase_anon_key
USDA_API_KEY=your_usda_api_key
VITE_API_URL=http://localhost:3000
```

Create a `.env` file in the **server directory**:
```env
PORT=3000
GEMINI_API_KEY=your_google_gemini_api_key
USDA_API_KEY=your_usda_fooddata_api_key
SPOONACULAR_API_KEY=your_spoonacular_api_key
SENDGRID_API_KEY=your_sendgrid_api_key
```

#### API Keys Required
- **Gemini API**: Get from [Google AI Studio](https://makersuite.google.com/app/apikey)
- **Supabase**: Get from your [Supabase project settings](https://supabase.com)
- **USDA FoodData Central**: Get from [USDA API Portal](https://fdc.nal.usda.gov/api-key-signup.html)
- **Spoonacular**: Get from [Spoonacular API](https://spoonacular.com/food-api) (Free tier: 150 requests/day)
- **SendGrid**: Get from [SendGrid](https://sendgrid.com) (Free tier: 100 emails/day)
  - **Important**: Verify your sender email (e.g., jaykinchan@gmail.com) in SendGrid before sending emails

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
  - **Suggested Recipes Section**:
    - Search recipes by keyword (e.g., "pasta", "chicken", "vegan")
    - Get 12 random recipe suggestions on page load
    - View recipe details on Spoonacular website
    - Save API recipes to your collection (includes ingredients and nutrition)
- **Favorites Tab**: Save frequently eaten meals
  - Quick add to today's plan
  - Manage favorite meals
- **Shopping List Tab**: Generate shopping lists
  - Auto-populate from meal plan ingredients
  - **Smart quantity aggregation**: Ingredients from duplicate recipes are summed
  - Check off items as you shop
  - Clear completed items

### Contact Us
- **AI-Powered Support**: Located in homepage footer
  - Fill out contact form with name, email, and message
  - **Instant confirmation email**: Receive immediate acknowledgment
  - **AI-generated response**: Get personalized answer within 1-2 minutes
  - AI analyzes your inquiry and provides relevant information about SmartCal features

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

## 🌐 API Integrations

### Backend Server Endpoints (Express)

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
Response: { recommendation: "...", success: true }
```

#### USDA Food Search
```
GET /api/food/search?query={food_name}
Response: { 
  foods: [
    { name, calories, serving, carbs, protein, fat, foodId }
  ],
  success: true 
}
```

#### Spoonacular Recipe Search
```
GET /api/recipes/search?query={recipe_name}
Response: { 
  recipes: [
    { id, title, image, readyInMinutes, servings, nutrition, extendedIngredients }
  ],
  success: true 
}
```

#### Get Random Recipes
```
GET /api/recipes/random
Response: { 
  recipes: [12 random recipes with full nutrition and ingredients],
  success: true 
}
```

#### Get Recipe Details
```
GET /api/recipes/:id
Response: { 
  recipe: { full recipe details with nutrition },
  success: true 
}
```

#### Contact Form with AI Response
```
POST /api/contact/send
Body: { name, email, message }
Process:
  1. Sends immediate confirmation email
  2. Processes message with Gemini AI (async)
  3. Sends AI-generated response email within 1-2 minutes
Response: { 
  success: true, 
  message: "Message sent successfully! Check your email for confirmation and an AI-powered response." 
}
```

### External API Integrations

#### Spoonacular API
- **Endpoint**: `https://api.spoonacular.com/recipes/`
- **Usage**: Recipe search, random recipes, detailed recipe information
- **Free Tier**: 150 requests/day
- **Features**: 
  - Complex recipe search with nutrition
  - Random recipe generation
  - Extended ingredient lists
  - Nutritional breakdown

#### USDA FoodData Central API
- **Endpoint**: `https://api.nal.usda.gov/fdc/v1/foods/search`
- **Usage**: Nutritional data for common foods
- **Data Types**: Foundation, SR Legacy
- **Results**: 8 foods per search with nutrients per 100g

#### SendGrid Email API
- **Endpoint**: `https://api.sendgrid.com/v3/mail/send`
- **Usage**: Transactional emails
- **Free Tier**: 100 emails/day
- **Email Types**:
  - Contact form confirmation
  - AI-generated responses
- **Requirements**: Verified sender email address

#### Google Gemini AI
- **Model**: gemini-2.5-flash
- **Usage**: 
  - Daily nutrition recommendations
  - Customer support email responses
- **Features**:
  - Context-aware responses
  - SmartCal feature knowledge
  - Professional email tone

---

## 🎨 Key Components

### MealPlanner.vue (~1880 lines)
- Weekly calendar view
- Recipe CRUD operations
- **Suggested Recipes Integration**:
  - Search recipes via backend API
  - Random recipe loading on mount
  - Save API recipes with ingredients and nutrition
  - View recipe details on Spoonacular
- Favorites management
- Shopping list generation with quantity aggregation
- Meal logging with automatic points

### SocialGamification.vue (757 lines)
- Gamification dashboard
- Achievement system
- Challenge tracking
- Leaderboard
- Points visualization with Chart.js

### Dashboard.vue (~1092 lines)
- Daily nutrition summary
- Quick action buttons with USDA food search
- AI recommendations
- Macro pie charts
- Water and nutrition logging

### Home.vue (~1030 lines)
- Landing page with hero section (centered)
- Features showcase
- About section
- **AI-Powered Contact Form**:
  - Reactive form with v-model bindings
  - Instant email confirmation
  - AI-generated response follow-up
  - Success/error message display
  - Loading states during submission
- Contact information
- Footer

### AnimatedModel.vue (375 lines)
- Three.js integration
- Animated 3D character
- WebGL rendering
- Responsive dimensions

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
- `VITE_GEMINI_API_KEY`
- `VITE_SUPABASE_URL`
- `VITE_SUPABASE_KEY`
- `VITE_API_URL` (set to your deployed backend URL)
- `GEMINI_API_KEY`
- `USDA_API_KEY`
- `SPOONACULAR_API_KEY`
- `SENDGRID_API_KEY`

**Important for Production**:
- Update VITE_API_URL to point to deployed backend
- Ensure all API keys are valid for production use
- Verify SendGrid sender email in production environment
- Monitor API rate limits (Spoonacular: 150/day, SendGrid: 100/day on free tier)

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
**Issue**: 404 errors when getting AI recommendations or recipes  
**Solution**:
1. Ensure backend server is running on port 3000
2. Check VITE_API_URL in root .env file
3. Verify all API keys are set in server/.env

### Recipe API Not Working
**Issue**: Suggested recipes not loading  
**Solution**:
1. Check SPOONACULAR_API_KEY in server/.env
2. Verify you haven't exceeded free tier limit (150 requests/day)
3. Check browser console for error messages
4. Ensure backend server is running

### Shopping List Not Aggregating Quantities
**Issue**: Duplicate recipe ingredients not being summed  
**Solution**:
1. Verify you're adding the same recipe multiple times (not different recipes)
2. Click "Generate Shopping List" button after adding all meals
3. Check that ingredients have matching names and units

### Email Not Sending
**Issue**: Contact form confirmation or AI response not received  
**Solution**:
1. Verify SENDGRID_API_KEY in server/.env
2. Check that sender email is verified in SendGrid dashboard
3. Update `from.email` in server.js to your verified SendGrid email
4. Check spam/junk folder
5. Look at server console logs for SendGrid errors

### Invalid Fetch Error on Login
**Issue**: "Failed to execute 'fetch' on 'Window': Invalid value"  
**Solution**:
1. Check that VITE_API_URL in root .env is properly formatted (no spaces)
2. Restart development server after changing .env
3. Verify .env file is not corrupted

### Food Search Not Working
**Issue**: USDA food search returns no results  
**Solution**:
1. Verify USDA_API_KEY in server/.env
2. Ensure query is at least 2 characters
3. Check backend server console for API errors

---

## 👥 Team

**WAD2 Team 2**
- Project Lead & Developer: **Chan Si Jie**

---

## 📄 License

This project is created for educational purposes as part of WAD2 coursework.

---

## 🙏 Acknowledgments

- Vue.js team for the amazing framework
- Supabase for backend infrastructure and authentication
- Google Gemini AI for recommendation and email response engine
- Spoonacular for recipe API and nutritional data
- USDA FoodData Central for food nutrition database
- SendGrid for reliable email delivery
- Chart.js for data visualization
- Three.js for 3D graphics
- Vercel for hosting platform

---

## 🔑 API Limits & Free Tiers

| Service | Free Tier Limit | Usage in SmartCal |
|---------|----------------|-------------------|
| Spoonacular | 150 requests/day | Recipe search, random recipes, recipe details |
| SendGrid | 100 emails/day | Contact form confirmations + AI responses |
| USDA FoodData | No stated limit | Food nutritional search |
| Google Gemini | Generous free tier | Nutrition recommendations, email responses |
| Supabase | 500MB database, 2GB bandwidth | Database, authentication, storage |

---

<div align="center">

**Made with ❤️ using Vue.js and Supabase**

[⬆ Back to Top](#-smartcal---ai-powered-nutrition--meal-planning-app)

</div>