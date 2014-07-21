/**
*
* @file  /C/inetpub/wwwroot/finealley/FineAlleyWebsite2/models/mail.cfc
* @author  
* @description
*
*/

component extends="base" displayname="mail" persistent="true" table="mailMessages" {

	property name="subject" type="string";
	property name="dateTime" type="datetime" ormtype="timestamp";
	property name="body" type="string" length="25000";
	
	property name="fromName" type="string";
	property name="fromEmailAddress" type="string";
	property name="fromPhone" type="string";


	public function init(){
		return super.init();
	}


	public void function refreshProperties() {
		super.refreshProperties();
		if (!structKeyExists(VARIABLES,'subject')) { VARIABLES.subject = javacast("null",""); }
		if (!structKeyExists(VARIABLES,'body')) { VARIABLES.body = javacast("null",""); }

		if (!structKeyExists(VARIABLES,'fromName')) { VARIABLES.fromName = javacast("null",""); }
		if (!structKeyExists(VARIABLES,'fromEmailAddress')) { VARIABLES.fromEmailAddress = javacast("null",""); }
		if (!structKeyExists(VARIABLES,'fromPhone')) { VARIABLES.fromPhone = javacast("null",""); }

		if (!structKeyExists(VARIABLES,'dateTime')) { VARIABLES.dateTime = now(); }
	}
}