<cfcomponent output="false" extends="cfml-liquid.tests.Test">

	<cffunction name="setup">
		<cfset loc.context = createobject("component", "cfml-liquid.lib.liquid.LiquidContext").init()>
	</cffunction>

	<cffunction name="test_specifying_filter_delim_with_no_filter_defined">
		<cfset loc.v = create_var_instance("var | ")>
		<cfset loc.context.set('var', "bla blub")>
		<cfset loc.e = "bla blub">
		<cfset loc.r = loc.v.render(loc.context)>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>
	
	<cffunction name="test_specifying_filter_that_does_not_exists">
		<cfset loc.v = create_var_instance("var | fdsdfsdfs")>
		<cfset loc.context.set('var', "bla blub")>
		<cfset loc.e = "bla blub">
		<cfset loc.r = loc.v.render(loc.context)>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

	<cffunction name="create_var_instance">
		<cfargument name="value" type="string" required="true">
		<cfreturn createObject("component", "cfml-liquid.lib.liquid.LiquidVariable").init(
			arguments.value
		)>
	</cffunction>

</cfcomponent>