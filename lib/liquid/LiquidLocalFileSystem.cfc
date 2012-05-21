<cfcomponent output="false" extends="LiquidBlankFileSystem" hint="This implements an abstract file system which retrieves template files named in a manner similar to Rails partials, ie. with the template name prefixed with an underscore. The extension '.liquid' is also added. For security reasons, template paths are only allowed to contain letters, numbers, and underscore.">

	<cffunction name="init">
		<cfargument name="root" type="string" required="true">
		
		<cfset this.root = ListChangeDelims(arguments.root, "/", "\")>
		
		<cfreturn this>
	</cffunction>

	<cffunction name="read_template_file" hint="Retrieve a template file">
		<cfargument name="template_path" type="string" required="true">
		<cfset var loc = {}>

		<cfset loc.full_path = this.full_path(arguments.template_path)>
		<cffile action="read" file="#ExpandPath(loc.full_path)#" variable="loc.contents">

		<cfreturn loc.contents>
	</cffunction>

	<cffunction name="full_path" hint="Resolves a given path to a full template file path, making sure it's valid">
		<cfargument name="template_path" type="string" required="true">
		<cfset var loc = {}>

		<cfset loc.name_regex = createObject("component", "LiquidRegexp").init('^[^\.\/][a-zA-Z0-9_\/]+$')>
		
		<cfif !loc.name_regex.match(arguments.template_path)>
			<cfset createObject("component", "LiquidException").init("Illegal template name '#arguments.template_path#'")>
		</cfif>

		<cfif FindNoCase('/', arguments.template_path) neq 0>
			<cfset loc.full_path = [GetDirectoryFromPath(arguments.template_path), "#application.LiquidConfig.LIQUID_INCLUDE_PREFIX##ListLast(arguments.template_path, '/')#.#application.LiquidConfig.LIQUID_INCLUDE_SUFFIX#"]>
		<cfelse>
			<cfset loc.full_path = ["#application.LiquidConfig.LIQUID_INCLUDE_PREFIX##arguments.template_path#.#application.LiquidConfig.LIQUID_INCLUDE_SUFFIX#"]>
		</cfif>
		
		<cfset loc.full_path = this.root & ListChangeDelims(ArrayToList(loc.full_path, "/"), "/", "/")>
		
		<!--- convert to full path --->
		<cftry>
			<cfset loc._full_path = ExpandPath(loc.full_path)>
			<cfset loc._root = ExpandPath(this.root)>
			
			<cfif left(loc._full_path, len(loc._root)) neq loc._root>
				<cfset createObject("component", "LiquidException").init("Illegal template path #loc.full_path#")>
			</cfif>
			
			<cfcatch type="any">
				<cfset createObject("component", "LiquidException").init("Illegal template path #loc.full_path#")>
			</cfcatch>
		</cftry>
		
		<cfreturn loc.full_path>
	</cffunction>
	
</cfcomponent>