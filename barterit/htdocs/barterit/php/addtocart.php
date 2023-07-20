<?php
    if (!isset($_POST)) {
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
        die();
    }
    
    include_once("dbconnect.php");
    
    $itemid = $_POST['item_id'];
    $cartqty = $_POST['item_qty'];
    $cartprice = $_POST['item_price'];
    $userid = $_POST['userid'];
    $sellerid = $_POST['sellerid'];
    
    $checkitemid = "SELECT * FROM `carts_tbl` WHERE `user_id` = '$userid' AND  `item_id` = '$itemid'";
    $resultqty = $conn->query($checkitemid);
    $numresult = $resultqty->num_rows;
    
    if ($numresult > 0) {
    	$sql = "UPDATE `carts_tbl` SET `cart_qty`= (cart_qty + $cartqty),`cart_price`= (cart_price+$cartprice) WHERE `user_id` = '$userid' AND  `item_id` = '$itemid'";
    }else{
    	$sql = "INSERT INTO `carts_tbl`(`item_id`, `cart_qty`, `cart_price`, `user_id`, `seller_id`) VALUES ('$itemid','$cartqty','$cartprice','$userid','$sellerid')";
    }
    
    if ($conn->query($sql) === TRUE) {
    		$response = array('status' => 'success', 'data' => $sql);
    		sendJsonResponse($response);
    	}else{
    		$response = array('status' => 'failed', 'data' => $sql);
    		sendJsonResponse($response);
    	}
    
    function sendJsonResponse($sentArray)
    {
        header('Content-Type: application/json');
        echo json_encode($sentArray);
    }

?>