/***
 * Heat pumps, binary devices that pump heat between both ends
 */
#define EFFICENCY_MULT 1
#define EFFICENCY_LIMIT_MULT 1

/obj/machinery/atmospherics/binary/heat_pump
    name = "heat pump"
    desc = "A heat pump, used to transfer heat between two pipe systems."

    level = 1

    icon = 'icons/atmos/heat_pump.dmi'
    icon_state = "map_off"
    construction_type = /obj/item/pipe/directional
    pipe_state = "pump"
    var/base_icon = "heat_pump"

    use_power = USE_POWER_OFF
    idle_power_usage = 150//internal circuitry, friction losses and stuff
    power_rating = 15000//15000 W ~ 20 HP
    var/max_power_rating = 15000
    /*can be used for radio stuff later
    var/frequency = 0
	var/id = null
	var/datum/radio_frequency/radio_connection
    */  
    var/target_temp = T20C
    var/lowest_temp = TCMB
    var/on = 0

/obj/machinery/atmospherics/binary/heat_pump/CtrlClick(mob/user)
    if (Adjacent(user))
        add_hiddenprint(user)
        if(powered())
            to_chat(user, "You toggle the power to the [src] [on ? "Off" : "On"].")
            update_use_power(!use_power)
            on = !on
            update_icon()
        else
            to_chat(user, "<span class='warning'>There doesn't seem to be any power.</span>")

/obj/machinery/atmospherics/binary/heat_pump/CtrlShiftClick(mob/user)
    if(Adjacent(user))
        add_hiddenprint(user)
        if (powered())
            to_chat(user, "You set the target temperature of the [src] to default.")
            target_temp = T20C
        else
            to_chat(user, "<span class='warning'>There doesn't seem to be any power.</span>")

/obj/machinery/atmospherics/binary/heat_pump/AltClick(mob/user)
    if(Adjacent(user))
        add_hiddenprint(user)
        if (powered())
            to_chat(user, "You set the target temperature of the [src] to [TCMB] Kelvin.")
            target_temp = TCMB
        else
            to_chat(user, "<span class='warning'>There doesn't seem to be any power.</span>")

/obj/machinery/atmospherics/binary/heat_pump/Initialize(mapload)
    . = ..()
    air1.volume = ATMOS_DEFAULT_VOLUME_PUMP
    air2.volume = ATMOS_DEFAULT_VOLUME_PUMP

/obj/machinery/atmospherics/binary/passive_gate/Destroy()
	unregister_radio(src, frequency)
	. = ..()

/obj/machinery/atmospherics/binary/heat_pump/update_icon()
    if(!powered() || !on)
        icon_state = "off"
    else if(air1.temperature < target_temp)
        icon_state = "cool_1"
    else if(air1.temperature > target_temp)
        icon_state = "cool_2"
    else
        icon_state = "off"

/obj/machinery/atmospherics/binary/heat_pump/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		add_underlay(T, node1, turn(dir, 180))
		add_underlay(T, node2, dir)

/obj/machinery/atmospherics/binary/heat_pump/hide(var/i)
	update_underlays()

/obj/machinery/atmospherics/binary/heat_pump/attack_hand(user as mob)
	if(..())
		return
	src.add_fingerprint(usr)
	if(!src.allowed(user))
		to_chat(user, "<span class='warning'>Access denied.</span>")
		return
	usr.set_machine(src)
	ui_interact(user)
	return

/obj/machinery/atmospherics/binary/heat_pump/process(delta_time)
    update_icon()
    if((stat & (NOPOWER|BROKEN)) || !use_power)
        return

    if( !air1 ||  !air2)
        return

    if((air2.temperature <= target_temp+0.1) && (air2.temperature >= target_temp-0.1))
        return//We are close enough to our target temp that its not worth the hassle
    
    if(check_passive_opportunity())
        handle_passive_flow()
        return//No need to pump while there is passive flow occuring

    //Now we are at the point where we need to actively pump
    var/efficiency = get_thermal_efficency()
    var/energy_transfered = 0
    CACHE_VSC_PROP(atmos_vsc, /atmos/heatpump/performance_factor, performance_factor)

    energy_transfered = clamp(air2.get_thermal_energy_change(target_temp),performance_factor*power_rating,-performance_factor*power_rating)
    
    var/power_draw = abs(energy_transfered/performance_factor)
    air2.add_thermal_energy(energy_transfered*efficiency)
    air1.add_thermal_energy(-energy_transfered*efficiency)
    if (power_draw >= 0)
        last_power_draw = power_draw
        use_power(power_draw)
        if(network1)
            network1.update = 1
        if(network2)
            network2.update = 1

/obj/machinery/atmospherics/binary/heat_pump/proc/get_thermal_efficency()
    if((target_temp < air2.temperature))
        return clamp((air2.temperature/air1.temperature)*EFFICENCY_MULT,0,1*EFFICENCY_LIMIT_MULT)
    else if((target_temp > air2.temperature))
        return clamp((air1.temperature/air2.temperature)*EFFICENCY_MULT,0,1*EFFICENCY_LIMIT_MULT)

/obj/machinery/atmospherics/binary/heat_pump/proc/handle_passive_flow()
    var/air_heat_capacity = air1.heat_capacity()
    var/other_air_heat_capacity = air2.heat_capacity()
    var/combined_heat_capacity = other_air_heat_capacity + air_heat_capacity

    if(combined_heat_capacity > 0)
        var/combined_energy = air1.temperature*other_air_heat_capacity + air_heat_capacity*air2.temperature

        var/new_temperature = combined_energy/combined_heat_capacity
        air1.temperature = new_temperature
        air2.temperature = new_temperature

/obj/machinery/atmospherics/binary/heat_pump/proc/check_passive_opportunity()
    if((target_temp < air2.temperature) && (air1.temperature < air2.temperature))
        return TRUE
    if((target_temp > air2.temperature) && (air1.temperature > air2.temperature))
        return TRUE
    return FALSE
    
/obj/machinery/atmospherics/binary/heat_pump/ui_interact(mob/user, datum/tgui/ui)
    ui = SStgui.try_update_ui(user, src, ui)
    if(!ui)
        ui = new(user, src, "heat_pump", name)
        ui.open()

/obj/machinery/atmospherics/binary/heat_pump/ui_data(mob/user)
    var/list/data = list()
    data["target_temp"] = target_temp
    data["current_temp"] = air2.temperature
    data["sink_temp"] = air1.temperature
    data["power_level"] = power_rating
    data["max_power_level"] = max_power_rating
    data["on"] = on
    data["lowest_temp"] = lowest_temp

    return data

/obj/machinery/atmospherics/binary/heat_pump/ui_state(mob/user)
    return GLOB.physical_state

/obj/machinery/atmospherics/binary/heat_pump/ui_act(action, params)
    if(..())
        return TRUE
    switch(action)
        if("power")
            on = !on
            if(on)
                use_power = USE_POWER_ACTIVE
            else
                use_power = USE_POWER_OFF
        if("target_temp")
            var/newValue = params["temperature"]
            if(text2num(newValue) != null)
                target_temp = text2num(newValue)
                . = TRUE
            if(.)
                target_temp = max(newValue,lowest_temp)


#undef EFFICENCY_MULT
#undef EFFICENCY_LIMIT_MULT
