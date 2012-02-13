<cffunction name="array_flatten" output="false">
	<cfargument name="arr" type="any" required="true">
	<cfset var loc = {}>
	
	<cfset loc.ret = []>

	<cfloop array="#arguments.arr#" index="loc.element">
		
		<cfif IsArray(loc.element)>
			<cfset loc.ret.addAll(array_flatten(loc.element))>
		<cfelse>
			<cfset arrayAppend(loc.ret, loc.element)>
		</cfif>
		
	</cfloop>
	
	<cfreturn loc.ret>
</cffunction>


<cffunction name="pregSplit3" output="false">
	<cfargument name="regex" type="string" required="true" hint="I am the regular expression being used to split the string." />
	<cfargument name="str" type="string" required="true" hint="I am the string being split." />
	<cfargument name="limit" type="numeric" required="false" default="0" hint="the number of results to limit to" />
	<cfargument name="captureDelim" type="boolean" required="false" default="true" hint="should we capture the delim also" />
	<cfset var loc = {}>

	<cfset loc.results = arrayNew(1)>
	<cfset loc.matches = ReMatchNoCase(arguments.regex, arguments.str)>
	
    <cfif ArrayIsEmpty(loc.matches)>
		
		<cfset loc.results[1] = arguments.str>
		<cfreturn loc.results>
		
    </cfif>
	
	<cfset loc.matcheslen = ArrayLen(loc.matches)>
	
	<cfloop from="1" to="#loc.matcheslen#" index="loc.i">
		<cfset loc.match = loc.matches[loc.i]>
		<cfset loc.f = FindNoCase(loc.match, arguments.str)>
		
		<cfif loc.f gt 1>
			<cfset ArrayAppend(loc.results, left(arguments.str, loc.f - 1))>
		</cfif>
		
		<cfset ArrayAppend(loc.results, loc.match)>
		<cfset loc.counter = loc.f + len(loc.match)>
		<cfset loc.strlen = len(arguments.str)>

		<cfif loc.counter lte loc.strlen>
			<cfset arguments.str = right(arguments.str, loc.strlen - loc.counter + 1)>
		</cfif>
		
	</cfloop>

	<cfif len(arguments.str) and FindNoCase(loc.match, arguments.str) eq 0>
		<cfset ArrayAppend(loc.results, arguments.str)>
	</cfif>
	
	<cfreturn loc.results>
</cffunction>


<cffunction name="pregSplit" output="false">
	<cfargument name="regex" type="string" required="true" hint="I am the regular expression being used to split the string." />
	<cfargument name="str" type="string" required="true" hint="I am the string being split." />
	<cfargument name="limit" type="numeric" required="false" default="0" hint="the number of results to limit to" />
	<cfargument name="captureDelim" type="boolean" required="false" default="true" hint="should we capture the delim also" />
	<cfset var loc = {}>
	
	<cfset loc.results = arrayNew(1)>
	<cfset loc.test = REFind(arguments.regex, arguments.str,1,1)>
	<cfset loc.pos = loc.test.pos[1]>
	<cfset loc.len = loc.test.len[1]>
	<cfset loc.oldpos = 1>
	
    <cfif not loc.pos>
		<cfset loc.results[1] = arguments.str>
    </cfif>
	
    <cfloop condition="loc.pos gt 0">
		
		<cfif arguments.limit and ArrayLen(loc.results) gte arguments.limit>
			<cfbreak>
		</cfif>
		
	    <cfif loc.pos-loc.oldpos gt 0>
	        <cfset arrayAppend(loc.results, mid(arguments.str, loc.oldpos, loc.pos-loc.oldpos))>
        </cfif>
		
		<cfif arguments.captureDelim>
	        <cfset arrayAppend(loc.results, mid(arguments.str, loc.pos, loc.len))>
		</cfif>
		
        <cfset loc.oldpos = loc.pos+loc.test.len[1]>
        <cfset loc.test = REFind(arguments.regex, arguments.str, loc.oldpos+1, 1)>
        <cfset loc.pos = loc.test.pos[1]>
        <cfset loc.len = loc.test.len[1]>
		
	</cfloop>
	
	<cfif !arguments.limit OR (arguments.limit and ArrayLen(loc.results) lt arguments.limit)>
		<cfif (len(arguments.str) - loc.oldpos gte 0) AND loc.oldpos gt 1>
			<cfif len(arguments.str) - loc.oldpos eq 0>
				<cfset arrayappend(loc.results, right(arguments.str,1))>
			<cfelse>
				<cfset arrayappend(loc.results, right(arguments.str,len(arguments.str)-loc.oldpos+1))>
			</cfif>
		</cfif>
	</cfif>

	<cfreturn loc.results>
