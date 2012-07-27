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

$ip = $_SERVER['REMOTE_ADDR'];
$msg = $_SERVER['REQUEST_URI'] . '\n' . print_r($_REQUEST, true);
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
				"WHERE links.places=" . $AddressGroup[Place::ID];
		$people = $DB->Execute($pquery);

		$place['people'] = array();
		while ($person = $people->FetchRow()) {
			$jPerson = array();
			$jPerson['parent_id'] = $AddressGroup[Place::ID];
			foreach ($person as $key => $value){
				$jPerson[$key] = GetValueString($key, $value, $results);
			}
			$place['people'][] = $jPerson;
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

    if (isset($_REQUEST['filter'])){
        $params = json_decode(stripslashes($_REQUEST['filter']));
        $query = "SELECT * FROM " . Person::TABLE_NAME .
                 " LEFT JOIN links ON " . Person::TABLE_NAME . "." . Person::ID . "=links.people" .
                 " WHERE links.places=" . $params[0]->value .
                 " Order By " . Person::LASTNAME . ", " . Person::FIRSTNAME;
        $results = $DB->Execute($query);
    }
    else{
	    $query = "SELECT * FROM " . Person::TABLE_NAME . " Order By " . Person::LASTNAME.", ". Person::FIRSTNAME;
	    $results = $DB->Execute($query);
	}

	$res->data = array();
	while ($person = $results->FetchRow()) {
		$personArr = array();
		
		foreach ($person as $key => $value){
			$personArr[$key] = GetValueString($key, $value, $results);
		}

		$pquery = "Select * FROM ". Place::TABLE_NAME .
				" LEFT JOIN links ON ".Place::TABLE_NAME.".".Place::ID."=links.places ".
				"WHERE links.people=" . $person[Person::ID];
		$places = $DB->Execute($pquery);

		$personArr['places'] = array();
		while ($location = $places->FetchRow()) {
			$locArr = array();
			$locArr['parent_id'] = $person[Person::ID];
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

    $id = $_REQUEST[Place::ID];
	// validate the id is correct
	$placeQuery = "SELECT * FROM links WHERE places=" . $id;
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
		$placeArr['parent_id'] = $id;
		foreach ($place as $key => $value){
			$placeArr[$key] = GetValueString($key, $value, $results);
		}
		if (in_array($place[Place::ID], $placeIds)){
			$placeArr['selected'] = 'true';
		}
		$res->data[] = $placeArr;
	}

	$res->success = true;
	$res->message = "Listed people for place: ".$id;
	return $res;
}

function ListLocationLinksForPerson() {
	global $DB;
	global $request;
    $res = new Response();

	// validate the id is correct

    $id = $_REQUEST[Person::ID];
	$placeQuery = "SELECT * FROM links WHERE people=" . $id;
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
		$personArr['parent_id'] = $id;
		foreach ($person as $key => $value){
			$personArr[$key] = GetValueString($key, $value, $results);
		}
		if (in_array($person[Place::ID], $peopleIds)){
			$personArr['selected'] = 'true';
		}
		$res->data[] = $personArr;
	}

	$res->success = true;
	$res->message = "Listed locations for person: ".$id;
	return $res;
}

function UpdateLinks($mode) {
	global $request;
    $res = new Response();

    $linkCount = $request->params;

    if (is_array($request->params)){
        for ($x = 0; $x < count($request->params); $x++){
            ProcessLinkUpdate($mode, $res, $request->params[$x]);
        }
    }else{
        ProcessLinkUpdate($mode, $res, $request->params);
    }

    $res->data = $request->params;
    $res->success = true;
    $res->message = "Updated list of links";
    return $res;
}

function ProcessLinkUpdate($mode, $res, $model){
    global $DB;
	global $request;

    if (!$model->selected){
        // Remove links no longer used.
        $deleteQuery = "DELETE FROM links WHERE ";
        $deleteQuery .= $mode ? "places=" : "people=";
        $deleteQuery .= $model->parent_id;
        $deleteQuery .= " AND ";
        $deleteQuery .= $mode ? "people=" : "places=";
        $deleteQuery .= $model->id;
        $DB->Execute($deleteQuery);
    }
    else{
        $query = "INSERT INTO links (";
        $query .= $mode ? "places" : "people";
        $query .= ", ";
        $query .= $mode ? "people" : "places";
        $query .= ") VALUES (";
        $query .= $model->parent_id;
        $query .= ", ";
        $query .= $model->id;
        $query .= ")";

        $DB->Execute($query);
    }
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
    global $request;
    $res = new Response();

	$query = "DELETE FROM links WHERE ";
	$query .= $mode ? "places" : "people";
	$query .= "=";
	$query .= $request->params->id;

	$query = "DELETE FROM ";
	$query .= $mode ? Place::TABLE_NAME : Person::TABLE_NAME;
	$query .= " WHERE ";
	$query .= $mode ? Place::ID : Person::ID;
	$query .= "=";
	$query .= $request->params->id;
	$DB->Execute($query);

	$res->success = true;
	$res->message = "Record Deleted";
	return $res;
}
?>