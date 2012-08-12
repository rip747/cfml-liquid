<cfcomponent extends="LiquidBlock" hint="
 temporarily disable tag processing to avoid syntax conflicts.

example:
{% raw %}{% comment %} test {% endcomment %}{% endraw %}

will render:
{% comment %} test {% endcomment %}
">

	<cffunction name="parse">
		<cfargument name="tokens" type="array" required="true">
		<cfset var loc = {}>
		<cfset loc.tag_regexp = createObject("component", "LiquidRegexp").init('^#application.LiquidConfig.LIQUID_TAG_START#\s*(\w+)\s*(.*)?#application.LiquidConfig.LIQUID_TAG_END#$')>
		
		<cfif !IsArray(arguments.tokens)>
			<cfreturn>
		</cfif>
		
		<cfloop condition="#ArrayLen(arguments.tokens)#">
			
			<cfset loc.temp = array_shift(arguments.tokens)>
			<cfset arguments.tokens = loc.temp.arr>
			<cfset loc.token = loc.temp.value>
			<cfset loc.tag_regexp.match(loc.token)>

			<cfif loc.tag_regexp.match(loc.token)>

				<!--- if we found the proper block delimitor just end parsing here and let the outer block proceed  --->
				<cfif loc.tag_regexp.matches[2] eq this.block_delimiter()>
					<cfreturn this.end_tag()>
				</cfif>

			</cfif>

			<cfset arrayAppend(this._nodelist, loc.token)>

		</cfloop>

		<cfset this.assert_missing_delimitation()>
	</cffunction>
	
</cfcomponent>