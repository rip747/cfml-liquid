<cfcomponent output="false" extends="cfml-liquid.tests.Test">
	
	<cffunction name="setup">
		<cfset loc.template = application.liquid.template()>
	</cffunction>
	
	<cffunction name="test_blackspace">
		<cfset loc.a = ['  ']>
		<cfset loc.template.parse('  ')>
		<cfset loc.nodelist = loc.template.getRoot().getNodelist()>
		
		<cfset assert('IsArray(loc.a) and IsArray(loc.nodelist)')>
		<cfset assert('ArrayLen(loc.a) eq 1 and ArrayLen(loc.nodelist) eq 1')>
		<cfset assert('loc.a[1] eq loc.nodelist[1]')>		
	</cffunction>
	
	<cffunction name="test_variable_beginning">
		<cfset loc.template.parse('{{funk}}  ')>
		<cfset loc.nodelist = loc.template.getRoot().getNodelist()>
		<cfset assert("ArrayLen(loc.nodelist) eq 2")>
		<cfset assert("getClassName(loc.nodelist[1]) eq 'LiquidVariable'")>
		<cfset assert("IsSimpleValue(loc.nodelist[2])")>
	</cffunction>

	<cffunction name="test_variable_end">
		<cfset loc.template.parse('  {{funk}}')>
		<cfset loc.nodelist = loc.template.getRoot().getNodelist()>
		
		<cfset assert("ArrayLen(loc.nodelist) eq 2")>
		<cfset assert("IsSimpleValue(loc.nodelist[1])")>
		<cfset assert("getClassName(loc.nodelist[2]) eq 'LiquidVariable'")>
	</cffunction>

	<cffunction name="test_variable_middle">
		<cfset loc.template.parse('  {{funk}}  ')>
		<cfset loc.nodelist = loc.template.getRoot().getNodelist()>

		<cfset assert("ArrayLen(loc.nodelist) eq 3")>
		<cfset assert("IsSimpleValue(loc.nodelist[1])")>
		<cfset assert("getClassName(loc.nodelist[2]) eq 'LiquidVariable'")>
		<cfset assert("IsSimpleValue(loc.nodelist[3])")>
	</cffunction>	

	<cffunction name="test_variable_many_embedded_fragments">
		<cfset loc.template.parse('  {{funk}}  {{soul}}  {{brother}} ')>
		<cfset loc.nodelist = loc.template.getRoot().getNodelist()>
		
		<cfset assert("ArrayLen(loc.nodelist) eq 7")>
		<cfset assert("IsSimpleValue(loc.nodelist[1])")>
		<cfset assert("getClassName(loc.nodelist[2]) eq 'LiquidVariable'")>
		<cfset assert("IsSimpleValue(loc.nodelist[3])")>
		<cfset assert("getClassName(loc.nodelist[4]) eq 'LiquidVariable'")>
		<cfset assert("IsSimpleValue(loc.nodelist[5])")>
		<cfset assert("getClassName(loc.nodelist[6]) eq 'LiquidVariable'")>
		<cfset assert("IsSimpleValue(loc.nodelist[7])")>
	</cffunction>

	<cffunction name="test_with_block">
		<cfset loc.template.parse('  {% comment %}  {% endcomment %} ')>
		<cfset loc.nodelist = loc.template.getRoot().getNodelist()>
		
		<cfset assert("ArrayLen(loc.nodelist) eq 3")>
		<cfset assert("IsSimpleValue(loc.nodelist[1])")>
		<cfset assert("getClassName(loc.nodelist[2]) eq 'LiquidTagComment'")>
		<cfset assert("IsSimpleValue(loc.nodelist[3])")>
	</cffunction>

</cfcomponent>