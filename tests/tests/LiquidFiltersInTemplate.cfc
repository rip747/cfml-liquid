<cfcomponent output="false" extends="cfml-liquid.tests.Test">
	
	<cffunction name="test_local_global">
		<cfset loc.template = application.liquid.template()>
		<cfset loc.m = create_class_instance("MoneyFilter")>
		<cfset loc.c = create_class_instance("CanadianMoneyFilter")>
		<cfset loc.template.registerFilter(loc.m)>
		<cfset loc.template.parse('{{1000 | money}}')>
		
		<cfset loc.e = ' 1000$ '>
		<cfset loc.r = loc.template.render()>
		<cfset assert('loc.e eq loc.r')>
		
		<cfset loc.e = ' 1000$ CAD '>
		<cfset loc.a = {}>
		<cfset loc.r = loc.template.render(loc.a, loc.c)>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>
	
	<cffunction name="create_class_instance">
		<cfargument name="klass" type="string" required="true">
		<cfreturn createObject("component", "classes.#arguments.klass#").init()>
	</cffunction>

</cfcomponent>