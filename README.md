This project aims to port the Liquid Templating Language over to ColdFusion. For the port I'm using the PHP port of the language.

Currect State
=============

All main Libraries, Tags and Filters have been ported. Still porting the test suite over and then it just getting the entire thing passing.

Running Tests
=============

Tests are written using the RocketUnit framework. To run the tests first clone the project into a directory off your webroot called `cfml-liquid`. Next point your browser to `http://localhost/cfml-liquid/tests`.