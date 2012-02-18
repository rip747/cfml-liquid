<cfcomponent output="false" extends="cfml-liquid.tests.Test">
	
	<cffunction name="setup">
		<cfset loc.template = application.liquid.template()>
	</cffunction>
	
	<cffunction name="test_no_transform">
		
		<cfset loc.e = "this text should come out of the template without change...">
		<cfset loc.t = "this text should come out of the template without change...">
		<cfset assert_template_result(loc.e, loc.t, loc.template)>
			
		<cfset loc.e = "blah">
		<cfset loc.t = "blah">
		<cfset assert_template_result(loc.e, loc.t, loc.template)>
			
		<cfset loc.e = "<blah>">
		<cfset loc.t = "<blah>">
		<cfset assert_template_result(loc.e, loc.t, loc.template)>
		
		<cfset loc.e = "|,.:">
		<cfset loc.t = "|,.:">
		<cfset assert_template_result(loc.e, loc.t, loc.template)>
		
		<cfset loc.e = "">
		<cfset loc.t = "">
		<cfset assert_template_result(loc.e, loc.t, loc.template)>
		
		<cfset loc.e = "this shouldnt see any transformation either but has multiple lines
 	     	              as you can clearly see here ...">
		<cfset assert_template_result(loc.e, loc.e, loc.template)>
	    
	</cffunction>
	
	<cffunction name="test_has_a_block_which_does_nothing">

		<cfset loc.e = "the comment block should be removed  .. right?">
		<cfset loc.t = "the comment block should be removed {%comment%} be gone.. {%endcomment%} .. right?">
		<cfset assert_template_result(loc.e, loc.t, loc.template)>

		<cfset loc.e = "">
		<cfset loc.t = "{%comment%}{%endcomment%}">
		<cfset assert_template_result(loc.e, loc.t, loc.template)>
 	   
		<cfset loc.e = "">
		<cfset loc.t = "{%comment%}{% endcomment %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template)>

		<cfset loc.e = "">
		<cfset loc.t = "{% comment %}{%endcomment%}">
		<cfset assert_template_result(loc.e, loc.t, loc.template)>

		<cfset loc.e = "">
		<cfset loc.t = "{% comment %}{% endcomment %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template)>

		<cfset loc.e = "">
		<cfset loc.t = "{%comment%}comment{%endcomment%}">
		<cfset assert_template_result(loc.e, loc.t, loc.template)>

		<cfset loc.e = "">
		<cfset loc.t = "{% comment %}comment{% endcomment %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template)>

		<cfset loc.e = "foobar">
		<cfset loc.t = "foo{%comment%}comment{%endcomment%}bar">
		<cfset assert_template_result(loc.e, loc.t, loc.template)>

		<cfset loc.e = "foobar">
		<cfset loc.t = "foo{% comment %}comment{% endcomment %}bar">
		<cfset assert_template_result(loc.e, loc.t, loc.template)>

		<cfset loc.e = "foobar">
		<cfset loc.t = "foo{%comment%} comment {%endcomment%}bar">
		<cfset assert_template_result(loc.e, loc.t, loc.template)>

		<cfset loc.e = "foobar">
		<cfset loc.t = "foo{% comment %} comment {% endcomment %}bar">
		<cfset assert_template_result(loc.e, loc.t, loc.template)>

		<cfset loc.e = "foo  bar">
		<cfset loc.t = "foo {%comment%} {%endcomment%} bar">
		<cfset assert_template_result(loc.e, loc.t, loc.template)>

		<cfset loc.e = "foo  bar">
		<cfset loc.t = "foo {%comment%}comment{%endcomment%} bar">
		<cfset assert_template_result(loc.e, loc.t, loc.template)>
		
		<cfset loc.e = "foo  bar">
		<cfset loc.t = "foo {%comment%} comment {%endcomment%} bar">
		<cfset assert_template_result(loc.e, loc.t, loc.template)>

		<cfset loc.e = "foobar">
		<cfset loc.t = "foo{%comment%}
 	                                     {%endcomment%}bar">
		<cfset assert_template_result(loc.e, loc.t, loc.template)>
				
	</cffunction>
	
	<cffunction name="test_for">

		<cfset loc.e = " yo  yo  yo  yo ">
		<cfset loc.t = "{%for item in array%} yo {%endfor%}">
		<cfset loc.a = {}>
		<cfset loc.a["array"] = [1,2,3,4]>
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
		<cfset loc.e = "yoyo">
		<cfset loc.t = "{%for item in array%}yo{%endfor%}">
		<cfset loc.a = {}>
		<cfset loc.a["array"] = [1,2]>
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
		<cfset loc.e = " yo ">
		<cfset loc.t = "{%for item in array%} yo {%endfor%}">
		<cfset loc.a = {}>
		<cfset loc.a["array"] = [1]>
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
		<cfset loc.e = "">
		<cfset loc.t = "{%for item in array%}{%endfor%}">
		<cfset loc.a = {}>
		<cfset loc.a["array"] = [1,2]>
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
		<cfset loc.e = "
  yo

  yo

  yo
