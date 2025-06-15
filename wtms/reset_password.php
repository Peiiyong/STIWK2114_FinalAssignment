<?php
include 'db.php';

// Check if 'email' and 'password' are set in the POST request
if (isset($_POST['email']) && isset($_POST['password'])) {
    $email = $_POST['email'];
    $password = $_POST['password'];

    // Hash the password using SHA1
    $hashedPassword = sha1($password);  // Using SHA1 for hashing the password

    // Prepare the SQL statement to update the password
    $sql = "UPDATE workers SET password=? WHERE email=?";
    $stmt = $conn->prepare($sql);
    
    if ($stmt === false) {
        // Error if preparing the statement fails
        echo json_encode(["status" => "error", "message" => "Database statement preparation failed"]);
        die();
    }

    // Bind parameters and execute the query
    $stmt->bind_param("ss", $hashedPassword, $email);

    // Execute the statement and check if the password was updated
    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Password has been reset"]);
    } else {
        echo json_encode(["status" => "fail", "message" => "Password update failed"]);
    }

    // Close the statement
    $stmt->close();
} else {
    // Return an error if email or password is missing
    echo json_encode(["status" => "error", "message" => "Missing required fields: email or password"]);
}
?>