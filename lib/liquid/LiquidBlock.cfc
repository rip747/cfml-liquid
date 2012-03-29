<cfcomponent output="false" extends="LiquidTag" hint="Base class for blocks.">
	
	<cfset this._nodelist = CreateObject("java","java.util.ArrayList").Init()>

	<cffunction name="getNodelist">
		<cfreturn this._nodelist>
	</cffunction>
	
	<cffunction name="setNodeList">
		<cfargument name="value" type="any" required="true">
		<cfset arrayAppend(this._nodelist, arguments.value)>
	</cffunction>

	<cffunction name="parse">
		<cfargument name="tokens" type="array" required="true">
		<cfset var loc = {}>
		<cfset loc.start_regexp = createObject("component", "LiquidRegexp").init('^#application.LiquidConfig.LIQUID_TAG_START#')>
		<cfset loc.tag_regexp = createObject("component", "LiquidRegexp").init('^#application.LiquidConfig.LIQUID_TAG_START#\s*(\w+)\s*(.*)?#application.LiquidConfig.LIQUID_TAG_END#$')>
		<cfset loc.variable_start_regexp = createObject("component", "LiquidRegexp").init('^#application.LiquidConfig.LIQUID_VARIABLE_START#')>
		
		<cfif !IsArray(arguments.tokens)>
			<cfreturn>
		</cfif>
		
		<cfset loc.tags = createObject("component", "LiquidTemplate").getTags()>

		<cfloop condition="#ArrayLen(arguments.tokens)#">
			
			<cfset loc.temp = array_shift(arguments.tokens)>
			<cfset arguments.tokens = loc.temp.arr>
			<cfset loc.token = loc.temp.value>
			<cfset loc.start_regexp.match(loc.token)>
			<cfset loc.tag_regexp.match(loc.token)>

			<cfif loc.start_regexp.match(loc.token)>

				<cfif loc.tag_regexp.match(loc.token)>

					<!--- if we found the proper block delimitor just end parsing here and let the outer block proceed  --->
					<cfif loc.tag_regexp.matches[2] eq this.block_delimiter()>
						<cfreturn this.end_tag()>
					</cfif>

					<cfif StructKeyExists(loc.tags, loc.tag_regexp.matches[2])>
						<cfset loc.tag_name = loc.tags[loc.tag_regexp.matches[2]]>
					<cfelse>
						<!--- search for a defined class of the right name, instead of searching in an array --->
						<cfset loc.tag_name = 'LiquidTag' & rereplace(loc.tag_regexp.matches[2], "\b(\w)","\u\1", "all")>
					</cfif>
					
					<cfset loc.tag_name_fullPath = "#application.LiquidConfig.LIQUID_DIR_PATH#/#loc.tag_name#.cfc">
					<cfset loc.tag_name_cfcPath = "#application.LiquidConfig.LIQUID_LIB_PATH#.#loc.tag_name#">

					<cfif fileExists(ExpandPath(loc.tag_name_fullPath))>

						<cfset loc.temp = createObject("component", loc.tag_name_cfcPath).init(loc.tag_regexp.matches[3], arguments.tokens, this.file_system)>
						<cfset loc.temp.pushToNodeList()>
						<cfset arrayAppend(this._nodelist, loc.temp)>

					<cfelse>

						<cfset this.unknown_tag(loc.tag_regexp.matches[2], loc.tag_regexp.matches[3], arguments.tokens)>
						
					</cfif>
				
				<cfelse>

					<cfset createobject("component", "LiquidException").init("Tag #loc.token# was not properly terminated")>
				</cfif>
				
			<cfelseif loc.variable_start_regexp.match(loc.token)>

				<cfset loc.temp = this.create_variable(loc.token)>
				<cfset arrayAppend(this._nodelist, loc.temp)>

			<cfelseif len(loc.token)>

				<cfset arrayAppend(this._nodelist, loc.token)>

			</cfif>
		</cfloop>

		<cfset this.assert_missing_delimitation()>
	</cffunction>

	<cffunction name="end_tag" hint="An action to execute when the end tag is reached">
		<cfreturn this>
	</cffunction>

	<cffunction name="unknown_tag" hint="Handler for unknown tags">
		<cfargument name="tag" type="string" required="true">
		<cfargument name="params" type="any" required="true">
		<cfargument name="tokens" type="any" required="true">
		<cfset var loc = {}>
		<cfswitch expression="#arguments.tag#">
			<cfcase value="else">
				<cfset createobject("component", "LiquidException").init(this.block_name() & " does not expect else tag")>
			</cfcase>
			<cfcase value="end">
				<cfset createobject("component", "LiquidException").init("'end' is not a valid delimiter for " & this.block_name() & " tags. Use " & this.block_delimiter())>
			</cfcase>
			<cfdefaultcase>
				<cfset createobject("component", "LiquidException").init("Unkown tag #arguments.tag#")>
			</cfdefaultcase>
		</cfswitch>
	</cffunction>

	<cffunction name="block_delimiter" hint="Returns the string that delimits the end of the block">
		<cfreturn "end#this.block_name()#">
	</cffunction>

	<cffunction name="block_name" hint="Returns the name of the block">
		<cfreturn replacenocase(ListLast(getMetaData(this).name, "."), 'liquidtag', '')>
	</cffunction>

	<cffunction name="create_variable" hint="Create a variable for the given token">
		<cfargument name="token" type="string" required="true">
		<cfset var loc = {}>
		<cfset loc.variable_regexp = createObject("component", "LiquidRegexp").init('^#application.LiquidConfig.LIQUID_VARIABLE_START#(.*)#application.LiquidConfig.LIQUID_VARIABLE_END#$')>
		<cfif loc.variable_regexp.match(arguments.token)>
			<cfset loc.ret = createObject("component", "LiquidVariable").init(loc.variable_regexp.matches[2])>
			<cfreturn loc.ret>
		</cfif>
		<cfset createobject("component", "LiquidException").init("Variable #loc.token# was not properly terminated")>
	</cffunction>

	<cffunction name="render" hint="Render the block.">
		<cfargument name="context" type="any" required="true">
		<cfreturn this.render_all(this._nodelist, arguments.context)>
	</cffunction>

	<cffunction name="assert_missing_delimitation" hint="This method is called at the end of parsing, and will through an error unless this method is subclassed, like it is for LiquidDocument">
		<cfset createobject("component", "LiquidException").init(this.block_name() & " tag was never closed")>
	</cffunction>

	<cffunction name="render_all" hint="Renders all the given nodelist's nodes">
		<cfargument name="list" type="array" required="true">
		<cfargument name="context" type="any" required="true">
		<cfset var loc = {}>
		<cfset loc.result = "">

		<cfloop array="#arguments.list#" index="loc.token">

			<cfif isObject(loc.token) AND StructKeyExists(loc.token, "render")>

				<cfset loc.result &= loc.token.render(arguments.context)>
				
			<cfelse>

				<cfset loc.result &= loc.token>
				
			</cfif>

		</cfloop>

		<cfreturn loc.result>
	</cffunction>
	
</cfcomponent>