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
            SmartCal helps you log meals, track nutrition, and reach your health
            goals — all through a simple, fun, and visual experience.
          </p>
          <div class="button-group">
            <button @click="$router.push('/dashboard')" class="cta-btn">
              Get Started
            </button>
            <button @click="$router.push('/fitness')" class="fitness-btn">
              Go to Fitness Tracker
            </button>
          </div>
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
          <img
            src="https://cdn-icons-png.flaticon.com/512/1046/1046784.png"
            alt="Food logging"
          />
          <h3>Easy Food Logging</h3>
          <p>
            Log your meals in seconds using our vast food database or add your
            own recipes.
          </p>
        </div>
        <div class="card">
          <img
            src="https://cdn-icons-png.flaticon.com/512/1046/1046790.png"
            alt="Progress"
          />
          <h3>Visual Progress</h3>
          <p>
            Track weekly calorie and macro trends with clean, easy-to-read
            charts.
          </p>
        </div>
        <div class="card">
          <img
            src="https://cdn-icons-png.flaticon.com/512/1046/1046786.png"
            alt="Goal setting"
          />
          <h3>Goal Setting</h3>
          <p>
            Stay motivated with personalized calorie and nutrition goals
            tailored for you.
          </p>
        </div>
        <div class="card">
          <img
            src="https://cdn-icons-png.flaticon.com/512/1046/1046796.png"
            alt="Secure accounts"
          />
          <h3>Secure Accounts</h3>
          <p>
            Your progress and logs are stored securely and accessible anytime,
            anywhere.
          </p>
        </div>
      </div>
    </section>

    <!-- ABOUT SECTION -->
    <section class="about" id="about">
      <div class="about-container">
        <div class="about-text">
          <h2>About</h2>
          <p>
            <strong>SmartCal</strong> is your personal calorie tracker that
            makes healthy eating simple. Log meals, monitor your daily calorie
            intake, and get <strong>AI-powered recommendations</strong> to reach
            your nutrition goals. With clear insights into your eating habits,
            SmartCal helps you make smarter choices and stay on
            track—effortlessly.
          </p>
        </div>
        <div class="about-image">
          <img
            src="https://cdn-icons-png.flaticon.com/512/2316/2316949.png"
            alt="Healthy eating illustration"
          />
        </div>
      </div>
    </section>

    <!-- CONTACT SECTION -->
    <section class="contact" id="contact">
      <div class="container contact-container">
        <h2>Contact Us</h2>
        <p>
          Have questions, feedback, or need support? We'd love to hear from you!
          Reach out through any of the channels below or send us a message
          directly.
        </p>

        <div class="contact-grid">
          <!-- Contact Info -->
          <div class="contact-info">
            <div class="info-card">
              <div>
                <h4>Email</h4>
                <a href="mailto:hello@smartcal.com">hello@smartcal.com</a>
              </div>
            </div>
            <div class="info-card">
              <div>
                <h4>Phone</h4>
                <a href="tel:+6598888999">+65 9888 8999</a>
              </div>
            </div>
            <div class="info-card">
              <div>
                <h4>Address</h4>
                80 Stamford Rd, Singapore 178902
              </div>
            </div>
          </div>

          <!-- Contact Form -->
          <div class="contact-form">
            <form>
              <input type="text" placeholder="Your Name" required />
              <input type="email" placeholder="Your Email" required />
              <textarea rows="5" placeholder="Your Message" required></textarea>
              <button type="submit">Send Message</button>
            </form>
          </div>
        </div>
      </div>
    </section>

    <!-- FOOTER -->
    <footer>
      <div class="footer-bottom">
        &copy; 2025 SmartCal. All rights reserved.
      </div>
    </footer>
  </div>
</template>

<script setup>
import Navbar from "../components/Navbar.vue";
</script>

<style>
@import url("https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap");

