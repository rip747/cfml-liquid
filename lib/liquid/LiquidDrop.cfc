<cfcomponent output="false" hint="

A drop in liquid is a class which allows you to to export DOM like things to liquid
Methods of drops are callable. 
The main use for liquid drops is the implement lazy loaded objects. 
If you would like to make data available to the web designers which you don't want loaded unless needed then 
a drop is a great way to do that

Example:

class ProductDrop extends LiquidDrop {
   function top_sales() {
      Products::find('all', array('order' => 'sales', 'limit' => 10 ));
   }
}

tmpl = Liquid::Template.parse( ' {% for product in product.top_sales %} {{ product.name }} {%endfor%} '  )
tmpl.render('product' => ProductDrop.new ) * will invoke top_sales query. 

Your drop can either implement the methods sans any parameters or implement the _beforeMethod(name) method which is a catch all

">

	<!--- LiquidContext --->
	<cfset variables._context = "">


	<cffunction name="beforeMethod" hint="Catch all method that is invoked before a specific method">
		<cfargument name="method" type="string" required="true">
	</cffunction>


	<cffunction name="setContext" hint="sets the context of the drop">
		<cfargument name="context" type="any" required="true">
		<cfreturn variables._context = arguments.context>
	</cffunction>

	<cffunction name="invokeDrop" hint="Invoke a specific method">
		<cfargument name="method" type="string" required="true">
		<cfset var loc = {}>
		
		<cfif this.hasKey(arguments.method)>
			<cfreturn "">
		</cfif>
		
		<cfset loc.ret = this.beforeMethod(arguments.method)>

		<cfif !StructKeyExists(loc, "ret")>
			<cfinvoke component="#this#" method="#arguments.method#" returnvariable="loc.ret">
		</cfif>
		
		<cfreturn loc.ret>
	</cffunction>

	<cffunction name="hasKey" hint="Returns true if the drop supports the given method">
		<cfargument name="name" type="string" required="true">
		<cfreturn StructKeyExists(this, arguments.name)>
	</cffunction>

	<cffunction name="toLiquid" hint="return this drop instance">
		<cfreturn this>
	</cffunction>

	<cffunction name="toString" hint="return the name of the class">
		<cfreturn getMetaData(this).name>
	</cffunction>

</cfcomponent>