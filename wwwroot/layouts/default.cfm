<cfscript>
	param name="body" default="Body Not Found!";
</cfscript>
<cfcontent reset="true" /><cfoutput><!doctype html>
<html>
<head>
	<title>Test Site</title>
</head>
<body>
	<section>#body#</section>
</body>
</html>
</cfoutput>
