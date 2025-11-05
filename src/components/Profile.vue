<template>
  <div>
    <Navbar />
    
    <div class="profile-page">
      <!-- Back Button -->
      <div class="back-button" @click="goHome">
        <img :src="backArrow" alt="Back" />
      </div>

      <div class="profile-container" v-if="userState.loggedIn">
      <!-- Profile Picture -->
      <div class="profile-pic">
        <img :src="profilePic || defaultPic" alt="Profile Picture" />
      </div>

      <h2>{{ userState.user.user_metadata.full_name || "User" }}</h2>

      <div class="profile-info">
        <div class="info-row">
          <span class="label">Email:</span>
          <span class="value">{{ userState.user.email }}</span>
        </div>
        <div class="info-row">
          <span class="label">Phone:</span>
          <span class="value">{{
            userState.user.user_metadata.phone || "-"
          }}</span>
        </div>
        <div class="info-row">
          <span class="label">Member Since:</span>
          <span class="value">{{ memberSince }}</span>
        </div>
      </div>

      <div class="profile-buttons">
        <button class="edit-btn" @click="openEditModal">Edit Profile</button>
        <button class="delete-btn" disabled>
          Delete Account (Coming Soon)
        </button>
      </div>

      <button class="logout-btn" @click="logout">Logout</button>
    </div>

    <div v-else class="not-logged-in">
      <p>You are not logged in.</p>
      <button @click="router.push('/login')">Go to Login</button>
    </div>

    <!-- Edit Profile Modal -->
    <div v-if="editing" class="edit-modal">
      <div class="modal-content">
        <h3>Edit Profile</h3>
        <form @submit.prevent="updateProfile">
          <label>Full Name</label>
          <input v-model="editName" type="text" required />

          <label>Email</label>
          <input v-model="editEmail" type="email" required />

          <label>Phone</label>
          <input v-model="editPhone" type="tel" />

          <label>Profile Picture</label>
          <input
            type="file"
            @change="onFileChange"
            accept="image/png, image/jpeg, image/jpg"
          />

          <div class="modal-buttons">
            <button type="submit">Save Changes</button>
            <button type="button" @click="editing = false" class="cancel-btn">
              Cancel
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
  </div>
</template>

<script setup>
import { ref, computed } from "vue";
import { useRouter } from "vue-router";
import { supabase } from "@/supabase";
import { userState } from "@/state/userState";
import Navbar from "@/components/Navbar.vue";
import backArrow from "@/assets/back-arrow.png";
import defaultPic from "@/assets/default-profile.png";

const router = useRouter();
const profilePic = ref(userState.user?.user_metadata.profile_pic || null);
const editing = ref(false);

// Editable fields
const editName = ref(userState.user?.user_metadata.full_name || "");
const editEmail = ref(userState.user?.email || "");
const editPhone = ref(userState.user?.user_metadata.phone || "");
let selectedFile = ref(null);

// Navigate home
const goHome = () => router.push("/");

// Logout
const logout = async () => {
  await supabase.auth.signOut();
  userState.loggedIn = false;
  userState.user = null;
  router.push("/");
};

// Open Edit Modal
const openEditModal = () => {
  editing.value = true;
  editName.value = userState.user?.user_metadata.full_name || "";
  editEmail.value = userState.user?.email || "";
  editPhone.value = userState.user?.user_metadata.phone || "";
  selectedFile.value = null;
};

// Handle profile pic selection and preview
const onFileChange = (e) => {
  const file = e.target.files[0];
  if (!file) return;

  const ext = file.name.split(".").pop().toLowerCase();
  if (!["png", "jpg", "jpeg"].includes(ext)) {
    alert("Only PNG, JPG, or JPEG files are allowed.");
    return;
  }

  selectedFile.value = file;

  const reader = new FileReader();
  reader.onload = (event) => {
    profilePic.value = event.target.result;
  };
  reader.readAsDataURL(file);
};

// Update Profile
const updateProfile = async () => {
  let profileUrl = profilePic.value;
  const bucket = "profile-pics";
  const folder = "avatars";
  const userId = userState.user.id;

  if (selectedFile.value) {
    const fileExt = selectedFile.value.name.split(".").pop().toLowerCase();
    if (!["png", "jpg", "jpeg"].includes(fileExt)) {
      alert("Only PNG, JPG, or JPEG files are allowed.");
      return;
    }

    const fileName = `${folder}/${userId}.${fileExt}`;

    // Remove previous file if exists
    try {
      const { data: listData } = await supabase.storage
        .from(bucket)
        .list(folder);
      const oldFile = listData?.find((f) => f.name.startsWith(userId));
      if (oldFile) {
        await supabase.storage
          .from(bucket)
          .remove([`${folder}/${oldFile.name}`]);
      }
    } catch (err) {
      console.warn("Could not check/remove old avatar:", err.message);
    }

    // Upload new file
    const { data: uploadData, error: uploadError } = await supabase.storage
      .from(bucket)
      .upload(fileName, selectedFile.value);

    if (uploadError) {
      alert("Error uploading profile picture: " + uploadError.message);
      return;
    }

    const { data: publicData } = supabase.storage
      .from(bucket)
      .getPublicUrl(fileName);
    profileUrl = publicData.publicUrl;
  }

  // Update Supabase user
  const { data, error } = await supabase.auth.updateUser({
    email: editEmail.value,
    data: {
      full_name: editName.value,
      phone: editPhone.value,
      profile_pic: profileUrl,
    },
  });

  if (error) {
    alert("Error updating profile: " + error.message);
    return;
  }

  // Update local state
  userState.user = data.user;
  profilePic.value = profileUrl;
  editing.value = false;
  alert("Profile updated successfully! Email change may require confirmation.");
};

