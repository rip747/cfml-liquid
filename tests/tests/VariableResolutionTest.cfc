<cfcomponent output="false" extends="cfml-liquid.tests.Test">
	
	<cffunction name="setup">
		<cfset loc.template = application.liquid.template()>
	</cffunction>
	
	<cffunction name="test_simple_variable">

		<cfset loc.a = {test = 'worked'}>
		<cfset loc.e = "worked">
		<cfset loc.template.parse("{{test}}")>
		<cfset loc.r = loc.template.render(loc.a)>
		<cfset assert('loc.e eq loc.r')>
		
	</cffunction>
	
	<cffunction name="test_simple_with_whitespaces">

 		<cfset loc.a = {test = 'worked'}>
		<cfset loc.e = '  worked  '>
		<cfset loc.template.parse("  {{ test }}  ")>
		<cfset loc.r = loc.template.render(loc.a)>
		<cfset assert('len(loc.e) eq len(loc.r)')>
		
		<cfset loc.a = {test = 'worked wonderfully'}>
		<cfset loc.e = '  worked wonderfully  '>
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
	
	<cffunction name="test_using_queries">
		
		<cfset loc.q = QueryNew("firstname,lastname")>
		<cfset QueryAddRow(loc.q)>
		<cfset QuerySetCell(loc.q, "firstname", "Tony")>
		<cfset QuerySetCell(loc.q, "lastname", "Petruzzi")>
		<cfset QueryAddRow(loc.q)>
		<cfset QuerySetCell(loc.q, "firstname", "Per")>
		<cfset QuerySetCell(loc.q, "lastname", "Djurner")>
		
		<cfset loc.a = {test = {test = loc.q}}>
		<cfset loc.e = 'tony'>
		<cfset loc.template.parse('{{ test.test.firstname }}')>
		<cfset loc.r = loc.template.render(loc.a)>
		<cfset assert('loc.e eq loc.r')>

	</cffunction>
	
</cfcomponent>