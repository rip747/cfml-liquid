<cfcomponent output="false" extends="cfml-liquid.lib.liquid.LiquidDrop">

	<cffunction name="amount">
		<cfreturn createObject("component", "HundredCentes.cfc")>
	</cffunction>
	
</cfcomponent>