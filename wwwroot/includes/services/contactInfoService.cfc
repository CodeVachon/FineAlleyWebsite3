/**
*
* @file  /C/inetpub/wwwroot/finealley/FineAlleyWebsite2/services/contactInfoService.cfc
* @author  
* @description
*
*/

component output="false" displayname="" extends="baseService" {

	public function init(){
		return super.init();
	}


	public models.contactInfo function getContactInfo() {
		if ((structCount(ARGUMENTS) == 1) && structKeyExists(ARGUMENTS,"1")) { ARGUMENTS = reduceStructLevel(ARGUMENTS[1]); }
		var _contactInfo = javaCast("null","");

		if (structKeyExists(ARGUMENTS,"contactInfoId")) {
			_contactInfo = ORMExecuteQuery("SELECT DISTINCT o FROM contactInfo o WHERE o.id=:id",{id=ARGUMENTS.contactInfoId},true);
		} else if (structKeyExists(ARGUMENTS,"id")) {
			_contactInfo = ORMExecuteQuery("SELECT DISTINCT o FROM contactInfo o WHERE o.id=:id",{id=ARGUMENTS.id},true);
		}

		if (isNull(_contactInfo)) { _contactInfo = entityNew("contactInfo"); }
		return _contactInfo;
	}


	public array function getContactInfos() {
		if ((structCount(ARGUMENTS) == 1) && structKeyExists(ARGUMENTS,"1")) { ARGUMENTS = reduceStructLevel(ARGUMENTS[1]); }

		if (!structKeyExists(ARGUMENTS,"page")) { ARGUMENTS.page = 1; }
		if (!structKeyExists(ARGUMENTS,"itemsPerPage")) { ARGUMENTS.itemsPerPage = 25; }

		var _maxResults = int(ARGUMENTS.itemsPerPage);
		var _offset=((ARGUMENTS.page-1)*_maxResults);

		return ORMExecuteQuery("SELECT DISTINCT o FROM contactInfo o WHERE  o.isDeleted=:isDeleted",{isDeleted=false},false,{maxResults=_maxResults,offset=_offset});
	}


	public models.contactInfo function editContactInfo() {
		if ((structCount(ARGUMENTS) == 1) && structKeyExists(ARGUMENTS,"1")) { ARGUMENTS = reduceStructLevel(ARGUMENTS[1]); }
		return super.setValuesInObject(this.getcontactInfo(ARGUMENTS),ARGUMENTS);
	}


	public models.contactInfo function editContactInfoAndSave() {
		if ((structCount(ARGUMENTS) == 1) && structKeyExists(ARGUMENTS,"1")) { ARGUMENTS = reduceStructLevel(ARGUMENTS[1]); }
		return super.saveObject(this.editcontactInfo(ARGUMENTS));
	}


	public models.contactInfo function removeContactInfo() {
		if ((structCount(ARGUMENTS) == 1) && structKeyExists(ARGUMENTS,"1")) { ARGUMENTS = reduceStructLevel(ARGUMENTS[1]); }
		return super.removeObject(this.getcontactInfo(ARGUMENTS));
	}
}