<cfcomponent output="false">

	<cfinclude template="utils.cfm">
	
	<cfset this.matches = []>
	<cfset this.pattern = "">

	<cffunction name="init">
		<cfargument name="pattern" type="string" required="true">
		<cfset this.pattern = arguments.pattern>
		<cfreturn this>
	</cffunction>

	<cffunction name="scan" hint="Returns an array of matches for the string in the same way as Ruby's scan method">
		<cfargument name="str" type="string" required="true">
		<cfset var loc = {}>
		
		<cfset loc.results = []>
		
		<cfset loc.matches = preg_match_all(this.pattern, arguments.str)>
		
		<cfif ArrayIsEmpty(loc.matches)>
			<cfreturn loc.results>
		</cfif>

		<cfif ArrayLen(loc.matches) eq 1>
			<cfreturn loc.matches[1]>
		</cfif>
		
		<cfset loc.temp = array_shift(loc.matches)>
		<cfset loc.matches = loc.temp.arr>
		<cfset loc.match = loc.temp.value>

		<cfloop from="1" to="#ArrayLen(loc.matches)#" index="loc.m">
			<cfloop from="1" to="#ArrayLen(loc.matches[loc.m])#" index="loc.i">
				<cfif ArrayLen(loc.results) neq loc.i>
					<cfset loc.results[loc.i] = []>
				</cfif>
				<cfset ArrayAppend(loc.results[loc.i], loc.matches[loc.m][loc.i])>
			</cfloop>
		</cfloop>

		<cfreturn loc.results>
	</cffunction>

	<cffunction name="match" hint="Matches the given string. Only matches once.">
		<cfargument name="str" type="string" required="true">
		<cfset var loc = {}>
		<cfset this.matches = preg_match(this.pattern, arguments.str)>
		<cfreturn not ArrayIsEmpty(this.matches)>
	</cffunction>

	<cffunction name="match_all" hint="Matches the given string. Matches all.">
		<cfargument name="str" type="string" required="true">
		<cfset this.matches = preg_match_all(this.pattern, arguments.str)>
		<cfreturn ArrayLen(this.matches)>
	</cffunction>

	<cffunction name="split" hint="Splits the given string">
		<cfargument name="str" type="string" required="true">
		<cfargument name="limit" type="numeric" required="false" default="0">
		<cfset var matches = pregSplit(this.pattern, arguments.str, arguments.limit, false)>
<!--- <cfdump var="#arguments.str#" label="splite">
<cfdump var="#matches#" label="splite"> --->
<!--- <cfabort> --->
		<cfreturn matches>
	</cffunction>
	
</cfcomponent>