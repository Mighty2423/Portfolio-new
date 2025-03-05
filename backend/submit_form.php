<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Collect and sanitize form data
    $name = htmlspecialchars($_POST['name']);
    $email = htmlspecialchars($_POST['email']);
    $message = htmlspecialchars($_POST['message']);

    // Validate form data
    if (!empty($name) && !empty($email) && !empty($message)) {
        // Process the form data (e.g., save to database, send email, etc.)
        // For demonstration, we'll just echo the data
        echo "Name: " . $name . "<br>";
        echo "Email: " . $email . "<br>";
        echo "Message: " . $message . "<br>";
    } else {
        echo "All fields are required.";
    }
} else {
    echo "Invalid request method.";
}
?>