<cfcomponent output="false">
	
	<cfset this._expire = 3600>
	
	<cffunction name="init">
		<cfargument name="options" type="struct" required="false" default="#StructNew()#">
		
		<cfif StructKeyExists(arguments, "_expire")>
			<cfset this._expire = arguments._expire>
		</cfif>

		<cfreturn this>
	</cffunction>

	<cffunction name="read">
		<cfargument name="key" type="string" required="true">
		<cfreturn application[application.LiquidConfig.LIQUID_CACHE_KEY][arguments.key]>
	</cffunction>

	<cffunction name="exists">
		<cfargument name="key" type="string" required="true">
		
		<cfif StructKeyExists(application[application.LiquidConfig.LIQUID_CACHE_KEY], arguments.key)>
			<cfreturn true>
		</cfif>
		
		<cfreturn false>
	</cffunction>

	<cffunction name="write">
		<cfargument name="key" type="string" required="true">
		<cfargument name="value" type="any" required="true">
		<cfset application[application.LiquidConfig.LIQUID_CACHE_KEY][arguments.key] = arguments.value>
	</cffunction>
	
	<cffunction name="delete">
		<cfargument name="key" type="string" required="true">
		<cfset StructDelete(application[application.LiquidConfig.LIQUID_CACHE_KEY], arguments.key, false)>
	</cffunction>

	<cffunction name="flush">
		<cfset StructClear(application[application.LiquidConfig.LIQUID_CACHE_KEY])>
	</cffunction>
	
</cfcomponent>