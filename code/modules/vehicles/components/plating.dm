//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/armor/vehicle_plating

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
 * * Any blocked damage should be directed to ourselves. The vehicle-side defense code will handle that.
 */
/obj/item/vehicle_component/plating/proc/compute_resultant_inbound_vehicle_damage_instance(SHIELDCALL_PROC_HEADER)

/obj/item/vehicle_component/plating/proc/



/obj/item/vehicle_component/plating/proc/


/obj/item/vehicle_component/plating/proc/


#warn impl
