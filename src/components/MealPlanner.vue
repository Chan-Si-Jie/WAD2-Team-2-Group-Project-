<template>
  <div class="meal-planner-page">
    <Navbar />

    <div class="meal-planner">
      <header class="planner-header">
        <h1>🍽️ Meal Planner</h1>
        <p>Plan your weekly meals and generate shopping lists</p>
      </header>

      <!-- Tab Navigation -->
      <div class="tabs">
        <button
          :class="{ active: activeTab === 'planner' }"
          @click="activeTab = 'planner'"
        >
          📅 Weekly Plan
        </button>
        <button
          :class="{ active: activeTab === 'recipes' }"
          @click="activeTab = 'recipes'"
        >
          📖 Recipes
        </button>
        <button
          :class="{ active: activeTab === 'favorites' }"
          @click="activeTab = 'favorites'"
        >
          ⭐ Favorites
        </button>
        <button
          :class="{ active: activeTab === 'shopping' }"
          @click="activeTab = 'shopping'"
        >
          🛒 Shopping List
        </button>
      </div>

      <!-- Weekly Planner Tab -->
      <div v-if="activeTab === 'planner'" class="tab-content">
        <div class="week-selector">
          <button @click="changeWeek(-1)">← Previous Week</button>
          <h3>{{ currentWeekDisplay }}</h3>
          <button @click="changeWeek(1)">Next Week →</button>
        </div>

        <div class="weekly-grid">
          <div
            v-for="day in weekDays"
            :key="day.date"
            class="day-column"
          >
            <h4>{{ day.label }}</h4>
            <p class="date-label">{{ formatDate(day.date) }}</p>

            <div class="meal-slot" v-for="mealType in mealTypes" :key="mealType">
              <div class="meal-header">
                <strong>{{ mealType }}</strong>
                <button
                  class="add-btn"
                  @click="openMealSelector(day.date, mealType)"
                >
                  +
                </button>
              </div>
              <div
                v-for="meal in getMealsForDay(day.date, mealType)"
                :key="meal.id"
                class="planned-meal"
              >
                <span>{{ meal.name }}</span>
                <div class="meal-actions">
                  <span class="calories">{{ meal.calories }} kcal</span>
                  <button @click="removePlannedMeal(meal.id)" class="remove-btn">
                    ×
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Recipes Tab -->
      <div v-if="activeTab === 'recipes'" class="tab-content">
        <div class="recipes-header">
          <h2>My Recipes</h2>
          <button @click="showRecipeForm = true" class="create-btn">
            + Create Recipe
          </button>
        </div>

        <div class="recipes-grid">
          <div
            v-for="recipe in recipes"
            :key="recipe.id"
            class="recipe-card"
          >
            <h3>{{ recipe.name }}</h3>
            <p class="recipe-description">{{ recipe.description }}</p>
            <div class="recipe-stats">
              <span>🔥 {{ recipe.total_calories }} kcal</span>
              <span>🍖 {{ recipe.total_protein }}g protein</span>
              <span>🥖 {{ recipe.total_carbs }}g carbs</span>
              <span>🥑 {{ recipe.total_fat }}g fat</span>
            </div>
            <div class="recipe-actions">
              <button @click="viewRecipe(recipe)" class="view-btn">View</button>
              <button @click="addToFavorites(recipe)" class="fav-btn">⭐</button>
              <button @click="deleteRecipe(recipe.id)" class="delete-btn">
                Delete
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- Favorites Tab -->
      <div v-if="activeTab === 'favorites'" class="tab-content">
        <h2>⭐ Favorite Meals</h2>
        <p class="subtitle">Quick-add your most frequently eaten items</p>

        <div class="favorites-grid">
          <div
            v-for="fav in favorites"
            :key="fav.id"
            class="favorite-card"
          >
            <h3>{{ fav.name }}</h3>
            <p>{{ fav.calories }} kcal | P: {{ fav.protein }}g | C: {{ fav.carbs }}g | F: {{ fav.fat }}g</p>
            <div class="favorite-actions">
              <button @click="quickAddToToday(fav)" class="quick-add-btn">
                Quick Add to Today
              </button>
              <button @click="removeFavorite(fav.id)" class="remove-fav-btn">
                Remove
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- Shopping List Tab -->
      <div v-if="activeTab === 'shopping'" class="tab-content">
        <div class="shopping-header">
          <h2>🛒 Shopping List</h2>
          <button @click="generateShoppingList" class="generate-btn">
            Generate from Meal Plan
          </button>
        </div>

        <div class="shopping-list">
          <div v-if="shoppingList.length === 0" class="empty-state">
            <p>No items in shopping list. Generate from your meal plan!</p>
          </div>
          <div v-else>
            <div
              v-for="item in shoppingList"
              :key="item.id"
              class="shopping-item"
            >
              <input
                type="checkbox"
                v-model="item.checked"
                @change="updateShoppingItem(item)"
              />
              <span :class="{ checked: item.checked }">{{ item.ingredient }}</span>
              <button @click="removeShoppingItem(item.id)" class="remove-btn">
                ×
              </button>
            </div>
            <button @click="clearCheckedItems" class="clear-btn">
              Clear Checked Items
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Meal Selector Modal -->
    <div v-if="showMealSelector" class="modal-overlay" @click="closeMealSelector">
      <div class="modal-content" @click.stop>
        <h3>Add Meal to {{ selectedMealType }}</h3>
        <div class="meal-options">
          <h4>From Recipes</h4>
          <div class="option-list">
            <div
              v-for="recipe in recipes"
              :key="recipe.id"
              class="option-item"
              @click="addRecipeToPlanner(recipe)"
            >
              <span>{{ recipe.name }}</span>
              <span class="calories">{{ recipe.total_calories }} kcal</span>
            </div>
          </div>

          <h4>From Favorites</h4>
          <div class="option-list">
            <div
              v-for="fav in favorites"
              :key="fav.id"
              class="option-item"
              @click="addFavoriteToPlanner(fav)"
            >
              <span>{{ fav.name }}</span>
              <span class="calories">{{ fav.calories }} kcal</span>
            </div>
          </div>
        </div>
        <button @click="closeMealSelector" class="close-btn">Close</button>
      </div>
    </div>

    <!-- Recipe Form Modal -->
    <div v-if="showRecipeForm" class="modal-overlay" @click="closeRecipeForm">
      <div class="modal-content recipe-form" @click.stop>
        <h3>{{ editingRecipe ? 'Edit Recipe' : 'Create New Recipe' }}</h3>
        <form @submit.prevent="saveRecipe">
          <div class="form-group">
            <label>Recipe Name</label>
            <input v-model="recipeForm.name" required />
          </div>
          <div class="form-group">
            <label>Description</label>
            <textarea v-model="recipeForm.description" rows="3"></textarea>
          </div>

          <h4>Ingredients</h4>
          <div
            v-for="(ingredient, index) in recipeForm.ingredients"
            :key="index"
            class="ingredient-row"
          >
            <input
              v-model="ingredient.name"
              placeholder="Ingredient"
              required
            />
            <input
              v-model.number="ingredient.amount"
              type="number"
              placeholder="Amount"
              step="0.1"
            />
            <input v-model="ingredient.unit" placeholder="Unit" />
            <button
              type="button"
              @click="removeIngredient(index)"
              class="remove-btn"
            >
              ×
            </button>
          </div>
          <button type="button" @click="addIngredient" class="add-ingredient-btn">
            + Add Ingredient
          </button>

          <h4>Nutrition (Total)</h4>
          <div class="nutrition-inputs">
            <div class="form-group">
              <label>Calories</label>
              <input v-model.number="recipeForm.calories" type="number" required />
            </div>
            <div class="form-group">
              <label>Protein (g)</label>
              <input v-model.number="recipeForm.protein" type="number" step="0.1" />
            </div>
            <div class="form-group">
              <label>Carbs (g)</label>
              <input v-model.number="recipeForm.carbs" type="number" step="0.1" />
            </div>
            <div class="form-group">
              <label>Fat (g)</label>
              <input v-model.number="recipeForm.fat" type="number" step="0.1" />
            </div>
          </div>

          <div class="form-actions">
            <button type="submit" class="save-btn">Save Recipe</button>
            <button type="button" @click="closeRecipeForm" class="cancel-btn">
              Cancel
            </button>
          </div>
        </form>
      </div>
    </div>

    <!-- Recipe Detail Modal -->
    <div v-if="viewingRecipe" class="modal-overlay" @click="closeRecipeView">
      <div class="modal-content recipe-detail" @click.stop>
        <h2>{{ viewingRecipe.name }}</h2>
        <p>{{ viewingRecipe.description }}</p>

        <div class="recipe-nutrition">
          <h3>Nutrition Information</h3>
          <div class="nutrition-grid">
            <div class="nutrition-item">
              <span class="label">Calories</span>
              <span class="value">{{ viewingRecipe.total_calories }} kcal</span>
            </div>
            <div class="nutrition-item">
              <span class="label">Protein</span>
              <span class="value">{{ viewingRecipe.total_protein }}g</span>
            </div>
            <div class="nutrition-item">
              <span class="label">Carbs</span>
              <span class="value">{{ viewingRecipe.total_carbs }}g</span>
            </div>
            <div class="nutrition-item">
              <span class="label">Fat</span>
              <span class="value">{{ viewingRecipe.total_fat }}g</span>
            </div>
          </div>
        </div>

        <div class="recipe-ingredients">
          <h3>Ingredients</h3>
          <ul>
            <li v-for="(ing, idx) in viewingRecipe.ingredients" :key="idx">
              {{ ing.amount }} {{ ing.unit }} {{ ing.name }}
            </li>
          </ul>
        </div>

        <button @click="closeRecipeView" class="close-btn">Close</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from "vue";
