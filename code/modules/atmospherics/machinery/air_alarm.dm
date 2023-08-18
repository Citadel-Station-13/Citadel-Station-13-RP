GLOBAL_LIST_EMPTY(air_alarms)

#define DECLARE_TLV_VALUES var/red_min; var/yel_min; var/yel_max; var/red_max; var/tlv_comparitor;
#define LOAD_TLV_VALUES(x, y) red_min = x[1]; yel_min = x[2]; yel_max = x[3]; red_max = x[4]; tlv_comparitor = y;
#define TEST_TLV_VALUES (((tlv_comparitor >= red_max && red_max > 0) || tlv_comparitor <= red_min) ? AIR_ALARM_RAISE_DANGER : ((tlv_comparitor >= yel_max && yel_max > 0) || tlv_comparitor <= yel_min) ? AIR_ALARM_RAISE_WARNING : AIR_ALARM_RAISE_OKAY)

#define MAX_TEMPERATURE 90
#define MIN_TEMPERATURE -40

//all air alarms in area are connected via magic
/area
	var/obj/machinery/air_alarm/master_air_alarm

/obj/machinery/air_alarm
	name = "alarm"
	desc = "Used to control various station atmospheric systems. The light indicates the current air status of the area."
	icon = 'icons/obj/monitors.dmi'
	icon_state = "alarm0"
	plane = TURF_PLANE
	layer = ABOVE_TURF_LAYER
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 80
	active_power_usage = 1000 //For heating/cooling rooms. 1000 joules equates to about 1 degree every 2 seconds for a single tile of air.
	power_channel = ENVIRON
	req_one_access = list(ACCESS_ENGINEERING_ATMOS, ACCESS_ENGINEERING_ENGINE)
	clicksound = "button"
	clickvol = 30
	//blocks_emissive = NONE
	light_power = 0.25

	/// The area we're registered to
	var/area/registered_area
	/// keys are gas group names
	/// values are TLV lists
	var/list/tlv_groups = list()
	/// keys are gas ids
	/// values are TLV lists
	var/list/tlv_ids = list()
	/// pressure tlv list
	var/list/tlv_pressure
	/// temperature tlv list
	var/list/tlv_temperature
	/// mode
	var/mode = AIR_ALARM_MODE_SCRUB

	var/alarm_id = null
	///Whether to use automatic breach detection or not
	var/breach_detection = TRUE
	var/frequency = 1439
	//var/skipprocess = 0 //Experimenting
	var/alarm_frequency = 1437
	var/remote_control = FALSE
	var/rcon_setting = RCON_AUTO
	var/rcon_time = 0
	var/locked = TRUE
	///If it's been screwdrivered open.
	panel_open = FALSE
	var/aidisabled = FALSE
	var/shorted = FALSE
	circuit = /obj/item/circuitboard/airalarm
	//armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 100, BOMB = 0, BIO = 100, FIRE = 90, ACID = 30)

	var/datum/wires/alarm/wires

	var/area_uid
	var/area/alarm_area

	var/target_temperature = T20C
	var/regulating_temperature = 0

	var/datum/radio_frequency/radio_connection

	var/danger_level = 0
	var/pressure_dangerlevel = 0

	var/report_danger_level = 1
	///If the alarms from this machine are visible on consoles
	var/alarms_hidden = FALSE

/obj/machinery/air_alarm/Initialize(mapload)
	. = ..()
	GLOB.air_alarms += src
	if(!pixel_x && !pixel_y)
		offset_airalarm()
	first_run()
	set_frequency(frequency)
	if(!master_is_operating())
		elect_master()

/obj/machinery/air_alarm/Destroy()
	GLOB.air_alarms -= src
	unregister_radio(src, frequency)
	qdel(wires)
	wires = null
	if(alarm_area && alarm_area.master_air_alarm == src)
		alarm_area.master_air_alarm = null
		elect_master(exclude_self = TRUE)
	return ..()

/obj/machinery/air_alarm/proc/offset_airalarm()
	pixel_x = (dir & 3) ? 0 : (dir == 4 ? -26 : 26)
	pixel_y = (dir & 3) ? (dir == 1 ? -26 : 26) : 0

