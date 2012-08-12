<cfcomponent output="false">
	
	<cfset this.version = "1.1">
	
	<cfset this.config = {}>
	
	<!--- directory the library is in --->
	<cfset this.config.LIQUID_DIR_PATH =  $liquidDirPath()>

	<cfset this.config.LIQUID_LIB_PATH = ListChangeDelims(this.config.LIQUID_DIR_PATH, ".", "/")>

	<!--- The method is called on objects when resolving variables to see if a given property exists --->
	<cfset this.config.LIQUID_HAS_PROPERTY_METHOD = "field_exists">

	<!--- This method is called on object when resolving variables when a given property exists --->
	<cfset this.config.LIQUID_GET_PROPERTY_METHOD = "get">

	<!--- Separator between filters --->
	<cfset this.config.LIQUID_FILTER_SEPARATOR = "\|">

	<!--- Separator for arguments --->
	<cfset this.config.LIQUID_ARGUMENT_SEPARATOR = ",">
	
	<!--- Separator for argument names and values --->
	<cfset this.config.LIQUID_FILTER_ARGUMENT_SEPARATOR = ":">
	
	<!--- Separator for variable attributes --->
	<cfset this.config.LIQUID_VARIABLE_ATTRIBUTE_SEPARATOR = ".">
	
	<!--- Suffix for include files --->
	<cfset this.config.LIQUID_INCLUDE_SUFFIX = "liquid">
	
	<!--- Prefix for include files --->
	<cfset this.config.LIQUID_INCLUDE_PREFIX = "_">
	
	<!--- Tag start --->
	<cfset this.config.LIQUID_TAG_START = "\{\%">
	
	<!--- Tag end --->
	<cfset this.config.LIQUID_TAG_END = "\%\}">
	
	<!--- Variable start --->
	<cfset this.config.LIQUID_VARIABLE_START = "\{\{">
	
	<!--- Variable end --->
	<cfset this.config.LIQUID_VARIABLE_END = "\}\}">
	
	<!--- Variable Signature --->
	<cfset this.config.LIQUID_VARIABLE_SIGNATURE = "[\(\w\-\.\[\]\)]">
		
	<!--- The characters allowed in a variable --->
	<cfset this.config.LIQUID_ALLOWED_VARIABLE_CHARS = "[a-zA-Z_.-]">
	
	<!--- Regex for quoted fragments --->
	<cfset this.config.LIQUID_QUOTED_STRING = '"[^"]*"|''[^'']*'''>
	
	<!--- Regex for quoted fragments --->
	<cfset this.config.LIQUID_QUOTED_FRAGMENT = '#this.config.LIQUID_QUOTED_STRING#|(?:[^\s,\|''"]|#this.config.LIQUID_QUOTED_STRING#)+'>
	
	<!--- Regex for recognizing tab attributes --->
	<cfset this.config.LIQUID_TAG_ATTRIBUTES = "(\w+)\s*:\s*(#this.config.LIQUID_QUOTED_FRAGMENT#)">
	
	<!--- Regex used to split tokens --->
	<cfset this.config.LIQUID_TOKENIZATION_REGEXP = "(#this.config.LIQUID_TAG_START#.*?#this.config.LIQUID_TAG_END#|#this.config.LIQUID_VARIABLE_START#.*?#this.config.LIQUID_VARIABLE_END#)">

	<cfset this.config.LIQUID_PATH = expandPath(".")>
	
	<cffunction name="init">
		<cfargument name="config" type="struct" required="false" default="#structNew()#">
		<cfset structAppend(this.config, arguments.config)>
		<cfset application["LiquidConfig"] = {}>
		<cfset StructAppend(application["LiquidConfig"], this.config)>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="template" hint="return a template object">
		<cfargument name="path" type="string" required="false" default="">
		<cfset var templateObj = createObject("component", "liquid.LiquidTemplate").init(
			path = arguments.path
		)>
		<cfreturn templateObj>
	</cffunction>
	
	<cffunction name="$liquidDirPath" access="private">
		<cfset var loc = {}>
		<!--- get paths --->
		<cfset loc.rootPath = expandPath('/')>
		<cfset loc.thisPath = GetDirectoryFromPath(GetCurrentTemplatePath())>
		<!--- os file system compatability --->
		<cfset loc.rootPath = lcase(ListChangeDelims(loc.rootPath, '/', '\'))>
		<cfset loc.thisPath = lcase(ListChangeDelims(loc.thisPath, '/', '\'))>
		<cfset loc.liquidDirPath = ReplaceNoCase(loc.thisPath, loc.rootPath, '', 'one')>
		<cfreturn ListAppend(loc.liquidDirPath, 'liquid', '/')>
	</cffunction>
	
</cfcomponent>