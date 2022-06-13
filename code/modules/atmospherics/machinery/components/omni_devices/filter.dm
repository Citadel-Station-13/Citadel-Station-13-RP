// In theory these lists could be generated at runtime from values
// on the XGM gas datums - would need to have a consistent/constant
// id for the gasses but otherwise should allow for true omni filters.

GLOBAL_LIST_INIT(filter_gas_to_mode, list(    \
	"None" =           ATM_NONE,              \
	"Oxygen" =         ATM_O2,                \
	"Nitrogen" =       ATM_N2,                \
	"Carbon Dioxide" = ATM_CO2,               \
	"Phoron" =         ATM_P,                 \
	"Nitrous Oxide" =  ATM_N2O,               \
	"Hydrogen" =       ATM_H2,                \
	"Methyl Bromide" = ATM_CH3BR              \
))

GLOBAL_LIST_INIT(filter_mode_to_gas, list(    \
	"[ATM_O2]" =       "Oxygen",              \
	"[ATM_N2]" =       "Nitrogen",            \
	"[ATM_CO2]" =      "Carbon Dioxide",      \
	"[ATM_P]" =        "Phoron",              \
	"[ATM_N2O]" =      "Nitrous Oxide",       \
	"[ATM_H2]" =       "Hydrogen",            \
	"[ATM_CH3BR]" =    "Methyl Bromide"       \
))

GLOBAL_LIST_INIT(filter_mode_to_gas_id, list( \
	"[ATM_O2]" =       "[GAS_OXYGEN]",        \
	"[ATM_N2]" =       "[GAS_NITROGEN]",      \
	"[ATM_CO2]" =      "[GAS_CO2]",           \
	"[ATM_P]" =        "[GAS_PHORON]",        \
	"[ATM_N2O]" =      "[GAS_N2O]",           \
	"[ATM_H2]" =       "[GAS_HYDROGEN]",      \
	"[ATM_CH3BR]" =    "[GAS_METHYL_BROMIDE]" \
))

//--------------------------------------------
// Gas filter - omni variant
//--------------------------------------------
/obj/machinery/atmospherics/component/quaternary/filter
	name = "omni gas filter"
	icon_state = "map_filter"
	pipe_state = "omni_filter"

	var/list/gas_filters = new()
	var/datum/omni_port/input
	var/datum/omni_port/output
	var/max_output_pressure = MAX_OMNI_PRESSURE

	idle_power_usage = 150 //internal circuitry, friction losses and stuff
	power_rating = 15000 // 15000 W ~ 20 HP

	var/max_flow_rate = ATMOS_DEFAULT_VOLUME_FILTER
	var/set_flow_rate = ATMOS_DEFAULT_VOLUME_FILTER

	var/list/filtering_outputs = list()	//maps gasids to gas_mixtures

/obj/machinery/atmospherics/component/quaternary/filter/Initialize(mapload)
	. = ..()
	rebuild_filtering_list()
	for(var/datum/omni_port/P in ports)
		P.air.volume = ATMOS_DEFAULT_VOLUME_FILTER

/obj/machinery/atmospherics/component/quaternary/filter/Destroy()
	input = null
	output = null
	gas_filters.Cut()
	return ..()

/obj/machinery/atmospherics/component/quaternary/filter/sort_ports()
	for(var/datum/omni_port/P in ports)
		if(P.update)
			if(output == P)
				output = null
			if(input == P)
				input = null
			if(gas_filters.Find(P))
				gas_filters -= P

			P.air.volume = ATMOS_DEFAULT_VOLUME_FILTER
			switch(P.mode)
				if(ATM_INPUT)
					input = P
				if(ATM_OUTPUT)
					output = P
				if(ATM_O2 to ATM_N2O)
					gas_filters += P

/obj/machinery/atmospherics/component/quaternary/filter/error_check()
	if(!input || !output || !gas_filters)
		return TRUE
	if(gas_filters.len < 1) //requires at least 1 gas_filters ~otherwise why are you using a filter?
		return TRUE

	return FALSE

/obj/machinery/atmospherics/component/quaternary/filter/process(delta_time)
	if(!..())
		return FALSE

	var/datum/gas_mixture/output_air = output.air // BYOND doesn't like referencing "output.air.return_pressure()" so we need to make a direct reference
	var/datum/gas_mixture/input_air = input.air   // it's completely happy with them if they're in a loop though i.e. "P.air.return_pressure()"... *shrug*

	var/delta = clamp((output_air ? (max_output_pressure - output_air.return_pressure()) : 0), 0, max_output_pressure)
	var/transfer_moles_max = calculate_transfer_moles(input_air, output_air, delta, (output && output.network && output.network.volume) ? output.network.volume : 0)
	for(var/datum/omni_port/filter_output in gas_filters)
		delta = clamp((filter_output.air ? (max_output_pressure - filter_output.air.return_pressure()) : 0), 0, max_output_pressure)
		transfer_moles_max = min(transfer_moles_max, (calculate_transfer_moles(input_air, filter_output.air, delta, (filter_output && filter_output.network && filter_output.network.volume) ? filter_output.network.volume : 0)))

	//Figure out the amount of moles to transfer
	var/transfer_moles = clamp(((set_flow_rate/input_air.volume)*input_air.total_moles), 0, transfer_moles_max)

	var/power_draw = -1
	if(transfer_moles > MINIMUM_MOLES_TO_FILTER)
		power_draw = filter_gas_multi(src, filtering_outputs, input_air, output_air, transfer_moles, power_rating)

	if (power_draw >= 0)
		last_power_draw = power_draw
		use_power_oneoff(power_draw)

		if(input.network)
			input.network.update = TRUE
		if(output.network)
			output.network.update = TRUE
		for(var/datum/omni_port/P in gas_filters)
			if(P.network)
				P.network.update = TRUE

	return TRUE

