<cfcomponent output="false" extends="cfml-liquid.tests.Test">
	
	<cffunction name="setup">
		<cfset loc.liquid = createObject("component", "cfml-liquid.lib.Liquid").init()>
		<cfset loc.template = createObject("component", "cfml-liquid.lib.liquid.LiquidTemplate").init()>
	</cffunction>
	
	<cffunction name="test_simple_variable">

		<cfset loc.a = {test = 'worked'}>
		<cfset loc.e = "worked">
		<cfset loc.template.parse("{{test}}")>
		<cfset loc.r = loc.template.render(loc.a)>
		<cfset assert('loc.e eq loc.r')>
		
	</cffunction>
	
	<cffunction name="_test_simple_with_whitespaces">
		<cfset fail()>
		$template = new LiquidTemplate();

	    $template->parse('  {{ test }}  ');
		$this->assertEqual('  worked  ', $template->render(array('test' => 'worked')));
		$this->assertEqual('  worked wonderfully  ', $template->render(array('test' => 'worked wonderfully')));		
	</cffunction>
	
	<cffunction name="_test_ignore_unknown">
		<cfset fail()>
		$template = new LiquidTemplate();
		
		$template->parse('{{ test }}');
		$this->assertEqual('', $template->render());		
	</cffunction>
	
	<cffunction name="_test_array_scoping">
		<cfset fail()>
		$template = new LiquidTemplate();
		
		$template->parse('{{ test.test }}');
		$this->assertEqual('worked', $template->render(array('test'=>array('test'=>'worked'))));
		
		// this wasn't working properly in if tests, test seperately
		$template->parse('{{ foo.bar }}');
		$this->dump($template->render(array('foo' => array())));		
	</cffunction>
	
</cfcomponent>