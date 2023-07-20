<?php
    error_reporting(0);
    
    $email = $_GET['email']; 
    $name = $_GET['name']; 
    $userid = $_GET['userid'];
    $amount = $_GET['amount']; 
    $sellerid = $_GET['sellerid'];
    
    
    $api_key = 'd827131e-1079-497c-8995-d364a03a8fd7';
    $collection_id = 'knxziiyy';
    $host = 'https://www.billplz-sandbox.com/api/v3/bills';
    
    $data = array(
              'collection_id' => $collection_id,
              'email' => $email,
              'name' => $name,
              'amount' => ($amount) * 100, // RM20
          'description' => 'Payment for order by '.$name,
              'callback_url' => "https://jxpersonal.com/barterit/return_url",
              'redirect_url' => "https://jxpersonal.com/barterit/php/payment_update.php?userid=$userid&email=$email&amount=$amount&name=$name" 
    );
    
    $process = curl_init($host );
    curl_setopt($process, CURLOPT_HEADER, 0);
    curl_setopt($process, CURLOPT_USERPWD, $api_key . ":");
    curl_setopt($process, CURLOPT_TIMEOUT, 30);
    curl_setopt($process, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($process, CURLOPT_SSL_VERIFYHOST, 0);
    curl_setopt($process, CURLOPT_SSL_VERIFYPEER, 0);
    curl_setopt($process, CURLOPT_POSTFIELDS, http_build_query($data) ); 
    
    $return = curl_exec($process);
    curl_close($process);
    
    $bill = json_decode($return, true);
    header("Location: {$bill['url']}");
?>