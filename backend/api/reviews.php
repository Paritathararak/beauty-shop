<?php
// ============================================================
// reviews.php
// ============================================================
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../config/helpers.php';
require_once __DIR__ . '/../middleware/auth.php';
setCorsHeaders();

$method = $_SERVER['REQUEST_METHOD'];
$pdo    = getDB();

// GET ?product_id=X
if ($method === 'GET') {
    $productId = $_GET['product_id'] ?? null;
    if (!$productId) error('กรุณาระบุ product_id');
    $stmt = $pdo->prepare('SELECT r.*, u.name AS user_name FROM reviews r JOIN users u ON r.user_id=u.id WHERE r.product_id=? ORDER BY r.created_at DESC');
    $stmt->execute([$productId]);
    success($stmt->fetchAll());
}

// POST — add review
if ($method === 'POST') {
    $user = requireAuth();
    $body = getBody();
    $productId = $body['product_id'] ?? null;
    $rating    = (int)($body['rating'] ?? 0);
    $comment   = trim($body['comment'] ?? '');
    if (!$productId || $rating < 1 || $rating > 5) error('ข้อมูลไม่ถูกต้อง');

    try {
        $pdo->prepare('INSERT INTO reviews (product_id,user_id,rating,title,comment) VALUES (?,?,?,?,?)')->execute([$productId,$user['id'],$rating,$body['title']??'',$comment]);
        // Update product rating_avg
        $avg = $pdo->prepare('SELECT AVG(rating) AS avg, COUNT(*) AS cnt FROM reviews WHERE product_id=?');
        $avg->execute([$productId]);
        $r = $avg->fetch();
        $pdo->prepare('UPDATE products SET rating_avg=?, rating_count=? WHERE id=?')->execute([round($r['avg'],2),(int)$r['cnt'],$productId]);
        success([], 'เพิ่มรีวิวสำเร็จ');
    } catch (PDOException $e) {
        error('คุณได้รีวิวสินค้านี้แล้ว');
    }
}

error('Invalid request', 404);
