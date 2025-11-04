<template>
  <div ref="container" class="model-container"></div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue';
import * as THREE from 'three';

const container = ref(null);
let scene, camera, renderer, model, clock;
let animationFrameId;

onMounted(() => {
  initThree();
  animate();
});

onUnmounted(() => {
  if (animationFrameId) {
    cancelAnimationFrame(animationFrameId);
  }
  if (renderer) {
    renderer.dispose();
  }
});

const initThree = () => {
  // Scene
  scene = new THREE.Scene();
  scene.background = new THREE.Color(0xe0f7fa);

  // Camera
  camera = new THREE.PerspectiveCamera(
    45,
    container.value.clientWidth / container.value.clientHeight,
    0.1,
    1000
  );
  camera.position.set(0, 1.5, 5);

  // Renderer
  renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true });
  renderer.setSize(container.value.clientWidth, container.value.clientHeight);
  renderer.setPixelRatio(window.devicePixelRatio);
  renderer.shadowMap.enabled = true;
  container.value.appendChild(renderer.domElement);

  // Lights
  const ambientLight = new THREE.AmbientLight(0xffffff, 0.6);
  scene.add(ambientLight);

  const directionalLight = new THREE.DirectionalLight(0xffffff, 0.8);
  directionalLight.position.set(5, 10, 7.5);
  directionalLight.castShadow = true;
  scene.add(directionalLight);

  const pointLight1 = new THREE.PointLight(0x27ae60, 1, 100);
  pointLight1.position.set(-5, 5, 5);
  scene.add(pointLight1);

  const pointLight2 = new THREE.PointLight(0xf59e0b, 1, 100);
  pointLight2.position.set(5, 5, -5);
  scene.add(pointLight2);

  // Create animated character
  createAnimeCharacter();

  // Clock for animations
  clock = new THREE.Clock();

  // Handle window resize
  window.addEventListener('resize', onWindowResize);
};

