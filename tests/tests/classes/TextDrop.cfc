<cfcomponent output="false" extends="cfml-liquid.lib.liquid.LiquidDrop">

	<cffunction name="get_array">
		<cfreturn ListToArray('text1', 'text2')>
	</cffunction>

	<cffunction name="text">
		<cfreturn 'text1'>
	</cffunction>

</cfcomponent>