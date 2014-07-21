component extends="includes.fw1.framework" {
	this.name = 'FineAlleyWebsiteVr3.0';
	this.sessionManagement = true;
	this.sessionTimeout = CreateTimespan(0,0,20,0);


	this.datasource = "FineAlley";
	this.ormEnabled = true;
	this.ormSettings = {
		dbcreate = ((this.getEnvironment() == "dev")?"update":"none"),
		eventHandling = true,
		cfclocation = 'models',
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
		}
	}


	public string function onMissingView( struct RC ) {
		return view( 'main/error404' );
	}
}
