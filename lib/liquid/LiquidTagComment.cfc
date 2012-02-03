<cfcomponent extends="LiquidBlock" hint="
Creates a comment; everything inside will be ignored

@example
{% comment %} This will be ignored {% endcomment %}
">

	<cffunction name="render" returntype="string" output="false">
		<cfargument name="contenxt" type="any" required="true">
		<cfreturn "">
	</cffunction>
	
</cfcomponent>