">
		<cfset loc.t = "{%for item in array%}
  yo
{%endfor%}">
		<cfset loc.a = {}>
		<cfset loc.a["array"] = [1,2,3]>
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
	</cffunction>
	
	<cffunction name="test_for_using_query">
	
		<cfset loc.q = QueryNew("firstname,lastname")>
		<cfset QueryAddRow(loc.q)>
		<cfset QuerySetCell(loc.q, "firstname", "Tony")>
		<cfset QuerySetCell(loc.q, "lastname", "Petruzzi")>
		<cfset QueryAddRow(loc.q)>
		<cfset QuerySetCell(loc.q, "firstname", "Per")>
		<cfset QuerySetCell(loc.q, "lastname", "Djurner")>
		<cfset loc.e = " Tony, Petruzzi  Per, Djurner ">
		<cfset loc.t = "{%for item in query%} {{item.firstname}}, {{item.lastname}} {%endfor%}">
		<cfset loc.a = {}>
		<cfset loc.a["query"] = loc.q>
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	
	</cffunction>

	<cffunction name="test_for_with_variable">
		
		<cfset loc.e = " 1  2  3 ">
		<cfset loc.t = "{%for item in array%} {{item}} {%endfor%}">
		<cfset loc.a = {}>
		<cfset loc.a["array"] = [1,2,3]>
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>

		<cfset loc.e = "123">
		<cfset loc.t = "{%for item in array%}{{item}}{%endfor%}">
		<cfset loc.a = {}>
		<cfset loc.a["array"] = [1,2,3]>
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>

		<cfset loc.e = "123">
		<cfset loc.t = "{% for item in array %}{{item}}{% endfor %}">
		<cfset loc.a = {}>
		<cfset loc.a["array"] = [1,2,3]>
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>

		<cfset loc.e = "abcd">
		<cfset loc.t = "{%for item in array%}{{item}}{%endfor%}">
		<cfset loc.a = {}>
		<cfset loc.a["array"] = ['a','b','c','d']>
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>

		<cfset loc.e = "a b c">
		<cfset loc.t = "{%for item in array%}{{item}}{%endfor%}">
		<cfset loc.a = {}>
		<cfset loc.a["array"] = ['a',' ','b',' ','c']>
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
		<cfset loc.e = "abc">
		<cfset loc.t = "{%for item in array%}{{item}}{%endfor%}">
		<cfset loc.a = {}>
		<cfset loc.a["array"] = ['a','','b','','c']>
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>

	</cffunction>
	
	<cffunction name="test_for_helpers">
		<cfset loc.a["array"] = [1,2,3]>
		
		<cfset loc.e = " 1/3  2/3  3/3 ">
		<cfset loc.t = "{%for item in array%} {{forloop.index}}/{{forloop.length}} {%endfor%}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>

		<cfset loc.e = " 1  2  3 ">
		<cfset loc.t = "{%for item in array%} {{forloop.index}} {%endfor%}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>

		<cfset loc.e = " 0  1  2 ">
		<cfset loc.t = "{%for item in array%} {{forloop.index0}} {%endfor%}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>

		<cfset loc.e = " 2  1  0 ">
		<cfset loc.t = "{%for item in array%} {{forloop.rindex0}} {%endfor%}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
 
		<cfset loc.e = " 3  2  1 ">
		<cfset loc.t = "{%for item in array%} {{forloop.rindex}} {%endfor%}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>

		<cfset loc.e = " 1  0  0 ">
		<cfset loc.t = "{%for item in array%} {{forloop.first}} {%endfor%}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
		<cfset loc.e = " 0  0  1 ">
		<cfset loc.t = "{%for item in array%} {{forloop.last}} {%endfor%}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>

	</cffunction>

	<cffunction name="test_for_and_if">
		<cfset loc.a["array"] = [1,2,3]>
		
		<cfset loc.e = " yay     ">
		<cfset loc.t = "{%for item in array%} {% if forloop.first %}yay{% endif %} {%endfor%}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
		<cfset loc.e = " yay  boo  boo ">
		<cfset loc.t = "{%for item in array%} {% if forloop.first %}yay{% else %}boo{% endif %} {%endfor%}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>

		<cfset loc.e = "   boo  boo ">
		<cfset loc.t = "{%for item in array%} {% if forloop.first %}{% else %}boo{% endif %} {%endfor%}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>

	</cffunction>

	<cffunction name="test_limiting">
		<cfset loc.a["array"] = [1,2,3,4,5,6,7,8,9,0]>
		
		<cfset loc.e = "12">
		<cfset loc.t = "{%for i in array limit:2 %}{{ i }}{%endfor%}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
		<cfset loc.e = "1234">
		<cfset loc.t = "{%for i in array limit:4 %}{{ i }}{%endfor%}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>

		<cfset loc.e = "3456">
		<cfset loc.t = "{%for i in array limit:4 offset:2 %}{{ i }}{%endfor%}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>

		<cfset loc.e = "3456">
		<cfset loc.t = "{%for i in array limit: 4  offset: 2 %}{{ i }}{%endfor%}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>


		<cfset loc.e = "34">
		<cfset loc.t = "{%for i in array limit: limit offset: offset %}{{ i }}{%endfor%}">
		<cfset loc.a['limit'] = 2>
		<cfset loc.a['offset'] = 2>
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>
	
	<cffunction name="test_nested_for">
		<cfset loc.a["array"] = [[1,2],[3,4],[5,6]]>
		
		<cfset loc.e = "123456">
		<cfset loc.t = "{%for item in array%}{%for i in item%}{{ i }}{%endfor%}{%endfor%}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>

	<cffunction name="test_offset_only">
		<cfset loc.a["array"] = [1,2,3,4,5,6,7,8,9,0]>
		
		<cfset loc.e = "890">
		<cfset loc.t = "{%for i in array offset:7 %}{{ i }}{%endfor%}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>
		
	<cffunction name="test_pause_resume">
		<cfset loc.temp = [1,2,3,4,5,6,7,8,9,0]>
		<cfset loc.a["array"] = {items = loc.temp}>
