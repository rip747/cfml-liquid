<cfcomponent output="false" extends="cfml-liquid.tests.Test">

	<cffunction name="setup">
		<cfset loc.template = application.liquid.template()>
	</cffunction>
	
	<cffunction name="test_append">
		<cfset loc.a["var"] = "foo">
		<cfset loc.e = "foobar">
		<cfset loc.t = "{{ var | append:'bar' }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>
	
	<cffunction name="test_capitalize">
		<!--- empty string --->
		<cfset loc.a["var"] = "">
		<cfset loc.e = "">
		<cfset loc.t = "{{ var | capitalize }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
		<!--- one word --->
		<cfset loc.a["var"] = "tony">
		<cfset loc.e = "Tony">
		<cfset loc.t = "{{ var | capitalize }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
		<!--- multiple words --->
		<cfset loc.a["var"] = "liquid is great">
		<cfset loc.e = "Liquid is great">
		<cfset loc.t = "{{ var | capitalize }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>
	
	<cffunction name="test_date_format">
		<!--- valid date --->
		<cfset loc.a["var"] = "08/14/2012">
		<cfset loc.e = "2012-08-14">
		<cfset loc.t = "{{ var | date_format:'yyyy-mm-dd' }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
		<!--- invalid date --->
		<cfset loc.a["var"] = "not a date">
		<cfset loc.e = "not a date">
		<cfset loc.t = "{{ var | date_format:'yyyy-mm-dd' }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
		<!--- invalid format --->
		<cfset loc.a["var"] = "08/14/2012">
		<cfset loc.e = "08/14/2012">
		<cfset loc.t = "{{ var | date_format:'' }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>
	
	<cffunction name="test_divided_by">
		<!--- valid --->
		<cfset loc.a["var"] = 20>
		<cfset loc.e = 4>
		<cfset loc.t = "{{ var | divided_by:5 }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
		<!--- without operand --->
		<cfset loc.a["var"] = 5>
		<cfset loc.e = 5>
		<cfset loc.t = "{{ var | divided_by }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
		<!--- divide by zero returns zero --->
		<cfset loc.a["var"] = 5>
		<cfset loc.e = 0>
		<cfset loc.t = "{{ var | divided_by:0 }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>
	
	<cffunction name="test_downcase">
		<!--- empty string --->
		<cfset loc.a["var"] = "">
		<cfset loc.e = "">
		<cfset loc.t = "{{ var | downcase }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
		<!--- one word --->
		<cfset loc.a["var"] = "Tony">
		<cfset loc.e = "tony">
		<cfset loc.t = "{{ var | downcase }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
		<!--- multiple words --->
		<cfset loc.a["var"] = "Liquid Is Great">
		<cfset loc.e = "liquid is great">
		<cfset loc.t = "{{ var | downcase }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>
	
	<cffunction name="test_escape">
		<cfset loc.str = "<html><head></head><body></body></html>">
		<cfset loc.a["var"] = loc.str>
		<cfset loc.e = HtmlEditFormat(loc.str)>
		<cfset loc.t = "{{ var | escape }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>
	
	<cffunction name="test_first">
		<!--- valid array --->
		<cfset loc.a["var"] = [1, 2, 3, 4]>
		<cfset loc.e = "1">
		<cfset loc.t = "{{ var | first }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
		<!--- invalid array --->
		<cfset loc.a["var"] = "dddd">
		<cfset loc.e = "dddd">
		<cfset loc.t = "{{ var | first }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>

	<cffunction name="test_join">
		<!--- valid array --->
		<cfset loc.a["var"] = [1, 2, 3, 4]>
		<cfset loc.e = "1 2 3 4">
		<cfset loc.t = "{{ var | join }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
		<!--- invalid array --->
		<cfset loc.a["var"] = "dddd">
		<cfset loc.e = "dddd">
		<cfset loc.t = "{{ var | join }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>
	
	<cffunction name="test_last">
		<!--- valid array --->
		<cfset loc.a["var"] = [1, 2, 3, 4]>
		<cfset loc.e = "4">
		<cfset loc.t = "{{ var | last }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
		<!--- invalid array --->
		<cfset loc.a["var"] = "dddd">
		<cfset loc.e = "dddd">
		<cfset loc.t = "{{ var | last }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>
	
	<cffunction name="test_minus">
		<!--- valid --->
		<cfset loc.a["var"] = 20>
		<cfset loc.e = 15>
		<cfset loc.t = "{{ var | minus:5 }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
		<!--- without operand --->
		<cfset loc.a["var"] = 5>
		<cfset loc.e = 5>
		<cfset loc.t = "{{ var | minus }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>
	
	<cffunction name="test_modulo">
		<!--- valid --->
		<cfset loc.a["var"] = 20>
		<cfset loc.e = 2>
		<cfset loc.t = "{{ var | modulo:3 }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
		<!--- without operand --->
		<cfset loc.a["var"] = 5>
		<cfset loc.e = 0>
		<cfset loc.t = "{{ var | modulo }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>
	
	<cffunction name="test_newline_to_br">
 		<!--- empty string --->
		<cfset loc.a["var"] = "">
		<cfset loc.e = "">
		<cfset loc.t = "{{ var | newline_to_br }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
		<!--- newline and carriage return (windows) --->
		<cfset loc.a["var"] = "liquid#chr(10)##chr(13)#kewl">
		<cfset loc.e = "liquid<br/>kewl">
		<cfset loc.t = "{{ var | newline_to_br }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
		<cfset loc.a["var"] = "liquid\n\rkewl">
		<cfset loc.e = "liquid<br/>kewl">
		<cfset loc.t = "{{ var | newline_to_br }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>

		<!--- multiple newlinease --->
		<cfset loc.a["var"] = "liquid\n\nkewl">
		<cfset loc.e = "liquid<br/><br/>kewl">
		<cfset loc.t = "{{ var | newline_to_br }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>
	
	<cffunction name="test_plus">
		<!--- valid --->
		<cfset loc.a["var"] = 20>
		<cfset loc.e = 25>
		<cfset loc.t = "{{ var | plus:5 }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
		<!--- without operand --->
		<cfset loc.a["var"] = 5>
		<cfset loc.e = 5>
		<cfset loc.t = "{{ var | plus }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>
	
	<cffunction name="test_prepend">
		<cfset loc.a["var"] = "foo">
		<cfset loc.e = "barfoo">
		<cfset loc.t = "{{ var | prepend:'bar' }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>
	
	<cffunction name="test_remove">
		<cfset loc.a["var"] = "foobarfoobar">
		<cfset loc.e = "barbar">
		<cfset loc.t = "{{ var | remove:'foo' }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>
	
	<cffunction name="test_remove_first">
		<cfset loc.a["var"] = "barbar">
		<cfset loc.e = "bar">
		<cfset loc.t = "{{ var | remove_first:'bar' }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>
	
	<cffunction name="test_replace">
		<cfset loc.a["var"] = "foofoo">
		<cfset loc.e = "barbar">
		<cfset loc.t = "{{ var | replace:'foo','bar' }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>
	
	<cffunction name="test_replace_first">
		<cfset loc.a["var"] = "foofoo">
		<cfset loc.e = "barfoo">
		<cfset loc.t = "{{ var | replace_first:'foo','bar' }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>
	
	<cffunction name="test_size">
		<!--- array --->
		<cfset loc.a["var"] = [1, 2, 3, 4]>
		<cfset loc.e = 4>
		<cfset loc.t = "{{ var | size }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
		<!--- string --->
		<cfset loc.a["var"] = "ddddd">
		<cfset loc.e = 5>
		<cfset loc.t = "{{ var | size }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
		<!--- struct --->
		<cfset loc.a["var"] = {a=1, b=2, c=3}>
		<cfset loc.e = 3>
		<cfset loc.t = "{{ var | size }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
		<!--- using split --->
		<cfset loc.a["var"] = "tony per chris">
		<cfset loc.e = 3>
		<cfset loc.t = "{{ var | split |size }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>
	
	<cffunction name="test_sort">
		<!--- non array --->
  		<cfset loc.a["var"] = "tony per chris">
		<cfset loc.e = "tony per chris">
		<cfset loc.t = "{{ var | sort }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
		<!--- default sort --->
  		<cfset loc.a["var"] = "tony per chris">
		<cfset loc.e = "chris">
		<cfset loc.t = "{{ var | split | sort |first }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
		<!--- specify type --->
		<cfset loc.a["var"] = "4 2 1 3">
		<cfset loc.e = "4">
		<cfset loc.t = "{{ var | split | sort:'numeric' | last }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
		<!--- specify order --->
		<cfset loc.a["var"] = "4 2 1 3">
		<cfset loc.e = "1">
		<cfset loc.t = "{{ var | split | sort:'numeric','desc' | last }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>
	
	<cffunction name="test_split">
		<!--- empty string --->
  		<cfset loc.a["var"] = "">
		<cfset loc.e = "">
		<cfset loc.t = "{{ var | split | first }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
 		
		<!--- default seperator --->
		<cfset loc.a["var"] = "tony per chris">
		<cfset loc.e = "chris">
		<cfset loc.t = "{{ var | split | last }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
		<!--- specify seperator --->
		<cfset loc.a["var"] = "tony,per,chris">
		<cfset loc.e = "chris">
		<cfset loc.t = "{{ var | split:',' | last }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
		<!--- invalid seperator --->
		<cfset loc.a["var"] = "tony per chris">
		<cfset loc.e = "tony per chris">
		<cfset loc.t = "{{ var | split:',' | last }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
		<!--- not return position returns string representation of array --->
		<cfset loc.a["var"] = "tony per chris">
		<cfset loc.e = "[tony, per, chris]">
		<cfset loc.t = "{{ var | split }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>
	
	<cffunction name="test_strip_html">
		<cfset loc.a["var"] = "<b>bla blub</a>">
		<cfset loc.e = "bla blub">
		<cfset loc.t = "{{ var | strip_html }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>
	
	<cffunction name="test_strip_newlines">
 		<!--- empty string --->
 		<cfset loc.a["var"] = "">
		<cfset loc.e = "">
		<cfset loc.t = "{{ var | strip_newlines }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
		<!--- newline and carriage return (windows) --->
		<cfset loc.a["var"] = "liquid#chr(10)##chr(13)#kewl">
		<cfset loc.e = "liquidkewl">
		<cfset loc.t = "{{ var | strip_newlines }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
		<cfset loc.a["var"] = "liquid\n\rkewl">
		<cfset loc.e = "liquidkewl">
		<cfset loc.t = "{{ var | strip_newlines }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>

		<!--- multiple newlinease --->
		<cfset loc.a["var"] = "liquid\n\nkewl">
		<cfset loc.e = "liquidkewl">
		<cfset loc.t = "{{ var | strip_newlines }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
		<!--- specify replacement --->
		<cfset loc.a["var"] = "liquid\n\nkewl">
		<cfset loc.e = "liquid**kewl">
		<cfset loc.t = "{{ var | strip_newlines:'*' }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>
	
	<cffunction name="test_time_format">
		<!--- valid time --->
		<cfset loc.a["var"] = "08/14/2012 05:22 PM">
		<cfset loc.e = "22:17">
		<cfset loc.t = "{{ var | time_format:'mm:HH' }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
		<!--- invalid time --->
		<cfset loc.a["var"] = "not a date">
		<cfset loc.e = "not a date">
		<cfset loc.t = "{{ var | time_format:mm:HH }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
		<!--- invalid format --->
		<cfset loc.a["var"] = "08/14/2012 05:22 PM">
		<cfset loc.e = "08/14/2012 05:22 PM">
		<cfset loc.t = "{{ var | time_format:'' }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>
	
	<cffunction name="test_times">
		<!--- valid --->
		<cfset loc.a["var"] = 5>
		<cfset loc.e = 20>
		<cfset loc.t = "{{ var | times:4 }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
		<!--- without operand --->
		<cfset loc.a["var"] = 5>
		<cfset loc.e = 5>
		<cfset loc.t = "{{ var | times }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>
	
	<cffunction name="test_truncate">
		<!--- valid truncate --->
		<cfset loc.a["var"] = "123456789">
		<cfset loc.e = "1234&hellip;">
		<cfset loc.t = "{{ var | truncate:4 }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
		<!--- blank string --->
		<cfset loc.a["var"] = "">
		<cfset loc.e = "">
		<cfset loc.t = "{{ var | truncate:4 }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>

		<!--- specify overflow --->
		<cfset loc.a["var"] = "123456789">
		<cfset loc.e = "1234@@@">
		<cfset loc.t = "{{ var | truncate:4,'@@@' }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
		<!--- no arguments --->
		<cfset loc.a["var"] = "123456789">
		<cfset loc.e = "123456789">
		<cfset loc.t = "{{ var | truncate }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>
	
	<cffunction name="test_truncatewords">
		<!--- valid truncate --->
		<cfset loc.a["var"] = "This is a test to see if this works or not">
		<cfset loc.e = "This is a test&hellip;">
		<cfset loc.t = "{{ var | truncatewords:4 }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
 		<!--- blank string --->
		<cfset loc.a["var"] = "">
		<cfset loc.e = "">
		<cfset loc.t = "{{ var | truncate_words:4 }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>

		<!--- specify overflow --->
		<cfset loc.a["var"] = "This is a test to see if this works or not">
		<cfset loc.e = "This is a test@@@">
		<cfset loc.t = "{{ var | truncate_words:4,'@@@' }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
		<!--- no arguments --->
		<cfset loc.a["var"] = "This is a test to see if this works or not">
		<cfset loc.e = "This is a&hellip;">
		<cfset loc.t = "{{ var | truncate_words }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>

	<cffunction name="test_upcase">
		<!--- empty string --->
		<cfset loc.a["var"] = "">
		<cfset loc.e = "">
		<cfset loc.t = "{{ var | upcase }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
		<!--- one word --->
		<cfset loc.a["var"] = "Tony">
		<cfset loc.e = "TONY">
		<cfset loc.t = "{{ var | upcase }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
		
		<!--- multiple words --->
		<cfset loc.a["var"] = "liquid is great">
		<cfset loc.e = "LIQUID IS GREAT">
		<cfset loc.t = "{{ var | upcase }}">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>

</cfcomponent>