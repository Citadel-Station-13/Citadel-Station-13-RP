//
// Base type of pipes
//
/obj/machinery/atmospherics/pipe
	buckle_allowed = TRUE
	buckle_flags = BUCKLING_REQUIRES_RESTRAINTS

	use_power = USE_POWER_OFF

	pipe_flags = NONE // Does not have PIPING_DEFAULT_LAYER_ONLY flag.

	#ifdef IN_MAP_EDITOR
	alpha = 128 // Set for the benefit of mapping.
	#endif

	var/datum/gas_mixture/air_temporary // used when reconstructing a pipeline that broke
	var/datum/pipeline/parent
	var/volume = 0

	var/alert_pressure = 80*ONE_ATMOSPHERE
		//minimum pressure before check_pressure(...) should be called

/obj/machinery/atmospherics/pipe/Initialize(mapload, newdir)
	if(istype(get_turf(src), /turf/simulated/wall) || istype(get_turf(src), /turf/simulated/shuttle/wall) || istype(get_turf(src), /turf/unsimulated/wall))
		level = 1
	return ..()

/obj/machinery/atmospherics/pipe/hides_under_flooring()
	return level != 2

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

/obj/machinery/atmospherics/pipe/attackby(var/obj/item/W as obj, var/mob/user as mob)
	if (istype(src, /obj/machinery/atmospherics/pipe/tank))
		return ..()

	if(istype(W,/obj/item/pipe_painter))
		return 0

	if (!W.is_wrench())
		return ..()
	var/turf/T = src.loc
	if (level==1 && isturf(T) && !T.is_plating())
		to_chat(user, "<span class='warning'>You must remove the plating first.</span>")
		return 1
	if(unsafe_pressure())
		to_chat(user, "<span class='warning'>You feel a gust of air blowing in your face as you try to unwrench [src]. Maybe you should reconsider..</span>")
	add_fingerprint(user)
	playsound(src, W.tool_sound, 50, 1)
	to_chat(user, "<span class='notice'>You begin to unfasten \the [src]...</span>")
	if (do_after(user, 40 * W.tool_speed))
		user.visible_message( \
			"<span class='notice'>\The [user] unfastens \the [src].</span>", \
			"<span class='notice'>You have unfastened \the [src].</span>", \
			"You hear a ratchet.")
		deconstruct()

/obj/machinery/atmospherics/pipe/proc/change_color(var/new_color)
	//only pass valid pipe colors please ~otherwise your pipe will turn invisible
	if(!pipe_color_check(new_color))
		return

	pipe_color = new_color
	update_icon()

/obj/machinery/atmospherics/pipe/color_cache_name(var/obj/machinery/atmospherics/node)
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

/obj/machinery/atmospherics/pipe/hide(var/i)
	if(istype(loc, /turf/simulated))
		invisibility = i ? 100 : 0
	update_icon()

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
		to_chat(user, "<span class='warning'>[src] doesn't have a pipenet, which is probably a bug.</span>")
