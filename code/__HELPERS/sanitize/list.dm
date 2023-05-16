/**
 * returns value if it is in list, or default, or random from list
 * default is treated as nonexistant if it is null!
 */
/proc/sanitize_inlist(value, list/L, default)
	if(value in L)
		return value
	return isnull(default)? SAFEPICK(L) : default
