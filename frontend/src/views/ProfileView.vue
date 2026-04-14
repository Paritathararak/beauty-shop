<template>
  <div class="container py-5"><div class="row justify-content-center"><div class="col-md-6">
    <div class="card border-0 shadow-sm rounded-4 p-4">
      <h4 class="fw-bold mb-4"><i class="bi bi-person-circle me-2 text-primary"></i>โปรไฟล์</h4>
      <form @submit.prevent="save">
        <div class="mb-3"><label class="form-label">ชื่อ</label><input v-model="form.name" class="form-control" required></div>
        <div class="mb-3"><label class="form-label">อีเมล</label><input :value="auth.user?.email" class="form-control" disabled></div>
        <div class="mb-3"><label class="form-label">เบอร์โทร</label><input v-model="form.phone" class="form-control"></div>
        <div class="mb-3"><label class="form-label">ที่อยู่</label><textarea v-model="form.address" class="form-control" rows="3"></textarea></div>
        <button type="submit" class="btn btn-primary w-100" :disabled="loading">
          <span v-if="loading" class="spinner-border spinner-border-sm me-2"></span>บันทึกข้อมูล
        </button>
      </form>
    </div>
  </div></div></div>
</template>
<script setup>
import { ref, onMounted } from 'vue'; import api from '@/api'; import { useAuthStore } from '@/stores/auth'; import { useToast } from 'vue-toastification'
const auth = useAuthStore(); const toast = useToast(); const loading = ref(false)
const form = ref({ name:'', phone:'', address:'' })
onMounted(async () => { const r = await api.get('/auth.php?action=me'); form.value = { name: r.data.name, phone: r.data.phone||'', address: r.data.address||'' } })
async function save() { loading.value = true; try { await api.put('/auth.php?action=profile', form.value); toast.success('บันทึกสำเร็จ') } catch(e){ toast.error(e.message) } finally { loading.value = false } }
</script>
