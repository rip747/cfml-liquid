<cfcomponent output="false" extends="cfml-liquid.tests.Test">
	
	<cffunction name="setup">
		<cfset loc.liquid = createObject("component", "cfml-liquid.lib.Liquid").init()>
		<cfset loc.template = createObject("component", "cfml-liquid.lib.liquid.LiquidTemplate").init()>
	</cffunction>
	
	<cffunction name="test_blackspace">
		<cfset loc.a = ['  ']>
		<cfset loc.template.parse('  ')>
		<cfset loc.nodelist = loc.template.getRoot().getNodelist()>
		<cfset assert("loc.a eq loc.nodelist")>
	</cffunction>
	
	<cffunction name="test_variable_beginning">
		<cfset loc.template.parse('{{funk}}  ')>
		<cfset loc.nodelist = loc.template.getRoot().getNodelist()>
		
		<cfset assert("ArrayLen(loc.nodelist eq 2")>
		<cfset assert("getMetaData(loc.nodelist[1]) eq 'LiquidVariable'")>
		<cfset assert("IsSimpleValue(loc.nodelist[2])")>
	</cffunction>

	<cffunction name="test_variable_end">
		<cfset loc.template.parse('  {{funk}}')>
		<cfset loc.nodelist = loc.template.getRoot().getNodelist()>
		
		<cfset assert("ArrayLen(loc.nodelist eq 2")>
		<cfset assert("IsSimpleValue(loc.nodelist[1])")>
		<cfset assert("getMetaData(loc.nodelist[2]) eq 'LiquidVariable'")>
	</cffunction>

	<cffunction name="test_variable_middle">
		<cfset loc.template.parse('  {{funk}}  ')>
		<cfset loc.nodelist = loc.template.getRoot().getNodelist()>

		<cfset assert("ArrayLen(loc.nodelist eq 3")>
		<cfset assert("IsSimpleValue(loc.nodelist[1])")>
		<cfset assert("getMetaData(loc.nodelist[2]) eq 'LiquidVariable'")>
		<cfset assert("IsSimpleValue(loc.nodelist[3])")>
	</cffunction>	

	<cffunction name="test_variable_many_embedded_fragments">
		<cfset loc.template.parse('  {{funk}}  {{soul}}  {{brother}} ')>
		<cfset loc.nodelist = loc.template.getRoot().getNodelist()>
		
		<cfset assert("ArrayLen(loc.nodelist eq 7")>
		<cfset assert("IsSimpleValue(loc.nodelist[1])")>
		<cfset assert("getMetaData(loc.nodelist[2]) eq 'LiquidVariable'")>
		<cfset assert("IsSimpleValue(loc.nodelist[3])")>
		<cfset assert("getMetaData(loc.nodelist[4]) eq 'LiquidVariable'")>
		<cfset assert("IsSimpleValue(loc.nodelist[5])")>
		<cfset assert("getMetaData(loc.nodelist[6]) eq 'LiquidVariable'")>
		<cfset assert("IsSimpleValue(loc.nodelist[7])")>
	</cffunction>

	<cffunction name="test_with_block">
		<cfset loc.template.parse('  {% comment %}  {% endcomment %} ')>
		<cfset loc.nodelist = loc.template.getRoot().getNodelist()>
		
		<cfset assert("ArrayLen(loc.nodelist eq 3")>
		<cfset assert("IsSimpleValue(loc.nodelist[1])")>
		<cfset assert("getMetaData(loc.nodelist[2]) eq 'LiquidTagComment'")>
		<cfset assert("IsSimpleValue(loc.nodelist[3])")>
	</cffunction>
	
</cfcomponent>