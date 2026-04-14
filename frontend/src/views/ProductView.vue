<template>
  <div class="container py-5" v-if="product">
    <nav aria-label="breadcrumb" class="mb-4">
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><router-link to="/">หน้าแรก</router-link></li>
        <li class="breadcrumb-item"><router-link to="/shop">สินค้า</router-link></li>
        <li class="breadcrumb-item active">{{ product.name }}</li>
      </ol>
    </nav>
    <div class="row g-5">
      <div class="col-md-5">
        <img :src="product.image || 'https://placehold.co/500x500/f8c8e4/e91e8c?text=Beauty'" :alt="product.name" class="img-fluid rounded-4 shadow">
      </div>
      <div class="col-md-7">
        <span class="badge bg-secondary mb-2">{{ product.category_name }}</span>
        <h2 class="fw-bold">{{ product.name }}</h2>
        <div class="mb-2">
          <span v-for="n in 5" :key="n" class="bi" :class="n <= Math.round(product.rating_avg) ? 'bi-star-fill star-filled' : 'bi-star star-empty'"></span>
          <span class="text-muted ms-2">{{ product.rating_avg }} ({{ product.rating_count }} รีวิว)</span>
        </div>
        <div class="mb-3">
          <span class="fs-3 fw-bold text-primary">฿{{ Number(product.sale_price || product.price).toLocaleString() }}</span>
          <span v-if="product.sale_price" class="text-muted text-decoration-line-through ms-2 fs-5">฿{{ Number(product.price).toLocaleString() }}</span>
        </div>
        <p class="text-muted">{{ product.description }}</p>
        <div class="mb-3">
          <small class="text-muted d-block">แบรนด์: {{ product.brand }}</small>
          <small class="text-muted d-block">คงเหลือ: {{ product.stock }} ชิ้น</small>
        </div>
        <div class="d-flex align-items-center gap-3 mb-4">
          <div class="input-group" style="width:130px">
            <button class="btn btn-outline-secondary" @click="qty > 1 && qty--">-</button>
            <input type="number" class="form-control text-center" v-model.number="qty" min="1" :max="product.stock">
            <button class="btn btn-outline-secondary" @click="qty < product.stock && qty++">+</button>
          </div>
          <button class="btn btn-primary px-4" :disabled="product.stock === 0" @click="addToCart">
            <i class="bi bi-cart-plus me-2"></i>เพิ่มลงตะกร้า
          </button>
        </div>
      </div>
    </div>
    <!-- Reviews -->
    <div class="mt-5">
      <h4 class="fw-bold mb-4">รีวิวจากลูกค้า</h4>
      <div v-if="auth.isLoggedIn" class="card border-0 shadow-sm rounded-4 p-4 mb-4">
        <h6>เขียนรีวิว</h6>
        <div class="mb-2">
          <span v-for="n in 5" :key="n" class="bi fs-4 cursor-pointer" :class="n <= reviewForm.rating ? 'bi-star-fill star-filled' : 'bi-star'" @click="reviewForm.rating = n" style="cursor:pointer"></span>
        </div>
        <input v-model="reviewForm.title" class="form-control mb-2" placeholder="หัวข้อรีวิว">
        <textarea v-model="reviewForm.comment" class="form-control mb-2" rows="3" placeholder="แชร์ประสบการณ์การใช้งาน..."></textarea>
        <button class="btn btn-primary" @click="submitReview" :disabled="!reviewForm.rating">ส่งรีวิว</button>
      </div>
      <div v-if="product.reviews?.length === 0" class="text-muted">ยังไม่มีรีวิว เป็นคนแรกที่รีวิวสินค้านี้!</div>
      <div v-for="r in product.reviews" :key="r.id" class="card border-0 shadow-sm rounded-4 p-3 mb-3">
        <div class="d-flex justify-content-between">
          <strong>{{ r.user_name }}</strong>
          <small class="text-muted">{{ new Date(r.created_at).toLocaleDateString('th-TH') }}</small>
        </div>
        <div><span v-for="n in 5" :key="n" class="bi bi-star-fill" :class="n <= r.rating ? 'star-filled' : 'star-empty'" style="font-size:.8rem"></span></div>
        <p class="mb-0 mt-1">{{ r.comment }}</p>
      </div>
    </div>
  </div>
  <div v-else class="text-center py-5"><div class="spinner-border text-primary"></div></div>
</template>
<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import api from '@/api'
import { useCartStore } from '@/stores/cart'
import { useAuthStore } from '@/stores/auth'
import { useToast } from 'vue-toastification'
const route = useRoute(); const cart = useCartStore(); const auth = useAuthStore(); const toast = useToast()
const product = ref(null); const qty = ref(1)
const reviewForm = ref({ rating: 0, title: '', comment: '' })
onMounted(async () => { const res = await api.get(`/products.php?id=${route.params.id}`); product.value = res.data })
function addToCart() { cart.addItem(product.value, qty.value); toast.success('เพิ่มสินค้าลงตะกร้าแล้ว') }
async function submitReview() {
  try {
    await api.post('/reviews.php', { product_id: product.value.id, ...reviewForm.value })
    toast.success('ขอบคุณสำหรับรีวิว!'); reviewForm.value = { rating: 0, title: '', comment: '' }
    const res = await api.get(`/products.php?id=${route.params.id}`); product.value = res.data
  } catch(e) { toast.error(e.message) }
}
</script>