/obj/machinery/air_alarm/proc/first_run()
	alarm_area = get_area(src)
	registered_area = alarm_area
	area_uid = "\ref[alarm_area]"
	if(name == "alarm")
		name = "[alarm_area.name] Air Alarm"

	if(!wires)
		wires = new(src)

	update_icon()
	create_tlv()

/obj/machinery/air_alarm/proc/create_tlv()
	if(isnull(tlv_pressure))
		tlv_pressure = AIR_ALARM_MAKE_TLV(0.7 * ONE_ATMOSPHERE, 0.9 * ONE_ATMOSPHERE, 1.1 * ONE_ATMOSPHERE, 1.3 * ONE_ATMOSPHERE)
	if(isnull(tlv_temperature))
		tlv_temperature = AIR_ALARM_MAKE_TLV(T0C - 26, T0C, T0C + 35, T0C + 60)
	for(var/id in global.gas_data.gas_ids_core)
		var/list/default = global.gas_data.default_tlvs[id]
		if(isnull(default))
			continue
		if(!isnull(tlv_ids[id]))
			continue
		tlv_ids[id] = default
	for(var/group in global.gas_data.gas_group_names_filterable)
		if(!isnull(tlv_groups[group]))
			continue
		tlv_groups[group] = AIR_ALARM_MAKE_TLV(0, 0, 0.5, 1)

/obj/machinery/air_alarm/process(delta_time)
	if((machine_stat & (NOPOWER|BROKEN)) || shorted)
		return

	var/turf/simulated/location = src.loc
	if(!istype(location))	return//returns if loc is not simulated

	var/datum/gas_mixture/environment = location.return_air()

	//Handle temperature adjustment here.
	handle_heating_cooling(environment)

	var/old_level = danger_level
	var/old_pressurelevel = pressure_dangerlevel
	danger_level = overall_danger_level(environment)

	if(old_level != danger_level)
		apply_danger_level(danger_level)

	if(old_pressurelevel != pressure_dangerlevel)
		if(breach_detected())
			mode = AIR_ALARM_MODE_OFF
			apply_mode()

	if(mode == AIR_ALARM_MODE_CYCLE && environment.return_pressure() < ONE_ATMOSPHERE * 0.05)
		mode = AIR_ALARM_MODE_FILL
		apply_mode()

	//atmos computer remote control stuff
	switch(rcon_setting)
		if(RCON_NO)
			remote_control = 0
		if(RCON_AUTO)
			if(danger_level == 2)
				remote_control = 1
			else
				remote_control = 0
		if(RCON_YES)
			remote_control = 1

	return

/obj/machinery/air_alarm/proc/handle_heating_cooling(var/datum/gas_mixture/environment)
	var/list/tlv = tlv_temperature
	var/this_is_fine = AIR_ALARM_TEST_TLV(target_temperature, tlv)
	if(!regulating_temperature)
		//check for when we should start adjusting temperature
		if((this_is_fine == AIR_ALARM_RAISE_OKAY) && abs(environment.temperature - target_temperature) > 2.0 && environment.return_pressure() >= 1)
			update_use_power(USE_POWER_ACTIVE)
			regulating_temperature = 1
			audible_message("\The [src] clicks as it starts [environment.temperature > target_temperature ? "cooling" : "heating"] the room.",\
			"You hear a click and a faint electronic hum.")
			playsound(src, 'sound/machines/click.ogg', 50, 1)
	else
		//check for when we should stop adjusting temperature
		if((this_is_fine != AIR_ALARM_RAISE_OKAY) || abs(environment.temperature - target_temperature) <= 0.5 || environment.return_pressure() < 1)
			update_use_power(USE_POWER_IDLE)
			regulating_temperature = 0
			audible_message("\The [src] clicks quietly as it stops [environment.temperature > target_temperature ? "cooling" : "heating"] the room.",\
			"You hear a click as a faint electronic humming stops.")
			playsound(src, 'sound/machines/click.ogg', 50, 1)

	if(regulating_temperature)
		if(target_temperature > T0C + MAX_TEMPERATURE)
			target_temperature = T0C + MAX_TEMPERATURE

		if(target_temperature < T0C + MIN_TEMPERATURE)
			target_temperature = T0C + MIN_TEMPERATURE

		var/datum/gas_mixture/gas
		gas = environment.remove(0.25 * environment.total_moles)
		if(gas)

			if(gas.temperature <= target_temperature)	//gas heating
				var/energy_used = min(gas.get_thermal_energy_change(target_temperature) , active_power_usage)

				gas.adjust_thermal_energy(energy_used)
				//use_power(energy_used, ENVIRON) //handle by update_use_power instead
			else	//gas cooling
				var/heat_transfer = min(abs(gas.get_thermal_energy_change(target_temperature)), active_power_usage)

				//Assume the heat is being pumped into the hull which is fixed at 20 C
				//none of this is really proper thermodynamics but whatever

				var/cop = gas.temperature / T20C	//coefficient of performance -> power used = heat_transfer/cop

				heat_transfer = min(heat_transfer, cop * active_power_usage)	//this ensures that we don't use more than active_power_usage amount of power

				heat_transfer = -gas.adjust_thermal_energy(-heat_transfer)	//get the actual heat transfer

				//use_power(heat_transfer / cop, ENVIRON)	//handle by update_use_power instead

			environment.merge(gas)

