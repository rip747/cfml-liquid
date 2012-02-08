<cfcomponent output="false" extends="cfml-liquid.tests.Test">
	
	<cffunction name="setup">
		<cfset loc.liquid = createObject("component", "cfml-liquid.lib.Liquid").init()>
		<cfset loc.template = createObject("component", "cfml-liquid.lib.liquid.LiquidTemplate").init()>
	</cffunction>
	
	<cffunction name="test_error_with_css">
		<cfset loc.text = " div { font-weight: bold; } ">
		<cfset loc.template.parse(loc.text)>
		<cfset loc.nodelist = loc.template.getRoot().getNodelist()>
		
		<cfset assert("loc.text eq loc.template.render()")>
		<cfset assert("IsSimpleValue(loc.nodelist[1])")>
	</cffunction>
	
</cfcomponent>