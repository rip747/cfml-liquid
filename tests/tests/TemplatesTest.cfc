<cfcomponent output="false" extends="cfml-liquid.tests.Test">
	
	<cffunction name="setup">
		<cfset loc.obj = application.liquid.template()>
	</cffunction>

	<cffunction name="test_tokenize_strings">
		
		<cfset loc.e = [' ']>
		<cfset loc.r = loc.obj.tokenize(' ')>
		<cfset assert('arrayCompare(loc.e, loc.r)')>

		<cfset loc.e = ['hello world']>
		<cfset loc.r = loc.obj.tokenize('hello world')>
		<cfset assert('arrayCompare(loc.e, loc.r)')>
		
	</cffunction>
 	
	<cffunction name="test_tokenize_variables">
		
 		<cfset loc.e = ['{{funk}}']>
		<cfset loc.r = loc.obj.tokenize('{{funk}}')>
		<cfset assert('arrayCompare(loc.e, loc.r)')>

		<cfset loc.e = [' ', '{{funk}}', ' ']>
		<cfset loc.r = loc.obj.tokenize(' {{funk}} ')>
		<!--- <cfset debug('loc.e')><cfset debug('loc.r')> --->
		<cfset assert('arrayCompare(loc.e, loc.r)')>
 		
 		<cfset loc.e = [' ', '{{funk}}', ' ', '{{so}}', ' ', '{{brother}}', ' ']>
		<cfset loc.r = loc.obj.tokenize(' {{funk}} {{so}} {{brother}} ')>
		<cfset assert('arrayCompare(loc.e, loc.r)')>
		
		<cfset loc.e = [' ', '{{  funk  }}', ' ']>
		<cfset loc.r = loc.obj.tokenize(' {{  funk  }} ')>
		<cfset assert('arrayCompare(loc.e, loc.r)')>

	</cffunction>

	<cffunction name="test_tokenize_blocks">
		
		<cfset loc.e = ['{%comment%}']>
		<cfset loc.r = loc.obj.tokenize('{%comment%}')>
		<cfset assert('arrayCompare(loc.e, loc.r)')>
		
		<cfset loc.e = [' ', '{%comment%}', ' ']>
		<cfset loc.r = loc.obj.tokenize(' {%comment%} ')>
		<cfset assert('arrayCompare(loc.e, loc.r)')>
		
		<cfset loc.e = [' ', '{%comment%}', ' ', '{%endcomment%}', ' ']>
		<cfset loc.r = loc.obj.tokenize(' {%comment%} {%endcomment%} ')>
		<cfset assert('arrayCompare(loc.e, loc.r)')>
		
		<cfset loc.e = ['  ', '{% comment %}', ' ', '{% endcomment %}', ' ']>
		<cfset loc.r = loc.obj.tokenize('  {% comment %} {% endcomment %} ')>
		<cfset assert('arrayCompare(loc.e, loc.r)')>

	</cffunction>
		
</cfcomponent>