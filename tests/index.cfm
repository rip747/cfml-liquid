<cfapplication name="soemthing">
<html>
<head>
	<title>RocketUnit unit tests</title>
</head>
<body>
	<cfset test = createObject("component", "Test")>
	<cfset test.runTestPackage("cfml-liquid.tests.tests")>
	<!--- <cfset test = createObject("component", "cfml-liquid.tests.tests.VariableResolutionTest")>
	
	<cfset test.runTest("test", "test_array_scoping")>
	 --->
	<cfoutput>#test.HTMLFormatTestResults()#</cfoutput>
</body>
</html>