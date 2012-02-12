<!---
	Base component for rapidly writing/running test cases.

	Terminology
	-----------
	-	A Test Package is a collection of Test Cases that tests the functionality
		of an application/service/whatever.

	-	A Test Case is a collection of Tests to apply to a particular CF component,
		tag or include file.

	- 	A Test is a sequence of calls to the code being tested and Assertions about
		the results we get from the code.

	-	An Assertion is a statement we make about the results we get that should
		evaluate to true if the tested code is working properly.

	How are these things represented in test code using this file?
	--------------------------------------------------------------
	-	A Test Package is a directory that can be referred to by a CF mapping, and
		ideally outside the web root for security.

	-	A Test Case is a CF component in that directory that has this file included
		in itself or a component it extends.  The include should be inside the
		<cfcomponent> tag and outside any <cffunction> tags.

	-	A Test is a method in one of these components.  The method name should start with
		the word "test", it should require no arguments and return void.  Any setup or
		clearup code common to all test functions can be added to optional setup() and
		teardown() methods, which again take no arguments and return void.

		Tests in each Test Case are run in alphabetical order.  If you want your tests
		to run in a particular order you could name them test01xxx, test02yyy, etc.

	-	An Assertion is a call to the assert() method (mixed in by this file) inside
		a test method.  assert() takes a string argument, an expression (see ColdFusion
		evaluate() documentation) that evaluates to true or false.  If false, a "failure"
		is recorded for the test case and the test case fails.  assert() tries to include
		the value of any variables it finds in the expression.

		If there are specific variable values you would like included in the failure message,
		pass them as additional string arguments to assert().  Multiple variables can be
		listed in a single space-delimited string if this is convenient.

		For more complicated assertions you may call the fail() method directly, which takes
		a single message string as an argument.

	-	If an uncaught exception is thrown an "error" is recorded for the Test Case and the
		Test Case fails.

	Running tests
	-------------
	This file can be included in any ColdFusion code, not just components.  To run
	a Test Package include this file and call run(), passing the Test Package name in dot
	format, e.g. run("com.rocketboots.myapp.test").  If you want to run a specific Test Case,
	create an instance of the Test Case component and call its run() method without any
	arguments.

	The test results are available in the request.test structure.  If you would like to
	use a different key in request (as we do for the rocketunit self-tests) for the results
	you can pass the key name as a second argument to the run method.  If you would like
	a formatted HTML string of the test results call HTMLFormatTestResults().  You can call
	run() multiple times and the test results will be combined.  If you wish to reset the test
	results before calling run() again, call resetTestResults().


	(c) 2008 RocketBoots Pty Ltd
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.
	
	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
	
	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.

	@version $Id$
--->

