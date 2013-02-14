<cfcomponent output="false" extends="cfml-liquid.tests.Test">
	
	<cffunction name="setup">
		<cfset loc.template = application.liquid.template()>
	</cffunction>
	
	<cffunction name="test_tag_in_raw">
		<cfset loc.e = "{% comment %} test {% endcomment %}">
		<cfset loc.t = "{% raw %}{% comment %} test {% endcomment %}{% endraw %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template)>
	</cffunction>

	<cffunction name="test_output_in_raw">
		<cfset loc.e = "{{ test }}">
		<cfset loc.t = "{% raw %}{{ test }}{% endraw %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template)>
	</cffunction>

</cfcomponent>