/obj/machinery/air_alarm/proc/overall_danger_level(datum/gas_mixture/environment)
	var/environment_pressure = environment.return_pressure()
	var/partial_pressure_factor = (R_IDEAL_GAS_EQUATION * environment.temperature) / environment.volume

	var/dangerlevel = AIR_ALARM_TEST_TLV(environment_pressure, tlv_pressure)
	if(dangerlevel >= AIR_ALARM_RAISE_DANGER)
		return dangerlevel
	dangerlevel = max(dangerlevel, AIR_ALARM_TEST_TLV(environment.temperature, tlv_temperature))
	if(dangerlevel >= AIR_ALARM_RAISE_DANGER)
		return dangerlevel

	// todo: would be faster to iterate once and store the groups we care about...

	for(var/id in tlv_ids)
		var/list/tlv = tlv_ids[id]
		var/partial = environment.gas[id] * partial_pressure_factor
		dangerlevel = max(dangerlevel, AIR_ALARM_TEST_TLV(partial, tlv))
		if(dangerlevel >= AIR_ALARM_RAISE_DANGER)
			return dangerlevel

	for(var/name in tlv_groups)
		var/list/tlv = tlv_groups[name]
		var/partial = environment.moles_by_group(global.gas_data.gas_group_by_name[name]) * partial_pressure_factor
		dangerlevel = max(dangerlevel, AIR_ALARM_TEST_TLV(partial, tlv))
		if(dangerlevel >= AIR_ALARM_RAISE_DANGER)
			return dangerlevel

	return dangerlevel

/// Returns whether this air alarm thinks there is a breach, given the sensors that are available to it.
/obj/machinery/air_alarm/proc/breach_detected()
	var/turf/simulated/location = src.loc

	if(!istype(location))
		return FALSE

	if(!breach_detection)
		return FALSE

	var/datum/gas_mixture/environment = location.return_air()
	var/environment_pressure = environment.return_pressure()
	var/list/pressure_levels = tlv_pressure

	if(environment_pressure <= pressure_levels[1]) // Low pressures
		switch(mode)
			if(AIR_ALARM_MODE_CYCLE)
				return FALSE
			if(AIR_ALARM_MODE_PANIC)
				return FALSE
			if(AIR_ALARM_MODE_SIPHON)
				return FALSE
			if(AIR_ALARM_MODE_REPLACE)
				return FALSE
		return TRUE
	return FALSE

/obj/machinery/air_alarm/proc/master_is_operating()
	return alarm_area && alarm_area.master_air_alarm && !(alarm_area.master_air_alarm.machine_stat & (NOPOWER | BROKEN))

