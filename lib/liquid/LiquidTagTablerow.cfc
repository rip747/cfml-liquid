<cfcomponent output="false" extends="LiquidBlock" hint="
Quickly create a table from a collection
">

	<cffunction name="init">
		<cfargument name="markup" type="string" required="true">
		<cfargument name="tokens" type="array" required="true">
		<cfargument name="file_system" type="any" required="true" hint="LiquidFileSystem">
		<cfset var loc = {}>
		
		<!--- The variable name of the table tag --->
		<cfset this.variable_name = "">
		
		<!--- The collection name of the table tags --->
		<cfset this.collection_name = "">
		
		<!--- Additional attributes --->
		<cfset this.attributes = []>
		
		<cfset super.init(arguments.markup, arguments.tokens, arguments.file_system)>
		
		<cfset loc.syntax = createObject("component", "LiquidRegexp").init("(\w+)\s+in\s+(#application.LiquidConfig.LIQUID_ALLOWED_VARIABLE_CHARS#+)")>
		
		<cfif loc.syntax.match(arguments.markup)>
			<cfset this.variable_name = loc.syntax.matches[2]>
			<cfset this.collection_name = loc.syntax.matches[3]>
			
			<cfset this.extract_attributes(arguments.markup)>
		<cfelse>
			<cfset createObject("component", "LiquidException").init("Syntax Error in 'table_row loop' - Valid syntax: table_row [item] in [collection] cols=3")>
		</cfif>
		
		<cfreturn this>
	</cffunction>

	<cffunction name="render">
		<cfargument name="context" type="any" required="true" hint="LiquidContext">
		<cfset var loc = {}>
		
		<cfset loc.collection = arguments.context.get(this.collection_name)>
		
		<cfif !StructKeyExists(loc, "collection") OR !IsArray(loc.collection) OR ArrayIsEmpty(loc.collection)>
			<cfreturn "">
		</cfif>
		
		<!--- discard keys --->
		<!--- TODO: do we even need this? --->
		$collection = array_values($collection);
		
		<cfif StructKeyExists(variables.attributes, "limit") OR StructKeyExists(variables.attributes, "offset")>
			<cfset loc.limit = arguments.context.get(this.attributes['limit'])>
			<cfset loc.offset = arguments.context.get(this.attributes['offset'])>
			<cfset loc.collection = createObject("java", "java.util.ArrayList").Init(loc.collection).subList(JavaCast("int", loc.offset), JavaCast("int", loc.limit))>
		</cfif>
		
		<cfset loc.length = ArrayLen(loc.collection)>
		
		<cfset loc.cols = arguments.context.get(this.attributes['cols'])>
		
		<cfset loc.row = 1>
		<cfset loc.col = 0>
		
		<cfset loc.result = '<tr class="row1">#chr(10)#'>
		
		<cfset arguments.context.push()>
		
		<cfloop from="1" to="#loc.length#" index="loc.index">
			
			<cfset arguments.context.set(this.variable_name, loc.collection[loc.index])>
			<cfset loc.temp = {}>
			<cfset loc.temp.name = variables._name>
			<cfset loc.temp.length = loc.length>
			<cfset loc.temp.index = loc.index + 1>
			<cfset loc.temp.index0 = loc.index>
			<cfset loc.temp.rindex = loc.length - loc.index>
			<cfset loc.temp.rindex0 = loc.length - loc.index - 1>
			<cfset loc.temp.first = IIf(loc.index eq 1, de(true), de(false))>
			<cfset loc.temp.last = IIF(loc.index eq (loc.length - 1), de(true), de(false))>
			<cfset arguments.context.set('tablerowloop', loc.temp)>
			
			<cfset loc.result &= '<td class="col#loc.col++#">' & this.render_all(this._nodelist, arguments.context) & "</td>">
			
			<cfif loc.col eq loc.cols AND not (loc.index eq loc.length - 1)>
				<cfset loc.col = 0>
				<cfset loc.result &= '</tr>#chr(10)#<tr class="row#loc.row++#">'>
			</cfif>
			
		</cfloop>
		
		<cfset arguments.context.pop()>
		
		<cfset loc.result &= "</tr>#chr(10)#">
		
		<cfreturn loc.result>
	</cffunction>

</cfcomponent>