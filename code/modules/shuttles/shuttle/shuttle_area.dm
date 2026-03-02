//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * shuttle areas
 */
/area/shuttle
	icon_state = "shuttle"
	unique = FALSE
	special = TRUE
	requires_power = TRUE
	area_flags = AREA_RAD_SHIELDED | AREA_FLAG_ERODING
	sound_env = SMALL_ENCLOSED
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	/// will be assigned the shuttle's ref post-init
	var/datum/shuttle/shuttle

/area/shuttle/proc/before_bounds_initializing(datum/shuttle/from_shuttle, datum/map_reservation/from_reservation, datum/shuttle_template/from_template)
	shuttle = from_shuttle

/**
 * autodetecting area
 */
/area/shuttle/auto
	/// [name] [count?] [descriptor?]
	var/count
	/// [name] [count?] [descriptor?]
	var/descriptor = "Compartment"

/area/shuttle/auto/before_bounds_initializing(datum/shuttle/from_shuttle, datum/map_reservation/from_reservation, datum/shuttle_template/from_template)
	. = ..()
	auto_name_instance(shuttle.name, shuttle.display_name)

/area/shuttle/auto/proc/auto_name_instance(real_name, display_name)
	src.name = "[real_name][count && " [count]"][descriptor && " [descriptor]"]"
	src.display_name = display_name

/area/shuttle/auto/primary
	count = "Primary"

/area/shuttle/auto/secondary
	count = "Secondary"

/area/shuttle/auto/tertiary
	count = "Tertiary"

/area/shuttle/auto/one_single_area
	count = ""
	descriptor = ""

/area/shuttle/auto/named/cockpit
	descriptor = "Cockpit"

/area/shuttle/auto/named/cargo
	descriptor = "Cargo Bay"

/area/shuttle/auto/named/engine
	descriptor = "Engine"

/area/shuttle/auto/named/deck
	descriptor = "Deck"

/area/shuttle/auto/named/airlock
	descriptor = "Airlock"

/area/shuttle/auto/named/airlock/primary
	count = "Primary"

/area/shuttle/auto/named/airlock/secondary
	count = "Secondary"

/area/shuttle/auto/named/airlock/tertiary
	count = "Tertiary"
