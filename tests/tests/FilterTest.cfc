<cfcomponent output="false" extends="cfml-liquid.tests.Test">

	<cffunction name="setup">
		<cfset loc.context = createobject("component", "cfml-liquid.lib.liquid.LiquidContext").init()>
	</cffunction>
	
	<cffunction name="create_var_instance">
		<cfargument name="value" type="string" required="true">
		<cfreturn createObject("component", "cfml-liquid.lib.liquid.LiquidVariable").init(
			arguments.value
		)>
	</cffunction>
	
	<cffunction name="create_class_instance">
		<cfargument name="klass" type="string" required="true">
		<cfreturn createObject("component", "classes.#arguments.klass#").init()>
	</cffunction>
	
	<cffunction name="create_moneyfilter_instance">
		<cfreturn createObject("component", "classes.MoneyFilter").init()>
	</cffunction>
	
	<cffunction name="test_local_filter">
		<cfset loc.v = create_var_instance('var | money')>
		<cfset loc.f = create_class_instance("MoneyFilter")>
		
		<cfset loc.context.set('var', 1000)>
		<cfset loc.context.add_filters(loc.f)>
		<cfset loc.e = " 1000$ ">
		<cfset loc.r = loc.v.render(loc.context)>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

	<cffunction name="test_underscore_in_filter_name">
		<cfset loc.v = create_var_instance('var | money_with_underscore ')>
		<cfset loc.f = create_class_instance("MoneyFilter")>
		
		<cfset loc.context.set('var', 1000)>
		<cfset loc.context.add_filters(loc.f)>
		<cfset loc.e = " 1000$ ">
		<cfset loc.r = loc.v.render(loc.context)>
		<cfset assert('loc.e eq loc.r')>			
	</cffunction>

	<cffunction name="test_second_filter_overwrites_first">		
		<cfset loc.v = create_var_instance('var | money ')>
		<cfset loc.f = create_class_instance("MoneyFilter")>
		<cfset loc.context.add_filters(loc.f)>
		<cfset loc.f = create_class_instance("CanadianMoneyFilter")>
		<cfset loc.context.add_filters(loc.f)>

		<cfset loc.context.set('var', 1000)>
		<cfset loc.e = ' 1000$ CAD '>
		<cfset loc.r = loc.v.render(loc.context)>
		<cfset assert('loc.e eq loc.r')>				
	</cffunction>

</cfcomponent>