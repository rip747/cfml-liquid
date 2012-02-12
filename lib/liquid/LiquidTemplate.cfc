<cfcomponent output="false" hint="
The template class.

$tpl = new LiquidTemplate();
$tpl->parse(template_source);
$tpl->render(array('foo'=>1, 'bar'=>2);
">

	<cfinclude template="utils.cfm">
	
		
	<!--- LiquidDocument The _root of the node tree --->
	<cfset this._root = "">
	
	<!--- LiquidBlankFileSystem The file system to use for includes --->
	<cfset this._fileSystem = "">
	
	<!--- array Globally included filters --->
	<cfset this._filters = []>
	
	<!--- struct Custom tags --->
	<cfset this._tags = {}>

	<cffunction name="init">
		<cfargument name="path" type="string" required="false" default="">

		<cfif len(arguments.path) AND directoryExists(arguments.path)>
			<cfset this._fileSystem = createObject("component", "LiquidLocalFileSystem").init(arguments.path)>
		<cfelse>
			<cfset this._fileSystem = createObject("component", "LiquidBlankFileSystem").init()>
		</cfif>

		<!--- cache --->
		<cfset startCache()>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setFileSystem">
		<cfargument name="fileSystem" type="any" required="true">
		<cfset this._fileSystem = arguments.fileSystem>
	</cffunction>
	
	
	<cffunction name="getCache">
		<cfreturn application[application.LiquidConfig.LIQUID_CACHE_KEY]>
	</cffunction>

	<cffunction name="getRoot">
		<cfreturn this._root>
	</cffunction>
	
	<cffunction name="getTags">
		<cfreturn this._tags>
	</cffunction>
	
	<cffunction name="startCache">
		<cfif !StructKeyExists(application, application.LiquidConfig.LIQUID_CACHE_KEY)>
			<cfset application[application.LiquidConfig.LIQUID_CACHE_KEY] = createObject("component", "LiquidCache").init()>
		</cfif>
		<cfreturn application[application.LiquidConfig.LIQUID_CACHE_KEY]>
	</cffunction>
	
	<cffunction name="registerTag">
		<cfargument name="name" type="string" required="true">
		<cfargument name="obj" type="any" required="true">
		<cfset this._tags[arguments.name] = arguments.obj>
	</cffunction>

	<cffunction name="registerFilter">
		<cfargument name="filter" type="any" required="true">
		<cfset arrayAppend(this._filters, arguments.filter)>
	</cffunction>

	<cffunction name="tokenize" hint="Tokenizes the given source string">
		<cfargument name="source" type="string" required="true">
		<cfset var loc = {}>
<!--- <cfdump var="#arguments.source#">	 --->
		<!--- use a java array list since we need to pass the parsed token by reference. THIS IS THE KEY TO ALL OF THIS! --->
		<cfset loc.arr = CreateObject("java","java.util.ArrayList").Init()>
		<cfif !len(arguments.source)>
			<cfreturn loc.arr>
		</cfif>
		<!--- need to put the values from the returning array into our reference array --->
<!--- <cfset loc.regex = CreateObject("java","java.util.regex.Pattern").compile(application.LiquidConfig.LIQUID_TOKENIZATION_REGEXP, 32)>
<cfdump var="#loc.regex.split(arguments.source)#"><cfabort> --->
		<cfset arguments.source = pregSplit3(application.LiquidConfig.LIQUID_TOKENIZATION_REGEXP, arguments.source)>
		<cfloop array="#arguments.source#" index="loc.i">
			<cfset ArrayAppend(loc.arr, loc.i)>
		</cfloop>
<!--- <cfdump var="#arguments.source#" label="tokenize">
<cfdump var="#loc.arr#" label="tokenize"> --->
<!--- <cfabort> --->
		<cfreturn loc.arr>
	</cffunction>

	<cffunction name="parse" hint="Parses the given source string">
		<cfargument name="source" type="string" required="true">
		<cfset var loc = {}>
		<cfset loc.key = hash(arguments.source)>
		<cfset loc.found = false>
		<cfset loc.cache = getCache()>
		<!--- <cfif !structIsEmpty(loc.cache)> --->
<!--- 			<cfif loc.cache.exists(loc.key) AND this._root.checkIncludes() neq true>
				<cfset this._root = loc.cache.read(loc.key)>
			<cfelse> --->
				<cfset this._root = createObject("component", "LiquidDocument").init(
						this.tokenize(arguments.source)
						,this._fileSystem
					)>
				<cfset loc.cache.write(loc.key, this._root)>
			<!--- </cfif> --->
<!--- 		<cfelse>

<!--- <cfdump var="#this.tokenize(arguments.source)#" label="Tokenized Source">
<cfdump var="#this._fileSystem#" label="File System"> --->
			<cfset this._root = createObject("component", "LiquidDocument").init(
					this.tokenize(arguments.source)
					,this._fileSystem
				)>
<!--- <cfdump var="#this._root#" label="Document Root"> --->
<!--- parse done<cfabort> --->
		</cfif> --->
<!--- 		here<cfdump var="#this._root#"><cfabort> --->
		<cfreturn this>
	</cffunction>

	<cffunction name="render" hint="Renders the current template">
		<cfargument name="assigns" type="struct" required="false" default="#Createobject('java', 'java.util.LinkedHashMap').init()#" hint="A struct of values for the template">
		<cfargument name="filters" type="any" required="false" default="" hint="Additional filters for the template">
		<cfargument name="registers" type="any" required="false" default="#StructNew()#" hint="Additional registers for the template">
		<cfset var loc = {}>
<!--- <cfdump var="#arguments#" label="template::render()::arguments"> --->
		<cfset loc.context = createObject("component", "LiquidContext").init(arguments.assigns, arguments.registers)>
<!--- <cfdump var="#arguments#">
<cfdump var="#loc.context.assigns#">
<cfabort> --->

		<cfif !isSimpleValue(arguments.filters)>
				
			<cfif isArray(arguments.filters)>
				<cfset this._filters.addAll(arguments.filters)>
			<cfelseif IsObject(arguments.filters)>
				<cfset arrayAppend(this._filters, arguments.filters)>
			</cfif>
		
		</cfif>
		
		<cfloop array="#this._filters#" index="loc.filter">
			<cfset loc.context.add_filters(loc.filter)>
		</cfloop>

<!--- <cfdump var="#this._root#" label="template::render()::root"> --->
<!--- <cfdump var="#loc.context#" label="template::render()::context"> --->
<!--- <cfabort> --->
		<cfreturn this._root.render(loc.context)>
	</cffunction>


</cfcomponent>