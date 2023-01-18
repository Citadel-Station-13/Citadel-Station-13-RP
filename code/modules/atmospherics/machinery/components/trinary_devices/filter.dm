/obj/machinery/atmospherics/component/trinary/atmos_filter
	icon = 'icons/atmos/filter.dmi'
	icon_state = "map"
	construction_type = /obj/item/pipe/trinary/flippable
	pipe_state = "filter"
	density = 0
	level = 1

	name = "Gas filter"

	use_power = USE_POWER_IDLE
	idle_power_usage = 150		//internal circuitry, friction losses and stuff
	power_rating = 7500	//This also doubles as a measure of how powerful the filter is, in Watts. 7500 W ~ 10 HP

	var/temp = null // -- TLE

	var/set_flow_rate = ATMOS_DEFAULT_VOLUME_FILTER

	/*
	Filter types:
	-1: Nothing
	 0: Phoron: Phoron, Oxygen Agent B
	 1: Oxygen: Oxygen ONLY
	 2: Nitrogen: Nitrogen ONLY
	 3: Carbon Dioxide: Carbon Dioxide ONLY
	 4: Sleeping Agent (N2O)
	*/
	var/filter_type = -1
	var/list/filtered_out = list()


	var/frequency = 0
	var/datum/radio_frequency/radio_connection

/obj/machinery/atmospherics/component/trinary/atmos_filter/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	if(frequency)
		radio_connection = radio_controller.add_object(src, frequency, RADIO_ATMOSIA)

/obj/machinery/atmospherics/component/trinary/atmos_filter/Initialize(mapload)
	. = ..()
	switch(filter_type)
		if(0) //removing hydrocarbons
			filtered_out += /datum/gas/phoron
			filtered_out += /datum/gas/volatile_fuel
		if(1) //removing O2
			filtered_out += /datum/gas/oxygen
		if(2) //removing N2
			filtered_out += /datum/gas/nitrogen
		if(3) //removing CO2
			filtered_out += /datum/gas/carbon_dioxide
		if(4)//removing N2O
			filtered_out += /datum/gas/nitrous_oxide

	air1.volume = ATMOS_DEFAULT_VOLUME_FILTER
	air2.volume = ATMOS_DEFAULT_VOLUME_FILTER
	air3.volume = ATMOS_DEFAULT_VOLUME_FILTER

/obj/machinery/atmospherics/component/trinary/atmos_filter/Destroy()
	unregister_radio(src, frequency)
	. = ..()

/obj/machinery/atmospherics/component/trinary/atmos_filter/update_icon()
	if(mirrored)
		icon_state = "m"
	else
		icon_state = ""

	if(!powered())
		icon_state += "off"
	else if(node2 && node3 && node1)
		icon_state += use_power ? "on" : "off"
	else
		icon_state += "off"
		update_use_power(USE_POWER_OFF)

/obj/machinery/atmospherics/component/trinary/atmos_filter/process(delta_time)
	..()

	last_power_draw = 0
	last_flow_rate = 0

	if((machine_stat & (NOPOWER|BROKEN)) || !use_power)
		return

	//Figure out the amount of moles to transfer
	var/transfer_moles = (set_flow_rate/air1.volume)*air1.total_moles

	var/power_draw = -1
	if (transfer_moles > MINIMUM_MOLES_TO_FILTER)
		power_draw = filter_gas(src, filtered_out, air1, air2, air3, transfer_moles, power_rating)

		if(network2)
			network2.update = 1

		if(network3)
			network3.update = 1

		if(network1)
			network1.update = 1

	if (power_draw >= 0)
		last_power_draw = power_draw
		use_power(power_draw)

	return 1

/obj/machinery/atmospherics/component/trinary/atmos_filter/Initialize(mapload)
	. = ..()
	if(frequency)
		set_frequency(frequency)

/obj/machinery/atmospherics/component/trinary/atmos_filter/attack_hand(user)
	if(..())
		return
	if(!src.allowed(user))
		to_chat(user, SPAN_WARNING("Access denied."))
		return
	ui_interact(user)

/obj/machinery/atmospherics/component/trinary/atmos_filter/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AtmosFilter", name)
		ui.open()

/obj/machinery/atmospherics/component/trinary/atmos_filter/ui_data(mob/user)
	var/list/data = list()

	data["on"] = use_power
	data["rate"] = set_flow_rate
	data["max_rate"] = air1.volume
	data["last_flow_rate"] = round(last_flow_rate, 0.1)

	data["filter_types"] = list()
	data["filter_types"] += list(list("name" = "Nothing",        "f_type" = -1, "selected" = filter_type == -1))
	data["filter_types"] += list(list("name" = "Phoron",         "f_type" =  0, "selected" = filter_type ==  0))
	data["filter_types"] += list(list("name" = "Oxygen",         "f_type" =  1, "selected" = filter_type ==  1))
	data["filter_types"] += list(list("name" = "Nitrogen",       "f_type" =  2, "selected" = filter_type ==  2))
	data["filter_types"] += list(list("name" = "Carbon Dioxide", "f_type" =  3, "selected" = filter_type ==  3))
	data["filter_types"] += list(list("name" = "Nitrous Oxide",  "f_type" =  4, "selected" = filter_type ==  4))

	return data

/obj/machinery/atmospherics/component/trinary/atmos_filter/ui_act(action, params)
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
		if("filter")
			. = TRUE
			filter_type = text2num(params["filterset"])
			filtered_out.len = 0 //no need to create new lists unnecessarily
			switch(filter_type)
				if(0) //removing hydrocarbons
					filtered_out += /datum/gas/phoron
					filtered_out += /datum/gas/volatile_fuel
				if(1) //removing O2
					filtered_out += /datum/gas/oxygen
				if(2) //removing N2
					filtered_out += /datum/gas/nitrogen
				if(3) //removing CO2
					filtered_out += /datum/gas/carbon_dioxide
				if(4)//removing N2O
					filtered_out += /datum/gas/nitrous_oxide

	update_icon()

//
// Mirrored Orientation - Flips the output dir to opposite side from normal.
//
/obj/machinery/atmospherics/component/trinary/atmos_filter/m_filter
	icon_state = "mmap"
	dir = SOUTH
	initialize_directions = SOUTH|NORTH|EAST
	mirrored = TRUE
