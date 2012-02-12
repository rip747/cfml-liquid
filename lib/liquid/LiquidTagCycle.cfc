<cfcomponent output="false" extends="LiquidTag" hint="
Cycles between a list of values; calls to the tag will return each value in turn

@example
{%cycle 'one', 'two'%} {%cycle 'one', 'two'%} {%cycle 'one', 'two'%}

this will return:
one two one

Cycles can also be named, to differentiate between multiple cycle with the same values:
{%cycle 1: 'one', 'two' %} {%cycle 2: 'one', 'two' %} {%cycle 1: 'one', 'two' %} {%cycle 2: 'one', 'two' %}

will return
one one two two
">

	<cffunction name="init">
		<cfargument name="markup" type="string" required="true">
		<cfargument name="tokens" type="array" required="true">
		<cfargument name="file_system" type="any" required="true">
		<cfset var loc = {}>
<!--- <cfdump var="#arguments#" label="cycle:init"> --->
		<!--- The name of the cycle; if none is given one is created using the value list --->
		<cfset this._name = "">
		<!--- The variables to cycle between --->
		<cfset this._variables = []>
		
		<cfset loc.simple_syntax = createObject("component", "LiquidRegexp").init(application.LiquidConfig.LIQUID_QUOTED_FRAGMENT)>
		<cfset loc.named_syntax = createObject("component", "LiquidRegexp").init("(#application.LiquidConfig.LIQUID_QUOTED_FRAGMENT#)\s*\:\s*(.*)")>
		
		<cfif loc.named_syntax.match(arguments.markup)>
<!--- <cfdump var="here"> --->
			<cfset this._variables = this._variablesFromString(loc.named_syntax.matches[3])>
			<cfset this._name = loc.named_syntax.matches[2]>
		<cfelseif loc.simple_syntax.match(arguments.markup)>
<!--- <cfdump var="here2"> --->
			<cfset this._variables = this._variablesFromString(arguments.markup)>
			<cfset this._name = "'#ArrayToList(this._variables, '')#'">
		<cfelse>
			<cfset createObject("component", "LiquidException").init("Syntax Error in 'cycle' - Valid syntax: cycle [name :] var [, var2, var3 ...]")>
		</cfif>
<!--- <Cfdump var="#this._variables#">
<Cfdump var="#this._name#">
<cfdump var="#loc.named_syntax.matches#">
<cfdump var="#loc.simple_syntax.matches#"> --->
		<cfreturn this>
	</cffunction>

	<cffunction name="render" hint="Renders the tag">
		<cfargument name="context" type="any" required="true" hint="LiquidContext">
		<cfset var loc = {}>
<!--- <Cfdump var="#this._name#"> --->
		<cfset arguments.context.push()>
		
		<cfset loc.key = arguments.context.get(this._name)>
<!--- <cfdump var="key:#loc.key#"> --->
		<cfif
			StructKeyExists(arguments.context, "registers")
			AND StructKeyExists(arguments.context.registers, "cycle")
			AND StructKeyExists(arguments.context.registers.cycle, loc.key)>
<!--- <cfdump var="isset">
<cfdump var="#arguments.context.registers.cycle#"> --->
			<cfset loc.iteration = arguments.context.registers['cycle'][loc.key]>
		<cfelse>
<!--- <cfdump var="not isset"> --->
			<cfset loc.iteration = 1>
		</cfif>

		<cfset loc.result = arguments.context.get(this._variables[loc.iteration])>
<!--- <cfdump var="#this._variables#">
<cfdump var="results: #loc.result#"> --->
		<cfset loc.iteration += 1>
<!--- <cfdump var="iteration: #loc.iteration#"> --->
		<cfif loc.iteration gt ArrayLen(this._variables)>
<!--- <cfdump var="iteration reseted:#loc.iteration#"> --->
			<cfset loc.iteration = 1>
		</cfif>
		
		<cfset arguments.context.registers['cycle'][loc.key] = loc.iteration>
<!--- <cfdump var="#arguments.context.registers['cycle']#"> --->
		<cfset arguments.context.pop()>
		
		<cfreturn loc.result>
	</cffunction>

	<cffunction name="_variablesFromString" hint="Extract variables from a string of markup">
		<cfargument name="markup" type="string" required="true">
		<cfset var loc = {}>
		
		<cfset loc.regexp = createObject("component", "LiquidRegexp").init('\s*(#application.LiquidConfig.LIQUID_QUOTED_FRAGMENT#)\s*')>
		<cfset loc.parts = ListToArray(arguments.markup, ',')>
		<cfset loc.result = []>
		
		<cfloop array="#loc.parts#" index="loc.part">
			<cfset loc.regexp.match(loc.part)>
			
			<cfif len(loc.regexp.matches[2])>
				<cfset ArrayAppend(loc.result, loc.regexp.matches[2])>
			</cfif>
		</cfloop>
		
		<cfreturn loc.result>
	</cffunction>
		
</cfcomponent>