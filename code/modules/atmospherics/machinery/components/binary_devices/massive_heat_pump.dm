/**
 *  Massive heat pumps are wired, clunky machines that can use a dynamic amount of power to
 *  do the job of normal heat pumps
 */

#define EFFICENCY_MULT 1
#define EFFICENCY_LIMIT_MULT 1


/obj/machinery/atmospherics/component/binary/massive_heat_pump
	name = "High performance heat pump"
	use_power = USE_POWER_OFF
	idle_power_usage = 150
	power_rating = MAX_POWER_FOR_MASSIVE
	var/target_temp = T20C
	var/min_heat_setting = TCMB
	var/max_heat_setting = 99999999

	icon = 'icons/obj/machines/massive_pumps.dmi'
	icon_state = "pump"
	pipe_flags = PIPING_DEFAULT_LAYER_ONLY|PIPING_ONE_PER_TURF
	anchored = 1
	density = 1
	circuit = /obj/item/circuitboard/massive_heat_pump

	var/power_level = MAX_POWER_FOR_MASSIVE//So we can limit the power we work with and
	//dont just have a stupid pump that drains all power

	var/obj/machinery/power/powersupply/power_machine //for funky massive power machines
	//if its not null the machine attempts to draw from the grid the power machinery is connected to
	//see examples in the file "code\modules\atmospherics\components\binary_devices\massive_heat_pump.dm"
	var/on = 0
	var/efficiency = 0

/obj/machinery/atmospherics/component/binary/massive_heat_pump/Initialize(mapload)
	. = ..()
	power_machine = new(src)

	on_construction("#000", PIPING_LAYER_DEFAULT)
	air1.volume = ATMOS_DEFAULT_VOLUME_PUMP * 50//give it a much larger volume
	air2.volume = ATMOS_DEFAULT_VOLUME_PUMP * 50//default is 200 L we give it 1000 L or 1m³

	desc = initial(desc) + " Its outlet port is to the [dir2text(dir)]."
	default_apply_parts()
	update_icon()
	// TODO - Make these in actual icon states so its not silly like this
	var/image/I = image(icon = icon, icon_state = "algae-pipe-overlay", dir = dir)
	I.color = PIPE_COLOR_GREY
	overlays += I
	I = image(icon = icon, icon_state = "algae-pipe-overlay", dir = GLOB.reverse_dir[dir])
	I.color = PIPE_COLOR_GREY
	overlays += I

/obj/machinery/atmospherics/component/binary/massive_heat_pump/Destroy()
	. = ..()
	qdel(power_machine)

/obj/machinery/atmospherics/component/binary/massive_heat_pump/process(delta_time)
	if(!network1 || !network2)
		build_network()//built networks if we are missing them
		network1?.update = 1
		network2?.update = 1
		return
	if((machine_stat & (NOPOWER|BROKEN)) || !use_power)
		return

	if(!power_machine || !power_machine.powernet)
		if(!power_machine || !power_machine.connect_to_network())//returns 0 if it fails to find a
			return//make sure we are connected to a powernet

	power_rating = power_machine.surplus() * 1000 //update power rateing to what ever is avaiable
	power_rating = clamp(power_rating, 0, power_level)

	if(power_rating <= 0)
		return//no point in continuing if we dont have any power

	if(!air1 || !air2)
		return

	//If there is no air1 or 2 the temperature is assumed 0 Kelvin which allows for
	if((air1.temperature < 1) ||  (air2.temperature < 1))
		return

	var/power_draw = -1
	//Now we are at the point where we need to actively pump
	efficiency = get_thermal_efficency()
	var/energy_transfered = 0
	CACHE_VSC_PROP(atmos_vsc, /atmos/heatpump/performance_factor, performance_factor)

	energy_transfered = clamp(air2.get_thermal_energy_change(target_temp),performance_factor*power_rating,-performance_factor*power_rating)

	power_draw = abs(energy_transfered/performance_factor)
	air2.adjust_thermal_energy(-air1.adjust_thermal_energy(-energy_transfered*efficiency))//only adds the energy actually removed from air one to air two(- infront of air1 because energy was removed)

	if (power_draw >= 0)
		last_power_draw = power_draw

		power_machine.draw_power(power_draw * 0.001)
		if(network1)
			network1.update = 1

		if(network2)
			network2.update = 1

	return 1

/obj/machinery/atmospherics/component/binary/massive_heat_pump/proc/get_thermal_efficency()
	if((target_temp < air2.temperature))
		return clamp((air2.temperature / air1.temperature) * EFFICENCY_MULT, 0, 1 * EFFICENCY_LIMIT_MULT)
	else if((target_temp > air2.temperature))
		return clamp((air1.temperature / air2.temperature) * EFFICENCY_MULT, 0, 1 * EFFICENCY_LIMIT_MULT)

