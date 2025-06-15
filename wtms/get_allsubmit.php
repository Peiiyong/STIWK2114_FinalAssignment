<?php
// filepath: c:\xampp\htdocs\wtms\get_allsubmit.php
include 'db.php';

$where = '';
$params = [];
$types = '';

if (isset($_POST['work_id'])) {
    $where = 'WHERE s.work_id = ?';
    $params[] = $_POST['work_id'];
    $types .= 'i';
}

$sql = "SELECT s.id, s.work_id, s.worker_id, s.submission_text, s.submitted_at, w.title 
        FROM tbl_submissions s 
        JOIN tbl_works w ON s.work_id = w.id 
        $where
        ORDER BY s.submitted_at ASC";

$stmt = $conn->prepare($sql);
if ($params) {
    $stmt->bind_param($types, ...$params);
}
$stmt->execute();
$result = $stmt->get_result();

$data = [];
while ($row = $result->fetch_assoc()) {
    $data[] = $row;
}

if (count($data) > 0) {
    echo json_encode([
        "status" => "success",
        "data" => $data
    ]);
} else {
    echo json_encode([
        "status" => "error",
        "message" => "No data found"
    ]);
}

$stmt->close();
$conn->close();
?>