<cfset loc.t = "
{%for i in array.items limit: 3 %}{{i}}{%endfor%}
next
{%for i in array.items offset:continue limit: 3 %}{{i}}{%endfor%}
next
{%for i in array.items offset:continue limit: 3 %}{{i}}{%endfor%}
">

<cfset loc.e = "
123
next
456
next
789
">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>
	
	<cffunction name="test_pause_resume_limit">
		<cfset loc.temp = [1,2,3,4,5,6,7,8,9,0]>
		<cfset loc.a["array"] = {items = loc.temp}>
<cfset loc.t = "
{%for i in array.items limit: 3 %}{{i}}{%endfor%}
next
{%for i in array.items offset:continue limit: 3 %}{{i}}{%endfor%}
next
{%for i in array.items offset:continue limit: 1 %}{{i}}{%endfor%}
">

<cfset loc.e = "
123
next
456
next
7
">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>
	
	<cffunction name="test_pause_resume_BIG_limit">
		<cfset loc.temp = [1,2,3,4,5,6,7,8,9,0]>
		<cfset loc.a["array"] = {items = loc.temp}>
<cfset loc.t = "
{%for i in array.items limit: 3 %}{{i}}{%endfor%}
next
{%for i in array.items offset:continue limit: 3 %}{{i}}{%endfor%}
next
{%for i in array.items offset:continue limit: 1000 %}{{i}}{%endfor%}
">
<cfset loc.e = "
123
next
456
next
7890
">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>
	
	<cffunction name="test_pause_resume_BIG_offset">
		<cfset loc.temp = [1,2,3,4,5,6,7,8,9,0]>
		<cfset loc.a["array"] = {items = loc.temp}>
