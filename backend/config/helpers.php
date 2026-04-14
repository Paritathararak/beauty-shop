<?php
function setCorsHeaders() {
    header('Access-Control-Allow-Origin: http://localhost:5173');
    header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
    header('Access-Control-Allow-Headers: Content-Type, Authorization');
    header('Content-Type: application/json; charset=utf-8');
    if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
        http_response_code(200);
        exit();
    }
}

function respond($data, $code = 200) {
    http_response_code($code);
    echo json_encode($data, JSON_UNESCAPED_UNICODE);
    exit();
}

function success($data = [], $message = 'Success') {
    respond(['success' => true, 'message' => $message, 'data' => $data]);
}

function error($message = 'Error', $code = 400) {
    respond(['success' => false, 'message' => $message], $code);
}

function getBody() {
    return json_decode(file_get_contents('php://input'), true) ?? [];
}

function paginate($query, $pdo, $params, $page, $limit) {
    $offset = ($page - 1) * $limit;
    $countSql = preg_replace('/SELECT .* FROM/s', 'SELECT COUNT(*) FROM', $query);
    $countSql = preg_replace('/ORDER BY.*/s', '', $countSql);
    $total = $pdo->prepare($countSql);
    $total->execute($params);
    $totalCount = $total->fetchColumn();

    $stmt = $pdo->prepare($query . " LIMIT $limit OFFSET $offset");
    $stmt->execute($params);
    return [
        'items' => $stmt->fetchAll(),
        'pagination' => [
            'total' => (int)$totalCount,
            'page' => (int)$page,
            'limit' => (int)$limit,
            'pages' => (int)ceil($totalCount / $limit)
        ]
    ];
}
