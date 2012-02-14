This project aims to port the [Liquid Templating Language](https://github.com/Shopify/liquid) over to [CFML](http://www.getrailo.org/). For the port I'm using the [PHP port](https://github.com/harrydeluxe/php-liquid) of the language.


Currect State
=============
Preparing for preview release


What's left to do
=================
*  Add full support for CFML queries
*  Add some sort of caching for compiled templates


Running Tests
=============

Tests are written using the [RocketUnit framework](http://rocketunit.riaforge.org/). To run the tests first clone the project into a directory off your webroot called `cfml-liquid`. Next point your browser to `http://localhost/cfml-liquid/tests`.