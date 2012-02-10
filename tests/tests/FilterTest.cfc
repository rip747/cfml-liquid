<cfcomponent output="false" extends="cfml-liquid.tests.Test">

	<cffunction name="setup">
		<cfset loc.context = createobject("component", "cfml-liquid.lib.liquid.LiquidContext").init()>
	</cffunction>
	
	<cffunction name="create_var_instance">
		<cfargument name="value" type="string" required="true">
		<cfreturn createObject("component", "cfml-liquid.lib.liquid.LiquidVariable").init(
			arguments.value
		)>
	</cffunction>
	
	<cffunction name="create_moneyfilter_instance">
		<cfreturn createObject("component", "classes.MoneyFilter").init()>
	</cffunction>
	
	<cffunction name="test_local_filter">
		<cfset loc.v = create_var_instance('var | money')>
		<cfset loc.f = create_moneyfilter_instance()>
		
		<cfset loc.context.set('var', 1000)>
		<cfset loc.context.add_filters(loc.f)>
		<cfset loc.e = " 1000$ ">
		<cfset loc.r = loc.v.render(loc.context)>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>
<!--- 	
	<cffunction name="test_underscore_in_filter_name">
		<cfset loc.v = create_var_instance('var | money_with_underscore ')>
		<cfset loc.f = create_moneyfilter_instance()>
		
		<cfset loc.context.set('var', 1000)>
		<cfset loc.context.add_filters(loc.f)>
		<cfset loc.e = " 1000$ ">
		<cfset loc.r = loc.v.render(loc.context)>
		<cfset assert('loc.e eq loc.r')>			
	</cffunction>

	<cffunction name="test_second_filter_overwrites_first">
	{
		$var = new LiquidVariable('var | money ');
		<cfset loc.context.set('var', 1000);
		<cfset loc.context.add_filters(new MoneyFilter(), 'money');
		<cfset loc.context.add_filters(new CanadianMoneyFilter(), 'money');
		<cfset loc.assertIdentical(' 1000$ CAD ', $var.render(<cfset loc.context));				
	</cffunction>
	
	<cffunction name="test_size">
	{
		$var = new LiquidVariable("var | size");
		<cfset loc.context.set('var', 1000);
		//<cfset loc.context.add_filters(new MoneyFilter());
		<cfset loc.assertEqual(4, $var.render(<cfset loc.context));		
	</cffunction>
	
	<cffunction name="test_join">
	{
		$var = new LiquidVariable("var | join");
	
		<cfset loc.context.set('var', array(1, 2, 3, 4));
		<cfset loc.assertEqual("1 2 3 4", $var.render(<cfset loc.context));		
	</cffunction>
	
	<cffunction name="test_strip_html"> ()
	{
		$var = new LiquidVariable("var | strip_html");
		
 	    <cfset loc.context.set('var', "<b>bla blub</a>");
 	    <cfset loc.assertEqual("bla blub", $var.render(<cfset loc.context));  
	</cffunction>
	 --->
</cfcomponent>