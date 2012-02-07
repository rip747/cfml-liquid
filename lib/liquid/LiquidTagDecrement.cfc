<cfcomponent output="false" extends="LiquidTag" hint="
Used to decrement a counter into a template

@example 
{% decrement value %}
">

	<cffunction name="init">
		<cfargument name="markup" type="string" required="true">
		<cfargument name="tokens" type="array" required="true">
		<cfargument name="file_system" type="any" required="true" hint="LiquidFileSystem">
		<cfset var loc = {}>
		
		<!--- Name of the variable to decrement --->
		<cfset this._toDecrement = "">
		
		<cfset loc.syntax = createObject("component", "LiquidRegexp").init("(#application.LiquidConfig.LIQUID_ALLOWED_VARIABLE_CHARS#+)")>

		<cfif loc.syntax.match(arguments.markup)>
			<cfset this._toDecrement = loc.syntax.matches[1]>
		<cfelse>
			<cfset createObject("component", "LiquidException").init("Syntax Error in 'decrement' - Valid syntax: decrement [var]")>
		</cfif>
		
		<cfreturn this>
	</cffunction>

	<cffunction name="render" hint="Renders the tag">
		<cfargument name="context" type="any" required="true" hint="LiquidContext">
		<cfset var loc = {}>
		
		<!--- 
		if the value is not set in the environment check to see if it
		exists in the context, and if not set it to 0
		 --->
		<cfif not IsDefined(arguments.context.environments[1][this._toDecrement])>
			<!--- check for a context value --->
			<cfset loc.from_context = arguments.context.get(this->_toDecrement)>
			
			<!--- we already have a value in the context --->
			<cfif StructKeyExists(loc, "from_context")>
				<cfset loc.temp = loc.from_context>
			<cfelse>
				<cfset loc.temp = 0>
			</cfif>
			
			<cfset arguments.context.environments[1][this._toDecrement] = loc.temp>
		</cfif>

		<!--- decrement the environment value --->
		<cfset arguments.context.environments[1][this._toDecrement] = arguments.context.environments[1][this._toDecrement] - 1>
	</cffunction>
	
</cfcomponent>