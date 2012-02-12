<cfcomponent output="false" extends="cfml-liquid.tests.Test">

	<cffunction name="setup">
		<cfset loc.context = createobject("component", "cfml-liquid.lib.liquid.LiquidContext").init()>
	</cffunction>

	<cffunction name="test_variables">
		<cfset loc.context.set('test', 'test')>
		<cfset loc.e = loc.context.get('test')>
		<cfset assert("loc.e eq 'test'")>
		
		<!--- we add this text to make sure we can return values that evaluate to false properly --->
		<cfset loc.context.set('test_0', 0)>
		<cfset loc.e = loc.context.get('test_0')>
		<cfset assert("loc.e eq 0")>
	</cffunction>

	<cffunction name="test_variables_not_existing">
		<cfset loc.e = loc.context.get('test')>
		<cfset assert("loc.e eq ''")>
	</cffunction>

	<cffunction name="test_scoping">
		<cfset loc.context.push()>
		<cfset loc.e = loc.context.pop()>
		<cfset assert("loc.e eq ''")>
	</cffunction>
	
	<cffunction name="test_length_query">
		<cfset loc.a = [1, 2, 3, 4]>
		<cfset loc.context.set('numbers', loc.a)>
		<cfset loc.e = loc.context.get('numbers.size')>
		<cfset assert("loc.e eq 4")>
		
		<cfset loc.a = {1=1, 2=2, 3=3, 4=4, 5=5}>
		<cfset loc.context.set('numbers', loc.a)>
		<cfset loc.e = loc.context.get('numbers.size')>
		<cfset assert("loc.e eq 5")>

		<cfset loc.a = QueryNew("firstname,lastname")>
		<cfset QueryAddRow(loc.a)>
		<cfset QuerySetCell(loc.a, "firstname", "Tony")>
		<cfset QuerySetCell(loc.a, "lastname", "Petruzzi")>
		<cfset QueryAddRow(loc.a)>
		<cfset QuerySetCell(loc.a, "firstname", "Per")>
		<cfset QuerySetCell(loc.a, "lastname", "Djurner")>
		<cfset loc.context.set('numbers', loc.a)>
		<cfset loc.e = loc.context.get('numbers.size')>
		<cfset assert("loc.e eq 2")>
	</cffunction>

	<cffunction name="test_add_filter">
		<cfset loc.context = createobject("component", "cfml-liquid.lib.liquid.LiquidContext").init()>
		<cfset loc.filter = createobject("component", "classes.HiFilter")>
		<cfset loc.context.add_filters(loc.filter)>
 		<cfset loc.e = loc.context.invoke_method('hi', 'hi?')>
		<cfset assert("loc.e eq 'hi? hi!'")>

		<cfset loc.context = createobject("component", "cfml-liquid.lib.liquid.LiquidContext").init()>
		<cfset loc.e = loc.context.invoke_method('hi', 'hi?')>
		<cfset assert("loc.e eq 'hi?'")>

		<cfset loc.context.add_filters(loc.filter)>
		<cfset loc.e = loc.context.invoke_method('hi', 'hi?')>
		<cfset assert("loc.e eq 'hi? hi!'")>
	</cffunction>
	
	<cffunction name="test_override_global_filter" hint="skip this one for now, as we haven't implemented global filters yet">
		<cfset loc.liquid = createObject("component", "cfml-liquid.lib.Liquid").init()>
		<cfset loc.template = createObject("component", "cfml-liquid.lib.liquid.LiquidTemplate").init()>
		<cfset loc.GlobalFilter = createObject("component", "classes.GlobalFilter")>
		<cfset loc.template.registerFilter(loc.GlobalFilter)>
		
		<cfset loc.template.parse("{{'test' | notice }}")>
		<cfset loc.e = loc.template.render()>
 		<cfset assert("loc.e eq 'Global test'")>
		
		<cfset loc.LocalFilter = createObject("component", "classes.LocalFilter").init()>
		<cfset loc.e = loc.template.render(StructNew(), loc.LocalFilter)>
		<cfset assert("loc.e eq 'Local test'")>
	</cffunction>
	
	<cffunction name="test_add_item_in_outer_scope">
		<cfset loc.context.set('test', 'test')>
		<cfset loc.context.push()>
		<cfset loc.e = loc.context.get('test')>
		<cfset assert("loc.e eq 'test'")>
		<cfset loc.context.pop()>
		<cfset loc.e = loc.context.get('test')>
		<cfset assert("loc.e eq 'test'")>
	</cffunction>

	<cffunction name="test_add_item_in_inner_scope">
		<cfset loc.context.push()>
		<cfset loc.context.set('test', 'test')>
		<cfset loc.e = loc.context.get('test')>
		<cfset assert("loc.e eq 'test'")>
		<cfset loc.context.pop()>
		<cfset loc.e = loc.context.get('test')>
		<cfset assert("loc.e eq ''")>
	</cffunction>
		
	<cffunction name="test_hierchal_data">
		<cfset loc.a = {name = "tobi"}>
		<cfset loc.context.set('hash', loc.a)>
		<cfset loc.e = loc.context.get('hash.name')>
		<cfset assert("loc.e eq 'tobi'")>
	</cffunction>

	<cffunction name="test_keywords">
		<cfset loc.e = loc.context.get('true')>
		<cfset assert("loc.e eq 'true'")>
		<cfset loc.e = loc.context.get('false')>
		<cfset assert("loc.e eq 'false'")>
	</cffunction>
	
	<cffunction name="test_digits">
		<cfset loc.e = loc.context.get(100)>
		<cfset assert("loc.e eq 100")>
		<cfset loc.e = loc.context.get(100.00)>
		<cfset assert("loc.e eq 100.00")>
	</cffunction>
	
	<cffunction name="test_string">
		<cfset loc.e = loc.context.get("'hello!'")>
		<cfset assert("loc.e eq 'hello!'")>
		<cfset loc.e = loc.context.get('"hello!"')>
		<cfset assert("loc.e eq 'hello!'")>
	</cffunction>	

	<cffunction name="test_merge">
		<cfset loc.a = {test = 'test'}>
		<cfset loc.context.merge(loc.a)>
		<cfset loc.e = loc.context.get('test')>
		<cfset assert("loc.e eq 'test'")>
		
		<cfset loc.a = {test = 'newvalue', foo = 'bar'}>
		<cfset loc.context.merge(loc.a)>
		<cfset loc.e = loc.context.get('test')>
		<cfset assert("loc.e eq 'newvalue'")>
		<cfset loc.e = loc.context.get('foo')>
		<cfset assert("loc.e eq 'bar'")>
	</cffunction>
	
	<cffunction name="test_cents">
		<cfset loc.HundredCentes = createObject("component", "classes.HundredCentes")>
		<cfset loc.a = {cents = loc.HundredCentes}>
		<cfset loc.context.merge(loc.a)>
		<cfset loc.e = loc.context.get('cents')>
		<cfset assert("loc.e eq 100")>
	</cffunction>

	<cffunction name="test_nested_cents">
		<cfset loc.HundredCentes = createObject("component", "classes.HundredCentes")>
		<cfset loc.b = {amount = loc.HundredCentes}>
		<cfset loc.a = {cents = loc.b}>
		<cfset loc.context.merge(loc.a)>
		<cfset loc.e = loc.context.get('cents.amount')>
		<cfset assert("loc.e eq 100")>

		<cfset loc.HundredCentes = createObject("component", "classes.HundredCentes")>
		<cfset loc.b = {amount = loc.HundredCentes}>
		<cfset loc.a = {cents = {cents = loc.b}}>
		<cfset loc.context.merge(loc.a)>
		<cfset loc.e = loc.context.get('cents.cents.amount')>
		<cfset assert("loc.e eq 100")>
	</cffunction>
	
	<cffunction name="test_cents_through_drop">
		<cfset loc.CentsDrop = createObject("component", "classes.CentsDrop")>
		<cfset loc.a = {cents = loc.CentsDrop}>
		<cfset loc.context.merge(loc.a)>
		<cfset loc.e = loc.context.get('cents.amount')>
		<cfset assert("loc.e eq 100")>
	</cffunction>
	
	<cffunction name="test_cents_through_drop_nestedly">
		<cfset loc.CentsDrop = createObject("component", "classes.CentsDrop")>
		<cfset loc.a = {cents = {cents = loc.CentsDrop}}>
		<cfset loc.context.merge(loc.a)>
		<cfset loc.e = loc.context.get('cents.cents.amount')>
		<cfset assert("loc.e eq 100")>
 		
		<cfset loc.CentsDrop = createObject("component", "classes.CentsDrop")>
		<cfset loc.a = {cents = {cents = {cents = loc.CentsDrop}}}>
		<cfset loc.context.merge(loc.a)>
		<cfset loc.e = loc.context.get('cents.cents.cents.amount')>
		<cfset assert("loc.e eq 100")>
	</cffunction>

</cfcomponent>