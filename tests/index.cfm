<html>
<head>
	<title>RocketUnit unit tests</title>
</head>
<body>

<cfif !structkeyexists(url, "single")>

 	<cfset test = createObject("component", "Test")>
	<cfset test.runTestPackage("cfml-liquid.tests.tests")>

<cfelse>

	<cfset test = createObject("component", "cfml-liquid.tests.tests.FilterbankTest")>
	<cfset test.runTest("test", "TEST_FUNCTION_FILTER")>

</cfif>

	<cfoutput>#test.HTMLFormatTestResults()#</cfoutput>
</body>
</html>