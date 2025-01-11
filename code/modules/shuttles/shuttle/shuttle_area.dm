//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * shuttle areas
 */
/area/shuttle
	unique = FALSE
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
	// todo: shuttle

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
