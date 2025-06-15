<?php
error_reporting(0);
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

if (!isset($_POST)) {
    sendJsonResponse(['status' => 'failed', 'data' => null]);
    die;
}

include_once 'db.php';

// Collect and sanitize inputs
$full_name = $_POST['full_name'];
$email = $_POST['email'];
$password = sha1($_POST['password']);
$phone = $_POST['phone'];
$address = $_POST['address'];

// Check if full_name already exists
$sqlcheckFullName = "SELECT * FROM workers WHERE full_name = '$full_name'";
$resultFullName = $conn->query($sqlcheckFullName);

if ($resultFullName->num_rows > 0) {
    sendJsonResponse(['status' => 'failed', 'message' => 'This full name has already been used. Try another.']);
    die;
}

// Check if email already exists
$sqlcheckEmail = "SELECT * FROM workers WHERE email = '$email'";
$resultEmail = $conn->query($sqlcheckEmail);

if ($resultEmail->num_rows > 0) {
    sendJsonResponse(['status' => 'failed', 'message' => 'This email has already been used. Try another.']);
    die;
}

// Insert into database
$sqlinsert = "INSERT INTO workers(full_name, email, password, phone, address) 
              VALUES ('$full_name', '$email', '$password', '$phone', '$address')";

try {
    if ($conn->query($sqlinsert) === TRUE) {
        sendJsonResponse(['status' => 'success', 'data' => null]);
    } else {
        sendJsonResponse(['status' => 'failed', 'message' => 'Database insert failed']);
    }
} catch (Exception $e) {
    sendJsonResponse(['status' => 'failed', 'message' => 'Server error']);
}

function sendJsonResponse($array) {
    echo json_encode($array);
}
?>