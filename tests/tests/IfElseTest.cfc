<cfcomponent output="false" extends="cfml-liquid.tests.Test">

	<cffunction name="setup">
		<cfset loc.template = application.liquid.template()>
	</cffunction>

	<cffunction name="test_if">
		<cfset loc.e = "  ">
		<cfset loc.t = " {% if false %} this text should not go into the output {% endif %} ">
		<cfset assert_template_result(loc.e, loc.t, loc.template)>

		<cfset loc.e = "  this text should go into the output  ">
		<cfset loc.t = " {% if true %} this text should go into the output {% endif %} ">
		<cfset assert_template_result(loc.e, loc.t, loc.template)>

		<cfset loc.e = "  you rock ?">
		<cfset loc.t = "{% if false %} you suck {% endif %} {% if true %} you rock {% endif %}?">
		<cfset assert_template_result(loc.e, loc.t, loc.template)>
	</cffunction>
		
	<cffunction name="test_if_else">
		<cfset loc.e = " YES ">
		<cfset loc.t = "{% if false %} NO {% else %} YES {% endif %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template)>

		<cfset loc.e = " YES ">
		<cfset loc.t = "{% if true %} YES {% else %} NO {% endif %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template)>

		<cfset loc.e = " YES ">
		<cfset loc.t = "{% if ""foo"" %} YES {% else %} NO {% endif %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template)>
	</cffunction>
		
	<cffunction name="test_if_boolean">
		<cfset loc.a = {var = true}>
		<cfset loc.e = " YES ">
		<cfset loc.t = "{% if var %} YES {% endif %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>

	<cffunction name="test_if_from_variable">
		<cfset loc.a = {var = false}>
		<cfset loc.e = "">
		<cfset loc.t = "{% if var %} NO {% endif %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>

		<cfset loc.a = {var = ""}>
		<cfset loc.e = "">
		<cfset loc.t = "{% if var %} NO {% endif %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>

		<cfset loc.a = {foo = {bar = "false"}}>
		<cfset loc.e = "">
		<cfset loc.t = "{% if foo.bar %} NO {% endif %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>

		<cfset loc.a = {foo = {}}>
		<cfset loc.e = "">
		<cfset loc.t = "{% if foo.bar %} NO {% endif %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>

		<cfset loc.a = {foo = ""}>
		<cfset loc.e = "">
		<cfset loc.t = "{% if foo.bar %} NO {% endif %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>

		<cfset loc.a = {var = "text"}>
		<cfset loc.e = ' YES '>
		<cfset loc.t = "{% if var %} YES {% endif %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	
		<cfset loc.a = {var = "true"}>
		<cfset loc.e = ' YES '>
		<cfset loc.t = "{% if var %} YES {% endif %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>

		<cfset loc.a = {var = 1}>
		<cfset loc.e = ' YES '>
		<cfset loc.t = "{% if var %} YES {% endif %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>

		<cfset loc.e = ' YES '>
		<cfset loc.t = "{% if ""foo"" %} YES {% endif %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template)>

		<cfset loc.a = {foo = {bar = true}}>
		<cfset loc.e = ' YES '>
		<cfset loc.t = "{% if foo.bar %} YES {% endif %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>

		<cfset loc.a = {foo = {bar = "text"}}>
		<cfset loc.e = ' YES '>
		<cfset loc.t = "{% if foo.bar %} YES {% endif %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>

		<cfset loc.a = {foo = {bar = 1}}>
		<cfset loc.e = ' YES '>
		<cfset loc.t = "{% if foo.bar %} YES {% endif %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
		<cfset loc.a = {var = false}>
		<cfset loc.e = ' YES '>
		<cfset loc.t = "{% if var %} NO {% else %} YES {% endif %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>

		<cfset loc.a = {var = "null"}>
		<cfset loc.e = ' YES '>
		<cfset loc.t = "{% if var %} NO {% else %} YES {% endif %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>

		<cfset loc.a = {var = true}>
		<cfset loc.e = ' YES '>
		<cfset loc.t = "{% if var %} YES {% else %} NO {% endif %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>

		<cfset loc.a = {var = "text"}>
		<cfset loc.e = ' YES '>
		<cfset loc.t = "{% if ""foo"" %} YES {% else %} NO {% endif %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>


		<cfset loc.a = {foo = {bar = false}}>
		<cfset loc.e = ' YES '>
		<cfset loc.t = "{% if foo.bar %} NO {% else %} YES {% endif %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>

		<cfset loc.a = {foo = {bar = true}}>
		<cfset loc.e = ' YES '>
		<cfset loc.t = "{% if foo.bar %} YES {% else %} NO {% endif %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>

		<cfset loc.a = {foo = {bar = "text"}}>
		<cfset loc.e = ' YES '>
		<cfset loc.t = "{% if foo.bar %} YES {% else %} NO {% endif %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>

		<cfset loc.a = {notbar = true}>
		<cfset loc.e = ' YES '>
		<cfset loc.t = "{% if foo.bar %} NO {% else %} YES {% endif %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
		<cfset loc.a = {foo = {}}>
		<cfset loc.e = ' YES '>
		<cfset loc.t = "{% if foo.bar %} NO {% else %} YES {% endif %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
		<cfset loc.a = {notfoo = {bar = true}}>
		<cfset loc.e = ' YES '>
		<cfset loc.t = "{% if foo.bar %} NO {% else %} YES {% endif %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>

	<cffunction name="test_nested_if">
		<cfset loc.e = ''>
		<cfset loc.t = "{% if false %}{% if false %} NO {% endif %}{% endif %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template)>
		
 		<cfset loc.e = ''>
		<cfset loc.t = "{% if false %}{% if true %} NO {% endif %}{% endif %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template)>

		<cfset loc.e = ''>
		<cfset loc.t = "{% if true %}{% if false %} NO {% endif %}{% endif %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template)>

		<cfset loc.e = ' YES '>
		<cfset loc.t = "{% if true %}{% if true %} YES {% endif %}{% endif %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template)>

		
		<cfset loc.e = ' YES '>
		<cfset loc.t = "{% if true %}{% if true %} YES {% else %} NO {% endif %}{% else %} NO {% endif %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template)>
		
		<cfset loc.e = ' YES '>
		<cfset loc.t = "{% if true %}{% if false %} NO {% else %} YES {% endif %}{% else %} NO {% endif %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template)>
		
		<cfset loc.e = ' YES '>
		<cfset loc.t = "{% if false %}{% if true %} NO {% else %} NONO {% endif %}{% else %} YES {% endif %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template)>
	</cffunction>
  
	<cffunction name="test_comparisons_on_null">
		<cfset loc.a = {}>
		<cfset loc.e = ''>
		
		<cfset loc.t = "{% if null < 10 %} NO {% endif %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
		<cfset loc.t = "{% if null <= 10 %} NO {% endif %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
		<cfset loc.t = "{% if null >= 10 %} NO {% endif %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
		<cfset loc.t = "{% if null > 10 %} NO {% endif %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>

		<cfset loc.t = "{% if 10 < null %} NO {% endif %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>

		<cfset loc.t = "{% if 10 <= null %} NO {% endif %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
		<cfset loc.t = "{% if 10 >= null %} NO {% endif %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
		<cfset loc.t = "{% if 10 > null %} NO {% endif %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>

	<cffunction name="test_syntax_error_no_variable">
		<cfset loc.e = ''>
		<cfset loc.t = "{% if jerry == 1 %}">
		<cfset loc.e = "if tag was never closed">
		<cfset loc.r = raised('assert_template_result(loc.e, loc.t, loc.template)')>
		<cfset assert('loc.e eq loc.r.message')>
	</cffunction>
 
	<cffunction name="test_elsif">
		<cfset loc.e = "Hello">
		<cfset loc.t = "{% assign test = 'hello' %}{% if test == 'bye' %}Bye{% elsif test == 'hello' %}Hello{% elseif test == 'ciao' %}Ciao{% else %}Rude{% endif %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template)>
		
		<cfset loc.e = "Bye">
		<cfset loc.t = "{% assign test = 'bye' %}{% if test == 'bye' %}Bye{% elsif test == 'hello' %}Hello{% elseif test == 'ciao' %}Ciao{% else %}Rude{% endif %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template)>
		
		<cfset loc.e = "Ciao">
		<cfset loc.t = "{% assign test = 'ciao' %}{% if test == 'bye' %}Bye{% elsif test == 'hello' %}Hello{% elseif test == 'ciao' %}Ciao{% else %}Rude{% endif %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template)>
		
		<cfset loc.e = "Rude">
		<cfset loc.t = "{% assign test = 'nothing' %}{% if test == 'bye' %}Bye{% elsif test == 'hello' %}Hello{% elseif test == 'ciao' %}Ciao{% else %}Rude{% endif %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template)>
	</cffunction>

	<cffunction name="test_multiple_conditions">
		<cfset loc.e = "no">
		<cfset loc.t = "{% assign test1 = 'test1' %}{% assign test2 = 'test2' %}{% if test1 == 'test1' and test2 != 'test2' %}yes{% else %}no{% endif %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template)>
	</cffunction>

</cfcomponent>