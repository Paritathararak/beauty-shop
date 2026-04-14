<template>
  <div>
    <h5 class="fw-bold mb-4">จัดการคำสั่งซื้อ</h5>
    <div class="mb-3">
      <div class="btn-group btn-group-sm">
        <button v-for="s in statuses" :key="s.val" class="btn" :class="filterStatus === s.val ? 'btn-primary' : 'btn-outline-secondary'" @click="filterStatus = s.val; fetchOrders()">{{ s.label }}</button>
      </div>
    </div>
    <div class="card border-0 shadow-sm rounded-4">
      <div v-if="loading" class="text-center py-4"><div class="spinner-border text-primary spinner-border-sm"></div></div>
      <table v-else class="table table-hover mb-0">
        <thead class="table-light"><tr><th>เลขที่</th><th>ลูกค้า</th><th>ยอดรวม</th><th>สถานะ</th><th>วันที่</th><th>อัปเดต</th></tr></thead>
        <tbody>
          <tr v-for="o in orders" :key="o.id">
            <td class="fw-semibold small">{{ o.order_number }}</td>
            <td><small>{{ o.user_name }}<br><span class="text-muted">{{ o.user_email }}</span></small></td>
            <td class="text-primary fw-semibold">฿{{ Number(o.total).toLocaleString() }}</td>
            <td><span class="badge rounded-pill px-3" :class="`order-status-${o.status}`">{{ statusLabel[o.status] }}</span></td>
            <td><small>{{ new Date(o.created_at).toLocaleDateString('th-TH') }}</small></td>
            <td>
              <select class="form-select form-select-sm" :value="o.status" @change="updateStatus(o.id, $event.target.value)" style="min-width:130px">
                <option v-for="s in statuses.slice(1)" :key="s.val" :value="s.val">{{ s.label }}</option>
              </select>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'; import api from '@/api'; import { useToast } from 'vue-toastification'
const toast = useToast(); const orders = ref([]); const loading = ref(true); const filterStatus = ref('')
const statuses = [ { val:'', label:'ทั้งหมด' }, { val:'pending', label:'รอยืนยัน' }, { val:'confirmed', label:'ยืนยัน' }, { val:'processing', label:'กำลังเตรียม' }, { val:'shipped', label:'จัดส่ง' }, { val:'delivered', label:'ส่งแล้ว' }, { val:'cancelled', label:'ยกเลิก' } ]
const statusLabel = { pending:'รอยืนยัน', confirmed:'ยืนยัน', processing:'กำลังเตรียม', shipped:'จัดส่งแล้ว', delivered:'ส่งสำเร็จ', cancelled:'ยกเลิก' }
async function fetchOrders() { loading.value=true; try { const r = await api.get(`/orders.php?status=${filterStatus.value}`); orders.value = r.data.items } finally { loading.value=false } }
async function updateStatus(id, status) { try { await api.put(`/orders.php?id=${id}`, { status }); toast.success('อัปเดตสำเร็จ'); fetchOrders() } catch(e) { toast.error(e.message) } }
onMounted(fetchOrders)
</script>
