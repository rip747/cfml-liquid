<cfcomponent output="false" extends="LiquidBlock" hint="This class represents the entire template document">

	<cffunction name="init">
		<cfargument name="tokens" type="array" required="true">
		<cfargument name="file_system" type="any" required="true">

		<cfset this.file_system = arguments.file_system>
		<cfset this.parse(arguments.tokens)>

		<cfreturn this>
	</cffunction>

	<cffunction name="checkIncludes" hint="check for cached includes">
		<cfset var loc = {}>
		<cfset loc.return = false>
		<cfloop array="#this._nodelist#" index="loc.token">
			<cfif isObject(loc.token)>
				<cfif getMetaData(loc.token).name eq 'LiquidTagInclude'>
					<cfif loc.token.checkIncludes() eq true>
						<cfset loc.return = true>
					</cfif>
				</cfif>
			</cfif>
		</cfloop>
		<cfreturn loc.return>
	</cffunction>

	<cffunction name="block_delimiter" hint="There isn't a real delimiter">
		<cfreturn ''>
	</cffunction>

	<cffunction name="assert_missing_delimitation" hint="Document blocks don't need to be terminated since they are not actually opened">
	</cffunction>
	
</cfcomponent>