<cfset loc.t = "{%for i in array.items limit: 3 %}{{i}}{%endfor%}
next
{%for i in array.items offset:continue limit: 3 %}{{i}}{%endfor%}
next
{%for i in array.items offset:continue limit: 1000 offset:1000 %}{{i}}{%endfor%}">

<cfset loc.e = "123
next
456
next
">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>
	
	<cffunction name="test_assign">
		<cfset loc.a["var"] = "content">
		<cfset loc.e = "var2:  var2:content">
		<cfset loc.t = "var2:{{var2}} {%assign var2 = var%} var2:{{var2}}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>
	
	<cffunction name="test_capture">
		<cfset loc.a["var1"] = "content">
		<cfset loc.e = "content foo content foo ">
		<cfset loc.t = "{{ var3 }}{% capture var3 %}{{ var1 }} foo {% endcapture %}{{ var3 }}{{ var3 }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>
	
	<cffunction name="test_case">
 		<cfset loc.a["condition"] = 2>
		<cfset loc.e = " its 2 ">
		<cfset loc.t = "{% case condition %}{% when 1 %} its 1 {% when 2 %} its 2 {% endcase %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>

		<cfset loc.a["condition"] = 1>
		<cfset loc.e = " its 1 ">
		<cfset loc.t = "{% case condition %}{% when 1 %} its 1 {% when 2 %} its 2 {% endcase %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>

 		<cfset loc.a["condition"] = 3>
		<cfset loc.e = "">
		<cfset loc.t = "{% case condition %}{% when 1 %} its 1 {% when 2 %} its 2 {% endcase %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	
		<cfset loc.a["condition"] = "string here">
		<cfset loc.e = " hit ">
		<cfset loc.t = "{% case condition %}{% when ""string here"" %} hit {% endcase %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>

		<cfset loc.a["condition"] = "bad string here">
		<cfset loc.e = "">
		<cfset loc.t = "{% case condition %}{% when ""string here"" %} hit {% endcase %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>

	<cffunction name="test_case_with_else">
		<cfset loc.a["condition"] = 5>
		<cfset loc.e = " hit ">
		<cfset loc.t = "{% case condition %}{% when 5 %} hit {% else %} else {% endcase %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
 
		<cfset loc.a["condition"] = 6>
		<cfset loc.e = " else ">
		<cfset loc.t = "{% case condition %}{% when 5 %} hit {% else %} else {% endcase %}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>
		
	<cffunction name="test_cycle">
		<cfset loc.e = "one">
		<cfset loc.t = '{%cycle "one", "two"%}'>
		<cfset assert_template_result(loc.e, loc.t, loc.template)>

		<cfset loc.e = "one two">
		<cfset loc.t = '{%cycle "one", "two"%} {%cycle "one", "two"%}'>
		<cfset assert_template_result(loc.e, loc.t, loc.template)>
		
		<cfset loc.e = "one two one">
		<cfset loc.t = '{%cycle "one", "two"%} {%cycle "one", "two"%} {%cycle "one", "two"%}'>
		<cfset assert_template_result(loc.e, loc.t, loc.template)>
	</cffunction>
	
	<cffunction name="test_multiple_cycles">
		<cfset loc.e = "1 2 1 1 2 3 1">
		<cfset loc.t = '{%cycle 1,2%} {%cycle 1,2%} {%cycle 1,2%} {%cycle 1,2,3%} {%cycle 1,2,3%} {%cycle 1,2,3%} {%cycle 1,2,3%}'>
		<cfset assert_template_result(loc.e, loc.t, loc.template)>
	</cffunction>

	<cffunction name="test_multiple_named_cycles">
		<cfset loc.e = "one one two two one one">
		<cfset loc.t = '{%cycle 1: "one", "two" %} {%cycle 2: "one", "two" %} {%cycle 1: "one", "two" %} {%cycle 2: "one", "two" %} {%cycle 1: "one", "two" %} {%cycle 2: "one", "two" %}'>
		<cfset assert_template_result(loc.e, loc.t, loc.template)>
	</cffunction>

	<cffunction name="test_multiple_named_cycles_with_names_from_context">
		<cfset loc.a = {var1 = 1, var2 = 2}>
		<cfset loc.e = "one one two two one one">
		<cfset loc.t = '{%cycle var1: "one", "two" %} {%cycle var2: "one", "two" %} {%cycle var1: "one", "two" %} {%cycle var2: "one", "two" %} {%cycle var1: "one", "two" %} {%cycle var2: "one", "two" %}'>
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>
		
	<cffunction name="test_size_of_array">
		<cfset loc.a["array1"] = [1, 2, 3, 4]>
		<cfset loc.e = "array has 4 elements">
		<cfset loc.t = "array has {{ array1.size }} elements">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>
	
	<cffunction name="test_size_of_hash">
		<cfset loc.a["hash"] = {a = 1, b = 2, c = 3, d = 4}>
		<cfset loc.e = "hash has 4 elements">
		<cfset loc.t = "hash has {{ hash.size }} elements">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>
	
	<cffunction name="test_hash_can_override_size">
		<cfset loc.a["hash"] = {a = 1, b = 2, c = 3, d = 4, size = '5000'}>
		<cfset loc.e = "hash has 5000 elements">
		<cfset loc.t = "hash has {{ hash.size }} elements">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>

	<cffunction name="test_include_tag">
		<cfset loc.a["var"] = [1,2,3]>
		<cfset loc.file_system = createObject("component", "classes.LiquidTestFileSystem")>
		<cfset loc.template.setFileSystem(loc.file_system)>
		<cfset loc.template.parse("Outer-{% include 'inner' with 'value' other:23 %}-Outer{% include 'inner' for var other:'loop' %}")>
		<cfset loc.r = loc.template.render(loc.a)>
		<cfset loc.e = "Outer-Inner: value23-OuterInner: 1loopInner: 2loopInner: 3loop">

		<cfset assert("loc.e eq loc.r")>
	</cffunction>

	<cffunction name="test_include_tag_no_with">
		<cfset loc.a["inner"] = "orig">
		<cfset loc.a["var"] = [1,2,3]>
		<cfset loc.file_system = createObject("component", "classes.LiquidTestFileSystem")>
		<cfset loc.template.setFileSystem(loc.file_system)>
		<cfset loc.template.parse("Outer-{% include 'inner' %}-Outer-{% include 'inner' other:'23' %}")>
		<cfset loc.r = loc.template.render(loc.a)>
		<cfset loc.e = "Outer-Inner: orig-Outer-Inner: orig23">

		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>