<template>
  <div class="min-vh-100 d-flex align-items-center" style="background:linear-gradient(135deg,#fff5fa,#f3e5f5)">
    <div class="container"><div class="row justify-content-center"><div class="col-md-5">
      <div class="card border-0 shadow-lg rounded-4 p-4">
        <div class="text-center mb-4"><div style="font-size:3rem">💄</div><h4 class="fw-bold">สมัครสมาชิก</h4></div>
        <form @submit.prevent="handleRegister">
          <div class="mb-3"><label class="form-label">ชื่อ</label><input v-model="form.name" class="form-control" required></div>
          <div class="mb-3"><label class="form-label">อีเมล</label><input v-model="form.email" type="email" class="form-control" required></div>
          <div class="mb-3"><label class="form-label">รหัสผ่าน</label><input v-model="form.password" type="password" class="form-control" minlength="6" required></div>
          <div v-if="error" class="alert alert-danger py-2">{{ error }}</div>
          <button type="submit" class="btn btn-primary w-100 btn-lg" :disabled="loading">
            <span v-if="loading" class="spinner-border spinner-border-sm me-2"></span>สมัครสมาชิก
          </button>
        </form>
        <hr><p class="text-center mb-0">มีบัญชีแล้ว? <router-link to="/login" class="text-primary">เข้าสู่ระบบ</router-link></p>
      </div>
    </div></div></div>
  </div>
</template>
<script setup>
import { ref } from 'vue'; import { useRouter } from 'vue-router'; import { useAuthStore } from '@/stores/auth'; import { useToast } from 'vue-toastification'
const auth = useAuthStore(); const router = useRouter(); const toast = useToast()
const form = ref({ name:'', email:'', password:'' }); const loading = ref(false); const error = ref('')
async function handleRegister() {
  loading.value = true; error.value = ''
  try { await auth.register(form.value.name, form.value.email, form.value.password); toast.success('สมัครสมาชิกสำเร็จ!'); router.push('/') }
  catch(e) { error.value = e.message } finally { loading.value = false }
}
</script>
