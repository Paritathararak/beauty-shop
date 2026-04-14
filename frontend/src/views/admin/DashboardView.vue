<template>
  <div>
    <div v-if="loading" class="text-center py-5"><div class="spinner-border text-primary"></div></div>
    <template v-else>
      <!-- Stat Cards -->
      <div class="row g-4 mb-4">
        <div class="col-6 col-md-3" v-for="s in stats" :key="s.label">
          <div class="card border-0 shadow-sm rounded-4 p-4 text-center">
            <div class="fs-2 mb-1">{{ s.icon }}</div>
            <h4 class="fw-bold text-primary mb-0">{{ s.value }}</h4>
            <small class="text-muted">{{ s.label }}</small>
          </div>
        </div>
      </div>
      <!-- Charts Row -->
      <div class="row g-4 mb-4">
        <div class="col-md-8">
          <div class="card border-0 shadow-sm rounded-4 p-4">
            <h6 class="fw-bold mb-3">ยอดขาย 6 เดือนล่าสุด</h6>
            <Bar v-if="chartData" :data="chartData" :options="chartOptions" />
          </div>
        </div>
        <div class="col-md-4">
          <div class="card border-0 shadow-sm rounded-4 p-4">
            <h6 class="fw-bold mb-3">สถานะออเดอร์</h6>
            <Doughnut v-if="doughnutData" :data="doughnutData" :options="{ plugins: { legend: { position: 'bottom' } } }" />
          </div>
        </div>
      </div>
      <!-- Tables Row -->
      <div class="row g-4">
        <div class="col-md-6">
          <div class="card border-0 shadow-sm rounded-4 p-4">
            <h6 class="fw-bold mb-3">สินค้าขายดี</h6>
            <table class="table table-sm">
              <thead><tr><th>สินค้า</th><th>ขาย</th><th>รายได้</th></tr></thead>
              <tbody>
                <tr v-for="p in data?.topProducts" :key="p.name">
                  <td><small>{{ p.name }}</small></td>
                  <td>{{ p.sold }}</td>
                  <td><small>฿{{ Number(p.revenue).toLocaleString() }}</small></td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
        <div class="col-md-6">
          <div class="card border-0 shadow-sm rounded-4 p-4">
            <h6 class="fw-bold mb-3">ออเดอร์ล่าสุด</h6>
            <table class="table table-sm">
              <thead><tr><th>เลขที่</th><th>ลูกค้า</th><th>ยอด</th><th>สถานะ</th></tr></thead>
              <tbody>
                <tr v-for="o in data?.recentOrders" :key="o.id">
                  <td><small>{{ o.order_number }}</small></td>
                  <td><small>{{ o.user_name }}</small></td>
                  <td><small>฿{{ Number(o.total).toLocaleString() }}</small></td>
                  <td><span class="badge rounded-pill" :class="`order-status-${o.status}`" style="font-size:.65rem">{{ o.status }}</span></td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </template>
  </div>
</template>
<script setup>
import { ref, computed, onMounted } from 'vue'
import { Bar, Doughnut } from 'vue-chartjs'
import { Chart as ChartJS, CategoryScale, LinearScale, BarElement, Title, Tooltip, Legend, ArcElement } from 'chart.js'
import api from '@/api'
ChartJS.register(CategoryScale, LinearScale, BarElement, Title, Tooltip, Legend, ArcElement)
const data = ref(null); const loading = ref(true)
const stats = computed(() => !data.value ? [] : [
  { icon: '💰', label: 'รายได้รวม', value: '฿' + Number(data.value.totalRevenue).toLocaleString() },
  { icon: '🛍️', label: 'คำสั่งซื้อ', value: data.value.totalOrders },
  { icon: '📦', label: 'สินค้า', value: data.value.totalProducts },
  { icon: '👥', label: 'ลูกค้า', value: data.value.totalUsers },
])
const chartData = computed(() => {
  if (!data.value?.monthlySales) return null
  return { labels: data.value.monthlySales.map(m => m.month), datasets: [{ label: 'รายได้ (฿)', data: data.value.monthlySales.map(m => m.revenue), backgroundColor: '#e91e8c88', borderColor: '#e91e8c', borderWidth: 2, borderRadius: 8 }] }
})
const chartOptions = { responsive: true, plugins: { legend: { display: false } } }
const doughnutData = computed(() => {
  if (!data.value?.ordersByStatus) return null
  const colors = { pending:'#ffc107', confirmed:'#0dcaf0', processing:'#0d6efd', shipped:'#198754', delivered:'#20c997', cancelled:'#dc3545' }
  return { labels: data.value.ordersByStatus.map(s => s.status), datasets: [{ data: data.value.ordersByStatus.map(s => s.count), backgroundColor: data.value.ordersByStatus.map(s => colors[s.status] || '#aaa') }] }
})
onMounted(async () => { try { const r = await api.get('/misc.php?resource=dashboard'); data.value = r.data } finally { loading.value = false } })
</script>
