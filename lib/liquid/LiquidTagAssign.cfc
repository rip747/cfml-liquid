<cfcomponent output="false" extends="LiquidTag" hint="
Performs an assignment of one variable to another
{%assign var = var %}
{%assign var = 'hello' | upcase %}
">

	<cffunction name="init">
		<cfargument name="markup" type="string" required="true">
		<cfargument name="tokens" type="array" required="true">
		<cfargument name="file_system" type="any" required="true">
		<cfset var loc = {}>
		
		<cfset loc.syntax_regexp = createobject("component", "LiquidRegexp").init('(#application.LiquidConfig.LIQUID_VARIABLE_SIGNATURE#+)\s*=\s*(.*)\s*')>

		<cfif loc.syntax_regexp.match(arguments.markup)>
			
			<cfset this._to = loc.syntax_regexp.matches[2]>
			<cfset this._from = createObject("component", "LiquidVariable").init(loc.syntax_regexp.matches[3])>
			
		<cfelse>
			<cfset createObject("component", "LiquidException").init("Syntax Error in 'assign' - Valid syntax: assign [var] = [source]")>
		</cfif>
		
		<cfreturn this>
	</cffunction>


	<cffunction name="render" hint="Renders the tag">
		<cfargument name="context" type="any" required="true">
		<cfset arguments.context.set(this._to, this._from.render(arguments.context))>
	</cffunction>

</cfcomponent>