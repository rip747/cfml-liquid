<cfcomponent output="false">

	<cffunction name="init">
		<cfargument name="message" type="string" required="true">
		<cfthrow type="LiquidError" message="#arguments.message#"/>
	</cffunction>

</cfcomponent>