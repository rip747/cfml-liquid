<cfcomponent output="false">
	
	<cffunction name="make_funny">
		<cfargument name="input" type="string" required="true">
		<cfreturn 'LOL'>
	</cffunction>
	
	<cffunction name="cite_funny">
		<cfargument name="input" type="string" required="true">
		<cfreturn 'LOL: '& arguments.input>
	</cffunction>
	
	<cffunction name="add_smiley">
		<cfargument name="input" type="string" required="true">
		<cfargument name="smiley" type="string" required="false" default=":-)">
		<cfreturn arguments.input & ' ' & arguments.smiley>
	</cffunction>
	
	<cffunction name="add_tag">
		<cfargument name="input" type="string" required="true">
		<cfargument name="tag" type="string" required="false" default="p">
		<cfargument name="id" type="string" required="false" default="foo">
		<cfreturn "<" & arguments.tag & " id=""" & arguments.id & """>" & arguments.input & "</" & arguments.tag & ">">
	</cffunction>

	<cffunction name="paragraph">
		<cfargument name="input" type="string" required="true">
    	<cfreturn "<p>" & arguments.input & "</p>">
	</cffunction>

	<cffunction name="link_to"> (, )
		<cfargument name="$name" type="string" required="true">
		<cfargument name="$url" type="string" required="true">
		<cfreturn "<a href=""" & arguments.url & """>" & arguments.$name & "</a>">
	</cffunction>

</cfcomponent>