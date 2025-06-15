<?php
include 'db.php';

if (!isset($_POST['worker_id'])) {
    echo json_encode(["status" => "error", "message" => "Missing worker_id"]);
    exit;
}

$worker_id = $_POST['worker_id'];

// update all overdue tasks to 'overdue' status
$updateSql = "
    UPDATE tbl_works w
    LEFT JOIN tbl_submissions s ON w.id = s.work_id
    SET w.status = 'overdue'
    WHERE w.assigned_to = ? 
      AND w.status = 'pending'
      AND w.due_date < NOW()
      AND s.id IS NULL
";
$updateStmt = $conn->prepare($updateSql);
$updateStmt->bind_param("i", $worker_id);
$updateStmt->execute();
$updateStmt->close();

// if tbl_submissions is empty, reset all tasks with status 'submitted' to 'pending'
$checkSubmissions = $conn->query("SELECT COUNT(*) as cnt FROM tbl_submissions");
$row = $checkSubmissions->fetch_assoc();
if ($row['cnt'] == 0) {
    $resetSql = "UPDATE tbl_works SET status = 'pending' WHERE status = 'submitted'";
    $conn->query($resetSql);
}

$sql = "SELECT id, title, description, assigned_to, date_assigned, due_date, status FROM tbl_works WHERE assigned_to = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $worker_id);
$stmt->execute();
$result = $stmt->get_result();

$tasks = array();
while ($row = $result->fetch_assoc()) {
    $tasks[] = $row;
}
echo json_encode($tasks);
?>