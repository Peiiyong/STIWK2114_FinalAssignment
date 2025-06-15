<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    exit;
}

include_once 'db.php';

$email = $_POST['email'] ?? '';
$password = sha1($_POST['password'] ?? '');

// Prepared statement (防止 SQL 注入)
$stmt = $conn->prepare("SELECT * FROM workers WHERE email = ? AND password = ?");
$stmt->bind_param("ss", $email, $password);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $sentArray = array();
    while ($row = $result->fetch_assoc()) {
        $sentArray[] = $row;
    }
    $response = array('status' => 'success', 'data' => $sentArray);
} else {
    $response = array('status' => 'failed', 'data' => null);
}

sendJsonResponse($response);

function sendJsonResponse($sentArray) {
    echo json_encode($sentArray);
}
?>