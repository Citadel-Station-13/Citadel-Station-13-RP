//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

// TODO: finish this file

/obj/machinery/mortar
	name = "mortar"
	desc = "A mortar of some kind. What kind of insanity drove you to possess one?"
	// TODO: sprite

	use_power = USE_POWER_OFF
	active_power_usage = 0
	idle_power_usage = 0

	/// caliber to use
	/// * can be a string id, a typepath, or an instance
	var/caliber

	/// collapses into kit type
	var/collapsible_kit_type = /obj/item/mortar_kit
	/// can collapse
	var/collapsible = TRUE

	/// in degrees std-dev
	var/standard_azimuth_error = 1
	/// in degrees, to add or subtract, going clockwise
	var/standard_azimuth_error_static = 0
	/// in degrees std-dev
	var/standard_elevation_error = 1
	/// in degrees, to add or subtract, going upwards towards the zenith
	var/standard_elevation_error_static = 0

	/// apply standard error?
	var/use_standard_error = TRUE

	#warn time to dest, inaccuracy

/obj/machinery/mortar/proc/fire_round()

/obj/machinery/mortar/proc/launch_round()

/obj/machinery/mortar/proc/collapse(atom/new_loc) as /obj/item/mortar_kit

/obj/machinery/mortar/proc/expand(obj/item/mortar_kit/from_kit)

/obj/machinery/mortar/proc/calculate_standard_error(turf/real_Target)
	#warn impl

#warn impl

/**
 * "but why is this not the base type"
 * * because auto-mortars should be a thing, not every mortar
 *   is an irl single-load military mortar.
 */
/obj/machinery/mortar/basic
	collapsible_kit_type = /obj/item/mortar_kit/basic

	/// time to load a shell which is then fired
	var/time_to_load = 3.85 SECONDS
	/// fire delay after shell loads
	var/time_to_fire = 1 SECONDS



/obj/machinery/mortar/basic/proc/using_item_on(obj/item/using, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()




/obj/machinery/mortar/basic/standard
	caliber = /datum/ammo_caliber/mortar
