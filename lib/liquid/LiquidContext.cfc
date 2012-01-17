<cfcomponent output="false" hint="Context keeps the variable stack and resolves variables, as well as keywords">

	<cfinclude template="utils.cfm">

	<cffunction name="init">
		<cfargument name="registers" type="array" required="true">
		<cfargument name="assigns" type="any" required="false" default="#ArrayNew(1)#">

		<cfset this.registers = arguments.registers>
		<cfset this.assigns = [arguments.assigns]>
		<cfset this.filterbank = createObject("component", "LiquidFilterbank").init(this)>
		<cfset this.environments = {}>

		<cfreturn this>
	</cffunction>

	<cffunction name="add_filters" hint="Add a filter to the context">
		<cfargument name="filter" type="any" required="true">
		<cfset this.filterbank.add_filter(arguments.filter)>
	</cffunction>

	<cffunction name="invokeMethod" hint="Invoke the filter that matches given name">
		<cfargument name="name" type="string" required="true" hint="The name of the filter">
		<cfargument name="value" type="any" required="true" hint="The value to filter">
		<cfargument name="args" type="array" required="false" default="#ArrayNew(1)#" hint="Additional arguments for the filter">
		<cfreturn this.filterbank.invokeMethod(arguments.name, arguments.value, arguments.args)>
	</cffunction>

	<cffunction name="merge" hint="Merges the given assigns into the current assigns">
		<cfargument name="new_assigns" type="array" required="true">
		<cfset this.assigns.addAll(arguments.new_assigns)>
	</cffunction>

	<cffunction name="push" hint="Push new local scope on the stack.">
		<cfset arrayAppend(this.assign, ArrayNew(1))>
		<cfreturn true>
	</cffunction>

	<cffunction name="pop" hint="Pops the current scope from the stack.">
		<cfif ArrayLen(this.assigns) eq 1>
			<cfthrow type="LiquidError" message="No elements to pop">
		</cfif>
		<cfset ArrayDeleteAt(this.assigns, 1)>
		<cfreturn true>
	</cffunction>

	<cffunction name="get" hint="Replaces []">
		<cfargument name="key" type="string" required="true">
		<cfreturn this.resolve(arguments.key)>
	</cffunction>

	<cffunction name="set" hint="Replaces []=">
		<cfargument name="key" type="string" required="true">
		<cfargument name="value" type="any" required="true">
		<cfset this.assign[0][arguments.key] = arguments.value>
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
	
		<cfif arguments.key eq "true">
			<cfreturn true>
		</cfif>
		
		<cfif arguments.key eq "false">
			<cfreturn false>
		</cfif>
		
		<cfset loc.temp = preg_match("^\'(.*)\'$", arguments.key)>
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
		
		<cfreturn this.variable(arguments.key)>		
	</cffunction>

	<cffunction name="fetch" hint="Fetches the current key in all the scopes">
		<cfargument name="key" type="string" required="true">
		<cfset var loc = {}>
		
		<cfloop collection="#this.environments#" item="loc.environment">
			<cfif StructKeyExists(loc.environment, arguments.key)>
				<cfreturn loc.environment[arguments.key]>
			</cfif>
		</cfloop>
		
		<cfloop array="#this.assigns#" index="loc.scope">
			<cfif StructKeyExists(loc.scope, arguments.key)>
				<cfset loc.obj = loc.scope[arguments.key]>
				
				<cfif IsInstanceof(loc.obj, "LiquidDrop")>
					<cfset loc.obj.setContext(this)>
				</cfif>
				
				<cfreturn loc.obj>
			</cfif>
		</cfloop>
	</cffunction>

	<cffunction name="parse" returntype="any" hint="Resolved the namespaced queries gracefully.">
		<cfargument name="key" type="string" required="true">
		<cfset var loc = {}>

		<!--- Support [0] style array indicies --->
		<cfif preg_match("|\[[0-9]+\]|", arguments.key)>
			<cfset arguments.key = ReReplace(arguments.key, "|\[([0-9]+)\]|", ".$1")>
		</cfif>

		<cfset loc.parts = ListToArray(arguments.key, application.LiquidConfig.LIQUID_VARIABLE_ATTRIBUTE_SEPARATOR)>

		<cfset loc.temp = array_shift(loc.parts)>
		<cfset loc.parts = loc.temp.arr>
		<cfset loc.object = loc.temp.value>
		
		<cfif isObject(loc.object)>
			<cfif !StructKeyExists(loc.object, "toLiquid")>
				<cfthrow type="LiquidError" message="Method 'toLiquid' not exists!">
			</cfif>
			<cfset loc.object = loc.object.toLiquid()>
		</cfif>
		
		<cfif !IsSimpleValue(loc.object) OR len(loc.object)>
			<cfloop condition="#!ArrayIsEmpty(loc.parts)#">
				<cfif IsInstanceOf(loc.object, "LiquidDrop")>
					<cfset loc.object.setContext(this)>
				</cfif>
				
				<cfset loc.temp = array_shift(loc.parts)>
				<cfset loc.parts = loc.temp.arr>
				<cfset loc.next_part_name = loc.temp.value>
				
				<cfif isArray(loc.object)>
				
					<cfset loc.temp = ArrayToList(loc.object, chr(7))>
				
					<!--- if the last part of the context variable is .size we just return the count --->
					<cfif loc.next_part_name eq 'size' AND ArrayLen(loc.parts) eq 0 AND !ListFindNoCase(loc.object, "size", chr(7))>
						<cfreturn ArrayLen(loc.object)>
					</cfif>				
					
					<cfif ListFindNoCase(loc.object, loc.next_part_name, chr(7))>
						<cfset loc.object = loc.object[ListFindNoCase(loc.object, loc.next_part_name, chr(7))]>
					<cfelse>
						<cfreturn "">
					</cfif>
					
				<cfelseif isObject(loc.object)>
					<cfif IsInstanceOf(loc.object, "LiquidDrop")>
					
						<!--- if the object is a drop, make sure it supports the given method --->
						<cfif !loc.object.hasKey(loc.next_part_name)>
							<cfreturn "">
						</cfif>

						<cfset loc.object = loc.object.invokeDrop(loc.next_part_name)>
						
					<cfelseif StructKeyExists(loc.object, application.LiquidConfig.LIQUID_HAS_PROPERTY_METHOD)>
						
<!--- 						<cfif if(!call_user_method(application.LiquidConfig.LIQUID_HAS_PROPERTY_METHOD, $object, $next_part_name))
						{
							return null;
						} --->
						
						<cfinvoke component="#loc.object#" method="#application.LiquidConfig.LIQUID_GET_PROPERTY_METHOD#" returnvariable="loc.object">

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
	
</cfcomponent>