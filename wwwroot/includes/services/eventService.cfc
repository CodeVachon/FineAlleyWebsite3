/**
*
* @file  /C/inetpub/wwwroot/finealley/FineAlleyWebsite2/services/eventService.cfc
* @author  
* @description
*
*/

component output="false" displayname="" extends="baseService" {

	public function init(){
		return super.init();
	}


	public models.event function getEvent() {
		if ((structCount(ARGUMENTS) == 1) && structKeyExists(ARGUMENTS,"1")) { ARGUMENTS = reduceStructLevel(ARGUMENTS[1]); }
		var _event = javaCast("null","");

		if (structKeyExists(ARGUMENTS,"eventId")) {
			_event = ORMExecuteQuery("SELECT DISTINCT e FROM event e WHERE e.id=:id",{id=ARGUMENTS.eventId},true);
		} else if (structKeyExists(ARGUMENTS,"date")) {
			ARGUMENTS.date = replace(ARGUMENTS.date,"-","/","all");
			if (isDate(ARGUMENTS.date)) {
				var _dayStart = createDateTime(year(ARGUMENTS.date),month(ARGUMENTS.date),day(ARGUMENTS.date),0,0,0);
				var _dayEnd = createDateTime(year(ARGUMENTS.date),month(ARGUMENTS.date),day(ARGUMENTS.date),23,59,59);
				var _possibleEvents = ORMExecuteQuery("SELECT DISTINCT e FROM event e WHERE e.dateTime > :dayStart AND e.dateTime < :dayEnd",{dayStart=_dayStart,dayEnd=_dayEnd},false);
				if (arrayLen(_possibleEvents) == 1) {
					_event = _possibleEvents[1];
				} else {
					for (var _thisEvent in _possibleEvents) {
						if (_thisEvent.getEncodedTitle() == ARGUMENTS.title) {
							_event = _thisEvent;
						}
					}
				}
			}
		} else if (structKeyExists(ARGUMENTS,"id")) {
			_event = ORMExecuteQuery("SELECT DISTINCT e FROM event e WHERE e.id=:id",{id=ARGUMENTS.id},true);
		}

		if (isNull(_event)) { _event = entityNew("event"); }
		return _event;
	}


	public array function getEvents() {
		if ((structCount(ARGUMENTS) == 1) && structKeyExists(ARGUMENTS,"1")) { ARGUMENTS = reduceStructLevel(ARGUMENTS[1]); }

		if (!structKeyExists(ARGUMENTS,"page")) { ARGUMENTS.page = 1; }
		if (!structKeyExists(ARGUMENTS,"itemsPerPage")) { ARGUMENTS.itemsPerPage = 25; }

		var _maxResults = int(ARGUMENTS.itemsPerPage);
		var _offset=((ARGUMENTS.page-1)*_maxResults);

		if (structKeyExists(ARGUMENTS,"allEvents") && isBoolean(ARGUMENTS.allEvents) && ARGUMENTS.allEvents) {
			return ORMExecuteQuery("SELECT DISTINCT e FROM event e WHERE e.isDeleted=:isDeleted ORDER BY e.dateTime DESC",{isDeleted=false,now=now()},false);
		} else if (structKeyExists(ARGUMENTS,"pastEvents") && isBoolean(ARGUMENTS.pastEvents) && ARGUMENTS.pastEvents) {
			return ORMExecuteQuery("SELECT DISTINCT e FROM event e WHERE e.isDeleted=:isDeleted AND e.dateTime < :now ORDER BY e.dateTime DESC",{isDeleted=false,now=now()},false);
		} else {
			return ORMExecuteQuery("SELECT DISTINCT e FROM event e WHERE  e.isDeleted=:isDeleted AND e.dateTime > :now ORDER BY e.dateTime ASC",{isDeleted=false,now=now()},false,{maxResults=_maxResults,offset=_offset});
		}
	}


	public models.event function editEvent() {
		if ((structCount(ARGUMENTS) == 1) && structKeyExists(ARGUMENTS,"1")) { ARGUMENTS = reduceStructLevel(ARGUMENTS[1]); }
		return super.setValuesInObject(this.getEvent(ARGUMENTS),ARGUMENTS);
	}


	public models.event function editEventAndSave() {
		if ((structCount(ARGUMENTS) == 1) && structKeyExists(ARGUMENTS,"1")) { ARGUMENTS = reduceStructLevel(ARGUMENTS[1]); }
		return super.saveObject(this.editEvent(ARGUMENTS));
	}


	public models.event function removeEvent() {
		if ((structCount(ARGUMENTS) == 1) && structKeyExists(ARGUMENTS,"1")) { ARGUMENTS = reduceStructLevel(ARGUMENTS[1]); }
		return super.removeObject(this.getEvent(ARGUMENTS));
	}


	public models.event function addVenueToEvent() {
		if ((structCount(ARGUMENTS) == 1) && structKeyExists(ARGUMENTS,"1")) { ARGUMENTS = reduceStructLevel(ARGUMENTS[1]); }
		var _event = this.getEvent(ARGUMENTS);

		var _venueService = new services.venueService();
		var _venue = _venueService.getVenue(ARGUMENTS);

		if (!_event.hasVenue(_venue)) {
			_event.setVenue(_venue);
		}

		return _event;
	}


	public models.event function addVenueToEventAndSave() {
		if ((structCount(ARGUMENTS) == 1) && structKeyExists(ARGUMENTS,"1")) { ARGUMENTS = reduceStructLevel(ARGUMENTS[1]); }
		return super.saveObject(this.addVenueToEvent(ARGUMENTS));
	}


	public models.event function removeVenueFromEvent() {
		if ((structCount(ARGUMENTS) == 1) && structKeyExists(ARGUMENTS,"1")) { ARGUMENTS = reduceStructLevel(ARGUMENTS[1]); }
		var _event = this.getEvent(ARGUMENTS);
		var _venueService = new services.venueService();
		var _venue = _venueService.getVenue(ARGUMENTS);
		return super.saveObject(_event.removeVenue(_venue));
	}
}