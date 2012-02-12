<cfcomponent output="false" extends="cfml-liquid.tests.Test">
	
	<cffunction name="setup">
		<cfset loc.a = {}>
		<cfset loc.a['best_cars'] = 'bmw'>
		<cfset loc.a['car'] = {bmw = 'good', gm = 'bad'}>

		<cfset this.filters = createObject("component", "classes.FunnyFilter")>
		<cfset loc.liquid = createObject("component", "cfml-liquid.lib.Liquid").init()>
		<cfset loc.template = createObject("component", "cfml-liquid.lib.liquid.LiquidTemplate").init()>
	</cffunction>

	<cffunction name="test_variable">
		<cfset loc.t = " {{best_cars}} ">
		<cfset loc.e = " bmw ">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>
	
	<cffunction name="test_variable_trasversing">
		<cfset loc.t = " {{car.bmw}} {{car.gm}} {{car.bmw}} ">
		<cfset loc.e = " good bad good ">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>
	
	<cffunction name="test_variable_piping">
		<cfset loc.t = " {{ car.gm | make_funny }} ">
		<cfset loc.e = " LOL ">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>
	
	<cffunction name="test_variable_piping_with_input">
		<cfset loc.t = " {{ car.gm | cite_funny }} ">
		<cfset loc.e = " LOL: bad ">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>

	<cffunction name="test_variable_piping_with_args">
		<cfset loc.t = " {{ car.gm | add_smiley : ':-(' }} ">
		<cfset loc.e = " bad :-( ">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>
	
	<cffunction name="text_variable_piping_with_no_args">
		<cfset loc.t = " {{ car.gm | add_smile }} ">
		<cfset loc.e = " bad :-( ">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>
	
	<cffunction name="test_multiple_variable_piping_with_args">
		<cfset loc.t = " {{ car.gm | add_smiley : ':-(' | add_smiley : ':-('}} ">
		<cfset loc.e = " bad :-( :-( ">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>
		
	<cffunction name="test_variable_piping_with_two_args">
		<cfset loc.t = " {{ car.gm | add_tag : 'span', 'bar'}} ">
		<cfset loc.e = " <span id=""bar"">bad</span> ">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>			
	</cffunction>
	
	<cffunction name="test_variable_piping_with_variable_args">
		<cfset loc.t = " {{ car.gm | add_tag : 'span', car.bmw}} ">
		<cfset loc.e = " <span id=""good"">bad</span> ">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>

	<cffunction name="test_multiple_pipings">
		<cfset loc.t = " {{ best_cars | cite_funny | paragraph }} ">
		<cfset loc.e = " <p>LOL: bmw</p> ">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>		
		
	<cffunction name="test_link_to">
		<cfset loc.t = " {{ 'Typo' | link_to: 'http://typo.leetsoft.com' }} ">
		<cfset loc.e = " <a href=""http://typo.leetsoft.com"">Typo</a> ">
		<cfset assert_template_result(loc.e, loc.t, loc.template, loc.a)>
	</cffunction>
	
</cfcomponent>