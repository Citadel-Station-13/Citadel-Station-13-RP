/**
 * Holds procs designed to change one type of value, into another.
 *
 * Contains:
 * * hex2num & num2hex
 * * text2list & list2text
 * * file2list
 * * angle2dir
 * * angle2text
 * * worldtime2text
 */

/**
 * Returns an integer given a hex input, supports negative values "-ff"
 * skips preceding invalid characters
 * breaks when hittin invalid characters thereafter
 *  If safe=TRUE, returns null on incorrect input strings instead of CRASHing
 */
/proc/hex2num(hex, safe=FALSE)
	. = 0
	var/place = 1
	for(var/i in length(hex) to 1 step -1)
		var/num = text2ascii(hex, i)
		switch(num)
			if(48 to 57)
				num -= 48	//0-9
			if(97 to 102)
				num -= 87	//a-f
			if(65 to 70)
				num -= 55	//A-F
			if(45)
				return . * -1 // -
			else
				if(safe)
					return null
				else
					CRASH("Malformed hex number")

		. += num * place
		place *= 16


/**
 * Returns the hex value of a number given a value assumed to be a base-ten value.
 */
/proc/num2hex(num, padlength)
	var/global/list/hexdigits = list("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F")

	. = ""
	while(num > 0)
		var/hexdigit = hexdigits[(num & 0xF) + 1]
		. = "[hexdigit][.]"
		num >>= 4 //go to the next half-byte

	//pad with zeroes
	var/left = padlength - length(.)
	while (left-- > 0)
		. = "0[.]"

/proc/text2numlist(text, delimiter="\n")
	var/list/num_list = list()
	for(var/x in splittext(text, delimiter))
		num_list += text2num(x)
	return num_list

/**
 * Turns a direction into text.
 */
/proc/num2dir(direction)
	switch (direction)
		if (1.0) return NORTH
		if (2.0) return SOUTH
		if (4.0) return EAST
		if (8.0) return WEST
		else
			log_world("UNKNOWN DIRECTION: [direction]")

/**
 * Splits the text of a file at seperator and returns them in a list.
 * Returns an empty list if the file doesn't exist.
 */
/world/proc/file2list(filename, seperator="\n", trim = TRUE)
	if (trim)
		return splittext(trim(file2text(filename)),seperator)
	return splittext(file2text(filename),seperator)

/**
 * Turns a direction into text.
 */
/proc/dir2text(direction)
	switch (direction)
		if (NORTH)
			return "north"
		if (SOUTH)
			return "south"
		if (EAST)
			return "east"
		if (WEST)
			return "west"
		if (NORTHEAST)
			return "northeast"
		if (SOUTHEAST)
			return "southeast"
		if (NORTHWEST)
			return "northwest"
		if (SOUTHWEST)
			return "southwest"
		if (UP)
			return "up"
		if (DOWN)
			return "down"

/**
 * Turns text into proper directions.
 */
/proc/text2dir(direction)
	switch (uppertext(direction))
		if ("NORTH")
			return 1
		if ("SOUTH")
			return 2
		if ("EAST")
			return 4
		if ("WEST")
			return 8
		if ("NORTHEAST")
			return 5
		if ("NORTHWEST")
			return 9
		if ("SOUTHEAST")
			return 6
		if ("SOUTHWEST")
			return 10

/**
 * Converts an angle (degrees) into an ss13 direction.
 */
/proc/angle2dir(degree)
	degree = (degree + 22.5) % 365 // 22.5 = 45 / 2
	if (degree < 45)
		return NORTH
	if (degree < 90)
		return NORTHEAST
	if (degree < 135)
		return EAST
	if (degree < 180)
		return SOUTHEAST
	if (degree < 225)
		return SOUTH
	if (degree < 270)
		return SOUTHWEST
	if (degree < 315)
		return WEST
	return NORTH|WEST

/**
 * Returns the north-zero clockwise angle in degrees, given a direction.
 */
/proc/dir2angle(direction)
	switch (direction)
		if (NORTH)
			return 0
		if (SOUTH)
			return 180
		if (EAST)
			return 90
		if (WEST)
			return 270
		if (NORTHEAST)
			return 45
		if (SOUTHEAST)
			return 135
		if (NORTHWEST)
			return 315
		if (SOUTHWEST)
			return 225

/**
 * Returns the angle in english.
 */
/proc/angle2text(degree)
	return dir2text(angle2dir(degree))

/**
 * Converts a blend_mode constant to one acceptable to icon.Blend()
 */
/proc/blendMode2iconMode(blend_mode)
	switch (blend_mode)
		if (BLEND_MULTIPLY)
			return ICON_MULTIPLY
		if (BLEND_ADD)
			return ICON_ADD
		if (BLEND_SUBTRACT)
			return ICON_SUBTRACT
		else
			return ICON_OVERLAY

/**
 * Converts a rights bitfield into a string.
 */