/obj/machinery/atmospherics/component/binary/massive_heat_pump/proc/handle_passive_flow()
	var/air_heat_capacity = air1.heat_capacity()
	var/other_air_heat_capacity = air2.heat_capacity()
	var/combined_heat_capacity = other_air_heat_capacity + air_heat_capacity

	if(combined_heat_capacity > 0)
		var/combined_energy = air1.temperature*other_air_heat_capacity + air_heat_capacity*air2.temperature

		var/new_temperature = combined_energy/combined_heat_capacity
		air1.temperature = new_temperature
		air2.temperature = new_temperature

/obj/machinery/atmospherics/component/binary/massive_heat_pump/proc/check_passive_opportunity()
    if((target_temp < air2.temperature) && (air1.temperature < air2.temperature - 5))//Little offsets to prevent just constant passive flow for minor temperature differences
        return TRUE
    if((target_temp > air2.temperature) && (air1.temperature > air2.temperature + 5))
        return TRUE
    return FALSE

/obj/machinery/atmospherics/component/binary/massive_heat_pump/attackby(obj/item/W as obj, mob/user as mob)
	add_fingerprint(user)
	if(default_deconstruction_screwdriver(user, W))
		return
	if(default_deconstruction_crowbar(user, W))
		return
	if(default_part_replacement(user, W))
		return
	else
		to_chat(user, SPAN_NOTICE("You cannot insert this item into \the [src]!"))
		return

/obj/machinery/atmospherics/component/binary/massive_heat_pump/update_icon()
	if(inoperable() || !anchored || !power_machine.powernet)
		icon_state = "pump"
	else if(use_power)
		switch(last_power_draw)
			if(1 to (1 MEGAWATTS))
				icon_state = "heat_1"
			if((1 MEGAWATTS) to (10 MEGAWATTS))
				icon_state = "heat_2"
			if((10 MEGAWATTS) to MAX_POWER_FOR_MASSIVE)
				icon_state = "heat_3"
	else
		icon_state = "pump"
	return TRUE

/obj/machinery/atmospherics/component/binary/massive_heat_pump/ui_interact(mob/user, datum/tgui/ui)
	if(machine_stat & (BROKEN|NOPOWER))
		return FALSE
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MassiveHeatPump", name)
		ui.open()

//This is the data which will be sent to the ui
/obj/machinery/atmospherics/component/binary/massive_heat_pump/ui_data(mob/user)
	var/list/data = list()

	data = list(
		"on" = use_power,
		"target_temp" = target_temp,
		"highest_temp" = max_heat_setting,
		"lowest_temp" = min_heat_setting,
		"power_level" = power_level,
		"current_temp" = air2.temperature,
		"sink_temp" = air1.temperature,
		"last_power_draw" = round(last_power_draw),
		"max_power_draw" = MAX_POWER_FOR_MASSIVE,
		"efficiency" = efficiency,
	)

	return data

/obj/machinery/atmospherics/component/binary/massive_heat_pump/attack_hand(mob/user)
	if(..())
		return
	add_fingerprint(usr)
	if(!allowed(user))
		to_chat(user, SPAN_WARNING("Access denied."))
		return
	ui_interact(user)

/obj/machinery/atmospherics/component/binary/massive_heat_pump/ui_act(action, params)
	if(..())
		return TRUE

	switch(action)
		if("power")
			update_use_power(!use_power)
			. = TRUE
		if("set_temp")
			var/temp = params["temp"]
			switch(temp)
				if("min")
					src.target_temp = min_heat_setting
				if("max")
					src.target_temp = max_heat_setting
				if("set")
					src.target_temp = input(usr,"Enter new target Temperature","Temperature controll",src.target_temp) as num
			src.target_temp = clamp( target_temp, min_heat_setting,  max_heat_setting)
			. = TRUE
		if("set_pow")
			var/pow = params["pow"]
			switch(pow)
				if("min")
					power_level = 0
				if("max")
					power_level = MAX_POWER_FOR_MASSIVE
				if("set")
					var/new_power_level = input(usr,"Enter new power level (0-10 GW)","Power control",src.power_level) as num
					src.power_level = clamp( new_power_level, 0,  MAX_POWER_FOR_MASSIVE)
			. = TRUE

	update_icon()


#undef EFFICENCY_MULT
#undef EFFICENCY_LIMIT_MULT
