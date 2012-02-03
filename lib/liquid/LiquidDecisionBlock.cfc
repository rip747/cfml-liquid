<cfcomponent output="false" extends="LiquidBlock">

	<!--- The current left variable to compare --->
	<cfset this._left = "">

	<!--- The current right variable to compare --->
	<cfset this._right = "">
	
	<cffunction name="string_value" hint="Returns a string value of an array for comparisons">
		<cfargument name="value" type="any" required="true">
		
		<!--- objects should have a to_string a value to compare to --->
		<cfif isObject(arguments.value)>
			<cfif StructKeyExists(arguments.value, "to_string")>
				<cfset arguments.value = arguments.value.to_string()>
			<cfelse>
				<cfthrow type="LiquidError" message="Cannot convert $value to string">
			</cfif>
		</cfif>

		<!--- arrays simply return true --->
		<cfif isArray(arguments.value)>
			<cfreturn arguments.value>
		</cfif>
		
		<cfreturn arguments.value>
	</cffunction>

	<cffunction name="equal_variables" hint="Check to see if to variables are equal in a given context">
		<cfargument name="left" type="string" required="true">
		<cfargument name="right" type="string" required="true">
		<cfargument name="context" type="any" required="true">
		
		<cfset this._left = this.string_value(arguments.context.get(arguments.left))>
		<cfset this._right = this.string_value(arguemnts.context.get(arguments.right))>

		<cfreturn this._left eq this._right>
	</cffunction>

	<cffunction name="interpret_condition" hint="Interpret a comparison">
		<cfargument name="left" type="string" required="true">
		<cfargument name="right" type="string" required="true">
		<cfargument name="op" type="string" required="true">
		<cfargument name="context" type="any" required="true">
		<cfset var loc = {}>

		<cfif !len(arguments.op)>

			<cfset loc.value = this.string_value(arguments.context.get(arguments.left))>
			<cfreturn loc.value>
		</cfif>
		<!--- values of 'empty' have a special meaning in array comparisons --->
		<cfif arguments.right eq "empty" AND isArray(arguments.context.get(arguments.left))>
			<cfset arguments.left = ArrayLen(arguments.context.get(arguments.left))>
			<cfset arguments.right = 0>
		<cfelseif arguments.left eq "empty" AND isArray(arguments.context.get(arguments.right))>
			<cfset arguments.right = ArrayLen(arguments.context.get(arguments.right))>
			<cfset arguments.left = 0>
		<cfelse>
			<cfset arguments.left = arguments.context.get(arguments.left)>
			<cfset arguments.right = arguments.context.get(arguments.right)>

			<cfset arguments.left = this.string_value(arguments.left)>
			<cfset arguments.right = this.string_value(arguments.right)>
		</cfif>

		<!--- special rules for null values --->
		<cfif !len(arguments.left) OR !len(arguments.right)>
		
			<!--- null == null returns true --->
			<cfif arguments.op eq "==">
				<cfreturn true>
			</cfif>

			<!--- null != anything other than null return true --->
			<cfif arguments.op eq "!=" AND (len(arguments.left) OR len(arguments.right))>
				<cfreturn true>
			</cfif>

			<!--- everything else, return false; --->
			<cfreturn false>
		</cfif>
		<cfdump var="#arguments#" label="decisionblock::interpret_condition">
		<!--- regular rules --->
		<cfswitch expression="#arguments.op#">
			<cfcase value="==">
				<cfreturn arguments.left eq arguments.right>
			</cfcase>
			<cfcase value="!=">
				<cfreturn arguments.left neq arguments.right>
			</cfcase>
			<cfcase value=">">
				<cfreturn arguments.left gt arguments.right>
			</cfcase>
			<cfcase value="<">
				<cfreturn arguments.left lt arguments.right>
			</cfcase>
			<cfcase value=">=">
				<cfreturn arguments.left gte arguments.right>
			</cfcase>
			<cfcase value="<=">
				<cfreturn arguments.left lte arguments.right>
			</cfcase>
			<cfcase value="contains">
				<cfif isArray(arguments.left)>
					<cfreturn arguments.left.indexOf(arguments.right)>
				<cfelse>
					<cfreturn arguments.left CONTAINS arguments.right>
				</cfif>
			</cfcase>
			<cfdefaultcase>
				<cfthrow type="LiquidError" message="Error in tag '#arguments.this.name()#' - Unknown operator">
			</cfdefaultcase>
		</cfswitch>
		
	</cffunction>
	
</cfcomponent>