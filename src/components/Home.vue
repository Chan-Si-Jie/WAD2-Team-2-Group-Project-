<template>
  <div class="home-page"> <!-- NAVBAR -->
    <Navbar /> <!-- HERO SECTION -->
    <section class="hero">
      <div class="hero-content">
        <div class="hero-text">
          <h1>Track Your Calories Effortlessly</h1>
          <p> SmartCal helps you log meals, track nutrition, and reach your health goals — all through a simple, fun,
            and visual experience. </p> <button @click="$router.push('/log')" class="cta-btn">Get Started</button>
        </div>
        <div class="hero-img"> <img src="https://cdn-icons-png.flaticon.com/512/3075/3075977.png" alt="Healthy food"
            class="hero-image" /> </div>
      </div>
    </section> <!-- FEATURES SECTION -->
    <section class="features" id="features">
      <h2>Features</h2>
      <div class="feature-grid">
        <div class="card"> <img src="https://cdn-icons-png.flaticon.com/512/1046/1046784.png" alt="Food logging" />
          <h3>Easy Food Logging</h3>
          <p>Log your meals in seconds using our vast food database or add your own recipes.</p>
        </div>
        <div class="card"> <img src="https://cdn-icons-png.flaticon.com/512/1046/1046790.png" alt="Progress" />
          <h3>Visual Progress</h3>
          <p>Track weekly calorie and macro trends with clean, easy-to-read charts.</p>
        </div>
        <div class="card"> <img src="https://cdn-icons-png.flaticon.com/512/1046/1046786.png" alt="Goal setting" />
          <h3>Goal Setting</h3>
          <p>Stay motivated with personalized calorie and nutrition goals tailored for you.</p>
        </div>
        <div class="card"> <img src="https://cdn-icons-png.flaticon.com/512/1046/1046796.png" alt="Secure accounts" />
          <h3>Secure Accounts</h3>
          <p>Your progress and logs are stored securely and accessible anytime, anywhere.</p>
        </div>
      </div>
    </section>
    <!-- ABOUT SECTION -->
    <section class="about" id="about">
      <div class="about-container">
        <div class="about-text">
          <h2>About</h2>
          <p>
            <strong>SmartCal</strong> is your personal calorie tracker that makes healthy eating simple.
            Log meals, monitor your daily calorie intake, and get <strong>AI-powered recommendations</strong> to reach
            your nutrition goals. With clear insights into your eating habits, SmartCal helps you make smarter choices
            and stay on
            track—effortlessly.
          </p>
        </div>
        <div class="about-image">
          <img src="https://cdn-icons-png.flaticon.com/512/2316/2316949.png" alt="Healthy eating illustration">
        </div>
      </div>
    </section>
    <!-- CONTACT SECTION -->
    <section class="contact" id="contact">
      <div class="container contact-container">
        <h2>Contact Us</h2>
        <p>
          Have questions, feedback, or need support? We'd love to hear from you!
          Reach out through any of the channels below or send us a message directly.
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
      <div class="footer-bottom"> &copy; 2025 SmartCal. All rights reserved. </div>
    </footer>
  </div>
</template>
<script setup>import Navbar from "../components/Navbar.vue"; </script>
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
  /* prevent horizontal scroll */
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
  transition: transform 0.28s cubic-bezier(.2, .9, .3, 1), box-shadow 0.28s;
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
  box-shadow: 0 10px 25px rgba(0,0,0,0.08);
  animation: float 4s ease-in-out infinite;
}

@keyframes float {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-10px); }
}

/* Responsive */
@media (max-width: 768px) {
  .about-container {
    flex-direction: column;
    text-align: center;
    gap: 30px;
  }

  .about-image img {
    max-width: 80%;
  }
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

/* Grid layout */
.contact-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 10px;
}

.contact-info {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.info-card {
  display: flex;
  align-items: center;
  gap: 15px;
  background: white;
  padding: 20px;
  border-radius: 12px;
  box-shadow: 0 6px 12px rgba(0, 0, 0, 0.08);
  transition: transform 0.3s ease;
}

.info-card:hover {
  transform: translateY(-5px);
}



.info-card h4 {
  margin: 0;
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

/* Contact form */
.contact-form form {
  display: flex;
  flex-direction: column;
  gap: 15px;
  background: white;
  padding: 30px;
  border-radius: 12px;
  box-shadow: 0 6px 12px rgba(0, 0, 0, 0.08);
}

.contact-form input,
.contact-form textarea {
  padding: 12px 15px;
  border: 1px solid #ccc;
  border-radius: 8px;
  font-size: 1rem;
  resize: none;
}

.contact-form button {
  padding: 12px 20px;
  background: #27ae60;
  color: white;
  font-weight: 600;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.contact-form button:hover {
  background: #1e874b;
  transform: translateY(-2px);
}

.contact-info {
  display: flex;
  flex-direction: column;
  gap: 20px;
  align-items: center;
  /* centers the cards horizontally */
}

.info-card {
  display: flex;
  flex-direction: column;
  /* stack icon + text vertically */
  align-items: center;
  /* center the content inside the card */
  justify-content: center;
  /* vertical alignment if needed */
  width: 500px;
  /* fixed width */
  background: white;
  padding: 20px;
  border-radius: 12px;
  box-shadow: 0 6px 12px rgba(0, 0, 0, 0.08);
  transition: transform 0.3s ease;
  text-align: center;
  /* ensures text inside is centered */
}

.info-card i {
  font-size: 1.5rem;
  color: #27ae60;
  width: 50px;
  height: 50px;
  background: #e0f7ea;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 12px;
  /* spacing between icon and text */
}

.info-card h4 {
  margin-bottom: 6px;
  font-size: 1rem;
  font-weight: 600;
}

.info-card a {
  color: #27ae60;
  text-decoration: none;
}

.info-card a:hover {
  text-decoration: underline;
}


/* Responsive adjustments */
@media (max-width: 768px) {
  .contact-grid {
    grid-template-columns: 1fr;
    gap: 30px;
  }
}


/* FOOTER */
footer {
  background: linear-gradient(135deg, #27ae60, #20c997);
  color: white;
  width: 100%;
  font-family: 'Poppins', sans-serif;
}

/* RESPONSIVE */
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
  }

  .contact-list {
    flex-direction: row;
    justify-content: center;
    gap: 2.5rem;
  }
}

@media (max-width: 768px) {
  .hero-content {
    gap: 30px;
  }

  .footer-container {
    flex-direction: column;
    align-items: center;
    text-align: center;
  }

  .footer-section {
    flex: 1 1 100%;
  }

  .social-icons {
    justify-content: center;
  }
}
</style>
