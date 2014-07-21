/**
*
* @file  /C/inetpub/wwwroot/finealley/FineAlleyWebsite2/models/contactInfo.cfc
* @author  
* @description
*
*/

component extends="base" displayname="contactInfo" persistent="true" table="contactInfo" discriminatorColumn="type" {

	property name="displayToPublic" type="boolean";


	public function init(){
		return super.init();
	}


	public void function refreshProperties() {
		super.refreshProperties();
		if (!structKeyExists(VARIABLES,'displayToPublic')) { VARIABLES.displayToPublic = true; }
	}
}