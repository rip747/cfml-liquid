<cfcomponent output="false" extends="cfml-liquid.tests.Test">
	
	<cffunction name="setup">
		<cfset loc.liquid = createObject("component", "cfml-liquid.lib.Liquid").init()>
		<cfset loc.template = createObject("component", "cfml-liquid.lib.liquid.LiquidTemplate").init()>
	</cffunction>

	<cffunction name="test_invalid_assign" hint="Tests the normal behavior of throwing an exception when the assignment is incorrect">
		<cfset loc.template.parse('{% assign test %}')>
		<cfset assert("loc.template.render() eq 'hello'")>
	</cffunction>

	<cffunction name="test_simple_assign" hint="Tests a simple assignment with no filters">
		<cfset loc.template.parse('{% assign test = "hello" %}{{ test }}')>
		<cfset assert("loc.template.render() eq 'hello'")>
	</cffunction>

	<cffunction name="test_assign_with_filters" hint="Tests filtered value assignment">
		<cfset loc.template.parse('{% assign test = "hello" | upcase %}{{ test }}')>
		<cfset assert("loc.template.render() eq 'HELLO'")>

 		<cfset loc.template.parse('{% assign test = "hello" | upcase | downcase | capitalize %}{{ test }}')>
		<cfset assert("loc.template.render() eq 'Hello'")>

		<cfset loc.a = {}>
		<cfset loc.a["array"] = ['a', 'b', 'c']>
		<cfset loc.template.parse('{% assign test = var1 | first | upcase %}{{ test }}')>
		<cfset assert("loc.template.render(loc.a) eq 'A'")>

		<cfset loc.a = {}>
		<cfset loc.a["array"] = ['a', 'b', 'c']>
		<cfset loc.template.parse('{% assign test = var1 | last | upcase %}{{ test }}')>
		<cfset assert("loc.template.render(loc.a) eq 'C'")>

		<cfset loc.a = {}>
		<cfset loc.a["array"] = ['a', 'b', 'c']>
		<cfset loc.template.parse('{% assign test = var1 | join %}{{ test }}')>
		<cfset assert("loc.template.render(loc.a) eq 'a b c'")>

		<cfset loc.a = {}>
		<cfset loc.a["array"] = ['a', 'b', 'c']>
		<cfset loc.template.parse('{% assign test = var1 | join : "." %}{{ test }}')>
		<cfset assert("loc.template.render(loc.a) eq 'a.b.c'")>
	</cffunction>
	
</cfcomponent>