<cfcomponent output="false" extends="cfml-liquid.tests.Test">
	
	<cffunction name="setup">
		<cfset loc.liquid = createObject("component", "cfml-liquid.lib.Liquid").init()>
		<cfset loc.regex = createObject("component", "cfml-liquid.lib.liquid.LiquidRegexp").init(application.LiquidConfig.LIQUID_QUOTED_FRAGMENT)>
	</cffunction>

	<cffunction name="test_empty">
		<cfset loc.e = []>
		<cfset loc.r = loc.regex.scan('')>
		<cfset debug('loc.e')><cfset debug('loc.r')>
		<cfset assert('arrayCompare(loc.e, loc.r)')>
	</cffunction>
	
	<cffunction name="test_quote">
		<cfset loc.e = ['"arg 1"']>
		<cfset loc.r = loc.regex.scan('"arg 1"')>
		<cfset assert('arrayCompare(loc.e, loc.r)')>
	</cffunction>
	
	<cffunction name="test_words">
		<cfset loc.e = ['arg1', 'arg2']>
		<cfset loc.r = loc.regex.scan('arg1 arg2')>
		<cfset assert('arrayCompare(loc.e, loc.r)')>
	</cffunction>
	
 	<cffunction name="test_quoted_words">
		<cfset loc.e = ['arg1', 'arg2', '"arg 3"']>
		<cfset loc.r = loc.regex.scan('arg1 arg2 "arg 3"')>
		<cfset assert('arrayCompare(loc.e, loc.r)')>
	</cffunction>
 	
	<cffunction name="test_quoted_words2">
		<cfset loc.e = ['arg1', 'arg2', "'arg 3'"]>
		<cfset loc.r = loc.regex.scan('arg1 arg2 ''arg 3''')>
		<cfset assert('arrayCompare(loc.e, loc.r)')>
	</cffunction>
 	
	<cffunction name="test_quoted_words_in_the_middle">
		<cfset loc.e = ['arg1', 'arg2', '"arg 3"', 'arg4']>
		<cfset loc.r = loc.regex.scan('arg1 arg2 "arg 3" arg4   ')>
		<cfset assert('arrayCompare(loc.e, loc.r)')>
	</cffunction>

</cfcomponent>