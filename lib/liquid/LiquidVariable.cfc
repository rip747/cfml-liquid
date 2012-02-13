<cfcomponent output="false" hint="Implements a template variable">

	<cfinclude template="utils.cfm">

	<cffunction name="init">
		<cfargument name="markup" type="string" required="true">
		<cfset var loc = {}>

		<cfset variables._markup = arguments.markup>
		<cfset variables._filters = []>
		<cfset variables._name = "">
		
		<cfset loc.quoted_fragment_regexp = createObject("component", "LiquidRegexp").init("\s*(#application.LiquidConfig.LIQUID_QUOTED_FRAGMENT#)")>
		<cfset loc.filter_seperator_regexp = createObject("component", "LiquidRegexp").init("#application.LiquidConfig.LIQUID_FILTER_SEPARATOR#\s*(.*)")>
		<cfset loc.filter_split_regexp = createObject("component", "LiquidRegexp").init(application.LiquidConfig.LIQUID_FILTER_SEPARATOR)>
		<cfset loc.filter_name_regexp = createObject("component", "LiquidRegexp").init("\s*(\w+)")>
		<cfset loc.filter_argument_regexp = createObject("component", "LiquidRegexp").init("(?:#application.LiquidConfig.LIQUID_FILTER_ARGUMENT_SEPARATOR#|#application.LiquidConfig.LIQUID_ARGUMENT_SEPARATOR#)\s*(#application.LiquidConfig.LIQUID_QUOTED_FRAGMENT#)")>

		<cfif loc.quoted_fragment_regexp.match(arguments.markup)>
			<cfset variables._name = trim(loc.quoted_fragment_regexp.matches[1])>
		</cfif>

		<cfif loc.filter_seperator_regexp.match(arguments.markup)>

			<cfset loc.$filters = loc.filter_split_regexp.split(loc.filter_seperator_regexp.matches[1])>

			<cfloop array="#loc.$filters#" index="loc.filter">
				
				<cfset loc.filter = trim(loc.filter)>
				<cfset loc.filter_name_regexp.match(loc.filter)>
				<cfset loc.filtername = loc.filter_name_regexp.matches[1]>
				<cfset loc.filter_argument_regexp.match_all(loc.filter)>
				<cfset loc.temp = []>
				<cfset loc.matches = []>
				
				<cfif !ArrayIsEmpty(loc.filter_argument_regexp.matches)>
					<cfset loc.matches = array_flatten(loc.filter_argument_regexp.matches[2])>
				</cfif>

				<cfset loc.temp = [loc.filtername, loc.matches]>
				<cfset arrayAppend(variables._filters, loc.temp)>

			</cfloop>
			
		</cfif>

		<cfreturn this>
	</cffunction>

	<cffunction name="render" hint="Renders the variable with the data in the context">
		<cfargument name="context" type="any" required="true">
		<cfset var loc = {}>

		<cfset loc.output = arguments.context.get(variables._name)>

		<cfloop array="#variables._filters#" index="loc.filter">
			
			<cfset loc.filtername = loc.filter[1]>
			<cfset loc.filter_arg_keys = loc.filter[2]>
			<cfset loc.filter_arg_values = []>
			
			<cfloop array="#loc.filter_arg_keys#" index="loc.arg_keys">
				<cfset arrayAppend(loc.filter_arg_values, arguments.context.get(loc.arg_keys))>
			</cfloop>

			<cfset loc.output = arguments.context.invoke_method(loc.filtername, loc.output, loc.filter_arg_values)>

		</cfloop>
		
		<cfreturn loc.output>
	</cffunction>
	
	<cffunction name="getName">
		<cfreturn variables._name>
	</cffunction>

	<cffunction name="getFilters">
		<cfreturn variables._filters>
	</cffunction>

</cfcomponent>