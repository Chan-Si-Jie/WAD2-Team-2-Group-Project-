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
              Start your fitness journey!👉
            </button>
          </div>
        </div>
        <div class="hero-img">
          <AnimatedModel />
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
        <div class="contact-header">
          <h2>Get In Touch</h2>
          <p>
            Have questions, feedback, or need support? We'd love to hear from
            you! Reach out through any of the channels below or send us a
            message directly.
          </p>
        </div>

        <div class="contact-grid">
          <!-- Contact Info Cards -->
          <div class="contact-info">
            <div class="info-card email-card">
              <div class="icon-wrapper">
                <i class="fas fa-envelope"></i>
              </div>
              <h4>Email Us</h4>
              <a href="mailto:jaykinchan@gmail.com">jaykinchan@gmail.com</a>
              <p class="info-desc">We'll respond within 24 hours</p>
            </div>

            <div class="info-card phone-card">
              <div class="icon-wrapper">
                <i class="fas fa-phone-alt"></i>
              </div>
              <h4>Call Us</h4>
              <a href="tel:+6598888999">+65 9888 8999</a>
              <p class="info-desc">Mon-Fri, 9AM-6PM SGT</p>
            </div>

            <div class="info-card location-card">
              <div class="icon-wrapper">
                <i class="fas fa-map-marker-alt"></i>
              </div>
              <h4>Visit Us</h4>
              <p>80 Stamford Rd<br />Singapore 178902</p>
              <p class="info-desc">Find us at the heart of the city</p>
            </div>
          </div>

          <!-- Contact Form -->
          <div class="contact-form-wrapper">
            <div class="form-header">
              <h3>Send us a Message</h3>
              <p>Fill out the form below and we'll get back to you shortly</p>
            </div>
            <form class="contact-form" @submit.prevent="handleSubmit">
              <div class="form-group">
                <label for="name">
                  <i class="fas fa-user"></i> Your Name
                </label>
                <input
                  type="text"
                  id="name"
                  v-model="contactForm.name"
                  placeholder="John Doe"
                  required
                />
              </div>

              <div class="form-group">
                <label for="email">
                  <i class="fas fa-envelope"></i> Your Email
                </label>
                <input
                  type="email"
                  id="email"
                  v-model="contactForm.email"
                  placeholder="john@example.com"
                  required
                />
              </div>

              <div class="form-group">
                <label for="message">
                  <i class="fas fa-comment-dots"></i> Your Message
                </label>
                <textarea
                  id="message"
                  v-model="contactForm.message"
                  rows="5"
                  placeholder="Tell us how we can help you..."
                  required
                ></textarea>
              </div>

              <button type="submit" class="submit-btn" :disabled="sending">
                <span>{{ sending ? "Sending..." : "Send Message" }}</span>
                <i class="fas fa-paper-plane"></i>
              </button>

              <div
                v-if="submitMessage"
                class="submit-message"
                :class="submitSuccess ? 'success' : 'error'"
              >
                {{ submitMessage }}
              </div>
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
import { ref } from "vue";
import Navbar from "../components/Navbar.vue";
import AnimatedModel from "../components/AnimatedModel.vue";

const API_BASE_URL = import.meta.env.VITE_API_URL || "http://localhost:3000";

const contactForm = ref({
  name: "",
  email: "",
  message: "",
});

const sending = ref(false);
const submitMessage = ref("");
const submitSuccess = ref(false);

const handleSubmit = async () => {
  sending.value = true;
  submitMessage.value = "";
  submitSuccess.value = false;

  try {
    const response = await fetch(`${API_BASE_URL}/api/contact/send`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(contactForm.value),
    });

    const data = await response.json();

    if (response.ok && data.success) {
      submitSuccess.value = true;
      submitMessage.value =
        data.message ||
        "Thank you for your message! We've sent a confirmation email to you.";

      // Reset form
      contactForm.value = {
        name: "",
        email: "",
        message: "",
      };
    } else {
      submitSuccess.value = false;
      submitMessage.value =
        data.error || "Failed to send message. Please try again.";
    }
  } catch (error) {
    console.error("Error sending contact form:", error);
    submitSuccess.value = false;
    submitMessage.value = "An error occurred. Please try again later.";
  } finally {
    sending.value = false;

    // Clear message after 5 seconds
    setTimeout(() => {
      submitMessage.value = "";
    }, 5000);
  }
};
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

