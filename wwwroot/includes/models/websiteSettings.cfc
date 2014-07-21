/**
*
* @file  /C/inetpub/wwwroot/finealley/FineAlleyWebsite2/models/websiteSettings.cfc
* @author  Christopher Vachon
* @description  holds all the settings for the website
*
*/

component output="false" displayname="websiteSettings" extends="base" persistent="true" table="websiteSettings" {

	property name="domain" type="string" setter="false";
	property name="siteName" type="string";
	property name="description" type="string";

	// Facebook Connection
	property name="FB_appID" type="string";
	property name="FB_appSecret" type="string";
	property name="FB_pageID" type="string";


	// Twitter Connection
	property name="TW_ConsumerKey" type="string";
	property name="TW_ConsumerSecret" type="string";
	property name="TW_AccessToken" type="string";
	property name="TW_AccessTokenSecret" type="string";
	property name="TW_UserName" type="string";


	// OPENGRAPH
	property name="openGraphTags" fieldtype="collection" type="struct" table="websiteSettings_ogTags" fkcolumn="fk_WebsiteSettingsID" structkeycolumn="OGKey" structkeytype="string" elementColumn="OGValue" elementtype="string" lazy="false";

	// Google
	property name="Google_gaCode" type="string";
	property name="Google_APICode" type="string";

	// Mail Settings
	property name="Mail_SMTPServer" type="string";
	property name="Mail_Port" type="string";
	property name="Mail_Username" type="string";
	property name="Mail_Password" type="string";
	property name="Mail_UseSSL" type="boolean";

	property name="Mail_FromName" type="string";
	property name="Mail_FromEmailAddress" type="string";
	property name="Mail_SendToEmailAddress" type="string";

	public function init(){
		this.refreshProperties();
		return super.init();
	}

	public void function refreshProperties() {
		super.refreshProperties();
		if (!structKeyExists(VARIABLES,"domain")) { VARIABLES["domain"] = CGI.SERVER_NAME; }
		if (!structKeyExists(VARIABLES,"siteName")) { VARIABLES["siteName"] = "New Band Site"; }
		if (!structKeyExists(VARIABLES,"description")) { VARIABLES["description"] = "This is a New Band Site"; }

		// Facebook
		if (!structKeyExists(VARIABLES,"FB_appID")) { VARIABLES["FB_appID"] = javaCast("null",""); }
		if (!structKeyExists(VARIABLES,"FB_appSecret")) { VARIABLES["FB_appSecret"] = javaCast("null",""); }
		if (!structKeyExists(VARIABLES,"FB_pageID")) { VARIABLES["FB_pageID"] = javaCast("null",""); }

		// Twitter
		if (!structKeyExists(VARIABLES,"TW_ConsumerKey")) { VARIABLES["TW_ConsumerKey"] = javaCast("null",""); }
		if (!structKeyExists(VARIABLES,"TW_ConsumerSecret")) { VARIABLES["TW_ConsumerSecret"] = javaCast("null",""); }
		if (!structKeyExists(VARIABLES,"TW_AccessToken")) { VARIABLES["TW_AccessToken"] = javaCast("null",""); }
		if (!structKeyExists(VARIABLES,"TW_AccessTokenSecret")) { VARIABLES["TW_AccessTokenSecret"] = javaCast("null",""); }
		if (!structKeyExists(VARIABLES,"TW_UserName")) { VARIABLES["TW_UserName"] = javaCast("null",""); }

		// openGraph
		if (!structKeyExists(VARIABLES,"openGraphTags")) { VARIABLES["openGraphTags"] = {}; }

		// Google
		if (!structKeyExists(VARIABLES,"Google_gaCode")) { VARIABLES["Google_gaCode"] = javaCast("null",""); }
		if (!structKeyExists(VARIABLES,"Google_APICode")) { VARIABLES["Google_APICode"] = javaCast("null",""); }

		// Mail
		if (!structKeyExists(VARIABLES,"Mail_SMTPServer")) { VARIABLES["Mail_SMTPServer"] = javaCast("null",""); }
		if (!structKeyExists(VARIABLES,"Mail_Port")) { VARIABLES["Mail_Port"] = javaCast("null",""); }
		if (!structKeyExists(VARIABLES,"Mail_Username")) { VARIABLES["Mail_Username"] = javaCast("null",""); }
		if (!structKeyExists(VARIABLES,"Mail_Password")) { VARIABLES["Mail_Password"] = javaCast("null",""); }
		if (!structKeyExists(VARIABLES,"Mail_UseSSL")) { VARIABLES["Mail_UseSSL"] = false; }

		if (!structKeyExists(VARIABLES,"Mail_FromName")) { VARIABLES["Mail_FromName"] = javaCast("null",""); }
		if (!structKeyExists(VARIABLES,"Mail_FromEmailAddress")) { VARIABLES["Mail_FromEmailAddress"] = javaCast("null",""); }
		if (!structKeyExists(VARIABLES,"Mail_SendToEmailAddress")) { VARIABLES["Mail_SendToEmailAddress"] = javaCast("null",""); }
	}


	public boolean function hasAllFacebookInfo() {
		if (!isNull(this.getFB_appID()) && (len(this.getFB_appID()) > 0)) {
			if (!isNull(this.getFB_appSecret()) && (len(this.getFB_appSecret()) > 0)) {
				if (!isNull(this.getFB_pageID()) && (len(this.getFB_pageID()) > 0)) {
					return true;
				}
			}
		}
		return false;
	}
}