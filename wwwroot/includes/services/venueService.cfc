/**
*
* @file  /C/inetpub/wwwroot/finealley/FineAlleyWebsite2/services/venueService.cfc
* @author  
* @description
*
*/

component output="false" displayname="" extends="baseService" {

	public function init(){
		return super.init();
	}


	public models.venue function getVenue() {
		if ((structCount(ARGUMENTS) == 1) && structKeyExists(ARGUMENTS,"1")) { ARGUMENTS = reduceStructLevel(ARGUMENTS[1]); }
		var _venue = javaCast("null","");

		if (structKeyExists(ARGUMENTS,"venueId")) {
			_venue = ORMExecuteQuery("SELECT DISTINCT o FROM venue o WHERE o.id=:id",{id=ARGUMENTS.venueId},true);
		} else if (structKeyExists(ARGUMENTS,"encodedName")) {
			_venue = ORMExecuteQuery("SELECT DISTINCT o FROM venue o WHERE o.encodedName=:encodedName",{encodedName=ARGUMENTS.encodedName},true);
		} else if (structKeyExists(ARGUMENTS,"id")) {
			_venue = ORMExecuteQuery("SELECT DISTINCT o FROM venue o WHERE o.id=:id",{id=ARGUMENTS.id},true);
		}

		if (isNull(_venue)) { _venue = entityNew("venue"); }
		return _venue;
	}


	public array function getVenues() {
		if ((structCount(ARGUMENTS) == 1) && structKeyExists(ARGUMENTS,"1")) { ARGUMENTS = reduceStructLevel(ARGUMENTS[1]); }

		if (!structKeyExists(ARGUMENTS,"page")) { ARGUMENTS.page = 1; }
		if (!structKeyExists(ARGUMENTS,"itemsPerPage")) { ARGUMENTS.itemsPerPage = 25; }

		var _maxResults = int(ARGUMENTS.itemsPerPage);
		var _offset=((ARGUMENTS.page-1)*_maxResults);

		return ORMExecuteQuery("SELECT DISTINCT o FROM venue o WHERE  o.isDeleted=:isDeleted",{isDeleted=false},false,{maxResults=_maxResults,offset=_offset});
	}


	public models.venue function editVenue() {
		if ((structCount(ARGUMENTS) == 1) && structKeyExists(ARGUMENTS,"1")) { ARGUMENTS = reduceStructLevel(ARGUMENTS[1]); }
		var _venue = super.setValuesInObject(this.getVenue(ARGUMENTS),ARGUMENTS);

		return _venue;
	}


	public models.venue function editVenueAndSave() {
		if ((structCount(ARGUMENTS) == 1) && structKeyExists(ARGUMENTS,"1")) { ARGUMENTS = reduceStructLevel(ARGUMENTS[1]); }
		return super.saveObject(this.editVenue(ARGUMENTS));
	}


	public models.venue function removeVenue() {
		if ((structCount(ARGUMENTS) == 1) && structKeyExists(ARGUMENTS,"1")) { ARGUMENTS = reduceStructLevel(ARGUMENTS[1]); }
		return super.removeObject(this.getVenue(ARGUMENTS));
	}


	public models.venue function editContentInfoAndAddToVenue() {
		if ((structCount(ARGUMENTS) == 1) && structKeyExists(ARGUMENTS,"1")) { ARGUMENTS = reduceStructLevel(ARGUMENTS[1]); }
		var _venue = this.getVenue(ARGUMENTS);

		var _contactInfoService = new services.contactInfoService();
		var _contactInfo = _contactInfoService.editContactInfo(ARGUMENTS);

		if (!_venue.hasContactInfo(_contactInfo)) {
			_venue.addContactInfo(_contactInfo);
		}

		return _venue;
	}


	public models.venue function editContentInfoAndAddToVenueAndSave() {
		if ((structCount(ARGUMENTS) == 1) && structKeyExists(ARGUMENTS,"1")) { ARGUMENTS = reduceStructLevel(ARGUMENTS[1]); }
		return super.saveObject(this.editContentInfoAndAddToVenue(ARGUMENTS));
	}


	public models.venue function removeContactInfoFromVenue() {
		if ((structCount(ARGUMENTS) == 1) && structKeyExists(ARGUMENTS,"1")) { ARGUMENTS = reduceStructLevel(ARGUMENTS[1]); }
		var _contactInfoService = new services.contactInfoService();
		var _contactInfo = _contactInfoService.getContactInfo(ARGUMENTS);
		var _venue = this.getVenue(ARGUMENTS);
		return super.saveObject(_venue.removeContactInfo(_contactInfo));
	}
}