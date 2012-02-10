<cfcomponent output="false">
	
	<cffunction name="hi">
		<cfargument name="value" type="string" required="true">
		<cfreturn arguments.value & ' hi!'>
	</cffunction>
	
</cfcomponent>