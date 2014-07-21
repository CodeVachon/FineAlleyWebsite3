/**
*
* @file  /C/inetpub/wwwroot/finealley/FineAlleyWebsite2/models/event.cfc
* @author  Christopher Vachon
* @description Holds Event Information
*
*/

component extends="base" displayname="event" persistent="true" table="events" {

	property name="title" type="string";
	property name="dateTime" type="datetime" ormtype="timestamp";
	property name="body" type="string" length="25000";
	property name="location" type="string" length="250";

	property name="facebookEventID" type="string" length="150";

	property name="venue" fieldtype="many-to-one" cfc="venue" fkcolumn="venueId" cascade="all";


	public function init(){
		return super.init();
	}


	public void function refreshProperties() {
		super.refreshProperties();
		if (!structKeyExists(VARIABLES,'title')) { VARIABLES.title = javacast("null",""); }
		if (!structKeyExists(VARIABLES,'dateTime')) { VARIABLES.dateTime = now(); }
		if (!structKeyExists(VARIABLES,'body')) { VARIABLES.body = javacast("null",""); }
		if (!structKeyExists(VARIABLES,'location')) { VARIABLES.location = javacast("null",""); }
		if (!structKeyExists(VARIABLES,'facebookEventID')) { VARIABLES.facebookEventID = javacast("null",""); }

		if (!structKeyExists(VARIABLES,'venue')) { VARIABLES.venue = javacast("null",""); }
	}


	public string function getEncodedTitle() {
		return urlEncodeValue(this.getTitle());
	}


	public string function getURI() {
		return "/" & year(this.getDateTime()) & "/" & month(this.getDateTime()) & "/" & day(this.getDateTime()) & "/" & this.getEncodedTitle();
	}
}