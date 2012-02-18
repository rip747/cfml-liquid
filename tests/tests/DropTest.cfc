<cfcomponent output="false" extends="cfml-liquid.tests.Test">
	
	<cffunction name="setup">
		<cfset loc.template = application.liquid.template()>
	</cffunction>
	
	<cffunction name="test_product_drop">

		<cfset loc.template.parse('  ')>
		<cfset loc.ProductDrop = createObject("component", "classes.ProductDrop")>
		<cfset loc.a = {product = loc.ProductDrop}>
		<cfset loc.r = loc.template.render(loc.a)>
		<cfset loc.e = '  '>
        <cfset assert("loc.e eq loc.r")>
		
 		<cfset loc.template = application.liquid.template()>
		<cfset loc.template.parse(' {{ product.top_sales }} ')>
		<cfset loc.ProductDrop = createObject("component", "classes.ProductDrop")>
		<cfset loc.a = {product = loc.ProductDrop}>
		<cfset loc.e = raised('loc.template.render(loc.a)')>
        <cfset assert("loc.e.message eq 'worked'")>
		
	</cffunction>

	<cffunction name="test_text_drop">
		
		<cfset loc.template.parse(' {{ product.texts.text }} ')>
		<cfset loc.ProductDrop = createObject("component", "classes.ProductDrop")>
		<cfset loc.a = {product = loc.ProductDrop}>
		<cfset loc.e = loc.template.render(loc.a)>
        <cfset assert("loc.e eq ' text1 '")>

		<cfset loc.template = application.liquid.template()>
		<cfset loc.template.parse(' {{ product.catchall.unknown }} ')>
		<cfset loc.ProductDrop = createObject("component", "classes.ProductDrop")>
		<cfset loc.a = {product = loc.ProductDrop}>
		<cfset loc.e = loc.template.render(loc.a)>
        <cfset assert("loc.e eq ' method: unknown '")>
		
	</cffunction>
	
	<cffunction name="test_text_array_drop">
		
		<cfset loc.template.parse('{% for text in product.texts.get_array %} {{text}} {% endfor %}')>
		<cfset loc.ProductDrop = createObject("component", "classes.ProductDrop")>
		<cfset loc.a = {product = loc.ProductDrop}>
		<cfset loc.e = loc.template.render(loc.a)>
        <cfset assert("loc.e eq ' text1  text2 '")>
		
	</cffunction>

	<cffunction name="test_context_drop">
		
		<cfset loc.template.parse(' {{ context.bar }} ')>
		<cfset loc.ContextDrop = createObject("component", "classes.ContextDrop")>
		<cfset loc.a = {context = loc.ContextDrop, bar = "carrot"}>
		<cfset loc.e = loc.template.render(loc.a)>
        <cfset assert("loc.e eq ' carrot '")>
		
	</cffunction>
	
	<cffunction name="test_nested_context_drop">

		<cfset loc.template.parse(' {{ product.context.foo }} ')>
		<cfset loc.ProductDrop = createObject("component", "classes.ProductDrop")>
		<cfset loc.a = {product = loc.ProductDrop, foo = "monkey"}>
		<cfset loc.e = loc.template.render(loc.a)>
        <cfset assert("loc.e eq ' monkey '")>
		
	</cffunction>
	
</cfcomponent>