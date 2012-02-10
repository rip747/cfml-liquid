<cfcomponent output="false">
	
	<cffunction name="init">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="money">
		<cfargument name="value" type="numeric" required="true">
		<cfreturn ' #arguments.value#$ '>
	</cffunction>
	
	<cffunction name="money_with_underscore">
		<cfargument name="value" type="numeric" required="true">
		<cfreturn ' #arguments.value#$ '>	
	</cffunction>
	
</cfcomponent>