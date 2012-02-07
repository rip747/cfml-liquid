<cfcomponent extends="LiquidBlock" output="false" hint="
Captures the output inside a block and assigns it to a variable

@example
{% capture foo %} bar {% endcapture %}
">

	<cfset this._to = "">

	<cffunction name="init" output="false">
		<cfargument name="markup" type="string" required="true">
		<cfargument name="tokens" type="array" required="true">
		<cfargument name="file_system" type="any" required="true" hint="LiquidFileSystem">
		<cfset var loc = {}>

		<cfset loc.syntax_regexp = createObject("component", "LiquidRegexp").init('(\w+)')>
		
		<cfif loc.syntax_regexp.match(arguments.markup)>
			<cfset this._to = loc.syntax_regexp.matches[2]>
			<cfset super.init(arguments.markup, arguments.tokens, arguments.file_system)>
		<cfelse>
			<cfset createObject("component", "LiquidException").init("Syntax Error in 'capture' - Valid syntax: assign [var] = [source]")>
		</cfif>
		
		<cfreturn this>
	</cffunction>

	<cffunction name="render">
		<cfargument name="context" type="any" required="" hint="">
		<cfset loc.output = super.render(arguments.context)>
		
		<cfset arguments.context.set(this._to, loc.output)>
	</cffunction>	
</cfcomponent>