<?php
///////////////////////////////////////////////////////////////////////////////
//
//    Copyright 2012 Ross Camara
//
//    This file is part of Addressbook.
//
//    Addressbook is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    AddressBook is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with Addressbook.  If not, see <http://www.gnu.org/licenses/>.
//
///////////////////////////////////////////////////////////////////////////////

require_once("dbconnect.php");
require(dirname(__FILE__).'/response.php');

define('SALT', 'melanie');

$response = new Response();
header("Content-type: application/json", true);
$json = array();
if (!$_REQUEST['username'] || !$_REQUEST['password'])
{
    $response->success = false;
    $response->message = 'Username/Password missing';
	echo $response->to_json();
	die();
}

if (isset($_REQUEST['register']) && $_REQUEST['register'] == true){
	$query = "SELECT uid FROM users WHERE username='". $_REQUEST['username']. "'";
	$uid = $DB->GetOne($query);
	
	if($uid != null){
		$response->success = false;
		$response->message = 'There already exist a user with this username';
		echo $response->to_json();
		die();
	}
	
	$record['username'] = $_REQUEST['username'];
	$record['password'] = ''.crypt($_REQUEST['password'], SALT);
	$record['active'] = 0;
	$DB->AutoExecute('users',$record, 'INSERT');
	
	
	$response->success = false;
	$response->message = 'Information entered. Please contact Ross to activate account.';
	echo $response->to_json();
	die();
}

$query = "SELECT uid FROM users WHERE username='". $_REQUEST['username']. "' AND password='".crypt($_REQUEST['password'], SALT)."' AND active=1";
$uid = $DB->GetOne($query);

if ($uid == null){
    $response->success = false;
    $response->message = 'Invalid User/Password combination ';
    echo $response->to_json();
	die();
}

$ip = getenv('REMOTE_ADDR');
$query = "UPDATE users SET last_ip='$ip' WHERE uid='$uid'";
$results = $DB->Execute($query);

$response->success = true;
$response->message = 'Login Success';
echo $response->to_json();

?>