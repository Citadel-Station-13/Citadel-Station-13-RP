/obj/machinery/atmospherics/component/trinary/filter
	name = "gas filter"
	icon = 'icons/atmos/filter.dmi'
	icon_state = "map"
	density = FALSE
	construction_type = /obj/item/pipe/trinary/flippable
	pipe_state = "filter"
	level = 1

	use_power = USE_POWER_IDLE
	idle_power_usage = 150
	power_rating = 7500

	/// target gas id, or groups
	var/filtering
	// todo: put flow rate at component level
	/// flow rate in L
	var/flow_setting = ATMOS_DEFAULT_VOLUME_FILTER
	/// current flow rate in L
	var/flow_current = 0

#warn groups

/obj/machinery/atmospherics/component/trinary/filter/Initialize(mapload)
	. = ..()
	air1.volume = ATMOS_DEFAULT_VOLUME_FILTER
	air2.volume = ATMOS_DEFAULT_VOLUME_FILTER
	air3.volume = ATMOS_DEFAULT_VOLUME_FILTER

/obj/machinery/atmospherics/component/trinary/filter/update_icon_state()
	if(mirrored)
		icon_state = "m"
	else
		icon_state = ""
	if(!powered())
		icon_state += "off"
	else if(node2 && node3 && node1)
		icon_state += on ? "on" : "off"
	else
		icon_state += "off"
	return ..()

/obj/machinery/atmospherics/component/trinary/filter/process(delta_time)
	..()

	if(!on || inoperable())
		return

	var/old_mols = air1.total_moles
	var/transfer_mols = (flow_setting / air1.volume) * old_mols

	if(transfer_mols > MINIMUM_MOLES_TO_FILTER)
		power_usage = xgm_filter_gas(air1, air3, air2, filtering, transfer_mols, power_setting)
		flow_current = (1 - air1.total_moles / old_mols) * air1.volume

		// todo: better API for this
		network1?.update = TRUE
		network2?.update = TRUE
		network3?.update = TRUE

	if(power_usage)
		use_power(power_usage)

/obj/machinery/atmospherics/component/trinary/filter/attack_hand(mob/user, list/params)
	if(..())
		return
	if(!src.allowed(user))
		to_chat(user, SPAN_WARNING("Access denied."))
		return
	ui_interact(user)

#warn above

/obj/machinery/atmospherics/component/trinary/filter/proc/

/obj/machinery/atmospherics/component/trinary/filter/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AtmosFilter", name)
		ui.open()

/obj/machinery/atmospherics/component/trinary/filter/ui_data(mob/user)
	. = ..()
	.["filtering"] = filtering
	.["maxRate"] = air1.volume
	.["rate"] = flow_setting

/obj/machinery/atmospherics/component/trinary/filter/ui_static_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	.["atmosContext"] = global.gas_data.tgui_gas_context()

/obj/machinery/atmospherics/component/trinary/filter/ui_act(action, params)
	. = ..()
	if(.)
		return
	switch(action)
		if("filter")
			var/target =
			#warn impl

#warn below


/obj/machinery/atmospherics/component/trinary/filter/ui_act(action, params)
	if(..())
		return TRUE

	switch(action)
		if("power")
			update_use_power(!use_power)
		if("rate")
			var/rate = params["rate"]
			if(rate == "max")
				rate = air1.volume
				. = TRUE
			else if(text2num(rate) != null)
				rate = text2num(rate)
				. = TRUE
			if(.)
				set_flow_rate = clamp(rate, 0, air1.volume)

	update_icon()

//
// Mirrored Orientation - Flips the output dir to opposite side from normal.
//
/obj/machinery/atmospherics/component/trinary/filter/m_filter
	icon_state = "mmap"
	dir = SOUTH
	initialize_directions = SOUTH|NORTH|EAST
	mirrored = TRUE
