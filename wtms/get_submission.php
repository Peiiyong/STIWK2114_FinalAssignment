<?php
include 'db.php';

if (!isset($_POST['worker_id'])) {
    echo json_encode(["status" => "error", "message" => "Missing worker_id"]);
    exit;
}

$worker_id = $_POST['worker_id'];

// Join submissions and works tables to get all submissions for the worke
$sql = "SELECT s.*, w.title as task_title 
        FROM tbl_submissions s 
        JOIN tbl_works w ON s.work_id = w.id 
        WHERE s.worker_id = ? 
        ORDER BY s.submitted_at DESC";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $worker_id);
$stmt->execute();
$result = $stmt->get_result();

$data = [];
while ($row = $result->fetch_assoc()) {
    $data[] = $row;
}

echo json_encode([
    "status" => "success",
    "data" => $data
]);

$stmt->close();
$conn->close();