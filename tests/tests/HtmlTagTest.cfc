<cfcomponent output="false" extends="cfml-liquid.tests.Test">
	
	<cffunction name="setup">
		<cfset loc.liquid = createObject("component", "cfml-liquid.lib.Liquid").init()>
		<cfset loc.template = createObject("component", "cfml-liquid.lib.liquid.LiquidTemplate").init()>
	</cffunction>
	
	<cffunction name="test_html_table">
		<cfset loc.a = {numbers = [1,2,3,4,5,6]}>
		<cfset loc.e = "<tr class=""row1"">#chr(10)#<td class=""col1""> 1 </td><td class=""col2""> 2 </td><td class=""col3""> 3 </td></tr>#chr(10)#<tr class=""row2""><td class=""col1""> 4 </td><td class=""col2""> 5 </td><td class=""col3""> 6 </td></tr>#chr(10)#">
		<cfset loc.t = "{% tablerow n in numbers cols:3%} {{n}} {% endtablerow %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>

 		<cfset loc.a = {numbers = []}>
		<cfset loc.e = "<tr class=""row1"">#chr(10)#</tr>#chr(10)#">
		<cfset loc.t = "{% tablerow n in numbers cols:3%} {{n}} {% endtablerow %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>

	<cffunction name="test_html_table_with_different_cols">
		<cfset loc.a = {numbers = [1,2,3,4,5,6]}>
		<cfset loc.e = "<tr class=""row1"">#chr(10)#<td class=""col1""> 1 </td><td class=""col2""> 2 </td><td class=""col3""> 3 </td><td class=""col4""> 4 </td><td class=""col5""> 5 </td></tr>#chr(10)#<tr class=""row2""><td class=""col1""> 6 </td></tr>#chr(10)#">
		<cfset loc.t = "{% tablerow n in numbers cols:5%} {{n}} {% endtablerow %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>
	
</cfcomponent>