/obj/machinery/air_alarm/proc/elect_master(exclude_self = FALSE)
	for(var/obj/machinery/air_alarm/AA in alarm_area)
		if(exclude_self && AA == src)
			continue
		if(!(AA.machine_stat & (NOPOWER|BROKEN)))
			alarm_area.master_air_alarm = AA
			return TRUE
	return FALSE

/obj/machinery/air_alarm/setDir(ndir)
	. = ..()
	base_pixel_x = 0
	base_pixel_y = 0
	var/turf/T = get_step(get_turf(src), turn(dir, 180))
	if(istype(T) && T.density)
		switch(dir)
			if(NORTH)
				base_pixel_y = -21
			if(SOUTH)
				base_pixel_y = 21
			if(WEST)
				base_pixel_x = 21
			if(EAST)
				base_pixel_x = -21
	reset_pixel_offsets()

/obj/machinery/air_alarm/update_icon()
	cut_overlays()

	if(panel_open)
		icon_state = "alarmx"
		set_light(0)
		//set_light_on(FALSE)
		return
	if((machine_stat & (NOPOWER|BROKEN)) || shorted)
		icon_state = "alarmp"
		set_light(0)
		//set_light_on(FALSE)
		return

	var/icon_level = danger_level
	if(alarm_area?.atmosalm)
		icon_level = max(icon_level, 1)	//if there's an atmos alarm but everything is okay locally, no need to go past yellow

	var/new_color = null
	switch(icon_level)
		if(0)
			icon_state = "alarm0"
			//add_overlay(mutable_appearance(icon, "alarm_ov0"))
			//add_overlay(emissive_appearance(icon, "alarm_ov0"))
			new_color = "#03A728"
		if(1)
			icon_state = "alarm2" //yes, alarm2 is yellow alarm
			//add_overlay(mutable_appearance(icon, "alarm_ov2"))
			//add_overlay(emissive_appearance(icon, "alarm_ov2"))
			new_color = "#EC8B2F"
		if(2)
			icon_state = "alarm1"
			//add_overlay(mutable_appearance(icon, "alarm_ov1"))
			//add_overlay(emissive_appearance(icon, "alarm_ov1"))
			new_color = "#DA0205"

	set_light(l_range = 2, l_power = 0.25, l_color = new_color)
	//set_light_on(TRUE)

/obj/machinery/air_alarm/receive_signal(datum/signal/signal)
	if(machine_stat & (NOPOWER|BROKEN))
		return
	if(alarm_area.master_air_alarm != src)
		if(master_is_operating())
			return
		elect_master()
		if(alarm_area.master_air_alarm != src)
			return
	if(!signal || signal.encryption)
		return
	var/id_tag = signal.data["tag"]
	if(!id_tag)
		return
	if(signal.data["area"] != area_uid)
		return
	if(signal.data["sigtype"] != "status")
		return

	SStgui.update_uis(src)

/obj/machinery/air_alarm/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = radio_controller.add_object(src, frequency, RADIO_TO_AIRALARM)

/obj/machinery/air_alarm/proc/send_signal(var/target, var/list/command)//sends signal 'command' to 'target'. Returns 0 if no radio connection, 1 otherwise
	if(!radio_connection)
		return 0

	var/datum/signal/signal = new
	signal.transmission_method = TRANSMISSION_RADIO //radio signal
	signal.source = src

	signal.data = command
	signal.data["tag"] = target
	signal.data["sigtype"] = "command"

	radio_connection.post_signal(src, signal, RADIO_FROM_AIRALARM)
//			TO_WORLD("Signal [command] Broadcasted to [target]")

	return 1

