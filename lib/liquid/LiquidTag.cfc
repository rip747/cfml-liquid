<cfcomponent output="false" hint="Base class for tags">
	
	<!--- The markup for the tag --->
	<cfset variables.markup = "">
	
	<!--- Filesystem object is used to load included template files --->
	<cfset variables.file_system = "">
	
	<!--- Additional attributes --->
	<cfset variables.attributes = {}>

	<cffunction name="init">
		<cfargument name="markup" type="string" required="true">
		<cfargument name="tokens" type="array" required="true">
		<cfargument name="file_system" type="any" required="true">

		<cfset variables.markup = arguments.markup>
		<cfset variables.file_system = arguments.file_system>
<cfdump var="#arguments#" label="liquidtag parse tokens">
		<cfreturn this.parse(arguments.tokens)>
	</cffunction>

	<cffunction name="parse" hint="Parse the given tokens">
		<cfargument name="tokens" type="array" required="true">
	</cffunction>

	<cffunction name="extract_attributes" hint="Extracts tag attributes from a markup string">
		<cfargument name="markup" type="string" required="true">
		<cfset var loc = {}>
	
		<cfset loc.attribute_regexp = createObject("component", "LiquidRegexp").init(application.LiquidConfig.LIQUID_TAG_ATTRIBUTES)>
		
		<cfset loc.matches = attribute_regexp.scan(arguments.markup)>
		
		<cfset structAppend(this.attributes, loc.matches, true)>
	</cffunction>

	<cffunction name="name" hint="Returns the name of the tag">
		<cfreturn lcase(getMetaData(this).name)>
	</cffunction>

	<cffunction name="render" hint="Render the tag with the given context">
		<cfargument name="context" type="any" required="true">
		<cfreturn "">
	</cffunction>

</cfcomponent>