const createAnimeCharacter = () => {
  const character = new THREE.Group();

  // Body (torso)
  const bodyGeometry = new THREE.CylinderGeometry(0.3, 0.4, 0.8, 8);
  const bodyMaterial = new THREE.MeshPhongMaterial({ color: 0x27ae60 });
  const body = new THREE.Mesh(bodyGeometry, bodyMaterial);
  body.position.y = 0.8;
  body.castShadow = true;
  character.add(body);

  // Head
  const headGeometry = new THREE.SphereGeometry(0.3, 16, 16);
  const headMaterial = new THREE.MeshPhongMaterial({ color: 0xffd1a3 });
  const head = new THREE.Mesh(headGeometry, headMaterial);
  head.position.y = 1.5;
  head.castShadow = true;
  character.add(head);

  // Eyes
  const eyeGeometry = new THREE.SphereGeometry(0.05, 8, 8);
  const eyeMaterial = new THREE.MeshPhongMaterial({ color: 0x000000 });
  
  const leftEye = new THREE.Mesh(eyeGeometry, eyeMaterial);
  leftEye.position.set(-0.1, 1.55, 0.25);
  character.add(leftEye);

  const rightEye = new THREE.Mesh(eyeGeometry, eyeMaterial);
  rightEye.position.set(0.1, 1.55, 0.25);
  character.add(rightEye);

  // Smile
  const smileGeometry = new THREE.TorusGeometry(0.1, 0.02, 8, 16, Math.PI);
  const smileMaterial = new THREE.MeshPhongMaterial({ color: 0x000000 });
  const smile = new THREE.Mesh(smileGeometry, smileMaterial);
  smile.position.set(0, 1.4, 0.25);
  smile.rotation.x = Math.PI;
  character.add(smile);

  // Hair (anime style)
  const hairGeometry = new THREE.ConeGeometry(0.35, 0.4, 8);
  const hairMaterial = new THREE.MeshPhongMaterial({ color: 0x8b4513 });
  const hair = new THREE.Mesh(hairGeometry, hairMaterial);
  hair.position.set(0, 1.8, 0);
  hair.rotation.x = Math.PI;
  character.add(hair);

  // Arms
  const armGeometry = new THREE.CylinderGeometry(0.08, 0.08, 0.6, 8);
  const armMaterial = new THREE.MeshPhongMaterial({ color: 0xffd1a3 });
  
  const leftArm = new THREE.Mesh(armGeometry, armMaterial);
  leftArm.position.set(-0.4, 0.9, 0);
  leftArm.rotation.z = 0.5;
  leftArm.castShadow = true;
  character.add(leftArm);

  const rightArm = new THREE.Mesh(armGeometry, armMaterial);
  rightArm.position.set(0.4, 0.9, 0);
  rightArm.rotation.z = -0.5;
  rightArm.castShadow = true;
  character.add(rightArm);

  // Legs
  const legGeometry = new THREE.CylinderGeometry(0.1, 0.1, 0.7, 8);
  const legMaterial = new THREE.MeshPhongMaterial({ color: 0x2c3e50 });
  
  const leftLeg = new THREE.Mesh(legGeometry, legMaterial);
  leftLeg.position.set(-0.15, 0.05, 0);
  leftLeg.castShadow = true;
  character.add(leftLeg);

  const rightLeg = new THREE.Mesh(legGeometry, legMaterial);
  rightLeg.position.set(0.15, 0.05, 0);
  rightLeg.castShadow = true;
  character.add(rightLeg);

  // Store references for animation
  character.userData = {
    body,
    head,
    leftArm,
    rightArm,
    leftLeg,
    rightLeg,
    leftEye,
    rightEye
  };

  // Ground plane
  const planeGeometry = new THREE.CircleGeometry(3, 32);
  const planeMaterial = new THREE.MeshPhongMaterial({ 
    color: 0xc8f6e0,
    side: THREE.DoubleSide 
  });
  const plane = new THREE.Mesh(planeGeometry, planeMaterial);
  plane.rotation.x = -Math.PI / 2;
  plane.position.y = -0.3;
  plane.receiveShadow = true;
  scene.add(plane);

  model = character;
  scene.add(model);
};

const animate = () => {
  animationFrameId = requestAnimationFrame(animate);

  const time = clock.getElapsedTime();

  if (model && model.userData) {
    const { body, head, leftArm, rightArm, leftLeg, rightLeg } = model.userData;

    // Rotate the entire character
    model.rotation.y = time * 0.5;

    // Dancing animation - body bounce
    body.position.y = 0.8 + Math.sin(time * 3) * 0.1;
    
    // Head bob
    head.position.y = 1.5 + Math.sin(time * 3) * 0.05;
    head.rotation.z = Math.sin(time * 2) * 0.1;

    // Arm wave
    leftArm.rotation.z = 0.5 + Math.sin(time * 3) * 0.5;
    rightArm.rotation.z = -0.5 - Math.sin(time * 3) * 0.5;
    leftArm.rotation.x = Math.sin(time * 3 + Math.PI) * 0.3;
    rightArm.rotation.x = Math.sin(time * 3) * 0.3;

    // Leg dance
    leftLeg.rotation.x = Math.sin(time * 3) * 0.3;
    rightLeg.rotation.x = Math.sin(time * 3 + Math.PI) * 0.3;
  }

  renderer.render(scene, camera);
};

const onWindowResize = () => {
  if (!container.value) return;
  
  camera.aspect = container.value.clientWidth / container.value.clientHeight;
  camera.updateProjectionMatrix();
  renderer.setSize(container.value.clientWidth, container.value.clientHeight);
};
</script>

<style scoped>
.model-container {
  width: 100%;
  height: 100%;
  min-height: 400px;
  border-radius: 20px;
  overflow: hidden;
  box-shadow: 0 10px 40px rgba(39, 174, 96, 0.2);
}

@media (max-width: 768px) {
  .model-container {
    min-height: 300px;
  }
}
</style>
