<?php
  if(!defined('ENGINE')) die();

  function GlobalLoadEnvironmentVariables() {
    $f = '../.env';
    if(file_exists($f)) {
      foreach(explode("\n", file_get_contents($f)) as $value) {
        if(trim($value) != '') {
          $pos = strpos($value, '=');
          if($pos === false) continue;
          $_ENV[substr($value, 0, $pos)] = substr($value, $pos + 1, strlen($value) - $pos - 1);
        }
      }
    }
  }

  // Read ENV variables
  GlobalLoadEnvironmentVariables();

  // Set default timezone
  date_default_timezone_set($_ENV['TZ']);