/* GLOBAL RESET AND BOX-SIZING */
* {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

html,
body {
  width: 100%;
  overflow-x: hidden;
  font-family: "Poppins", sans-serif;
  color: #2c3e50;
}

/* HERO SECTION */
.hero {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 100px 20px;
  background: linear-gradient(135deg, #e0f7fa, #c8f6e0);
  width: 100%;
}

.hero-content {
  display: flex;
  flex-direction: column;
  gap: 40px;
  max-width: 1100px;
  width: 100%;
  margin: 0 auto;
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

.button-group {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 10px;
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

.fitness-btn {
  background: #007bff;
  color: white;
  border: none;
  padding: 12px 28px;
  border-radius: 30px;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
}

.fitness-btn:hover {
  background: #0056b3;
  transform: translateY(-3px);
}

.hero-img {
  display: flex;
  justify-content: center;
}

.hero-image {
  width: 100%;
  max-width: 280px;
  height: auto;
  animation: float 3s ease-in-out infinite;
}

@keyframes float {
  0%,
  100% {
    transform: translateY(0);
  }

  50% {
    transform: translateY(-10px);
  }
}

/* FEATURES SECTION */
.features {
  background: #fff;
  padding: 100px 20px;
  width: 100%;
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
  width: 100%;
  margin: 0 auto;
  padding: 0 10px;
}

.card {
  border-radius: 16px;
  padding: 30px 20px;
  text-align: center;
  transition: transform 0.28s cubic-bezier(0.2, 0.9, 0.3, 1), box-shadow 0.28s;
  box-shadow: 0 6px 14px rgba(0, 0, 0, 0.06);
  color: #fff;
}

.feature-grid .card:nth-child(1) {
  background: linear-gradient(135deg, #27ae60, #2ecc71);
}

.feature-grid .card:nth-child(2) {
  background: linear-gradient(135deg, #ff7b54, #ff9a76);
}

.feature-grid .card:nth-child(3) {
  background: linear-gradient(135deg, #5b8def, #7fb3ff);
}

.feature-grid .card:nth-child(4) {
  background: linear-gradient(135deg, #f6c85f, #ffd97a);
  color: #2c3e50;
}

.card img {
  width: 70px;
  margin-bottom: 15px;
  filter: drop-shadow(0 4px 8px rgba(0, 0, 0, 0.12));
}

.card h3 {
  margin-bottom: 10px;
  font-weight: 700;
  color: inherit;
}

.card p {
  line-height: 1.6;
  color: inherit;
}

.card:hover {
  transform: translateY(-10px);
  box-shadow: 0 18px 40px rgba(0, 0, 0, 0.15);
}

/* ABOUT SECTION */
.about {
  padding: 80px 20px;
  background: linear-gradient(135deg, #f0f9ff, #e0f7fa);
  width: 100%;
}

.about-container {
  display: flex;
  align-items: center;
  justify-content: space-between;
  max-width: 1100px;
  margin: 0 auto;
  gap: 40px;
}

.about-text {
  flex: 1;
}

.about-text h2 {
  font-size: 2.2rem;
  margin-bottom: 20px;
  color: #2c3e50;
}

.about-text p {
  font-size: 1.1rem;
  line-height: 1.7;
  color: #34495e;
}

.about-image {
  flex: 1;
  display: flex;
  justify-content: center;
}

.about-image img {
  max-width: 100%;
  height: auto;
  border-radius: 16px;
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.08);
  animation: float 4s ease-in-out infinite;
}

/* CONTACT SECTION */
.contact {
  background: #f9f9f9;
  padding: 100px 20px;
  text-align: center;
  width: 100%;
}

.contact-container {
  max-width: 1300px;
  margin: 0 auto;
}

.contact h2 {
  font-size: 2.2rem;
  margin-bottom: 15px;
  color: #2c3e50;
}

.contact p {
  color: #555;
  margin-bottom: 40px;
  font-size: 1rem;
  line-height: 1.6;
}

.contact-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 10px;
}

.contact-info {
  display: flex;
  flex-direction: column;
  gap: 20px;
  align-items: center;
}

.info-card {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  width: 500px;
  background: white;
  padding: 20px;
  border-radius: 12px;
  box-shadow: 0 6px 12px rgba(0, 0, 0, 0.08);
  transition: transform 0.3s ease;
  text-align: center;
}

.info-card:hover {
  transform: translateY(-5px);
}

.info-card h4 {
  margin-bottom: 6px;
  font-size: 1rem;
  font-weight: 600;
  color: #2c3e50;
}

.info-card a {
  color: #27ae60;
  text-decoration: none;
}

.info-card a:hover {
  text-decoration: underline;
}

/* Responsive */
@media (max-width: 768px) {
  .hero-content {
    gap: 30px;
  }

  .about-container {
    flex-direction: column;
    text-align: center;
    gap: 30px;
  }

  .about-image img {
    max-width: 80%;
  }

  .contact-grid {
    grid-template-columns: 1fr;
    gap: 30px;
  }
}

footer {
  background: linear-gradient(135deg, #27ae60, #20c997);
  color: white;
  text-align: center;
  padding: 20px;
}
</style>
