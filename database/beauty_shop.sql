-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 14, 2026 at 07:16 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `beauty_shop`
--

-- --------------------------------------------------------

--
-- Table structure for table `cart_items`
--

CREATE TABLE `cart_items` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `slug` varchar(120) NOT NULL,
  `description` text DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `name`, `slug`, `description`, `image`, `created_at`) VALUES
(1, 'สกินแคร์', 'skincare', 'ผลิตภัณฑ์ดูแลผิวหน้าและผิวกาย', NULL, '2026-04-14 04:15:15'),
(2, 'เมกอัพ', 'makeup', 'เครื่องสำอางและผลิตภัณฑ์แต่งหน้า', NULL, '2026-04-14 04:15:15'),
(3, 'ผมและหนังศีรษะ', 'hair', 'ผลิตภัณฑ์ดูแลเส้นผมและหนังศีรษะ', NULL, '2026-04-14 04:15:15'),
(4, 'น้ำหอม', 'fragrance', 'น้ำหอมและโลชั่นกลิ่นหอม', NULL, '2026-04-14 04:15:15'),
(5, 'วิตามินและอาหารเสริม', 'supplements', 'วิตามินและผลิตภัณฑ์เสริมอาหาร', NULL, '2026-04-14 04:15:15');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `order_number` varchar(30) NOT NULL,
  `status` enum('pending','confirmed','processing','shipped','delivered','cancelled') DEFAULT 'pending',
  `subtotal` decimal(10,2) NOT NULL,
  `discount` decimal(10,2) DEFAULT 0.00,
  `shipping_fee` decimal(10,2) DEFAULT 0.00,
  `total` decimal(10,2) NOT NULL,
  `coupon_code` varchar(50) DEFAULT NULL,
  `shipping_address` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`shipping_address`)),
  `payment_method` varchar(50) DEFAULT 'cod',
  `note` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) DEFAULT NULL,
  `product_name` varchar(200) NOT NULL,
  `product_image` varchar(255) DEFAULT NULL,
  `quantity` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `total` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `category_id` int(11) DEFAULT NULL,
  `name` varchar(200) NOT NULL,
  `slug` varchar(220) NOT NULL,
  `description` text DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `sale_price` decimal(10,2) DEFAULT NULL,
  `stock` int(11) DEFAULT 0,
  `image` varchar(255) DEFAULT NULL,
  `images` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`images`)),
  `sku` varchar(80) DEFAULT NULL,
  `brand` varchar(100) DEFAULT NULL,
  `rating_avg` decimal(3,2) DEFAULT 0.00,
  `rating_count` int(11) DEFAULT 0,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `category_id`, `name`, `slug`, `description`, `price`, `sale_price`, `stock`, `image`, `images`, `sku`, `brand`, `rating_avg`, `rating_count`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 1, 'Vitamin C Serum 30ml', 'vitamin-c-serum-30ml', 'เซรั่มวิตามินซีเข้มข้น ช่วยให้ผิวกระจ่างใสและลดจุดด่างดำ', 890.00, 750.00, 50, 'https://images.unsplash.com/photo-1570194065650-d99fb4bedf0a?w=400', NULL, 'SK001', 'GlowSkin', 0.00, 0, 1, '2026-04-14 04:15:15', '2026-04-14 05:10:14'),
