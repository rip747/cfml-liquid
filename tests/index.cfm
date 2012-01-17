<cfapplication name="soemthing">
<html>
<head>
	<title>RocketUnit unit tests</title>
</head>
<body>
	<cfset test = createObject("component", "Test")>
	<cfset test.runTestPackage("cfml-liquid.tests.tests")>
	<cfset test.runTestPackage("cfml-liquid.tests.tests.convert")>
	<cfoutput>#test.HTMLFormatTestResults()#</cfoutput>
</body>
</html>