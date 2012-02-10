<cfcomponent output="false" extends="cfml-liquid.tests.Test">
	
	<cffunction name="test_local_global">
	{
		$template = new LiquidTemplate;
		$template->registerFilter(new MoneyFilter());
		
		$template->parse('{{1000 | money}}');
		$this->assertIdentical(' 1000$ ', $template->render());	
		$this->assertIdentical(' 1000$ CAD ', $template->render(array(null), new CanadianMoneyFilter()));	
	</cffunction>

</cfcomponent>