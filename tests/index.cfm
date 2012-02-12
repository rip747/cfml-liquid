<html>
<head>
	<title>RocketUnit unit tests</title>
</head>
<body>

<cfif !structkeyexists(url, "single")>

 	<cfset test = createObject("component", "Test")>
	<cfset test.runTestPackage("cfml-liquid.tests.tests")>

<cfelse>

	<cfset test = createObject("component", "cfml-liquid.tests.tests.BlockTest")>
	<cfset test.runTest("test", "TEST_VARIABLE_BEGINNING")>

</cfif>

	<cfoutput>#test.HTMLFormatTestResults()#</cfoutput>
</body>
</html>