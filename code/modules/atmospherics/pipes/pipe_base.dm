//
// Base type of pipes
//
/obj/machinery/atmospherics/pipe

	var/datum/gas_mixture/air_temporary // used when reconstructing a pipeline that broke
	var/datum/pipeline/parent
	var/volume = 0

	layer = PIPES_LAYER
	use_power = USE_POWER_OFF

	pipe_flags = 0 // Does not have PIPING_DEFAULT_LAYER_ONLY flag.

	var/alert_pressure = 80*ONE_ATMOSPHERE
		//minimum pressure before check_pressure(...) should be called

	can_buckle = 1
	buckle_require_restraints = 1
	buckle_lying = -1

/obj/machinery/atmospherics/pipe/New()
	add_atom_colour(pipe_color, FIXED_COLOUR_PRIORITY)
	// volume = 35 * device_type
	..()

///I have no idea why there's a new and at this point I'm too afraid to ask
/obj/machinery/atmospherics/pipe/Initialize(mapload)
	. = ..()

	AddElement(/datum/element/undertile, TRAIT_T_RAY_VISIBLE)

/obj/machinery/atmospherics/pipe/proc/pipeline_expansion()
	return null

// For pipes this is the same as pipeline_expansion()
/obj/machinery/atmospherics/pipe/get_neighbor_nodes_for_init()
	return pipeline_expansion()

/obj/machinery/atmospherics/pipe/proc/check_pressure(pressure)
	//Return 1 if parent should continue checking other pipes
	//Return null if parent should stop checking other pipes. Recall: qdel(src) will by default return null

	return 1

/obj/machinery/atmospherics/pipe/return_air()
	if(!parent)
		parent = new /datum/pipeline()
		parent.build_pipeline(src)

	return parent.air

/obj/machinery/atmospherics/pipe/build_network()
	if(!parent)
		parent = new /datum/pipeline()
		parent.build_pipeline(src)

	return parent.return_network()

/obj/machinery/atmospherics/pipe/network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)
	if(!parent)
		parent = new /datum/pipeline()
		parent.build_pipeline(src)

	return parent.network_expand(new_network, reference)

/obj/machinery/atmospherics/pipe/return_network(obj/machinery/atmospherics/reference)
	if(!parent)
		parent = new /datum/pipeline()
		parent.build_pipeline(src)

	return parent.return_network(reference)

/obj/machinery/atmospherics/pipe/Destroy()
	QDEL_NULL(parent)
	if(air_temporary)
		loc.assume_air(air_temporary)
	for(var/obj/machinery/meter/meter in loc)
		if(meter.target == src)
			var/obj/item/pipe_meter/PM = new /obj/item/pipe_meter(loc)
			meter.transfer_fingerprints_to(PM)
			qdel(meter)
	. = ..()

/obj/machinery/atmospherics/pipe/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(src, /obj/machinery/atmospherics/pipe/tank))
		return ..()

	if(istype(W,/obj/item/pipe_painter))
		return 0

	if(!W.is_wrench())
		return ..()

	if(unsafe_pressure())
		to_chat(user, SPAN_WARNING("You feel a gust of air blowing in your face as you try to unwrench [src]. Maybe you should reconsider.."))

	add_fingerprint(user)
	playsound(src, W.usesound, 50, 1)
	to_chat(user, SPAN_NOTICE("You begin to unfasten \the [src]..."))
	if(do_after(user, 40 * W.toolspeed))
		user.visible_message( \
			SPAN_NOTICE("\The [user] unfastens \the [src]."), \
			SPAN_NOTICE("You have unfastened \the [src]."), \
			SPAN_HEAR("You hear a ratchet."))
		deconstruct()

/obj/machinery/atmospherics/pipe/proc/change_color(new_color)
	//only pass valid pipe colors please ~otherwise your pipe will turn invisible
	if(!pipe_color_check(new_color))
		return

	pipe_color = new_color
	update_icon()

/obj/machinery/atmospherics/pipe/color_cache_name(obj/machinery/atmospherics/node)
	if(istype(src, /obj/machinery/atmospherics/pipe/tank))
		return ..()

	if(istype(node, /obj/machinery/atmospherics/pipe/manifold) || istype(node, /obj/machinery/atmospherics/pipe/manifold4w))
		if(pipe_color == node.pipe_color)
			return node.pipe_color
		else
			return null
	else if(istype(node, /obj/machinery/atmospherics/pipe/simple))
		return node.pipe_color
	else
		return pipe_color

/obj/machinery/atmospherics/pipe/process(delta_time)
	if(!parent) //This should cut back on the overhead calling build_network thousands of times per cycle
		..()
	else
		. = PROCESS_KILL

/obj/machinery/atmospherics/pipe/attack_ghost(mob/user)
	. = ..()
	if(user.client && user.client.inquisitive_ghost)
		analyze_gases_ghost(src, user)
	else
		to_chat(user, SPAN_WARNING("[src] doesn't have a pipenet, which is probably a bug."))
