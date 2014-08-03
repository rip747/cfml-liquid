:heart: This project is dedicated to my wife, Linda. Though we are going through a difficult time, know that I love you with all the love in the world :heart:

This project aims to port the [Liquid Templating Language](https://github.com/Shopify/liquid) over to [CFML](http://www.getrailo.org/). For the port I'm using the [PHP port](https://github.com/harrydeluxe/php-liquid) of the language.


How To Use
==========

```coldfusion
<!--- make sure the liquid library is loaded in the application scope --->
<cfif !StructKeyExists(application, "liquid")>
	<cfset application.liquid = createObject("component", "lib.Liquid").init()>
</cfif>

<!--- create our template object --->
<cfset template = application.liquid.template()>

<!--- create the source we want to parse --->
<cfsavecontent variable="source">
<h1>{{ pageTitle }}</h1>
{% if query.size %}
<ul>
	{% for item in query %}
		<li>{{ item.project }} - <a href="{{ item.link }}">{{ item.link }}</a></li>
	{% endfor %}
</ul>
{% else %}
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
```
would produce

```html
<h1>ColdFusion Frameworks on Github</h1>
<ul>
		<li>CFWheels - <a href="https://github.com/cfwheels/cfwheels">https://github.com/cfwheels/cfwheels</a></li>
		<li>ColdMVC - <a href="https://github.com/tonynelson19/ColdMVC">https://github.com/tonynelson19/ColdMVC</a></li>
		<li>FW/1 - <a href="https://github.com/seancorfield/fw1">https://github.com/seancorfield/fw1</a></li>
		<li>Fusebox - <a href="https://github.com/fusebox-framework/Fusebox-ColdFusion">https://github.com/fusebox-framework/Fusebox-ColdFusion</a></li>
</ul>
```

More examples and information can be found in the original [Liquid documentation](https://github.com/Shopify/liquid/wiki/Liquid-for-Designers)

Currect State
=============

Currently this project is in a state that I'm happy with. As a result, I will be focusing my attention on [CFWheels](https://github.com/cfwheels/cfwheels). If you would like to take over the project as the maintainer, please contact me through github.


What's left to do
=================

I was going to add caching but I'm deciding against it as (from what I can tell) the original Liquid library doesn't have it. Feel free to implement it if you desire.


Running Tests
=============

Tests are written using the [RocketUnit framework](http://rocketunit.riaforge.org/). To run the tests first clone the project into a directory off your webroot called `cfml-liquid`. Next point your browser to `http://localhost/cfml-liquid/tests`.


Issues and Enhancements
====================

I will be taking issues requests until the project is passed to a maintainer. Please file your issues in the issue tracker for this repo.

I will **not** be taking enhancement requests. If there is something that you want added to the project, please fork the project, code the enhancement and send me a pull requst.

Latest Release
==============

[Releases can be downloaded directly from Github](https://github.com/rip747/cfml-liquid/releases)

Changelog
=========

v1.2
----

* added RAW tag
* added the following filters
  * append
  * prepend
  * escape
  * remove
  * remove_first
  * replace
  * replace_first
  * sort
