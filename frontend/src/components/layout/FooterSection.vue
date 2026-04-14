<template>
  <footer class="bg-dark text-white mt-5 py-4">
    <div class="container">
      <div class="row g-4">
        <div class="col-md-4">
          <h5><i class="bi bi-heart-fill text-primary me-1"></i>BeautyShop</h5>
          <p class="text-muted small">ร้านค้าความงามและสุขภาพออนไลน์ สินค้าคุณภาพส่งตรงถึงบ้าน</p>
        </div>
        <div class="col-md-4">
          <h6>ลิงก์ด่วน</h6>
          <ul class="list-unstyled small">
            <li><router-link to="/shop" class="text-muted text-decoration-none">สินค้าทั้งหมด</router-link></li>
            <li><router-link to="/cart" class="text-muted text-decoration-none">ตะกร้าสินค้า</router-link></li>
            <li><router-link to="/orders" class="text-muted text-decoration-none">ติดตามคำสั่งซื้อ</router-link></li>
          </ul>
        </div>
        <div class="col-md-4">
          <h6>ติดต่อเรา</h6>
          <p class="text-muted small mb-1"><i class="bi bi-envelope me-2"></i>support@beautyshop.com</p>
          <p class="text-muted small"><i class="bi bi-telephone me-2"></i>02-xxx-xxxx</p>
        </div>
      </div>
      <hr class="border-secondary">
      <p class="text-center text-muted small mb-0">© {{ new Date().getFullYear() }} BeautyShop. สงวนลิขสิทธิ์</p>
    </div>
  </footer>
</template>
