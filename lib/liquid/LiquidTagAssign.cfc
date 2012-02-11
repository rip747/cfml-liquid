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
		
		<cfset loc.syntax_regexp = createobject("component", "LiquidRegexp").init('(\w+)\s*=\s*(#application.LiquidConfig.LIQUID_QUOTED_FRAGMENT#)')>

		<cfset loc.filter_seperator_regexp = createobject("component", "LiquidRegexp").init('#application.LiquidConfig.LIQUID_FILTER_SEPARATOR#\s*(.*)')>
		<cfset loc.filter_split_regexp =createobject("component", "LiquidRegexp").init('#application.LiquidConfig.LIQUID_FILTER_SEPARATOR#')>
		<cfset loc.filter_name_regexp = createobject("component", "LiquidRegexp").init('\s*(\w+)')>
		<cfset loc.filter_argument_regexp = createobject("component", "LiquidRegexp").init('(?:#application.LiquidConfig.LIQUID_FILTER_ARGUMENT_SEPARATOR#|#application.LiquidConfig.LIQUID_ARGUMENT_SEPARATOR#)\s*(#application.LiquidConfig.LIQUID_QUOTED_FRAGMENT#)')>
		
		<cfset this.filters = []>
<!--- <cfdump var="#loc.filter_seperator_regexp.match(arguments.markup)#"><cfabort> --->
		<cfif loc.filter_seperator_regexp.match(arguments.markup)>
			
			<cfset loc.filters = loc.filter_split_regexp.split(loc.filter_seperator_regexp.matches[2])>

			<cfloop array="#loc.filters#" index="loc.filter">
				<cfset loc.filter_name_regexp.match(loc.filter)>
				<cfset loc.filtername = loc.filter_name_regexp.matches[1]>

				<cfset loc.filter_argument_regexp.match_all(loc.filter)>
				<cfset loc.matches = array_flatten(loc.filter_argument_regexp.matches[2])>
				
				<cfset loc.temp = [loc.filtername, loc.matches]>
				<cfset arrayAppend(this.filters, loc.temp)>
			</cfloop>
		</cfif>

		<cfif loc.syntax_regexp.match(arguments.markup)>
			<cfset this._to = loc.syntax_regexp.matches[2]>
			<cfset this._from = loc.syntax_regexp.matches[3]>
		<cfelse>
			<cfset createObject("component", "LiquidException").init("Syntax Error in 'assign' - Valid syntax: assign [var] = [source]")>
		</cfif>
		
		<cfreturn this>
	</cffunction>


	<cffunction name="render" hint="Renders the tag">
		<cfargument name="context" type="any" required="true">
		<cfset var loc = {}>
		<cfset loc.output = arguments.context.get(this._from)>
<!--- <cfdump var="#loc.output#"> --->
		<cfloop array="#this.filters#" index="loc.filter">
			
			<cfset loc.filtername = loc.filter[1]>
			<cfset loc.filter_arg_keys = loc.filter[2]>
<!--- <cfdump var="#loc.filter#"> --->

			<cfset loc.filter_arg_values = []>
			<cfloop array="#loc.filter_arg_keys#" index="loc.arg_key">
				<cfset arrayAppend(loc.filter_arg_values, arguments.context.get(loc.arg_key))>
			</cfloop>
<!--- <cfdump var="#loc.filtername#">
<cfdump var="#loc.output#">
<cfdump var="#loc.filter_arg_values#">
<cfdump var="#getmetadata(arguments.context)#">
<cfabort> --->
			<cfset loc.output = arguments.context.invoke_method(loc.filtername, loc.output, loc.filter_arg_values)>
		</cfloop>

		<cfset arguments.context.set(this._to, loc.output)>
	</cffunction>
	
</cfcomponent>