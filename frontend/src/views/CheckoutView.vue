<template>
  <div class="container py-5">
    <h2 class="fw-bold mb-4"><i class="bi bi-credit-card me-2 text-primary"></i>ชำระเงิน</h2>
    <div class="row g-4">
      <div class="col-lg-7">
        <div class="card border-0 shadow-sm rounded-4 p-4 mb-3">
          <h5 class="fw-bold mb-3">ที่อยู่จัดส่ง</h5>
          <div class="row g-3">
            <div class="col-md-6"><label class="form-label">ชื่อผู้รับ</label><input v-model="address.name" class="form-control" required></div>
            <div class="col-md-6"><label class="form-label">เบอร์โทร</label><input v-model="address.phone" class="form-control" required></div>
            <div class="col-12"><label class="form-label">ที่อยู่</label><textarea v-model="address.address" class="form-control" rows="2" required></textarea></div>
            <div class="col-md-6"><label class="form-label">จังหวัด</label><input v-model="address.province" class="form-control"></div>
            <div class="col-md-6"><label class="form-label">รหัสไปรษณีย์</label><input v-model="address.zip" class="form-control"></div>
          </div>
        </div>
        <div class="card border-0 shadow-sm rounded-4 p-4 mb-3">
          <h5 class="fw-bold mb-3">วิธีชำระเงิน</h5>
          <div class="form-check mb-2"><input class="form-check-input" type="radio" v-model="paymentMethod" value="cod" id="cod"><label class="form-check-label" for="cod">💵 เก็บเงินปลายทาง</label></div>
          <div class="form-check"><input class="form-check-input" type="radio" v-model="paymentMethod" value="transfer" id="transfer"><label class="form-check-label" for="transfer">🏦 โอนเงินผ่านธนาคาร</label></div>
        </div>
        <div class="card border-0 shadow-sm rounded-4 p-4">
          <h5 class="fw-bold mb-3">โค้ดส่วนลด</h5>
          <div class="input-group">
            <input v-model="couponCode" class="form-control" placeholder="WELCOME10">
            <button class="btn btn-outline-primary" @click="applyCoupon" :disabled="couponLoading">ใช้โค้ด</button>
          </div>
          <div v-if="couponMsg" class="mt-2" :class="discount > 0 ? 'text-success' : 'text-danger'">{{ couponMsg }}</div>
        </div>
      </div>
      <div class="col-lg-5">
        <div class="card border-0 shadow-sm rounded-4 p-4 sticky-top" style="top:80px">
          <h5 class="fw-bold mb-3">สรุปคำสั่งซื้อ</h5>
          <div v-for="item in cart.items" :key="item.id" class="d-flex justify-content-between mb-2 small">
            <span>{{ item.name }} × {{ item.quantity }}</span>
            <span>฿{{ (item.price * item.quantity).toLocaleString() }}</span>
          </div>
          <hr>
          <div class="d-flex justify-content-between mb-1"><span>ยอดสินค้า</span><span>฿{{ cart.totalPrice.toLocaleString() }}</span></div>
          <div v-if="discount > 0" class="d-flex justify-content-between mb-1 text-success"><span>ส่วนลด</span><span>-฿{{ discount.toLocaleString() }}</span></div>
          <div class="d-flex justify-content-between mb-1"><span>ค่าจัดส่ง</span><span>{{ cart.shippingFee === 0 ? 'ฟรี' : '฿' + cart.shippingFee }}</span></div>
          <hr>
          <div class="d-flex justify-content-between fw-bold fs-5 mb-4"><span>รวมทั้งหมด</span><span class="text-primary">฿{{ finalTotal.toLocaleString() }}</span></div>
          <button class="btn btn-primary w-100 btn-lg" @click="placeOrder" :disabled="orderLoading || cart.items.length === 0">
            <span v-if="orderLoading" class="spinner-border spinner-border-sm me-2"></span>
            <i v-else class="bi bi-bag-check me-2"></i>ยืนยันคำสั่งซื้อ
          </button>
        </div>
      </div>
    </div>
  </div>
</template>
<script setup>
import { ref, computed } from 'vue'; import { useRouter } from 'vue-router'; import api from '@/api'
import { useCartStore } from '@/stores/cart'; import { useAuthStore } from '@/stores/auth'; import { useToast } from 'vue-toastification'
const cart = useCartStore(); const auth = useAuthStore(); const router = useRouter(); const toast = useToast()
const address = ref({ name: auth.user?.name || '', phone: '', address: '', province: '', zip: '' })
const paymentMethod = ref('cod'); const couponCode = ref(''); const couponMsg = ref(''); const discount = ref(0); const couponLoading = ref(false); const orderLoading = ref(false)
const finalTotal = computed(() => Math.max(0, cart.totalPrice - discount.value + cart.shippingFee))
async function applyCoupon() {
  couponLoading.value = true; couponMsg.value = ''; discount.value = 0
  try { const r = await api.get(`/misc.php?resource=promotions&code=${couponCode.value}&amount=${cart.totalPrice}`); discount.value = r.data.discount; couponMsg.value = `ส่วนลด ฿${r.data.discount}` }
  catch(e) { couponMsg.value = e.message } finally { couponLoading.value = false }
}
async function placeOrder() {
  if (!address.value.name || !address.value.phone || !address.value.address) return toast.error('กรุณากรอกที่อยู่ให้ครบ')
  orderLoading.value = true
  try {
    const r = await api.post('/orders.php', { items: cart.items.map(i => ({ product_id: i.id, quantity: i.quantity })), shipping_address: address.value, payment_method: paymentMethod.value, coupon_code: couponCode.value || null })
    cart.clearCart(); toast.success('สั่งซื้อสำเร็จ! 🎉'); router.push('/orders')
  } catch(e) { toast.error(e.message) } finally { orderLoading.value = false }
}
</script>
