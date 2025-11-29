//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/armor/vehicle_plating

/datum/armor/vehicle_plating_redirection

/**
 * Base type of vehicle plating.
 * * Damage is soaked on `redirection` armor and directed to us, and ran against our armor.
 * * Any remaining damage will penetrate, whatever that means for the attack.
 */
/obj/item/vehicle_component/plating
	armor_type = /datum/armor/vehicle_plating
	/// redirection armor
	var/datum/armor/redirection_armor
	/// redirection armor type
	var/redirection_armor_type
	/// active effective thickness multiplier; determines our effective integrity
	var/effective_relative_thickness = 1

/obj/item/vehicle_component/plating/proc/reset_redirection_armor()
	set_redirection_armor(initial(armor_type))

/obj/item/vehicle_component/plating/proc/set_redirection_armor(what)
	armor = fetch_armor_struct(what)

/obj/item/vehicle_component/plating/proc/fetch_redirection_armor()
	RETURN_TYPE(/datum/armor)
	return armor || (armor = generate_redirection_armor())

/obj/item/vehicle_component/plating/proc/generate_redirection_armor()
	return fetch_armor_struct(armor_type)

/**
 * Returns part of damage instance that should be continued, if any
 *
 * * Any blocked damage should be directed to ourselves. The vehicle-side defense code will handle that.
 * * This will modify the passed in list.
 */
/obj/item/vehicle_component/plating/proc/run_inbound_vehicle_damage_instance(list/shieldcall_args, fake_attack)
	// check how damaged we are; after integrity failure there's escalating chance we start letting
	// stuff through wholesale

	if(integrity < integrity_failure)
		// simple linear interpolation once at integrity failure
		var/pass_percent = (1 - (integrity / integrity_failure)) * 100
		if(prob(pass_percent))
			return

	var/datum/armor/redirection = fetch_redirection_armor()
	var/reduced_damage = redirection?.resultant_damage(
		shieldcall_args[SHIELDCALL_ARG_DAMAGE],
		shieldcall_args[SHIELDCALL_ARG_DAMAGE_TIER],
		shieldcall_args[SHIELDCALL_ARG_DAMAGE_FLAG],
		shieldcall_args[SHIELDCALL_ARG_DAMAGE_MODE] & DAMAGE_MODE_REQUEST_ARMOR_RANDOMIZATION,
	)
	if(shieldcall_args[SHIELDCALL_ARG_DAMAGE_MODE] & DAMAGE_MODE_REQUEST_ARMOR_BLUNTING)
		// if requested, blunt tier as needed

	#warn impl
