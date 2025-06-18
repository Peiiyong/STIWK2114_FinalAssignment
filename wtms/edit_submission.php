<?php
// edit_submission.php
header('Content-Type: application/json');
include 'db.php';

// Check for required POST parameters
if (!isset($_POST['submission_id']) || !isset($_POST['updated_text'])) {
    echo json_encode([
        'status' => 'error',
        'message' => 'Missing parameters'
    ]);
    exit;
}

$submission_id = $_POST['submission_id'];
$updated_text = $_POST['updated_text'];

// Prepare and execute update query
$sql = "UPDATE tbl_submissions SET submission_text = ? WHERE id = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("si", $updated_text, $submission_id);

if ($stmt->execute()) {
    echo json_encode([
        'status' => 'success',
        'message' => 'Submission updated successfully'
    ]);
} else {
    echo json_encode([
        'status' => 'error',
        'message' => 'Failed to update submission'
    ]);
}

$stmt->close();
$conn->close();
?>