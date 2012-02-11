<cfcomponent output="false" extends="cfml-liquid.tests.Test">
	
	<cffunction name="test_default">
		<cfset loc.file_system = createObject("component", "cfml-liquid.lib.liquid.LiquidBlankFileSystem").init()>
		<cftry>
			<cfset loc.file_system.read_template_file('dummy')>
			<cfcatch type="any">
				<cfset loc.e = cfcatch.message>
				<cfset loc.r = "This liquid context does not allow includes.">
				<cfset assert('loc.e eq loc.r')>
			</cfcatch>
		</cftry>	
	</cffunction>
	
	
	<cffunction name="test_local">
		<cfset loc.root = expandPath(".") & '/templates/'>
		
		<cfset loc.file_system = createObject("component", "cfml-liquid.lib.liquid.LiquidLocalFileSystem").init(loc.root)>
		
		<cfset loc.e = loc.root & "mypartial.tpl">
		<cfset loc.r = loc.file_system.full_path("mypartial")>
		<cfset assert("loc.e eq loc.e")>

		<cfset loc.e = loc.root & "dir/mypartial.tpl">
		<cfset loc.r = loc.file_system.full_path("dir/mypartial")>
		<cfset assert("loc.e eq loc.e")>

		<cftry>
			<cfset loc.file_system.full_path("../dir/mypartial")>
			<cfcatch type="any">
				<cfset loc.e = cfcatch.message>
				<cfset loc.r = "Illegal template name '../dir/mypartial'">
				<cfset assert("loc.e eq loc.e")>
			</cfcatch>
		</cftry>

		<cftry>
			<cfset loc.file_system.full_path("/dir/../../dir/mypartial")>
			<cfcatch type="any">
				<cfset loc.e = cfcatch.message>
				<cfset loc.r = "Illegal template name '/dir/../../dir/mypartial'">
				<cfset assert("loc.e eq loc.e")>
			</cfcatch>
		</cftry>

		<cftry>
			<cfset loc.file_system.full_path("/etc/passwd")>
			<cfcatch type="any">
				<cfset loc.e = cfcatch.message>
				<cfset loc.r = "Illegal template name '/etc/passwd'">
				<cfset assert("loc.e eq loc.e")>
			</cfcatch>
		</cftry>

	</cffunction>
	
</cfcomponent>