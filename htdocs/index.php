<?php
  define('ENGINE', true);
  include_once('startup.php');

  // $_ENV['MYSQL_USER']
  // $_ENV['MYSQL_PASS']
  // $_ENV['MYSQL_BASE']
  // $_ENV['MYSQL_HOST']

  $mysqli = new mysqli($_ENV['MYSQL_HOST'], $_ENV['MYSQL_USER'], $_ENV['MYSQL_PASS'], $_ENV['MYSQL_BASE']);
  if($mysqli->connect_error) {
    echo '<pre>';
    echo 'MySQL connection error'."\n";
    echo 'Error code errno: '.$mysqli->connect_errno."\n";
    echo 'Error message error: '.$mysqli->connect_error."\n";
    echo '</pre>';
    die();
  }

  // Print date/time from PHP
  echo "Hello from PHP!<br>".date("Y-m-d / H:i:s");

  // Print date/time from MySQL
  echo '<pre>';
  $res = $mysqli->query("SELECT SYSDATE()");
  $res->data_seek(0);
  while($row = $res->fetch_assoc()) {
    print_r($row);
  }
  echo '</pre>';

  // Close connection
  $mysqli->close();
