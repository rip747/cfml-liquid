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
		<cfset loc.results = ReMatchNoCase(this.pattern, arguments.str)>
<!--- 
		if (count($matches) == 1)
		{
			return $matches[0];
		}
		
		array_shift($matches);
		
		$result = array();
		
		foreach($matches as $match_key => $sub_matches)
		{
			foreach($sub_matches as $sub_match_key => $sub_match)
			{
				$result[$sub_match_key][$match_key] = $sub_match;
			}
		}
 --->
		<cfreturn loc.results>
	</cffunction>

	<cffunction name="match" hint="Matches the given string. Only matches once.">
		<cfargument name="str" type="string" required="true">
		<cfset var loc = {}>
		<cfset loc.m = ReMatchNoCase(this.pattern, arguments.str)>
		<cfif !ArrayIsEmpty(loc.m)>
			<cfset loc.t = loc.m[1]>
			<cfset this.matches = [loc.t]>
			<cfset loc.ret = true>
		</cfif>
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
		<cfreturn pregSplit(this.pattern, arguments.str, arguments.limit, false)>
	</cffunction>
	
</cfcomponent>