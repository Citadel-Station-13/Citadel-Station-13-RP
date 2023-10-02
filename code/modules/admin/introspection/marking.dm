//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * essentially a softcode pointer
 *
 * these intentionally do not use weakrefs right now, and *will* block garbage collection!
 */
/datum/vv_mark
	/// type - used for UI
	var/type_enum

/**
 * get the bound object
 */
/datum/vv_mark/proc/resolve()
	CRASH("?")

/datum/vv_mark/direct
	/// target datum
	var/datum/target

/datum/vv_mark/direct/resolve()
	return target

/datum/vv_mark/binding
	/// target datum
	var/datum/target
	/// target var name
	var/var_name

/datum/vv_mark/binding/resolve()
	return target?.vars[var_name]

/**
 * mark a datum
 */
/datum/vv_context/proc/mark_datum(datum/D)

/**
 * perform a binding mark on a datum
 */
/datum/vv_context/proc/bind_datum(datum/D, var_name)

#warn impl all