.home-page {
  width: 100%;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
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
  align-items: center;
  gap: 40px;
  max-width: 1100px;
  width: 100%;
  margin: 0 auto;
}

.hero-text {
  text-align: center;
  width: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.hero-text h1 {
  font-size: 2.5rem;
  font-weight: 700;
  color: #2c3e50;
}

.hero-text p {
  margin: 15px auto 30px;
  font-size: 1.1rem;
  color: #555;
  line-height: 1.6;
  max-width: 700px;
  text-align: center;
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
  width: 100%;
  max-width: 600px;
  min-height: 400px;
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
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 100px 20px;
  width: 100%;
  position: relative;
  overflow: hidden;
}

.contact::before {
  content: "";
  position: absolute;
  top: -50%;
  left: -50%;
  width: 200%;
  height: 200%;
  background: radial-gradient(
    circle,
    rgba(255, 255, 255, 0.1) 1px,
    transparent 1px
  );
  background-size: 50px 50px;
  animation: float 20s linear infinite;
}

.contact-container {
  max-width: 1200px;
  margin: 0 auto;
  position: relative;
  z-index: 1;
}

.contact-header {
  text-align: center;
  margin-bottom: 60px;
}

.contact-header h2 {
  font-size: 2.5rem;
  margin-bottom: 15px;
  color: white;
  font-weight: 700;
}

.contact-header p {
  color: rgba(255, 255, 255, 0.9);
  font-size: 1.1rem;
  line-height: 1.6;
  max-width: 700px;
  margin: 0 auto;
}

.contact-grid {
  display: grid;
  grid-template-columns: 1fr 1.5fr;
  gap: 40px;
  align-items: start;
}

/* Contact Info Cards */
.contact-info {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.info-card {
  background: white;
  padding: 30px;
  border-radius: 20px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
  transition: all 0.3s ease;
  text-align: center;
  position: relative;
  overflow: hidden;
}

.info-card::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(90deg, #667eea, #764ba2);
  transform: scaleX(0);
  transition: transform 0.3s ease;
}

.info-card:hover::before {
  transform: scaleX(1);
}

.info-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 15px 40px rgba(0, 0, 0, 0.25);
}

.icon-wrapper {
  width: 60px;
  height: 60px;
  margin: 0 auto 15px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24px;
  color: white;
  background: linear-gradient(135deg, #667eea, #764ba2);
  box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
}

.info-card h4 {
  margin-bottom: 10px;
  font-size: 1.2rem;
  font-weight: 600;
  color: #2c3e50;
}

.info-card a {
  color: #667eea;
  text-decoration: none;
  font-weight: 500;
  font-size: 1.05rem;
  transition: color 0.3s ease;
}

.info-card a:hover {
  color: #764ba2;
}

.info-card p {
  color: #555;
  margin-top: 5px;
  line-height: 1.6;
}

.info-desc {
  font-size: 0.9rem;
  color: #999 !important;
  margin-top: 8px;
  font-style: italic;
}

/* Contact Form */
.contact-form-wrapper {
  background: white;
  padding: 40px;
  border-radius: 20px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
}

.form-header {
  margin-bottom: 30px;
  text-align: center;
}

.form-header h3 {
  font-size: 1.8rem;
  color: #2c3e50;
  margin-bottom: 10px;
}

.form-header p {
  color: #777;
  font-size: 0.95rem;
}

.contact-form {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.form-group label {
  font-weight: 600;
  color: #2c3e50;
  font-size: 0.95rem;
  display: flex;
  align-items: center;
  gap: 8px;
}

.form-group label i {
  color: #667eea;
  font-size: 0.9rem;
}

.form-group input,
.form-group textarea {
  padding: 14px 16px;
  border: 2px solid #e0e0e0;
  border-radius: 12px;
  font-size: 1rem;
  font-family: "Poppins", sans-serif;
  transition: all 0.3s ease;
  background: #f8f9fa;
}

.form-group input:focus,
.form-group textarea:focus {
  outline: none;
  border-color: #667eea;
  background: white;
  box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
}

.form-group textarea {
  resize: vertical;
  min-height: 120px;
}

.submit-btn {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border: none;
  padding: 16px 32px;
  border-radius: 12px;
  font-size: 1.1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  margin-top: 10px;
  box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);
}

.submit-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(102, 126, 234, 0.4);
}

.submit-btn:active {
  transform: translateY(0);
}

.submit-btn i {
  font-size: 1rem;
  transition: transform 0.3s ease;
}

.submit-btn:hover i {
  transform: translateX(5px);
}

.submit-btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
  transform: none;
}

