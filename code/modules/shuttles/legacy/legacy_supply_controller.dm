GLOBAL_DATUM(legacy_cargo_shuttle_controller, /datum/shuttle_controller/ferry/cargo)

/datum/shuttle_controller/ferry/cargo

/datum/shuttle_controller/ferry/cargo/on_transit_to_away()
	. = ..()

/datum/shuttle_controller/ferry/cargo/on_transit_to_home()
	. = ..()

#warn impl

/proc/legacy_supply_forbidden_atoms_check(datum/shuttle/shuttle)
	var/datum/shuttle_controller/ferry/controller = shuttle.controller
	// allow it if they're not on station; remember station is away.
	if(istype(controller) && !controller.is_at_away())
		return FALSE
	for(var/area/area in shuttle.areas)
		if(SSsupply.forbidden_atoms_check(area))
			return TRUE
	return FALSE
