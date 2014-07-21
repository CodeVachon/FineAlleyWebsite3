/**
*
* @file  /C/inetpub/wwwroot/finealley/FineAlleyWebsite2/services/mailService.cfc
* @author  Christopher Vachon	
* @description	Used for sending emails
*
*/

component output="false" displayname="mailService" extends="baseService" {

	public array function getMailHistory() {
		return ORMExecuteQuery("FROM mail WHERE isDeleted=0 ORDER BY dateTime DESC",{},false);
	}


	public void function sendEmail() {
		if ((structCount(ARGUMENTS) == 1) && structKeyExists(ARGUMENTS,"1")) { ARGUMENTS = reduceStructLevel(ARGUMENTS[1]); }
		var mail = new mail();
		mail.setSubject((structKeyExists(ARGUMENTS,"subject"))?ARGUMENTS.subject:"Unknown Subject");
		mail.setTo((structKeyExists(ARGUMENTS,"toAddress"))?ARGUMENTS.toAddress:"Unknown Address");

		mail.setType("HTML");

		if (structKeyExists(ARGUMENTS,"SMTPServer")) { mail.setServer(ARGUMENTS["SMTPServer"]); }
		if (structKeyExists(ARGUMENTS,"SMTPPort")) { mail.setPort(ARGUMENTS["SMTPPort"]); }
		if (structKeyExists(ARGUMENTS,"SMTPUsername")) { mail.setUsername(ARGUMENTS["SMTPUsername"]); }
		if (structKeyExists(ARGUMENTS,"SMTPPassword")) { mail.setPassword(ARGUMENTS["SMTPPassword"]); }
		if (structKeyExists(ARGUMENTS,"SMTPuseSSL")) { mail.setUseSSL(ARGUMENTS["SMTPuseSSL"]); }

		if (structKeyExists(ARGUMENTS,"SMTPFromName")) { mail.setFrom(ARGUMENTS["SMTPFromName"] & " <#((structKeyExists(ARGUMENTS,"SMTPFromEmailAddress"))?ARGUMENTS["SMTPFromEmailAddress"]:"no-reply@#lCase(CGI.SERVER_NAME)#")#>"); }
		if (structKeyExists(ARGUMENTS,"SMTPFromEmailAddress")) { mail.setReplyto(ARGUMENTS["SMTPFromEmailAddress"]); }

		if (structKeyExists(ARGUMENTS,"content")) { mail.setBody(ARGUMENTS["content"]); }  

		mail.setspoolenable(true);
		mail.setTimeout("300");
		mail.setuseTLS("false");

		var saveMailMessage = entityNew("mail");
		saveMailMessage.setSubject(mail.getSubject());
		saveMailMessage.setBody(mail.getBody());

		saveMailMessage.setFromName("#ARGUMENTS.firstName# #ARGUMENTS.lastName#");
		saveMailMessage.setFromEmailAddress(ARGUMENTS.emailAddress);
		saveMailMessage.setFromPhone(ARGUMENTS.phoneNumber);

		// We save the message to the database in the event of Mail Delivery Failure
		saveMailMessage = this.saveObject(saveMailMessage);

		try {
			mail.send();
		} catch (any e) {
			writeDump(e);
			abort;

			throw(message="Failed to Send Message");
		}
	}


	public struct function validateContactUsFormAndSend() {
		if ((structCount(ARGUMENTS) == 1) && structKeyExists(ARGUMENTS,"1")) { ARGUMENTS = reduceStructLevel(ARGUMENTS[1]); }
		var validationErrors = {};

		if (!structKeyExists(ARGUMENTS,"firstName") || (len(trim(ARGUMENTS.firstName)) == 0)) {
			validationErrors.firstName = "Please enter your First Name";
		}
		if (!structKeyExists(ARGUMENTS,"lastName") || (len(trim(ARGUMENTS.lastName)) == 0)) {
			validationErrors.lastName = "Please enter your Last Name";
		}
		if (!structKeyExists(ARGUMENTS,"emailAddress") || (len(trim(ARGUMENTS.emailAddress)) == 0)) {
			validationErrors.emailAddress = "Please enter an Email Address to contact you at";
		} else {
			if (len(reReplaceNoCase(ARGUMENTS.emailAddress,"^[a-z0-9._-]{3,}@[a-z0-9._-]{2,}\.[a-z]{2,5}$","","ONE")) > 0) {
				validationErrors.emailAddress = "Please enter a Valid Email Address to contact you at";
			}
		}

		if (!structKeyExists(ARGUMENTS,"subject") || (len(trim(ARGUMENTS.subject)) == 0)) {
			validationErrors.subject = "Please enter a Subject";
		}
		if (!structKeyExists(ARGUMENTS,"body") || (len(trim(reReplace(ARGUMENTS.body,"<[^>]+>","","all"))) == 0)) {
			validationErrors.body = "Please enter a Message";
		}

		if (structIsEmpty(validationErrors)) {
			if (!structKeyExists(ARGUMENTS,"phoneNumber") || (len(trim(ARGUMENTS.phoneNumber)) == 0)) {
				ARGUMENTS.phoneNumber = "Not Provided";
			}
			var ARGUMENTS.content = "
				<h1>Website Message</h1>
				<p>
					From: #ARGUMENTS.firstName# #ARGUMENTS.lastName# [<a href='mailto:#ARGUMENTS.emailAddress#'>#ARGUMENTS.emailAddress#</a>]<br/>
					Phone: #ARGUMENTS.phoneNumber#<br />
				</p>
				#ARGUMENTS.body#
			";
			this.sendEmail(ARGUMENTS);
		}

		return validationErrors;
	}
}