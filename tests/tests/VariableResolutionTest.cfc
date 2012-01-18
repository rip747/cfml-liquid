<cfcomponent output="false" extends="cfml-liquid.tests.Test">
	
	<cffunction name="setup">
		<cfset loc.liquid = createObject("component", "cfml-liquid.lib.Liquid").init()>
		<cfset loc.template = createObject("component", "cfml-liquid.lib.liquid.LiquidTemplate").init()>
	</cffunction>
	
	<cffunction name="test_simple_variable">

		<cfset loc.a = {test = 'worked'}>
		<cfset loc.e = "worked">
		<cfset loc.template.parse("{{test}}")>
		<cfset loc.r = loc.template.render(loc.a)>
		<cfset assert('loc.e eq loc.r')>
		
	</cffunction>
	
	<cffunction name="test_simple_with_whitespaces">

		<cfset loc.a = {test = '  worked  '}>
		<cfset loc.e = 'worked'>
		<cfset loc.template.parse('  {{ test }}  ')>
		<cfset loc.r = loc.template.render(loc.a)>
		<cfset assert('loc.e eq loc.r')>
		
		<cfset loc.a = {test = '  worked wonderfully  '}>
		<cfset loc.e = 'worked wonderfully'>
		<cfset loc.template.parse('  {{ test }}  ')>
		<cfset loc.r = loc.template.render(loc.a)>
		<cfset assert('loc.e eq loc.r')>

	</cffunction>
	
	<cffunction name="test_ignore_unknown">

		<cfset loc.e = ''>
		<cfset loc.template.parse('{{ test }}')>
		<cfset loc.r = loc.template.render()>
		<cfset assert('loc.e eq loc.r')>
	
	</cffunction>
	
	<cffunction name="test_array_scoping">

		<cfset loc.a = {test = {test = 'worked'}}>
		<cfset loc.e = 'worked'>
		<cfset loc.template.parse('{{ test.test }}')>
		<cfset loc.r = loc.template.render(loc.a)>
		<cfset assert('loc.e eq loc.r')>

	</cffunction>
	
</cfcomponent>