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

  // Head (bigger for anime style)
  const headGeometry = new THREE.SphereGeometry(0.35, 32, 32);
  const headMaterial = new THREE.MeshPhongMaterial({ 
    color: 0xffe4c4,
    shininess: 30 
  });
  const head = new THREE.Mesh(headGeometry, headMaterial);
  head.position.y = 1.6;
  head.scale.set(1, 1.1, 0.95); // Slightly elongated
  head.castShadow = true;
  character.add(head);

  // Eyes (big anime eyes)
  const eyeWhiteGeometry = new THREE.SphereGeometry(0.08, 16, 16);
  const eyeWhiteMaterial = new THREE.MeshPhongMaterial({ color: 0xffffff });
  
  const leftEyeWhite = new THREE.Mesh(eyeWhiteGeometry, eyeWhiteMaterial);
  leftEyeWhite.position.set(-0.12, 1.65, 0.28);
  leftEyeWhite.scale.set(1, 1.3, 0.5);
  character.add(leftEyeWhite);

  const rightEyeWhite = new THREE.Mesh(eyeWhiteGeometry, eyeWhiteMaterial);
  rightEyeWhite.position.set(0.12, 1.65, 0.28);
  rightEyeWhite.scale.set(1, 1.3, 0.5);
  character.add(rightEyeWhite);

  // Eye pupils (sparkly)
  const pupilGeometry = new THREE.SphereGeometry(0.05, 16, 16);
  const pupilMaterial = new THREE.MeshPhongMaterial({ 
    color: 0x4a90e2,
    emissive: 0x1e3a5f 
  });
  
  const leftPupil = new THREE.Mesh(pupilGeometry, pupilMaterial);
  leftPupil.position.set(-0.12, 1.65, 0.32);
  character.add(leftPupil);

  const rightPupil = new THREE.Mesh(pupilGeometry, pupilMaterial);
  rightPupil.position.set(0.12, 1.65, 0.32);
  character.add(rightPupil);

  // Eye highlights
  const highlightGeometry = new THREE.SphereGeometry(0.02, 8, 8);
  const highlightMaterial = new THREE.MeshBasicMaterial({ color: 0xffffff });
  
  const leftHighlight = new THREE.Mesh(highlightGeometry, highlightMaterial);
  leftHighlight.position.set(-0.1, 1.7, 0.34);
  character.add(leftHighlight);

  const rightHighlight = new THREE.Mesh(highlightGeometry, highlightMaterial);
  rightHighlight.position.set(0.14, 1.7, 0.34);
  character.add(rightHighlight);

  // Blush
  const blushGeometry = new THREE.CircleGeometry(0.08, 16);
  const blushMaterial = new THREE.MeshBasicMaterial({ 
    color: 0xffb6c1,
    transparent: true,
    opacity: 0.6 
  });
  
  const leftBlush = new THREE.Mesh(blushGeometry, blushMaterial);
  leftBlush.position.set(-0.25, 1.55, 0.3);
  character.add(leftBlush);

  const rightBlush = new THREE.Mesh(blushGeometry, blushMaterial);
  rightBlush.position.set(0.25, 1.55, 0.3);
  character.add(rightBlush);

  // Smile
  const smileGeometry = new THREE.TorusGeometry(0.08, 0.015, 8, 16, Math.PI);
  const smileMaterial = new THREE.MeshPhongMaterial({ color: 0xff6b9d });
  const smile = new THREE.Mesh(smileGeometry, smileMaterial);
  smile.position.set(0, 1.45, 0.3);
  smile.rotation.x = Math.PI;
  character.add(smile);

  // Long anime hair
  const hairColor = 0xff69b4; // Pink hair
  
  // Hair base (top)
  const hairTopGeometry = new THREE.SphereGeometry(0.38, 32, 32);
  const hairMaterial = new THREE.MeshPhongMaterial({ 
    color: hairColor,
    shininess: 60 
  });
  const hairTop = new THREE.Mesh(hairTopGeometry, hairMaterial);
  hairTop.position.set(0, 1.75, -0.05);
  hairTop.scale.set(1, 0.8, 1);
  character.add(hairTop);

  // Bangs
  for (let i = 0; i < 5; i++) {
    const bangGeometry = new THREE.ConeGeometry(0.08, 0.3, 8);
    const bang = new THREE.Mesh(bangGeometry, hairMaterial);
    bang.position.set(-0.2 + i * 0.1, 1.55, 0.25);
    bang.rotation.x = 0.3;
    character.add(bang);
  }

  // Twin tails
  const twinTailGeometry = new THREE.ConeGeometry(0.12, 0.6, 8);
  
  const leftTwinTail = new THREE.Mesh(twinTailGeometry, hairMaterial);
  leftTwinTail.position.set(-0.35, 1.5, -0.1);
  leftTwinTail.rotation.z = 0.5;
  character.add(leftTwinTail);

  const rightTwinTail = new THREE.Mesh(twinTailGeometry, hairMaterial);
  rightTwinTail.position.set(0.35, 1.5, -0.1);
  rightTwinTail.rotation.z = -0.5;
  character.add(rightTwinTail);

  // Body (school uniform style - white top)
  const bodyGeometry = new THREE.CylinderGeometry(0.25, 0.35, 0.7, 16);
  const bodyMaterial = new THREE.MeshPhongMaterial({ color: 0xffffff });
  const body = new THREE.Mesh(bodyGeometry, bodyMaterial);
  body.position.y = 0.85;
  body.castShadow = true;
  character.add(body);

  // Collar
  const collarGeometry = new THREE.TorusGeometry(0.26, 0.03, 8, 16);
  const collarMaterial = new THREE.MeshPhongMaterial({ color: 0x4a90e2 });
  const collar = new THREE.Mesh(collarGeometry, collarMaterial);
  collar.position.y = 1.18;
  collar.rotation.x = Math.PI / 2;
  character.add(collar);

  // Skirt (pleated)
  const skirtGeometry = new THREE.ConeGeometry(0.4, 0.35, 16);
  const skirtMaterial = new THREE.MeshPhongMaterial({ color: 0x4a90e2 });
  const skirt = new THREE.Mesh(skirtGeometry, skirtMaterial);
  skirt.position.y = 0.35;
  skirt.castShadow = true;
  character.add(skirt);

  // Arms (slender)
  const armGeometry = new THREE.CylinderGeometry(0.06, 0.055, 0.55, 12);
  const armMaterial = new THREE.MeshPhongMaterial({ color: 0xffe4c4 });
  
  const leftArm = new THREE.Mesh(armGeometry, armMaterial);
  leftArm.position.set(-0.32, 0.95, 0);
  leftArm.rotation.z = 0.3;
  leftArm.castShadow = true;
  character.add(leftArm);

  const rightArm = new THREE.Mesh(armGeometry, armMaterial);
  rightArm.position.set(0.32, 0.95, 0);
  rightArm.rotation.z = -0.3;
  rightArm.castShadow = true;
  character.add(rightArm);

  // Hands
  const handGeometry = new THREE.SphereGeometry(0.07, 12, 12);
  
  const leftHand = new THREE.Mesh(handGeometry, armMaterial);
  leftHand.position.set(-0.4, 0.65, 0);
  character.add(leftHand);

  const rightHand = new THREE.Mesh(handGeometry, armMaterial);
  rightHand.position.set(0.4, 0.65, 0);
  character.add(rightHand);

  // Legs (with socks)
  const legGeometry = new THREE.CylinderGeometry(0.08, 0.075, 0.5, 12);
  const legMaterial = new THREE.MeshPhongMaterial({ color: 0xffe4c4 });
  
  const leftLeg = new THREE.Mesh(legGeometry, legMaterial);
  leftLeg.position.set(-0.12, 0, 0);
  leftLeg.castShadow = true;
  character.add(leftLeg);

  const rightLeg = new THREE.Mesh(legGeometry, legMaterial);
  rightLeg.position.set(0.12, 0, 0);
  rightLeg.castShadow = true;
  character.add(rightLeg);

  // Socks (white knee-high)
  const sockGeometry = new THREE.CylinderGeometry(0.085, 0.08, 0.3, 12);
  const sockMaterial = new THREE.MeshPhongMaterial({ color: 0xffffff });
  
  const leftSock = new THREE.Mesh(sockGeometry, sockMaterial);
  leftSock.position.set(-0.12, -0.15, 0);
  character.add(leftSock);

  const rightSock = new THREE.Mesh(sockGeometry, sockMaterial);
  rightSock.position.set(0.12, -0.15, 0);
  character.add(rightSock);

  // Shoes
  const shoeGeometry = new THREE.BoxGeometry(0.12, 0.08, 0.18);
  const shoeMaterial = new THREE.MeshPhongMaterial({ color: 0x8b4513 });
  
  const leftShoe = new THREE.Mesh(shoeGeometry, shoeMaterial);
  leftShoe.position.set(-0.12, -0.32, 0.03);
  leftShoe.castShadow = true;
  character.add(leftShoe);

  const rightShoe = new THREE.Mesh(shoeGeometry, shoeMaterial);
  rightShoe.position.set(0.12, -0.32, 0.03);
  rightShoe.castShadow = true;
  character.add(rightShoe);

  // Store references for animation
  character.userData = {
    body,
    head,
    leftArm,
    rightArm,
    leftLeg,
    rightLeg,
    leftTwinTail,
    rightTwinTail,
    leftEyeWhite,
    rightEyeWhite
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
    const { body, head, leftArm, rightArm, leftLeg, rightLeg, leftTwinTail, rightTwinTail } = model.userData;

    // Rotate the entire character
    model.rotation.y = time * 0.5;

    // Dancing animation - body bounce
    body.position.y = 0.85 + Math.sin(time * 3) * 0.08;
    
    // Head bob with cute tilt
    head.position.y = 1.6 + Math.sin(time * 3) * 0.04;
    head.rotation.z = Math.sin(time * 2) * 0.08;

    // Arm wave (more feminine)
    leftArm.rotation.z = 0.3 + Math.sin(time * 3) * 0.4;
    rightArm.rotation.z = -0.3 - Math.sin(time * 3) * 0.4;
    leftArm.rotation.x = Math.sin(time * 3 + Math.PI) * 0.2;
    rightArm.rotation.x = Math.sin(time * 3) * 0.2;

    // Leg dance (idol-style)
    leftLeg.rotation.x = Math.sin(time * 3) * 0.2;
    rightLeg.rotation.x = Math.sin(time * 3 + Math.PI) * 0.2;

    // Twin tails bounce
    leftTwinTail.rotation.x = Math.sin(time * 4) * 0.3;
    rightTwinTail.rotation.x = Math.sin(time * 4) * 0.3;
    leftTwinTail.rotation.z = 0.5 + Math.sin(time * 3) * 0.2;
    rightTwinTail.rotation.z = -0.5 - Math.sin(time * 3) * 0.2;
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
