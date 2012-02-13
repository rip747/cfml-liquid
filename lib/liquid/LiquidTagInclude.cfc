<cfcomponent output="false" extends="LiquidTag" hint="
Includes another, partial, template

@example
{% include 'foo' %}

Will include the template called 'foo'

{% include 'foo' with 'bar' %}

Will include the template called 'foo', with a variable called foo that will have the value of 'bar'

{% include 'foo' for 'bar' %}

Will loop over all the values of bar, including the template foo, passing a variable called foo
with each value of bar
">

	<!--- The name of the template --->
	<cfset this.template_name = "">

	<!--- True if the variable is a collection --->
	<cfset this.collection = false>

	<!--- The value to pass to the child template as the template name --->
	<cfset this.variable = "">

	<!--- The LiquidDocument that represents the included template --->
	<cfset this.document = "">
	
	<cfset this._hash = "">	

	<cffunction name="init">
		<cfargument name="markup" type="string" required="true">
		<cfargument name="tokens" type="array" required="true">
		<cfargument name="file_system" type="any" required="true" hint="LiquidFileSystem">
		<cfset var loc = {}>
		
		<cfset loc.regex = createObject("component", "LiquidRegexp").init('("[^"]+"|''[^'']+'')(\s+(with|for)\s+(#application.LiquidConfig.LIQUID_QUOTED_FRAGMENT#))?')>
		
		<cfif loc.regex.match(arguments.markup)>

			<cfset this.template_name = mid(loc.regex.matches[2], 2, len(loc.regex.matches[2]) - 2)>
			
			<cfif ArrayLen(loc.regex.matches) gte 3 AND loc.regex.matches[3] eq "for">
				<cfset this.collection = true>
			</cfif>
			
			<cfif ArrayLen(loc.regex.matches) gte 4>
				<cfset this.variable = loc.regex.matches[4]>
			</cfif>

			<cfset this.extract_attributes(arguments.markup)>
		<cfelse>
			<cfset createObject("component", "LiquidException").init("Error in tag 'include' - Valid syntax: include '[template]' (with|for) [object|collection]")>
		</cfif>
		
		<cfset super.init(arguments.markup, arguments.tokens, arguments.file_system)>
		
		<cfreturn this>
	</cffunction>

	<cffunction name="parse">
		<cfargument name="tokens" type="array" required="true">
		<cfset var loc = {}>
		
		<cfif !StructKeyExists(this, "file_system")>
			<cfset createObject("component", "LiquidException").init("No file system")>
		</cfif>

		<!--- read the source of the template and create a new sub document --->
		<cfset loc.source = this.file_system.read_template_file(this.template_name)>

		<cfset this._hash = hash(loc.source)>

		<cfset loc.cache = application[application.LiquidConfig.LIQUID_CACHE_KEY]>

		<cfif IsDefined("loc.cache")>

<!--- 			<cfif loc.cache.exists(this._hash)>
				<cfset this.document = loc.cache.read(this._hash)>
			</cfif>
		
			<cfdump var="#this.document#"><cfabort>
			<cfif this.document.checkIncludes() eq true> --->
				<cfset loc.template = createObject("component", "LiquidTemplate")>
				<cfset this.document = createObject("component", "LiquidDocument").init(loc.template.tokenize(loc.source), this.file_system)>
				<cfset loc.s = createObject("component", "LiquidTemplate").tokenize(loc.source)>
				<cfset loc.cache.write(this._hash, this.document)>
			<!--- </cfif> --->
		<cfelse>
			<cfset this.document = createObject("component", "LiquidDocument").init(loc.s, this.file_system)>
		</cfif>
	</cffunction>

	<cffunction name="checkIncludes" hint="check for cached includes">
		<cfset var loc = {}>
		
		<cfset loc.cache = application[application.LiquidConfig.LIQUID_CACHE_KEY]>

		<cfif this.document.checkIncludes() eq true>
			<cfreturn true>
		</cfif>
	
		<cfset loc.source = this.file_system.read_template_file(this.template_name)>
		
		<cfif loc.cache.exists(hash5(loc.source)) AND this._hash eq hash(loc.source)>
			<cfreturn false>
		</cfif>
		
		<cfreturn true>
	</cffunction>

	<cffunction name="render">
		<cfargument name="context" type="any" required="true" hint="LiquidContext">
		<cfset var loc = {}>
		
		<cfset loc.result = "">
		<cfset loc.variable = arguments.context.get(this.variable)>
		
		<cfset arguments.context.push()>
		
		<cfloop collection="#this.attributes#" item="loc.key">
			<cfset arguments.context.set(loc.key, arguments.context.get(this.attributes[loc.key]))>
		</cfloop>
		
		<cfif this.collection>
			<cfloop array="#loc.variable#" index="loc.item">
				<cfset arguments.context.set(this.template_name, loc.item)>
				<cfset loc.result &= this.document.render(loc.context)>
			</cfloop>
		<cfelse>
			<cfif StructKeyExists(this, "variable")>
				<cfset arguments.context.set(this.template_name, loc.variable)>
			</cfif>
			
			<cfset loc.result &= this.document.render(arguments.context)>
		</cfif>
		
		<cfset arguments.context.pop()>
		
		<cfreturn loc.result>
	</cffunction>
	
</cfcomponent>