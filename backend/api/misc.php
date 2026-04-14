<?php
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../config/helpers.php';
require_once __DIR__ . '/../middleware/auth.php';
setCorsHeaders();

$method   = $_SERVER['REQUEST_METHOD'];
$resource = $_GET['resource'] ?? '';
$pdo      = getDB();

// ---- CATEGORIES ----
if ($resource === 'categories') {
    if ($method === 'GET') {
        $stmt = $pdo->query('SELECT c.*, COUNT(p.id) AS product_count FROM categories c LEFT JOIN products p ON p.category_id=c.id AND p.is_active=1 GROUP BY c.id ORDER BY c.name');
        success($stmt->fetchAll());
    }
    if ($method === 'POST') {
        requireAdmin();
        $body = getBody();
        $slug = strtolower(preg_replace('/[^a-z0-9]+/i','-',$body['name']??''));
        $pdo->prepare('INSERT INTO categories (name,slug,description,image) VALUES (?,?,?,?)')->execute([$body['name'],$slug,$body['description']??'',$body['image']??null]);
        success(['id'=>(int)$pdo->lastInsertId()],'เพิ่มหมวดหมู่สำเร็จ');
    }
}

// ---- PROMOTIONS ----
if ($resource === 'promotions') {
    if ($method === 'GET') {
        // validate coupon  ?code=WELCOME10&amount=500
        $code   = $_GET['code'] ?? '';
        $amount = (float)($_GET['amount'] ?? 0);
        if ($code) {
            $stmt = $pdo->prepare('SELECT * FROM promotions WHERE code=? AND is_active=1 AND (expires_at IS NULL OR expires_at > NOW()) AND (usage_limit IS NULL OR usage_count < usage_limit)');
            $stmt->execute([$code]);
            $promo = $stmt->fetch();
            if (!$promo) error('โค้ดส่วนลดไม่ถูกต้องหรือหมดอายุ');
            if ($amount < $promo['min_order']) error("ยอดขั้นต่ำ " . number_format($promo['min_order'],0) . " บาท");
            $discount = $promo['type']==='percent' ? $amount*$promo['value']/100 : $promo['value'];
            if ($promo['max_discount']) $discount = min($discount, $promo['max_discount']);
            success(['promo'=>$promo,'discount'=>round($discount,2)],'โค้ดส่วนลดถูกต้อง');
        }
        requireAdmin();
        success($pdo->query('SELECT * FROM promotions ORDER BY created_at DESC')->fetchAll());
    }
    if ($method === 'POST') {
        requireAdmin();
        $body = getBody();
        $pdo->prepare('INSERT INTO promotions (code,name,type,value,min_order,max_discount,usage_limit,is_active,starts_at,expires_at) VALUES (?,?,?,?,?,?,?,?,?,?)')->execute([$body['code'],$body['name'],$body['type']??'percent',$body['value'],$body['min_order']??0,$body['max_discount']??null,$body['usage_limit']??null,$body['is_active']??1,$body['starts_at']??null,$body['expires_at']??null]);
        success(['id'=>(int)$pdo->lastInsertId()],'เพิ่มโปรโมชั่นสำเร็จ');
    }
    if ($method === 'PUT') {
        requireAdmin();
        $id = $_GET['id'] ?? null;
        if (!$id) error('ระบุ id');
        $body = getBody();
        $pdo->prepare('UPDATE promotions SET is_active=? WHERE id=?')->execute([$body['is_active'],$id]);
        success([],'อัปเดตสำเร็จ');
    }
}

// ---- DASHBOARD STATS (admin) ----
if ($resource === 'dashboard') {
    requireAdmin();
    $totalRevenue  = $pdo->query("SELECT COALESCE(SUM(total),0) FROM orders WHERE status != 'cancelled'")->fetchColumn();
    $totalOrders   = $pdo->query("SELECT COUNT(*) FROM orders")->fetchColumn();
    $totalProducts = $pdo->query("SELECT COUNT(*) FROM products WHERE is_active=1")->fetchColumn();
    $totalUsers    = $pdo->query("SELECT COUNT(*) FROM users WHERE role='customer'")->fetchColumn();

    $monthlySales  = $pdo->query("SELECT DATE_FORMAT(created_at,'%Y-%m') AS month, SUM(total) AS revenue, COUNT(*) AS orders FROM orders WHERE status != 'cancelled' AND created_at >= DATE_SUB(NOW(), INTERVAL 6 MONTH) GROUP BY month ORDER BY month")->fetchAll();
    $topProducts   = $pdo->query("SELECT p.name, p.image, SUM(oi.quantity) AS sold, SUM(oi.total) AS revenue FROM order_items oi JOIN products p ON oi.product_id=p.id GROUP BY oi.product_id ORDER BY sold DESC LIMIT 5")->fetchAll();
    $recentOrders  = $pdo->query("SELECT o.*, u.name AS user_name FROM orders o LEFT JOIN users u ON o.user_id=u.id ORDER BY o.created_at DESC LIMIT 5")->fetchAll();
    $ordersByStatus= $pdo->query("SELECT status, COUNT(*) AS count FROM orders GROUP BY status")->fetchAll();

    success(compact('totalRevenue','totalOrders','totalProducts','totalUsers','monthlySales','topProducts','recentOrders','ordersByStatus'));
}

error('Invalid resource', 404);
