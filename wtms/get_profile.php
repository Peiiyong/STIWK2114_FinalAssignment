<?php
include 'db.php';

if (!isset($_POST['worker_id'])) {
    echo json_encode(["status" => "error", "message" => "Missing worker_id"]);
    exit;
}

$worker_id = $_POST['worker_id'];

$sql = "SELECT id, full_name, email, password, phone, address FROM workers WHERE id = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $worker_id);
$stmt->execute();
$result = $stmt->get_result();

if ($row = $result->fetch_assoc()) {
    // Return the worker fields at the top level
    $response = array_merge(["status" => "success"], $row);
} else {
    $response = ["status" => "failed"];
}

echo json_encode($response);

$stmt->close();
$conn->close();