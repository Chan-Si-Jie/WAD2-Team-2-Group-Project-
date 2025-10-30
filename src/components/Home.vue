<template>
  <div class="home-page">
    <!-- NAVBAR -->
    <Navbar />

    <!-- HERO SECTION -->
    <section class="hero">
      <div class="hero-content">
        <div class="hero-text">
          <h1>Track Your Calories Effortlessly</h1>
          <p>
            SmartCal helps you log meals, track nutrition, and reach your health goals — 
            all through a simple, fun, and visual experience.
          </p>
          <button @click="$router.push('/log')" class="cta-btn">Get Started</button>
        </div>
        <div class="hero-img">
          <img
            src="https://cdn-icons-png.flaticon.com/512/3075/3075977.png"
            alt="Healthy food"
            class="hero-image"
          />
        </div>
      </div>
    </section>

    <!-- FEATURES SECTION -->
    <section class="features" id="features">
      <h2>Features</h2>
      <div class="feature-grid">
        <div class="card">
          <img src="https://cdn-icons-png.flaticon.com/512/1046/1046784.png" alt="Food logging" />
          <h3>Easy Food Logging</h3>
          <p>Log your meals in seconds using our vast food database or add your own recipes.</p>
        </div>

        <div class="card">
          <img src="https://cdn-icons-png.flaticon.com/512/1046/1046790.png" alt="Progress" />
          <h3>Visual Progress</h3>
          <p>Track weekly calorie and macro trends with clean, easy-to-read charts.</p>
        </div>

        <div class="card">
          <img src="https://cdn-icons-png.flaticon.com/512/1046/1046786.png" alt="Goal setting" />
          <h3>Goal Setting</h3>
          <p>Stay motivated with personalized calorie and nutrition goals tailored for you.</p>
        </div>

        <div class="card">
          <img src="https://cdn-icons-png.flaticon.com/512/1046/1046796.png" alt="Secure accounts" />
          <h3>Secure Accounts</h3>
          <p>Your progress and logs are stored securely and accessible anytime, anywhere.</p>
        </div>
      </div>
    </section>

    <!-- ABOUT SECTION -->
    <section class="about" id="about">
      <div class="container">
        <h2>About</h2>
        <p>
          <strong>SmartCal</strong> is an intuitive calorie tracking app developed by a passionate team of students
          from <strong>SMU</strong> as part of our Web Application Development course.
          Our mission is to empower individuals to live healthier lives by making nutrition tracking
          <em>simple, fun, and visually engaging</em>.
          (And yes, we wouldn’t mind scoring well for this project too 😄)
          We hope you enjoy using <strong>SmartCal</strong> as much as we enjoyed building it!
        </p>
      </div>
    </section>

    <!-- CONTACT SECTION -->
    <section class="contact" id="contact">
      <div class="container">
        <h2>Contact Us</h2>
        <p>
          Have questions, feedback, or need support? We'd love to hear from you!
          Reach out through any of the channels below:
        </p>
        <ul class="contact-list">
          <li><i class="fas fa-envelope"></i> <a href="mailto:hello@smartcal.com">hello@smartcal.com</a></li>
          <li><i class="fas fa-phone"></i> <a href="tel:+6598888999">+65 9888 8999</a></li>
          <li><i class="fas fa-map-marker-alt"></i> 80 Stamford Rd, Singapore 178902</li>
        </ul>
      </div>
    </section>

    <!-- FOOTER -->
    <footer>
      &copy; 2025 SmartCal. All rights reserved.
    </footer>
  </div>
</template>

<script setup>
import Navbar from "../components/Navbar.vue";
</script>

<style>
@import url("https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap");

/* Global */
body {
  font-family: "Poppins", sans-serif;
  margin: 0;
  color: #2c3e50;
}

/* HERO SECTION */
.hero {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 100px 20px;
  background: linear-gradient(135deg, #e0f7fa, #c8f6e0);
}

.hero-content {
  display: flex;
  flex-direction: column;
  gap: 40px;
  align-items: center;
  max-width: 1100px;
}

.hero-text {
  text-align: center;
}

.hero-text h1 {
  font-size: 2.5rem;
  font-weight: 700;
  color: #2c3e50;
}

.hero-text p {
  margin: 15px 0 30px;
  font-size: 1.1rem;
  color: #555;
  line-height: 1.6;
}

.cta-btn {
  background: #27ae60;
  color: white;
  border: none;
  padding: 14px 32px;
  border-radius: 30px;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
}

.cta-btn:hover {
  background: #1e874b;
  transform: translateY(-3px);
}

.hero-image {
  width: 280px;
  max-width: 90%;
  animation: float 3s ease-in-out infinite;
}

@keyframes float {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-10px); }
}

/* FEATURES SECTION */
.features {
  background: #fff;
  padding: 100px 20px;
}

.features h2 {
  text-align: center;
  font-size: 2.2rem;
  margin-bottom: 2rem;
  color: #2c3e50;
}

.feature-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(230px, 1fr));
  gap: 2rem;
  max-width: 1100px;
  margin: 0 auto;
}

.card {
  background: #f8f9fa;
  border-radius: 16px;
  padding: 30px 20px;
  text-align: center;
  transition: all 0.3s ease;
  box-shadow: 0 4px 8px rgba(0,0,0,0.05);
}

.card:hover {
  transform: translateY(-8px);
  box-shadow: 0 8px 18px rgba(0,0,0,0.1);
}

.card img {
  width: 70px;
  margin-bottom: 15px;
}

.card h3 {
  margin-bottom: 10px;
  color: #27ae60;
}

.card p {
  color: #555;
  line-height: 1.6;
}

/* ABOUT SECTION */
.about {
  background: linear-gradient(135deg, #f0f9ff, #e0f7fa);
  padding: 100px 20px;
  text-align: center;
}

.about .container {
  max-width: 900px;
  margin: 0 auto;
}

.about p {
  font-size: 1.05rem;
  line-height: 1.8;
  color: #34495e;
}

/* CONTACT SECTION */
.contact {
  background: #ffffff;
  padding: 100px 20px;
  text-align: center;
}

.contact .container {
  max-width: 900px;
  margin: 0 auto;
}

.contact-list {
  list-style: none;
  padding: 0;
  margin-top: 2rem;
  display: flex;
  flex-direction: column;
  gap: 1rem;
  align-items: center;
}

.contact-list li {
  font-size: 1.1rem;
}

.contact-list a {
  color: #27ae60;
  text-decoration: none;
  font-weight: 500;
}

.contact-list a:hover {
  text-decoration: underline;
}

.contact-list i {
  margin-right: 8px;
  color: #27ae60;
}

@media (min-width: 768px) {
  .hero-content {
    flex-direction: row;
    text-align: left;
    gap: 60px;
  }

  .hero-text {
    flex: 1;
  }

  .hero-img {
    flex: 1;
    display: flex;
    justify-content: center;
  }

  .contact-list {
    flex-direction: row;
    justify-content: center;
    gap: 2.5rem;
  }
}

/* FOOTER */
footer {
  background: #2c3e50;
  color: white;
  text-align: center;
  padding: 25px 10px;
  font-size: 0.9rem;
}
</style>
