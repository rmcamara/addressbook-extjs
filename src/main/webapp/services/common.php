<?php
///////////////////////////////////////////////////////////////////////////////
//    
//    Copyright 2008 Ross Camara
//
//    This file is part of Addressbook.
//
//    Foobar is free software: you can redistribute it and/or modify
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
//    along with Foobar.  If not, see <http://www.gnu.org/licenses/>.
//
///////////////////////////////////////////////////////////////////////////////

require_once(dirname(__FILE__)."/dbconnect.php");

require(dirname(__FILE__).'/request.php');
require(dirname(__FILE__).'/response.php');

include(dirname(__FILE__)."/dbscheme.php");

//

$ip = getenv('REMOTE_ADDR');
$msg = print_r($_REQUEST, true);
$query = "INSERT INTO requestLog (source, request) VALUES ('$ip', '$msg')";
$DB->Execute($query);

$request = new Request(array('restful' => false));

// perform login check

function GetValueString($key, $value, $results){
	if($value == null){
		return $value;
	}

	if ($key == 'birth' || $key == "last-update"){
		return $results->UserTimeStamp($value, "Y/m/d H:i:s");
	}
	else{
		return stripslashes($value);
	}
}

function ListAllAddress() {
	global $DB;
	global $request;
    $res = new Response();

	// validate the id is correct

	$query = "SELECT * FROM places Order by " . Place::NAME;
	$results = $DB->Execute($query);
	
	$res->data = array();
	while ($AddressGroup = $results->FetchRow()) {
		$place = array();
		
		foreach ($AddressGroup as $key => $value){
			$place[$key]=GetValueString($key, $value, $results);
		}
		
		$pquery = "Select id, firstname, lastname, title ".
				"FROM people LEFT JOIN links ON people.id=links.people ".
				"WHERE links.places=" . $AddressGroup['id'];
		$people = $DB->Execute($pquery);

		$place['People'] = array();
		while ($person = $people->FetchRow()) {
			$jPerson = array();
			foreach ($person as $key => $value){
				$jPerson[$key] = GetValueString($key, $value, $results);
			}
			$place['People'][] = $jPerson;
		}
		
		$res->data[] = $place;
	}

	$res->success = true;
	$res->message = "Loaded People";
	return $res;
}

function ListPeople() {
	global $DB;
	global $request;
    $res = new Response();
	
	// validate the id is correct
    $jRequest = get_object_vars($request->params);

	$query = "SELECT * FROM " . Person::TABLE_NAME . " Order By " . Person::LASTNAME.", ". Person::FIRSTNAME;
	$results = $DB->Execute($query);

	$res->data = array();
	while ($person = $results->FetchRow()) {
		$personArr = array();
		
		foreach ($person as $key => $value){
			$personArr[$key] = GetValueString($key, $value, $results);
		}

		$pquery = "Select ". Place::ID . ", " . Place::NAME .
				" FROM ". Place::TABLE_NAME .
				" LEFT JOIN links ON ".Place::TABLE_NAME.".".Place::ID."=links.places ".
				"WHERE links.people=" . $person[Person::ID];
		$places = $DB->Execute($pquery);

		$personArr['places'] = array();
		$xml->startElement('Places');
		while ($location = $places->FetchRow()) {
			$locArr = array();
			foreach ($location as $key => $value){
				$locArr[$key]=GetValueString($key, $value, $results);
			}
			$personArr['places'][] = $locArr;
		}
		$res->data[] = $personArr;
	}

	$res->success = true;
	$res->message = "Loaded People";
	return $res;
}

function ListPersonLinksForLocation() {
	global $DB;
	global $request;
    $res = new Response();

	// validate the id is correct

	$placeQuery = "SELECT * FROM links WHERE places=" . $request->params->id;
	$places = $DB->Execute($placeQuery);
	$placeIds = Array();
	while ($place = $places->FetchRow()) {
		array_push($placeIds, $place['people']);
	}

	$query = "SELECT " .Person::ID.", ".Person::FIRSTNAME.", " .Person::LASTNAME.
	" FROM " . Person::TABLE_NAME;
	$results = $DB->Execute($query);

	$res->data = array();
	while ($place = $results->FetchRow()) {
		$placeArr = array();
		foreach ($place as $key => $value){
			$placeArr[$key] = GetValueString($key, $value, $results);
		}
		if (in_array($place[Place::ID], $placeIds)){
			$placeArr['selected'] = 'true';
		}
		$res->data[] = $placeArr;
	}

	$res->success = true;
	$res->message = "Listed people for place: ".$request->params->id;
	return $res;
}

