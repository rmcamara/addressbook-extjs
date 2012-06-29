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
header("Content-type: application/json", true);
$json = array();
if (!$_REQUEST['username'] || !$_REQUEST['password'])
{
    $json['success'] = false;
	echo json_encode($json);
	die();
}

$query = "SELECT uid FROM users WHERE username='". $_REQUEST['username']. "' AND password='".$_REQUEST['password']."'";
$uid = $DB->GetOne($query);

if ($uid == null){
    $json['success'] = false;
    $json['errors'] = array();
    $json['errors']['password'] = 'Invalid User/Password combination';
    echo json_encode($json);
	die();
}

$ip = getenv('REMOTE_ADDR');
$query = "UPDATE users SET last_ip='$ip' WHERE uid='$uid'";
$results = $DB->Execute($query);

$json['success'] = true;
echo json_encode($json);

?>