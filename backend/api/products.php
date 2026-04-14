<?php
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../config/helpers.php';
require_once __DIR__ . '/../middleware/auth.php';
setCorsHeaders();

$method = $_SERVER['REQUEST_METHOD'];
$id     = $_GET['id'] ?? null;
$pdo    = getDB();

// GET /api/products.php  — list with search/filter/paginate
if ($method === 'GET' && !$id) {
    $search   = $_GET['search'] ?? '';
    $category = $_GET['category'] ?? '';
    $sort     = $_GET['sort'] ?? 'created_at';
    $order    = strtoupper($_GET['order'] ?? 'DESC') === 'ASC' ? 'ASC' : 'DESC';
    $page     = max(1, (int)($_GET['page'] ?? 1));
    $limit    = min(50, max(1, (int)($_GET['limit'] ?? 12)));

    $allowed = ['created_at','price','rating_avg','name'];
    if (!in_array($sort, $allowed)) $sort = 'created_at';

    $sql    = 'SELECT p.*, c.name AS category_name FROM products p LEFT JOIN categories c ON p.category_id = c.id WHERE p.is_active = 1';
    $params = [];
    if ($search) { $sql .= ' AND (p.name LIKE ? OR p.description LIKE ? OR p.brand LIKE ?)'; $s = "%$search%"; $params = [$s,$s,$s]; }
    if ($category) { $sql .= ' AND c.slug = ?'; $params[] = $category; }
    $sql .= " ORDER BY p.$sort $order";

    $result = paginate($sql, $pdo, $params, $page, $limit);
    success($result);
}

// GET /api/products.php?id=1  — single product with reviews
if ($method === 'GET' && $id) {
    $stmt = $pdo->prepare('SELECT p.*, c.name AS category_name FROM products p LEFT JOIN categories c ON p.category_id = c.id WHERE p.id = ? AND p.is_active = 1');
    $stmt->execute([$id]);
    $product = $stmt->fetch();
    if (!$product) error('ไม่พบสินค้า', 404);

    $rev = $pdo->prepare('SELECT r.*, u.name AS user_name FROM reviews r JOIN users u ON r.user_id = u.id WHERE r.product_id = ? ORDER BY r.created_at DESC LIMIT 10');
    $rev->execute([$id]);
    $product['reviews'] = $rev->fetchAll();
    success($product);
}

// POST — create product (admin)
if ($method === 'POST') {
    requireAdmin();
    $body = getBody();
    $fields = ['category_id','name','description','price','stock','brand','sku'];
    foreach ($fields as $f) if (empty($body[$f]) && $f !== 'description' && $f !== 'brand') error("กรุณากรอก $f");

    $slug = strtolower(preg_replace('/[^a-z0-9]+/i','-', $body['name'])) . '-' . time();
    $stmt = $pdo->prepare('INSERT INTO products (category_id,name,slug,description,price,sale_price,stock,brand,sku,image) VALUES (?,?,?,?,?,?,?,?,?,?)');
    $stmt->execute([$body['category_id'],$body['name'],$slug,$body['description']??'',$body['price'],$body['sale_price']??null,$body['stock']??0,$body['brand']??'',$body['sku'],$body['image']??null]);
    success(['id' => (int)$pdo->lastInsertId()], 'เพิ่มสินค้าสำเร็จ');
}

// PUT — update product (admin)
if ($method === 'PUT' && $id) {
    requireAdmin();
    $body = getBody();
    $stmt = $pdo->prepare('UPDATE products SET category_id=?,name=?,description=?,price=?,sale_price=?,stock=?,brand=?,image=?,is_active=? WHERE id=?');
    $stmt->execute([$body['category_id'],$body['name'],$body['description']??'',$body['price'],$body['sale_price']??null,$body['stock']??0,$body['brand']??'',$body['image']??null,$body['is_active']??1,$id]);
    success([], 'อัปเดตสินค้าสำเร็จ');
}

// DELETE — soft delete (admin)
if ($method === 'DELETE' && $id) {
    requireAdmin();
    $pdo->prepare('UPDATE products SET is_active=0 WHERE id=?')->execute([$id]);
    success([], 'ลบสินค้าสำเร็จ');
}

error('Invalid request', 404);
