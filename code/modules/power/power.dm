/**
 * these machines intrinsically have auto-linking powernet connections
 *
 * you can further customize them with when/where their powernet connections should try to attach to turf.
 */
/obj/machinery/power
	icon = 'icons/obj/power.dmi'
	anchored = TRUE
	use_power = USE_POWER_OFF
	idle_power_usage = 0
	active_power_usage = 0

	/// our powernet connection
	var/datum/wirenet_connection/power/connection
	/// connect while unanchored?
	var/connection_requires_anchored = TRUE
	#warn handling

/obj/machinery/power/Initialize(mapload)
	connection = new(src)
	auto_connect()
	return ..()

/obj/machinery/power/Destroy()
	disconnect()
	QDEL_NULL(connection)
	return ..()

/obj/machinery/power/proc/should_connect()
	return !connection_requires_anchored || anchored

/obj/machinery/power/set_anchored(anchorvalue)
	. = ..()
	auto_connect()

/obj/machinery/power/proc/auto_connect()
	#warn impl

/obj/machinery/power/proc/disconnect()
	#warn impl

/obj/machinery/power/proc/connect()
	#warn impl

/obj/machinery/power/Moved(atom/old_loc, direction, forced)
	. = ..()
	auto_connect()

/obj/machinery/power/proc/is_connected()
	return connection.is_connected()

/obj/machinery/power/proc/supply(amount)
	connection.network?.supply(amount)

/**
 * high priority non load balanced draw
 *
 * @params
 * * amount - amount in kw
 *
 * @return kw's successfully drawn
 */
/obj/machinery/power/proc/flat_draw(amount)
	if(isnull(connection.network))
		return 0
	return connection.network.flat_draw(amount)

/**
 * dynamic priority load balanced draw
 *
 * @params
 * * amount - amount in kw
 * * tier - load balancing tier
 *
 * @return kw's successfully drawn
 */
/obj/machinery/power/proc/dynamic_draw(amount, tier)
	if(isnull(connection.network))
		return 0
	return connection.network.dynamic_draw(amount, tier)

/**
 * returns everything on the same powernet
 */
/obj/machinery/power/proc/directly_connected_hosts()
	return isnull(connection.network)? lists() : connection.network.get_hosts()

/**
 * get available power on network
 *
 * this is including already used power! e.g. 1MW available with 900KW used is still 1MW. You need power_surplus() for the 100kw.
 *
 * @params
 * * kw - kilowatts needed; if specified, this returns 0 unless we have atleast that.
 */
/obj/machinery/power/proc/power_available(kw)
	#warn impl

/**
 * get surplus power on network
 *
 * this is not including already used power.
 *
 * @params
 * * kw - kilowatts needed; if specified, this returns 0 unless we have atleast that.
 */
/obj/machinery/power/proc/power_surplus(kw)
	#warn impl

/**
 * get total draw on network
 *
 * @params
 * * kw - kilowatts needed; if specified, this returns 0 unless the network is under atleast that amount of load.
 */
/obj/machinery/power/proc/power_load_overall(kw)
	#warn impl

/**
 * get tier draw on network
 *
 * @params
 * * tier - the tier we're checking
 * * kw - kilowatts needed; if specified, this returns 0 unless the network is under atleast that amount of load.
 */
/obj/machinery/power/proc/power_load_tier(tier, kw)
	#warn impl

/**
 * get flat draw on network
 *
 * @params
 * * kw - kilowatts needed; if specified, this returns 0 unless the network is under atleast that amount of load.
 */
/obj/machinery/power/proc/power_load_flat(kw)
	#warn impl


///////////////////////////////
// General procedures
//////////////////////////////

// common helper procs for all power machines
/obj/machinery/power/drain_energy(datum/actor, amount, flags)
	if(!powernet)
		return 0
	return powernet.drain_energy_handler(actor, amount, flags)

/obj/machinery/power/can_drain_energy(datum/actor, amount)
	return TRUE


// attach a wire to a power machine - leads from the turf you are standing on
//almost never called, overwritten by all power machines but terminal and generator
/obj/machinery/power/attackby(obj/item/W, mob/user)

	if(istype(W, /obj/item/stack/cable_coil))

		var/obj/item/stack/cable_coil/coil = W

		var/turf/T = user.loc

		if(!T.is_plating() || !istype(T, /turf/simulated/floor))
			return

		if(get_dist(src, user) > 1)
			return

		coil.turf_place(T, user)
		return
	else
		..()

// Used for power spikes by the engine, has specific effects on different machines.
/obj/machinery/power/proc/overload(var/obj/machinery/power/source)
	return

// Used by the grid checker upon receiving a power spike.
/obj/machinery/power/proc/do_grid_check()
	return

/obj/machinery/power/proc/power_spike()
	return

///////////////////////////////////////////
// Powernet handling helpers
//////////////////////////////////////////

//returns all the cables WITHOUT a powernet in neighbors turfs,
//pointing towards the turf the machine is located at
/obj/machinery/power/proc/get_connections()

	. = list()

	var/cdir
	var/turf/T

	for(var/card in GLOB.cardinal)
		T = get_step(loc,card)
		cdir = get_dir(T,loc)

		for(var/obj/structure/cable/C in T)
			if(C.powernet)	continue
			if(C.d1 == cdir || C.d2 == cdir)
				. += C
	return .

