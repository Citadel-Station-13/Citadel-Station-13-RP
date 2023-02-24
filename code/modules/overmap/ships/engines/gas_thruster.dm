//Gas nozzle engine
/datum/ship_engine/gas_thruster
	name = "gas thruster"
	var/obj/machinery/atmospherics/component/unary/engine/nozzle

/datum/ship_engine/gas_thruster/New(var/obj/machinery/_holder)
	..()
	nozzle = _holder

/datum/ship_engine/gas_thruster/Destroy()
	nozzle = null
	. = ..()

/datum/ship_engine/gas_thruster/get_status()
	return nozzle.get_status()

/datum/ship_engine/gas_thruster/get_thrust()
	return nozzle.get_thrust()

/datum/ship_engine/gas_thruster/burn()
	return nozzle.burn()

/datum/ship_engine/gas_thruster/set_thrust_limit(var/new_limit)
	nozzle.thrust_limit = new_limit

/datum/ship_engine/gas_thruster/get_thrust_limit()
	return nozzle.thrust_limit

/datum/ship_engine/gas_thruster/is_on()
	if(nozzle.use_power && nozzle.operable())
		if(nozzle.next_on > world.time)
			return -1
		else
			return 1
	return 0

/datum/ship_engine/gas_thruster/toggle()
	if(nozzle.use_power)
		nozzle.update_use_power(USE_POWER_OFF)
	else
		if(nozzle.blockage)
			if(nozzle.check_blockage())
				return
		nozzle.update_use_power(USE_POWER_IDLE)
		if(nozzle.machine_stat & NOPOWER)//try again
			nozzle.power_change()
		if(nozzle.is_on())//if everything is in working order, start booting!
			nozzle.next_on = world.time + nozzle.boot_time

/datum/ship_engine/gas_thruster/can_burn()
	return nozzle.is_on() && nozzle.check_fuel()

//Actual thermal nozzle engine object

/obj/machinery/atmospherics/component/unary/engine
	name = "rocket nozzle"
	desc = "Simple rocket nozzle, expelling gas at hypersonic velocities to propell the ship."
	icon = 'icons/turf/shuttle_parts.dmi'
	icon_state = "nozzle"
	opacity = TRUE
	density = TRUE
	CanAtmosPass = ATMOS_PASS_AIR_BLOCKED
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_FUEL

	// construct_state = /singleton/machine_construction/default/panel_closed
	// maximum_component_parts = list(/obj/item/stock_parts = 6)//don't want too many, let upgraded component shine
	// uncreated_component_parts = list(/obj/item/stock_parts/power/apc/buildable = 1)

	use_power = USE_POWER_OFF
	power_channel = EQUIP
	idle_power_usage = 1000

	var/datum/ship_engine/gas_thruster/controller
	var/thrust_limit = 1		//Value between 1 and 0 to limit the resulting thrust
	var/volume_per_burn = 15	//20 litres(with bin)
	var/charge_per_burn = 3600
	var/boot_time = 35
	var/next_on
	var/blockage
	var/linked = FALSE

/obj/machinery/atmospherics/component/unary/engine/Initialize(mapload)
	. = ..()
	controller = new(src)
	update_nearby_tiles()
	SSshuttle.unary_engines += src
	if(SSshuttle.initialized)
		link_to_ship()

/obj/machinery/atmospherics/component/unary/engine/Destroy()
	QDEL_NULL(controller)
	SSshuttle.unary_engines -= src
	update_nearby_tiles()
	. = ..()

/obj/machinery/atmospherics/component/unary/engine/proc/link_to_ship()
	for(var/ship in SSshuttle.ships)
		var/obj/effect/overmap/visitable/ship/S = ship
		if(S.check_ownership(src))
			S.engines |= controller
			if(dir != S.fore_dir)
				set_broken(TRUE)
			else
				set_broken(FALSE)
			linked = TRUE

/obj/machinery/atmospherics/component/unary/engine/proc/get_status()
	. = list()
	.+= "Location: [get_area(src)]."
	if(machine_stat & NOPOWER)
		.+= list(list("Insufficient power to operate.", "bad"))
	if(!check_fuel())
		.+= list(list("Insufficient fuel for a burn.", "bad"))
	if(machine_stat & BROKEN)
		.+= list(list("Inoperable engine configuration.", "bad"))
	if(blockage)
		.+= list(list("Obstruction of airflow detected.", "bad"))

	.+= "Propellant total mass: [round(air_contents.get_mass(),0.01)] kg."
	.+= "Propellant used per burn: [round(air_contents.get_mass() * volume_per_burn * thrust_limit / air_contents.volume,0.01)] kg."
	.+= "Propellant pressure: [round(air_contents.return_pressure()/1000,0.1)] MPa."

/obj/machinery/atmospherics/component/unary/engine/legacy_ex_act()
	return

/obj/machinery/atmospherics/component/unary/engine/power_change()
	. = ..()
	if(machine_stat & NOPOWER)
		update_use_power(USE_POWER_OFF)

