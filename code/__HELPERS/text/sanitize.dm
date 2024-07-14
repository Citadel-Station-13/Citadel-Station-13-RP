//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * get rid of non alphanumeric chars in a string
 */
/proc/string_filter_to_alphanumeric(str)
	// todo: rustg
	var/static/regex/expression = regex(@"[^a-zA-Z0-9_ ]+", "g")
	return replacetext_char(str, expression, "")
