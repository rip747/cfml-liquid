<cfcomponent extends="cfml-liquid.lib.liquid.LiquidBlankFileSystem">

	<cffunction name="read_template_file">
		<cfargument name="template_path" type="any" required="true">

		<cfif arguments.template_path eq 'inner'>
			<cfreturn "Inner: {{ inner }}{{ other }}">
		</cfif>
		
	</cffunction>

</cfcomponent>