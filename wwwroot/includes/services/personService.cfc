/**
*
* @file  /C/inetpub/wwwroot/finealley/services/personService.cfc
* @author  
* @description
*
*/

component output="false" extends="baseService" displayname=""  {
	public function init(){ return super.init(); }


	public models.person function getPerson() {
		if (isStruct(ARGUMENTS[1])) { ARGUMENTS = reduceStructLevel(ARGUMENTS[1]); }

		var _person = javaCast("NULL","");

		if (structKeyExists(ARGUMENTS,'personID')) {
			_person = entityLoadByPK("person",ARGUMENTS.personID);
		} else if (structKeyExists(ARGUMENTS,'username')) {
			var _personArray = ORMExecuteQuery("SELECT DISTINCT p FROM person p WHERE p.userName = :username",{username = ARGUMENTS.username},false);
			if (arrayLen(_personArray) > 0) {
				_person = _personArray[1];
			}
		}

		if (isNull(_person)) { _person = entityNew("person"); }
		return _person;
	} // close getPerson();


	public array function getPeople() {
		if (isStruct(ARGUMENTS[1])) { ARGUMENTS = reduceStructLevel(ARGUMENTS[1]); }
		return ORMExecuteQuery("FROM person",{},false);
	} // close getPeople();


	public models.person function editPerson() {
		if (isStruct(ARGUMENTS[1])) { ARGUMENTS = reduceStructLevel(ARGUMENTS[1]); }
		if (structKeyExists(ARGUMENTS,"password") && (len(ARGUMENTS.password) == 0)) {
			structDelete(ARGUMENTS,"password");
		}
		var _person = this.setValuesInObject(this.getPerson(ARGUMENTS),ARGUMENTS);
		if (structKeyExists(ARGUMENTS,"password")) { _person.setPassword(trim(ARGUMENTS.password)); }
		return _person;
	} // close editPerson()


	public models.person function editPersonAndSave() {
		if (isStruct(ARGUMENTS[1])) { ARGUMENTS = reduceStructLevel(ARGUMENTS[1]); }
		return this.saveObject(this.editPerson(ARGUMENTS));
	} // close editPersonAndSave() 	
}