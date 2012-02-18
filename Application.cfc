<cfcomponent output="false">

	<cfset this.Name = "liquidtemplate" />
	<cfset this.mappings["/liquiddir"] = ExpandPath('/cfml-liquid/lib/liquid')>
	
	<cffunction	name="OnApplicationStart" access="public" returntype="boolean" output="false" hint="Fires when the application is first created.">
		<!--- Return out. --->
		<cfreturn true />
	</cffunction>

</cfcomponent>