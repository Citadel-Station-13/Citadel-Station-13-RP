#define CAN_DEFAULT_RELEASE_PRESSURE (ONE_ATMOSPHERE)

/obj/machinery/portable_atmospherics/canister
	name = "canister"
	icon = 'icons/modules/atmospherics/portable/canister.dmi'
	icon_state = "yellow"
	density = 1
	interaction_flags_machine = INTERACT_MACHINE_OFFLINE
	integrity = 300
	integrity_max = 300
	integrity_failure = 100
	w_class = WEIGHT_CLASS_HUGE
	materials_base = list(
		/datum/prototype/material/steel::id = 5 * /datum/prototype/material/steel::sheet_amount,
	)
	worth_intrinsic = 50

	layer = TABLE_LAYER	// Above catwalks, hopefully below other things

	///Is the valve open?
	var/valve_open = FALSE
	///Used to log opening and closing of the valve, available on VV
	var/release_log = ""
	///How much the canister should be filled (recommended from 0 to 1)
	//var/filled = 0.5
	///Stores the path of the gas for mapped canisters
	//var/gas_type
	///Player controlled var that set the release pressure of the canister
	var/release_pressure = ONE_ATMOSPHERE
	///Maximum pressure allowed for release_pressure var
	var/can_max_release_pressure = (ONE_ATMOSPHERE * 10)
	///Minimum pressure allower for release_pressure var
	var/can_min_release_pressure = (ONE_ATMOSPHERE * 0.1)
	///Max amount of heat allowed inside of the canister before it starts to melt (different tiers have different limits)
	var/heat_limit = 5000
	///Max amount of pressure allowed inside of the canister before it starts to break (different tiers have different limits)
	var/pressure_limit = 46000

	var/release_flow_rate = ATMOS_DEFAULT_VOLUME_PUMP //in L/s
	var/canister_color = "yellow"
	var/can_label = TRUE
	start_pressure = 45 * ONE_ATMOSPHERE
	pressure_resistance = 7 * ONE_ATMOSPHERE
	var/temperature_resistance = 1000 + T0C
	volume = 1000
	use_power = USE_POWER_OFF

/obj/machinery/portable_atmospherics/canister/get_containing_worth(flags)
	. = ..()
	var/list/gas = air_contents.gas
	for(var/id in gas)
		var/datum/gas/gas_datum = global.gas_data.gases[id]
		. += gas_datum.worth * gas[id]

/obj/machinery/portable_atmospherics/canister/atom_break()
	. = ..()
	update_icon()

/obj/machinery/portable_atmospherics/canister/atom_fix()
	. = ..()
	update_icon()

/obj/machinery/portable_atmospherics/canister/update_icon()
	cut_overlays()
	icon_state = "[base_icon_state || initial(icon_state)][atom_flags & ATOM_BROKEN ? "-broken" : ""]"
	. = ..()
	if(atom_flags & ATOM_BROKEN)
		return

	if(holding)
		add_overlay("open")
	if(connected_port)
		add_overlay("connector")

	var/pressure = air_contents.return_pressure()
	if(pressure < MINIMUM_MEANINGFUL_MOLES_DELTA)
		// no overlay
	else if(pressure < 10)
		add_overlay("gauge-0")
	else if(pressure < ONE_ATMOSPHERE)
		add_overlay("gauge-1")
	else if(pressure < 15 * ONE_ATMOSPHERE)
		add_overlay("gauge-2")
	else
		add_overlay("gauge-3")

// todo: generic fire
/obj/machinery/portable_atmospherics/canister/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > temperature_resistance)
		inflict_atom_damage(5)

/obj/machinery/portable_atmospherics/canister/drop_products(method, atom/where)
	. = ..()
	new /obj/item/stack/material/steel(drop_location(), method == ATOM_DECONSTRUCT_DISASSEMBLED? 10 : 7)

/obj/machinery/portable_atmospherics/canister/atom_break()
	. = ..()
	loc.assume_air(air_contents)
	set_density(FALSE)
	playsound(src, 'sound/effects/spray.ogg', 20, 1)
	if(holding)
		holding.forceMove(drop_location())
		holding = null