/proc/rights2text(rights,seperator="")
	if (rights & R_BUILDMODE)
		. += "[seperator]+BUILDMODE"
	if (rights & R_ADMIN)
		. += "[seperator]+ADMIN"
	if (rights & R_BAN)
		. += "[seperator]+BAN"
	if (rights & R_FUN)
		. += "[seperator]+FUN"
	if (rights & R_SERVER)
		. += "[seperator]+SERVER"
	if (rights & R_DEBUG)
		. += "[seperator]+DEBUG"
	if (rights & R_POSSESS)
		. += "[seperator]+POSSESS"
	if (rights & R_PERMISSIONS)
		. += "[seperator]+PERMISSIONS"
	if (rights & R_STEALTH)
		. += "[seperator]+STEALTH"
	if (rights & R_REJUVINATE)
		. += "[seperator]+REJUVINATE"
	if (rights & R_VAREDIT)
		. += "[seperator]+VAREDIT"
	if (rights & R_SOUNDS)
		. += "[seperator]+SOUND"
	if (rights & R_SPAWN)
		. += "[seperator]+SPAWN"
	if (rights & R_MOD)
		. += "[seperator]+MODERATOR"
	if (rights & R_EVENT)
		. += "[seperator]+EVENT"
	return .

// Very ugly, BYOND doesn't support unix time and rounding errors make it really hard to convert it to BYOND time.
// returns "YYYY-MM-DD" by default
/proc/unix2date(timestamp, seperator = "-")
	if(timestamp < 0)
		return 0 //Do not accept negative values

	var/const/dayInSeconds = 86400 //60secs*60mins*24hours
	var/const/daysInYear = 365 //Non Leap Year
	var/const/daysInLYear = daysInYear + 1//Leap year
	var/days = round(timestamp / dayInSeconds) //Days passed since UNIX Epoc
	var/year = 1970 //Unix Epoc begins 1970-01-01
	var/tmpDays = days + 1 //If passed (timestamp < dayInSeconds), it will return 0, so add 1
	var/monthsInDays = list() //Months will be in here ***Taken from the PHP source code***
	var/month = 1 //This will be the returned MONTH NUMBER.
	var/day //This will be the returned day number.

	while(tmpDays > daysInYear) //Start adding years to 1970
		year++
		if(isLeap(year))
			tmpDays -= daysInLYear
		else
			tmpDays -= daysInYear

	if(isLeap(year)) //The year is a leap year
		monthsInDays = list(-1,30,59,90,120,151,181,212,243,273,304,334)
	else
		monthsInDays = list(0,31,59,90,120,151,181,212,243,273,304,334)

	var/mDays = 0;
	var/monthIndex = 0;

	for(var/m in monthsInDays)
		monthIndex++
		if(tmpDays > m)
			mDays = m
			month = monthIndex

	day = tmpDays - mDays //Setup the date

	return "[year][seperator][((month < 10) ? "0[month]" : month)][seperator][((day < 10) ? "0[day]" : day)]"

/proc/isLeap(y)
	return ((y) % 4 == 0 && ((y) % 100 != 0 || (y) % 400 == 0))

/proc/type2parent(child)
	var/string_type = "[child]"
	var/last_slash = findlasttext(string_type, "/")
	if(last_slash == 1)
		switch(child)
			if(/datum)
				return null
			if(/obj, /mob)
				return /atom/movable
			if(/area, /turf)
				return /atom
			else
				return /datum
	return text2path(copytext(string_type, 1, last_slash))

//returns a string the last bit of a type, without the preceeding '/'
/proc/type2top(the_type)
	//handle the builtins manually
	if(!ispath(the_type))
		return
	switch(the_type)
		if(/datum)
			return "datum"
		if(/atom)
			return "atom"
		if(/obj)
			return "obj"
		if(/mob)
			return "mob"
		if(/area)
			return "area"
		if(/turf)
			return "turf"
		else //regex everything else (works for /proc too)
			return lowertext(replacetext("[the_type]", "[type2parent(the_type)]/", ""))

/// Return html to load a url.
/// for use inside of browse() calls to html assets that might be loaded on a cdn.
/proc/url2htmlloader(url)
	return {"<html><head><meta http-equiv="refresh" content="0;URL='[url]'"/></head><body onLoad="parent.location='[url]'"></body></html>"}

// Converts a string into ascii then converts it into hexadecimal.
/proc/strtohex(str)
	if(!istext(str)||!str)
		return
	var/r
	var/c
	for(var/i = 1 to length(str))
		c= text2ascii(str,i)
		r+= num2hex(c)
	return r

// Decodes hexadecimal ascii into a raw byte string.
// If safe=TRUE, returns null on incorrect input strings instead of CRASHing
/proc/hextostr(str, safe=FALSE)
	if(!istext(str)||!str)
		return
	var/r
	var/c
	for(var/i = 1 to length(str)/2)
		c = hex2num(copytext(str,i*2-1,i*2+1), safe)
		if(isnull(c))
			return null
		r += ascii2text(c)
	return r


/**
 *! This is a weird one:
 * It returns a list of all var names found in the string
 * These vars must be in the [var_name] format
 * It's only a proc because it's used in more than one place.
 *
 * Takes a string and a datum
 * The string is well, obviously the string being checked
 * The datum is used as a source for var names, to check validity
 * Otherwise every single word could technically be a variable!
 */
