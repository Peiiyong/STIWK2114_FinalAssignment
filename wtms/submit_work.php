<?php
include 'db.php';

if (!isset($_POST['work_id'], $_POST['worker_id'], $_POST['submission_text'])) {
    echo json_encode(["status" => "error", "message" => "Missing required fields"]);
    exit;
}

$work_id = $_POST['work_id'];
$worker_id = $_POST['worker_id'];
$submission_text = $_POST['submission_text'];

$sql = "INSERT INTO tbl_submissions (work_id, worker_id, submission_text) VALUES (?, ?, ?)";
$stmt = $conn->prepare($sql);
$stmt->bind_param("iis", $work_id, $worker_id, $submission_text);
$stmt->execute();

if ($stmt->affected_rows > 0) {
    // Update the task status to 'submitted'
    $updateSql = "UPDATE tbl_works SET status = 'submitted' WHERE id = ?";
    $updateStmt = $conn->prepare($updateSql);
    $updateStmt->bind_param("i", $work_id);
    $updateStmt->execute();
    $updateStmt->close();

    echo json_encode(["status" => "success"]);
} else {
    echo json_encode(["status" => "fail"]);
}
$stmt->close();
$conn->close();
?>