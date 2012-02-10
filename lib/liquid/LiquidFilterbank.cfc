<cfcomponent output="false" hint="The filter bank is where all registered filters are stored, and where filter invocation is handled it supports a variety of different filter types; objects, class, and simple methods">

	<!--- The registerd filter objects --->
	<cfset this.filters = {}>

	<!--- A map of all filters and the class that contain them (in the case of methods) --->
	<cfset this.method_map = {}>

	<!--- Reference to the current context object --->
	<cfset this.context = "">

	<cffunction name="init">
		<cfargument name="context" type="any" required="true">
		<cfset var standardFilters = createObject("component", "LiquidStandardFilters").init()>
		<cfset this.context = arguments.context>
		<cfset this.add_filter(standardFilters)>
		
		<cfreturn this>
	</cffunction>

	<cffunction name="add_filter" hint="Adds a filter to the bank" returntype="boolean">
		<cfargument name="filter" type="any" required="true" hint="Can either be an object, the name of a class (in which case the filters will be called statically) or the name of a function">
		<cfset var loc = {}>
		
		<!--- if the passed filter was an object, store the object for future reference. --->
		<cfif isObject(arguments.filter)>
			
			<cfset arguments.filter.context = this.context>
			<cfset loc.name = getMetaData(arguments.filter).name>
			<cfset this.filters[loc.name] = arguments.filter>
			
			<cfloop collection="#arguments.filter#" item="loc.method">
				<cfset this.method_map[loc.method] = loc.name>
			</cfloop>
			
			<cfset arguments.filter = loc.name>
			<cfreturn true>
			
		</cfif>

		<!--- if it wasn't an object an isn't a string either, it's a bad parameter --->
		<cfif isSimpleValue(arguments.filter) AND IsCustomFunction(arguments.filter)>
			<cfset this.method_map[arguments.filter] = false>
			<cfreturn true>
		</cfif>
		
		<cfthrow type="LiquidError" message="Parameter passed to add_filter must be an object or a the name of a method">
	</cffunction>

	<cffunction name="invoke_method" hint="Invokes the filter with the given name">
		<cfargument name="name" type="string" required="true" hint="The name of the filter">
		<cfargument name="value" type="string" required="true" hint="The value to filter">
		<cfargument name="args" type="any" required="true" hint="The additional arguments for the filter">

		<cfif !IsStruct(arguments.args)>
			<cfset arguments.args = {}>
		</cfif>
		
		<cfset StructInsert(arguments.args, arguments.value, "")>
		
		<!--- consult the mapping  --->
		<cfif StructKeyExists(this.method_map, arguments.name)>
			<cfset loc.class = this.method_map[arguments.name]>

			<!--- if we have a registered object for the class, use that instead --->
			<cfif StructKeyExists(this.filters, arguments.class)>
				<cfset loc.class = this.filters[loc.class]>
			</cfif>
			
			<!--- if we're calling a function --->
			<cfif loc.class eq false>
				<cfinvoke method="#arguments.name#" argumentcollection="#argumetns#" returnvariable="loc.ret">
				<cfreturn loc.ret>
			<cfelse>
				<cfinvoke component="#loc.class#" method="#arguments.name#" argumentcollection="#argumetns#" returnvariable="loc.ret">
				<cfreturn loc.ret>
			</cfif>
		</cfif>
		
		<cfreturn arguments.value>
	</cffunction>

</cfcomponent>