<cfcomponent>
	
	<cfinclude template="helpers.cfm">
	
	<!--- used to determine if the component is expending us --->
	<cfset this.ROCKETUNIT_TEST_COMPONENT = true>
	
	<!--- used to hold debug information for display --->
	<cfif !StructKeyExists(request, "TESTING_FRAMEWORK_DEBUGGING")>
		<cfset request["TESTING_FRAMEWORK_DEBUGGING"] = {}>
	</cfif>
	
	<!---
		Instanciate all components in specified package and call their runTest()
		method.
		
		@param testPackage	Package containing test components
		@param resultKey	Key to store distinct test result sets under in
							request scope, defaults to "test"
		@returns			true if no failures or errors detected.
	--->
	<cffunction returntype="boolean" name="runTestPackage" output="false">
		<cfargument name="testPackage" type="string" required="true">
		<cfargument name="resultKey" type="string" required="false" default="test">
	
		<cfset var packageDir = "">
		<cfset var qPackage = "">
		<cfset var instance = "">
		<cfset var result = 0>
		
		<!--
			Called with a testPackage argument.  List package directory contents, instanciate
			any components we find and call their run() method.
		--->
		<cfset packageDir = "/" & replace(testpackage, ".", "/", "ALL")>
		<cfdirectory action="list"  directory="#expandPath(packageDir)#" name="qPackage">
	
		<cfloop query="qPackage">
			<cfif listLast(qPackage.name, ".") eq "cfc">
				<cfset instance = createObject("component", testPackage & "." & listFirst(qPackage.name, "."))>
				<cfif StructKeyExists(instance, "ROCKETUNIT_TEST_COMPONENT")>
					<cfset result = result + instance.runTest(resultKey)>
				</cfif>
			</cfif>
		</cfloop>
		
		<cfreturn result eq 0>
		
	</cffunction>
	
	
	
	<!---
		Run all the tests in a component.
	
		@param resultKey	Key to store distinct test result sets under in
							request scope, defaults to "test"
		@returns true if no errors
	--->
	<cffunction name="runTest" returntype="boolean" output="true">
		<cfargument name="resultKey" type="string" required="false" default="test">
		<cfargument name="testname" type="string" required="false" default="">
	
		<cfset var key = "">
		<cfset var keyList = "">
		<cfset var time = "">
		<cfset var testCase = "">
		<cfset var status = "">
		<cfset var result = "">
		<cfset var message = "">
		<cfset var numTests = 0>
		<cfset var numTestFailures = 0>
		<cfset var numTestErrors = 0>
		<cfset var newline = chr(10) & chr(13)>
	
		<!---
			Check for and if necessary set up the structure to store test results
		--->
		<cfif !StructKeyExists(request, resultKey)>
			<cfset resetTestResults(resultKey)>
		</cfif>
	
		<cfset testCase = getMetadata(this).name>
	
		<!---
			Iterate through the members of the this scope in alphabetical order,
			invoking methods starting in "test".  Wrap with calls to setup()
			and teardown() if provided.
		--->
		<cfset keyList = listSort(structKeyList(this), "textnocase", "asc")>
	
		<cfloop list="#keyList#" index="key">
		
			<!--- keep track of the test name so we can display debug information --->
			<cfset TESTING_FRAMEWORK_VARS.RUNNING_TEST = key>
	
			<cfif (left(key, 4) eq "test" and isCustomFunction(this[key])) and (!len(arguments.testname) or (len(arguments.testname) and arguments.testname eq key))>
	
				<cfset time = getTickCount()>
	
				<cfif structKeyExists(this, "setup")>
					<cfset setup()>
				</cfif>
	
				<cftry>
	
					<cfset message = "">
					<cfinvoke method="#key#">
					<cfset status = "Success">
					<cfset request[resultkey].numSuccesses = request[resultkey].numSuccesses + 1>
	
				<cfcatch type="any">
	
					<cfset message = cfcatch.message>

					<cfif cfcatch.ErrorCode eq "__FAIL__">
	
						<!---
							fail() throws __FAIL__ exception
						--->
						<cfset status = "Failure">
						<cfset request[resultkey].ok = false>
						<cfset request[resultkey].numFailures = request[resultkey].numFailures + 1>
						<cfset numTestFailures = numTestFailures + 1>
	
					<cfelse>
	
						<!---
							another exception thrown
						--->
						<cfset status = "Error">
						<cfset message = message & newline & listLast(cfcatch.tagContext[1].template, "/") & " line " & cfcatch.tagContext[1].line  & newline & newline & cfcatch.detail>
						<cfset request[resultkey].ok = false>
						<cfset request[resultkey].numErrors = request[resultkey].numErrors + 1>
						<cfset numTestErrors = numTestErrors + 1>
	
					</cfif>
	
				</cfcatch>
				</cftry>
	
				<cfif structKeyExists(this, "teardown")>
					<cfset teardown()>
				</cfif>
	
				<cfset time = getTickCount() - time>
	
				<!---
					Record test results
				--->
				<cfset result = structNew()>
				<cfset result.testCase = testCase>
				<cfset result.testName = key>
				<cfset result.time = time>
				<cfset result.status = status>
				<cfset result.message = message>
				<cfset arrayAppend(request[resultkey].results, result)>
	
				<cfset request[resultkey].numTests = request[resultkey].numTests + 1>
				<cfset numTests = numTests + 1>
	
			</cfif>
	
		</cfloop>
	
		<cfset result = structNew()>
		<cfset result.testCase = testCase>
		<cfset result.numTests = numTests>
		<cfset result.numFailures = numTestFailures>
		<cfset result.numErrors = numTestErrors>
		<cfset arrayAppend(request[resultkey].summary, result)>
	
		<cfset request[resultkey].numCases = request[resultkey].numCases + 1>
		<cfset request[resultkey]["end"] = now()>
	
		<cfreturn numTestErrors eq 0>
	
	</cffunction>
	
	
	
	
	<!---
		Called from a test function to cause the test to fail.
	
		@param message	Message to record in test results against failure.
	--->
	<cffunction name="fail" returntype="void" hint="will throw an exception resulting in a test failure along with an option message.">
		<cfargument type="string" name="message" required="false" default="">
	
		<!---
			run() interprets exception with this errorcode as a "Failure".
			All other errorcodes cause are interpreted as an "Error".
		--->
		<cfthrow errorcode="__FAIL__" message="#HTMLEditFormat(message)#">
	
	</cffunction>
	
	
	
	
	<!---
		Called from a test function.  If expression evaluates to false,
		record a failure against the test.
	
		@param	expression	String containing CFML expression to evaluate
		@param	2..n			Optional. String(s) containing space-delimited list
							of variables to evaluate and include in the
							failure message to help determine cause of failed
							assertion.
	--->
	<cffunction returntype="void" name="assert" output="false">
		<cfargument type="string" name="expression" required=true>
	
		<cfset var token = "">
		<cfset var tokenValue = "">
		<cfset var message = "assert failed: #expression#">
		<cfset var newline = chr(10) & chr(13)>
		<cfset var i = "">
		<cfset var evaluatedTokens = "">
	
		<cfif not evaluate(expression)>
	
			<cfloop from="1" to="#arrayLen(arguments)#" index="i">
	
				<cfset expression = arguments[i]>
				<cfset evaluatedTokens = structNew()>
	
				<!---
					Double pass of expressions with different delimiters so that for expression "a(b) or c[d]",
					"a(b)", "c[d]", "b" and "d" are evaluated.  Do not evaluate any expression more than once.
				--->
				<cfloop list="#expression# #reReplace(expression, "[([\])]", " ")#" delimiters=" +=-*/%##" index="token">
	
					<cfif not structKeyExists(evaluatedTokens, token)>
	
						<cfset evaluatedTokens[token] = true>
						<cfset tokenValue = "__INVALID__">
	
						<cfif not (isNumeric(token) or isBoolean(token))>
	
							<cftry>
								<cfset tokenValue = evaluate(token)>
							<cfcatch type="expression"/>
							</cftry>
	
						</cfif>
	
						<!---
							Format token value according to type
						--->
						<cfif (not isSimpleValue(tokenValue)) or (tokenValue neq "__INVALID__")>
	
							<cfif isSimpleValue(tokenValue)>
								<cfif not (isNumeric(tokenValue) or isBoolean(tokenValue))>
									<cfset tokenValue ="'#tokenValue#'">
								</cfif>
							<cfelse>
								<cfif isArray(tokenValue)>
									<cfset tokenValue = "array of #arrayLen(tokenValue)# items">
								<cfelseif isStruct(tokenValue)>
									<cfset tokenValue = "struct with #structCount(tokenValue)# members">
								<cfelseif IsCustomFunction(tokenValue)>
									<cfset tokenValue = "UDF">
								</cfif>
							</cfif>
	
							<cfset message = message & newline & token & " = " & tokenValue>
	
						</cfif>
	
					</cfif>
	
				</cfloop>
	
			</cfloop>
	
			<cfset fail(message)>
	
		</cfif>

	</cffunction>
	
	
	
	<cffunction name="debug" returntype="Any" output="false" hint="used to examine an expression. any overloaded arguments get passed to cfdump's attributeCollection">
		<cfargument name="expression" type="string" required="true" hint="the expression to examine.">
		<cfargument name="display" type="boolean" required="false" default="true" hint="whether to display the debug call. false returns without outputting anything into the buffer. good when you want to leave the debug command in the test for later purposes, but don't want it to display">
		<cfset var attributeArgs = {}>
		<cfset var dump = "">
		
		<cfif !arguments.display>
			<cfreturn>
		</cfif>

		<cfset attributeArgs["var"] = "#evaluate(arguments.expression)#">
		
		<cfset structdelete(arguments, "expression")>
		<cfset structdelete(arguments, "display")>
		<cfset structappend(attributeArgs, arguments, true)>

		<cfsavecontent variable="dump">
		<cfdump attributeCollection="#attributeArgs#">
		</cfsavecontent>
		
		<cfif !StructKeyExists(request["TESTING_FRAMEWORK_DEBUGGING"], TESTING_FRAMEWORK_VARS.RUNNING_TEST)>
			<cfset request["TESTING_FRAMEWORK_DEBUGGING"][TESTING_FRAMEWORK_VARS.RUNNING_TEST] = []>
		</cfif>
		<cfset arrayAppend(request["TESTING_FRAMEWORK_DEBUGGING"][TESTING_FRAMEWORK_VARS.RUNNING_TEST], dump)>
	</cffunction>



	<cffunction name="raised" returntype="any" output="false" hint="catches an raised error and returns the error type. great if you want to test that a certain exception will be raised.">
		<cfargument type="string" name="expression" required="true">
		<cftry>
			<cfset evaluate(arguments.expression)>
			<cfcatch type="any">
				<cfreturn "#cfcatch#">
			</cfcatch>
		</cftry>
		<cfreturn StructNew()>
	</cffunction>
	
	
	
	<!---
		Called from a test function to compare strings that might differ in
		minor ways that may be hard to spot. Fails test with a message
		containing a table of character index comparisons
	
		@param	string1	
		@param	string2
	--->
	<cffunction returntype="void" name="stringsEqual" output="false">
		<cfargument type="string" name="string1" required=true>
		<cfargument type="string" name="string2" required=true>
		
		<cfset var output = "<table>">
		<cfset var i = 0>
		<cfset var c1 = 0>
		<cfset var c2 = 0>
		<cfset var bFail = false>
		<cfset var maxLen = max(len(string1), len(string2))>
		
		<cfloop from="1" to="#maxLen#" index="i">
			
			<cfset c1 = 0>
			<cfset c2 = 0>
			
			<cfif i le len(string1)>
				<cfset c1 = asc(mid(string1, i, 1))>
			</cfif>
			
			<cfif i le len(string2)>
				<cfset c2 = asc(mid(string2, i, 1))>
			</cfif>
			
			<cfif c1 neq c2>
				<cfset bFail = true>
				<cfset output = output & "<tr><td><b>#chr(c1)#</b></td><td><b>#c1#</b></td><td><b>#chr(c2)#</b></td><td><b>#c2#</b></td></tr>">
				<cfbreak>
			<cfelse>
				<cfset output = output & "<tr><td>#chr(c1)#</td><td>#c1#</td><td>#chr(c2)#</td><td>#c2#</td></tr>">	
			</cfif>
			
		</cfloop>
		
		<cfif bFail>
			<cfset fail(output & "</table>")>
		</cfif>
		
	</cffunction>
		
		
		
	<!---
		Clear results.
		
		@param resultKey	Key to store distinct test result sets under in
							request scope, defaults to "test"
	--->
	<cffunction name="resetTestResults" returntype="void" output="false">
		<cfargument name="resultKey" type="string" required="false" default="test">
		<cfscript>
		request[resultkey] = {};
		request[resultkey].begin = now();
		request[resultkey].ok = true;
		request[resultkey].numCases = 0;
		request[resultkey].numTests = 0;
		request[resultkey].numSuccesses = 0;
		request[resultkey].numFailures = 0;
		request[resultkey].numErrors = 0;
		request[resultkey].summary = [];
		request[resultkey].results = [];
		</cfscript>
	</cffunction>
	
	
	
	
	<!---
		Report test results at overall, test case and test level, highlighting
		failures and errors.
		
		@param resultKey	Key to retrive distinct test result sets from in
							request scope, defaults to "test"
		@returns			HTML formatted test results
	--->
	<cffunction returntype="string" name="HTMLFormatTestResults" output="false">
		<cfargument name="resultKey" type="string" required="false" default="test">
		<cfargument name="showPassedTests" type="boolean" required="false" default="true">
	
		<cfset var testIndex = "">
		<cfset var newline = chr(10) & chr(13)>

		<cfsavecontent variable="result">
		<cfoutput>
		<table cellpadding="5" cellspacing="0">
			<cfif not request[resultkey].ok>
				<tr><th align="left"><span style="color:red;font-weight:bold">Status</span></th><td><span style="color:red;font-weight:bold">Failed</span></td></tr>
			<cfelse>
				<tr><th align="left">Status</th><td>Passed</td></tr>
			</cfif>
			<tr><th align="left">Date</th><td>#dateFormat(request[resultkey].end)#</td></tr>
			<tr><th align="left">Begin</th><td>#timeFormat(request[resultkey].begin, "HH:mm:ss L")#</td></tr>
			<tr><th align="left">End</th><td>#timeFormat(request[resultkey].end, "HH:mm:ss L")#</td></tr>
			<tr><th align="left">Cases</th><td align="right">#request[resultkey].numCases#</td></tr>
			<tr><th align="left">Tests</th><td align="right">#request[resultkey].numTests#</td></tr>
			<cfif request[resultkey].numFailures neq 0>
				<tr><th align="left"><span style="color:red;font-weight:bold">Failures</span></th>
				<td align="right"><span style="color:red;font-weight:bold">#request[resultkey].numFailures#</span></td></tr>
			<cfelse>
				<tr><th align="left">Failures</th><td align="right">#request[resultkey].numFailures#</td></tr>
			</cfif>
			<cfif request[resultkey].numErrors neq 0>
				<tr><th align="left"><span style="color:red;font-weight:bold">Errors</span></th>
				<td align="right"><span style="color:red;font-weight:bold">#request[resultkey].numErrors#</span></td></tr>
			<cfelse>
				<tr><th align="left">Errors</th><td align="right">#request[resultkey].numErrors#</td></tr>
			</cfif>
		</table>
		<br>
		<table border="0" cellpadding="5" cellspacing="0">
		<tr align="left"><th>Test Case</th><th>Tests</th><th>Failures</th><th>Errors</th></tr>
		<cfloop from="1" to=#arrayLen(request[resultkey].summary)# index="testIndex">
			<tr valign="top">
			<td>#request[resultkey].summary[testIndex].testCase#</td>
			<td align="right">#request[resultkey].summary[testIndex].numTests#</td> 
			<cfif request[resultkey].summary[testIndex].numFailures neq 0>
				<td align="right"><span style="color:red;font-weight:bold">#request[resultkey].summary[testIndex].numFailures#</span></td>
			<cfelse>
				<td align="right">#request[resultkey].summary[testIndex].numFailures#</td>
			</cfif>
			<cfif request[resultkey].summary[testIndex].numErrors neq 0>
				<td align="right"><span style="color:red;font-weight:bold">#request[resultkey].summary[testIndex].numErrors#</span></td>
			<cfelse>
				<td align="right">#request[resultkey].summary[testIndex].numErrors#</td>
			</cfif>
			</tr>
		</cfloop>
		</table>
		<br>
		<table border="0" cellpadding="5" cellspacing="0">
		<tr align="left"><th>Test Case</th><th>Test Name</th><th>Time</th><th>Status</th><th>Message</th></tr>
		<cfloop from="1" to=#arrayLen(request[resultkey].results)# index="testIndex">
			<cfif arguments.showPassedTests>
				<tr valign="top">
				<td>#request[resultkey].results[testIndex].testCase#</td>
				<td>#request[resultkey].results[testIndex].testName#</td>
				<td align="right">#request[resultkey].results[testIndex].time#</td>
				<cfif request[resultkey].results[testIndex].status neq "Success">
					<td><span style="color:red;font-weight:bold">#request[resultkey].results[testIndex].status#</span></td>
					<td><span style="color:red;font-weight:bold">#replace(request[resultkey].results[testIndex].message, newline, "<br>", "ALL")#</span></td>
				<cfelse>
					<td>#request[resultkey].results[testIndex].status#</td>
					<td>#request[resultkey].results[testIndex].message#</td>
				</cfif>
				</tr>
			<cfelseif request[resultkey].results[testIndex].status neq "Success">
				<tr valign="top">
				<td>#request[resultkey].results[testIndex].testCase#</td>
				<td>#request[resultkey].results[testIndex].testName#</td>
				<td align="right">#request[resultkey].results[testIndex].time#</td>
				<td><span style="color:red;font-weight:bold">#request[resultkey].results[testIndex].status#</span></td>
				<td><span style="color:red;font-weight:bold">#request[resultkey].results[testIndex].message#</span></td>
				</tr>
			</cfif>
			<cfif StructKeyExists(request, "TESTING_FRAMEWORK_DEBUGGING") && StructKeyExists(request["TESTING_FRAMEWORK_DEBUGGING"], request[resultkey].results[testIndex].testName)>
				<cfloop array="#request['TESTING_FRAMEWORK_DEBUGGING'][request[resultkey].results[testIndex].testName]#" index="i">
				<tr class="<cfif request[resultkey].results[testIndex].status neq 'Success'>errRow<cfelse>sRow</cfif>"><td colspan="5">#i#</tr>
				</cfloop>
			</cfif>
		</cfloop>
		</table>
		</cfoutput>
		</cfsavecontent>
	
		<cfreturn REReplace(result, "[	 " & newline & "]{2,}", newline, "ALL")>
	
	</cffunction>
	
</cfcomponent>