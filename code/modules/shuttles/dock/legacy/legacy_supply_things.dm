//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/proc/legacy_supply_forbidden_atoms_check(datum/shuttle/shuttle)
	var/datum/shuttle_controller/ferry/controller = shuttle.controller
	// allow it if they're not on station; remember station is away.
	if(istype(controller) && !controller.is_at_away())
		return FALSE
	for(var/area/area in shuttle.areas)
		if(SSsupply.forbidden_atoms_check(area))
			return TRUE
	return FALSE