.submit-btn:disabled:hover {
  transform: none;
  box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);
}

.submit-message {
  margin-top: 15px;
  padding: 12px 16px;
  border-radius: 8px;
  font-size: 0.95rem;
  font-weight: 500;
  text-align: center;
  animation: slideIn 0.3s ease;
}

.submit-message.success {
  background: #d4edda;
  color: #155724;
  border: 1px solid #c3e6cb;
}

.submit-message.error {
  background: #f8d7da;
  color: #721c24;
  border: 1px solid #f5c6cb;
}

@keyframes slideIn {
  from {
    opacity: 0;
    transform: translateY(-10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* RESPONSIVE DESIGN */

/* Large tablets and small desktops */
@media (max-width: 1024px) {
  .hero-text h1 {
    font-size: 2.2rem;
  }

  .features h2,
  .about-text h2,
  .contact h2 {
    font-size: 2rem;
  }

  .feature-grid {
    grid-template-columns: repeat(2, 1fr);
    max-width: 900px;
  }
}

/* Tablets */
@media (max-width: 768px) {
  .hero {
    padding: 60px 15px;
  }

  .hero-content {
    flex-direction: column;
    gap: 30px;
  }

  .hero-text {
    text-align: center;
  }

  .hero-text h1 {
    font-size: 2rem;
  }

  .hero-text p {
    font-size: 1rem;
  }

  .button-group {
    flex-direction: column;
    align-items: center;
    width: 100%;
  }

  .cta-btn,
  .fitness-btn {
    width: 100%;
    max-width: 300px;
  }

  .hero-img {
    min-height: 300px;
  }

  .features,
  .about,
  .contact {
    padding: 60px 15px;
  }

  .features h2,
  .about-text h2,
  .contact-header h2 {
    font-size: 1.8rem;
  }

  .feature-grid {
    grid-template-columns: 1fr;
    gap: 1.5rem;
    max-width: 400px;
  }

  .about-container {
    flex-direction: column;
    text-align: center;
    gap: 30px;
  }

  .about-text p {
    font-size: 1rem;
  }

  .about-image img {
    max-width: 80%;
  }

  .contact-grid {
    grid-template-columns: 1fr;
    gap: 30px;
  }

  .contact-form-wrapper {
    padding: 30px 20px;
  }

  .form-header h3 {
    font-size: 1.5rem;
  }

  .info-card {
    max-width: 100%;
  }
}

/* Mobile phones */
@media (max-width: 480px) {
  .hero {
    padding: 40px 10px;
  }

  .hero-text h1 {
    font-size: 1.6rem;
  }

  .hero-text p {
    font-size: 0.9rem;
  }

  .cta-btn,
  .fitness-btn {
    padding: 12px 24px;
    font-size: 0.9rem;
  }

  .features h2,
  .about-text h2,
  .contact-header h2 {
    font-size: 1.5rem;
  }

  .features,
  .about,
  .contact {
    padding: 40px 10px;
  }

  .feature-grid {
    max-width: 100%;
  }

  .card {
    padding: 20px 15px;
  }

  .card img {
    width: 60px;
  }

  .about-text p {
    font-size: 0.9rem;
  }

  .contact-header p {
    font-size: 0.9rem;
  }

  .contact-form-wrapper {
    padding: 25px 15px;
  }

  .form-header h3 {
    font-size: 1.3rem;
  }

  .form-header p {
    font-size: 0.85rem;
  }

  .info-card {
    padding: 20px;
  }

  .icon-wrapper {
    width: 50px;
    height: 50px;
    font-size: 20px;
  }

  .info-card h4 {
    font-size: 1.1rem;
  }

  .form-group input,
  .form-group textarea {
    padding: 12px 14px;
    font-size: 0.95rem;
  }

  .submit-btn {
    padding: 14px 28px;
    font-size: 1rem;
  }
}

footer {
  background: linear-gradient(135deg, #27ae60, #20c997);
  color: white;
  text-align: center;
  padding: 20px;
}
</style>
