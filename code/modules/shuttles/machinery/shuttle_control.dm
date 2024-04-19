//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/obj/machinery/computer/shuttle_control
	name = "shuttle controller"
	desc = "A control interface for a shuttle."
	#warn icon

	/// bound shuttle ID; null to autoinit on our shuttle
	///
	/// for game design purposes of not having magic remote-control
	/// consoles, it's a good idea in general to make us indestructible
	/// if this is hard-set.
	var/shuttle_id
	/// are we a hardcoded console?
	var/hardcoded = FALSE
	/// our current shuttle instance
	var/datum/shuttle/shuttle

/obj/machinery/computer/shuttle_control/Initialize(mapload)
	. = ..()
	if(isnull(shuttle_id))
		#warn autodetect
	else
		hardcoded = TRUE
	#warn link

/obj/machinery/computer/shuttle_control/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change)
	. = ..()
	if(hardcoded)
		return
	var/area/shuttle/shuttle_area = loc?.loc
	if(shuttle_area?.shuttle?.id != shuttle_id)
		shuttle_id = shuttle_area?.shuttle?.id
		shuttle = shuttle_area?.shuttle
	if(!shuttle)
		SStgui.close_uis(src)

/obj/machinery/computer/shuttle_control/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	switch(action)

/obj/machinery/computer/shuttle_control/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ShuttleConsole")
		ui.register_module(shuttle.controller, "shuttle")
		ui.open()

/obj/machinery/computer/shuttle_control/ui_data(mob/user, datum/tgui/ui)
	. = ..()

/obj/machinery/computer/shuttle_control/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()


#warn impl all

#warn OVERMAPS BELOW

//Shuttle controller computer for shuttles going between sectors
/obj/machinery/computer/shuttle_control
	name = "general shuttle control console"
	circuit = /obj/item/circuitboard/shuttle_console/explore
	tgui_subtemplate = "ShuttleControlConsoleExploration"

/obj/machinery/computer/shuttle_control/shuttlerich_ui_data(var/datum/shuttle/autodock/overmap/shuttle)
	. = ..()
	if(istype(shuttle))
		var/total_gas = 0
		for(var/obj/structure/fuel_port/FP in shuttle.fuel_ports) //loop through fuel ports
			var/obj/item/tank/fuel_tank = locate() in FP
			if(fuel_tank)
				total_gas += fuel_tank.air_contents.total_moles

		var/fuel_span = "good"
		if(total_gas < shuttle.fuel_consumpt//Shuttle controller computer for shuttles going between sectors
/obj/machinery/computer/shuttle_control
	name = "general shuttle control console"
	circuit = /obj/item/circuitboard/shuttle_console/explore
	tgui_subtemplate = "ShuttleControlConsoleExploration"

/obj/machinery/computer/shuttle_control/shuttlerich_ui_data(var/datum/shuttle/autodock/overmap/shuttle)
	. = ..()
	if(istype(shuttle))
		var/total_gas = 0
		for(var/obj/structure/fuel_port/FP in shuttle.fuel_ports) //loop through fuel ports
			var/obj/item/tank/fuel_tank = locate() in FP
			if(fuel_tank)
				total_gas += fuel_tank.air_contents.total_moles

		var/fuel_span = "good"
		if(total_gas < shuttle.fuel_consumption * 2)
			fuel_span = "bad"

		. += list(
			"destination_name" = shuttle.get_destination_name(),
			"can_pick" = shuttle.moving_status == SHUTTLE_IDLE,
			"fuel_usage" = shuttle.fuel_consumption * 100,
			"remaining_fuel" = round(total_gas, 0.01) * 100,
			"fuel_span" = fuel_span
		)

/obj/machinery/computer/shuttle_control/ui_act(action, list/params, datum/tgui/ui)
	if(..())
		return TRUE

	var/datum/shuttle/autodock/overmap/shuttle = SSshuttle.shuttles[shuttle_tag]
	if(!istype(shuttle))
		to_chat(usr, "<span class='warning'>Unable to establish link with the shuttle.</span>")
		return TRUE

	switch(action)
		if("pick")
			var/list/possible_d = shuttle.get_possible_destinations()
			var/D
			if(possible_d.len)
				D = input("Choose shuttle destination", "Shuttle Destination") as null|anything in possible_d
			else
				to_chat(usr,"<span class='warning'>No valid landing sites in range.</span>")
			possible_d = shuttle.get_possible_destinations()
			if(CanInteract(usr, GLOB.default_state) && (D in possible_d))
				shuttle.set_destination(possible_d[D])
			return TRUE
ion * 2)
			fuel_span = "bad"

		. += list(
			"destination_name" = shuttle.get_destination_name(),
			"can_pick" = shuttle.moving_status == SHUTTLE_IDLE,
			"fuel_usage" = shuttle.fuel_consumption * 100,
			"remaining_fuel" = round(total_gas, 0.01) * 100,
			"fuel_span" = fuel_span
		)

/obj/machinery/computer/shuttle_control/ui_act(action, list/params, datum/tgui/ui)
	if(..())
		return TRUE

	var/datum/shuttle/autodock/overmap/shuttle = SSshuttle.shuttles[shuttle_tag]
	if(!istype(shuttle))
		to_chat(usr, "<span class='warning'>Unable to establish link with the shuttle.</span>")
		return TRUE

	switch(action)
		if("pick")
			var/list/possible_d = shuttle.get_possible_destinations()
			var/D
			if(possible_d.len)
				D = input("Choose shuttle destination", "Shuttle Destination") as null|anything in possible_d
			else
				to_chat(usr,"<span class='warning'>No valid landing sites in range.</span>")
			possible_d = shuttle.get_possible_destinations()
			if(CanInteract(usr, GLOB.default_state) && (D in possible_d))
				shuttle.set_destination(possible_d[D])
			return TRUE

#warn above

/**
 * hardcoded shuttle control consoles
 * these should not be deconstructible as we don't want
 * players to get ahold of remote-control shuttle consoles without wanting them
 * to do so.
 */
/obj/machinery/computer/shuttle_control/hardcoded
	integrity_flags = INTEGRITY_INDESTRUCTIBLE
