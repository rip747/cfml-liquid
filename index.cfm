<!--- make sure the liquid library is loaded in the application scope --->
<cfif !StructKeyExists(application, "liquid")>
	<cfset application.liquid = createObject("component", "testing.cfml-liquid.lib.Liquid").init()>
</cfif>

<!--- create our template object --->
<cfset template = application.liquid.template()>

<!--- create the source we want to parse --->
<cfsavecontent variable="source">
<h1>{{ pageTitle }}</h1>
{% if query.size %}
<ul>
	{%for item in query%}
		<li>{{item.project}} - <a href="{{ item.link }}">{{ item.link }}</a></li>
	{%endfor%}
</ul>
{% else%}
<p>No records found</p>
{% endif %}
</cfsavecontent>

<!--- lets assign some variables to the source --->
<!--- create a mock query for showing what this thing can do --->
<cfset q = QueryNew("project,link")>
<cfset QueryAddRow(q)>
<cfset QuerySetCell(q, "project", "CFWheels")>
<cfset QuerySetCell(q, "link", "https://github.com/cfwheels/cfwheels")>
<cfset QueryAddRow(q)>
<cfset QuerySetCell(q, "project", "ColdMVC")>
<cfset QuerySetCell(q, "link", "https://github.com/tonynelson19/ColdMVC")>
<cfset QueryAddRow(q)>
<cfset QuerySetCell(q, "project", "FW/1")>
<cfset QuerySetCell(q, "link", "https://github.com/seancorfield/fw1")>
<cfset QueryAddRow(q)>
<cfset QuerySetCell(q, "project", "Fusebox")>
<cfset QuerySetCell(q, "link", "https://github.com/fusebox-framework/Fusebox-ColdFusion")>

<!--- create a structure to pass in --->
<cfset assigns = {query = q, pageTitle = "ColdFusion Frameworks on Github"}>

<!---
NOTE: if there are any errors in the source, a LiquidError exception will be thrown
Always wrap the calls to Liquid in a try/catch block so you can display
the parsing errors to the user.
 --->
<cftry>
	<!--- parse the source --->
	<cfset template.parse(source)>
	<!--- render the output --->
	<cfoutput>#template.render(assigns)#</cfoutput>
	<cfcatch type="LiquidError">
		<cfoutput>#cfcatch.message#</cfoutput>
	</cfcatch>
</cftry>