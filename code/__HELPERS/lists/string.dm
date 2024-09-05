/**
 * Returns a list in plain english as a string.
 *
 * @params
 * * input - the list to interpolate into strings
 * * nothing_text - the text to emit if the list is empty
 * * and_text - the text to emit on the last element instead of a comma
 * * comma_text - the glue between elements
 * * final_comma_text - the glue between the last two elements; usually empty for use with 'and_text'
 * * limit - limit the entries processed. if the limit was reached, the last two elements will not use the usual glue text.
 * * limit_text - text to append at the end if we were limited. defaults to "..."
 */
/proc/english_list(list/input, nothing_text = "nothing", and_text = " and ", comma_text = ", ", final_comma_text = "", limit, limit_text = "...")
	var/total = length(input)
	var/limited = FALSE
	if(!isnull(limit))
		if(total > limit)
			total = limit
			limited = TRUE
	if (!total)
		return "[nothing_text]"
	else if (total == 1)
		return "[input[1]]"
	else if (total == 2)
		return "[input[1]][and_text][input[2]]"
	else
		var/output = ""
		var/index = 1
		while (index < total)
			if ((index == (total - 1)) && !limited)
				comma_text = final_comma_text

			output += "[input[index]][comma_text]"
			index++

		return "[output][limited ? "" : and_text][input[index]][limited? limit_text : ""]"

/**
 * Removes a string from a list.
 */
/proc/remove_strings_from_list(string, list/L)
	if(!LAZYLEN(L) || !string)
		return
	while(string in L)
		L -= string
	return L
