//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/obj/machinery/teleporter/bluespace_capacitor
	name = "bluespace projection capacitor"
	desc = "A powerful capacitor used to power a bluespace field projector."
	#warn sprite

	/// kilojoules of energy stored
	var/stored = 0
	/// kilojoules of energy we can store
	var/capacity = 25000
	/// charge rate in kw
	var/draw_rate = 0
	/// max charge rate in kw
	var/draw_max = 1000

	/// linked projector
	var/obj/machinery/teleporter/bluespace_projector/projector

/obj/machinery/teleporter/bluespace_capacitor/update_icon_state()
	#warn projector status
	return ..()

/obj/machinery/teleporter/bluespace_capacitor/proc/charge(kj)
	. = min(capacity - stored, kj)
	stored += .

/obj/machinery/teleporter/bluespace_capacitor/proc/use(kj)
	. = min(stored, kj)
	stored -= .

/obj/machinery/teleporter/bluespace_capacitor/process(delta_time)
	if(!draw_rate)
		return
	if(stored >= capacity)
		return
	var/needed = min(capacity - stored, draw_rate)
	var/got = shitcode_consume_kw_immediate(needed)
	charge(got)

/obj/machinery/teleporter/bluespace_capacitor/proc/set_draw_rate(rate)
	draw_rate = clamp(rate, 0, draw_max)

/obj/machinery/teleporter/bluespace_capacitor/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	.["stored"] = stored
	.["drawRate"] = draw_rate
	.["linkedProjector"] = !isnull(projector)

/obj/machinery/teleporter/bluespace_capacitor/ui_static_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	.["capacity"] = capacity
	.["drawMax"] = draw_max

/obj/machinery/teleporter/bluespace_capacitor/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TelesciCapacitor")
		ui.open()

//! WARNING WARNING LEGACY SHITCODE
//! REFACTORING ON POWERNET REFACTOR.

/// amt is in kw, obviously.
/obj/machinery/teleporter/bluespace_capacitor/proc/shitcode_consume_kw_immediate(amt)
	for(var/obj/structure/cable/cable in loc)
		if(cable.d1)
			continue
		// cable is a node
		if(isnull(cable.powernet))
			continue
		// cable has a powernet
		return cable.powernet.draw_power(amt)
	return 0
