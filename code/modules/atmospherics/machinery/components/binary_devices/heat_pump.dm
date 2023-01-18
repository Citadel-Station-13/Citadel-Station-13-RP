/***
 * Heat pumps, binary devices that pump heat between both ends
 */
#define EFFICENCY_MULT 1
#define EFFICENCY_LIMIT_MULT 1

/obj/machinery/atmospherics/component/binary/heat_pump
	name = "heat pump"
	desc = "A heat pump, used to transfer heat between two pipe systems."

	level = 1

	icon = 'icons/atmos/heat_pump.dmi'
	icon_state = "map_off"
	construction_type = /obj/item/pipe/directional
	pipe_state = "pump"

	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_AUX

	use_power = USE_POWER_OFF
	//Internal circuitry, friction losses and stuff
	idle_power_usage = 150
	//15000 W ~ 20 HP
	power_rating = 15000
	var/max_power_rating = 15000
	/*can be used for radio stuff later
	var/frequency = 0
	var/id = null
	var/datum/radio_frequency/radio_connection
    */
	var/target_temp = T20C
	var/lowest_temp = TCMB
	var/max_temp = 99999999//Need to bottle it somewhere, the sun's core has 15 million kelvin

	var/on = 0
	var/efficiency = 0

/obj/machinery/atmospherics/component/binary/heat_pump/CtrlClick(mob/user)
	if(Adjacent(user))
		add_hiddenprint(user)
		if(powered())
			to_chat(user, "You toggle the power to the [src] [on ? "Off" : "On"].")
			update_use_power(!use_power)
			on = !on
			update_icon()
		else
			to_chat(user, SPAN_WARNING("There doesn't seem to be any power."))

/obj/machinery/atmospherics/component/binary/heat_pump/CtrlShiftClick(mob/user)
	if(Adjacent(user))
		add_hiddenprint(user)
		if (powered())
			to_chat(user, "You set the target temperature of the [src] to default.")
			target_temp = T20C
		else
			to_chat(user, SPAN_WARNING("There doesn't seem to be any power."))

/obj/machinery/atmospherics/component/binary/heat_pump/AltClick(mob/user)
	if(Adjacent(user))
		add_hiddenprint(user)
		if (powered())
			to_chat(user, "You set the target temperature of the [src] to [TCMB] Kelvin.")
			target_temp = TCMB
		else
			to_chat(user, SPAN_WARNING("There doesn't seem to be any power."))

/obj/machinery/atmospherics/component/binary/heat_pump/Initialize(mapload)
	. = ..()
	air1.volume = ATMOS_DEFAULT_VOLUME_PUMP
	air2.volume = ATMOS_DEFAULT_VOLUME_PUMP

/obj/machinery/atmospherics/component/binary/passive_gate/Destroy()
	unregister_radio(src, frequency)
	. = ..()

/obj/machinery/atmospherics/component/binary/heat_pump/update_icon()
	. = ..()
	if(!powered() || !on)
		icon_state = "off"
	else if(air1.temperature < target_temp)
		icon_state = "cool_1"
	else if(air1.temperature > target_temp)
		icon_state = "cool_2"
	else
		icon_state = "off"

/obj/machinery/atmospherics/component/binary/heat_pump/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		add_underlay(T, node1, turn(dir, 180))
		add_underlay(T, node2, dir)

/obj/machinery/atmospherics/component/binary/heat_pump/hide(var/i)
	update_underlays()

/obj/machinery/atmospherics/component/binary/heat_pump/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/pen))
		var/new_name = input(user, "Please enter the new name for this device:", "New Name")  as text|null
		new_name = trim(new_name)
		name = (new_name? new_name : name)
		return
	if (!W.is_wrench())
		return ..()
	if (!(machine_stat & NOPOWER) && use_power)
		to_chat(user, "<span class='warning'>You cannot unwrench this [src], turn it off first.</span>")
		return 1
	add_fingerprint(user)
	playsound(src, W.tool_sound, 50, 1)
	to_chat(user, "<span class='notice'>You begin to unfasten \the [src]...</span>")
	if (do_after(user, 40 * W.tool_speed))
		user.visible_message( \
			"<span class='notice'>\The [user] unfastens \the [src].</span>", \
			"<span class='notice'>You have unfastened \the [src].</span>", \
			"You hear ratchet.")
		deconstruct()

