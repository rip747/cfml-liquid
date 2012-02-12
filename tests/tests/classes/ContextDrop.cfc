<cfcomponent output="false" extends="cfml-liquid.lib.liquid.LiquidDrop">

	<cffunction name="_beforeMethod">
		<cfargument name="method" type="string" required="true">
		<cfdump var="#variables._context#">
		<cfdump var="#arguments#">
		<cfabort>
		<cfreturn variables._context.get(arguments.method)>
	</cffunction>
	
</cfcomponent>