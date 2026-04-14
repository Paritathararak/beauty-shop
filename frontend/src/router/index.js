import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

const routes = [
  { path: '/',           name: 'Home',       component: () => import('@/views/HomeView.vue') },
  { path: '/shop',       name: 'Shop',       component: () => import('@/views/ShopView.vue') },
  { path: '/product/:id',name: 'Product',    component: () => import('@/views/ProductView.vue') },
  { path: '/cart',       name: 'Cart',       component: () => import('@/views/CartView.vue') },
  { path: '/login',      name: 'Login',      component: () => import('@/views/LoginView.vue') },
  { path: '/register',   name: 'Register',   component: () => import('@/views/RegisterView.vue') },
  {
    path: '/checkout', name: 'Checkout',
    component: () => import('@/views/CheckoutView.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/orders', name: 'Orders',
    component: () => import('@/views/OrdersView.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/profile', name: 'Profile',
    component: () => import('@/views/ProfileView.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/admin',
    component: () => import('@/views/admin/AdminLayout.vue'),
    meta: { requiresAdmin: true },
    children: [
      { path: '',         name: 'AdminDashboard', component: () => import('@/views/admin/DashboardView.vue') },
      { path: 'products', name: 'AdminProducts',  component: () => import('@/views/admin/ProductsView.vue') },
      { path: 'orders',   name: 'AdminOrders',    component: () => import('@/views/admin/OrdersView.vue') },
      { path: 'promos',   name: 'AdminPromos',    component: () => import('@/views/admin/PromosView.vue') },
    ]
  },
  { path: '/:pathMatch(.*)*', name: 'NotFound', component: () => import('@/views/NotFoundView.vue') }
]

const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior: () => ({ top: 0 })
})

router.beforeEach((to, _from, next) => {
  const auth = useAuthStore()
  if (to.meta.requiresAdmin && !auth.isAdmin) return next('/login')
  if (to.meta.requiresAuth && !auth.isLoggedIn) return next('/login')
  next()
})

export default router