import { useRouter } from "vue-router";
import { supabase } from "@/supabase";
import { userState } from "@/state/userState";
import Navbar from "@/components/Navbar.vue";

const router = useRouter();
const user = userState.user;

const activeTab = ref("planner");
const currentWeekOffset = ref(0);
const mealTypes = ["Breakfast", "Lunch", "Dinner", "Snack"];

// Data
const plannedMeals = ref([]);
const recipes = ref([]);
const favorites = ref([]);
const shoppingList = ref([]);

// Modals
const showMealSelector = ref(false);
const showRecipeForm = ref(false);
const viewingRecipe = ref(null);
const editingRecipe = ref(null);

const selectedDate = ref(null);
const selectedMealType = ref(null);

// Recipe Form
const recipeForm = ref({
  name: "",
  description: "",
  calories: 0,
  protein: 0,
  carbs: 0,
  fat: 0,
  ingredients: [{ name: "", amount: "", unit: "" }],
});

// Week calculation
const currentWeekStart = computed(() => {
  const today = new Date();
  const monday = new Date(today);
  monday.setDate(today.getDate() - today.getDay() + 1 + currentWeekOffset.value * 7);
  monday.setHours(0, 0, 0, 0);
  return monday;
});

const currentWeekDisplay = computed(() => {
  const start = new Date(currentWeekStart.value);
  const end = new Date(start);
  end.setDate(start.getDate() + 6);
  return `${start.toLocaleDateString("en-US", {
    month: "short",
    day: "numeric",
  })} - ${end.toLocaleDateString("en-US", { month: "short", day: "numeric", year: "numeric" })}`;
});

