<cffunction name="array_flatten">
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

<cffunction name="pregSplit">
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


<cfscript>
/**
 * Emulates the preg_match function in PHP for returning a regex match along with any backreferences.
 * 
 * @param regex 	 Regular expression. (Required)
 * @param str 	 String to search. (Required)
 * @return Returns an array. 
 * @author Aaron Eisenberger (&#97;&#97;&#114;&#111;&#110;&#64;&#120;&#45;&#99;&#108;&#111;&#116;&#104;&#105;&#110;&#103;&#46;&#99;&#111;&#109;) 
 * @version 1, February 15, 2004 
 */
function preg_match(regex,str) {
	var results = arraynew(1);
	var match = "";
	var x = 1;
	if (REFindNoCase(regex, str, 1)) { 
		match = REFindNoCase(regex, str, 1, TRUE); 
		for (x = 1; x lte arrayLen(match.pos); x = x + 1) {
			if(match.len[x])
				results[x] = mid(str, match.pos[x], match.len[x]);
			else
				results[x] = '';
		}
	}
	return results;
}

/**
 * Emulates the preg_match_all function in PHP for returning all regex matches along with their backreferences.
 * 
 * @param regex      Regular expression. (Required)
 * @param str      String to search. (Required)
 * @return Returns an array. 
 * @author Aaron Eisenberger (aaron@x-clothing.com) 
 * @version 1, February 15, 2004 
 */
function preg_match_all(regex,str) {
    var results = arraynew(2);
    var pos = 1;
    var loop = 1;
    var match = "";
    var x= 1;
    
    while (REFindNoCase(regex, str, pos)) { 
        match = REFindNoCase(regex, str, pos, TRUE); 
        for (x = 1; x lte arrayLen(match.pos); x = x + 1) {
            if(match.len[x])
                results[x][loop] = mid(str, match.pos[x], match.len[x]);
            else
                results[x][loop] = '';
        }
        pos = match.pos[1] + match.len[1];
        loop = loop + 1;
    }
    return results;
}

function array_shift(arr){
	var ret = StructNew();
	ret.value = "";
	ret.arr = ArrayNew(1);
	
	if(!ArrayIsEmpty(arguments.arr)){
		ret.value = arguments.arr[1];
		ArrayDeleteAt(arguments.arr, 1);
		ret.arr = arguments.arr;
	}
	return ret;
}
</cfscript>