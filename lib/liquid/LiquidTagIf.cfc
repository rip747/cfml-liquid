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
<!--- <cfdump var="#arguments#" label="Arguments = LiquidTagIf::Init"> --->

		<cfset loc.temp = ['if', arguments.markup,  this._nodelist]>
		<cfset arrayAppend(this._blocks, loc.temp)>

<!--- <cfdump var="#this._blocks#" label="blocks  = LiquidTagIf::Init">
<cfdump var="#arguments.tokens#" label="tokens = LiquidTagIf::Init"> --->
		<cfset super.init(arguments.markup, arguments.tokens, arguments.file_system)>
		<cfreturn this>
	</cffunction>

	<cffunction name="unknown_tag" hint="Handler for unknown tags, handle else tags">
		<cfargument name="tag" type="string" required="true">
		<cfargument name="params" type="any" required="true">
		<cfargument name="tokens" type="any" required="true">
		<cfset var loc = {}>
<!--- <Cfdump var="#arguments#" label="Start = LiquidIf::unknown_tag"> --->
		<cfif arguments.tag eq 'else' OR arguments.tag eq 'elsif'>
<!--- 
<cfdump var="#ArrayLen(this._blocks)#">
<cfdump var="#this._blocks#" label="blocks">
<cfdump var="#this._nodelist#" label="_nodelist">
<cfdump var="#this._nodelistHolders#" label="_nodelistHolders">
 --->

<!--- 			<cfset this._nodelist = this._nodelistHolders[ArrayLen(this._blocks)]> --->

<!--- 		$this->_nodelist = &$this->_nodelistHolders[count($this->_blocks) + 1]; --->
		
		<cfset this._blocks[ArrayLen(this._blocks)][3] = this._nodelist>
		<cfset this._nodelist = this._nodelistHolders>
<!--- 
		
<cfdump var="#this._blocks#" label="blocks 2">
<cfdump var="#this._nodelist#" label="_nodelist 2">
<cfdump var="#this._nodelistHolders#" label="_nodelistHolders 2">
 --->

		<cfset loc.temp = [arguments.tag, arguments.params, this._nodelist]>
		<cfset ArrayAppend(this._blocks, loc.temp)>
		<cfset ArrayClear(this._nodelist)>
<!--- 
			
<cfdump var="#this._blocks#" label="blocks 3">
<cfdump var="#this._nodelist#" label="_nodelist 3">
<cfdump var="#this._nodelistHolders#" label="_nodelistHolders 3">
 --->

		<cfelse>
			<cfset super.unknown_tag(arguments.tag, arguments.params, arguments.tokens)>
		</cfif>

	</cffunction>

	<cffunction name="render" hint="Render the tag">
		<cfargument name="context" type="any" required="true">
		<cfset var loc = {}>
<!--- <cfdump var="#arguments.context.assigns#" label="tagIf render context"> --->
		<cfset arguments.context.push()>
		
		<cfset loc.logicalRegex = createObject("component", "LiquidRegexp").init("\s+(and|or)\s+")>
		<cfset loc.conditionalRegex = createObject("component", "LiquidRegexp").init('(#application["LiquidConfig"]["LIQUID_QUOTED_FRAGMENT"]#)\s*([=!<>a-z_]+)?\s*(#application["LiquidConfig"]["LIQUID_QUOTED_FRAGMENT"]#)?')>

		<cfset loc.result = "">

		<cfloop array="#this._blocks#" index="loc.block">
<!--- <cfdump var="#this._blocks#" label="_blocks">
<cfdump var="#loc.block#" label="block"> --->

			<cfif loc.block[1] eq "else">
				<cfset loc.result = this.render_all(loc.block[3], arguments.context)>
				<cfbreak>
			</cfif>

			<cfif loc.block[1] eq 'if' OR loc.block[1] eq 'elsif'>
				<!--- Extract logical operators --->
				<cfset loc.logicalRegex.match(loc.block[2])>

				<cfset loc.logicalOperators = loc.logicalRegex.matches>
				<cfset loc.temp = array_shift(loc.logicalOperators)>
				<cfset loc.logicalOperators = loc.temp.arr>

				<!--- Extract individual conditions --->
				<cfset loc.temp = loc.logicalRegex.split(loc.block[2])>

				<cfset loc.conditions = []>
<!--- <cfdump var="#loc.temp#" label="temp split"> --->
				<cfloop array="#loc.temp#" index="loc.condition">
					
					<cfif loc.conditionalRegex.match(loc.condition)>
					
						<cfset loc.t = {}>
<!--- <cfdump var="#loc.conditionalRegex.matches#" label="conditions"> --->
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
<!--- <cfdump var="#loc.conditions#" label="conditions"> --->
					<cfelse>
						<cfthrow type="LiquidError" message="Syntax Error in tag 'if' - Valid syntax: if [condition]">
					</cfif>
				</cfloop>
<!--- <cfdump var="#loc.logicalOperators#" label="loc.logicalOperators"> --->
				<cfif ArrayLen(loc.logicalOperators)>

					<!--- If statement contains and/or --->
					<cfset loc.display = true>

					<cfloop from="1" to="#ArrayLen(loc.logicalOperators)#" index="loc.i">
						
						<cfset loc.t = loc.conditions[loc.i]>
						<cfset loc.iLeft = this.interpret_condition(loc.t['left'], loc.t['right'], loc.t['operator'], arguments.context)>
						
						<cfset loc.tt = loc.conditions[IncrementValue(loc.i)]>
						<cfset loc.iRight = this.interpret_condition(loc.t['left'], loc.t['right'], loc.t['operator'], arguments.context)>

						<cfif loc.logicalOperators[loc.i] eq 'and'>
							<cfset loc.display = loc.iLeft AND loc.iRight>
						<cfelse>
							<cfset loc.display = loc.iLeft OR loc.iRight>
						</cfif>
					</cfloop>

				<cfelse>
<!--- <cfdump var="#arguments.context.assigns#"><cfabort> --->
					<!--- If statement is a single condition --->
<!--- <cfdump var="#loc.conditions[1]#" label="conditions"> --->
					<cfset loc.display = this.interpret_condition(loc.conditions[1]['left'], loc.conditions[1]['right'], loc.conditions[1]['operator'], arguments.context)>
<!--- <cfdump var="display: #loc.display#"> --->
				</cfif>

				<cfif (IsBoolean(loc.display) and loc.display) OR (!IsBoolean(loc.display) AND len(loc.display) AND loc.display neq "null")>
					<cfset loc.result = this.render_all(loc.block[3], arguments.context)>
					<cfbreak>
				</cfif>
				
			</cfif>
		</cfloop>
<!--- <Cfdump var="#loc.result#"> --->
		<cfset arguments.context.pop()>
<!--- <Cfdump var="#loc.result#"> --->
<!--- <cfabort> --->
		<cfreturn loc.result>
	</cffunction>
	
</cfcomponent>