/obj/machinery/air_alarm/proc/apply_mode(mode)
	// set our mode
	src.mode = mode
	// legacy: propagate mode to other air alarms in the area
	//TODO: make it so that players can choose between applying the new mode to the room they are in (related area) vs the entire alarm area
	for(var/obj/machinery/air_alarm/AA in alarm_area)
		AA.mode = mode

	switch(mode)
		if(AIR_ALARM_MODE_OFF)
			for(var/obj/machinery/atmospherics/component/unary/vent_pump/pump as anything in registered_area.vent_pumps)
				if(!pump.controllable_from_alarm || !pump.environmental)
					continue
				send_signal(pump.id_tag, list("hard_reset" = TRUE, "power" = FALSE))
			for(var/obj/machinery/atmospherics/component/unary/vent_scrubber/scrubber as anything in registered_area.vent_scrubbers)
				if(!scrubber.controllable_from_alarm || !scrubber.environmental)
					continue
				send_signal(scrubber.id_tag, list("hard_reset" = TRUE, "power" = FALSE))
		if(AIR_ALARM_MODE_SCRUB)
			for(var/obj/machinery/atmospherics/component/unary/vent_pump/pump as anything in registered_area.vent_pumps)
				if(!pump.controllable_from_alarm || !pump.environmental)
					continue
				send_signal(pump.id_tag, list("hard_reset" = TRUE, "power" = TRUE))
			for(var/obj/machinery/atmospherics/component/unary/vent_scrubber/scrubber as anything in registered_area.vent_scrubbers)
				if(!scrubber.controllable_from_alarm || !scrubber.environmental)
					continue
				send_signal(scrubber.id_tag, list("hard_reset" = TRUE, "power" = TRUE))
		if(AIR_ALARM_MODE_REPLACE)
			for(var/obj/machinery/atmospherics/component/unary/vent_pump/pump as anything in registered_area.vent_pumps)
				if(!pump.controllable_from_alarm || !pump.environmental)
					continue
				send_signal(pump.id_tag, list("hard_reset" = TRUE, "power" = TRUE))
			for(var/obj/machinery/atmospherics/component/unary/vent_scrubber/scrubber as anything in registered_area.vent_scrubbers)
				if(!scrubber.controllable_from_alarm || !scrubber.environmental)
					continue
				send_signal(scrubber.id_tag, list("hard_reset" = TRUE, "power" = TRUE, "siphon" = TRUE))
		if(AIR_ALARM_MODE_SIPHON, AIR_ALARM_MODE_CYCLE)
			for(var/obj/machinery/atmospherics/component/unary/vent_pump/pump as anything in registered_area.vent_pumps)
				if(!pump.controllable_from_alarm || !pump.environmental)
					continue
				send_signal(pump.id_tag, list("hard_reset" = TRUE, "power" = FALSE))
			for(var/obj/machinery/atmospherics/component/unary/vent_scrubber/scrubber as anything in registered_area.vent_scrubbers)
				if(!scrubber.controllable_from_alarm || !scrubber.environmental)
					continue
				send_signal(scrubber.id_tag, list("hard_reset" = TRUE, "power" = TRUE, "siphon" = TRUE))
		if(AIR_ALARM_MODE_PANIC)
			for(var/obj/machinery/atmospherics/component/unary/vent_pump/pump as anything in registered_area.vent_pumps)
				if(!pump.controllable_from_alarm || !pump.environmental)
					continue
				send_signal(pump.id_tag, list("hard_reset" = TRUE, "power" = FALSE))
			for(var/obj/machinery/atmospherics/component/unary/vent_scrubber/scrubber as anything in registered_area.vent_scrubbers)
				if(!scrubber.controllable_from_alarm || !scrubber.environmental)
					continue
				send_signal(scrubber.id_tag, list("hard_reset" = TRUE, "power" = TRUE, "siphon" = TRUE, "expand" = TRUE))
		if(AIR_ALARM_MODE_CONTAMINATED)
			for(var/obj/machinery/atmospherics/component/unary/vent_pump/pump as anything in registered_area.vent_pumps)
				if(!pump.controllable_from_alarm || !pump.environmental)
					continue
				send_signal(pump.id_tag, list("hard_reset" = TRUE))
			for(var/obj/machinery/atmospherics/component/unary/vent_scrubber/scrubber as anything in registered_area.vent_scrubbers)
				if(!scrubber.controllable_from_alarm || !scrubber.environmental)
					continue
				send_signal(scrubber.id_tag, list("hard_reset" = TRUE, "power" = TRUE, "expand" = TRUE))
		if(AIR_ALARM_MODE_FILL)
			for(var/obj/machinery/atmospherics/component/unary/vent_pump/pump as anything in registered_area.vent_pumps)
				if(!pump.controllable_from_alarm || !pump.environmental)
					continue
				send_signal(pump.id_tag, list("hard_reset" = TRUE))
			for(var/obj/machinery/atmospherics/component/unary/vent_scrubber/scrubber as anything in registered_area.vent_scrubbers)
				if(!scrubber.controllable_from_alarm || !scrubber.environmental)
					continue
				send_signal(scrubber.id_tag, list("hard_reset" = TRUE, "power" = FALSE))

