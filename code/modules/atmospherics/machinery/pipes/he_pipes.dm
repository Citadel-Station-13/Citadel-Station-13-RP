/**
 * Pipes but they exchange heat with environment.
 */
/obj/machinery/atmospherics/pipe/simple/heat_exchanging
	icon = 'icons/atmos/heat.dmi'
	icon_state = "intact"
	pipe_icon = "hepipe"
	color = "#404040"
	hides_underfloor = OBJ_UNDERFLOOR_NEVER
	connect_types = CONNECT_TYPE_HE
	pipe_flags = PIPING_DEFAULT_LAYER_ONLY
	construction_type = /obj/item/pipe/binary/bendable
	pipe_state = "he"

	layer = PIPES_HE_LAYER
	var/initialize_directions_he
	var/icon_temperature = T20C //stop small changes in temperature causing an icon refresh


	/// Our surface area in m^2
	var/surface = 2
	/// thermal conductivity for normal heat exchange
	var/thermal_conductivity = 0.75
	/// thermal conductivity for space cooling, basically
	var/blackbody_thermal_conductivity = 1
	/// minimum temperature difference for heat exchanger pipes to exchange heat
	var/minimum_temperature_difference = 0.01

/obj/machinery/atmospherics/pipe/simple/heat_exchanging/Initialize(mapload)
	. = ..()
	add_atom_color("#404040") //we don't make use of the fancy overlay system for colours, use this to set the default.

/obj/machinery/atmospherics/pipe/simple/heat_exchanging/init_dir()
	..()
	initialize_directions_he = initialize_directions	// The auto-detection from /pipe is good enough for a simple HE pipe
	initialize_directions = 0

/obj/machinery/atmospherics/pipe/simple/heat_exchanging/get_init_dirs()
	return ..() | initialize_directions_he

/obj/machinery/atmospherics/pipe/simple/heat_exchanging/get_standard_layer(underfloor)
	return PIPES_HE_LAYER

// Use initialize_directions_he to connect to neighbors instead.
/obj/machinery/atmospherics/pipe/simple/heat_exchanging/can_be_node(var/obj/machinery/atmospherics/pipe/simple/heat_exchanging/target)
	if(!istype(target))
		return FALSE
	return (target.initialize_directions_he & get_dir(target,src)) && check_connectable(target) && target.check_connectable(src)

/obj/machinery/atmospherics/pipe/simple/heat_exchanging/atmos_init()
	normalize_dir()
	var/node1_dir
	var/node2_dir

	for(var/direction in GLOB.cardinal)
		if(direction&initialize_directions_he)
			if (!node1_dir)
				node1_dir = direction
			else if (!node2_dir)
				node2_dir = direction

	for(var/obj/machinery/atmospherics/pipe/simple/heat_exchanging/target in get_step(src,node1_dir))
		if(can_be_node(target, 1))
			node1 = target
			break
	for(var/obj/machinery/atmospherics/pipe/simple/heat_exchanging/target in get_step(src,node2_dir))
		if(can_be_node(target, 2))
			node2 = target
			break
	if(!node1 && !node2)
		qdel(src)
		return

	update_icon()

