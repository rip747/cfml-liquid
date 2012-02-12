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
		
		<cfif !IsDefined("arguments.context.registers") OR !StructKeyExists(arguments.context.registers, "for")>
			<cfset arguments.context.registers["for"] = []>
		</cfif>
		
		<cfset loc.collection = arguments.context.get(this._collectionName)>

		<cfif !StructKeyExists(loc, "collection") OR !IsArray(loc.collection) OR ArrayIsEmpty(loc.collection)>
			<cfreturn "">
		</cfif>
		
		<!--- array(0, count($collection)) --->
		<cfif StructKeyExists(this.attributes, "limit") OR StructKeyExists(this.attributes, "offset")>
		
			<cfset loc.range = [ArrayLen(loc.collection), 0]>

			<cfset loc.offset = 0>
			
			<cfif StructKeyExists(this.attributes, 'offset')>
				<cfif this.attributes['offset'] eq "continue">
					<cfset loc.offset = arguments.context.registers['for'][this._name]>
				<cfelse>
					<cfset loc.offset = arguments.context.get(this.attributes['offset'])>
				</cfif>
			</cfif>
			
			<cfif StructKeyExists(this.attributes, 'limit')>
				<cfset loc.limit = arguments.context.get(this.attributes['limit'])>
			<cfelse>
				<cfset loc.limit = "">
			</cfif>
			
			<cfif IsNumeric(loc.limit)>
				<cfset loc.range_end = loc.limit>
			<cfelse>
				<cfset loc.range_end = ArrayLen(loc.collection) - loc.offset>
			</cfif>
			
			<cfset loc.range = [loc.offset, loc.range_end]>
			
			<cfset arguments.context.registers['for'][this._name] = loc.range_end + loc.offset>
			
			<cfset loc.collection = createObject("java", "java.util.ArrayList").Init(loc.collection).subList(JavaCast("int", loc.range[1]), JavaCast("int", loc.range[2]))>
			
		</cfif>
		
		<cfset loc.result = "">

		<cfif ArrayIsEmpty(loc.collection)>
			<cfreturn loc.result>
		</cfif>
		
		<cfset arguments.context.push()>
		
		<cfset loc.length = ArrayLen(loc.collection)>
<!--- <cfdump var="#loc.collection#"> --->
		<cfloop from="1" to="#loc.length#" index="loc.index">
<!--- <cfdump var="#arguments.context.assigns#"> --->
			<cfset arguments.context.set(this._variableName, loc.collection[loc.index])>
			<cfset loc.temp = {}>
			<cfset loc.temp.name = this._name>
			<cfset loc.temp.length = loc.length>
			<cfset loc.temp.index = loc.index + 1>
			<cfset loc.temp.index0 = loc.index>
			<cfset loc.temp.rindex = loc.length - loc.index>
			<cfset loc.temp.rindex0 = loc.length - loc.index - 1>
			<cfset loc.temp.first = IIf(loc.index eq 1, de(true), de(false))>
			<cfset loc.temp.last = IIF(loc.index eq (loc.length - 1), de(true), de(false))>
			<cfset arguments.context.set('forloop', loc.temp)>
<!--- <cfdump var="#arguments.context.assigns#"><cfabort> --->
			<cfset loc.result &= this.render_all(this._nodelist, arguments.context)>
			
		</cfloop>
	
		<cfset arguments.context.pop()>
		
		<cfreturn loc.result>
	</cffunction>
	
</cfcomponent>