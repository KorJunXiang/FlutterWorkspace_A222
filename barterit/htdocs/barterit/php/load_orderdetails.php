<?php
    if (!isset($_POST)) {
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
        die();
    }
    
    include_once("dbconnect.php");
    
    if (isset($_POST['buyerid']) && isset($_POST['orderbill'])){
    	$buyerid = $_POST['buyerid'];	
    	$orderbill = $_POST['orderbill'];
    	$sellerid = $_POST['sellerid'];
    	$sqlorderdetails = "SELECT * FROM `orderdetails_tbl` INNER JOIN `items_tbl` ON orderdetails_tbl.item_id = items_tbl.item_id WHERE orderdetails_tbl.buyer_id = '$buyerid' AND orderdetails_tbl.order_bill = '$orderbill' AND orderdetails_tbl.seller_id = '$sellerid'";
    }else{
        $sqlorderdetails = "NA";
    }
    
    $result = $conn->query($sqlorderdetails);
    if ($result->num_rows > 0) {
        $oderdetails["orderdetails"] = array();
    	while ($row = $result->fetch_assoc()) {
            $orderdetailslist = array();
            $orderdetailslist['orderdetail_id'] = $row['orderdetail_id'];
            $orderdetailslist['order_bill'] = $row['order_bill'];
            $orderdetailslist['item_id'] = $row['item_id'];
            $orderdetailslist['item_name'] = $row['item_name'];
            $orderdetailslist['orderdetail_qty'] = $row['orderdetail_qty'];
            $orderdetailslist['orderdetail_paid'] = $row['orderdetail_paid'];
            $orderdetailslist['buyer_id'] = $row['buyer_id'];
            $orderdetailslist['seller_id'] = $row['seller_id'];
            $orderdetailslist['orderdetail_date'] = $row['orderdetail_date'];
            array_push($oderdetails["orderdetails"] ,$orderdetailslist);
        }
        $response = array('status' => 'success', 'data' => $oderdetails,'mysql'=>$sqlorderdetails);
        sendJsonResponse($response);
    }else{
         $response = array('status' => 'failed', 'data' => null, 'mysql'=> $sqlorderdetails);
        sendJsonResponse($response);
    }
    function sendJsonResponse($sentArray)
    {
        header('Content-Type: application/json');
        echo json_encode($sentArray);
    }
?>