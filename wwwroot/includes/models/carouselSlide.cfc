/**
*
* @file  /C/inetpub/wwwroot/finealley/FineAlleyWebsite2/models/carouselSlide.cfc
* @author  
* @description
*
*/

component extends="base" displayname="carouselSlide" persistent="true" table="carouselSlides" {

	property name="title" type="string";
	property name="slideContents" type="string" length="1500";
	property name="caption" type="string" length="1000";

	property name="startDate" type="string" ormtype="timestamp";
	property name="endDate" type="string" ormtype="timestamp";

	public function init(){
		return super.init();
	}


	public void function refreshProperties() {
		super.refreshProperties();
		if (!structKeyExists(VARIABLES,'title')) { VARIABLES.title = javacast("null",""); }
		if (!structKeyExists(VARIABLES,'slideContents')) { VARIABLES.slideContents = javacast("null",""); }
		if (!structKeyExists(VARIABLES,'caption')) { VARIABLES.caption = javacast("null",""); }
		
		if (!structKeyExists(VARIABLES,'startDate')) { VARIABLES.startDate = now(); }
		if (!structKeyExists(VARIABLES,'endDate')) { VARIABLES.endDate = dateAdd("m", 1, now()); }
	}
}