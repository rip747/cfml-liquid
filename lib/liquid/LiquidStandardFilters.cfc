<cfcomponent output="false" hint="A selection of standard filters">

	<cffunction name="init">
		<cfreturn this>
	</cffunction>

	<cffunction name="size" hint="Return the size of an array or of an string">
		<cfargument name="input" type="any" required="true">
		<cfset var ret = arguments.input>
		
		<cfif isSimpleValue(arguments.input)>
			<cfset ret = len(arguments.input)>
		<cfelseif isArray(arguments.input)>
			<cfset ret = ArrayLen(arguments.input)>
		<cfelseif isStruct(arguments.input)>
			<cfset ret = StructCount(arguments.input)>
		<cfelseif isObject(arguments.input)>
			<cfif StructKeyExists(arguments.input, "size")>
				<cfinvoke component="#arguments.input#" method="size" returnvariable="ret">
			</cfif>
		</cfif>
		
		<cfreturn ret>
	</cffunction>

	<cffunction name="downcase" hint="Convert an input to lowercase">
		<cfargument name="input" type="any" required="true">
		<cfif isSimpleValue(arguments.input)>
			<cfreturn lcase(arguments.string)>
		</cfif>
		<cfreturn arguments.input>
	</cffunction>

	<cffunction name="upcase" hint="Convert an input to uppercase">
		<cfargument name="input" type="any" required="true">
		<cfif isSimpleValue(arguments.input)>
			<cfreturn ucase(arguments.string)>
		</cfif>
		<cfreturn arguments.input>
	</cffunction>

	<cffunction name="capitalize" hint="Capitalize words in the input sentence">
		<cfargument name="input" type="any" required="true">
		<cfif isSimpleValue(arguments.input)>
			<cfreturn rereplace(arguments.input, "\b(\w)","\u\1","all")>
		</cfif>
		<cfreturn arguments.input>
	</cffunction>

	<cffunction name="strip_newlines" hint="Strip all newlines (\n, \r) from string">
		<cfargument name="input" type="any" required="true">
		<cfif isSimpleValue(arguments.input)>
			<cfreturn replaceList(arguments.input, "#chr(10)#,#chr(13)#", ",")>
		</cfif>
		<cfreturn arguments.input>
	</cffunction>

	<cffunction name="newline_to_br" hint="Replace each newline (\n) with html break">
		<cfargument name="input" type="any" required="true">
		<cfif isSimpleValue(arguments.input)>
			<cfreturn ReReplace(arguments.input, "\n|\r", "<br/>", "all")>
		</cfif>
		<cfreturn arguments.input>
	</cffunction>

	<cffunction name="truncate" hint="Truncate a string down to x characters">
		<cfargument name="input" type="any" required="true">
		<cfargument name="count" type="any" required="false" default="100">
		<cfset arguments.count = fix(val(arguments.count))>
		<cfif IsSimpleValue(arguments.input) AND Len(arguments.input) gt arguments.count>
			<cfreturn Left(arguments.input, arguments.count) & "&hellip;">
		</cfif>
		<cfreturn arguments.input>
	</cffunction>

	<cffunction name="truncatewords" hint="Truncate string down to x words">
		<cfargument name="input" type="any" required="true">
		<cfargument name="words" type="any" required="false" default="3">
		<cfset arguments.words = fix(val(arguments.words)) - 1>
		<cfif IsSimpleValue(arguments.input)>
			<cfset arguments.input = ListToArray(arguments.input, " ")>
			<cfif ArrayLen(arguments.input) gt arguments.words>
				<cfset arguments.input.subList(0, arguments.words)>
				<cfset arrayAppend(arguments.input, "&hellip;")>
			</cfif>
			<cfset arguments.input = ArrayToList(arguments.input, " ")>
		</cfif>
		<cfreturn arguments.input>
	</cffunction>

	<cffunction name="strip_html" hint="Removes html tags from text">
		<cfargument name="string" type="any" required="true">
		<cfif IsSimpleValue(arguments.string)>
			<cfset arguments.string = REReplaceNoCase(arguments.string, "<\ *[a-z].*?>", "", "all")>
			<cfset arguments.string = REReplaceNoCase(arguments.string, "<\ */\ *[a-z].*?>", "", "all")>
		</cfif>
		<cfreturn arguments.input>
	</cffunction>

	<cffunction name="join" hint="Joins elements of an array with a given character between them">
		<cfargument name="input" type="any" required="true">
		<cfargument name="glue" type="any" required="false" default=" ">
		<cfif IsArray(arguments.input) AND IsSimpleValue(arguments.glue)>
			<cfreturn ArrayToList(arguments.input, arguments.glue)>
		</cfif>
		<cfreturn arguments.input>
	</cffunction>

	<cffunction name="date_format" hint="Formats a date">
		<cfargument name="input" type="any" required="true">
		<cfargument name="format" type="any" required="true">
		<cfif IsDate(arguments.input) AND IsSimpleValue(arguments.format)>
			<cfreturn Dateformat(arguments.input, arguments.format)>
		</cfif>
		<cfreturn arguments.input>
	</cffunction>
	
	<cffunction name="time_format" hint="Formats a time">
		<cfargument name="input" type="any" required="true">
		<cfargument name="format" type="any" required="true">
		<cfif IsValid("time", arguments.input) AND IsSimpleValue(arguments.format)>
			<cfreturn Timeformat(arguments.input, arguments.format)>
		</cfif>
		<cfreturn arguments.input>
	</cffunction>
	
	<cffunction name="datetime_format" hint="Formats a datetime. seperate format with a space">
		<cfargument name="input" type="any" required="true">
		<cfargument name="format" type="any" required="true">
		<cfif IsSimpleValue(arguments.input) AND IsSimpleValue(arguments.format)>
			<cfif ListLen(arguments.input, " ") eq 2>
				<cfreturn date_format(GetToken(arguments.input, 1, " "), GetToken(arguments.format, 1, " ")) & " " & time_format(GetToken(arguments.input, 2, " "), GetToken(arguments.format, 2, " "))>
			<cfelse>
				<cfreturn date_format(GetToken(arguments.input, 1, " "), GetToken(arguments.format, 1, " "))>
			</cfif>
		</cfif>
		<cfreturn arguments.input>
	</cffunction>

	<cffunction name="first" hint="Returns the first element of an array">
		<cfargument name="input" type="any" required="true">
		<cfif IsArray(arguments.input) AND !ArrayIsEmpty(arguments.input)>
			<cfreturn arguments.input[1]>
		</cfif>
		<cfreturn arguments.input>
	</cffunction>

	<cffunction name="last" hint="Returns the last element of an array">
		<cfargument name="input" type="any" required="true">
		<cfif IsArray(arguments.input) AND !ArrayIsEmpty(arguments.input)>
			<cfreturn arguments.input[ArrayLen(arguments.input)]>
		</cfif>
		<cfreturn arguments.input>
	</cffunction>

	<cffunction name="split" hint="Split input string into an array of substrings separated by given pattern.">
		<cfargument name="input" type="any" required="true">
		<cfargument name="pattern" type="any" required="true">
		<cfif IsSimpleValue(arguments.input) AND IsSimpleValue(arguments.pattern)>
			<cfreturn ListToArray(arguments.input, arguments.pattern)>
		</cfif>
		<cfreturn arguments.input>		
	</cffunction>

	<cffunction name="plus" hint="addition">
		<cfargument name="input" type="any" required="true">
		<cfargument name="operand" type="any" required="true">
		<cfreturn val(arguments.input) + val(arguments.operand)>		
	</cffunction>	

	<cffunction name="minus" hint="subtraction">
		<cfargument name="input" type="any" required="true">
		<cfargument name="operand" type="any" required="true">
		<cfreturn val(arguments.input) - val(arguments.operand)>	
	</cffunction>	

	<cffunction name="times" hint="multiplication">
		<cfargument name="input" type="any" required="true">
		<cfargument name="operand" type="any" required="true">
		<cfreturn val(arguments.input) * val(arguments.operand)>		
	</cffunction>

	<cffunction name="divided_by" hint="division">
		<cfargument name="input" type="any" required="true">
		<cfargument name="operand" type="any" required="true">
		<cfreturn val(arguments.input) / val(arguments.operand)>	
	</cffunction>

	<cffunction name="modulo" hint="modulo">
		<cfargument name="input" type="any" required="true">
		<cfargument name="operand" type="any" required="true">
		<cfreturn val(arguments.input) % val(arguments.operand)>	
	</cffunction>
	
</cfcomponent>