<html>
<head>
	<title>RocketUnit unit tests</title>
</head>
<body>
<!--- 

 	<cfset test = createObject("component", "Test")>
	<cfset test.runTestPackage("cfml-liquid.tests.tests")>
 --->

<cfset test = createObject("component", "cfml-liquid.tests.tests.StatementsTest")>
<cfset test.runTest("test", "TEST_TRUE_NOT_EQL_TRUE")>


	<cfoutput>#test.HTMLFormatTestResults()#</cfoutput>
</body>
</html>