function ListLocationLinksForPerson() {
	global $DB;
	global $request;
    $res = new Response();

	// validate the id is correct

	$placeQuery = "SELECT * FROM links WHERE people=" . $request->params->id;
	$people = $DB->Execute($placeQuery);
	$peopleIds = Array();
	while ($person = $people->FetchRow()) {
		array_push($peopleIds, $person['places']);
	}

	$query = "SELECT ".Place::ID.", ".Place::NAME.", " .Place::STATE.", " .Place::CITY.
			 " FROM " . Place::TABLE_NAME;
	$results = $DB->Execute($query);
	
	$res->data = array();
	while ($person = $results->FetchRow()) {
		$personArr = array();
		foreach ($person as $key => $value){
			$personArr[$key] = GetValueString($key, $value, $results);
		}
		if (in_array($person[Place::ID], $peopleIds)){
			$personArr['selected'] = 'true';
		}
		$res->data[] = $personArr;
	}

	$res->success = true;
	$res->message = "Listed loctions for person: ".$request->params->id;
	return $res;
}

function UpdateLinks($mode) {
	global $DB;
	global $request;
    $res = new Response();
    $jRequest = get_object_vars($request->params);

    $linkCount = $request->params->count;

	// Remove links no longer used.
	$deleteQuery = "DELETE FROM links WHERE ";
	$deleteQuery .= $mode ? "places=" : "people=";
	$deleteQuery .= $request->params->id;
	$deleteQuery .= " AND ";
	$deleteQuery .= $mode ? "people" : "places";
	$deleteQuery .= " NOT IN (";
	for ($x = 0; $x < $linkCount; $x++){
		if ($x > 0){
			$deleteQuery .= ", ";
		}
		$deleteQuery .= $jRequest['lid'.$x];
	}
	$deleteQuery .= ")";
	$DB->Execute($deleteQuery);

	for ($x = 0; $x < $linkCount; $x++){
		$query = "Select * FROM links WHERE ";
		$query .= $mode ? "places=" : "people=";
		$query .= $request->params->id;
		$query .= " AND ";
		$query .= $mode ? "people=" : "places=";
		$query .= $jRequest['lid'.$x];
		
		$results = $DB->Execute($query);
		
		if ($results->FetchRow() == null){
			$query = "INSERT INTO links (";
			$query .= $mode ? "places" : "people";
			$query .= ", ";
			$query .= $mode ? "people" : "places";
			$query .= ") VALUES (";
			$query .= $request->params->id;
			$query .= ", ";
			$query .= $_REQUEST['lid'.$x];
			$query .= ")";

			$DB->Execute($query);
		}
	}


	$res->success = true;
	$res->message = "Updated list of links";
	return $res;
}

function GetPerson() {
	global $DB;
	global $request;
	$res = new Response();

	$fields = array( Person::ID => $request->params->id);

	$query = "SELECT * FROM ".Person::TABLE_NAME.generateWhere($fields);
	$results = $DB->Execute($query);

	while ($person = $results->FetchRow()) { // only ever one record
		$personArr = array();
		foreach ($person as $key => $value){
			$personArr[$key] = GetValueString($key, $value, $results);
		}

		$pquery = "Select * ".
				"FROM ".Place::TABLE_NAME.
				" LEFT JOIN links ON ".Place::TABLE_NAME.'.'.Place::ID."=links.places ".
				"WHERE links.people=" . $person['id'];
		$places = $DB->Execute($pquery);

		$personArr['locations'] = array();
		while ($place = $places->FetchRow()) {
			$placeArr = array();
			foreach ($place as $key => $value){
				$placeArr[$key] = GetValueString($key, $value, $results);
			}
			$personArr['locations'][] = $placeArr;
		}
		
		$res->data = $personArr;
	}
	
	$res->success = true;
	$res->message = "Loaded Record";
	return $res;
}