const weekDays = computed(() => {
  const days = [];
  const dayNames = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
  for (let i = 0; i < 7; i++) {
    const date = new Date(currentWeekStart.value);
    date.setDate(date.getDate() + i);
    days.push({
      label: dayNames[i],
      date: date.toISOString().split("T")[0],
    });
  }
  return days;
});

const changeWeek = (offset) => {
  currentWeekOffset.value += offset;
};

const formatDate = (dateStr) => {
  const date = new Date(dateStr);
  return date.toLocaleDateString("en-US", { month: "short", day: "numeric" });
};

// Fetch data
const fetchPlannedMeals = async () => {
  const { data } = await supabase
    .from("planned_meals")
    .select("*")
    .eq("user_id", user.id)
    .order("date", { ascending: true });
  plannedMeals.value = data || [];
};

const fetchRecipes = async () => {
  const { data } = await supabase
    .from("recipes")
    .select("*")
    .eq("user_id", user.id)
    .order("created_at", { ascending: false });
  recipes.value = data || [];
};

const fetchFavorites = async () => {
  const { data } = await supabase
    .from("favorite_meals")
    .select("*")
    .eq("user_id", user.id)
    .order("created_at", { ascending: false });
  favorites.value = data || [];
};

const fetchShoppingList = async () => {
  const { data } = await supabase
    .from("shopping_list")
    .select("*")
    .eq("user_id", user.id)
    .order("checked", { ascending: true });
  shoppingList.value = data || [];
};

