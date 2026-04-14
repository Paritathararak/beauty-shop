<?php
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../config/helpers.php';
require_once __DIR__ . '/../middleware/auth.php';
setCorsHeaders();

$method = $_SERVER['REQUEST_METHOD'];
$action = $_GET['action'] ?? '';
$pdo = getDB();

// POST /api/auth.php?action=register
if ($method === 'POST' && $action === 'register') {
    $body = getBody();
    $name  = trim($body['name'] ?? '');
    $email = trim($body['email'] ?? '');
    $pass  = $body['password'] ?? '';

    if (!$name || !$email || !$pass) error('กรุณากรอกข้อมูลให้ครบ');
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) error('อีเมลไม่ถูกต้อง');
    if (strlen($pass) < 6) error('รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร');

    $check = $pdo->prepare('SELECT id FROM users WHERE email = ?');
    $check->execute([$email]);
    if ($check->fetch()) error('อีเมลนี้มีผู้ใช้งานแล้ว');

    $hashed = password_hash($pass, PASSWORD_BCRYPT);
    $stmt = $pdo->prepare('INSERT INTO users (name, email, password) VALUES (?, ?, ?)');
    $stmt->execute([$name, $email, $hashed]);
    $userId = $pdo->lastInsertId();

    $token = generateJWT(['id' => (int)$userId, 'email' => $email, 'role' => 'customer', 'name' => $name]);
    success(['token' => $token, 'user' => ['id' => (int)$userId, 'name' => $name, 'email' => $email, 'role' => 'customer']], 'สมัครสมาชิกสำเร็จ');
}

// POST /api/auth.php?action=login
if ($method === 'POST' && $action === 'login') {
    $body  = getBody();
    $email = trim($body['email'] ?? '');
    $pass  = $body['password'] ?? '';

    if (!$email || !$pass) error('กรุณากรอกอีเมลและรหัสผ่าน');

    $stmt = $pdo->prepare('SELECT * FROM users WHERE email = ?');
    $stmt->execute([$email]);
    $user = $stmt->fetch();

    if (!$user || !password_verify($pass, $user['password'])) error('อีเมลหรือรหัสผ่านไม่ถูกต้อง');

    $token = generateJWT(['id' => (int)$user['id'], 'email' => $user['email'], 'role' => $user['role'], 'name' => $user['name']]);
    success([
        'token' => $token,
        'user'  => ['id' => (int)$user['id'], 'name' => $user['name'], 'email' => $user['email'], 'role' => $user['role'], 'avatar' => $user['avatar']]
    ], 'เข้าสู่ระบบสำเร็จ');
}

// GET /api/auth.php?action=me
if ($method === 'GET' && $action === 'me') {
    $user = requireAuth();
    $stmt = $pdo->prepare('SELECT id, name, email, role, avatar, phone, address, created_at FROM users WHERE id = ?');
    $stmt->execute([$user['id']]);
    success($stmt->fetch());
}

// PUT /api/auth.php?action=profile
if ($method === 'PUT' && $action === 'profile') {
    $user = requireAuth();
    $body = getBody();
    $name    = trim($body['name'] ?? '');
    $phone   = trim($body['phone'] ?? '');
    $address = trim($body['address'] ?? '');
    $stmt = $pdo->prepare('UPDATE users SET name=?, phone=?, address=? WHERE id=?');
    $stmt->execute([$name, $phone, $address, $user['id']]);
    success([], 'อัปเดตข้อมูลสำเร็จ');
}

error('Invalid action', 404);
