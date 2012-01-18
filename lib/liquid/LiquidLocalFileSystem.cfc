<cfcomponent output="false" extends="LiquidBlankFileSystem" hint="This implements an abstract file system which retrieves template files named in a manner similar to Rails partials, ie. with the template name prefixed with an underscore. The extension '.liquid' is also added. For security reasons, template paths are only allowed to contain letters, numbers, and underscore.">

	<cffunction name="init">
		<cfargument name="root" type="string" required="true">
		<cfset this._root = arguments.root>
	</cffunction>

	<cffunction name="read_template_file" hint="Retrieve a template file">
		<cfargument name="template_path" type="string" required="true">
		<cfset var loc = {}>

		<cfset loc.full_path = this.full_path(arguments.templatePath)>
		<cffile action="read" file="#loc.fullpath#" variable="loc.contents">

		<cfreturn loc.contents>
	</cffunction>

	<cffunction name="full_path" hint="Resolves a given path to a full template file path, making sure it's valid">
		<cfargument name="template_path" type="string" required="true">
		<cfset var loc = {}>
		
		<cfset loc.pathArr = ListToArray(arguments.template_path, "/")>
		<cfset loc.pathArr[ArrayLen(loc.path)] = "#application.LiquidConfig.LIQUID_INCLUDE_PREFIX##loc.pathArr[ArrayLen(loc.pathArr)]#.#application.LiquidConfig.LIQUID_INCLUDE_SUFFIX#">
		
		<cfset arrayAppend(loc.pathArr, this._root)>
		
		<cftry>
			<cfset loc.path = ExpandPath(ArrayToList(loc.pathArr, "/"))>
			<cfcatch type="Any">
				<cfthrow type="LiquidError" message="Invalid Path">
			</cfcatch>
		</cftry>
		
		<cfset loc.rootFullPath = expandPath(this._root)>
		
		<cfif left(loc.path, len(loc.rootFullPath)) neq loc.rootFullPath>
			<cfthrow type="LiquidError" message="Illegal template path '#loc.path#'">
		</cfif>
		
		<cfreturn loc.path>
	</cffunction>
	
</cfcomponent>