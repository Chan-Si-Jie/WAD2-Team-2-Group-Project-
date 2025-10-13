<template>
  <nav class="navbar">
    <h1 @click="$router.push('/')">SmartCal</h1>
    <ul class="nav-links">
      <li><a @click="$router.push('/')">Home</a></li>
      <li><a href="#features">Features</a></li>
      <li><a href="#about">About</a></li>
      <li><a href="#contact">Contact</a></li>
      <li>
        <button class="login-btn" @click="$router.push('/login')">Login</button>
      </li>
    </ul>
  </nav>
</template>

<style scoped>
.navbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background-color: #007bff;
  padding: 0.8rem 2rem;
  color: white;
}

.navbar h1 {
  cursor: pointer;
}

.nav-links {
  list-style: none;
  display: flex;
  align-items: center;
  gap: 1.5rem;
  margin: 0;
  padding: 0;
}

.nav-links li a {
  color: white;
  text-decoration: none;
  font-weight: 600;
}

.login-btn {
  background-color: white;
  color: #007bff;
  border: none;
  padding: 0.4rem 1rem;
  border-radius: 8px;
  cursor: pointer;
  font-weight: 600;
}

.login-btn:hover {
  background-color: #e6e6e6;
  color: #0056b3;
}

@media (max-width: 768px) {
  .nav-links {
    flex-direction: column;
    gap: 1rem;
  }
}
</style>
