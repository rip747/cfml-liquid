<cfcomponent output="false" extends="LiquidDecisionBlock" hint="
An if statement
example
{% if true %} YES {% else %} NO {% endif %}

will return:
YES
">

	<cfset this._nodelistHolders = CreateObject("java","java.util.ArrayList").Init()>
	
	<cfset this._blocks = CreateObject("java","java.util.ArrayList").Init()>

	<cffunction name="init">
		<cfargument name="markup" type="string" required="true">
		<cfargument name="tokens" type="array" required="true">
		<cfargument name="file_system" type="any" required="true">
		<cfset var loc = {}>

		<cfset loc.temp = ['if', arguments.markup,  this._nodelist]>
		<cfset arrayAppend(this._blocks, loc.temp)>
		<cfset super.init(arguments.markup, arguments.tokens, arguments.file_system)>
		
		<cfreturn this>
	</cffunction>

	<cffunction name="unknown_tag" hint="Handler for unknown tags, handle else tags">
		<cfargument name="tag" type="string" required="true">
		<cfargument name="params" type="any" required="true">
		<cfargument name="tokens" type="any" required="true">
		<cfset var loc = {}>

		<cfif arguments.tag eq 'else' OR arguments.tag eq 'elsif' OR arguments.tag eq 'elseif'>

			<cfset this._blocks[ArrayLen(this._blocks)][3] = duplicate(this._nodelist)>
			<cfset this._nodelist = this._nodelistHolders>
			<cfset loc.temp = [arguments.tag, arguments.params, this._nodelist]>
			<cfset ArrayAppend(this._blocks, loc.temp)>
			<cfset ArrayClear(this._nodelist)>

		<cfelse>
			<cfset super.unknown_tag(arguments.tag, arguments.params, arguments.tokens)>
		</cfif>
	</cffunction>

	<cffunction name="render" hint="Render the tag">
		<cfargument name="context" type="any" required="true">
		<cfset var loc = {}>

		<cfset loc.logicalRegex = createObject("component", "LiquidRegexp").init("\s+(and|or)\s+")>
		<cfset loc.conditionalRegex = createObject("component", "LiquidRegexp").init('(#application["LiquidConfig"]["LIQUID_QUOTED_FRAGMENT"]#)\s*([=!<>a-z_]+)?\s*(#application["LiquidConfig"]["LIQUID_QUOTED_FRAGMENT"]#)?')>
		<cfset loc.result = "">

		<cfloop array="#this._blocks#" index="loc.block">

			<cfif loc.block[1] eq "else">
				
				<cfset loc.result = this.render_all(loc.block[3], arguments.context)>
				<cfset arguments.context.push()>
				<cfbreak>
				
			</cfif>

			<cfif loc.block[1] eq 'if' OR loc.block[1] eq 'elsif'OR loc.block[1] eq 'elseif'>
			
				<!--- Extract logical operators --->
				<cfset loc.logicalRegex.match(loc.block[2])>
				<cfset loc.logicalOperators = loc.logicalRegex.matches>
				<cfset loc.temp = array_shift(loc.logicalOperators)>
				<cfset loc.logicalOperators = loc.temp.arr>

				<!--- Extract individual conditions --->
				<cfset loc.temp = loc.logicalRegex.split(loc.block[2])>
				<cfset loc.conditions = []>

				<cfloop array="#loc.temp#" index="loc.condition">
					
					<cfif loc.conditionalRegex.match(loc.condition)>
					
						<cfset loc.t = {}>

						<cfset loc.t.left = "">
						<cfif ArrayLen(loc.conditionalRegex.matches) gte 2>
							<cfset loc.t.left = loc.conditionalRegex.matches[2]>
						</cfif>

						<cfset loc.t.operator = "">
						<cfif ArrayLen(loc.conditionalRegex.matches) gte 3>
							<cfset loc.t.operator = loc.conditionalRegex.matches[3]>
						</cfif>
						
						<cfset loc.t.right = "">
						<cfif ArrayLen(loc.conditionalRegex.matches) gte 4>
							<cfset loc.t.right = loc.conditionalRegex.matches[4]>
						</cfif>

						<cfset arrayAppend(loc.conditions, loc.t)>

					<cfelse>
						<cfthrow type="LiquidError" message="Syntax Error in tag 'if' - Valid syntax: if [condition]">
					</cfif>
					<cfset arguments.context.push()>
					
				</cfloop>
				
				<cfif ArrayLen(loc.logicalOperators)>

					<!--- If statement contains and/or --->
					<cfset loc.display = true>

					<cfloop from="1" to="#ArrayLen(loc.logicalOperators)#" index="loc.i">
						
						<cfset loc.t = loc.conditions[loc.i]>
						<cfset loc.iLeft = this.interpret_condition(loc.t['left'], loc.t['right'], loc.t['operator'], arguments.context)>
						<cfset loc.tt = loc.conditions[loc.i + 1]>
						<cfset loc.iRight = this.interpret_condition(loc.tt['left'], loc.tt['right'], loc.tt['operator'], arguments.context)>

						<cfif loc.logicalOperators[loc.i] eq 'and'>
							<cfset loc.display = loc.iLeft AND loc.iRight>
						<cfelse>
							<cfset loc.display = loc.iLeft OR loc.iRight>
						</cfif>
						
					</cfloop>

				<cfelse>
				
					<!--- If statement is a single condition --->
					<cfset loc.display = this.interpret_condition(loc.conditions[1]['left'], loc.conditions[1]['right'], loc.conditions[1]['operator'], arguments.context)>
					
				</cfif>

				<cfif (IsBoolean(loc.display) and loc.display) OR (!IsBoolean(loc.display) AND len(loc.display) AND loc.display neq "null")>
					
					<cfset loc.result = this.render_all(loc.block[3], arguments.context)>
					<cfset arguments.context.push()>
					<cfbreak>
					
				</cfif>
				
			</cfif>
		</cfloop>

		<cfset arguments.context.pop()>

		<cfreturn loc.result>
	</cffunction>

	<cffunction name="pushToNodeList">
		<cfset this._blocks[ArrayLen(this._blocks)][3] = this._nodelist>
	</cffunction>

</cfcomponent>