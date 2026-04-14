<template>
  <div class="container py-5">
    <h2 class="fw-bold mb-4"><i class="bi bi-cart3 me-2 text-primary"></i>ตะกร้าสินค้า</h2>
    <div v-if="cart.items.length === 0" class="text-center py-5">
      <div style="font-size:4rem">🛒</div>
      <h5 class="text-muted mt-3">ตะกร้าของคุณว่างเปล่า</h5>
      <router-link to="/shop" class="btn btn-primary mt-3">ช้อปสินค้า</router-link>
    </div>
    <div v-else class="row g-4">
      <div class="col-lg-8">
        <div class="card border-0 shadow-sm rounded-4">
          <div class="card-body p-0">
            <div v-for="item in cart.items" :key="item.id" class="d-flex align-items-center gap-3 p-3 border-bottom">
              <img :src="item.image || 'https://placehold.co/80x80/f8c8e4/e91e8c?text=B'" :alt="item.name" style="width:80px;height:80px;object-fit:cover;border-radius:12px">
              <div class="flex-grow-1">
                <p class="mb-1 fw-semibold">{{ item.name }}</p>
                <p class="mb-0 text-primary fw-bold">฿{{ Number(item.price).toLocaleString() }}</p>
              </div>
              <div class="input-group" style="width:120px">
                <button class="btn btn-outline-secondary btn-sm" @click="cart.updateQuantity(item.id, item.quantity-1)">-</button>
                <input type="number" class="form-control form-control-sm text-center" :value="item.quantity" @change="cart.updateQuantity(item.id, +$event.target.value)" min="1">
                <button class="btn btn-outline-secondary btn-sm" @click="cart.updateQuantity(item.id, item.quantity+1)">+</button>
              </div>
              <span class="fw-bold" style="min-width:80px;text-align:right">฿{{ (item.price * item.quantity).toLocaleString() }}</span>
              <button class="btn btn-sm text-danger" @click="cart.removeItem(item.id)"><i class="bi bi-trash"></i></button>
            </div>
          </div>
        </div>
      </div>
      <div class="col-lg-4">
        <div class="card border-0 shadow-sm rounded-4 p-4">
          <h5 class="fw-bold mb-3">สรุปคำสั่งซื้อ</h5>
          <div class="d-flex justify-content-between mb-2"><span>ยอดสินค้า</span><span>฿{{ cart.totalPrice.toLocaleString() }}</span></div>
          <div class="d-flex justify-content-between mb-2"><span>ค่าจัดส่ง</span><span :class="cart.shippingFee === 0 ? 'text-success' : ''">{{ cart.shippingFee === 0 ? 'ฟรี' : '฿' + cart.shippingFee }}</span></div>
          <hr>
          <div class="d-flex justify-content-between fw-bold fs-5 mb-3"><span>รวม</span><span class="text-primary">฿{{ cart.grandTotal.toLocaleString() }}</span></div>
          <router-link to="/checkout" class="btn btn-primary w-100 btn-lg">ดำเนินการสั่งซื้อ →</router-link>
          <p v-if="cart.shippingFee > 0" class="text-muted text-center small mt-2">ซื้อเพิ่มอีก ฿{{ (1000 - cart.totalPrice).toLocaleString() }} รับส่งฟรี!</p>
        </div>
      </div>
    </div>
  </div>
</template>
<script setup>
import { useCartStore } from '@/stores/cart'
const cart = useCartStore()
</script>
