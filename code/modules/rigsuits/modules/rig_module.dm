//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * modules are modular items that can be inserted into specific slots on the rig.
 */
/obj/item/rig_module
	#warn impl all

	//* Core
	/// lookup id
	var/lookup_id
	/// lookup prefix - set this please
	var/lookup_prefix = "unkw"

	//* Balancing
	/// slots this takes up
	///
	/// slots is the metric used to balance complexity / variety of functions
	/// more niche & powerful/varied gear takes up more slots
	var/module_slots = 0
	/// size this takes up
	///
	/// size is the metric used to balance offense/defense/storage
	/// you generally can have two of the three, not all of the above
	var/module_size = 0
	/// weight to add to rigsuit
	///
	/// stuff like heavy armor tends to be heavier.
	var/module_weight = 0

	//* UI
	//! todo: this is fucking evil
	/// cached b64 string of our UI icon
	var/cached_tgui_icon_b64
	/// is our UI update queued?
	var/ui_update_queued = FALSE

	//* Zone
	#warn ughh

/**
 * @return list(command = desc, ...)
 */
/obj/item/rig_module/proc/console_query(mob/user)
	return list()

/**
 * @return list(output, admin log text)
 */
/obj/item/rig_module/proc/console_process(mob/user, effective_control_flags, username, command, list/arguments)
	return list("unknown command", "<invalid>")
