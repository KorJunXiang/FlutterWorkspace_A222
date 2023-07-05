<?php
	if (!isset($_POST)) 
	{
		$response = array('status' => 'failed', 'data' => null);
		sendJsonResponse($response);
		die();
	}

	include_once("dbconnect.php");

	$userid = $_POST['userid'];
	$item_name = $_POST['itemname'];
	$item_desc = $_POST['itemdesc'];
	$item_qty = $_POST['itemqty'];
	$item_price = $_POST['itemprice'];
	$item_type = $_POST['type'];
	$latitude = $_POST['latitude'];
	$longitude = $_POST['longitude'];
	$state = $_POST['state'];
	$locality = $_POST['locality'];
	$imageItems = $_POST["image"];
	$image = json_decode($imageItems);

	$sqlinsert = "INSERT INTO items_tbl(user_id, item_name, item_qty, item_desc, item_price, item_type, item_state, item_locality, item_lat, item_long) VALUES ('$userid','$item_name','$item_qty','$item_desc','$item_price', '$item_type','$state','$locality','$latitude','$longitude')";
	
	try
	{
		if ($conn->query($sqlinsert) === TRUE) 
		{
			$filename = mysqli_insert_id($conn);
			foreach ($image as $index => $base64image) 
			{
				$decoded_string = base64_decode($base64image);
				$path = '../assets/items/'.$filename.'_'.($index + 1).'.png';
				file_put_contents($path, $decoded_string);
			}
			$response = array('status' => 'success', 'data' => null);
			sendJsonResponse($response);
		} else {
			$response = array('status' => 'failed', 'data' => null);
			sendJsonResponse($response);
		}
	}
	catch(Exception $e)
	{
		$response = array('status' => 'failed', 'data' => $sqlinsert);
		sendJsonResponse($response);
	}
	$conn->close();
	
	function sendJsonResponse($sentArray)
	{
		header('Content-Type: application/json');
		echo json_encode($sentArray);
	}
?>