function CommitPerson(){
	global $DB;
	global $request;
	$res = new Response();

	$jRequest = get_object_vars($request->params);
	if($request->params->id < 1){
		$DB->AutoExecute(Person::TABLE_NAME,$record, 'INSERT');
		
		// update the id.
		$sql = "select " . Person::ID . " from " . Person::TABLE_NAME . generateWhere($jRequest) .
		" Order by `" . Person::LAST_UPDATE . "` DESC";
		$request->params->id = $DB->GetOne($sql);
	}
	else{
		$DB->AutoExecute(Person::TABLE_NAME,$jRequest, 'UPDATE', Person::ID."=".$request->params->id, false);
	}
		
	$res->success = true;
	$res->message = "Updated Record";
	$res->data = GetPerson()->data;
	return $res;
}

function GetLocation() {
	global $DB;
	global $request;
    $res = new Response();

	$fields = array( Place::ID => $request->params->id);
	$query = "SELECT * FROM ".Place::TABLE_NAME. generateWhere($fields);
	$results = $DB->Execute($query);

	while ($place = $results->FetchRow()) {
		$placeArr = array();

        foreach ($place as $key => $value){
        	$placeArr[$key]=GetValueString($key, $value, $results);
        }

		$pquery = "Select * ".
				"FROM ".Person::TABLE_NAME.
				" LEFT JOIN links ON ".Person::TABLE_NAME.'.'.Person::ID."=links.people ".
				"WHERE links.places=" . $place[Place::ID];
		$people = $DB->Execute($pquery);

        $placeArr['People'] = array();
        while ($person = $people->FetchRow()) {
        	$jPerson = array();
        	foreach ($person as $key => $value){
        		$jPerson[$key] = GetValueString($key, $value, $results);
        	}
        	$placeArr['People'][] = $jPerson;
        }

        $res->data = $placeArr;
	}

    $res->success = true;
    $res->message = "Loaded Record";
	return $res;
}

function CommitLocation(){
	global $DB;
	global $request;
    $res = new Response();

    $jRequest = get_object_vars($request->params);
	if($request->params->id < 1){
		$DB->AutoExecute(Place::TABLE_NAME,$jRequest, 'INSERT');

		// update the id.
		$sql = "select " . Place::ID . " from " . Place::TABLE_NAME . generateWhere($jRequest) .
		" Order by `" . Place::LAST_UPDATE . "` DESC";
		$request->params->id = $DB->GetOne($sql);
	}
	else{
		$DB->AutoExecute(Place::TABLE_NAME,$jRequest, 'UPDATE', Place::ID."=".$request->params->id, false);
	}

    $res->success = true;
    $res->message = "Updated Record";
    $res->data = GetLocation()->data;
	return $res;
}

function DeleteModel($mode){
	global $DB;

	$xml = new XMLWriter();
	$xml->openMemory();
	$xml->setIndent(true);
	$xml->startDocument('1.0','UTF-8');
	$xml->startElement('response');

	$query = "DELETE FROM links WHERE ";
	$query .= $mode ? "places" : "people";
	$query .= "=";
	$query .= $mode ? $_REQUEST[Place::ID] : $_REQUEST[Person::ID];
	$DB->Execute($query);
	$xml->startElement('links');
	$xml->text($query);
	$xml->endElement();

	$query = "DELETE FROM ";
	$query .= $mode ? Place::TABLE_NAME : Person::TABLE_NAME;
	$query .= " WHERE ";
	$query .= $mode ? Place::ID : Person::ID;
	$query .= "=";
	$query .= $mode ? $_REQUEST[Place::ID] : $_REQUEST[Person::ID];
	$DB->Execute($query);
	$xml->startElement('item');
	$xml->text($query);
	$xml->endElement();

	$xml->endElement(); // end response
	$xml->endDocument();
	header("Content-type: text/xml");
	print $xml->outputMemory(true);
}
?>