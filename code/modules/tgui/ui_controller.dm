//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * A UI controller that hooks to a datum.
 */
/datum/ui_controller
	var/expected_type = /datum

#warn impl

/**
 * Called when a /datum's `notify_uis()` is called.
 *
 * @params
 * * entity - The /datum. This may be type-casted to our expected type.
 * * key - A string key.
 * * ... - A variable number of arguments that the datum passes into the signal.
 */
/datum/ui_controller/proc/on_notify(datum/entity, key, ...)
	return