/obj/machinery/air_alarm/proc/apply_danger_level(var/new_danger_level)
	if(report_danger_level && alarm_area.atmosalert(new_danger_level, src))
		post_alert(new_danger_level)

	update_icon()

/obj/machinery/air_alarm/proc/post_alert(alert_level)
	var/datum/radio_frequency/frequency = radio_controller.return_frequency(alarm_frequency)
	if(!frequency)
		return

	var/datum/signal/alert_signal = new
	alert_signal.source = src
	alert_signal.transmission_method = TRANSMISSION_RADIO
	alert_signal.data["zone"] = alarm_area.name
	alert_signal.data["type"] = "Atmospheric"

	if(alert_level==2)
		alert_signal.data["alert"] = "severe"
	else if(alert_level==1)
		alert_signal.data["alert"] = "minor"
	else if(alert_level==0)
		alert_signal.data["alert"] = "clear"

	frequency.post_signal(src, alert_signal)

/obj/machinery/air_alarm/attack_ai(mob/user)
	ui_interact(user)

/obj/machinery/air_alarm/attack_hand(mob/user, list/params)
	. = ..()
	if(.)
		return
	return interact(user)

/obj/machinery/air_alarm/interact(mob/user)
	ui_interact(user)
	wires.Interact(user)

/obj/machinery/air_alarm/ui_status(mob/user)
	if(isAI(user) && aidisabled)
		to_chat(user, "AI control has been disabled.")
	else if(!shorted)
		return ..()
	return UI_CLOSE

/obj/machinery/air_alarm/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui, datum/ui_state/state)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AirAlarm", name, parent_ui)
		if(state)
			ui.set_state(state)
		ui.open()

/obj/machinery/air_alarm/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	var/datum/gas_mixture/environment = loc.return_air()
	.["environment"] = environment.tgui_analyzer_scan(GAS_GROUP_REAGENT | GAS_GROUP_UNKNOWN)
	// todo: static data with event hooks for updates for these two
	var/list/vents = list()
	var/list/scrubbers = list()
	for(var/obj/machinery/atmospherics/component/unary/vent_pump/pump as anything in registered_area.vent_pumps)
		var/list/returned = pump.ui_vent_data()
		returned["name"] = pump.name
		vents[pump.id_tag] = returned
	for(var/obj/machinery/atmospherics/component/unary/vent_scrubber/scrubber as anything in registered_area.vent_scrubbers)
		var/list/returned = scrubber.ui_scrubber_data()
		returned["name"] = scrubber.name
		scrubbers[scrubber.id_tag] = returned
	.["vents"] = vents
	.["scrubbers"] = scrubbers
	.["mode"] = mode

	//! legacy below
	var/list/data = list(
		"locked" = locked,
		"siliconUser" = issilicon(user),
		"remoteUser" = !!ui?.parent_ui,
		"danger_level" = danger_level,
		"target_temperature" = "[target_temperature - T0C]C",
		"rcon" = rcon_setting,
	)
	var/area/A = get_area(src)
	data["atmos_alarm"] = A?.atmosalm
	data["fire_alarm"] = A?.fire
	. += data
	//! end

/obj/machinery/air_alarm/ui_static_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	.["gasContext"] = global.gas_data.tgui_gas_context()
	.["gasTLV"] = tlv_ids
	.["groupTLV"] = tlv_groups
	.["pressureTLV"] = tlv_pressure
	.["temperatureTLV"] = tlv_temperature

/obj/machinery/air_alarm/proc/push_ui_tlv()
	var/list/data = list()
	data["gasTLV"] = tlv_ids
	data["groupTLV"] = tlv_groups
	data["pressureTLV"] = tlv_pressure
	data["temperatureTLV"] = tlv_temperature
	push_ui_data(data = data)

