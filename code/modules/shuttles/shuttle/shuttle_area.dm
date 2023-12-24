//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * shuttle areas
 */
/area/shuttle
	unique = FALSE

#warn impl all

/**
 * autodetecting area
 */
/area/shuttle/auto
	/// [name] [count?] [descriptor?]
	var/count
	/// [name] [count?] [descriptor?]
	var/descriptor = "Compartment"

/area/shuttle/auto/proc/auto_name_instance(shuttle_name)
	name = "[shuttle_name][count && " [count]"][descriptor && " [descriptor]"]"

/area/shuttle/auto/primary
	count = "Primary"

/area/shuttle/auto/secondary
	count = "Secondary"

/area/shuttle/auto/tertiary
	count = "Tertiary"

/area/shuttle/auto/one_single_area
	count = ""
	descriptor = ""
