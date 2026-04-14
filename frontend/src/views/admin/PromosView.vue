<template>
  <div>
    <div class="d-flex justify-content-between align-items-center mb-4">
      <h5 class="fw-bold mb-0">โปรโมชั่น / คูปอง</h5>
      <button class="btn btn-primary btn-sm" @click="showModal=true"><i class="bi bi-plus-lg me-1"></i>เพิ่มโค้ด</button>
    </div>
    <div class="card border-0 shadow-sm rounded-4">
      <table class="table table-hover mb-0">
        <thead class="table-light"><tr><th>โค้ด</th><th>ชื่อ</th><th>ส่วนลด</th><th>ใช้แล้ว</th><th>หมดอายุ</th><th>สถานะ</th></tr></thead>
        <tbody>
          <tr v-for="p in promos" :key="p.id">
            <td><span class="badge bg-dark font-monospace fs-6">{{ p.code }}</span></td>
            <td><small>{{ p.name }}</small></td>
            <td><span class="text-primary fw-bold">{{ p.type==='percent' ? p.value+'%' : '฿'+p.value }}</span><small class="text-muted d-block">ขั้นต่ำ ฿{{ p.min_order }}</small></td>
            <td>{{ p.usage_count }}{{ p.usage_limit ? ' / '+p.usage_limit : '' }}</td>
            <td><small>{{ p.expires_at ? new Date(p.expires_at).toLocaleDateString('th-TH') : 'ไม่มีกำหนด' }}</small></td>
            <td><div class="form-check form-switch"><input class="form-check-input" type="checkbox" :checked="p.is_active" @change="togglePromo(p.id, $event.target.checked)"></div></td>
          </tr>
        </tbody>
      </table>
    </div>
    <!-- Modal -->
    <div v-if="showModal" class="modal d-block" style="background:rgba(0,0,0,.5)">
      <div class="modal-dialog modal-dialog-centered"><div class="modal-content rounded-4 border-0">
        <div class="modal-header border-0"><h5 class="modal-title fw-bold">เพิ่มโค้ดส่วนลด</h5><button class="btn-close" @click="showModal=false"></button></div>
        <div class="modal-body">
          <div class="mb-3"><label class="form-label">โค้ด</label><input v-model="form.code" class="form-control font-monospace" placeholder="BEAUTY10" required></div>
          <div class="mb-3"><label class="form-label">ชื่อโปรโมชั่น</label><input v-model="form.name" class="form-control"></div>
          <div class="row g-3 mb-3">
            <div class="col-6"><label class="form-label">ประเภท</label><select v-model="form.type" class="form-select"><option value="percent">เปอร์เซ็นต์ (%)</option><option value="fixed">จำนวนเงิน (฿)</option></select></div>
            <div class="col-6"><label class="form-label">ส่วนลด</label><input v-model.number="form.value" type="number" class="form-control"></div>
          </div>
          <div class="row g-3 mb-3">
            <div class="col-6"><label class="form-label">ยอดขั้นต่ำ (฿)</label><input v-model.number="form.min_order" type="number" class="form-control"></div>
            <div class="col-6"><label class="form-label">จำนวนสิทธิ์</label><input v-model.number="form.usage_limit" type="number" class="form-control" placeholder="ไม่จำกัด"></div>
          </div>
          <div class="mb-3"><label class="form-label">วันหมดอายุ</label><input v-model="form.expires_at" type="date" class="form-control"></div>
        </div>
        <div class="modal-footer border-0">
          <button class="btn btn-secondary" @click="showModal=false">ยกเลิก</button>
          <button class="btn btn-primary" @click="addPromo">บันทึก</button>
        </div>
      </div></div>
    </div>
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'; import api from '@/api'; import { useToast } from 'vue-toastification'
const toast = useToast(); const promos = ref([]); const showModal = ref(false)
const form = ref({ code:'', name:'', type:'percent', value:10, min_order:0, usage_limit:null, expires_at:'' })
async function fetchPromos() { const r = await api.get('/misc.php?resource=promotions'); promos.value = r.data }
async function addPromo() { try { await api.post('/misc.php?resource=promotions', form.value); toast.success('เพิ่มโค้ดสำเร็จ'); showModal.value=false; fetchPromos() } catch(e) { toast.error(e.message) } }
async function togglePromo(id, val) { await api.put(`/misc.php?resource=promotions&id=${id}`, { is_active: val ? 1 : 0 }); toast.success('อัปเดตสำเร็จ') }
onMounted(fetchPromos)
</script>
