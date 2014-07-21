/**
*
* @file  /C/inetpub/wwwroot/finealley/FineAlleyWebsite2/services/carouselSlideService.cfc
* @author  
* @description
*
*/

component output="false" displayname="carouselSlideService" extends="baseService" {

	public function init(){
		return super.init();
	}


	public models.carouselSlide function getCarouselSlide() {
		if ((structCount(ARGUMENTS) == 1) && structKeyExists(ARGUMENTS,"1")) { ARGUMENTS = reduceStructLevel(ARGUMENTS[1]); }
		var _carouselSlide = javaCast("null","");

		if (structKeyExists(ARGUMENTS,"carouselSlideId")) {
			_carouselSlide = ORMExecuteQuery("SELECT DISTINCT s FROM carouselSlide s WHERE s.id=:id",{id=ARGUMENTS.carouselSlideId},true);
		} else if (structKeyExists(ARGUMENTS,"id")) {
			_carouselSlide = ORMExecuteQuery("SELECT DISTINCT s FROM carouselSlide s WHERE s.id=:id",{id=ARGUMENTS.id},true);
		}

		if (isNull(_carouselSlide)) { _carouselSlide = entityNew("carouselSlide"); }
		return _carouselSlide;
	}


	public array function getCarouselSlides() {
		if ((structCount(ARGUMENTS) == 1) && structKeyExists(ARGUMENTS,"1")) { ARGUMENTS = reduceStructLevel(ARGUMENTS[1]); }

		if (structKeyExists(ARGUMENTS,"allSlides") && isBoolean(ARGUMENTS.allSlides) && ARGUMENTS.allSlides) {
			return ORMExecuteQuery("SELECT DISTINCT s FROM carouselSlide s WHERE s.isDeleted=:isDeleted ORDER BY s.startDate ASC",{isDeleted=false},false);
		} else {
			return ORMExecuteQuery("SELECT DISTINCT s FROM carouselSlide s WHERE s.startDate <= :now AND s.endDate >= :now  AND s.isDeleted=:isDeleted ORDER BY s.startDate ASC",{isDeleted=false,now=now()},false);
		}
	}


	public models.carouselSlide function editCarouselSlide() {
		if ((structCount(ARGUMENTS) == 1) && structKeyExists(ARGUMENTS,"1")) { ARGUMENTS = reduceStructLevel(ARGUMENTS[1]); }
		return super.setValuesInObject(this.getcarouselSlide(ARGUMENTS),ARGUMENTS);
	}


	public models.carouselSlide function editCarouselSlideAndSave() {
		if ((structCount(ARGUMENTS) == 1) && structKeyExists(ARGUMENTS,"1")) { ARGUMENTS = reduceStructLevel(ARGUMENTS[1]); }
		return super.saveObject(this.editcarouselSlide(ARGUMENTS));
	}


	public models.carouselSlide function removeCarouselSlide() {
		if ((structCount(ARGUMENTS) == 1) && structKeyExists(ARGUMENTS,"1")) { ARGUMENTS = reduceStructLevel(ARGUMENTS[1]); }
		return super.removeObject(this.getcarouselSlide(ARGUMENTS));
	}
}