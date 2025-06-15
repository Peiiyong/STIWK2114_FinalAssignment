<?php
include 'db.php';

// Check if required POST data is set
if (!isset($_POST['worker_id'], $_POST['field'], $_POST['new_value'])) {
    echo json_encode(["success" => false, "message" => "Missing required fields"]);
    exit;
}

// Get POST data
$worker_id = $_POST['worker_id'];
$field = $_POST['field'];
$new_value = $_POST['new_value'];

// Log the incoming POST data for debugging
error_log("POST data received: " . print_r($_POST, true));

// Define valid fields
$valid_fields = ['email', 'phone', 'address'];

// Check if the provided field is valid
if (in_array($field, $valid_fields)) {
    // Check if the new email already exists (only if the field is 'email')
    if ($field === 'email') {
        $emailCheckSql = "SELECT id FROM workers WHERE email = ? AND id != ?";
        $emailCheckStmt = $conn->prepare($emailCheckSql);
        $emailCheckStmt->bind_param("si", $new_value, $worker_id);
        $emailCheckStmt->execute();
        $emailCheckResult = $emailCheckStmt->get_result();

        if ($emailCheckResult->num_rows > 0) {
            echo json_encode(["success" => false, "message" => "Email already exists"]);
            $emailCheckStmt->close();
            $conn->close();
            exit;
        }

        $emailCheckStmt->close();
    }

    // Prepare the update query
    $sql = "UPDATE workers SET $field = ? WHERE id = ?";
    $retryCount = 0;
    $maxRetries = 3;

    while ($retryCount < $maxRetries) {
        try {
            $stmt = $conn->prepare($sql);

            if (!$stmt) {
                error_log("Failed to prepare statement: " . $conn->error);
                echo json_encode(["success" => false, "message" => "Failed to prepare statement"]);
                exit;
            }

            $stmt->bind_param("si", $new_value, $worker_id);

            if ($stmt->execute()) {
                echo json_encode(["success" => true, "message" => "$field updated successfully"]);
                $stmt->close();
                $conn->close();
                exit;
            } else {
                throw new Exception("Failed to execute statement: " . $stmt->error);
            }
        } catch (mysqli_sql_exception $e) {
            if (strpos($e->getMessage(), 'Lock wait timeout exceeded') !== false) {
                $retryCount++;
                sleep(1); // Wait for 1 second before retrying
                continue;
            } else {
                error_log("SQL Exception: " . $e->getMessage());
                echo json_encode(["success" => false, "message" => "Database error"]);
                exit;
            }
        } catch (Exception $e) {
            error_log("General Exception: " . $e->getMessage());
            echo json_encode(["success" => false, "message" => "Unexpected error occurred"]);
            exit;
        }
    }

    echo json_encode(["success" => false, "message" => "Failed to update $field after multiple retries"]);
} else {
    echo json_encode(["success" => false, "message" => "Invalid field"]);
}

$conn->close();
?>