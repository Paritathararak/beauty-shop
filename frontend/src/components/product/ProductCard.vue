<template>
  <div class="card product-card shadow-sm h-100">
    <router-link :to="`/product/${product.id}`">
      <img :src="product.image || 'https://placehold.co/400x300/f8c8e4/e91e8c?text=Beauty'" :alt="product.name" class="card-img-top">
    </router-link>
    <div class="card-body d-flex flex-column">
      <small class="text-muted">{{ product.brand }}</small>
      <router-link :to="`/product/${product.id}`" class="text-decoration-none text-dark">
        <h6 class="card-title mt-1 mb-2">{{ product.name }}</h6>
      </router-link>
      <div class="mb-2">
        <span v-for="n in 5" :key="n" class="bi" :class="n <= Math.round(product.rating_avg) ? 'bi-star-fill star-filled' : 'bi-star star-empty'" style="font-size:.75rem"></span>
        <small class="text-muted ms-1">({{ product.rating_count }})</small>
      </div>
      <div class="mt-auto">
        <div class="d-flex align-items-center gap-2 mb-2">
          <span class="fw-bold text-primary fs-5">฿{{ Number(product.sale_price || product.price).toLocaleString() }}</span>
          <span v-if="product.sale_price" class="text-muted text-decoration-line-through small">฿{{ Number(product.price).toLocaleString() }}</span>
          <span v-if="product.sale_price" class="badge-sale">SALE</span>
        </div>
        <button class="btn btn-primary btn-sm w-100" :disabled="product.stock === 0" @click.prevent="addToCart">
          <i class="bi bi-cart-plus me-1"></i>{{ product.stock === 0 ? 'สินค้าหมด' : 'เพิ่มลงตะกร้า' }}
        </button>
      </div>
    </div>
  </div>
</template>
<script setup>
import { useCartStore } from '@/stores/cart'
import { useToast } from 'vue-toastification'
const props = defineProps({ product: Object })
const cart = useCartStore()
const toast = useToast()
function addToCart() { cart.addItem(props.product); toast.success('เพิ่มสินค้าลงตะกร้าแล้ว') }
</script>