(2, 1, 'Hyaluronic Acid Moisturizer', 'hyaluronic-acid-moisturizer', 'มอยส์เจอไรเซอร์ไฮยาลูโรนิค ให้ความชุ่มชื้นสูงสุด 24 ชั่วโมง', 1290.00, NULL, 30, 'https://images.unsplash.com/photo-1556228578-8c89e6adf883?w=400', NULL, 'SK002', 'HydraGlow', 0.00, 0, 1, '2026-04-14 04:15:15', '2026-04-14 05:10:14'),
(3, 2, 'Cushion SPF50+ PA++++', 'cushion-spf50-pa', 'คุชชั่นครีมกันแดดสูตรเบา ป้องกันแสงแดดสูงสุด', 650.00, 599.00, 80, 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=400', NULL, 'MK001', 'FlawlessBase', 0.00, 0, 1, '2026-04-14 04:15:15', '2026-04-14 05:10:14'),
(4, 3, 'Repair Hair Mask 200ml', 'repair-hair-mask-200ml', 'มาส์กผมสูตรเข้มข้น ฟื้นฟูผมเสียให้นุ่มลื่น', 420.00, NULL, 45, 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=400', NULL, 'HR001', 'HairLab', 0.00, 0, 1, '2026-04-14 04:15:15', '2026-04-14 05:10:14'),
(5, 5, 'Collagen Peptide 30 Sachets', 'collagen-peptide-30-sachets', 'คอลลาเจนเปปไทด์ดูดซึมเร็ว บำรุงผิวจากภายใน', 1590.00, 1390.00, 25, 'https://images.unsplash.com/photo-1512290923902-8a9f81dc236c?w=400', NULL, 'SP001', 'BeautyHealth', 0.00, 0, 1, '2026-04-14 04:15:15', '2026-04-14 05:10:14'),
(6, 4, 'Rose Garden Eau de Parfum 50ml', 'rose-garden-edp-50ml', 'น้ำหอมกลิ่นดอกกุหลาบสดชื่น ผสมผสานกับวานิลลาและมัสก์ อ่อนหวานและหรูหรา เหมาะสำหรับสาวๆ ทุกวัย', 1290.00, 990.00, 40, 'https://images.unsplash.com/photo-1541643600914-78b084683702?w=400', NULL, 'FR001', 'FloraLux', 4.50, 28, 1, '2026-04-14 05:13:07', '2026-04-14 05:13:07'),
(7, 4, 'Midnight Oud Parfum 75ml', 'midnight-oud-parfum-75ml', 'น้ำหอมกลิ่นไม้อู้ดลึกลับ ผสมแอมเบอร์และแซนดัลวู้ด กลิ่นหนักแน่นติดทนนาน เหมาะสำหรับกลางคืน', 2490.00, NULL, 25, 'https://images.unsplash.com/photo-1592945403244-b3fbafd7f539?w=400', NULL, 'FR002', 'OudElite', 4.80, 15, 1, '2026-04-14 05:13:07', '2026-04-14 05:13:07'),
(8, 4, 'Cherry Blossom EDT 30ml', 'cherry-blossom-edt-30ml', 'น้ำหอมกลิ่นดอกซากุระ สดใสและละมุน ผสมพีชและส้ม เหมาะสำหรับสาวรักความน่ารัก', 650.00, 550.00, 60, 'https://images.unsplash.com/photo-1590156206657-e1b2a4a0f8d4?w=400', NULL, 'FR003', 'SakuraMist', 4.20, 42, 1, '2026-04-14 05:13:07', '2026-04-14 05:13:07'),
(9, 4, 'Velvet Amber Parfum 100ml', 'velvet-amber-parfum-100ml', 'น้ำหอมแอมเบอร์อบอุ่น ผสมหญ้าฝรั่นและกุหลาบ กลิ่นหวานลึกและเย้ายวน ติดทนมากกว่า 12 ชั่วโมง', 3200.00, 2890.00, 20, 'https://images.unsplash.com/photo-1547887538-e3a2f32cb1cc?w=400', NULL, 'FR004', 'AmberVelvet', 4.90, 8, 1, '2026-04-14 05:13:07', '2026-04-14 05:13:07'),
(10, 4, 'Ocean Breeze EDT 50ml', 'ocean-breeze-edt-50ml', 'น้ำหอมกลิ่นทะเล สดชื่นและเบาบาง ผสมมะนาว มิ้นต์ และเกลือทะเล เหมาะสำหรับใส่กลางวัน', 890.00, NULL, 55, 'https://images.unsplash.com/photo-1571781926291-c477ebfd024b?w=400', NULL, 'FR005', 'AquaPure', 4.00, 33, 1, '2026-04-14 05:13:07', '2026-04-14 05:13:07'),
(11, 4, 'French Vanilla EDP 60ml', 'french-vanilla-edp-60ml', 'น้ำหอมวานิลลาฝรั่งเศส หอมหวานและนุ่มนวล ผสมคาราเมลและซีดาร์วู้ด กลิ่นอบอุ่นเหมือนกอดรัก', 1490.00, 1190.00, 35, 'https://images.unsplash.com/photo-1588405748880-12d1d2a59f75?w=400', NULL, 'FR006', 'DouxParfum', 4.60, 19, 1, '2026-04-14 05:13:07', '2026-04-14 05:13:07'),
(12, 4, 'Black Orchid Parfum 50ml', 'black-orchid-parfum-50ml', 'น้ำหอมกล้วยไม้ดำ ลึกลับและหรูหรา ผสมพลัม ช็อกโกแลต และพาทชูลี สำหรับผู้หญิงมั่นใจ', 2100.00, NULL, 18, 'https://images.unsplash.com/photo-1590439471364-192aa70c0b53?w=400', NULL, 'FR007', 'LuxOrchid', 4.70, 12, 1, '2026-04-14 05:13:07', '2026-04-14 05:13:07'),
(13, 4, 'Citrus Splash EDT 100ml', 'citrus-splash-edt-100ml', 'น้ำหอมซิตรัสสดใส ผสมเบอร์กาม็อต เกรปฟรุต และมะนาว สดชื่นตลอดวัน เหมาะสำหรับอากาศร้อน', 750.00, 650.00, 70, 'https://images.unsplash.com/photo-1585386959984-a4155224a1ad?w=400', NULL, 'FR008', 'FreshCitrus', 4.10, 51, 1, '2026-04-14 05:13:07', '2026-04-14 05:13:07'),
(14, 4, 'Jasmine Nights EDP 45ml', 'jasmine-nights-edp-45ml', 'น้ำหอมมะลิยามค่ำคืน กลิ่นดอกไม้หอมอ่อนโยน ผสมแซมบัคแจสมินและมัสก์ขาว ติดทนตลอดคืน', 1150.00, NULL, 42, 'https://images.unsplash.com/photo-1578301978018-3005759f48f7?w=400', NULL, 'FR009', 'JasmineAura', 4.40, 24, 1, '2026-04-14 05:13:07', '2026-04-14 05:13:07'),
(15, 4, 'Oud Rose Intense 75ml', 'oud-rose-intense-75ml', 'น้ำหอมอู้ดผสมกุหลาบ เข้มข้นและหรูหรา ได้รับแรงบันดาลใจจากน้ำหอมตะวันออกกลาง ติดทนนาน 24 ชั่วโมง', 3800.00, 3490.00, 15, 'https://images.unsplash.com/photo-1608248597279-f99d160bfcbc?w=400', NULL, 'FR010', 'ArabiqueOud', 5.00, 6, 1, '2026-04-14 05:13:07', '2026-04-14 05:13:07'),
(16, 4, 'White Tea & Ginger EDT 50ml', 'white-tea-ginger-edt-50ml', 'น้ำหอมชาขาวผสมขิง สะอาดและสดชื่น ผสมดอกไม้ขาวและมัสก์ กลิ่นสะอาดเหมือนเพิ่งอาบน้ำ', 980.00, 850.00, 48, 'https://images.unsplash.com/photo-1556228453-efd6c1ff04f6?w=400', NULL, 'FR011', 'TeaGarden', 4.30, 37, 1, '2026-04-14 05:13:07', '2026-04-14 05:13:07'),
(17, 4, 'Peony & Blush Suede EDP 80ml', 'peony-blush-suede-edp-80ml', 'น้ำหอมดอก Peony ผสมหนังกวาง กลิ่นหวานและนุ่มนวล เหมาะสำหรับสาวที่ชื่นชอบความโรแมนติก', 1850.00, NULL, 30, 'https://images.unsplash.com/photo-1523293182086-7651a899d37f?w=400', NULL, 'FR012', 'BlushFleur', 4.50, 21, 1, '2026-04-14 05:13:07', '2026-04-14 05:13:07'),
(18, 4, 'Sandalwood Dreams EDP 60ml', 'sandalwood-dreams-edp-60ml', 'น้ำหอมแซนดัลวู้ดอบอุ่น ผสมอ้อยและกานพลู กลิ่นไม้หอมลึกและน่าหลงใหล เหมาะสำหรับฤดูหนาว', 1680.00, 1380.00, 22, 'https://images.unsplash.com/photo-1605651202774-7d573fd3f12d?w=400', NULL, 'FR013', 'WoodSage', 4.60, 16, 1, '2026-04-14 05:13:07', '2026-04-14 05:13:07'),
(19, 4, 'Floral Bouquet EDT 35ml', 'floral-bouquet-edt-35ml', 'น้ำหอมช่อดอกไม้ ผสมกุหลาบ ลิลลี่ และฟรีเซีย สดใสและสวยงาม เหมาะสำหรับสาวรักธรรมชาติ', 590.00, NULL, 65, 'https://images.unsplash.com/photo-1563170351-be54ebebc8e5?w=400', NULL, 'FR014', 'GardenBloom', 4.00, 44, 1, '2026-04-14 05:13:07', '2026-04-14 05:13:07'),
(20, 4, 'Luxury Musk Collection 100ml', 'luxury-musk-collection-100ml', 'น้ำหอมมัสก์พรีเมียม ผสมมัสก์ขาว ฝ้าย และอำพัน กลิ่นสะอาดและหรูหรา ใส่ได้ทุกโอกาส', 2250.00, 1990.00, 28, 'https://images.unsplash.com/photo-1615634260167-c8cdede054de?w=400', NULL, 'FR015', 'PureMusk', 4.70, 31, 1, '2026-04-14 05:13:07', '2026-04-14 05:13:07');

-- --------------------------------------------------------

--
-- Table structure for table `promotions`
--

CREATE TABLE `promotions` (
  `id` int(11) NOT NULL,
  `code` varchar(50) NOT NULL,
  `name` varchar(150) NOT NULL,
  `type` enum('percent','fixed') DEFAULT 'percent',
  `value` decimal(10,2) NOT NULL,
  `min_order` decimal(10,2) DEFAULT 0.00,
  `max_discount` decimal(10,2) DEFAULT NULL,
  `usage_limit` int(11) DEFAULT NULL,
  `usage_count` int(11) DEFAULT 0,
  `is_active` tinyint(1) DEFAULT 1,
  `starts_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `promotions`
--

INSERT INTO `promotions` (`id`, `code`, `name`, `type`, `value`, `min_order`, `max_discount`, `usage_limit`, `usage_count`, `is_active`, `starts_at`, `expires_at`, `created_at`) VALUES
(1, 'WELCOME10', 'ส่วนลดต้อนรับสมาชิกใหม่ 10%', 'percent', 10.00, 500.00, 200.00, 100, 0, 1, NULL, '2026-05-14 04:15:15', '2026-04-14 04:15:15'),
(2, 'BEAUTY50', 'ลด 50 บาท สำหรับออเดอร์ 300 บาทขึ้นไป', 'fixed', 50.00, 300.00, NULL, 200, 0, 1, NULL, '2026-06-13 04:15:15', '2026-04-14 04:15:15');

-- --------------------------------------------------------

--
-- Table structure for table `reviews`
--

CREATE TABLE `reviews` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `rating` tinyint(4) NOT NULL CHECK (`rating` between 1 and 5),
  `title` varchar(150) DEFAULT NULL,
  `comment` text DEFAULT NULL,
  `is_verified` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('customer','admin') DEFAULT 'customer',
  `avatar` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`, `role`, `avatar`, `phone`, `address`, `created_at`, `updated_at`) VALUES
(1, 'Admin', 'admin@beautyshop.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin', NULL, NULL, NULL, '2026-04-14 04:15:15', '2026-04-14 04:15:15'),
(2, 'Test User', 'user@beautyshop.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'customer', NULL, NULL, NULL, '2026-04-14 04:15:15', '2026-04-14 04:15:15'),
(3, '3ewfd', 'jen@beautyshop.com', '$2y$10$1dDUjxMUop8ROPHTtyHpkuujcPkLr0PKP41MQ3OK0dWT4wTldYSyy', 'customer', NULL, NULL, NULL, '2026-04-14 05:08:21', '2026-04-14 05:08:21');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cart_items`
--
ALTER TABLE `cart_items`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_cart` (`user_id`,`product_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `order_number` (`order_number`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`),
  ADD UNIQUE KEY `sku` (`sku`),
  ADD KEY `category_id` (`category_id`);

--
-- Indexes for table `promotions`
--
ALTER TABLE `promotions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`);

--
-- Indexes for table `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_review` (`product_id`,`user_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cart_items`
--
ALTER TABLE `cart_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `promotions`
--
ALTER TABLE `promotions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `reviews`
--
ALTER TABLE `reviews`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `cart_items`
--
ALTER TABLE `cart_items`
  ADD CONSTRAINT `cart_items_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `cart_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
