<template>
  <div>
    <div class="d-flex justify-content-between align-items-center mb-4">
      <h5 class="fw-bold mb-0">จัดการสินค้า</h5>
      <button class="btn btn-primary btn-sm" @click="openModal()"><i class="bi bi-plus-lg me-1"></i>เพิ่มสินค้า</button>
    </div>
    <div class="card border-0 shadow-sm rounded-4">
      <div class="card-body p-0">
        <div class="p-3 border-bottom"><input v-model="search" @input="fetchProducts" class="form-control form-control-sm" style="max-width:300px" placeholder="ค้นหาสินค้า..."></div>
        <div v-if="loading" class="text-center py-4"><div class="spinner-border text-primary spinner-border-sm"></div></div>
        <table v-else class="table table-hover mb-0">
          <thead class="table-light"><tr><th>สินค้า</th><th>ราคา</th><th>คงเหลือ</th><th>สถานะ</th><th>จัดการ</th></tr></thead>
          <tbody>
            <tr v-for="p in products" :key="p.id">
              <td><div class="d-flex align-items-center gap-2"><img :src="p.image||'https://placehold.co/40x40/f8c8e4/e91e8c?text=B'" style="width:40px;height:40px;object-fit:cover;border-radius:8px"><div><div class="fw-semibold small">{{ p.name }}</div><small class="text-muted">{{ p.brand }}</small></div></div></td>
              <td><span class="text-primary fw-semibold">฿{{ Number(p.sale_price||p.price).toLocaleString() }}</span><br><small v-if="p.sale_price" class="text-muted text-decoration-line-through">฿{{ Number(p.price).toLocaleString() }}</small></td>
              <td><span :class="p.stock < 5 ? 'text-danger fw-bold' : ''">{{ p.stock }}</span></td>
              <td><span class="badge" :class="p.is_active ? 'bg-success' : 'bg-secondary'">{{ p.is_active ? 'เปิดขาย' : 'ปิด' }}</span></td>
              <td>
                <button class="btn btn-outline-primary btn-sm me-1" @click="openModal(p)"><i class="bi bi-pencil"></i></button>
                <button class="btn btn-outline-danger btn-sm" @click="deleteProduct(p.id)"><i class="bi bi-trash"></i></button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Modal -->
    <div v-if="showModal" class="modal d-block" style="background:rgba(0,0,0,.5)">
      <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content rounded-4 border-0">
          <div class="modal-header border-0"><h5 class="modal-title fw-bold">{{ editProduct?.id ? 'แก้ไขสินค้า' : 'เพิ่มสินค้า' }}</h5><button class="btn-close" @click="showModal=false"></button></div>
          <div class="modal-body">
            <div class="row g-3">
              <div class="col-md-8"><label class="form-label">ชื่อสินค้า</label><input v-model="form.name" class="form-control" required></div>
              <div class="col-md-4"><label class="form-label">SKU</label><input v-model="form.sku" class="form-control"></div>
              <div class="col-md-6"><label class="form-label">ราคาปกติ (฿)</label><input v-model.number="form.price" type="number" class="form-control" required></div>
              <div class="col-md-6"><label class="form-label">ราคาลด (฿)</label><input v-model.number="form.sale_price" type="number" class="form-control"></div>
              <div class="col-md-6"><label class="form-label">คงเหลือ</label><input v-model.number="form.stock" type="number" class="form-control"></div>
              <div class="col-md-6"><label class="form-label">แบรนด์</label><input v-model="form.brand" class="form-control"></div>
              <div class="col-12"><label class="form-label">หมวดหมู่</label>
                <select v-model.number="form.category_id" class="form-select">
                  <option v-for="c in categories" :key="c.id" :value="c.id">{{ c.name }}</option>
                </select>
              </div>
              <div class="col-12"><label class="form-label">รายละเอียด</label><textarea v-model="form.description" class="form-control" rows="3"></textarea></div>
              <div class="col-12"><label class="form-label">URL รูปภาพ</label><input v-model="form.image" class="form-control" placeholder="https://..."></div>
              <div class="col-12"><div class="form-check"><input v-model="form.is_active" class="form-check-input" type="checkbox" id="isActive"><label class="form-check-label" for="isActive">เปิดขาย</label></div></div>
            </div>
          </div>
          <div class="modal-footer border-0">
            <button class="btn btn-secondary" @click="showModal=false">ยกเลิก</button>
            <button class="btn btn-primary" @click="saveProduct" :disabled="saving"><span v-if="saving" class="spinner-border spinner-border-sm me-1"></span>บันทึก</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'; import api from '@/api'; import { useToast } from 'vue-toastification'
const toast = useToast()
const products = ref([]); const categories = ref([]); const loading = ref(true); const saving = ref(false)
const showModal = ref(false); const editProduct = ref(null); const search = ref('')
const form = ref({ name:'', sku:'', price:0, sale_price:null, stock:0, brand:'', category_id:'', description:'', image:'', is_active:1 })
let searchTimer = null
async function fetchProducts() { clearTimeout(searchTimer); searchTimer = setTimeout(async () => { loading.value=true; try { const r = await api.get(`/products.php?search=${search.value}&limit=50`); products.value = r.data.items } finally { loading.value=false } }, 400) }
function openModal(p = null) { editProduct.value = p; form.value = p ? { ...p } : { name:'',sku:'',price:0,sale_price:null,stock:0,brand:'',category_id:categories.value[0]?.id||'',description:'',image:'',is_active:1 }; showModal.value = true }
async function saveProduct() {
  saving.value = true
  try { editProduct.value?.id ? await api.put(`/products.php?id=${editProduct.value.id}`, form.value) : await api.post('/products.php', form.value); toast.success('บันทึกสำเร็จ'); showModal.value = false; fetchProducts() }
  catch(e) { toast.error(e.message) } finally { saving.value = false }
}
async function deleteProduct(id) { if (!confirm('ยืนยันลบสินค้า?')) return; await api.delete(`/products.php?id=${id}`); toast.success('ลบสำเร็จ'); fetchProducts() }
onMounted(async () => { const [,cats] = await Promise.all([fetchProducts(), api.get('/misc.php?resource=categories')]); categories.value = cats.data })
</script>