</cffunction>


<cffunction name="method_exists" output="false">
	<cfargument name="class" type="any" required="true">
	<cfargument name="method" type="string" required="true">
	<cfset var loc = {}>

	<cfif IsObject(arguments.class)>
		<cfset loc.class_methods = getMetaData(arguments.class).functions>
	<cfelse>
		<cfset loc.class_methods = getComponentMetaData(arguments.class).functions>
	</cfif>

	<cfloop array="#loc.class_methods#" index="loc.class_method">
		<cfif loc.class_method.name eq arguments.method>
			<cfreturn true>
		</cfif>
	</cfloop>
	
	<cfreturn false>
</cffunction>


<cffunction name="preg_match" output="false" hint="
 * Emulates the preg_match function in PHP for returning a regex match along with any backreferences.
 * 
 * @param regex 	 Regular expression. (Required)
 * @param str 	 String to search. (Required)
 * @return Returns an array. 
 * @author Aaron Eisenberger (aaron@x-clothing.com)
 * @version 1, February 15, 2004 
">
	<cfargument name="regex" type="string" required="true">
	<cfargument name="str" type="string" required="true">
	<cfset var loc = {}>
	
	<cfset loc.results = []>
	<cfset loc.match = "">
	<cfset loc.x = 1>
	
	<cfif REFindNoCase(arguments.regex, arguments.str, 1)>
		
		<cfset loc.match = REFindNoCase(arguments.regex, arguments.str, 1, true)>
		<cfset loc.l = ArrayLen(loc.match.pos)>
		
		<cfloop from="1" to="#loc.l#" index="loc.i">
			
			<cfset loc.results[loc.i] = "">
			
			<cfif loc.match.len[loc.i]>
				<cfset loc.results[loc.i] = mid(arguments.str, loc.match.pos[loc.i], loc.match.len[loc.i])>
			</cfif>
			
		</cfloop>
	</cfif>
	
	<cfreturn loc.results>
</cffunction>

<cffunction name="preg_match_all" output="false" hint="
 * Emulates the preg_match_all function in PHP for returning all regex matches along with their backreferences.
 * 
 * @param regex      Regular expression. (Required)
 * @param str      String to search. (Required)
 * @return Returns an array. 
 * @author Aaron Eisenberger (aaron@x-clothing.com) 
 * @version 1, February 15, 2004 
">
	<cfargument name="regex" type="string" required="true">
	<cfargument name="str" type="string" required="true">
	<cfset var loc = {}>
    
	<cfset loc.results = ArrayNew(2)>
    <cfset loc.pos = 1>
    <cfset loc.loop = 1>
    <cfset loc.match = "">
    
    <cfloop condition="REFindNoCase(arguments.regex, arguments.str, loc.pos)">
		
        <cfset loc.match = REFindNoCase(arguments.regex, arguments.str, loc.pos, true)>
		<cfset loc.l = ArrayLen(loc.match.pos)>
		
        <cfloop from="1" to="#loc.l#" index="loc.i">
			
			<cfset loc.results[loc.i][loc.loop] = "">
			
            <cfif loc.match.len[loc.i]>
                <cfset loc.results[loc.i][loc.loop] = mid(arguments.str, loc.match.pos[loc.i], loc.match.len[loc.i])>
            </cfif>
			
		</cfloop>
        
		<cfset loc.pos = loc.match.pos[1] + loc.match.len[1]>
		<cfset loc.loop++>

    </cfloop>
	
    <cfreturn loc.results>
</cffunction>

<cffunction name="array_shift">
	<cfargument name="arr" type="array" required="true">
	<cfset var loc = {}>
	
	<cfset loc.ret.value = "">
	<cfset loc.ret.arr = []>
	
	<cfif !ArrayIsEmpty(arguments.arr)>
		<cfset loc.ret.value = arguments.arr[1]>
		<cfset ArrayDeleteAt(arguments.arr, 1)>
		<cfset loc.ret.arr = arguments.arr>
	</cfif>
	
	<cfreturn loc.ret>
</cffunction>