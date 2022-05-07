/proc/safe_json_encode(list/L, default = "")
	. = default
	return json_encode(L)

/proc/safe_json_decode(string, default = list())
	. = default
	return json_decode(string)
