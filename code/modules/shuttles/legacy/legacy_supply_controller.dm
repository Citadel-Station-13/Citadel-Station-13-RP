GLOBAL_DATUM(legacy_cargo_shuttle_controller, /datum/shuttle_controller/ferry/cargo)

/datum/shuttle_controller/ferry/cargo
	transit_time_home = 2 MINUTES
	transit_time_away = 2 MINUTES

/datum/shuttle_controller/ferry/cargo/on_transit_begin(obj/shuttle_dock/dock, redirected)
	. = ..()
	// Set the supply shuttle displays to read out the ETA
	var/datum/signal/S = new()
	S.source = src
	S.data = list("command" = "supply")
	var/datum/radio_frequency/F = radio_controller.return_frequency(1435)
	F.post_signal(src, S)

/datum/shuttle_controller/ferry/cargo/on_begin_transit_to_away()
	. = ..()
	SSsupply.buy()

/datum/shuttle_controller/ferry/cargo/on_successful_transit_to_home()
	. = ..()
	SSsupply.sell()

/proc/legacy_supply_forbidden_atoms_check(datum/shuttle/shuttle)
	var/datum/shuttle_controller/ferry/controller = shuttle.controller
	// allow it if they're not on station; remember station is away.
	if(istype(controller) && !controller.is_at_away())
		return FALSE
	for(var/area/area in shuttle.areas)
		if(SSsupply.forbidden_atoms_check(area))
			return TRUE
	return FALSE
