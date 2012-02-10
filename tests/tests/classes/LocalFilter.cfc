<cfcomponent output="false">
	
	<cffunction name="notice">
		<cfargument name="value" type="string" required="true">
		<cfreturn "Local #arguments.value#">
	</cffunction>
	
</cfcomponent>