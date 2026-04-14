# 🌸 BeautyShop E-Commerce

ระบบร้านค้าออนไลน์ความงามและสุขภาพ พัฒนาด้วย Vue.js 3, Bootstrap 5, PHP, MySQL

## 🗂️ โครงสร้างโปรเจกต์

```
beauty-shop/
├── database/
│   └── schema.sql          ← SQL สร้างตาราง + Seed data
├── backend/
│   ├── config/
│   │   ├── database.php    ← เชื่อมต่อ MySQL
│   │   └── helpers.php     ← ฟังก์ชันช่วยเหลือ
│   ├── middleware/
│   │   └── auth.php        ← JWT Auth
│   └── api/
│       ├── auth.php        ← Login, Register, Profile
│       ├── products.php    ← CRUD สินค้า
│       ├── orders.php      ← จัดการออเดอร์
│       ├── reviews.php     ← รีวิวสินค้า
│       └── misc.php        ← Categories, Promos, Dashboard
└── frontend/
    ├── src/
    │   ├── api/index.js    ← Axios instance
    │   ├── stores/
    │   │   ├── auth.js     ← Pinia Auth Store
    │   │   └── cart.js     ← Pinia Cart Store
    │   ├── router/index.js ← Vue Router
    │   ├── components/
    │   │   ├── layout/     ← NavBar, Footer
    │   │   └── product/    ← ProductCard
    │   └── views/
    │       ├── HomeView.vue
    │       ├── ShopView.vue
    │       ├── ProductView.vue
    │       ├── CartView.vue
    │       ├── CheckoutView.vue
    │       ├── OrdersView.vue
    │       ├── ProfileView.vue
    │       ├── LoginView.vue
    │       ├── RegisterView.vue
    │       └── admin/
    │           ├── AdminLayout.vue
    │           ├── DashboardView.vue
    │           ├── ProductsView.vue
    │           ├── OrdersView.vue
    │           └── PromosView.vue
    ├── index.html
    ├── package.json
    └── vite.config.js
```

## 🚀 วิธีรันโปรเจกต์

### 1. ตั้งค่าฐานข้อมูล
```bash
# รัน SQL ใน phpMyAdmin หรือ MySQL CLI
mysql -u root -p < database/schema.sql
```

### 2. ตั้งค่า Backend (PHP)
```bash
# แก้ไข backend/config/database.php
# DB_USER และ DB_PASS ให้ตรงกับเครื่องของคุณ

# รัน PHP built-in server (port 8000)
cd beauty-shop
php -S localhost:8000
```

### 3. รัน Frontend (Vue.js)
```bash
cd frontend
npm install
npm run dev
# เปิด http://localhost:5173
```

## 🔑 บัญชีทดสอบ
| Role    | Email                    | Password |
|---------|--------------------------|----------|
| Admin   | admin@beautyshop.com     | password |
| User    | user@beautyshop.com      | password |

## 🛒 ฟีเจอร์หลัก
- หน้าร้านค้า + ค้นหา + กรองหมวดหมู่
- หน้ารายละเอียดสินค้า + รีวิว
- ตะกร้าสินค้า (localStorage)
- ชำระเงิน + โค้ดส่วนลด
- ระบบสมาชิก + JWT Auth
- Admin: Dashboard + Charts, จัดการสินค้า/ออเดอร์/โปรโมชั่น

## 💡 โค้ดส่วนลดทดสอบ
- `WELCOME10` — ลด 10% (ขั้นต่ำ 500 บาท)
- `BEAUTY50`  — ลด 50 บาท (ขั้นต่ำ 300 บาท)