/obj/machinery/atmospherics/component/binary/heat_pump/attack_hand(user as mob)
	if(..())
		return
	src.add_fingerprint(usr)
	if(!src.allowed(user))
		to_chat(user, SPAN_BOLDWARNING("Access denied."))
		return
	usr.set_machine(src)
	ui_interact(user)
	return

/obj/machinery/atmospherics/component/binary/heat_pump/process(delta_time)
	update_icon()
	if((machine_stat & (NOPOWER|BROKEN)) || !use_power)
		return

	if(!air1 || !air2)
		return

	//If there is no air1 or 2 the temperature is assumed 0 Kelvin which allows for
	if((air1.temperature < 1) ||  (air2.temperature < 1))
		return

	//Now we are at the point where we need to actively pump
	efficiency = get_thermal_efficency()
	var/energy_transfered = 0
	CACHE_VSC_PROP(atmos_vsc, /atmos/heatpump/performance_factor, performance_factor)

	energy_transfered = clamp(air2.get_thermal_energy_change(target_temp),performance_factor*power_rating,-performance_factor*power_rating)

	var/power_draw = abs(energy_transfered/performance_factor)
	air2.adjust_thermal_energy(-air1.adjust_thermal_energy(-energy_transfered*efficiency))//only adds the energy actually removed from air one to air two(- infront of air1 because energy was removed)
	if (power_draw >= 0)
		last_power_draw = power_draw
		use_power(power_draw)
		if(network1)
			network1.update = 1
		if(network2)
			network2.update = 1

/obj/machinery/atmospherics/component/binary/heat_pump/proc/get_thermal_efficency()
	if((target_temp < air2.temperature))
		return clamp((air2.temperature / air1.temperature) * EFFICENCY_MULT, 0, 1 * EFFICENCY_LIMIT_MULT)
	else if((target_temp > air2.temperature))
		return clamp((air1.temperature / air2.temperature) * EFFICENCY_MULT, 0, 1 * EFFICENCY_LIMIT_MULT)

/obj/machinery/atmospherics/component/binary/heat_pump/proc/handle_passive_flow()
	var/air_heat_capacity = air1.heat_capacity()
	var/other_air_heat_capacity = air2.heat_capacity()
	var/combined_heat_capacity = other_air_heat_capacity + air_heat_capacity

	if(combined_heat_capacity > 0)
		var/combined_energy = air1.temperature*other_air_heat_capacity + air_heat_capacity*air2.temperature

		var/new_temperature = combined_energy/combined_heat_capacity
		air1.temperature = new_temperature
		air2.temperature = new_temperature

/obj/machinery/atmospherics/component/binary/heat_pump/proc/check_passive_opportunity()
    if((target_temp < air2.temperature) && (air1.temperature < air2.temperature - 5))//Little offsets to prevent just constant passive flow for minor temperature differences
        return TRUE
    if((target_temp > air2.temperature) && (air1.temperature > air2.temperature + 5))
        return TRUE
    return FALSE

/obj/machinery/atmospherics/component/binary/heat_pump/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "heat_pump", name)
		ui.open()

/obj/machinery/atmospherics/component/binary/heat_pump/ui_data(mob/user)
	var/list/data = list()
	data["target_temp"] = target_temp
	data["current_temp"] = air2.temperature
	data["sink_temp"] = air1.temperature
	data["on"] = on
	data["lowest_temp"] = lowest_temp
	data["highest_temp"] = max_temp
	data["efficency"] = efficiency


	return data

/obj/machinery/atmospherics/component/binary/heat_pump/ui_state(mob/user)
	return GLOB.physical_state

/obj/machinery/atmospherics/component/binary/heat_pump/ui_act(action, params)
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
