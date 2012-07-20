<cfcomponent output="false" extends="cfml-liquid.lib.liquid.LiquidDrop">

	<cffunction name="beforeMethod">
		<cfargument name="method" type="string" required="true">
		<cfreturn 'method: ' & arguments.method>
	</cffunction>
	
</cfcomponent>