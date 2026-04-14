<?php
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../config/helpers.php';
require_once __DIR__ . '/../middleware/auth.php';
setCorsHeaders();

$method = $_SERVER['REQUEST_METHOD'];
$id     = $_GET['id'] ?? null;
$pdo    = getDB();

// GET /api/orders.php — my orders or all (admin)
if ($method === 'GET' && !$id) {
    $user  = requireAuth();
    $page  = max(1,(int)($_GET['page']??1));
    $limit = 10;

    if ($user['role'] === 'admin') {
        $status = $_GET['status'] ?? '';
        $sql    = 'SELECT o.*, u.name AS user_name, u.email AS user_email FROM orders o LEFT JOIN users u ON o.user_id = u.id WHERE 1=1';
        $params = [];
        if ($status) { $sql .= ' AND o.status = ?'; $params[] = $status; }
        $sql .= ' ORDER BY o.created_at DESC';
    } else {
        $sql    = 'SELECT * FROM orders WHERE user_id = ? ORDER BY created_at DESC';
        $params = [$user['id']];
    }
    success(paginate($sql, $pdo, $params, $page, $limit));
}

// GET /api/orders.php?id=1 — single order detail
if ($method === 'GET' && $id) {
    $user = requireAuth();
    $stmt = $pdo->prepare('SELECT o.*, u.name AS user_name FROM orders o LEFT JOIN users u ON o.user_id=u.id WHERE o.id=?');
    $stmt->execute([$id]);
    $order = $stmt->fetch();
    if (!$order) error('ไม่พบออเดอร์', 404);
    if ($user['role'] !== 'admin' && $order['user_id'] != $user['id']) error('Forbidden', 403);

    $items = $pdo->prepare('SELECT * FROM order_items WHERE order_id=?');
    $items->execute([$id]);
    $order['items'] = $items->fetchAll();
    success($order);
}

// POST — place order
if ($method === 'POST') {
    $user = requireAuth();
    $body = getBody();
    $items   = $body['items'] ?? [];
    $address = $body['shipping_address'] ?? [];
    $coupon  = $body['coupon_code'] ?? '';

    if (empty($items)) error('ไม่มีสินค้าในคำสั่งซื้อ');
    if (empty($address['name']) || empty($address['phone']) || empty($address['address'])) error('กรุณากรอกที่อยู่จัดส่ง');

    $subtotal = 0;
    $orderItems = [];
    foreach ($items as $item) {
        $stmt = $pdo->prepare('SELECT * FROM products WHERE id=? AND is_active=1 AND stock >= ?');
        $stmt->execute([$item['product_id'], $item['quantity']]);
        $product = $stmt->fetch();
        if (!$product) error("สินค้า {$item['product_id']} ไม่พร้อมจำหน่าย");
        $price = $product['sale_price'] ?? $product['price'];
        $subtotal += $price * $item['quantity'];
        $orderItems[] = ['product' => $product, 'quantity' => $item['quantity'], 'price' => $price];
    }

    $discount = 0;
    if ($coupon) {
        $cp = $pdo->prepare('SELECT * FROM promotions WHERE code=? AND is_active=1 AND (expires_at IS NULL OR expires_at > NOW()) AND (usage_limit IS NULL OR usage_count < usage_limit)');
        $cp->execute([$coupon]);
        $promo = $cp->fetch();
        if ($promo && $subtotal >= $promo['min_order']) {
            $discount = $promo['type'] === 'percent' ? $subtotal * $promo['value'] / 100 : $promo['value'];
            if ($promo['max_discount']) $discount = min($discount, $promo['max_discount']);
            $pdo->prepare('UPDATE promotions SET usage_count=usage_count+1 WHERE id=?')->execute([$promo['id']]);
        }
    }

    $shipping = $subtotal >= 1000 ? 0 : 50;
    $total    = $subtotal - $discount + $shipping;
    $orderNum = 'BS' . date('Ymd') . strtoupper(substr(uniqid(), -6));

    $pdo->beginTransaction();
    try {
        $stmt = $pdo->prepare('INSERT INTO orders (user_id,order_number,subtotal,discount,shipping_fee,total,coupon_code,shipping_address,payment_method,note) VALUES (?,?,?,?,?,?,?,?,?,?)');
        $stmt->execute([$user['id'],$orderNum,$subtotal,$discount,$shipping,$total,$coupon?:null,json_encode($address),$body['payment_method']??'cod',$body['note']??'']);
        $orderId = $pdo->lastInsertId();

        foreach ($orderItems as $oi) {
            $pdo->prepare('INSERT INTO order_items (order_id,product_id,product_name,product_image,quantity,price,total) VALUES (?,?,?,?,?,?,?)')->execute([$orderId,$oi['product']['id'],$oi['product']['name'],$oi['product']['image'],$oi['quantity'],$oi['price'],$oi['price']*$oi['quantity']]);
            $pdo->prepare('UPDATE products SET stock=stock-? WHERE id=?')->execute([$oi['quantity'],$oi['product']['id']]);
        }
        $pdo->commit();
        success(['order_id' => (int)$orderId, 'order_number' => $orderNum, 'total' => $total], 'สั่งซื้อสำเร็จ');
    } catch (Exception $e) {
        $pdo->rollBack();
        error('เกิดข้อผิดพลาด กรุณาลองใหม่');
    }
}

// PUT — update status (admin)
if ($method === 'PUT' && $id) {
    requireAdmin();
    $body   = getBody();
    $status = $body['status'] ?? '';
    $allowed = ['pending','confirmed','processing','shipped','delivered','cancelled'];
    if (!in_array($status, $allowed)) error('สถานะไม่ถูกต้อง');
    $pdo->prepare('UPDATE orders SET status=? WHERE id=?')->execute([$status, $id]);
    success([], 'อัปเดตสถานะสำเร็จ');
}

error('Invalid request', 404);
