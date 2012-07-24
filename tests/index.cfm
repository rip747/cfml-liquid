<html>
<head>
	<title>RocketUnit unit tests</title>
</head>
<body>

<cfset StructClear(application)>
<cfset application.liquid = createObject("component", "cfml-liquid.lib.Liquid").init()>

<cfif !structkeyexists(url, "single")>

 	<cfset test = createObject("component", "Test")>
	<cfset test.runTestPackage("cfml-liquid.tests.tests")>

<cfelse>

	<cfset test = createObject("component", "cfml-liquid.tests.tests.ParsingErrors")>
	<cfset test.runTest("test", "test_specifying_filter_without_supplying_required_arguments")>

</cfif>

<cfoutput>#test.HTMLFormatTestResults()#</cfoutput>
</body>
</html>