// Member Since
const memberSince = computed(() => {
  if (!userState.user?.created_at) return "-";
  const date = new Date(userState.user.created_at);
  const day = String(date.getDate()).padStart(2, "0");
  const monthNames = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
  ];
  const month = monthNames[date.getMonth()];
  const year = date.getFullYear();
  const hours = String(date.getHours()).padStart(2, "0");
  const minutes = String(date.getMinutes()).padStart(2, "0");
  return `${day} ${month}, ${year} ${hours}:${minutes}`;
});
</script>

<style scoped>
/* keep all your styles exactly the same */
.profile-page {
  position: relative;
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea, #764ba2);
  display: flex;
  justify-content: center;
  align-items: flex-start;
  padding: 2rem 0 80px 0;
  font-family: "Poppins", sans-serif;
}
.back-button {
  position: absolute;
  top: 20px;
  left: 20px;
  width: 40px;
  height: 40px;
  cursor: pointer;
  z-index: 100;
}
.back-button img {
  width: 100%;
  height: 100%;
  object-fit: contain;
  transition: transform 0.3s ease;
}
.back-button:hover img {
  transform: translateX(-5px);
}
.profile-container {
  background: white;
  padding: 2.5rem 2rem;
  border-radius: 20px;
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2);
  width: 350px;
  text-align: center;
}
.profile-pic {
  width: 100px;
  height: 100px;
  margin: 0 auto 1rem;
}
.profile-pic img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 50%;
  border: 3px solid #667eea;
}
.profile-info {
  margin: 1.5rem 0;
}
.info-row {
  display: flex;
  justify-content: space-between;
  margin-bottom: 0.8rem;
  font-size: 0.95rem;
}
.label {
  font-weight: 600;
  color: #555;
}
.value {
  color: #333;
}
.profile-buttons {
  display: flex;
  justify-content: space-between;
  margin-top: 1.5rem;
}
.edit-btn {
  flex: 1;
  margin-right: 0.5rem;
  padding: 0.6rem 1.2rem;
  background-color: #667eea;
  color: white;
  border: none;
  border-radius: 10px;
  cursor: pointer;
  font-weight: 600;
}
.edit-btn:hover {
  background-color: #5a67d8;
}
.delete-btn {
  flex: 1;
  margin-left: 0.5rem;
  padding: 0.6rem 1.2rem;
  background-color: #e74c3c;
  color: white;
  border: none;
  border-radius: 10px;
  cursor: not-allowed;
  font-weight: 600;
}
.logout-btn {
  margin-top: 1.5rem;
  padding: 0.6rem 1.5rem;
  background-color: #27ae60;
  color: white;
  border: none;
  border-radius: 10px;
  font-weight: 600;
  cursor: pointer;
}
.logout-btn:hover {
  background-color: #1e8449;
}
.not-logged-in {
  text-align: center;
  color: white;
}
.not-logged-in button {
  margin-top: 1rem;
  padding: 0.5rem 1.2rem;
  background-color: white;
  color: #667eea;
  border: none;
  border-radius: 8px;
  cursor: pointer;
}
.not-logged-in button:hover {
  background-color: #f0f0f0;
}
/* Edit Modal */
.edit-modal {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.6);
  display: flex;
  justify-content: center;
  align-items: center;
}
.modal-content {
  background: white;
  padding: 2rem;
  border-radius: 15px;
  width: 350px;
}
.modal-content h3 {
  margin-bottom: 1rem;
  text-align: center;
}
.modal-content form label {
  display: block;
  margin-top: 0.8rem;
  font-weight: 600;
}
.modal-content form input {
  width: 100%;
  padding: 0.5rem;
  border-radius: 8px;
  border: 1px solid #ccc;
  margin-top: 0.3rem;
}
.modal-buttons {
  display: flex;
  justify-content: space-between;
  margin-top: 1rem;
}
.modal-buttons .cancel-btn {
  background: #ccc;
  color: #333;
}
.modal-buttons button {
  flex: 1;
  margin: 0 0.25rem;
  padding: 0.5rem 0;
  border-radius: 10px;
  border: none;
  font-weight: 600;
  cursor: pointer;
}

/* RESPONSIVE DESIGN */
@media (max-width: 768px) {
  .profile-page {
    padding-top: 60px;
    padding-left: 1rem;
    padding-right: 1rem;
  }

  .back-button {
    top: 15px;
    left: 15px;
    width: 35px;
    height: 35px;
  }

  .profile-container {
    width: 100%;
    max-width: 400px;
    padding: 2rem 1.5rem;
  }

  .modal-content {
    width: 90%;
    max-width: 400px;
    padding: 1.5rem;
  }
}

@media (max-width: 480px) {
  .profile-page {
    padding-top: 50px;
  }

  .back-button {
    top: 10px;
    left: 10px;
    width: 30px;
    height: 30px;
  }

  .profile-container {
    padding: 1.5rem 1rem;
  }

  .profile-container h2 {
    font-size: 1.3rem;
  }

  .info-row {
    flex-direction: column;
    align-items: flex-start;
    gap: 0.3rem;
    margin-bottom: 1rem;
  }

  .profile-buttons {
    flex-direction: column;
    gap: 0.5rem;
  }

  .edit-btn,
  .delete-btn {
    margin: 0;
    width: 100%;
  }

  .modal-content {
    padding: 1rem;
  }

  .modal-buttons {
    flex-direction: column;
    gap: 0.5rem;
  }

  .modal-buttons button {
    margin: 0;
    width: 100%;
  }
}
</style>
