/**
*
* @file  /C/inetpub/wwwroot/finealley/models/person.cfc
* @author  
* @description
*
*/

component output="false" displayname="" extends="base" persistent="true" table="people" {

	property name="firstName" type="string";
	property name="lastName" type="string";

	property name="userName" type="string";
	property name="password" type="string" sqltype="varchar(1000)" setter="false";

	property name="isAdmin" type="boolean";

	public function init(){
		this.refreshProperties();
		return super.init();
	}

	public void function refreshProperties() {
		super.refreshProperties();
		if (!structKeyExists(VARIABLES,"firstName")) { VARIABLES["firstName"] = javaCast("null",""); }
		if (!structKeyExists(VARIABLES,"lastName")) { VARIABLES["lastName"] = javaCast("null",""); }

		if (!structKeyExists(VARIABLES,"userName")) { VARIABLES["userName"] = javaCast("null",""); }
		if (!structKeyExists(VARIABLES,"password")) { VARIABLES["password"] = javaCast("null",""); }

		if (!structKeyExists(VARIABLES,"isAdmin")) { VARIABLES["isAdmin"] = false; }
	}

	public struct function validate() {
		var _validationErrors = super.validate();

		if (!structKeyExists(VARIABLES,"firstName") || (len(VARIABLES["firstName"]) == 0)) { _validationErrors["firstName"] = "invalid lenth for First Name"; }
		if (!structKeyExists(VARIABLES,"lastName") || (len(VARIABLES["lastName"]) == 0)) { _validationErrors["lastName"] = "invalid lenth for Last Name"; }
		if (!structKeyExists(VARIABLES,"username") || (len(VARIABLES["username"]) == 0)) { _validationErrors["username"] = "invalid lenth for User Name"; }

		return _validationErrors;
	}

	public string function getName() {
		return this.getFirstName() & " " & this.getLastName();
	}

	public void function setPassword(required string value) {
		VARIABLES.password = hash(ARGUMENTS.value,"md5");
	}
}