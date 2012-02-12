<cfcomponent output="false" extends="cfml-liquid.lib.liquid.LiquidDrop">

	<cffunction name="get_array">
		<cfset var a = ['text1','text2']>
		<cfreturn a>
	</cffunction>

	<cffunction name="text">
		<cfreturn 'text1'>
	</cffunction>

</cfcomponent>