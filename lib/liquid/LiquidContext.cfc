<cfcomponent output="false" hint="Context keeps the variable stack and resolves variables, as well as keywords">

	<cfinclude template="utils.cfm">

	<cffunction name="init">
		<cfargument name="assigns" type="struct" required="false" default="#Createobject('java', 'java.util.LinkedHashMap').init()#">
		<cfargument name="registers" type="struct" required="false" default="#StructNew()#">
		
		
		<cfset this.registers = arguments.registers>
		<cfset this.assigns = arguments.assigns>
		<cfset this.filterbank = createObject("component", "LiquidFilterbank").init(this)>
		<cfset this.environments = {}>
		<cfset this.scopes = [this.assigns]>
		<!--- <cfset ArrayAppend(this.scopes, )> --->

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
		<cfset StructAppend(this.assigns, arguments.new_assigns, true)>
	</cffunction>

	<cffunction name="push" hint="Push new local scope on the stack.">
<!--- <cfdump var="#this.scopes#" label="context::push 1"> --->
		<cfif ArrayIsEmpty(this.scopes)>
			<cfreturn false>
		</cfif>
		<cfset ArrayPrepend(this.scopes, StructNew())>
		<cfset this.assigns = this.scopes[1]>
<!--- <cfdump var="#this.scopes#" label="context::push 2"> --->
		<cfreturn true>
	</cffunction>

	<cffunction name="pop" hint="Pops the current scope from the stack.">
<!--- <cfdump var="#this.scopes#" label="context::pop 1"> --->
		<cfif ArrayLen(this.scopes) eq 1>
			<cfset createObject("component", "LiquidException").init('No elements to pop')>
		</cfif>
		
		<cfset ArrayDeleteAt(this.scopes, 1)>
		<cfset this.assigns = this.scopes[1]>
<!--- <cfdump var="#this.scopes#" label="context::pop 2"> --->
		<cfif StructIsEmpty(this.assigns)>
			<cfreturn "">
		</cfif>

		<cfreturn true>
	</cffunction>

	<cffunction name="get" hint="Replaces []">
		<cfargument name="key" type="string" required="true">
<!--- <cfdump var="context::get - #arguments.key#"> --->
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
	
		<cfif arguments.key eq "true">
			<cfreturn true>
		</cfif>
		
		<cfif arguments.key eq "false">

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
<!--- <cfdump var="here1"> --->
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
	
	<cffunction name="fetch_recursions">
		<cfargument name="key" type="string" required="true">
	
	
	</cffunction>

	<cffunction name="parse" returntype="any" hint="Resolved the namespaced queries gracefully.">
		<cfargument name="key" type="string" required="true">
		<cfset var loc = {}>

		<!--- Support [0] style array indicies --->
<!--- 		<cfset loc.matches = preg_match("|\[[0-9]+\]|", arguments.key)>
		<cfif !ArrayIsEmpty(loc.matches)>
			<cfset arguments.key = ReReplace(arguments.key, "|\[([0-9]+)\]|", "\1", "all")>
		</cfif> --->

		<cfset loc.parts = ListToArray(arguments.key, application.LiquidConfig.LIQUID_VARIABLE_ATTRIBUTE_SEPARATOR)>
		<cfset loc.temp = array_shift(loc.parts)>
		<cfset loc.parts = loc.temp.arr>
		<cfset loc.object = this.fetch(loc.temp.value)>

		<cfif isObject(loc.object)>
			<cfif !StructKeyExists(loc.object, "toLiquid")>
				<cfthrow type="LiquidError" message="Method 'toLiquid' not exists!">
			</cfif>
			<cfset loc.object = loc.object.toLiquid()>
		</cfif>
<!--- <cfdump var="#loc#"><cfabort> --->
		<cfif !IsSimpleValue(loc.object) OR len(loc.object)>

			<cfloop array="#loc.parts#" index="loc.part">
				
				<cfif IsInstanceOf(loc.object, "LiquidDrop")>
					<cfset loc.object.setContext(this)>
				</cfif>
				
				<cfif loc.part eq "size">
				
					<cfif IsArray(loc.object)>
						<cfset loc.object = ArrayLen(loc.object)>
					<cfelseif IsQuery(loc.object)>
						<cfset loc.object = loc.object.recordcount>
					<cfelseif IsSimpleValue(loc.object)>
						<cfset loc.object = len(loc.object)>
					<cfelseif IsStruct(loc.object)>
						<cfset loc.object = StructCount(loc.object)>
					</cfif>

				<cfelseif IsStruct(loc.object) AND StructKeyExists(loc.object, loc.part)>
				
					<cfset loc.object = loc.object[loc.part]>
				
				<cfelseif isObject(loc.object)>
				
					<cfif IsInstanceOf(loc.object, "LiquidDrop")>
					
						<cfset loc.object = loc.object.invokeDrop(loc.part)>
						
					<cfelseif StructKeyExists(loc.object, application.LiquidConfig.LIQUID_HAS_PROPERTY_METHOD) AND IsCustomFunction(loc.part)>
						
						<cfset loc.args = {method = loc.part}>
						<cfinvoke component="#loc.object#" method="#application.LiquidConfig.LIQUID_GET_PROPERTY_METHOD#" argumentcollection="#loc.args#" returnvariable="loc.object">

					<cfelse>
					
						<!--- if it's just a regular object, attempt to access a property --->
						<cfif !StructKeyExists(loc.object, loc.next_part_name)>
							<cfreturn "">	
						</cfif>
						<cfset loc.object = evaluate("#loc.object#.#loc.part#()")>

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
<!--- <cfdump var="#loc#"><cfabort> --->
	</cffunction>
	
	<cffunction name="inspect">
		<cfreturn this>
	</cffunction>
	
</cfcomponent>