/obj/machinery/air_alarm/ui_act(action, params, datum/tgui/ui)
	. = ..()
	if(.)
		return

	// unlocked actions
	switch(action)
		if("rcon")
			//! warning: legacy
			var/attempted_rcon_setting = text2num(params["rcon"])
			switch(attempted_rcon_setting)
				if(RCON_NO)
					rcon_setting = RCON_NO
				if(RCON_AUTO)
					rcon_setting = RCON_AUTO
				if(RCON_YES)
					rcon_setting = RCON_YES
			return TRUE
		if("temperature")
			//! warning: legacy
			var/list/selected = tlv_temperature
			var/max_temperature = min(selected[3] - T0C, MAX_TEMPERATURE)
			var/min_temperature = max(selected[2] - T0C, MIN_TEMPERATURE)
			var/input_temperature = tgui_input_number(usr, "What temperature would you like the system to mantain? (Capped between [min_temperature] and [max_temperature]C)", "Thermostat Controls", (target_temperature - T0C), max_temperature, min_temperature)
			if(isnum(input_temperature))
				if(input_temperature > max_temperature || input_temperature < min_temperature)
					to_chat(usr, "Temperature must be between [min_temperature]C and [max_temperature]C")
				else
					target_temperature = input_temperature + T0C
			return TRUE

	// Account for remote users here.
	// Yes, this is kinda snowflaky; however, I would argue it would be far more snowflakey
	// to include "custom hrefs" and all the other bullshit that nano states have just for the
	// like, two UIs, that want remote access to other UIs.
	//! warning: legacy
	if((locked && !issilicon(usr) && !istype(ui.state, /datum/ui_state/air_alarm_remote)) || (issilicon(usr) && aidisabled))
		return

	// locked actions
	switch(action)
		if("vent")
			var/id = params["id"]
			var/obj/machinery/atmospherics/component/unary/vent_pump/machine = registered_area.vent_pump_by_id(id)
			if(isnull(machine) || !machine.controllable_from_alarm)
				return TRUE
			var/command = params["command"]
			var/target = params["target"]
			switch(command)
				if("direction")
					send_signal(id, list("direction" = !machine.pump_direction))
				if("internalPressure")
					send_signal(id, list("set_internal_pressure" = text2num(target)))
				if("externalPressure")
					send_signal(id, list("set_external_pressure" = text2num(target)))
				if("internalToggle")
					send_signal(id, list("checks_toggle" = ATMOS_VENT_CHECK_INTERNAL))
				if("externalToggle")
					send_signal(id, list("checks_toggle" = ATMOS_VENT_CHECK_EXTERNAL))
				if("power")
					send_signal(id, list("power" = !machine.use_power))
			return TRUE
		if("scrubber")
			var/id = params["id"]
			var/obj/machinery/atmospherics/component/unary/vent_scrubber/machine = registered_area.vent_scrubber_by_id(id)
			if(isnull(machine) || !machine.controllable_from_alarm)
				return TRUE
			var/command = params["command"]
			var/target = params["target"]
			switch(command)
				if("siphon")
					send_signal(id, list("siphon" = !machine.siphoning))
				if("gasID")
					send_signal(id, list("scrub_ids_toggle" = list(target)))
				if("gasGroup")
					send_signal(id, list("scrub_groups_toggle" = text2num(target)))
				if("highPower")
					send_signal(id, list("expand" = !machine.expanded))
				if("power")
					send_signal(id, list("power" = !machine.use_power))
			return TRUE
		if("mode")
			var/mode = params["mode"]
			apply_mode(mode)
			return TRUE
		if("tlv")
			var/entry = params["entry"]
			var/index = text2num(params["index"]) + 1
			if((index < AIR_ALARM_TLV_INDEX_MIN) || (index > AIR_ALARM_TLV_INDEX_MAX))
				return TRUE
			var/val = clamp(0, text2num(params["val"]), 1000000)
			var/list/target
			switch(entry)
				if("pressure")
					target = tlv_pressure
				if("temperature")
					target = tlv_temperature
				else
					var/group = global.gas_data.gas_group_by_name[entry]
					if(group)
						target = tlv_groups[entry]
					else
						target = tlv_ids[entry]
			if(isnull(target))
				return TRUE
			target[index] = val
			clamp_tlv_list(target, index)
			push_ui_tlv()
			return TRUE
		if("alarm")
			//! warning: legacy
			if(alarm_area.atmosalert(2, src))
				apply_danger_level(2)
			return TRUE
		if("reset")
			//! warning: legacy
			atmos_reset()
			return TRUE
		if("lock")
			//! warning: legacy
			if(issilicon(usr) && !wires.is_cut(WIRE_IDSCAN))
				locked = !locked
			return TRUE

