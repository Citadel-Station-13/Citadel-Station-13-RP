//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * Given a specific variable name and value, intuit what datatype it should be
 *
 * @params
 * * key - variable name, or index if source is list
 * * value - variable value
 * * source - (optional) datum / list that we're currently scanning variables of
 */
/proc/vv_detect_datatype(key, value, source)
	#warn impl

/**
 * Request an arbitrary value.
 *
 * @params
 * * user - who to ask
 * * datatypes - (optional) list of allowed datatypes, or a single datatype. defaults to all datatype. if it's a single datatype, this datatype is forced.
 * * default_datatype - (optional) default datatype to use
 * * var_name - variable name
 * * add_datatypes - (optional) forcefully add these datatypes to datatypes list.
 * * remove_datatypes - (optional) forcefully remove these datatypes from datatypes list. overrides add_datatypes.
 */
/proc/vv_request_datatype(client/user, list/datatypes, default_datatype, var_name, list/add_datatypes, list/remove_datatypes)
	var/list/retval = list(
		"type" = null,
		"value" = null,
	)
	#warn impl
	return retval