/obj/machinery/atmospherics/pipe/simple/heat_exchanging/process(delta_time)
	if(!parent)
		..()
	else
		// process against turf
		// we check temperatures first, but we directly have parent pipeline-interact with location, rather than doing it ourselves.
		// get immutable air references; we will directly call our pipeline's interact procs,
		// instead of doing it ourselves.
		var/datum/gas_mixture/our_air_immutable = parent.air
		if(istype(loc, /turf/space))
			parent.share_heat_with_space(surface, blackbody_thermal_conductivity)
		else if(istype(loc, /turf)) // it better be a goddamn turf
			var/turf/loc_casted_as_turf = loc
			if(abs((loc_casted_as_turf.temperature_for_heat_exchangers || loc_casted_as_turf.return_temperature()) - our_air_immutable.temperature) > minimum_temperature_difference)
				// temperature difference is enough, process equalization
				parent.turf_thermal_superconduction(loc, volume, thermal_conductivity, 1)
		else
			stack_trace("HE pipe was not on a turf but was processing. what the hell?")
			qdel(src)

		// process buckled mobs
		if(has_buckled_mobs())
			for(var/M in buckled_mobs)
				var/mob/living/L = M

				var/hc = our_air_immutable.heat_capacity()
				// todo: this is not even close to someone's actual heat capacity lol
				var/avg_temp = (our_air_immutable.temperature * hc + L.bodytemperature * 3500) / (hc + 3500)
				L.bodytemperature = avg_temp

				var/heat_limit = 1000

				var/mob/living/carbon/human/H = L
				if(istype(H) && H.species)
					heat_limit = H.species.heat_level_3

				if(our_air_immutable.temperature > heat_limit + 1)
					L.apply_damage(4 * log(our_air_immutable.temperature - heat_limit), DAMAGE_TYPE_BURN, BP_TORSO, used_weapon = "Excessive Heat")

		// process icon / glow
		if(our_air_immutable.temperature && (icon_temperature > 500 || our_air_immutable.temperature > 500)) //start glowing at 500K
			if(abs(our_air_immutable.temperature - icon_temperature) > 10)
				icon_temperature = our_air_immutable.temperature

				var/h_r = heat2colour_r(icon_temperature)
				var/h_g = heat2colour_g(icon_temperature)
				var/h_b = heat2colour_b(icon_temperature)

				if(icon_temperature < 2000) //scale up overlay until 2000K
					var/scale = (icon_temperature - 500) / 1500
					h_r = 64 + (h_r - 64)*scale
					h_g = 64 + (h_g - 64)*scale
					h_b = 64 + (h_b - 64)*scale

				animate(src, color = rgb(h_r, h_g, h_b), time = 20, easing = SINE_EASING)

//
// Heat Exchange Junction - Interfaces HE pipes to normal pipes
//
/obj/machinery/atmospherics/pipe/simple/heat_exchanging/junction
	icon = 'icons/atmos/junction.dmi'
	icon_state = "intact"
	pipe_icon = "hejunction"
	hides_underfloor = OBJ_UNDERFLOOR_NEVER
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_HE
	construction_type = /obj/item/pipe/directional
	pipe_state = "junction"

/obj/machinery/atmospherics/pipe/simple/heat_exchanging/junction/init_dir()
	..()
	switch ( dir )
		if ( SOUTH )
			initialize_directions = NORTH
			initialize_directions_he = SOUTH
		if ( NORTH )
			initialize_directions = SOUTH
			initialize_directions_he = NORTH
		if ( EAST )
			initialize_directions = WEST
			initialize_directions_he = EAST
		if ( WEST )
			initialize_directions = EAST
			initialize_directions_he = WEST

	// Allow ourselves to make connections to either HE or normal pipes depending on which node we are doing.
/obj/machinery/atmospherics/pipe/simple/heat_exchanging/junction/can_be_node(obj/machinery/atmospherics/target, node_num)
	var/target_initialize_directions
	switch(node_num)
		if(1)
			target_initialize_directions = target.initialize_directions // Node1 is towards normal pipes
		if(2)
			var/obj/machinery/atmospherics/pipe/simple/heat_exchanging/H = target
			if(!istype(H))
				return FALSE
			target_initialize_directions = H.initialize_directions_he  // Node2 is towards HE pies.
	return (target_initialize_directions & get_dir(target,src)) && check_connectable(target) && target.check_connectable(src)

/obj/machinery/atmospherics/pipe/simple/heat_exchanging/junction/atmos_init()
	for(var/obj/machinery/atmospherics/target in get_step(src,initialize_directions))
		if(target.initialize_directions & get_dir(target,src))
			node1 = target
			break
	for(var/obj/machinery/atmospherics/pipe/simple/heat_exchanging/target in get_step(src,initialize_directions_he))
		if(target.initialize_directions_he & get_dir(target,src))
			node2 = target
			break

	if(!node1&&!node2)
		qdel(src)
		return

	update_icon()
	return
