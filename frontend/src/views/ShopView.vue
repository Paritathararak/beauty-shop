<template>
  <div>
    <div class="page-hero text-center"><h2 class="fw-bold">🛍️ สินค้าทั้งหมด</h2></div>
    <div class="container py-5">
      <div class="row g-4">
        <!-- Sidebar -->
        <div class="col-lg-3">
          <div class="card border-0 shadow-sm rounded-4 p-3 mb-3">
            <h6 class="fw-bold mb-3">ค้นหาสินค้า</h6>
            <input v-model="search" @input="onSearch" type="text" class="form-control" placeholder="ชื่อสินค้า, แบรนด์...">
          </div>
          <div class="card border-0 shadow-sm rounded-4 p-3 mb-3">
            <h6 class="fw-bold mb-3">หมวดหมู่</h6>
            <div v-for="cat in categories" :key="cat.id">
              <button class="btn btn-sm w-100 text-start mb-1 sidebar-link" :class="{ active: selectedCat === cat.slug }" @click="selectCat(cat.slug)">
                {{ cat.name }} <span class="badge bg-secondary float-end">{{ cat.product_count }}</span>
              </button>
            </div>
            <button v-if="selectedCat" class="btn btn-outline-secondary btn-sm w-100 mt-2" @click="selectCat('')">ล้างตัวกรอง</button>
          </div>
          <div class="card border-0 shadow-sm rounded-4 p-3">
            <h6 class="fw-bold mb-3">เรียงตาม</h6>
            <select v-model="sort" @change="fetchProducts()" class="form-select">
              <option value="created_at">ใหม่ล่าสุด</option>
              <option value="price">ราคา: ต่ำ → สูง</option>
              <option value="rating_avg">คะแนนสูงสุด</option>
            </select>
          </div>
        </div>
        <!-- Products -->
        <div class="col-lg-9">
          <div v-if="loading" class="text-center py-5"><div class="spinner-border text-primary"></div></div>
          <template v-else>
            <p class="text-muted mb-3">พบ {{ pagination.total }} รายการ</p>
            <div v-if="products.length === 0" class="text-center py-5 text-muted"><i class="bi bi-search fs-1 d-block mb-2"></i>ไม่พบสินค้า</div>
            <div class="row g-4">
              <div class="col-6 col-md-4" v-for="p in products" :key="p.id">
                <ProductCard :product="p" />
              </div>
            </div>
            <!-- Pagination -->
            <nav class="mt-4" v-if="pagination.pages > 1">
              <ul class="pagination justify-content-center">
                <li class="page-item" :class="{ disabled: page === 1 }"><button class="page-link" @click="changePage(page-1)">‹</button></li>
                <li class="page-item" v-for="n in pagination.pages" :key="n" :class="{ active: n === page }"><button class="page-link" @click="changePage(n)">{{ n }}</button></li>
                <li class="page-item" :class="{ disabled: page === pagination.pages }"><button class="page-link" @click="changePage(page+1)">›</button></li>
              </ul>
            </nav>
          </template>
        </div>
      </div>
    </div>
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'
import api from '@/api'
import ProductCard from '@/components/product/ProductCard.vue'
const products = ref([]); const categories = ref([]); const loading = ref(true)
const search = ref(''); const selectedCat = ref(''); const sort = ref('created_at')
const page = ref(1); const pagination = ref({ total:0, pages:1 })
let searchTimer = null
async function fetchProducts() {
  loading.value = true
  try {
    const params = new URLSearchParams({ search: search.value, category: selectedCat.value, sort: sort.value, page: page.value, limit: 12 })
    const res = await api.get(`/products.php?${params}`)
    products.value = res.data.items; pagination.value = res.data.pagination
  } finally { loading.value = false }
}
function onSearch() { clearTimeout(searchTimer); searchTimer = setTimeout(() => { page.value = 1; fetchProducts() }, 400) }
function selectCat(slug) { selectedCat.value = slug; page.value = 1; fetchProducts() }
function changePage(n) { if (n >= 1 && n <= pagination.value.pages) { page.value = n; fetchProducts() } }
onMounted(async () => {
  const [,cats] = await Promise.all([fetchProducts(), api.get('/misc.php?resource=categories')])
  categories.value = cats.data
})
</script>
