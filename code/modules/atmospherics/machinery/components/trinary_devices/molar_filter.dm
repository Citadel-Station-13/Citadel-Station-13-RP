/obj/machinery/atmospherics/component/trinary/molar_filter
	name = "molar filter"
	desc = "A prototype filter that filters gases based on their molar mass."
	icon = 'icons/modules/atmospherics/components/trinary/molar_filter.dmi'
	base_icon_state = "molar"
	icon_state = "molar-map"
	density = FALSE
	construction_type = /obj/item/pipe/trinary/flippable
	pipe_state = "filter"

	use_power = USE_POWER_IDLE
	idle_power_usage = 150
	power_maximum = 7500

	tgui_interface = "AtmosTrinaryMolarFilter"
	default_access_interface = TRUE
	atmos_component_ui_flags = ATMOS_COMPONENT_UI_TOGGLE_POWER

	/// inverted mode
	var/invert = FALSE
	/// lower molar bound
	var/mass_lower = 0
	/// upper molar bound
	var/mass_upper = 10000
	// todo: put flow rate at component level
	/// flow rate in L
	var/flow_setting = ATMOS_DEFAULT_VOLUME_FILTER
	/// current flow rate in L
	var/flow_current = 0

/obj/machinery/atmospherics/component/trinary/molar_filter/Initialize(mapload)
	. = ..()
	air1.volume = ATMOS_DEFAULT_VOLUME_FILTER
	air2.volume = ATMOS_DEFAULT_VOLUME_FILTER
	air3.volume = ATMOS_DEFAULT_VOLUME_FILTER

/obj/machinery/atmospherics/component/trinary/molar_filter/update_icon_state()
	var/is_on = on && powered() && (node1 && node2 && node3)
	icon_state = "[base_icon_state][mirrored? "-f" : ""][(is_on? "-on" : "")]"
	return ..()

/obj/machinery/atmospherics/component/trinary/molar_filter/process(delta_time)
	..()

	if(!on || inoperable())
		return

	var/old_mols = air1.total_moles
	var/transfer_mols = (flow_setting / air1.volume) * old_mols

	if(transfer_mols > MINIMUM_MOLES_TO_FILTER)
		if(invert)
			power_current = xgm_molar_filter_gas(air1, air2, air3, mass_lower, mass_upper, transfer_mols, power_setting * efficiency_multiplier) / efficiency_multiplier
		else
			power_current = xgm_molar_filter_gas(air1, air3, air2, mass_lower, mass_upper, transfer_mols, power_setting * efficiency_multiplier) / efficiency_multiplier
		flow_current = (1 - air1.total_moles / old_mols) * air1.volume

		// todo: better API for this
		network1?.update = TRUE
		network2?.update = TRUE
		network3?.update = TRUE

	if(power_current)
		use_power(power_current)
		// switch to watts instead of joules by dividing out tick time
		power_current /= delta_time

/obj/machinery/atmospherics/component/trinary/molar_filter/proc/set_rate(liters)
	flow_setting = clamp(liters, 0, air1.volume)

/obj/machinery/atmospherics/component/trinary/molar_filter/ui_data(mob/user, datum/tgui/ui)
	. = ..()
	.["lower"] = mass_lower
	.["upper"] = mass_upper
	.["invert"] = invert
	.["maxRate"] = air1.volume
	.["rate"] = flow_setting

/obj/machinery/atmospherics/component/trinary/molar_filter/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	switch(action)
		if("lower")
			var/target = params["target"]
			target = clamp(text2num(target), 0, INFINITY)
			mass_lower = target
			mass_upper = max(mass_upper, mass_lower)
			return TRUE
		if("upper")
			var/target = params["target"]
			target = clamp(text2num(target), 0, INFINITY)
			mass_upper = target
			mass_lower = min(mass_lower, mass_upper)
			return TRUE
		if("invert")
			invert = !invert
			return TRUE
		if("rate")
			var/liters = params["rate"]
			if(isnull(liters))
				return FALSE
			set_rate(liters)
			return TRUE

/obj/machinery/atmospherics/component/trinary/molar_filter/mirrored
	dir = SOUTH
	initialize_directions = SOUTH|NORTH|EAST
	mirrored = TRUE
	icon_state = "molar-f-map"
