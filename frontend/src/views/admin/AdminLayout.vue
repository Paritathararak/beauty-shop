<template>
  <div class="d-flex min-vh-100">
    <!-- Sidebar -->
    <div class="bg-dark text-white d-flex flex-column" style="width:240px;min-height:100vh">
      <div class="p-4 border-bottom border-secondary">
        <h5 class="mb-0"><i class="bi bi-heart-fill text-primary me-2"></i>Admin Panel</h5>
      </div>
      <nav class="p-3 flex-grow-1">
        <router-link v-for="m in menu" :key="m.to" :to="m.to" class="d-flex align-items-center gap-2 p-2 mb-1 text-white text-decoration-none rounded" :class="{ 'bg-primary': $route.path === m.to, 'opacity-75': $route.path !== m.to }">
          <i :class="`bi ${m.icon}`"></i>{{ m.label }}
        </router-link>
      </nav>
      <div class="p-3 border-top border-secondary">
        <router-link to="/" class="text-muted text-decoration-none small"><i class="bi bi-arrow-left me-1"></i>กลับหน้าร้าน</router-link>
      </div>
    </div>
    <!-- Content -->
    <div class="flex-grow-1 bg-light">
      <div class="bg-white border-bottom px-4 py-3 d-flex justify-content-between align-items-center">
        <h6 class="mb-0 fw-bold">{{ $route.meta.title || 'Dashboard' }}</h6>
        <span class="text-muted small">{{ auth.user?.name }}</span>
      </div>
      <div class="p-4"><router-view /></div>
    </div>
  </div>
</template>
<script setup>
import { useAuthStore } from '@/stores/auth'
const auth = useAuthStore()
const menu = [
  { to: '/admin',          icon: 'bi-speedometer2', label: 'Dashboard' },
  { to: '/admin/products', icon: 'bi-box-seam',     label: 'สินค้า' },
  { to: '/admin/orders',   icon: 'bi-bag',          label: 'คำสั่งซื้อ' },
  { to: '/admin/promos',   icon: 'bi-tag',          label: 'โปรโมชั่น' },
]
</script>