// Meal planner functions
const getMealsForDay = (date, mealType) => {
  return plannedMeals.value.filter((m) => m.date === date && m.meal_type === mealType);
};

const openMealSelector = (date, mealType) => {
  selectedDate.value = date;
  selectedMealType.value = mealType;
  showMealSelector.value = true;
};

const closeMealSelector = () => {
  showMealSelector.value = false;
  selectedDate.value = null;
  selectedMealType.value = null;
};

const addRecipeToPlanner = async (recipe) => {
  const { data, error } = await supabase.from("planned_meals").insert([
    {
      user_id: user.id,
      date: selectedDate.value,
      meal_type: selectedMealType.value,
      name: recipe.name,
      calories: recipe.total_calories,
      protein: recipe.total_protein,
      carbs: recipe.total_carbs,
      fat: recipe.total_fat,
      recipe_id: recipe.id,
    },
  ]);
  
  if (error) {
    console.error("Error logging meal:", error);
    alert("Failed to log meal. Please try again.");
    return;
  }
  
  console.log("✅ Meal logged successfully! Stats should be updated automatically.");
  await fetchPlannedMeals();
  closeMealSelector();
};

const addFavoriteToPlanner = async (fav) => {
  const { data, error } = await supabase.from("planned_meals").insert([
    {
      user_id: user.id,
      date: selectedDate.value,
      meal_type: selectedMealType.value,
      name: fav.name,
      calories: fav.calories,
      protein: fav.protein,
      carbs: fav.carbs,
      fat: fav.fat,
      favorite_id: fav.id,
    },
  ]);
  
  if (error) {
    console.error("Error logging meal:", error);
    alert("Failed to log meal. Please try again.");
    return;
  }
  
  console.log("✅ Meal logged successfully! Stats should be updated automatically.");
  await fetchPlannedMeals();
  closeMealSelector();
};

const removePlannedMeal = async (id) => {
  await supabase.from("planned_meals").delete().eq("id", id);
  await fetchPlannedMeals();
};

// Recipe functions
const addIngredient = () => {
  recipeForm.value.ingredients.push({ name: "", amount: "", unit: "" });
};

const removeIngredient = (index) => {
  recipeForm.value.ingredients.splice(index, 1);
};

const saveRecipe = async () => {
  const recipeData = {
    user_id: user.id,
    name: recipeForm.value.name,
    description: recipeForm.value.description,
    total_calories: recipeForm.value.calories,
    total_protein: recipeForm.value.protein,
    total_carbs: recipeForm.value.carbs,
    total_fat: recipeForm.value.fat,
    ingredients: recipeForm.value.ingredients.filter((i) => i.name),
  };

  if (editingRecipe.value) {
    await supabase.from("recipes").update(recipeData).eq("id", editingRecipe.value.id);
  } else {
    await supabase.from("recipes").insert([recipeData]);
  }

  await fetchRecipes();
  closeRecipeForm();
};

const closeRecipeForm = () => {
  showRecipeForm.value = false;
  editingRecipe.value = null;
  recipeForm.value = {
    name: "",
    description: "",
    calories: 0,
    protein: 0,
    carbs: 0,
    fat: 0,
    ingredients: [{ name: "", amount: "", unit: "" }],
  };
};

const viewRecipe = (recipe) => {
  viewingRecipe.value = recipe;
};

const closeRecipeView = () => {
  viewingRecipe.value = null;
};

const deleteRecipe = async (id) => {
  if (confirm("Are you sure you want to delete this recipe?")) {
    await supabase.from("recipes").delete().eq("id", id);
    await fetchRecipes();
  }
};

// Favorites functions
const addToFavorites = async (recipe) => {
  const { error } = await supabase.from("favorite_meals").insert([
    {
      user_id: user.id,
      name: recipe.name,
      calories: recipe.total_calories,
      protein: recipe.total_protein,
      carbs: recipe.total_carbs,
      fat: recipe.total_fat,
    },
  ]);
  if (!error) {
    alert("Added to favorites!");
    await fetchFavorites();
  }
};

