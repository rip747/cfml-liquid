<cfcomponent output="false" extends="cfml-liquid.tests.Test">
	
	<cffunction name="setup">
		<cfset loc.liquid = createObject("component", "cfml-liquid.lib.Liquid").init()>
		<cfset loc.template = createObject("component", "cfml-liquid.lib.liquid.LiquidTemplate").init()>
	</cffunction>

	<cffunction name="test_true_eql_true">
		<cfset loc.tpl = " {% if true == true %} true {% else %} false {% endif %} ">
		<cfset loc.expected = "  true  ">
		<cfset assert_template_result(loc.expected, loc.tpl, loc.template)>
	</cffunction>

	<cffunction name="test_true_not_eql_true">
		<cfset loc.tpl = " {% if true != true %} true {% else %} false {% endif %} ">
		<cfset loc.expected = "  false  ">
		<cfset assert_template_result(loc.expected, loc.tpl, loc.template)>
	</cffunction>

	<cffunction name="test_true_lq_true">
		<cfset loc.tpl = " {% if 0 > 0 %} true {% else %} false {% endif %} ">
		<cfset loc.expected = "  false  ">
		<cfset assert_template_result(loc.expected, loc.tpl, loc.template)>
	</cffunction>
		
	<cffunction name="test_one_lq_zero">
		<cfset loc.tpl = " {% if 1 > 0 %} true {% else %} false {% endif %} ">
		<cfset loc.expected = "  true  ">
		<cfset assert_template_result(loc.expected, loc.tpl, loc.template)>
	</cffunction>
 		
	<cffunction name="test_zero_lq_one">
		<cfset loc.tpl = " {% if 0 < 1 %} true {% else %} false {% endif %} ">
		<cfset loc.expected = "  true  ">
		<cfset assert_template_result(loc.expected, loc.tpl, loc.template)>
	</cffunction>
		
	<cffunction name="test_zero_lq_or_equal_one">
		<cfset loc.tpl = " {% if 0 <= 0 %} true {% else %} false {% endif %} ">
		<cfset loc.expected = "  true  ">
		<cfset assert_template_result(loc.expected, loc.tpl, loc.template)>
	</cffunction>

	<cffunction name="test_zero_lq_or_equal_one_involving_nil">
		<cfset loc.tpl = " {% if null <= 0 %} true {% else %} false {% endif %} ">
		<cfset loc.expected = "  false  ">
		<cfset assert_template_result(loc.expected, loc.tpl, loc.template)>
		
		<cfset loc.tpl = " {% if 0 <= null %} true {% else %} false {% endif %} ">
		<cfset loc.expected = "  false  ">
		<cfset assert_template_result(loc.expected, loc.tpl, loc.template)>
	</cffunction>
 		
	<cffunction name="test_zero_lqq_or_equal_one">
		<cfset loc.tpl = " {% if 0 >= 0 %} true {% else %} false {% endif %} ">
		<cfset loc.expected = "  true  ">
		<cfset assert_template_result(loc.expected, loc.tpl, loc.template)>
	</cffunction>
		
	<cffunction name="test_strings">
		<cfset loc.tpl = " {% if 'test' == 'test' %} true {% else %} false {% endif %} ">
		<cfset loc.expected = "  true  ">
		<cfset assert_template_result(loc.expected, loc.tpl, loc.template)>
	</cffunction>
		
	<cffunction name="test_strings_not_equal">
		<cfset loc.tpl = " {% if 'test' != 'test' %} true {% else %} false {% endif %} ">
		<cfset loc.expected = "  false  ">
		<cfset assert_template_result(loc.expected, loc.tpl, loc.template)>
	</cffunction>
		
	<cffunction name="test_var_strings_equal">
		<cfset loc.a = {var="hello there!"}>
		<cfset loc.tpl = " {% if var == ""hello there!\"" %} true {% else %} false {% endif %} ">
		<cfset loc.expected = "  true  ">
		<cfset assert_template_result(loc.expected, loc.tpl, loc.template, loc.a)>
	</cffunction>

	<cffunction name="test_var_strings_are_not_equal">
		<cfset loc.a = {var="hello there!"}>
		<cfset loc.tpl = " {% if ""hello there!"" == var %} true {% else %} false {% endif %} ">
		<cfset loc.expected = "  true  ">
		<cfset assert_template_result(loc.expected, loc.tpl, loc.template, loc.a)>
	</cffunction>
		
	<cffunction name="test_var_and_long_string_are_equal">
		<cfset loc.a = {var="hello there!"}>
		<cfset loc.tpl = " {% if var == 'hello there!' %} true {% else %} false {% endif %} ">
		<cfset loc.expected = "  true  ">
		<cfset assert_template_result(loc.expected, loc.tpl, loc.template, loc.a)>
	</cffunction>

	<cffunction name="test_var_and_long_string_are_equal_backwards">
		<cfset loc.a = {var="hello there!"}>
		<cfset loc.tpl = " {% if 'hello there!' == var %} true {% else %} false {% endif %} ">
		<cfset loc.expected = "  true  ">
		<cfset assert_template_result(loc.expected, loc.tpl, loc.template, loc.a)>
	</cffunction>

	<cffunction name="test_is_collection_empty">
		<cfset loc.a = {array=[]}>
		<cfset loc.tpl = " {% if array == empty %} true {% else %} false {% endif %} ">
		<cfset loc.expected = "  true  ">
		<cfset assert_template_result(loc.expected, loc.tpl, loc.template, loc.a)>
	</cffunction>
	
	<cffunction name="test_is_not_collection_empty">
		<cfset loc.a = {array = [1,2,3]}>
		<cfset loc.tpl = " {% if array == empty %} true {% else %} false {% endif %} ">
		<cfset loc.expected = "  false  ">
		<cfset assert_template_result(loc.expected, loc.tpl, loc.template, loc.a)>
	</cffunction>

	<cffunction name="test_nil">
		<cfset loc.a = {var = "null"}>
		<cfset loc.tpl = " {% if var == null %} true {% else %} false {% endif %} ">
		<cfset loc.expected = "  true  ">
		<cfset assert_template_result(loc.expected, loc.tpl, loc.template, loc.a)>

 		<cfset loc.a = {var = "null"}>
		<cfset loc.tpl = " {% if var == null %} true {% else %} false {% endif %} ">
		<cfset loc.expected = "  true  ">
		<cfset assert_template_result(loc.expected, loc.tpl, loc.template, loc.a)>
	</cffunction>

	<cffunction name="test_not_nil">
 		<cfset loc.a = {var = 1}>
		<cfset loc.tpl = " {% if var != null %} true {% else %} false {% endif %} ">
		<cfset loc.expected = "  true  ">
		<cfset assert_template_result(loc.expected, loc.tpl, loc.template, loc.a)>

 		<cfset loc.a = {var = 1}>
		<cfset loc.tpl = " {% if var != null %} true {% else %} false {% endif %} ">
		<cfset loc.expected = "  true  ">
		<cfset assert_template_result(loc.expected, loc.tpl, loc.template, loc.a)>
	</cffunction>

</cfcomponent>