<cfcomponent output="false" extends="cfml-liquid.tests.Test">
	
	<cffunction name="setup">
		<cfset loc.liquid = createObject("component", "cfml-liquid.lib.Liquid").init()>
	</cffunction>
	
	<cffunction name="create_instance">
		<cfargument name="value" type="string" required="true">
		<cfreturn createObject("component", "cfml-liquid.lib.liquid.LiquidVariable").init(
			arguments.value
		)>
	</cffunction>
	
	<cffunction name="test_variable">
		<cfset loc.e = 'hello'>
		<cfset loc.r = create_instance('hello').getName()>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

	<cffunction name="test_filters">
		
 		<cfset loc.e = 'hello'>
		<cfset loc.r = create_instance('hello | textileze')>
		<cfset assert('loc.e eq loc.r.getName()')>
		<cfset loc.e = []>
		<cfset loc.temp = ["textileze", ArrayNew(1)]>
		<cfset arrayAppend(loc.e, loc.temp)>
		<cfset assert('arrayCompare(loc.e, loc.r.getFilters())')>
 
 		<cfset loc.e = 'hello'>
		<cfset loc.r = create_instance('hello | textileze | paragraph')>
		<cfset assert('loc.e eq loc.r.getName()')>
		<cfset loc.e = []>
		<cfset loc.temp = ["textileze", ArrayNew(1)]>
		<cfset arrayAppend(loc.e, loc.temp)>
		<cfset loc.temp = ["paragraph", ArrayNew(1)]>
		<cfset arrayAppend(loc.e, loc.temp)>
		<cfset assert('arrayCompare(loc.e, loc.r.getFilters())')>

 		<cfset loc.e = 'hello'>
		<cfset loc.r = create_instance(" hello | strftime: '%Y'")>
		<cfset assert('loc.e eq loc.r.getName()')>
		<cfset loc.e = []>
		<cfset loc.args = ["'%Y'"]>
		<cfset loc.temp = ["strftime", loc.args]>
		<cfset arrayAppend(loc.e, loc.temp)>
		<cfset assert('arrayCompare(loc.e, loc.r.getFilters())')>
	
 		<cfset loc.e = "'typo'">
		<cfset loc.r = create_instance(" 'typo' | link_to: 'Typo', true ")>
		<cfset assert('loc.e eq loc.r.getName()')>
		<cfset loc.e = []>
		<cfset loc.args = ["'Typo'", "true"]>
		<cfset loc.temp = ["link_to", loc.args]>
		<cfset arrayAppend(loc.e, loc.temp)>
		<cfset assert('arrayCompare(loc.e, loc.r.getFilters())')>
		
 		<cfset loc.e = "'typo'">
		<cfset loc.r = create_instance(" 'typo' | link_to: 'Typo', false ")>
		<cfset assert('loc.e eq loc.r.getName()')>
		<cfset loc.e = []>
		<cfset loc.args = ["'Typo'", "false"]>
		<cfset loc.temp = ["link_to", loc.args]>
		<cfset arrayAppend(loc.e, loc.temp)>
		<cfset assert('arrayCompare(loc.e, loc.r.getFilters())')>

 		<cfset loc.e = "'foo'">
		<cfset loc.r = create_instance(" 'foo' | repeat: 3 ")>
		<cfset assert('loc.e eq loc.r.getName()')>
		<cfset loc.e = []>
		<cfset loc.args = ["3"]>
		<cfset loc.temp = ["repeat", loc.args]>
		<cfset arrayAppend(loc.e, loc.temp)>
		<cfset assert('arrayCompare(loc.e, loc.r.getFilters())')>
		
 		<cfset loc.e = "'foo'">
		<cfset loc.r = create_instance(" 'foo' | repeat: 3, 3")>
		<cfset assert('loc.e eq loc.r.getName()')>
		<cfset loc.e = []>
		<cfset loc.args = ["3", "3"]>
		<cfset loc.temp = ["repeat", loc.args]>
		<cfset arrayAppend(loc.e, loc.temp)>
		<cfset assert('arrayCompare(loc.e, loc.r.getFilters())')>
		
 		<cfset loc.e = "'foo'">
		<cfset loc.r = create_instance(" 'foo' | repeat: 3, 3, 3 ")>
		<cfset assert('loc.e eq loc.r.getName()')>
		<cfset loc.e = []>
		<cfset loc.args = ["3", "3", "3"]>
		<cfset loc.temp = ["repeat", loc.args]>
		<cfset arrayAppend(loc.e, loc.temp)>
		<cfset assert('arrayCompare(loc.e, loc.r.getFilters())')>
		
 		<cfset loc.e = 'hello'>
		<cfset loc.r = create_instance(" hello | strftime: '%Y, okay?'")>
		<cfset assert('loc.e eq loc.r.getName()')>
		<cfset loc.e = []>
		<cfset loc.args = ["'%Y, okay?'"]>
		<cfset loc.temp = ["strftime", loc.args]>
		<cfset arrayAppend(loc.e, loc.temp)>
		<cfset assert('arrayCompare(loc.e, loc.r.getFilters())')>
		
 		<cfset loc.e = 'hello'>
		<cfset loc.r = create_instance(" hello | things: ""%Y, okay?"", 'the other one'")>
		<cfset assert('loc.e eq loc.r.getName()')>
		<cfset loc.e = []>
		<cfset loc.args = ['"%Y, okay?"', "'the other one'"]>
		<cfset loc.temp = ["things", loc.args]>
		<cfset arrayAppend(loc.e, loc.temp)>
		<cfset assert('arrayCompare(loc.e, loc.r.getFilters())')>

	</cffunction>


	<cffunction name="test_filters_without_whitespace">
		
 		<cfset loc.e = 'hello'>
		<cfset loc.r = create_instance('hello | textileze | paragraph')>
		<cfset assert('loc.e eq loc.r.getName()')>
		<cfset loc.e = []>
		<cfset loc.args = []>
		<cfset loc.temp = ["textileze", loc.args]>
		<cfset arrayAppend(loc.e, loc.temp)>
		<cfset loc.args = []>
		<cfset loc.temp = ["paragraph", loc.args]>
		<cfset arrayAppend(loc.e, loc.temp)>
		<cfset assert('arrayCompare(loc.e, loc.r.getFilters())')>
		
 		<cfset loc.e = 'hello'>
		<cfset loc.r = create_instance('hello|textileze|paragraph')>
		<cfset assert('loc.e eq loc.r.getName()')>
		<cfset loc.e = []>
		<cfset loc.args = []>
		<cfset loc.temp = ["textileze", loc.args]>
		<cfset arrayAppend(loc.e, loc.temp)>
		<cfset loc.args = []>
		<cfset loc.temp = ["paragraph", loc.args]>
		<cfset arrayAppend(loc.e, loc.temp)>
		<cfset assert('arrayCompare(loc.e, loc.r.getFilters())')>
		
	</cffunction>
	
	<cffunction name="test_symbol">
		
 		<cfset loc.e = 'http://disney.com/logo.gif'>
		<cfset loc.r = create_instance("http://disney.com/logo.gif | image: 'med' ")>
		<cfset assert('loc.e eq loc.r.getName()')>
		<cfset loc.e = []>
		<cfset loc.args = ["'med'"]>
		<cfset loc.temp = ["image", loc.args]>
		<cfset arrayAppend(loc.e, loc.temp)>
		<cfset assert('arrayCompare(loc.e, loc.r.getFilters())')>
		
	</cffunction>
		
	<cffunction name="test_string_single_quoted">
		
 		<cfset loc.e = '"hello"'>
		<cfset loc.r = create_instance(' "hello" ')>
		<cfset assert('loc.e eq loc.r.getName()')>

	</cffunction>
	
	<cffunction name="test_string_double_quoted">
		
 		<cfset loc.e = "'hello'">
		<cfset loc.r = create_instance(" 'hello' ")>
		<cfset assert('loc.e eq loc.r.getName()')>
			
	</cffunction>
	
	<cffunction name="test_integer">
		
 		<cfset loc.e = '1000'>
		<cfset loc.r = create_instance(' 1000 ')>
		<cfset assert('loc.e eq loc.r.getName()')>

	</cffunction>
	
	<cffunction name="test_float">
		
 		<cfset loc.e = '1000.01'>
		<cfset loc.r = create_instance(' 1000.01 ')>
		<cfset assert('loc.e eq loc.r.getName()')>
	
	</cffunction>
 	
	<cffunction name="test_string_with_special_chars">
		
 		<cfset loc.e = "'hello! $!@.;""ddasd"" '">
		<cfset loc.r = create_instance("'hello! $!@.;""ddasd"" ' ")>
		<cfset assert('loc.e eq loc.r.getName()')>

	</cffunction>
	
	<cffunction name="test_string_dot">
		
 		<cfset loc.e = 'test.test'>
		<cfset loc.r = create_instance(" test.test ")>
		<cfset assert('loc.e eq loc.r.getName()')>
		
	</cffunction>

</cfcomponent>