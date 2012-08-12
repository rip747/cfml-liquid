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
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setFileSystem">
		<cfargument name="fileSystem" type="any" required="true">
		<cfset this._fileSystem = arguments.fileSystem>
	</cffunction>
	
	<cffunction name="getRoot">
		<cfreturn this._root>
	</cffunction>
	
	<cffunction name="getTags">
		<cfreturn this._tags>
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

		<!--- use a java array list since we need to pass the parsed token by reference. THIS IS THE KEY TO ALL OF THIS! --->
		<cfset loc.arr = CreateObject("java","java.util.ArrayList").Init()>

		<cfif !len(arguments.source)>
			<cfreturn loc.arr>
		</cfif>
		<!--- need to put the values from the returning array into our reference array --->
		<cfset arguments.source = pregSplit3(application.LiquidConfig.LIQUID_TOKENIZATION_REGEXP, arguments.source)>

		<cfloop array="#arguments.source#" index="loc.i">
			<cfset ArrayAppend(loc.arr, loc.i)>
		</cfloop>

		<cfreturn loc.arr>
	</cffunction>

	<cffunction name="parse" hint="Parses the given source string">
		<cfargument name="source" type="string" required="true">
		
		<cfset this._root = createObject("component", "LiquidDocument").init(
				this.tokenize(arguments.source)
				,this._fileSystem
			)>

		<cfreturn this>
	</cffunction>

	<cffunction name="render" hint="Renders the current template">
		<cfargument name="assigns" type="struct" required="false" default="#Createobject('java', 'java.util.LinkedHashMap').init()#" hint="A struct of values for the template">
		<cfargument name="filters" type="any" required="false" default="" hint="Additional filters for the template">
		<cfargument name="registers" type="any" required="false" default="#StructNew()#" hint="Additional registers for the template">
		<cfset var loc = {}>
		
 		<cftry>
			<cfset loc.result = _render(argumentCollection=arguments)>

			<cfcatch type="any">
				<cfset loc.result = cfcatch.message>
			</cfcatch>
		</cftry>

		<cfreturn loc.result>
	</cffunction>
	
	<cffunction name="_render" hint="Renders the current template. throws errors">
		<cfargument name="assigns" type="struct" required="false" default="#Createobject('java', 'java.util.LinkedHashMap').init()#" hint="A struct of values for the template">
		<cfargument name="filters" type="any" required="false" default="" hint="Additional filters for the template">
		<cfargument name="registers" type="any" required="false" default="#StructNew()#" hint="Additional registers for the template">
		<cfset var loc = {}>
		
		<cfset loc.result = "">
			
		<cfset loc.context = createObject("component", "LiquidContext").init(arguments.assigns, arguments.registers)>

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
		
		<cfset loc.result = this._root.render(loc.context)>

		<cfreturn loc.result>
	</cffunction>

</cfcomponent>