const quickAddToToday = async (fav) => {
  const today = new Date().toISOString().split("T")[0];
  await supabase.from("meals").insert([
    {
      user_id: user.id,
      name: fav.name,
      calories: fav.calories,
      date: today,
    }]);
  await supabase.from("nutrition").insert([
    {
      user_id: user.id,
      protein: fav.protein,
      carbs: fav.carbs,
      fat: fav.fat,
      calories: fav.calories,
      date: today,
    },
  ]);
  alert(`${fav.name} added to today's meals!`);
};

const removeFavorite = async (id) => {
  await supabase.from("favorite_meals").delete().eq("id", id);
  await fetchFavorites();
};

// Shopping list functions
const generateShoppingList = async () => {
  const startDate = weekDays.value[0].date;
  const endDate = weekDays.value[6].date;

  const mealsThisWeek = plannedMeals.value.filter(
    (m) => m.date >= startDate && m.date <= endDate && m.recipe_id
  );

  const recipeIds = [...new Set(mealsThisWeek.map((m) => m.recipe_id))];

  const { data: recipesData } = await supabase
    .from("recipes")
    .select("*")
    .in("id", recipeIds);

  const ingredientMap = {};
  recipesData?.forEach((recipe) => {
    recipe.ingredients?.forEach((ing) => {
      if (ingredientMap[ing.name]) {
        ingredientMap[ing.name] += parseFloat(ing.amount || 0);
      } else {
        ingredientMap[ing.name] = parseFloat(ing.amount || 0);
      }
    });
  });

  // Clear existing shopping list
  await supabase.from("shopping_list").delete().eq("user_id", user.id);

  // Add new items
  const items = Object.entries(ingredientMap).map(([name, amount]) => ({
    user_id: user.id,
    ingredient: `${amount.toFixed(1)} ${name}`,
    checked: false,
  }));

  if (items.length > 0) {
    await supabase.from("shopping_list").insert(items);
  }

  await fetchShoppingList();
  activeTab.value = "shopping";
};

const updateShoppingItem = async (item) => {
  await supabase
    .from("shopping_list")
    .update({ checked: item.checked })
    .eq("id", item.id);
};

const removeShoppingItem = async (id) => {
  await supabase.from("shopping_list").delete().eq("id", id);
  await fetchShoppingList();
};

const clearCheckedItems = async () => {
  await supabase.from("shopping_list").delete().eq("user_id", user.id).eq("checked", true);
  await fetchShoppingList();
};

onMounted(() => {
  fetchPlannedMeals();
  fetchRecipes();
  fetchFavorites();
  fetchShoppingList();
});
</script>

<style scoped>
.meal-planner-page {
  min-height: 100vh;
  background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
  padding: 2rem;
  font-family: "Poppins", sans-serif;
}

.meal-planner {
  max-width: 1400px;
  margin: 0 auto;
}

.planner-header {
  text-align: center;
  margin-bottom: 2rem;
}

.planner-header h1 {
  font-size: 2.5rem;
  color: #2c3e50;
  margin-bottom: 0.5rem;
}

.planner-header p {
  color: #7f8c8d;
  font-size: 1.1rem;
}

/* Tabs */
.tabs {
  display: flex;
  gap: 1rem;
  margin-bottom: 2rem;
  justify-content: center;
  flex-wrap: wrap;
}