/**
 * clamps tlv to be sensical
 *
 * source_indx is the one the user / or something else is changing; rest will be updated to make sense with it.
 */
/obj/machinery/air_alarm/proc/clamp_tlv_list(list/tlv, source_index)
	for(var/i in AIR_ALARM_TLV_INDEX_MIN to (source_index - 1))
		if(tlv[i] > tlv[source_index])
			tlv[i] = tlv[source_index]
	for(var/i in (source_index + 1) to AIR_ALARM_TLV_INDEX_MAX)
		if(tlv[i] < tlv[source_index])
			tlv[i] = tlv[source_index]

/obj/machinery/air_alarm/proc/atmos_reset()
	if(alarm_area.atmosalert(0, src))
		apply_danger_level(0)
	update_icon()

/obj/machinery/air_alarm/attackby(obj/item/W as obj, mob/user as mob)
	add_fingerprint(user)
	if(alarm_deconstruction_screwdriver(user, W))
		return
	if(alarm_deconstruction_wirecutters(user, W))
		return

	if(istype(W, /obj/item/card/id) || istype(W, /obj/item/pda))// trying to unlock the interface with an ID card
		togglelock()
	return ..()

/obj/machinery/air_alarm/verb/togglelock(mob/user as mob)
	if(machine_stat & (NOPOWER|BROKEN))
		to_chat(user, "It does nothing.")
		return
	else
		if(allowed(usr) && !wires.is_cut(WIRE_IDSCAN))
			locked = !locked
			to_chat(user, SPAN_NOTICE("You [locked ? "lock" : "unlock"] the Air Alarm interface."))
		else
			to_chat(user, SPAN_BOLDWARNING("Access denied."))
		return

/obj/machinery/air_alarm/AltClick()
	..()
	togglelock()

/obj/machinery/air_alarm/power_change()
	..()
	spawn(rand(0,15))
		update_icon()

#undef LOAD_TLV_VALUES
#undef TEST_TLV_VALUES
#undef DECLARE_TLV_VALUES

/obj/machinery/air_alarm/alarms_hidden
	alarms_hidden = TRUE

/obj/machinery/air_alarm/angled
//	icon = 'icons/obj/wall_machines_angled.dmi'

/obj/machinery/air_alarm/angled/hidden
	alarms_hidden = TRUE

/obj/machinery/air_alarm/angled/offset_airalarm()
	pixel_x = (dir & 3) ? 0 : (dir == 4 ? -21 : 21)
	pixel_y = (dir & 3) ? (dir == 1 ? -18 : 20) : 0

/obj/machinery/air_alarm/freezer
	target_temperature = T0C - 13.15 // Chilly freezer room

/obj/machinery/air_alarm/freezer/create_tlv()
	if(isnull(tlv_temperature))
		tlv_temperature = list(T0C - 40, T0C - 20, T0C + 40, T0C + 60)
	return ..()

/obj/machinery/air_alarm/monitor
	report_danger_level = 0
	breach_detection = 0

/obj/machinery/air_alarm/nobreach
	breach_detection = 0

/obj/machinery/air_alarm/server/Initialize(mapload)
	. = ..()
	req_access = list(ACCESS_SCIENCE_RD, ACCESS_ENGINEERING_ATMOS, ACCESS_ENGINEERING_ENGINE)
	setDir(dir)
