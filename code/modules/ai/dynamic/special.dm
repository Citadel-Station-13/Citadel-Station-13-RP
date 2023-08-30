//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/ai_holder/dynamic
	/// how frequently special combat routines should be called; null for disabled
	var/special_combat_interval
	/// how frequently special noncombat routines should be called; null for disabled
	var/special_noncombat_interval

/**
 * called as special during combat
 */
/datum/ai_holder/dynamic/proc/handle_special_combat()

/**
 * called as special during noncombat
 */
/datum/ai_holder/dynamic/proc/handle_special_noncombat()

#warn impl all
