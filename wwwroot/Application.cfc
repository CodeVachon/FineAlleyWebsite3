component extends="includes.fw1.framework" {
	this.name = 'FineAlleyWebsiteVr3.0';
	this.sessionManagement = true;
	this.sessionTimeout = CreateTimespan(0,0,20,0);


	this.datasource = "FineAlley";
	this.ormEnabled = true;
	this.ormSettings = {
		dbcreate = ((this.getEnvironment() == "dev")?"update":"none"),
		eventHandling = true,
		cfclocation = 'includes/models',
		flushatrequestend = false,
		namingstrategy = "smart",
		dialect = "MySQL"
	};


	VARIABLES.framework = {
		defaultSection = 'main', defaultItem = 'default',
		error = 'main.error',
		generateSES = true,
		SESOmitIndex = true,
		applicationKey = 'frameworkOne',
		routes = [],
		environments = {
			dev = {
				reload = 'reload',
				password = 'true',
				reloadApplicationOnEveryRequest = true
			},
			live = {
				reload = 'arma-iterum',
				password = 'onere',
				reloadApplicationOnEveryRequest = false
			}
		}
	};


	public string function getEnvironment() {
		if (reFindNoCase("\.(local)$",CGI.SERVER_NAME) > 0) {
			return "dev";
		} else {
			return "live";
		}
	}


	public void function setupApplication() {}


	public void function setupRequest() {
		if (isFrameworkReloadRequest() || !structKeyExists(APPLICATION,"websiteSettings")) {
			ORMClearSession();
			ORMReload();

			try {
				var websiteSettingsService = new includes.services.websiteSettingsService();
				APPLICATION.websiteSettings = websiteSettingsService.editWebsiteSettingsAndSave({domain=CGI.SERVER_NAME});
			} catch (any e) {
				writeDump(e);abort;
			}
		}

		REQUEST.template = new includes.services.template();
		REQUEST.security = new includes.services.security();

		REQUEST.template.setSiteName(APPLICATION.websiteSettings.getSiteName());
		if (this.getEnvironment() == "dev") {
			REQUEST.template.addFile('/includes/js/jquery-1.11.1.min.js');
			REQUEST.template.addFile('/includes/js/bootstrap.min.js');
		} else {
			REQUEST.template.addFile('//code.jquery.com/jquery-1.11.1.min.js');
			REQUEST.template.addFile('//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js');
		}
		
		REQUEST.template.addFile('/favicon.ico');

		REQUEST.template.addMetaTag(name="viewport",content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no");

		REQUEST.template.addMetaTag(property="fb:app_id",content="272812729524274");
		REQUEST.template.addMetaTag(property="og:url",content="http://www.finealley.com#buildUrl(getSectionAndItem())#");
		REQUEST.template.addMetaTag(property="og:site_name",content="Fine Alley");
		REQUEST.template.addMetaTag(property="og:type",content="website");
		REQUEST.template.addMetaTag(property="og:locale",content="en_US");
		REQUEST.template.addMetaTag(property="og:image",content="http://www.finealley.com/includes/img/finealleySplash1500.jpg");
	}


	public string function onMissingView( struct RC ) {
		return view( 'main/error404' );
	}
}
