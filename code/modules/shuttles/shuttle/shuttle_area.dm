//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * shuttle areas
 */
/area/shuttle
	icon = 'icons/areas/shuttle.dmi'
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
	area_icon_smoothing_restrict = AREA_ICON_SMOOTHING_RESTRICT_SHUTTLE(from_shuttle.id)

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
	auto_name_instance(shuttle.name, shuttle.descriptor.display_name)

/area/shuttle/auto/proc/auto_name_instance(real_name, display_name)
	src.name = "[real_name][count && " [count]"][descriptor && " [descriptor]"]"
	src.display_name = "[display_name || real_name][count && " [count]"][descriptor && " [descriptor]"]"

/area/shuttle/auto/primary
	icon_state = "primary"
	count = "Primary"

/area/shuttle/auto/secondary
	icon_state = "secondary"
	count = "Secondary"

/area/shuttle/auto/tertiary
	icon_state = "tertiary"
	count = "Tertiary"

/area/shuttle/auto/one_single_area
	icon_state = "unified"
	count = ""
	descriptor = ""

/area/shuttle/auto/named/cockpit
	icon_state = "cockpit"
	descriptor = "Cockpit"

/area/shuttle/auto/named/ready_room
	icon_state = "ready_room"
	descriptor = "Ready Room"

/area/shuttle/auto/named/cargo
	icon_state = "cargo"
	descriptor = "Cargo Bay"

/area/shuttle/auto/named/engine
	icon_state = "engine"
	descriptor = "Engine"

/area/shuttle/auto/named/medbay
	icon_state = "medbay"
	descriptor = "Medbay"

/area/shuttle/auto/named/deck
	icon_state = "deck"
	descriptor = "Deck"

/area/shuttle/auto/named/airlock
	icon_state = "airlock"
	descriptor = "Airlock"

/area/shuttle/auto/named/airlock/primary
	icon_state = "airlock_primary"
	count = "Primary"

/area/shuttle/auto/named/airlock/secondary
	icon_state = "airlock_secondary"
	count = "Secondary"

/area/shuttle/auto/named/airlock/tertiary
	icon_state = "airlock_tertiary"
	count = "Tertiary"
