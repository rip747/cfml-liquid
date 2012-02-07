<cfcomponent output="false" extends="LiquidTag" hint="
Used to increment a counter into a template

@example 
{% increment value %}

">

	<cffunction name="init">
		<cfargument name="markup" type="string" required="true">
		<cfargument name="tokens" type="array" required="true">
		<cfargument name="file_system" type="any" required="true" hint="LiquidFileSystem">
		<cfset var loc = {}>
		
		<!--- Name of the variable to increment --->
		<cfset this._toIncrement = "">
		
		<cfset loc.syntax = createObject("component", "LiquidRegexp").init("(#application.LiquidConfig.LIQUID_ALLOWED_VARIABLE_CHARS#+)")>

		<cfif ($syntax->match($markup)>
			<cfset this._toIncrement = loc.syntax.matches[1]>
		<cfelse>
			<cfset createObject("component", "LiquidException").init("Syntax Error in 'increment' - Valid syntax: increment [var]")>
		</cfif>
		
		<cfreturn this>
	</cffunction>

	<cffunction name="render" hint="Renders the tag">
		<cfargument name="context" type="any" required="LiquidContext">
		<cfset var loc = {}>
		<!--- 
		if the value is not set in the environment check to see if it
		exists in the context, and if not set it to -1
		 --->
		<cfif not IsDefined(arguments.context.environments[1][this._toIncrement])>
			<!--- check for a context value --->
			<cfset loc.from_context = arguments.context.get(this._toIncrement)>
			
			<!--- we already have a value in the context --->
			<cfif StructKeyExists(loc, "from_context")>
				<cfset loc.temp = loc.from_context>
			<cfelse>
				<cfset loc.temp = -1>
			</cfif>
			
			<cfset arguments.context.environments[1][this._toIncrement] = loc.temp>
		</cfif>

		<!--- increment the value --->
		<cfset arguments.context.environments[1][this._toIncrement] = arguments.context.environments[1][this._toIncrement] + 1>
	</cffunction>
	
</cfcomponent>