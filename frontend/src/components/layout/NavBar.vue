<template>
  <nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm sticky-top">
    <div class="container">
      <router-link class="navbar-brand" to="/">
        <i class="bi bi-heart-fill text-primary me-1"></i>
        <span>Beauty</span>Shop
      </router-link>
      <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navMenu">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse" id="navMenu">
        <ul class="navbar-nav me-auto">
          <li class="nav-item"><router-link class="nav-link" to="/">หน้าแรก</router-link></li>
          <li class="nav-item"><router-link class="nav-link" to="/shop">สินค้าทั้งหมด</router-link></li>
        </ul>
        <div class="d-flex align-items-center gap-3">
          <router-link to="/cart" class="position-relative text-dark">
            <i class="bi bi-cart3 fs-5"></i>
            <span v-if="cart.totalItems > 0" class="cart-badge">{{ cart.totalItems }}</span>
          </router-link>
          <template v-if="auth.isLoggedIn">
            <div class="dropdown">
              <button class="btn btn-outline-primary btn-sm dropdown-toggle" data-bs-toggle="dropdown">
                <i class="bi bi-person-circle me-1"></i>{{ auth.user?.name }}
              </button>
              <ul class="dropdown-menu dropdown-menu-end">
                <li v-if="auth.isAdmin"><router-link class="dropdown-item" to="/admin"><i class="bi bi-speedometer2 me-2"></i>Admin Panel</router-link></li>
                <li><router-link class="dropdown-item" to="/orders"><i class="bi bi-bag me-2"></i>คำสั่งซื้อ</router-link></li>
                <li><router-link class="dropdown-item" to="/profile"><i class="bi bi-person me-2"></i>โปรไฟล์</router-link></li>
                <li><hr class="dropdown-divider"></li>
                <li><button class="dropdown-item text-danger" @click="logout"><i class="bi bi-box-arrow-right me-2"></i>ออกจากระบบ</button></li>
              </ul>
            </div>
          </template>
          <template v-else>
            <router-link to="/login" class="btn btn-outline-primary btn-sm">เข้าสู่ระบบ</router-link>
            <router-link to="/register" class="btn btn-primary btn-sm">สมัครสมาชิก</router-link>
          </template>
        </div>
      </div>
    </div>
  </nav>
</template>
<script setup>
import { useAuthStore } from '@/stores/auth'
import { useCartStore } from '@/stores/cart'
import { useRouter } from 'vue-router'
const auth = useAuthStore()
const cart = useCartStore()
const router = useRouter()
function logout() { auth.logout(); router.push('/') }
</script>
