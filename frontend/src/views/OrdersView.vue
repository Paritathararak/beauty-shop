<template>
  <div class="container py-5">
    <h2 class="fw-bold mb-4"><i class="bi bi-bag me-2 text-primary"></i>คำสั่งซื้อของฉัน</h2>
    <div v-if="loading" class="text-center py-5"><div class="spinner-border text-primary"></div></div>
    <div v-else-if="orders.length === 0" class="text-center py-5 text-muted"><div style="font-size:3rem">📦</div><p class="mt-2">ยังไม่มีคำสั่งซื้อ</p></div>
    <div v-else>
      <div v-for="order in orders" :key="order.id" class="card border-0 shadow-sm rounded-4 mb-3 p-4">
        <div class="d-flex justify-content-between align-items-start flex-wrap gap-2">
          <div>
            <h6 class="fw-bold mb-1">{{ order.order_number }}</h6>
            <small class="text-muted">{{ new Date(order.created_at).toLocaleDateString('th-TH', {year:'numeric',month:'long',day:'numeric'}) }}</small>
          </div>
          <div class="text-end">
            <span class="badge rounded-pill px-3 py-2" :class="`order-status-${order.status}`">{{ statusLabel[order.status] }}</span>
            <div class="fw-bold text-primary mt-1">฿{{ Number(order.total).toLocaleString() }}</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'; import api from '@/api'
const orders = ref([]); const loading = ref(true)
const statusLabel = { pending:'รอยืนยัน', confirmed:'ยืนยันแล้ว', processing:'กำลังเตรียม', shipped:'จัดส่งแล้ว', delivered:'ส่งสำเร็จ', cancelled:'ยกเลิก' }
onMounted(async () => { try { const r = await api.get('/orders.php'); orders.value = r.data.items } finally { loading.value = false } })
</script>