/obj/machinery/portable_atmospherics/canister/process(delta_time)
	if (atom_flags & ATOM_BROKEN)
		return

	..()

	if(valve_open)
		var/datum/gas_mixture/environment
		if(holding)
			environment = holding.air_contents
		else
			environment = loc.return_air()

		var/env_pressure = environment.return_pressure()
		var/pressure_delta = release_pressure - env_pressure

		if((air_contents.temperature > 0) && (pressure_delta > 0))
			var/transfer_moles = calculate_transfer_moles(air_contents, environment, pressure_delta)
			transfer_moles = min(transfer_moles, (release_flow_rate/air_contents.volume)*air_contents.total_moles) //flow rate limit

			var/returnval = pump_gas_passive(src, air_contents, environment, transfer_moles)
			if(returnval >= 0)
				src.update_icon()

	if(air_contents.return_pressure() < 1)
		can_label = 1
	else
		can_label = 0

	air_contents.react() //cooking up air cans - add phoron and oxygen, then heat above PHORON_MINIMUM_BURN_TEMPERATURE

/obj/machinery/portable_atmospherics/canister/return_air()
	return air_contents

/obj/machinery/portable_atmospherics/canister/attackby(var/obj/item/W as obj, var/mob/user as mob)
	if(istype(user, /mob/living/silicon/robot) && istype(W, /obj/item/tank/jetpack))
		var/datum/gas_mixture/thejetpack = W:air_contents
		var/env_pressure = thejetpack.return_pressure()
		var/pressure_delta = min(10*ONE_ATMOSPHERE - env_pressure, (air_contents.return_pressure() - env_pressure)/2)
		//Can not have a pressure delta that would cause environment pressure > tank pressure
		var/transfer_moles = 0
		if((air_contents.temperature > 0) && (pressure_delta > 0))
			transfer_moles = pressure_delta*thejetpack.volume/(air_contents.temperature * R_IDEAL_GAS_EQUATION)//Actually transfer the gas
			var/datum/gas_mixture/removed = air_contents.remove(transfer_moles)
			thejetpack.merge(removed)
			to_chat(user, "You pulse-pressurize your jetpack from the tank.")
		return CLICKCHAIN_DO_NOT_PROPAGATE

	. = ..()
	update_ui_data()

