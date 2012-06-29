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

if (!$_GET['user'] || !$_GET['password'])
{
	throw new Exception('Malformed login request.');
}

$query = "SELECT uid FROM users WHERE username='". $_GET['user']. "' AND password='".$_GET['password']."'";
$uid = $DB->GetOne($query);

if ($uid == null){
	header('HTTP/1.1 403 Forbidden');
	die();
}

$ip = getenv('REMOTE_ADDR');
$query = "UPDATE users SET last_ip='$ip' WHERE uid='$uid'";
$results = $DB->Execute($query);

header("Content-type: text/json");
echo json_encode(true);

?>