<template>
  <div class="min-vh-100 d-flex align-items-center" style="background:linear-gradient(135deg,#fff5fa,#f3e5f5)">
    <div class="container"><div class="row justify-content-center"><div class="col-md-5">
      <div class="card border-0 shadow-lg rounded-4 p-4">
        <div class="text-center mb-4">
          <div style="font-size:3rem">🌸</div>
          <h4 class="fw-bold">เข้าสู่ระบบ</h4>
        </div>
        <form @submit.prevent="handleLogin">
          <div class="mb-3">
            <label class="form-label">อีเมล</label>
            <input v-model="form.email" type="email" class="form-control" required>
          </div>
          <div class="mb-3">
            <label class="form-label">รหัสผ่าน</label>
            <input v-model="form.password" type="password" class="form-control" required>
          </div>
          <div v-if="error" class="alert alert-danger py-2">{{ error }}</div>
          <button type="submit" class="btn btn-primary w-100 btn-lg" :disabled="loading">
            <span v-if="loading" class="spinner-border spinner-border-sm me-2"></span>เข้าสู่ระบบ
          </button>
        </form>
        <hr><p class="text-center mb-0">ยังไม่มีบัญชี? <router-link to="/register" class="text-primary">สมัครสมาชิก</router-link></p>
        <p class="text-center text-muted small mt-2">Demo: user@beautyshop.com / password</p>
      </div>
    </div></div></div>
  </div>
</template>
<script setup>
import { ref } from 'vue'; import { useRouter } from 'vue-router'; import { useAuthStore } from '@/stores/auth'; import { useToast } from 'vue-toastification'
const auth = useAuthStore(); const router = useRouter(); const toast = useToast()
const form = ref({ email: '', password: '' }); const loading = ref(false); const error = ref('')
async function handleLogin() {
  loading.value = true; error.value = ''
  try { await auth.login(form.value.email, form.value.password); toast.success('ยินดีต้อนรับ!'); router.push('/') }
  catch(e) { error.value = e.message } finally { loading.value = false }
}
</script>
