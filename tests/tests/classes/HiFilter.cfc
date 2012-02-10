<cfcomponent output="false">
	
	<cffunction name="ht">
		<cfargument name="value" type="string" required="true">
		<cfreturn arguments.value & ' hi!'>
	</cffunction>
	
</cfcomponent>