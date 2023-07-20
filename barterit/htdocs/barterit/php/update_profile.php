<?php
    if (!isset($_POST)) {
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
        die();
    }
    
    include_once("dbconnect.php");
    
    
    if(isset($_POST['image'])){
        $image = $_POST['image'];
        $userid = $_POST['userid'];
        
        $decoded_string = base64_decode($image);
	    $path = '../assets/profile/'.$userid.'.png';
	    file_put_contents($path, $decoded_string);
	    $response = array('status' => 'success', 'data' => null);
        sendJsonResponse($response);
        die();
    }
    
    $userid = $_POST['userid'];
    
    $sqlupdate = "UPDATE `users_tbl` SET ";
    $updatedData = array();
    
    if (isset($_POST['name']) && !empty($_POST['name'])) {
        $name = $_POST['name'];
        $sqlupdate .= "`user_name`='$name', ";
        $updatedData['name'] = $name;
    }
    
    if (isset($_POST['email']) && !empty($_POST['email'])) {
        $email = $_POST['email'];
        $sqlupdate .= "`user_email`='$email', ";
        $updatedData['email'] = $email;
    }
    
    if (isset($_POST['password']) && !empty($_POST['password'])) {
        $password = sha1($_POST['password']);
        $sqlupdate .= "`user_pass`='$password', ";
        $updatedData['password'] = $_POST['password'];
    }
    
    $sqlupdate = rtrim($sqlupdate, ", ");
    $sqlupdate .= " WHERE user_id = '$userid'";
    
    if ($conn->query($sqlupdate) === TRUE) {
        $response = array('status' => 'success', 'data' => $updatedData);
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
    }
    
    function sendJsonResponse($sentArray)
    {
        header('Content-Type: application/json');
        echo json_encode($sentArray);
    }
?>
