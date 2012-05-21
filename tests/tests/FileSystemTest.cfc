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
	
	<cffunction name="test_root">
		<cfset loc.root = '/cfml-liquid/tests/tests/templates/'>

		<cfset loc.file_system = createObject("component", "cfml-liquid.lib.liquid.LiquidLocalFileSystem").init(loc.root)>
		
		<cfset loc.root = ListChangeDelims(loc.root, "/", "\")>
		
		<cfset loc.r = loc.file_system.root>
		<cfset loc.e = loc.root>
		
		<cfset assert('loc.e eq loc.r')>
	</cffunction>
	
	<cffunction name="test_local">
		<cfset loc.root = '/cfml-liquid/tests/tests/templates/'>
		<cfset loc.root = ListChangeDelims(loc.root, "/", "\")>

		<cfset loc.file_system = createObject("component", "cfml-liquid.lib.liquid.LiquidLocalFileSystem").init(loc.root)>
		
		<cfset loc.e = loc.root & "_mypartial.liquid">
		<cfset loc.r = loc.file_system.full_path("mypartial")>
		<cfset assert("loc.e eq loc.r")>
	
		<cfset loc.e = loc.root & "dir/_mypartial.liquid">
		<cfset loc.r = loc.file_system.full_path("dir/mypartial")>
		<cfset assert("loc.e eq loc.r")>

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
	
	<cffunction name="test_read_local_template">
		<cfset loc.root = '/cfml-liquid/tests/tests/templates/'>
		<cfset loc.root = ListChangeDelims(loc.root, "/", "\")>

		<cfset loc.file_system = createObject("component", "cfml-liquid.lib.liquid.LiquidLocalFileSystem").init(loc.root)>
		
		<cfset loc.e = "Put Liquid Markup here">
		<cfset loc.r = loc.file_system.read_template_file('template')>
		
		<cfset assert('loc.e eq loc.r')>
	</cffunction>
	
</cfcomponent>