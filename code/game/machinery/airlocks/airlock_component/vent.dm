//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

// todo: buildable

/obj/machinery/airlock_component/vent
	name = "airlock vent"
	desc = "A large vent used in an airlock to dispel unwanted waste gases and use as a heat source/sink."

	#warn sprite

	/// are we allowed to vent gas?
	var/allow_gas_venting = TRUE
	/// are we allowed to siphon gas?
	var/allow_gas_siphon = TRUE
	/// are we allowed to vent heat?
	var/allow_heat_venting = TRUE
	/// are we allowed to siphon heat?
	var/allow_heat_siphon = TRUE

#warn impl

/obj/machinery/airlock_component/vent/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return

	#warn impl

/obj/machinery/airlock_component/vent/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()

/obj/machinery/airlock_component/vent/ui_data(mob/user, datum/tgui/ui)
	. = ..()
	.["gasVent"] = allow_gas_venting
	.["gasSiphon"] = allow_gas_siphon
	.["heatVent"] = allow_heat_venting
	.["heatSiphon"] = allow_heat_siphon

/obj/machinery/airlock_component/vent/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AirlockVent")
		ui.set_autoupdate(FALSE)
		ui.open()

/obj/machinery/airlock_component/vent/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	switch(action)
		if("toggleGasVent")
		if("toggleGasSiphon")
		if("toggleHeatVent")
		if("toggleHeatSiphon")

#warn requires panel open
