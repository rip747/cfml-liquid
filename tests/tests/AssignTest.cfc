<cfcomponent output="false" extends="cfml-liquid.tests.Test">
	
	<cffunction name="setup">
		<cfset loc.template = application.liquid.template()>
	</cffunction>

	<cffunction name="test_invalid_assign" hint="Tests the normal behavior of throwing an exception when the assignment is incorrect">
		<cfset loc.r = raised("loc.template.parse('{% assign test %}')")>
		<cfset loc.e = 'LiquidError'>
		<cfset assert("loc.e eq loc.r.type")>
	</cffunction>

	<cffunction name="test_simple_assign" hint="Tests a simple assignment with no filters">
		<cfset loc.template.parse('{% assign test = "hello" %}{{ test }}')>
		<cfset loc.r = loc.template.render()>
		<cfset loc.e = 'hello'>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_assign_with_filters" hint="Tests filtered value assignment">

		<cfset loc.template.parse('{% assign test = "hello" | upcase %}{{ test }}')>
		<cfset loc.r = loc.template.render()>
		<cfset loc.e = 'HELLO'>
		<cfset assert("loc.e eq loc.r")>

 		<cfset loc.template.parse('{% assign test = "hello" | upcase | downcase | capitalize %}{{ test }}')>
		<cfset loc.r = loc.template.render()>
		<cfset loc.e = 'Hello'>
		<cfset assert("loc.e eq loc.r")>


		<cfset loc.a = {}>
		<cfset loc.a["var1"] = ['a', 'b', 'c']>
		<cfset loc.template.parse('{% assign test = var1 | first | upcase %}{{ test }}')>
		<cfset loc.r = loc.template.render(loc.a)>
		<cfset loc.e = 'A'>
		<cfset assert("loc.e eq loc.r")>

		<cfset loc.a = {}>
		<cfset loc.a["var1"] = ['a', 'b', 'c']>
		<cfset loc.template.parse('{% assign test = var1 | last | upcase %}{{ test }}')>
		<cfset loc.r = loc.template.render(loc.a)>
		<cfset loc.e = 'C'>
		<cfset assert("loc.e eq loc.r")>

		<cfset loc.a = {}>
		<cfset loc.a["var1"] = ['a', 'b', 'c']>
		<cfset loc.template.parse('{% assign test = var1 | join %}{{ test }}')>
		<cfset loc.r = loc.template.render(loc.a)>
		<cfset loc.e = 'a b c'>
		<cfset assert("loc.e eq loc.r")>

		<cfset loc.a = {}>
		<cfset loc.a["var1"] = ['a', 'b', 'c']>
		<cfset loc.template.parse('{% assign test = var1 | join : "." %}{{ test }}')>
		<cfset loc.r = loc.template.render(loc.a)>
		<cfset loc.e = 'a.b.c'>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>
	
</cfcomponent>