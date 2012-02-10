<cfcomponent output="false">
	
	<cffunction name="init">
		<cfreturn this>
	</cffunction>

	<cffunction name="money">
		<cfargument name="value" type="numeric" required="true">
		<cfreturn ' #arguments.value#$ CAD '>
	</cffunction>
	
</cfcomponent>