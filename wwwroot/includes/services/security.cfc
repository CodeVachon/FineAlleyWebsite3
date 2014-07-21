/**
*
* @file  /C/inetpub/wwwroot/finealley/FineAlleyWebsite2/services/security.cfc
* @author  
* @description
*
*/

component output="false" displayname="security" extends="object" {

	public function init() { return this; }


	public boolean function checkPermission(required string permissionName) {
		if (this.isLoggedIn()) {
			if (structKeyExists(SESSION.userData,"permissions")) {
				if (structKeyExists(SESSION.userData.permissions,ARGUMENTS.permissionName) && isBoolean(SESSION.userData.permissions[ARGUMENTS.permissionName])) {
					return SESSION.userData.permissions[ARGUMENTS.permissionName];
				}
			}
		}
		return false;
	}


	public boolean function isLoggedIn() {
		return structKeyExists(SESSION,"userData");
	}


	public void function logOut() {
		if (this.isLoggedIn()) {
			structDelete(SESSION,"userData");
		}
	}


	public void function logIn() {
		if (!structKeyExists(ARGUMENTS,"username")) { throw("Username not providing"); }
		if (!structKeyExists(ARGUMENTS,"password")) { throw("Password not providing"); }

		var personService = new services.personService();
		var person = personService.getPerson(username=ARGUMENTS.username);
		if ((person.getUsername() == ARGUMENTS.username) && (person.getPassword() == hash(ARGUMENTS.password,"md5"))) {
			SESSION.userData = {
				firstName = person.getFirstName(),
				lastName = person.getLastName(),
				username = person.getusername(),
				permissions = {
					isAdmin = person.getIsAdmin()
				}
			};
		}
	}
}