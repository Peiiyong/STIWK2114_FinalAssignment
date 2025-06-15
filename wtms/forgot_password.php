<?php
include 'db.php';

if (isset($_POST['email'])) {
    $email = $_POST['email'];
    $result = mysqli_query($conn, "SELECT * FROM workers WHERE email='$email'");
    
    if (mysqli_num_rows($result) > 0) {
        echo json_encode(["status" => "success"]);
    } else {
        echo json_encode(["status" => "fail"]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Email not provided"]);
}
?>