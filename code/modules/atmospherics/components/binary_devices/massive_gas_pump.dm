/**
 *  Massive gas pumps are wired, clunky machines that can use a dynamic amount of power to
 *  do the job of normal gas pumps
 */
#define MAX_POWER_FOR_MASSIVE 100000000
/obj/machinery/atmospherics/component/binary/massive_gas_pump
	name = "High performance gas pump"


	use_power = USE_POWER_OFF
	idle_power_usage = 150		//internal circuitry, friction losses and stuff
	power_rating = 0			//7500 W ~ 10 HP
	var/target_pressure = ONE_ATMOSPHERE


	var/max_pressure_setting = 15000	//kPa

	icon = 'icons/obj/machines/massive_pumps.dmi'
	icon_state = "pump"
	pipe_flags = PIPING_DEFAULT_LAYER_ONLY|PIPING_ONE_PER_TURF
	anchored = 1
	density = 1
	circuit = /obj/item/circuitboard/massive_gas_pump

	var/power_level = MAX_POWER_FOR_MASSIVE//So we can limit the power we work with and
	//dont just have a stupid pump that drains all power

	var/obj/machinery/power/powersupply/power_machine = null//for funky massive power machines
	//if its not null the machine attempts to draw from the grid the power machinery is connected to
	//see examples in the file "code\modules\atmospherics\components\binary_devices\massive_gas_pump.dm"

/obj/machinery/atmospherics/component/binary/massive_gas_pump/Initialize(mapload)
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

/obj/machinery/atmospherics/component/binary/massive_gas_pump/Destroy()
	. = ..()
	qdel(power_machine)

/obj/machinery/atmospherics/component/binary/massive_gas_pump/process(delta_time)
	if(!network1 || !network2)
		build_network()//built networks if we are missing them
		network1?.update = 1
		network2?.update = 1
		last_flow_rate = last_power_draw = 0
		return
	if((machine_stat & (NOPOWER|BROKEN)) || !use_power)
		last_flow_rate = last_power_draw = 0
		return

	if(!power_machine || !power_machine.powernet)
		if(!power_machine || !power_machine.connect_to_network())//returns 0 if it fails to find a
			last_flow_rate = last_power_draw = 0
			return//make sure we are connected to a powernet

	power_rating = power_machine.surplus() * 1000 //update power rateing to what ever is avaiable
	power_rating = clamp(power_rating, 0, power_level)

	if(power_rating <= 0)
		last_flow_rate = last_power_draw = 0
		return//no point in continuing if we dont have any power

	var/power_draw = -1
	var/pressure_delta = target_pressure - air2.return_pressure()

	if(pressure_delta > 0.01 && air1.temperature > 0)
		//Figure out how much gas to transfer to meet the target pressure.
		var/transfer_moles = calculate_transfer_moles(air1, air2, pressure_delta, (network2)? network2.volume : 0)
		power_draw = pump_gas(src, air1, air2, transfer_moles, power_rating)

	if (power_draw >= 0)
		last_power_draw = power_draw

		power_machine.draw_power(power_draw * 0.001)
		if(network1)
			network1.update = 1

		if(network2)
			network2.update = 1

	return 1

/obj/machinery/atmospherics/component/binary/massive_gas_pump/attackby(obj/item/W as obj, mob/user as mob)
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

/obj/machinery/atmospherics/component/binary/massive_gas_pump/update_icon()
	if(inoperable() || !anchored || !power_machine.powernet)
		icon_state = "pump"
	else if(use_power)
		switch(last_power_draw)
			if(1 to (1 MEGAWATTS))
				icon_state = "pump_1"
			if((1 MEGAWATTS) to (10 MEGAWATTS))
				icon_state = "pump_2"
			if((10 MEGAWATTS) to MAX_POWER_FOR_MASSIVE)
				icon_state = "pump_3"
	else
		icon_state = "pump"
	return TRUE

/obj/machinery/atmospherics/component/binary/massive_gas_pump/ui_interact(mob/user, datum/tgui/ui)
	if(machine_stat & (BROKEN|NOPOWER))
		return FALSE
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MassiveGasPump", name)
		ui.open()

//This is the data which will be sent to the ui
/obj/machinery/atmospherics/component/binary/massive_gas_pump/ui_data(mob/user)
	var/list/data = list()

	data = list(
		"on" = use_power,
		"pressure_set" = round(target_pressure*100),
		"max_pressure" = max_pressure_setting,
		"power_level" = power_level,
		"last_flow_rate" = round(last_flow_rate*10),
		"last_power_draw" = round(last_power_draw),
		"max_power_draw" = MAX_POWER_FOR_MASSIVE,
	)

	return data

/obj/machinery/atmospherics/component/binary/massive_gas_pump/attack_hand(mob/user)
	if(..())
		return
	add_fingerprint(usr)
	if(!allowed(user))
		to_chat(user, SPAN_WARNING("Access denied."))
		return
	ui_interact(user)

/obj/machinery/atmospherics/component/binary/massive_gas_pump/ui_act(action, params)
	if(..())
		return TRUE

	switch(action)
		if("power")
			update_use_power(!use_power)
			. = TRUE
		if("set_press")
			var/press = params["press"]
			switch(press)
				if("min")
					target_pressure = 0
				if("max")
					target_pressure = max_pressure_setting
				if("set")
					var/new_pressure = input(usr,"Enter new output pressure (0-[max_pressure_setting]kPa)","Pressure control",src.target_pressure) as num
					src.target_pressure = clamp( new_pressure, 0,  max_pressure_setting)
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
