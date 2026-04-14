<template>
  <div>
    <!-- Hero -->
    <section class="hero-section py-5">
      <div class="container">
        <div class="row align-items-center">
          <div class="col-lg-6">
            <span class="badge bg-primary mb-3">✨ New Arrivals</span>
            <h1 class="display-5 fw-bold mb-3">ความงามที่คุณ<span class="text-primary">สัมผัสได้</span></h1>
            <p class="text-muted mb-4">สินค้าความงามและสุขภาพคัดสรรมาเพื่อคุณโดยเฉพาะ ส่งฟรีเมื่อซื้อครบ 1,000 บาท</p>
            <router-link to="/shop" class="btn btn-primary btn-lg px-5">
              <i class="bi bi-bag-heart me-2"></i>ช้อปเลย
            </router-link>
          </div>
          <div class="col-lg-6 text-center mt-4 mt-lg-0">
            <div style="font-size:8rem">🌸</div>
          </div>
        </div>
      </div>
    </section>

    <!-- Features -->
    <section class="py-4 bg-white">
      <div class="container">
        <div class="row g-3 text-center">
          <div class="col-6 col-md-3" v-for="f in features" :key="f.icon">
            <div class="p-3"><div class="fs-2 mb-1">{{ f.icon }}</div><small class="text-muted">{{ f.text }}</small></div>
          </div>
        </div>
      </div>
    </section>

    <!-- Featured Products -->
    <section class="py-5">
      <div class="container">
        <div class="d-flex justify-content-between align-items-center mb-4">
          <h2 class="fw-bold mb-0">สินค้ายอดนิยม</h2>
          <router-link to="/shop" class="btn btn-outline-primary btn-sm">ดูทั้งหมด →</router-link>
        </div>
        <div v-if="loading" class="text-center py-5"><div class="spinner-border text-primary"></div></div>
        <div v-else class="row g-4">
          <div class="col-6 col-md-4 col-lg-3" v-for="p in products" :key="p.id">
            <ProductCard :product="p" />
          </div>
        </div>
      </div>
    </section>

    <!-- Promo Banner -->
    <section class="py-5" style="background:linear-gradient(135deg,#e91e8c,#6f42c1)">
      <div class="container text-center text-white">
        <h3 class="fw-bold mb-2">🎁 ใช้โค้ด WELCOME10</h3>
        <p class="mb-3">รับส่วนลด 10% สำหรับสมาชิกใหม่ ยอดสั่งซื้อขั้นต่ำ 500 บาท</p>
        <router-link to="/register" class="btn btn-light px-5">สมัครสมาชิกฟรี</router-link>
      </div>
    </section>
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'
import api from '@/api'
import ProductCard from '@/components/product/ProductCard.vue'
const products = ref([])
const loading = ref(true)
const features = [
  { icon: '🚚', text: 'ส่งฟรีครบ 1,000 บาท' },
  { icon: '✅', text: 'สินค้าของแท้ 100%' },
  { icon: '↩️', text: 'คืนสินค้าใน 7 วัน' },
  { icon: '🔒', text: 'ชำระเงินปลอดภัย' },
]
onMounted(async () => {
  try {
    const res = await api.get('/products.php?limit=8&sort=rating_avg')
    products.value = res.data.items
  } finally { loading.value = false }
})
</script>