.tabs button {
  padding: 0.75rem 1.5rem;
  border: none;
  background: white;
  border-radius: 25px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.tabs button.active {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
}

.tabs button:hover:not(.active) {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

/* Tab Content */
.tab-content {
  background: white;
  padding: 2rem;
  border-radius: 20px;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
}

/* Week Selector */
.week-selector {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 2rem;
  padding: 1rem;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 15px;
  color: white;
}

.week-selector button {
  background: rgba(255, 255, 255, 0.2);
  color: white;
  border: none;
  padding: 0.5rem 1rem;
  border-radius: 10px;
  cursor: pointer;
  font-weight: 600;
  transition: all 0.3s ease;
}

.week-selector button:hover {
  background: rgba(255, 255, 255, 0.3);
}

/* Weekly Grid */
.weekly-grid {
  display: grid;
  grid-template-columns: repeat(7, 1fr);
  gap: 1rem;
  overflow-x: auto;
}

.day-column {
  background: #f8f9fa;
  padding: 1rem;
  border-radius: 15px;
  min-width: 180px;
}

.day-column h4 {
  margin-bottom: 0.5rem;
  color: #2c3e50;
  font-size: 1rem;
}

.date-label {
  font-size: 0.85rem;
  color: #7f8c8d;
  margin-bottom: 1rem;
}

.meal-slot {
  margin-bottom: 1rem;
  padding: 0.75rem;
  background: white;
  border-radius: 10px;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
}

.meal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 0.5rem;
}

.meal-header strong {
  font-size: 0.9rem;
  color: #34495e;
}

.add-btn {
  background: #3498db;
  color: white;
  border: none;
  width: 24px;
  height: 24px;
  border-radius: 50%;
  cursor: pointer;
  font-size: 1.2rem;
  line-height: 1;
  transition: all 0.3s ease;
}

.add-btn:hover {
  background: #2980b9;
  transform: scale(1.1);
}

.planned-meal {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0.5rem;
  background: #e8f4f8;
  border-radius: 8px;
  margin-bottom: 0.5rem;
  font-size: 0.85rem;
}

.meal-actions {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.calories {
  font-size: 0.75rem;
  color: #7f8c8d;
}

.remove-btn {
  background: #e74c3c;
  color: white;
  border: none;
  width: 20px;
  height: 20px;
  border-radius: 50%;
  cursor: pointer;
  font-size: 1.2rem;
  line-height: 1;
  transition: all 0.3s ease;
}

.remove-btn:hover {
  background: #c0392b;
}

/* Recipes Grid */
.recipes-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 2rem;
}

.create-btn {
  background: linear-gradient(135deg, #27ae60 0%, #2ecc71 100%);
  color: white;
  border: none;
  padding: 0.75rem 1.5rem;
  border-radius: 25px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
}

.create-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(39, 174, 96, 0.4);
}

.recipes-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 1.5rem;
}

.recipe-card {
  background: white;
  padding: 1.5rem;
  border-radius: 15px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  transition: all 0.3s ease;
}

.recipe-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12);
}

.recipe-card h3 {
  margin-bottom: 0.5rem;
  color: #2c3e50;
}

.recipe-description {
  color: #7f8c8d;
  font-size: 0.9rem;
  margin-bottom: 1rem;
}

.recipe-stats {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 0.5rem;
  margin-bottom: 1rem;
  font-size: 0.85rem;
}

.recipe-actions {
  display: flex;
  gap: 0.5rem;
}

.view-btn,
.fav-btn,
.delete-btn {
  flex: 1;
  padding: 0.5rem;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-weight: 600;
  transition: all 0.3s ease;
}

.view-btn {
  background: #3498db;
  color: white;
}

.fav-btn {
  background: #f39c12;
  color: white;
}

.delete-btn {
  background: #e74c3c;
  color: white;
}

.view-btn:hover,
.fav-btn:hover,
.delete-btn:hover {
  transform: translateY(-2px);
}

/* Favorites Grid */
.subtitle {
  text-align: center;
  color: #7f8c8d;
  margin-bottom: 2rem;
}

.favorites-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 1.5rem;
}

.favorite-card {
  background: linear-gradient(135deg, #ffeaa7 0%, #fdcb6e 100%);
  padding: 1.5rem;
  border-radius: 15px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.favorite-card h3 {
  margin-bottom: 0.5rem;
  color: #2c3e50;
}

.favorite-card p {
  color: #2c3e50;
  margin-bottom: 1rem;
  font-size: 0.9rem;
}

.favorite-actions {
  display: flex;
  gap: 0.5rem;
}

.quick-add-btn,
.remove-fav-btn {
  flex: 1;
  padding: 0.5rem;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-weight: 600;
  transition: all 0.3s ease;
}

.quick-add-btn {
  background: #27ae60;
  color: white;
}

.remove-fav-btn {
  background: #e74c3c;
  color: white;
}

/* Shopping List */
.shopping-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 2rem;
}

.generate-btn {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border: none;
  padding: 0.75rem 1.5rem;
  border-radius: 25px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
}

.generate-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
}

.shopping-list {
  max-width: 600px;
  margin: 0 auto;
}

.empty-state {
  text-align: center;
  padding: 3rem;
  color: #7f8c8d;
}

.shopping-item {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 1rem;
  background: white;
  border-radius: 10px;
  margin-bottom: 0.5rem;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
}

.shopping-item input[type="checkbox"] {
  width: 20px;
  height: 20px;
  cursor: pointer;
}

