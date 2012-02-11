<cfcomponent output="false">

	<cfset this.variable = 'not set'>
	
	<cffunction name="static_test">
		<cfreturn "worked">
	</cffunction>
	
	<cffunction name="instance_test_one">
		<cfset this.variable = 'set'>
		<cfreturn 'set'>
	</cffunction>
	
	<cffunction name="instance_test_two">
		<cfreturn this.variable>
	</cffunction>
	
</cfcomponent>