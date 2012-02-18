<cfcomponent output="false" extends="LiquidBlock" hint="
 * Loops over an array, assigning the current value to a given variable
 * 
 * @example
 * {%for item in array%} {{item}} {%endfor%}
 * 
 * With an array of 1, 2, 3, 4, will return 1 2 3 4
 * 
 * @package Liquid
">

	<!--- The collection to loop over --->
	<cfset this._collectionName = "">
	
	<!--- The variable name to assign collection elements to --->
	<cfset this._variableName = "">

	<!--- The name of the loop, which is a compound of the collection and variable names --->
	<cfset this._name = "">

	<cffunction name="init">
		<cfargument name="markup" type="string" required="true">
		<cfargument name="tokens" type="array" required="true">
		<cfargument name="file_system" type="any" required="true" hint="LiquidFileSystem">
		<cfset var loc = {}>

		<cfset super.init(arguments.markup, arguments.tokens, arguments.file_system)>
	
		<cfset loc.syntax_regexp = createObject("component", "LiquidRegexp").init('(\w+)\s+in\s+(#application["LiquidConfig"]["LIQUID_ALLOWED_VARIABLE_CHARS"]#+)')>
		
		<cfif loc.syntax_regexp.match(arguments.markup)>

			<cfset this._variableName = loc.syntax_regexp.matches[2]>
			<cfset this._collectionName = loc.syntax_regexp.matches[3]>
			<cfset this._name = loc.syntax_regexp.matches[2] & '-' & loc.syntax_regexp.matches[3]>
			<cfset this.extract_attributes(arguments.markup)>
			
		<cfelse>		
			<cfset createobject("component", "LiquidException").init("Syntax Error in 'for loop' - Valid syntax: for [item] in [collection]")>
		</cfif>

		<cfreturn this>
	</cffunction>
	
	<cffunction name="render">
		<cfargument name="context" type="any" required="true" hint="LiquidContext">
		<cfset var loc = {}>
		
		<cfset loc.results = "">

		<cfif !IsDefined("arguments.context.registers") OR !StructKeyExists(arguments.context.registers, "for")>
			<cfset arguments.context.registers["for"] = {}>
		</cfif>
		
		<cfset loc.collection = arguments.context.get(this._collectionName)>
		
		<cfif
			!StructKeyExists(loc, "collection")
			OR IsSimpleValue(loc.collection)
			OR IsStruct(loc.collection)
			OR (IsArray(loc.collection) AND ArrayIsEmpty(loc.collection))
			OR (IsQuery(loc.collection) AND loc.collection.recordcount eq 0)>
			<cfreturn "">
		</cfif>
		
		<cfset arguments.context.push()>		
	
		<cfif IsArray(loc.collection)>
			<cfset loc.result = _renderArray(loc.collection, arguments.context)>
		<cfelseif IsQuery(loc.collection)>
			<cfset loc.result = _renderQuery(loc.collection, arguments.context)>
		</cfif>
	
		<cfset arguments.context.pop()>
		
		<cfreturn loc.result>
	</cffunction>
	
	<cffunction name="_renderArray">
		<cfargument name="collection" type="array" required="true">
		<cfargument name="context" type="any" required="true">
		<cfset var loc = {}>
		
		<cfset loc.result = "">
		<cfset loc.range = [0, ArrayLen(arguments.collection)]>
		
		<cfif StructKeyExists(this.attributes, "limit") OR StructKeyExists(this.attributes, "offset")>

			<cfset loc.offset = 0>
			<cfset loc.limit = 0>
			
			<cfif StructKeyExists(this.attributes, 'offset')>
			
				<cfif this.attributes['offset'] eq "continue">
					<cfset loc.offset = arguments.context.registers['for'][this._name]>
				<cfelse>
					<cfset loc.offset = arguments.context.get(this.attributes['offset'])>
				</cfif>
				
				<cfif loc.offset GTE ArrayLen(arguments.collection)>
					<cfset loc.offset = ArrayLen(arguments.collection)>
				</cfif>
				
				<cfset loc.offset = abs(fix(val(loc.offset)))>
				
			</cfif>

			<cfif StructKeyExists(this.attributes, 'limit')>
				
				<cfset loc.limit = arguments.context.get(this.attributes['limit'])>
				<cfset loc.limit = abs(fix(val(loc.limit)))>
				
			</cfif>
			
			<cfif loc.limit gt 0>
				<cfset loc.limit = loc.limit + loc.offset>
			</cfif>
			
			<cfif loc.limit GTE ArrayLen(arguments.collection)>
				
				<cfset loc.limit = ArrayLen(arguments.collection)>
			</cfif>

			<cfif loc.limit gt 0 AND loc.limit lte ArrayLen(arguments.collection)>
				<cfset loc.range_end = loc.limit>
			<cfelse>
				<cfset loc.range_end = ArrayLen(arguments.collection)>
			</cfif>
			
			<cfset loc.range = [loc.offset, loc.range_end]>
			<cfset arguments.context.registers['for'][this._name] = loc.range_end>

		</cfif>
		
		<cfset arguments.collection = createObject("java", "java.util.ArrayList").Init(arguments.collection).subList(JavaCast("int", loc.range[1]), JavaCast("int", loc.range[2]))>
		
		<cfset loc.length = ArrayLen(arguments.collection)>

		<cfloop from="1" to="#loc.length#" index="loc.index">

			<cfset arguments.context.set(this._variableName, arguments.collection[loc.index])>
			<cfset loc.temp = {}>
			<cfset loc.temp.name = this._name>
			<cfset loc.temp.length = loc.length>
			<cfset loc.temp.index = loc.index>
			<cfset loc.temp.index0 = loc.index - 1>
			<cfset loc.temp.rindex = loc.length - loc.index + 1>
			<cfset loc.temp.rindex0 = loc.length - loc.index>
			<cfset loc.temp.first = IIf(loc.index eq 1, de(1), de(0))>
			<cfset loc.temp.last = IIF(loc.index eq (loc.length), de(1), de(0))>
			<cfset arguments.context.set('forloop', loc.temp)>
			<cfset loc.result &= this.render_all(this._nodelist, arguments.context)>
			
		</cfloop>
		
		<cfreturn loc.result>
	</cffunction>
	
	<cffunction name="_renderQuery">
		<cfargument name="collection" type="query" required="true">
		<cfargument name="context" type="any" required="true">
		<cfset var loc = {}>

		<cfset loc.result = "">
		<cfset loc.range = [0, arguments.collection.recordcount]>
		<cfset loc.length = arguments.collection.recordcount>
		<cfset loc.columnList = arguments.collection.columnlist>
		
		<cfloop from="1" to="#loc.length#" index="loc.index">
			
			<cfset loc.segment = {}>
			
			<cfloop list="#loc.columnList#" index="loc.column">
				<cfset loc.segment[loc.column] = arguments.collection[loc.column][loc.index]>
			</cfloop>

			<cfset arguments.context.set(this._variableName, loc.segment)>
			<cfset loc.temp = {}>
			<cfset loc.temp.name = this._name>
			<cfset loc.temp.length = loc.length>
			<cfset loc.temp.index = loc.index>
			<cfset loc.temp.index0 = loc.index - 1>
			<cfset loc.temp.rindex = loc.length - loc.index + 1>
			<cfset loc.temp.rindex0 = loc.length - loc.index>
			<cfset loc.temp.first = IIf(loc.index eq 1, de(1), de(0))>
			<cfset loc.temp.last = IIF(loc.index eq (loc.length), de(1), de(0))>
			<cfset arguments.context.set('forloop', loc.temp)>
			<cfset loc.result &= this.render_all(this._nodelist, arguments.context)>
			
		</cfloop>
		<cfreturn loc.result>
	</cffunction>
	
</cfcomponent>