/obj/machinery/atmospherics/component/unary/engine/proc/is_on()
	return use_power && operable() && (next_on < world.time)

/obj/machinery/atmospherics/component/unary/engine/proc/check_fuel()
	return air_contents.total_moles > 5 // minimum fuel usage is five moles, for EXTREMELY hot mix or super low pressure

/obj/machinery/atmospherics/component/unary/engine/proc/get_thrust()
	if(!is_on() || !check_fuel())
		return 0
	var/used_part = volume_per_burn * thrust_limit / air_contents.volume
	. = calculate_thrust(air_contents, used_part)
	return

/obj/machinery/atmospherics/component/unary/engine/proc/check_blockage()
	var/exhaust_dir = REVERSE_DIR(dir)
	var/turf/T = get_step(src, exhaust_dir)		// turf we're on is blocked by ourselves
	while(!(isspaceturf(T) || (T.mz_flags & (MZ_ATMOS_BOTH))))
		var/turf/next = get_step(T, exhaust_dir)
		if(!next)
			// not found
			return TRUE
		if(T.CheckAirBlock(next) == ATMOS_PASS_AIR_BLOCKED)
			// couldn't go past
			return TRUE
	return FALSE

/obj/machinery/atmospherics/component/unary/engine/proc/burn()
	if(!is_on())
		return 0
	if(!check_fuel() || (use_power_oneoff(charge_per_burn) < charge_per_burn) || check_blockage())
		audible_message(src,"<span class='warning'>[src] coughs once and goes silent!</span>")
		update_use_power(USE_POWER_OFF)
		return 0

	var/datum/gas_mixture/removed = air_contents.remove_ratio(volume_per_burn * thrust_limit / air_contents.volume)
	if(!removed)
		return 0
	. = calculate_thrust(removed)
	playsound(src, 'sound/machines/thruster.ogg', 100 * thrust_limit, 0, world.view * 4, 0.1)
	if(network)
		network.update = 1

	var/exhaust_dir = REVERSE_DIR(dir)
	var/turf/T = get_step(src,exhaust_dir)
	if(T)
		T.assume_air(removed)
		new/obj/effect/engine_exhaust(T, exhaust_dir, air_contents.check_combustability() && air_contents.temperature >= PHORON_MINIMUM_BURN_TEMPERATURE)

/obj/machinery/atmospherics/component/unary/engine/proc/calculate_thrust(datum/gas_mixture/propellant, used_part = 1)
	return round((propellant.get_mass() * used_part * (air_contents.return_pressure()/200) ** 0.5) ** 0.85,0.1)

/obj/machinery/atmospherics/component/unary/engine/RefreshParts()
	..()
	//allows them to upgrade the max limit of fuel intake (which only gives diminishing returns) for increase in max thrust but massive reduction in fuel economy
	var/bin_upgrade = 5 * clamp(total_component_rating_of_type(/obj/item/stock_parts/matter_bin), 0, 6)//5 litre per rank
	volume_per_burn = bin_upgrade ? initial(volume_per_burn) + bin_upgrade : 2 //Penalty missing part: 10% fuel use, no thrust
	boot_time = bin_upgrade ? initial(boot_time) - bin_upgrade : initial(boot_time) * 2
	//energy cost - thb all of this is to limit the use of back up batteries
	var/energy_upgrade = clamp(total_component_rating_of_type(/obj/item/stock_parts/capacitor), 0.1, 6)
	charge_per_burn = initial(charge_per_burn) / energy_upgrade
	change_power_consumption(initial(idle_power_usage) / energy_upgrade, USE_POWER_IDLE)

//Exhaust effect
/obj/effect/engine_exhaust
	name = "engine exhaust"
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"
	light_color = "#ed9200"
	anchored = 1

/obj/effect/engine_exhaust/Initialize(mapload, ndir, flame)
	. = ..(mapload)
	if(flame)
		icon_state = "exhaust"
		var/turf/T = loc
		if(istype(T))
			T.hotspot_expose(1000,125)
		set_light(0.5, 3)
	setDir(ndir)
	QDEL_IN(src, 20)

/obj/item/circuitboard/unary_atmos/engine //why don't we move this elsewhere?
	name = T_BOARD("gas thruster")
	icon_state = "mcontroller"
	build_path = /obj/machinery/atmospherics/component/unary/engine
	origin_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 2)
	req_components = list(
		/obj/item/stack/cable_coil = 30,
		/obj/item/pipe = 2,
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/capacitor = 2)

// Not Implemented - Variant that pulls power from cables.  Too complicated without bay's power components.
// /obj/machinery/atmospherics/component/unary/engine/terminal
// 	base_type = /obj/machinery/atmospherics/component/unary/engine
// 	stock_part_presets = list(/singleton/stock_part_preset/terminal_setup)
// 	uncreated_component_parts = list(/obj/item/stock_parts/power/terminal/buildable = 1)
