//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * called to get list of variables
 *
 * @params
 * * actor - actor
 * * raw_query - query requested was raw, do not inject helper / wrapper vars
 *
 * @return list, or null to forbid
 */
/datum/proc/vv_var_query(datum/vv_context/actor)
	return vars


/**
 * called to handle a var edit
 *
 * @params
 * * actor - actor
 * * var_name - variable name
 * * var_value - variable value
 * * mass_edit - mass edit op? this is set to iteration, so you can check == 1 if needed
 * * raw_edit - edit requested was raw, do not do automatic handling
 */
/datum/proc/vv_edit_var(datum/vv_context/actor, var_name, var_value, mass_edit, raw_edit)
	#warn overrides
	return VV_EDIT_NORMAL

/**
 * called to read a variable
 *
 * @params
 * * actor - actor
 * * var_name - variable name
 * * raw_read - read requested was raw, do not do automatic handling
 *
 * @return variable value
 */
/datum/proc/vv_get_var(datum/vv_context/actor, var_name, raw_read)
	#warn overrides
	#warn redo?
	return vars[var_name]

/**
 * checks if we can be marked as a datum; this means someone is trying to grab a reference to us
 *
 * @params
 * * actor - actor
 */
/datum/proc/can_vv_mark(datum/vv_context/actor)
	#warn overrides
	return TRUE

/**
 * checks if we can make a bind-mark to a variable name on us
 *
 * bound marks follows the variable, and not the thing marked
 *
 * @params
 * * actor - actor
 * * var_name - variable name
 */
/datum/proc/can_vv_bind(datum/vv_context/actor, var_name)
	return TRUE

/**
 * can call a proc of a given name
 *
 * @params
 * * actor - actor
 * * proc_name - proc name
 * * raw_call - call requested was raw, do ont do automatic handling
 */
/datum/proc/can_vv_call(datum/vv_context/actor, proc_name, raw_call)
	return TRUE

/**
 * can call a proc of a given name with the given params
 *
 * @params
 * * actor - actor
 * * proc_name - proc name
 * * proc_args - proc args, you can edit or parse this list at your own peril
 * * raw_call - call requested was raw, do not do automatic handling
 */
/datum/proc/vv_call_proc(datum/vv_context/actor, proc_name, list/proc_args, raw_call)
	return can_vv_call(actor, proc_name, raw_call)? VV_CALL_NORMAL : VV_CALL_REJECT

/**
 * allow vv deletes?
 *
 * @params
 * * actor - actor
 */
/datum/proc/can_vv_delete(datum/vv_context/actor)
	return TRUE

/**
 * return a list of dropdown options
 *
 * this does not include the base dropdowns for callproc, delete, etc
 *
 * @params
 * * actor - actor
 *
 * @return list(key = name)
 */
/datum/proc/vv_dropdown(datum/vv_context/actor)
	return list()