.shopping-item span {
  flex: 1;
  transition: all 0.3s ease;
}

.shopping-item span.checked {
  text-decoration: line-through;
  color: #95a5a6;
}

.clear-btn {
  margin-top: 1rem;
  width: 100%;
  padding: 0.75rem;
  background: #e74c3c;
  color: white;
  border: none;
  border-radius: 10px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
}

.clear-btn:hover {
  background: #c0392b;
}

/* Modals */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.6);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
  overflow-y: auto;
  padding: 2rem;
}

.modal-content {
  background: white;
  padding: 2rem;
  border-radius: 20px;
  max-width: 600px;
  width: 100%;
  max-height: 90vh;
  overflow-y: auto;
}

.modal-content h3 {
  margin-bottom: 1.5rem;
  color: #2c3e50;
}

.option-list {
  margin-bottom: 1.5rem;
}

.option-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem;
  background: #f8f9fa;
  border-radius: 10px;
  margin-bottom: 0.5rem;
  cursor: pointer;
  transition: all 0.3s ease;
}

.option-item:hover {
  background: #e9ecef;
  transform: translateX(5px);
}

.close-btn {
  width: 100%;
  padding: 0.75rem;
  background: #95a5a6;
  color: white;
  border: none;
  border-radius: 10px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
}

.close-btn:hover {
  background: #7f8c8d;
}

/* Recipe Form */
.recipe-form {
  max-width: 700px;
}

.form-group {
  margin-bottom: 1rem;
}

.form-group label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: 600;
  color: #2c3e50;
}

.form-group input,
.form-group textarea {
  width: 100%;
  padding: 0.75rem;
  border: 1px solid #ddd;
  border-radius: 10px;
  font-family: inherit;
}

.ingredient-row {
  display: grid;
  grid-template-columns: 2fr 1fr 1fr auto;
  gap: 0.5rem;
  margin-bottom: 0.5rem;
}

.ingredient-row input {
  padding: 0.5rem;
  border: 1px solid #ddd;
  border-radius: 8px;
}

.add-ingredient-btn {
  background: #3498db;
  color: white;
  border: none;
  padding: 0.5rem 1rem;
  border-radius: 8px;
  cursor: pointer;
  margin-bottom: 1rem;
}

.nutrition-inputs {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 1rem;
  margin-bottom: 1rem;
}

.form-actions {
  display: flex;
  gap: 1rem;
  margin-top: 2rem;
}

.save-btn,
.cancel-btn {
  flex: 1;
  padding: 0.75rem;
  border: none;
  border-radius: 10px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
}

.save-btn {
  background: linear-gradient(135deg, #27ae60 0%, #2ecc71 100%);
  color: white;
}

.cancel-btn {
  background: #95a5a6;
  color: white;
}

/* Recipe Detail */
.recipe-detail {
  max-width: 700px;
}

.recipe-nutrition {
  margin: 2rem 0;
}

.nutrition-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 1rem;
  margin-top: 1rem;
}

.nutrition-item {
  background: #f8f9fa;
  padding: 1rem;
  border-radius: 10px;
  text-align: center;
}

.nutrition-item .label {
  display: block;
  color: #7f8c8d;
  font-size: 0.9rem;
  margin-bottom: 0.5rem;
}

.nutrition-item .value {
  display: block;
  font-size: 1.5rem;
  font-weight: 700;
  color: #2c3e50;
}

.recipe-ingredients ul {
  list-style: none;
  padding: 0;
}

.recipe-ingredients li {
  padding: 0.75rem;
  background: #f8f9fa;
  border-radius: 8px;
  margin-bottom: 0.5rem;
}

/* Responsive */
@media (max-width: 1200px) {
  .weekly-grid {
    grid-template-columns: repeat(3, 1fr);
  }
}

@media (max-width: 768px) {
  .weekly-grid {
    grid-template-columns: 1fr;
  }

  .tabs {
    gap: 0.5rem;
  }

  .tabs button {
    padding: 0.5rem 1rem;
    font-size: 0.9rem;
  }

  .week-selector {
    flex-direction: column;
    gap: 1rem;
  }

  .nutrition-inputs {
    grid-template-columns: 1fr;
  }

  .ingredient-row {
    grid-template-columns: 1fr;
  }
}
</style>
