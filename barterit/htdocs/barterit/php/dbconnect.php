<?php
	$servername = "localhost";
	$username   = "jxperson_adminbarterit";
	$password   = "G52g2o5anm&H";
	$dbname     = "jxperson_barterit";

	$conn = new mysqli($servername, $username, $password, $dbname);
	if ($conn->connect_error) {
		die("Connection failed: " . $conn->connect_error);
	}
?>