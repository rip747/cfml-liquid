<cfcomponent output="false" hint="The filter bank is where all registered filters are stored, and where filter invocation is handled it supports a variety of different filter types; objects, class, and simple methods">

	<!--- The registerd filter objects --->
	<cfset this.filters = {}>

	<!--- A map of all filters and the class that contain them (in the case of methods) --->
	<cfset this.method_map = {}>

	<!--- Reference to the current context object --->
	<cfset this.context = "">

	<cffunction name="init">
		<cfargument name="context" type="any" required="true">

		<cfset this.context = arguments.context>
		<cfset this.add_filter("LiquidStandardFilters")>
		
		<cfreturn this>
	</cffunction>

	<cffunction name="add_filter" hint="Adds a filter to the bank" returntype="boolean">
		<cfargument name="filter" type="any" required="true" hint="Can either be an object, the name of a class (in which case the filters will be called statically) or the name of a function">
		<cfset var loc = {}>
		
		<cfif not IsObject(arguments.filter) AND !isSimpleValue(arguments.filter)>
			<cfset createObject("component", "LiquidException").init("Parameter passed to add_filter must be an object or a string")>
		</cfif>
		
		<!--- if the passed filter was an object, store the object for future reference. --->
		<cfif isObject(arguments.filter)>
			
			<cfset arguments.filter.context = this.context>
			<cfset loc.name = getMetaData(arguments.filter).name>
			<cfset this.filters[loc.name] = arguments.filter>
			<cfset arguments.filter = loc.name>
			
		</cfif>
		
		<cftry>
			<cfset loc.methods = getComponentMetaData(arguments.filter).functions>
			<cfcatch type="any">
				<cfset loc.methods = []>
			</cfcatch>
		</cftry>

		<cfif !ArrayIsEmpty(loc.methods)>
			<cfloop array="#loc.methods#" index="loc.method">
				<cfif loc.method.name neq "init">
					<cfset this.method_map[loc.method.name] = arguments.filter>
				</cfif>
			</cfloop>
			<cfreturn true>
		</cfif>
				
		<!--- if it wasn't an object an isn't a string either, it's a bad parameter --->
		<cfif IsCustomFunction(arguments.filter)>
			<cfset this.method_map[arguments.filter] = false>
			<cfreturn true>
		</cfif>

		<cfset createObject("component", "LiquidException").init("Parameter passed to add_filter must a class or a function")>
	</cffunction>

	<cffunction name="invoke_method" hint="Invokes the filter with the given name">
		<cfargument name="name" type="string" required="true" hint="The name of the filter">
		<cfargument name="value" type="any" required="true" hint="The value to filter">
		<cfargument name="args" type="any" required="true" hint="The additional arguments for the filter">

		<cfif !IsArray(arguments.args)>
			<cfset arguments.args = []>
		</cfif>

		<cfset ArrayPrepend(arguments.args, arguments.value)>

		<!--- consult the mapping  --->
		<cfif StructKeyExists(this.method_map, arguments.name)>
			<cfset loc.class = this.method_map[arguments.name]>

			<!--- if we have a registered object for the class, use that instead --->
			<cfif StructKeyExists(this.filters, loc.class)>
				<cfset loc.class = this.filters[loc.class]>
			</cfif>

			<!--- if we're calling a function --->
			<cfif IsSimpleValue(loc.class) and loc.class eq false>
				<cfset loc.method_args = build_method_args(arguments.args, arguments.name)>
				<cfinvoke method="#arguments.name#" argumentcollection="#loc.method_args#" returnvariable="loc.ret">
				<cfreturn loc.ret>
			<cfelse>
				<cfset loc.method_args = build_method_args(arguments.args, arguments.name, loc.class)>
				<cfinvoke component="#loc.class#" method="#arguments.name#" argumentcollection="#loc.method_args#" returnvariable="loc.ret">
				<cfreturn loc.ret>
			</cfif>
		</cfif>
		<cfreturn arguments.value>
	</cffunction>
	
	<cffunction name="build_method_args" returntype="struct">
		<cfargument name="args" type="array" required="true">
		<cfargument name="method" type="string" required="true">
		<cfargument name="class" type="any" required="false">
		<cfset var loc = {}>
		<cfset loc.ret = {}>

		<cfif StructKeyExists(arguments, "class")>
		
			<cfif IsObject(arguments.class)>
				<cfset loc.class_methods = getMetaData(arguments.class).functions>
			<cfelse>
				<cfset loc.class_methods = getComponentMetaData(arguments.class).functions>
			</cfif>

			<cfloop array="#loc.class_methods#" index="loc.class_method">
				<cfif loc.class_method.name eq arguments.method>
					<cfset loc.method_args = loc.class_method.parameters>
					<cfbreak>
				</cfif>
			</cfloop>
			
		<cfelse>
		
			<cfset loc.method_args = getMetaData(arguments.name).parameters>
			
		</cfif>
		
		<cfset loc.counter = ArrayLen(loc.method_args)>
		<cfset loc.args_counter = ArrayLen(arguments.args)>
		
		<cfloop from="1" to="#loc.counter#" index="loc.i">
			<cfif loc.args_counter gte loc.i>
				<cfset loc.method_arg = loc.method_args[loc.i].name>
				<cfset loc.ret[loc.method_arg] = arguments.args[loc.i]>
			</cfif>
		</cfloop>
		
		<cfreturn loc.ret>
	</cffunction>

</cfcomponent>