///////////////////////////////////////////
// GLOBAL PROCS for powernets handling
//////////////////////////////////////////


// returns a list of all power-related objects (nodes, cable, junctions) in turf,
// excluding source, that match the direction d
// if unmarked==1, only return those with no powernet
/proc/power_list(var/turf/T, var/source, var/d, var/unmarked=0, var/cable_only = 0)
	. = list()

	var/reverse = d ? global.reverse_dir[d] : 0
	for(var/AM in T)
		if(AM == source)	continue			//we don't want to return source

		if(!cable_only && istype(AM,/obj/machinery/power))
			var/obj/machinery/power/P = AM
			if(P.powernet == 0)	continue		// exclude APCs which have powernet=0

			if(!unmarked || !P.powernet)		//if unmarked=1 we only return things with no powernet
				if(d == 0)
					. += P

		else if(istype(AM,/obj/structure/cable))
			var/obj/structure/cable/C = AM

			if(!unmarked || !C.powernet)
				if(C.d1 == d || C.d2 == d || C.d1 == reverse || C.d2 == reverse )
					. += C
	return .

//remove the old powernet and replace it with a new one throughout the network.
/proc/propagate_network(var/obj/O, var/datum/powernet/PN)
	//to_chat(world.log, "propagating new network")
	var/list/worklist = list()
	var/list/found_machines = list()
	var/index = 1
	var/obj/P = null

	worklist+=O //start propagating from the passed object

	while(index<=worklist.len) //until we've exhausted all power objects
		P = worklist[index] //get the next power object found
		index++

		if( istype(P,/obj/structure/cable))
			var/obj/structure/cable/C = P
			if(C.powernet != PN) //add it to the powernet, if it isn't already there
				PN.add_cable(C)
			worklist |= C.get_connections() //get adjacents power objects, with or without a powernet

		else if(P.anchored && istype(P,/obj/machinery/power))
			var/obj/machinery/power/M = P
			found_machines |= M //we wait until the powernet is fully propagates to connect the machines

		else
			continue

	//now that the powernet is set, connect found machines to it
	for(var/obj/machinery/power/PM in found_machines)
		if(!PM.connect_to_network()) //couldn't find a node on its turf...
			PM.disconnect_from_network() //... so disconnect if already on a powernet

//Determines how strong could be shock, deals damage to mob, uses power.
//M is a mob who touched wire/whatever
//power_source is a source of electricity, can be powercell, area, apc, cable, powernet or null
//source is an object caused electrocuting (airlock, grille, etc)
//No animations will be performed by this proc.
/proc/electrocute_mob(mob/living/M as mob, var/power_source, var/obj/source, var/siemens_coeff = 1.0)
	if(istype(M.loc,/obj/mecha))	return 0	//feckin mechs are dumb
	if(issilicon(M))	return 0	//No more robot shocks from machinery
	var/area/source_area
	if(istype(power_source,/area))
		source_area = power_source
		power_source = source_area.get_apc()
	if(istype(power_source,/obj/structure/cable))
		var/obj/structure/cable/Cable = power_source
		power_source = Cable.powernet

	var/datum/powernet/PN
	var/obj/item/cell/cell

	if(istype(power_source,/datum/powernet))
		PN = power_source
	else if(istype(power_source,/obj/item/cell))
		cell = power_source
	else if(istype(power_source,/obj/machinery/power/apc))
		var/obj/machinery/power/apc/apc = power_source
		cell = apc.cell
		if (apc.terminal)
			PN = apc.terminal.powernet
	else if (!power_source)
		return 0
	else
		log_admin("ERROR: /proc/electrocute_mob([M], [power_source], [source]): wrong power_source")
		return 0
	//Triggers powernet warning, but only for 5 ticks (if applicable)
	//If following checks determine user is protected we won't alarm for long.
	if(PN)
		PN.trigger_warning(5)
	if(istype(M,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		if(H.species.siemens_coefficient <= 0)
			return
		if(H.gloves)
			var/obj/item/clothing/gloves/G = H.gloves
			if(G.siemens_coefficient == 0)	return 0		//to avoid spamming with insulated glvoes on

	//Checks again. If we are still here subject will be shocked, trigger standard 20 tick warning
	//Since this one is longer it will override the original one.
	if(PN)
		PN.trigger_warning()

	if (!cell && !PN)
		return 0
	var/PN_damage = 0
	var/cell_damage = 0
	if (PN)
		PN_damage = PN.get_electrocute_damage()
	if (cell)
		cell_damage = cell.get_electrocute_damage()
	var/shock_damage = 0
	if (PN_damage>=cell_damage)
		power_source = PN
		shock_damage = PN_damage
	else
		power_source = cell
		shock_damage = cell_damage
	var/drained_hp = M.electrocute_act(shock_damage, source, siemens_coeff) //zzzzzzap!
	// 10kw per hp
	var/drained_energy = drained_hp * 10000
	if (source_area)
		source_area.use_burst_power(drained_energy)
	else if (istype(power_source,/datum/powernet))
		drained_energy = PN.draw_power(drained_energy * 0.001) * 1000
	else if (istype(power_source, /obj/item/cell))
		cell.use(DYNAMIC_W_TO_CELL_UNITS(drained_energy, 1))
	return drained_energy
