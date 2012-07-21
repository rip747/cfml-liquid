<cfcomponent output="false" hint="Context keeps the variable stack and resolves variables, as well as keywords">

	<cfinclude template="utils.cfm">

	<cffunction name="init">
		<cfargument name="assigns" type="struct" required="false" default="#StructNew()#">
		<cfargument name="registers" type="struct" required="false" default="#StructNew()#">
				
		<cfset this.registers = arguments.registers>
		<cfset this.assigns = arguments.assigns>
		<cfset this.filterbank = createObject("component", "LiquidFilterbank").init(this)>
		<cfset this.environments = {}>
		<cfset this.scopes = [this.assigns]>

		<cfreturn this>
	</cffunction>

	<cffunction name="add_filters" hint="Add a filter to the context">
		<cfargument name="filter" type="any" required="true">
		<cfset this.filterbank.add_filter(arguments.filter)>
	</cffunction>

	<cffunction name="invoke_method" hint="Invoke the filter that matches given name">
		<cfargument name="name" type="string" required="true" hint="The name of the filter">
		<cfargument name="value" type="any" required="true" hint="The value to filter">
		<cfargument name="args" type="array" required="false" default="#ArrayNew(1)#" hint="Additional arguments for the filter">
		<cfreturn this.filterbank.invoke_method(arguments.name, arguments.value, arguments.args)>
	</cffunction>

	<cffunction name="merge" hint="Merges the given assigns into the current assigns">
		<cfargument name="new_assigns" type="struct" required="true">
		<cfset StructAppend(this.scopes[1], arguments.new_assigns, true)>
	</cffunction>

	<cffunction name="push" hint="Push new local scope on the stack.">
		
		<cfif ArrayIsEmpty(this.scopes)>
			<cfreturn false>
		</cfif>
		<cfset ArrayPrepend(this.scopes, StructNew())>
		<cfset this.assigns = this.scopes[1]>
		
		<cfreturn true>
	</cffunction>

	<cffunction name="pop" hint="Pops the current scope from the stack.">
		
		<cfif ArrayLen(this.scopes) eq 1>
			<cfset createObject("component", "LiquidException").init('No elements to pop')>
		</cfif>
		
		<cfset ArrayDeleteAt(this.scopes, 1)>
		<cfset this.assigns = this.scopes[1]>
		<cfif StructIsEmpty(this.assigns)>
			<cfreturn "">
		</cfif>

		<cfreturn true>
	</cffunction>

	<cffunction name="get" hint="Replaces []">
		<cfargument name="key" type="string" required="true">
		<cfreturn this.resolve(arguments.key)>
	</cffunction>

	<cffunction name="set" hint="Replaces []=">
		<cfargument name="key" type="string" required="true">
		<cfargument name="value" type="any" required="true">
		<cfset this.assigns[arguments.key] = arguments.value>
	</cffunction>

	<cffunction name="has_key" returntype="boolean" hint="Returns true if the given key will properly resolve">
		<cfargument name="key" type="string" required="true">
		<cfreturn !!len(this.resolve(arguments.key))>
	</cffunction>

	<cffunction name="resolve" returntype="any" hint="Resolve a key by either returning the appropriate literal or by looking up the appropriate variable. Test for empty has been moved to interpret condition, in LiquidDecisionBlock">
		<cfargument name="key" type="string" required="true">
		<cfset var loc = {}>

		<cfif !len(arguments.key) OR arguments.key eq "null">		
			<cfreturn "">
		</cfif>
	
		<cfif !IsNumeric(arguments.key) AND IsBoolean(arguments.key) and arguments.key eq "true">
			<cfreturn true>
		</cfif>
		
		<cfif !IsNumeric(arguments.key) AND IsBoolean(arguments.key) and arguments.key eq "false">
			<cfreturn false>
		</cfif>
		
		<cfset loc.temp = preg_match("^'(.*)'$", arguments.key)>
		<cfif !ArrayIsEmpty(loc.temp)>
			<cfreturn loc.temp[2]>
		</cfif>

		<cfset loc.temp = preg_match('^"(.*)"$', arguments.key)>
		<cfif !ArrayIsEmpty(loc.temp)>
			<cfreturn loc.temp[2]>
		</cfif>

		<cfset loc.temp = preg_match('^(\d+)$', arguments.key)>
		<cfif !ArrayIsEmpty(loc.temp)>
			<cfreturn loc.temp[2]>
		</cfif>

		<cfset loc.temp = preg_match('^(\d[\d\.]+)$', arguments.key)>
		<cfif !ArrayIsEmpty(loc.temp)>
			<cfreturn loc.temp[2]>
		</cfif>

		<cfreturn this.parse(arguments.key)>		
	</cffunction>

	<cffunction name="fetch" hint="Fetches the current key in all the scopes">
		<cfargument name="key" type="string" required="true">
		<cfset var loc = {}>
		
		<cfloop collection="#this.environments#" item="loc.environment">
			<cfif StructKeyExists(loc.environment, arguments.key)>
				<cfreturn loc.environment[arguments.key]>
			</cfif>
		</cfloop>

		<cfloop array="#this.scopes#" index="loc.scope">

			<cfif StructKeyExists(loc.scope, arguments.key)>

				<cfset loc.obj = loc.scope[arguments.key]>
				<cfif IsInstanceof(loc.obj, "LiquidDrop")>
					<cfset loc.obj.setContext(this)>
				</cfif>
				<cfreturn loc.obj>
			</cfif>

		</cfloop>
		
		<cfreturn "">
	</cffunction>

	<cffunction name="parse" returntype="any" hint="Resolved the namespaced queries gracefully.">
		<cfargument name="key" type="string" required="true">
		<cfset var loc = {}>
		
		<!--- Support [0] style array indicies --->
		<cfif ReFindNoCase("|\[[0-9]+\]|", arguments.key)>
			<cfset arguments.key = ReReplaceNoCase(arguments.key, "|\[([0-9]+)\]|", ".\1")>
		</cfif>

		<cfset loc.parts = ListToArray(arguments.key, application.LiquidConfig.LIQUID_VARIABLE_ATTRIBUTE_SEPARATOR)>
		<cfset loc.temp = array_shift(loc.parts)>
		<cfset loc.parts = loc.temp.arr>
		<cfset loc.object = this.fetch(loc.temp.value)>

		<cfif isObject(loc.object)>
			<cfif !IsInstanceof(loc.object, "LiquidDrop") AND !StructKeyExists(loc.object, "toLiquid")>
				<cfthrow type="LiquidError" message="Method 'toLiquid' not exists!">
			</cfif>
			<cfset loc.object = loc.object.toLiquid()>
		</cfif>

		<cfif !IsSimpleValue(loc.object) OR len(loc.object)>

			<cfloop condition="#ArrayLen(loc.parts)# gt 0">

				<cfif IsInstanceOf(loc.object, "LiquidDrop")>
					<cfset loc.object.setContext(this)>
				</cfif>
				
				<cfset loc.temp = array_shift(loc.parts)>
				<cfset loc.parts = loc.temp.arr>
				<cfset loc.next_part_name = loc.temp.value>

				<cfif !IsObject(loc.object)>
				
					<cfif
						loc.next_part_name eq 'size'
						AND ArrayLen(loc.parts) eq 0
						AND (
								(IsStruct(loc.object) || IsObject(loc.object)) AND !StructKeyExists(loc.object, "size")
								OR (IsArray(loc.object) || IsQuery(loc.object))
						)>
						<cfif IsArray(loc.object)>
							<cfreturn ArrayLen(loc.object)>
						<cfelseif IsQuery(loc.object)>
							<cfreturn loc.object.recordcount>
						<cfelseif IsSimpleValue(loc.object)>
							<cfreturn len(loc.object)>
						<cfelseif IsStruct(loc.object)>
							<cfreturn StructCount(loc.object)>
						</cfif>
					</cfif>
					<cfif StructKeyExists(loc.object, loc.next_part_name)>
						<cfset loc.object = loc.object[loc.next_part_name]>
					<cfelse>
						<cfreturn "">
					</cfif>
				
				<cfelseif isObject(loc.object)>
				
					<cfif IsInstanceOf(loc.object, "LiquidDrop")>
					
						<cfset loc.object = loc.object.invokeDrop(loc.next_part_name)>

					<cfelseif StructKeyExists(loc.object, application.LiquidConfig.LIQUID_HAS_PROPERTY_METHOD) AND IsCustomFunction(loc.next_part_name)>

						<cfset loc.args = {method = loc.next_part_name}>
						<cfinvoke component="#loc.object#" method="#application.LiquidConfig.LIQUID_GET_PROPERTY_METHOD#" argumentcollection="#loc.args#" returnvariable="loc.object">

					<cfelse>
					
						<!--- if it's just a regular object, attempt to access a property --->
						<cfif !StructKeyExists(loc.object, loc.next_part_name)>
							<cfreturn "">	
						</cfif>
						<cfinvoke component="#loc.object#" method="#loc.next_part_name#" returnvariable="loc.object">
					</cfif>
					
				</cfif>

				<cfif isObject(loc.object) AND StructKeyExists(loc.object, "toLiquid")>
					<cfset loc.object = loc.object.toLiquid()>
				</cfif>

			</cfloop>

			<cfreturn loc.object>
			
		<cfelse>

			<cfreturn "">
			
		</cfif>
	</cffunction>
	
	<cffunction name="inspect">
		<cfreturn this>
	</cffunction>
	
</cfcomponent>