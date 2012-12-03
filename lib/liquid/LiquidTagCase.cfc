<cfcomponent output="false" extends="LiquidDecisionBlock" hint="
A switch statememt

@example
{% case condition %}{% when foo %} foo {% else %} bar {% endcase %}
">

	<cffunction name="init">
		<cfargument name="markup" type="string" required="true">
		<cfargument name="tokens" type="array" required="true">
		<cfargument name="file_system" type="any" required="true" hint="LiquidFileSystem">
		<cfset var loc = {}>
		
		<cfset this.nodelists = []>
		<cfset this.left = "">
		<cfset this.right = "">
		
		<cfset super.init(arguments.markup, arguments.tokens, arguments.file_system)>
		
		<cfset loc.syntax_regexp = createObject("component", "LiquidRegexp").init(application.LiquidConfig.LIQUID_QUOTED_FRAGMENT)>
		
		<cfif loc.syntax_regexp.match(arguments.markup)>
			<cfset this.left = loc.syntax_regexp.matches[1]>
		<cfelse>
			<cfset createObject("component", "LiquidException").init("Syntax Error in tag 'case' - Valid syntax: case [condition]")>
		</cfif>
		
		<cfreturn this>
	</cffunction>

	<cffunction name="end_tag" hint="Pushes the last nodelist onto the stack">
		<cfset this.push_nodelist()>
	</cffunction>

	<cffunction name="unknown_tag" hint="Unknown tag handler">
		<cfargument name="tag" type="string" required="true">
		<cfargument name="params" type="any" required="true">
		<cfargument name="tokens" type="array" required="true">
		<cfset var loc = {}>

		<cfset loc.when_syntax_regexp = createObject("component", "LiquidRegexp").init(application.LiquidConfig.LIQUID_QUOTED_FRAGMENT)>

		<cfswitch expression="#arguments.tag#">
			<cfcase value="when">

				<!--- push the current nodelist onto the stack and prepare for a new one --->
				<cfif loc.when_syntax_regexp.match(arguments.params)>

					<cfset this.push_nodelist()>
					<cfset this.right = loc.when_syntax_regexp.matches[1]>
					<cfset this._nodelist = []>

				<cfelse>
					<cfset createObject("component", "LiquidException").init("Syntax Error in tag 'case' - Valid when condition: when [condition]")>
				</cfif>

			</cfcase>
			<cfcase value="else">

				<!--- push the last nodelist onto the stack and prepare to recieve the else nodes --->
				<cfset this.push_nodelist()>
				<cfset this.right = "">
				
				<cfif !StructKeyExists(this, "else_nodelist")>
					<cfset this.else_nodelist = []>
				</cfif>
				
				<cfset this.else_nodelist = this._nodelist>
				<cfset this._nodelist = []>

			</cfcase>
			<cfdefaultcase>
				<cfset super.unknown_tag(arguments.tag, arguments.params, arguments.tokens)>
			</cfdefaultcase>
		</cfswitch>
	</cffunction>

	<cffunction name="push_nodelist" hint="Pushes the current right value and nodelist into the nodelist stack">
		<cfset var loc = {}>

		<cfif len(this.right)>
			<cfset loc.temp = [this.right, this._nodelist]>
			<cfset ArrayAppend(this.nodelists, loc.temp)>
		</cfif>
	</cffunction>

	<cffunction name="render" hint="Renders the node">
		<cfargument name="context" type="any" required="true" hint="LiquidContext">
		<cfset var loc = {}>

		<cfset loc.output = "">
		<cfset loc.run_else_block = true>

		<cfloop array="#this.nodelists#" index="loc.data">
			<cfset loc.right = loc.data[1]>
			<cfset loc.nodelist = loc.data[2]>
			
			<cfif this.equal_variables(this.left, loc.right, arguments.context)>
				<cfset loc.run_else_block = false>
				
				<cfset arguments.context.push()>
				<cfset loc.output &= this.render_all(loc.nodelist, arguments.context)>
				<cfset arguments.context.pop()>
			</cfif>
		</cfloop>

		<cfif loc.run_else_block AND StructKeyExists(this, "else_nodelist")>

			<cfset arguments.context.push()>
			<cfset loc.output &= this.render_all(this.else_nodelist, arguments.context)>
			<cfset arguments.context.pop()>
			
		</cfif>

		<cfreturn loc.output>
	</cffunction>
	
	<cffunction name="pushToNodeList">
		<cfif StructKeyExists(this, "else_nodelist")>
			<cfset this.else_nodelist = this._nodelist>
		</cfif>
	</cffunction>
	
</cfcomponent>