/proc/string2listofvars(t_string, datum/var_source)
	if(!t_string || !var_source)
		return list()

	. = list()

	var/var_found = findtext(t_string,"\[") //Not the actual variables, just a generic "should we even bother" check
	if(var_found)
		//Find var names

		// "A dog said hi [name]!"
		// splittext() --> list("A dog said hi ","name]!"
		// jointext() --> "A dog said hi name]!"
		// splittext() --> list("A","dog","said","hi","name]!")

		t_string = replacetext(t_string,"\[","\[ ")//Necessary to resolve "word[var_name]" scenarios
		var/list/list_value = splittext(t_string,"\[")
		var/intermediate_stage = jointext(list_value, null)

		list_value = splittext(intermediate_stage," ")
		for(var/value in list_value)
			if(findtext(value,"]"))
				value = splittext(value,"]") //"name]!" --> list("name","!")
				for(var/A in value)
					if(var_source.vars.Find(A))
						. += A

/proc/get_end_section_of_type(type)
	var/strtype = "[type]"
	var/delim_pos = findlasttext(strtype, "/")
	if(delim_pos == 0)
		return strtype
	return copytext(strtype, delim_pos)


/**
 * list2text - takes delimiter and returns text
 *
 * Concatenates a list of strings into a single string.  A seperator may optionally be provided.
 */
/proc/list2text(list/ls, sep)
	if (ls.len <= 1) // Early-out code for empty or singleton lists.
		return ls.len ? ls[1] : ""

	var/l = ls.len // Made local for sanic speed.
	var/i = 0      // Incremented every time a list index is accessed.

	if (sep <> null)
		// Macros expand to long argument lists like so: sep, ls[++i], sep, ls[++i], sep, ls[++i], etc...
		#define S1  sep, ls[++i]
		#define S4  S1,  S1,  S1,  S1
		#define S16 S4,  S4,  S4,  S4
		#define S64 S16, S16, S16, S16

		. = "[ls[++i]]" // Make sure the initial element is converted to text.

		// Having the small concatenations come before the large ones boosted speed by an average of at least 5%.
		if (l-1 & 0x01) // 'i' will always be 1 here.
			. = text("[][][]", ., S1) // Append 1 element if the remaining elements are not a multiple of 2.
		if (l-i & 0x02)
			. = text("[][][][][]", ., S1, S1) // Append 2 elements if the remaining elements are not a multiple of 4.
		if (l-i & 0x04)
			. = text("[][][][][][][][][]", ., S4) // And so on....
		if (l-i & 0x08)
			. = text("[][][][][][][][][][][][][][][][][]", ., S4, S4)
		if (l-i & 0x10)
			. = text("[][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]", ., S16)
		if (l-i & 0x20)
			. = text("[][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]\
			          [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]", ., S16, S16)
		if (l-i & 0x40)
			. = text("[][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]\
			          [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]\
			          [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]\
			          [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]", ., S64)
		while (l > i) // Chomp through the rest of the list, 128 elements at a time.
			. = text("[][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]\
			          [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]\
			          [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]\
			          [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]\
			          [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]\
			          [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]\
			          [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]\
			          [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]", ., S64, S64)

		#undef S64
		#undef S16
		#undef S4
		#undef S1
	else
		// Macros expand to long argument lists like so: ls[++i], ls[++i], ls[++i], etc...
		#define S1  ls[++i]
		#define S4  S1,  S1,  S1,  S1
		#define S16 S4,  S4,  S4,  S4
		#define S64 S16, S16, S16, S16

		. = "[ls[++i]]" // Make sure the initial element is converted to text.

		if (l-1 & 0x01) // 'i' will always be 1 here.
			. += S1 // Append 1 element if the remaining elements are not a multiple of 2.
		if (l-i & 0x02)
			. = text("[][][]", ., S1, S1) // Append 2 elements if the remaining elements are not a multiple of 4.
		if (l-i & 0x04)
			. = text("[][][][][]", ., S4) // And so on...
		if (l-i & 0x08)
			. = text("[][][][][][][][][]", ., S4, S4)
		if (l-i & 0x10)
			. = text("[][][][][][][][][][][][][][][][][]", ., S16)
		if (l-i & 0x20)
			. = text("[][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]", ., S16, S16)
		if (l-i & 0x40)
			. = text("[][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]\
			          [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]", ., S64)
		while (l > i) // Chomp through the rest of the list, 128 elements at a time.
			. = text("[][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]\
			          [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]\
			          [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]\
			          [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]", ., S64, S64)

		#undef S64
		#undef S16
		#undef S4
		#undef S1

/**
 * text2list - takes delimiter, and creates list
 *
 * Converts a string into a list by splitting the string at each delimiter found. (discarding the seperator)
 */

/proc/text2list(text, delimiter="\n")
	var/delim_len = length(delimiter)
	if (delim_len < 1)
		return list(text)

	. = list()
	var/last_found = 1
	var/found

	do
		found       = findtext(text, delimiter, last_found, 0)
		.          += copytext(text, last_found, found)
		last_found  = found + delim_len
	while (found)
