<cfcomponent output="false" extends="cfml-liquid.tests.Test">
	
	<!--- LiquidFilterBank --->
	<cfset this.context = "">
	
	<cffunction name="setup">
		<cfset this.context = createObject("component", "cfml-liquid.lib.liquid.LiquidContext").init()>
	</cffunction>

	<cffunction name="test_function_filter">
		<cfset loc.var = createObject("component", "cfml-liquid.lib.liquid.LiquidVariable").init('var | function_filter')>
		<cfset this.context.set('var', 1000)>
		<cfset this.context.add_filters('test_function_filter')>
		<cfset loc.e = 'worked'>
		<cfset loc.r = loc.var.render(this.context)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>
	
	<cffunction name="test_static_class_filter">
		<cfset loc.var = createObject("component", "cfml-liquid.lib.liquid.LiquidVariable").init('var | static_test')>
		<cfset this.context.set('var', 1000)>
		<cfset this.context.add_filters('TestClassFilter')>
		<cfset loc.e = 'worked'>
		<cfset loc.r = loc.var.render(this.context)>
		<cfset assert("loc.e eq loc.r")>	
	</cffunction>
	
	<cffunction name="test_object_filter">
		<cfset loc.var = createObject("component", "cfml-liquid.lib.liquid.LiquidVariable").init('var | instance_test_one')>
		<cfset this.context.set('var', 1000)>
		<cfset loc.f = createObject("component", "classes.TestClassFilter")>
		<cfset this.context.add_filters(loc.f)>
		<cfset loc.e = 'set'>
		<cfset loc.r = loc.var.render(this.context)>
		<cfset assert("loc.e eq loc.r")>
			
		<cfset loc.var = createObject("component", "cfml-liquid.lib.liquid.LiquidVariable").init('var | instance_test_two')>
		<cfset loc.e = 'set'>
		<cfset loc.r = loc.var.render(this.context)>
		<cfset assert("loc.e eq loc.r")>
	</cffunction>
	
	<cffunction name="function_filter">
		<cfargument name="value" type="string" required="true">
		<cfreturn "worked">
	</cffunction>
	
</cfcomponent>