<cfcomponent output="false" hint="A selection of standard filters">

	<cffunction name="init">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="append" hint="append a string">
		<cfargument name="input" type="any" required="true">
		<cfargument name="str" type="any" required="false" default="">
		
		<cfset arguments.input = arguments.input.toString()>
		<cfset arguments.str = arguments.str.toString()>

		<cfreturn arguments.input & arguments.str>
	</cffunction>
	
	<cffunction name="prepend" hint="prepend a string">
		<cfargument name="input" type="any" required="true">
		<cfargument name="str" type="any" required="false" default="">
		
		<cfset arguments.input = arguments.input.toString()>
		<cfset arguments.str = arguments.str.toString()>

		<cfreturn arguments.str & arguments.input>
	</cffunction>
	
	<cffunction name="capitalize" hint="Capitalize words in the input sentence">
		<cfargument name="input" type="any" required="true">
		
		<cfset arguments.input = arguments.input.toString()>
		
		<cfreturn rereplace(arguments.input, "\b(\w)","\u\1","all")>
	</cffunction>
	
	<cffunction name="date_format" hint="Formats a date">
		<cfargument name="input" type="any" required="true">
		<cfargument name="format" type="any" required="false" default="mm/dd/yyyy">
		
		<cfset arguments.input = arguments.input.toString()>
		<cfset arguments.format = arguments.format.toString()>
		
		<cfif IsDate(arguments.input) AND len(arguments.format)>
			<cfset arguments.input = Dateformat(arguments.input, arguments.format)>
		</cfif>
		
		<cfreturn arguments.input>
	</cffunction>
	
	<cffunction name="divided_by" hint="division">
		<cfargument name="input" type="any" required="true">
		<cfargument name="operand" type="any" required="false" default="1">
		
		<cfset arguments.input = val(arguments.input)>
		<cfset arguments.operand = val(arguments.operand)>
		
		<cfif arguments.operand eq 0>
			<cfreturn 0>
		</cfif>
		
		<cfreturn arguments.input / arguments.operand>
	</cffunction>
	
	<cffunction name="downcase" hint="Convert an input to lowercase">
		<cfargument name="input" type="any" required="true">
		
		<cfset arguments.input = arguments.input.toString()>
		<cfset arguments.input = lcase(arguments.input)>

		<cfreturn arguments.input>
	</cffunction>
	
	<cffunction name="escape" hint="escape a string">
		<cfargument name="input" type="any" required="true">
		
		<cfset arguments.input = arguments.input.toString()>

		<cfreturn HtmlEditFormat(arguments.input)>
	</cffunction>
	
	<cffunction name="first" hint="Returns the first element of an array">
		<cfargument name="input" type="any" required="true">

		<cfif IsArray(arguments.input)>
			<cfif !ArrayIsEmpty(arguments.input)>
				<cfset arguments.input = arguments.input[1]>
			<cfelse>
				<cfset arguments.input = "">
			</cfif>
		</cfif>
		
		<cfreturn arguments.input>
	</cffunction>
	
	<cffunction name="join" hint="Joins elements of an array with a given character between them">
		<cfargument name="input" type="any" required="true">
		<cfargument name="glue" type="any" required="false" default=" ">
		
		<cfif IsArray(arguments.input)>
			<cfset arguments.glue = arguments.glue.toString()>
			<cfset arguments.input = ArrayToList(arguments.input, arguments.glue)>
		</cfif>
		
		<cfreturn arguments.input>
	</cffunction>

	<cffunction name="last" hint="Returns the last element of an array">
		<cfargument name="input" type="any" required="true">
		
		<cfif IsArray(arguments.input)>
			<cfif !ArrayIsEmpty(arguments.input)>
				<cfset arguments.input = arguments.input[ArrayLen(arguments.input)]>
			<cfelse>
				<cfset arguments.input = "">
			</cfif>
		</cfif>
		
		<cfreturn arguments.input>
	</cffunction>
	
	<cffunction name="minus" hint="subtraction">
		<cfargument name="input" type="any" required="true">
		<cfargument name="operand" type="any" required="false" default="0">
		<cfreturn val(arguments.input) - val(arguments.operand)>	
	</cffunction>
	
	<cffunction name="modulo" hint="modulo">
		<cfargument name="input" type="any" required="true">
		<cfargument name="operand" type="any" required="false" default="1">
		<cfreturn val(arguments.input) % val(arguments.operand)>	
	</cffunction>
	
	<cffunction name="newline_to_br" hint="Replace each newline (\n) with html break">
		<cfargument name="input" type="any" required="true">
		
		<cfset arguments.input = arguments.input.toString()>
		<cfset arguments.input = ReReplaceNoCase(arguments.input, "\n\r|\\n\\r|\n|\\n", "<br/>", "all")>
		
		<cfreturn arguments.input>
	</cffunction>
	
	<cffunction name="plus" hint="addition">
		<cfargument name="input" type="any" required="false">
		<cfargument name="operand" type="any" required="false" default="0">
		<cfreturn val(arguments.input) + val(arguments.operand)>		
	</cffunction>
	
	<cffunction name="remove" hint="remove each occurrence">
		<cfargument name="input" type="any" required="true">
		<cfargument name="string" type="any" required="false" default="">
		
		<cfset arguments.input = arguments.input.toString()>
		<cfset arguments.string = arguments.string.toString()>
		
		<cfreturn ReplaceNoCase(arguments.input, arguments.string, "", "all")>
	</cffunction>
	
	<cffunction name="remove_first" hint="remove each occurrence">
		<cfargument name="input" type="any" required="true">
		<cfargument name="string" type="any" required="false" default="">
		
		<cfset arguments.input = arguments.input.toString()>
		<cfset arguments.string = arguments.string.toString()>
		
		<cfreturn ReplaceNoCase(arguments.input, arguments.string, "", "one")>
	</cffunction>
	
	<cffunction name="_replace" hint="replace each occurrence">
		<cfargument name="input" type="any" required="true">
		<cfargument name="string1" type="any" required="false" default="">
		<cfargument name="string2" type="any" required="false" default="">
		
		<cfset arguments.input = arguments.input.toString()>
		<cfset arguments.string1 = arguments.string1.toString()>
		<cfset arguments.string2 = arguments.string2.toString()>
		
		<cfreturn ReplaceNoCase(arguments.input, arguments.string1, arguments.string2, "all")>
	</cffunction>
	
	<cffunction name="replace_first" hint="replace the first occurrence">
		<cfargument name="input" type="any" required="true">
		<cfargument name="string1" type="any" required="false" default="">
		<cfargument name="string2" type="any" required="false" default="">
		
		<cfset arguments.input = arguments.input.toString()>
		<cfset arguments.string1 = arguments.string1.toString()>
		<cfset arguments.string2 = arguments.string2.toString()>
		
		<cfreturn ReplaceNoCase(arguments.input, arguments.string1, arguments.string2, "one")>
	</cffunction>

	<cffunction name="size" hint="Return the size of an array or of an string or hash">
		<cfargument name="input" type="any" required="true">
		<cfset var ret = arguments.input>
		
		<cfif isSimpleValue(arguments.input)>
			<cfset ret = len(arguments.input)>
		<cfelseif isArray(arguments.input)>
			<cfset ret = ArrayLen(arguments.input)>
		<cfelseif isStruct(arguments.input)>
			<cfset ret = StructCount(arguments.input)>
		</cfif>
		
		<cfreturn ret>
	</cffunction>
	
	<cffunction name="sort" hint="sorts an array">
		<cfargument name="input" type="any" required="true">
		<cfargument name="type" type="any" required="false" default="textnocase">
		<cfargument name="order" type="any" required="false" default="asc">
		
		<cfif IsArray(arguments.input)>
		
			<cfset arguments.type = arguments.type.toString()>
			<cfset arguments.order = arguments.order.toString()>
			
			<cfif !ListFindNoCase("numeric,text,textnocase", arguments.type)>
				<cfset arguments.type = "textnocase">
			</cfif>
			
			<cfif !ListFindNoCase("asc,desc", arguments.order)>
				<cfset arguments.order = "asc">
			</cfif>
			
			<cfset ArraySort(arguments.input, arguments.type, arguments.order)>
		
		</cfif>
		
		<cfreturn arguments.input>
	</cffunction>

	<cffunction name="split" hint="Split input string into an array of substrings separated by given pattern.">
		<cfargument name="input" type="any" required="true">
		<cfargument name="pattern" type="any" required="false" default=" ">
		
		<cfset arguments.input = arguments.input.toString()>
		<cfset arguments.pattern = arguments.pattern.toString()>

		<cfreturn ListToArray(arguments.input, arguments.pattern)>
	</cffunction>

	<cffunction name="strip_html" hint="Removes html tags from text">
		<cfargument name="input" type="any" required="true">
		
		<cfset arguments.input = arguments.input.toString()>
		<cfset arguments.input = REReplaceNoCase(arguments.input, "<\ *[a-z].*?>", "", "all")>
		<cfset arguments.input = REReplaceNoCase(arguments.input, "<\ */\ *[a-z].*?>", "", "all")>
		
		<cfreturn arguments.input>
	</cffunction>

	<cffunction name="strip_newlines" hint="Strip all newlines (\n, \r) from string">
		<cfargument name="input" type="any" required="true">
		<cfargument name="replacement" type="any" required="false" default="">
		
		<cfset arguments.input = arguments.input.toString()>

		<cfreturn ReReplaceNoCase(arguments.input, "\n\r|\\n\\r|\n|\\n", arguments.replacement, "all")>
	</cffunction>
	
	<cffunction name="time_format" hint="Formats a time">
		<cfargument name="input" type="any" required="true">
		<cfargument name="format" type="any" required="false" default="hh:mm tt">

		<cfset arguments.input = arguments.input.toString()>
		<cfset arguments.format = arguments.format.toString()>

		<cfif IsValid("time", arguments.input) AND len(arguments.format)>
			<cfreturn Timeformat(arguments.input, arguments.format)>
		</cfif>

		<cfreturn arguments.input>
	</cffunction>
	
	<cffunction name="times" hint="multiplication">
		<cfargument name="input" type="any" required="true">
		<cfargument name="operand" type="any" required="false" default="1">
		<cfreturn val(arguments.input) * val(arguments.operand)>		
	</cffunction>
	
	<cffunction name="truncate" hint="Truncate a string down to x characters">
		<cfargument name="input" type="any" required="true">
		<cfargument name="count" type="any" required="false" default="100">
		<cfargument name="overflow" type="string" required="false" default="&hellip;">
		
		<cfset arguments.input = arguments.input.toString()>
		<cfset arguments.count = fix(val(arguments.count))>
		<cfset arguments.overflow = arguments.overflow.toString()>
		
		<cfif Len(arguments.input) gt arguments.count>
			<cfset arguments.input = Left(arguments.input, arguments.count) & arguments.overflow>
		</cfif>
		
		<cfreturn arguments.input>
	</cffunction>

	<cffunction name="truncatewords" hint="Truncate string down to x words">
		<cfargument name="input" type="any" required="true">
		<cfargument name="words" type="any" required="false" default="3">
		<cfargument name="overflow" type="string" required="false" default="&hellip;">
		
		<cfset arguments.input = arguments.input.toString()>
		<cfset arguments.words = fix(val(arguments.words))>
		<cfset arguments.input = ListToArray(arguments.input, " ")>
	
		<cfif ArrayLen(arguments.input) gt arguments.words>

			<cfset arguments.input = arguments.input.subList(0, arguments.words)>
			<cfset arguments.input = ArrayToList(arguments.input, " ") & arguments.overflow>
			
		<cfelse>
			<cfset arguments.input = ArrayToList(arguments.input, " ")>
		</cfif>

		<cfreturn arguments.input>
	</cffunction>
	
	<cffunction name="truncate_words" hint="alias for truncatewords">
		<cfargument name="input" type="any" required="true">
		<cfargument name="words" type="any" required="false" default="3">
		<cfargument name="overflow" type="string" required="false" default="&hellip;">
		<cfreturn this.truncatewords(argumentCollection=arguments)>
	</cffunction>

	<cffunction name="upcase" hint="Convert an input to uppercase">
		<cfargument name="input" type="any" required="true">
		
		<cfset arguments.input = arguments.input.toString()>
		<cfreturn ucase(arguments.input)>
	</cffunction>

</cfcomponent>