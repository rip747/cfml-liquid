<cfcomponent output="false">
	
	<cffunction name="notice">
		<cfargument name="value" type="string" required="true">
		<cfreturn "Global #arguments.value#">
	</cffunction>
	
</cfcomponent>