/obj/machinery/portable_atmospherics/canister/attack_ai(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/portable_atmospherics/canister/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	return src.ui_interact(user)

/obj/machinery/portable_atmospherics/canister/ui_state()
	return GLOB.physical_state

/obj/machinery/portable_atmospherics/canister/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Canister", name)
		ui.open()

/obj/machinery/portable_atmospherics/canister/ui_static_data(mob/user, datum/tgui/ui)
	return list(
		"defaultReleasePressure" = round(CAN_DEFAULT_RELEASE_PRESSURE),
		"minReleasePressure" = round(can_min_release_pressure),
		"maxReleasePressure" = round(can_max_release_pressure),
		"pressureLimit" = round(pressure_limit),
		"holdingTankLeakPressure" = round(TANK_LEAK_PRESSURE),
		"holdingTankFragPressure" = round(TANK_FRAGMENT_PRESSURE)
	)

/obj/machinery/portable_atmospherics/canister/ui_data(mob/user, datum/tgui/ui)
	. = list(
		"portConnected" = !!connected_port,
		"tankPressure" = round(air_contents.return_pressure()),
		"releasePressure" = round(release_pressure),
		"valveOpen" = !!valve_open,
		//"isPrototype" = !!prototype,
		"hasHoldingTank" = !!holding
	)
/*
	if(prototype)
		. += list(
			"restricted" = restricted,
			"timing" = timing,
			"time_left" = get_time_left(),
			"timer_set" = timer_set,
			"timer_is_not_default" = timer_set != default_timer_set,
			"timer_is_not_min" = timer_set != minimum_timer_set,
			"timer_is_not_max" = timer_set != maximum_timer_set
		)
*/
	if(holding)
		. += list(
			"holdingTank" = list(
				"name" = holding.name,
				"tankPressure" = round(holding.air_contents.return_pressure())
			)
		)

/obj/machinery/portable_atmospherics/canister/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return

	switch(action)
		if("relabel")
			if(can_label)
				var/list/colors = list(\
					"\[N2O\]" = "redws", \
					"\[N2\]" = "red", \
					"\[O2\]" = "blue", \
					"\[Phoron\]" = "orange", \
					"\[CO2\]" = "black", \
					"\[Air\]" = "grey", \
					"\[CAUTION\]" = "yellow", \
				)
				var/label = input("Choose canister label", "Gas canister") as null|anything in colors
				if(label)
					canister_color = colors[label]
					icon_state = colors[label]
					base_icon_state = icon_state
					name = "Canister: [label]"
		if("pressure")
			var/pressure = params["pressure"]
			if(pressure == "reset")
				pressure = initial(release_pressure)
				. = TRUE
			else if(pressure == "min")
				pressure = can_min_release_pressure
				. = TRUE
			else if(pressure == "max")
				pressure = can_max_release_pressure
				. = TRUE
			else if(pressure == "input")
				pressure = input("New release pressure ([can_min_release_pressure]-[can_max_release_pressure] kPa):", name, release_pressure) as num|null
				if(!isnull(pressure) && !..())
					. = TRUE
			else if(text2num(pressure) != null)
				pressure = text2num(pressure)
				. = TRUE
			if(.)
				release_pressure = clamp(round(pressure), can_min_release_pressure, can_max_release_pressure)
				investigate_log("was set to [release_pressure] kPa by [key_name(usr)].", INVESTIGATE_ATMOS)
		if("valve")
			if(valve_open)
				if(holding)
					release_log += "Valve was <b>closed</b> by [usr] ([usr.ckey]), stopping the transfer into the [holding]<br>"
				else
					release_log += "Valve was <b>closed</b> by [usr] ([usr.ckey]), stopping the transfer into the <font color='red'><b>air</b></font><br>"
			else
				if(holding)
					release_log += "Valve was <b>opened</b> by [usr] ([usr.ckey]), starting the transfer into the [holding]<br>"
				else
					release_log += "Valve was <b>opened</b> by [usr] ([usr.ckey]), starting the transfer into the <font color='red'><b>air</b></font><br>"
					log_open()
			valve_open = !valve_open
			. = TRUE
	update_appearance()

/obj/machinery/portable_atmospherics/canister/on_eject(obj/item/tank/tank, mob/user)
	if (valve_open)
		user.action_feedback(SPAN_WARNING("[src]'s valve closes automatically as you yank \the [tank] out. That was close."), src)
	valve_open = FALSE
	return ..()

/obj/machinery/portable_atmospherics/canister/nitrous_oxide
	name = "Canister: \[N2O\]"
	icon_state = "redws"
	canister_color = "redws"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/nitrogen
	name = "Canister: \[N2\]"
	icon_state = "red"
	canister_color = "red"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/oxygen
	name = "Canister: \[O2\]"
	icon_state = "blue"
	canister_color = "blue"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/oxygen/prechilled
	name = "Canister: \[O2 (Cryo)\]"

/obj/machinery/portable_atmospherics/canister/phoron
	name = "Canister \[Phoron\]"
	icon_state = "orange"
	canister_color = "orange"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/carbon_dioxide
	name = "Canister \[CO2\]"
	icon_state = "black"
	canister_color = "black"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/air
	name = "Canister \[Air\]"
	icon_state = "grey"
	canister_color = "grey"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/air/airlock
	start_pressure = 3 * ONE_ATMOSPHERE

/obj/machinery/portable_atmospherics/canister/empty/
	start_pressure = 0
	can_label = 1

/obj/machinery/portable_atmospherics/canister/empty/oxygen
	name = "Canister: \[O2\]"
	icon_state = "blue"
	canister_color = "blue"
/obj/machinery/portable_atmospherics/canister/empty/phoron
	name = "Canister \[Phoron\]"
	icon_state = "orange"
	canister_color = "orange"
/obj/machinery/portable_atmospherics/canister/empty/nitrogen
	name = "Canister \[N2\]"
	icon_state = "red"
	canister_color = "red"
/obj/machinery/portable_atmospherics/canister/empty/carbon_dioxide
	name = "Canister \[CO2\]"
	icon_state = "black"
	canister_color = "black"
/obj/machinery/portable_atmospherics/canister/empty/nitrous_oxide
	name = "Canister \[N2O\]"
	icon_state = "redws"
	canister_color = "redws"

/obj/machinery/portable_atmospherics/canister/helium
	name = "Canister \[Helium\]"

/obj/machinery/portable_atmospherics/canister/carbon_monoxide
	name = "Canister \[Carbon Monoxide\]"

/obj/machinery/portable_atmospherics/canister/methyl_bromide
	name = "Canister \[Methyl Bromide\]"

/obj/machinery/portable_atmospherics/canister/nitrodioxide
	name = "Canister \[Nitrogen Dioxide\]"

/obj/machinery/portable_atmospherics/canister/nitricoxide
	name = "Canister \[Nitric Oxide\]"

/obj/machinery/portable_atmospherics/canister/methane
	name = "Canister \[Methane\]"

/obj/machinery/portable_atmospherics/canister/argon
	name = "Canister \[Argon\]"

/obj/machinery/portable_atmospherics/canister/krypton
	name = "Canister \[Krypton\]"

/obj/machinery/portable_atmospherics/canister/neon
	name = "Canister \[Neon\]"

/obj/machinery/portable_atmospherics/canister/ammonia
	name = "Canister \[Ammonia\]"

/obj/machinery/portable_atmospherics/canister/xenon
	name = "Canister \[Xenon\]"

/obj/machinery/portable_atmospherics/canister/chlorine
	name = "Canister \[Chlorine\]"

/obj/machinery/portable_atmospherics/canister/sulfur_dioxide
	name = "Canister \[Sulfur Dioxide\]"

/obj/machinery/portable_atmospherics/canister/hydrogen
	name = "Canister \[Hydrogen\]"

/obj/machinery/portable_atmospherics/canister/tritium
	name = "Canister \[Tritium\]"

/obj/machinery/portable_atmospherics/canister/deuterium
	name = "Canister \[Deuterium\]"

/obj/machinery/portable_atmospherics/canister/phoron/Initialize(mapload)
	. = ..()
	src.air_contents.adjust_gas(GAS_ID_PHORON, MolesForPressure())
	src.update_icon()

/obj/machinery/portable_atmospherics/canister/oxygen/Initialize(mapload)
	. = ..()
	src.air_contents.adjust_gas(GAS_ID_OXYGEN, MolesForPressure())
	src.update_icon()

/obj/machinery/portable_atmospherics/canister/oxygen/prechilled/Initialize(mapload)
	. = ..()
	src.air_contents.adjust_gas(GAS_ID_OXYGEN, MolesForPressure())
	src.air_contents.temperature = 80
	src.update_icon()

/obj/machinery/portable_atmospherics/canister/nitrous_oxide/Initialize(mapload)
	. = ..()
	air_contents.adjust_gas(GAS_ID_NITROUS_OXIDE, MolesForPressure())
	src.update_icon()

/obj/machinery/portable_atmospherics/canister/helium/Initialize(mapload)
	. = ..()
	src.air_contents.adjust_gas(GAS_ID_HELIUM, MolesForPressure())
	src.update_icon()

/obj/machinery/portable_atmospherics/canister/carbon_monoxide/Initialize(mapload)
	. = ..()
	src.air_contents.adjust_gas(GAS_ID_CARBON_MONOXIDE, MolesForPressure())
	src.update_icon()

/obj/machinery/portable_atmospherics/canister/methyl_bromide/Initialize(mapload)
	. = ..()
	src.air_contents.adjust_gas(GAS_ID_METHYL_BROMIDE, MolesForPressure())
	src.update_icon()

/obj/machinery/portable_atmospherics/canister/nitrodioxide/Initialize(mapload)
	. = ..()
	src.air_contents.adjust_gas(GAS_ID_NITROGEN_DIOXIDE, MolesForPressure())
	src.update_icon()

/obj/machinery/portable_atmospherics/canister/nitricoxide/Initialize(mapload)
	. = ..()
	src.air_contents.adjust_gas(GAS_ID_NITRIC_OXIDE, MolesForPressure())
	src.update_icon()

/obj/machinery/portable_atmospherics/canister/methane/Initialize(mapload)
	. = ..()
	src.air_contents.adjust_gas(GAS_ID_METHANE, MolesForPressure())
	src.update_icon()

/obj/machinery/portable_atmospherics/canister/argon/Initialize(mapload)
	. = ..()
	src.air_contents.adjust_gas(GAS_ID_ARGON, MolesForPressure())
	src.update_icon()

/obj/machinery/portable_atmospherics/canister/krypton/Initialize(mapload)
	. = ..()
	src.air_contents.adjust_gas(GAS_ID_KRYPTON, MolesForPressure())
	src.update_icon()

/obj/machinery/portable_atmospherics/canister/neon/Initialize(mapload)
	. = ..()
	src.air_contents.adjust_gas(GAS_ID_NEON, MolesForPressure())
	src.update_icon()

/obj/machinery/portable_atmospherics/canister/ammonia/Initialize(mapload)
	. = ..()
	src.air_contents.adjust_gas(GAS_ID_AMMONIA, MolesForPressure())
	src.update_icon()

/obj/machinery/portable_atmospherics/canister/xenon/Initialize(mapload)
	. = ..()
	src.air_contents.adjust_gas(GAS_ID_XENON, MolesForPressure())
	src.update_icon()

/obj/machinery/portable_atmospherics/canister/chlorine/Initialize(mapload)
	. = ..()
	src.air_contents.adjust_gas(GAS_ID_CHLORINE, MolesForPressure())
	src.update_icon()

/obj/machinery/portable_atmospherics/canister/sulfur_dioxide/Initialize(mapload)
	. = ..()
	src.air_contents.adjust_gas(GAS_ID_SULFUR_DIOXIDE, MolesForPressure())
	src.update_icon()

/obj/machinery/portable_atmospherics/canister/hydrogen/Initialize(mapload)
	. = ..()
	src.air_contents.adjust_gas(GAS_ID_HYDROGEN, MolesForPressure())
	src.update_icon()

/obj/machinery/portable_atmospherics/canister/tritium/Initialize(mapload)
	. = ..()
	src.air_contents.adjust_gas(GAS_ID_TRITIUM, MolesForPressure())
	src.update_icon()

/obj/machinery/portable_atmospherics/canister/deuterium/Initialize(mapload)
	. = ..()
	src.air_contents.adjust_gas(GAS_ID_DEUTERIUM, MolesForPressure())
	src.update_icon()

//Dirty way to fill room with gas. However it is a bit easier to do than creating some floor/engine/n2o -rastaf0
/obj/machinery/portable_atmospherics/canister/nitrous_oxide/roomfiller/Initialize(mapload)
	. = ..()
	air_contents.gas[GAS_ID_NITROUS_OXIDE] = 9*4000
	air_contents.update_values()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/portable_atmospherics/canister/nitrous_oxide/roomfiller/LateInitialize()
	. = ..()
	var/turf/simulated/location = src.loc
	if (istype(src.loc))
		while (!location.air)
			sleep(10)
		location.assume_air(air_contents)
		air_contents = new

/obj/machinery/portable_atmospherics/canister/nitrogen/Initialize(mapload)
	. = ..()
	src.air_contents.adjust_gas(GAS_ID_NITROGEN, MolesForPressure())
	src.update_icon()

/obj/machinery/portable_atmospherics/canister/carbon_dioxide/Initialize(mapload)
	. = ..()
	src.air_contents.adjust_gas(GAS_ID_CARBON_DIOXIDE, MolesForPressure())
	src.update_icon()

/obj/machinery/portable_atmospherics/canister/air/Initialize(mapload)
	. = ..()
	var/list/air_mix = StandardAirMix()
	src.air_contents.adjust_multi(GAS_ID_OXYGEN, air_mix[GAS_ID_OXYGEN], GAS_ID_NITROGEN, air_mix[GAS_ID_NITROGEN])
	src.update_icon()

//R-UST port
// Special types used for engine setup admin verb, they contain double amount of that of normal canister.
/obj/machinery/portable_atmospherics/canister/nitrogen/engine_setup/Initialize(mapload)
	. = ..()
	src.air_contents.adjust_gas(GAS_ID_NITROGEN, MolesForPressure())
	src.update_icon()

/obj/machinery/portable_atmospherics/canister/carbon_dioxide/engine_setup/Initialize(mapload)
	. = ..()
	src.air_contents.adjust_gas(GAS_ID_CARBON_DIOXIDE, MolesForPressure())
	src.update_icon()

/obj/machinery/portable_atmospherics/canister/phoron/engine_setup/Initialize(mapload)
	. = ..()
	src.air_contents.adjust_gas(GAS_ID_PHORON, MolesForPressure())
	src.update_icon()
