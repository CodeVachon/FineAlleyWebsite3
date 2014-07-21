/**
*
* @file  /C/inetpub/wwwroot/finealley/FineAlleyWebsite2/models/address.cfc
* @author  
* @description
*
*/

component extends="contactInfo" displayname="address" persistent="true" table="addresses" joinColumn="contactInfoId" discriminatorValue="address" {

	property name="name" type="string";
	property name="addressLine1" type="string";
	property name="addressLine2" type="string";
	property name="city" type="string";
	property name="state" type="string";
	property name="country" type="string";
	property name="zipcode" type="string";


	public function init(){
		return super.init();
	}


	public void function refreshProperties() {
		super.refreshProperties();
		if (!structKeyExists(VARIABLES,'name')) { VARIABLES.name = javacast("null",""); }
		if (!structKeyExists(VARIABLES,'addressLine1')) { VARIABLES.addressLine1 = javacast("null",""); }
		if (!structKeyExists(VARIABLES,'addressLine2')) { VARIABLES.addressLine2 = javacast("null",""); }
		if (!structKeyExists(VARIABLES,'city')) { VARIABLES.city = javacast("null",""); }
		if (!structKeyExists(VARIABLES,'state')) { VARIABLES.state = javacast("null",""); }
		if (!structKeyExists(VARIABLES,'country')) { VARIABLES.country = javacast("null",""); }
		if (!structKeyExists(VARIABLES,'zipcode')) { VARIABLES.zipcode = javacast("null",""); }
	}
}