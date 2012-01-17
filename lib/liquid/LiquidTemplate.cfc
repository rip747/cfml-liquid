<cfcomponent output="false" hint="
The template class.

$tpl = new LiquidTemplate();
$tpl->parse(template_source);
$tpl->render(array('foo'=>1, 'bar'=>2);
">

	<cfinclude template="utils.cfm">

	<cffunction name="init">
		<cfargument name="path" type="string" required="false" default="">
		
		<!--- LiquidDocument The _root of the node tree --->
		<cfset variables._root = "">
		
		<!--- LiquidBlankFileSystem The file system to use for includes --->
		<cfset variables._fileSystem = "">
		
		<!--- array Globally included filters --->
		<cfset variables._filters = []>
		
		<!--- struct Custom tags --->
		<cfset variables._tags = {}>
		
		<cfif len(arguments.path) AND directoryExists(arguments.path)>
			<cfset variables._fileSystem = createObject("component", "LiquidLocalFileSystem").init(arguments.path)>
		<cfelse>
			<cfset variables._fileSystem = createObject("component", "LiquidBlankFileSystem").read_template_file>
		</cfif>
		
		<!--- cache --->
		<cfset variables._cache = startCache()>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getCache">
		<cfreturn variables._cache>
	</cffunction>

	<cffunction name="getRoot">
		<cfreturn variables._root>
	</cffunction>
	
	<cffunction name="getTags">
		<cfreturn variables._tags>
	</cffunction>
	
	<cffunction name="startCache">
		<cfif !StructKeyExists(application, application.LiquidConfig.LIQUID_CACHE_KEY)>
			<cfset application[application.LiquidConfig.LIQUID_CACHE_KEY] = {}>
		</cfif>
		<cfreturn application[application.LiquidConfig.LIQUID_CACHE_KEY]>
	</cffunction>
	
	<cffunction name="registerTag">
		<cfargument name="name" type="string" required="true">
		<cfargument name="obj" type="any" required="true">
		<cfset variables._tags[arguments.name] = arguments.obj>
	</cffunction>

	<cffunction name="registerFilter">
		<cfargument name="filter" type="any" required="true">
		<cfset arrayAppend(variables._filters, arguments.filter)>
	</cffunction>

	<cffunction name="tokenize" hint="Tokenizes the given source string">
		<cfargument name="source" type="string" required="true">
		<!--- <cfset arguments.source = trim(arguments.source)> --->
		<cfif !len(arguments.source)>
			<cfreturn arrayNew(1)>
		</cfif>
		<cfset arguments.source = pregSplit(application.LiquidConfig.LIQUID_TOKENIZATION_REGEXP, arguments.source)>
		<cfreturn arguments.source>
	</cffunction>

	<cffunction name="parse" hint="Parses the given source string">
		<cfargument name="source" type="string" required="true">
		<!--- <cfset var loc = {}> --->
		<cfset loc.key = hash(arguments.source)>
		<cfif !structIsEmpty(variables._cache)>
			<cfif structKeyExists(variables._cache, loc.key) AND variables._root eq variables._cache[loc.key] AND variables._root.checkIncludes() eq false>
				<!--- haven't a clue yet --->
			<cfelse>
				<cfset variables._root = createObject("component", "LiquidDocument").init(
						this.tokenize(arguments.source)
						,variables._fileSystem
					)>
				<cfset variables._cache[loc.key] = variables._root>
			</cfif>
		<cfelse>
<!--- 			<cfset variables._root = createObject("component", "LiquidDocument").init(
					this.tokenize(arguments.source)
					,variables._fileSystem
				)> --->
		</cfif>
		<cfreturn this>
	</cffunction>

	<cffunction name="render" hint="Renders the current template">
		<cfargument name="assigns" type="array" required="true" hint="An array of values for the template">
		<cfargument name="filters" type="any" required="false" default="" hint="Additional filters for the template">
		<cfargument name="registers" type="any" required="false" default="" hint="Additional registers for the template">
		<cfset var loc = {}>
		<cfset loc.context = createObject("component", "LiquidContext").init(arguments.assigns, arguments.registers)>

		<cfif !isSimpleValue(arguments.filters) OR len(arguments.filters)>		
			<cfif isArray(arguments.filters)>
				<cfset variables._filters.addAll(arguments.filters)>
			<cfelse>
				<cfset arrayAppend(variables._filters, arguments.filters)>
			</cfif>
		</cfif>
	
		<cfloop array="#variables._filters#" index="loc.filter">
			<cfset loc.context.addFilters(loc.filter)>
		</cfloop>

		<cfreturn variables._root.render(loc.context)>		
	</cffunction>

</cfcomponent>