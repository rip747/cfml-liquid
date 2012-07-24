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
	
	<cffunction name="test_size">
		<cfset loc.v = create_var_instance("var | size")>
		<cfset loc.f = create_class_instance("MoneyFilter")>
		<cfset loc.context.add_filters(loc.f)>

		<cfset loc.context.set('var', 1000)>
		<cfset loc.e = 4>
		<cfset loc.r = loc.v.render(loc.context)>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>
	
	<cffunction name="test_join">
		<cfset loc.v = create_var_instance("var | join")>
		<cfset loc.a = [1, 2, 3, 4]>
		<cfset loc.context.set('var', loc.a)>
		<cfset loc.e = "1 2 3 4">
		<cfset loc.r = loc.v.render(loc.context)>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>
	
	<cffunction name="test_strip_html">
		<cfset loc.v = create_var_instance("var | strip_html")>

		<cfset loc.context.set('var', "<b>bla blub</a>")>
		<cfset loc.e = "bla blub">
		<cfset loc.r = loc.v.render(loc.context)>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

	<cffunction name="test_plus_without_operand">
		<cfset loc.v = create_var_instance("var | plus")>
		<cfset loc.context.set('var', 5)>
		<cfset loc.e = "5">
		<cfset loc.r = loc.v.render(loc.context)>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>
	
	<cffunction name="test_minus_without_operand">
		<cfset loc.v = create_var_instance("var | minus")>
		<cfset loc.context.set('var', 5)>
		<cfset loc.e = "5">
		<cfset loc.r = loc.v.render(loc.context)>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>
	
	<cffunction name="test_times_without_operand">
		<cfset loc.v = create_var_instance("var | times")>
		<cfset loc.context.set('var', 5)>
		<cfset loc.e = "5">
		<cfset loc.r = loc.v.render(loc.context)>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>
	
	<cffunction name="test_divided_by_without_operand">
		<cfset loc.v = create_var_instance("var | divided_by")>
		<cfset loc.context.set('var', 5)>
		<cfset loc.e = "5">
		<cfset loc.r = loc.v.render(loc.context)>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>
	
	<cffunction name="test_divided_zero_returns_zero">
		<cfset loc.v = create_var_instance("var | divided_by:0")>
		<cfset loc.context.set('var', 5)>
		<cfset loc.e = "0">
		<cfset loc.r = loc.v.render(loc.context)>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>
	
	<cffunction name="test_modulo_without_operand">
		<cfset loc.v = create_var_instance("var | modulo")>
		<cfset loc.context.set('var', 5)>
		<cfset loc.e = "0">
		<cfset loc.r = loc.v.render(loc.context)>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

</cfcomponent>