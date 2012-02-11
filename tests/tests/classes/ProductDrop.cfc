<cfcomponent output="false" extends="cfml-liquid.lib.liquid.LiquidDrop">

	<cffunction name="top_sales">
		<cfthrow type="worked" message="worked">
	</cffunction>
	
	<cffunction name="texts">
		<cfreturn createObject("component", "TextDrop")>
	</cffunction>
	
	<cffunction name="catchall">
		<cfreturn createObject("component", "CatchallDrop")>
	</cffunction>
	
	<cffunction name="context">
		<cfreturn createObject("component", "ContextDrop")>
	</cffunction>
	
	<cffunction name="callmenot">
		<cfreturn "protected">
	</cffunction>

</cfcomponent>