/obj/machinery/atmospherics/component/quaternary/filter/ui_interact(mob/user,datum/tgui/ui = null)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "OmniFilter", name)

		ui.open()

/obj/machinery/atmospherics/component/quaternary/filter/ui_data(mob/user)
	var/list/data = list()

	data["power"] = use_power
	data["config"] = configuring

	var/portData[0]
	for(var/datum/omni_port/P in ports)
		if(!configuring && P.mode == 0)
			continue

		var/input = 0
		var/output = 0
		var/is_filter = 1
		var/f_type = null
		switch(P.mode)
			if(ATM_INPUT)
				input = 1
				is_filter = 0
			if(ATM_OUTPUT)
				output = 1
				is_filter = 0
			if(ATM_O2 to ATM_N2O)
				f_type = mode_send_switch(P.mode)

		portData[++portData.len] = list( \
			"dir" = dir_name(P.dir, capitalize = 1), \
			"input" = input, \
			"output" = output, \
			"atmo_filter" = is_filter, \
			"f_type" = f_type, \
		)

	if(portData.len)
		data["ports"] = portData
	if(output)
		data["set_flow_rate"] = round(set_flow_rate*10) //TODO: TGUI can handle rounding.
		data["last_flow_rate"] = round(last_flow_rate*10)

	return data

/obj/machinery/atmospherics/component/quaternary/filter/proc/mode_send_switch(mode = ATM_NONE)
	return GLOB.filter_mode_to_gas["[mode]"]

/obj/machinery/atmospherics/component/quaternary/filter/ui_act(action, params)
	if(..())
		return TRUE

	switch(action)
		if("power")
			if(!configuring)
				update_use_power(!use_power)
			else
				update_use_power(USE_POWER_OFF)
			. = TRUE
		if("configure")
			configuring = !configuring
			if(configuring)
				update_use_power(USE_POWER_OFF)
			. = TRUE
		if("set_flow_rate")
			if(!configuring || use_power)
				return
			var/new_flow_rate = input(usr,"Enter new flow rate limit (0-[max_flow_rate]L/s)","Flow Rate Control",set_flow_rate) as num
			set_flow_rate = clamp( new_flow_rate, 0,  max_flow_rate)
			. = TRUE
		if("switch_mode")
			if(!configuring || use_power)
				return
			switch_mode(dir_flag(params["dir"]), mode_return_switch(params["mode"]))
			. = TRUE
		if("switch_filter")
			if(!configuring || use_power)
				return
			var/new_filter = input(usr,"Select filter mode:","Change filter",params["mode"]) in list("None", "Oxygen", "Nitrogen", "Carbon Dioxide", "Phoron", "Nitrous Oxide")
			switch_filter(dir_flag(params["dir"]), mode_return_switch(new_filter))
			. = TRUE

	update_icon()

/obj/machinery/atmospherics/component/quaternary/filter/proc/mode_return_switch(mode)
	. = GLOB.filter_gas_to_mode[mode]
	if(!.)
		switch(mode)
			if("in")
				return ATM_INPUT
			if("out")
				return ATM_OUTPUT

/obj/machinery/atmospherics/component/quaternary/filter/proc/switch_filter(dir, mode)
	//check they aren't trying to disable the input or output ~this can only happen if they hack the cached tmpl file
	for(var/datum/omni_port/P in ports)
		if(P.dir == dir)
			if(P.mode == ATM_INPUT || P.mode == ATM_OUTPUT)
				return

	switch_mode(dir, mode)

/obj/machinery/atmospherics/component/quaternary/filter/proc/switch_mode(port, mode)
	if(mode == null || !port)
		return

	var/datum/omni_port/target_port = null
	var/list/other_ports = new()

	for(var/datum/omni_port/P in ports)
		if(P.dir == port)
			target_port = P
		else
			other_ports += P

	var/previous_mode = null
	if(target_port)
		previous_mode = target_port.mode
		target_port.mode = mode
		if(target_port.mode != previous_mode)
			handle_port_change(target_port)
			rebuild_filtering_list()
		else
			return
	else
		return

	for(var/datum/omni_port/P in other_ports)
		if(P.mode == mode)
			var/old_mode = P.mode
			P.mode = previous_mode
			if(P.mode != old_mode)
				handle_port_change(P)

	update_ports()

/obj/machinery/atmospherics/component/quaternary/filter/proc/rebuild_filtering_list()
	filtering_outputs.Cut()
	for(var/datum/omni_port/P in ports)
		var/gasid = GLOB.filter_mode_to_gas_id["[P.mode]"]
		if(gasid)
			filtering_outputs[gasid] = P.air

/obj/machinery/atmospherics/component/quaternary/filter/proc/handle_port_change(datum/omni_port/P)
	switch(P.mode)
		if(ATM_NONE)
			initialize_directions &= ~P.dir
			P.disconnect()
		else
			initialize_directions |= P.dir
			P.connect()
	P.update = 1
