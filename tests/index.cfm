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

	<cfset test = createObject("component", "cfml-liquid.tests.tests.RawTest")>
	<cfset test.runTest("test", "test_output_in_raw")>

</cfif>

<cfoutput>#test.HTMLFormatTestResults()#</cfoutput>
</body>
</html>