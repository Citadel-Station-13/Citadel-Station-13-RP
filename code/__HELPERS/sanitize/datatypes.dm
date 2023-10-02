/**
 * returns value if text, otherwise default
 */
/proc/sanitize_istext(value, default = "")
	return istext(value)? value : default

/**
 * returns value if num, otherwise default
 */
/proc/sanitize_isnum(value, default = 0)
	return isnum(value)? value : default

/**
 * returns value if list, otherwise default
 */
/proc/sanitize_islist(value, default = list())
	return islist(value)? value : default
