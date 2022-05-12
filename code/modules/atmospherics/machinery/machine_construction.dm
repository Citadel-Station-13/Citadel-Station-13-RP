/**
 * Snowflaked because pipes are not nearly even machinery at this point
 * Called on construction to begin init.
 * The proper way to do this is to have constructed = FALSE in the new() call for pipes, and then call this to set everything.
 */
/obj/machinery/atmospherics/proc/InitConstructed(set_color, set_dir, set_layer)
	SHOULD_CALL_PARENT(TRUE)
	if(set_color)
		pipe_color = set_color
	add_atom_colour(pipe_color, FIXED_COLOUR_PRIORITY)
	if(set_layer)
		SetPipingLayer(set_layer)
	var/turf/T = get_turf(src)
	level = T.intact ? 2 : 1
	if(set_dir)
		setDir(set_dir)
	if(SSair.initialized)
		InitAtmos()

/obj/machinery/atmospherics/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/pipe)) //lets you autodrop
		var/obj/item/pipe/pipe = W
		if(user.dropItemToGround(pipe))
			pipe.setPipingLayer(pipe_layer) //align it with us
			return TRUE
	else
		return ..()

/obj/machinery/atmospherics/wrench_act(mob/living/user, obj/item/I)
	if(!can_unwrench(user))
		return ..()

	var/turf/T = get_turf(src)
	if (level==1 && isturf(T) && T.intact)
		to_chat(user, "<span class='warning'>You must remove the plating first!</span>")
		return TRUE

	var/datum/gas_mixture/int_air = return_air()
	var/datum/gas_mixture/env_air = loc.return_air()
	add_fingerprint(user)

	var/unsafe_wrenching = FALSE
	var/internal_pressure = int_air.return_pressure()-env_air.return_pressure()

	to_chat(user, "<span class='notice'>You begin to unfasten \the [src]...</span>")

	if (internal_pressure > 2*ONE_ATMOSPHERE)
		to_chat(user, "<span class='warning'>As you begin unwrenching \the [src] a gush of air blows in your face... maybe you should reconsider?</span>")
		unsafe_wrenching = TRUE //Oh dear oh dear

	if(I.use_tool(src, user, 20, volume=50))
		user.visible_message( \
			"[user] unfastens \the [src].", \
			"<span class='notice'>You unfasten \the [src].</span>", \
			"<span class='italics'>You hear ratchet.</span>")
		investigate_log("was <span class='warning'>REMOVED</span> by [key_name(usr)]", INVESTIGATE_ATMOS)

		//You unwrenched a pipe full of pressure? Let's splat you into the wall, silly.
		if(unsafe_wrenching)
			unsafe_pressure_release(user, internal_pressure)
		deconstruct(TRUE)
	return TRUE

/obj/machinery/atmospherics/proc/can_unwrench(mob/user)
	return can_unwrench

// Throws the user when they unwrench a pipe with a major difference between the internal and environmental pressure.
/obj/machinery/atmospherics/proc/unsafe_pressure_release(mob/user, pressures = null)
	if(!user)
		return
	if(!pressures)
		var/datum/gas_mixture/int_air = return_air()
		var/datum/gas_mixture/env_air = loc.return_air()
		pressures = int_air.return_pressure() - env_air.return_pressure()

	user.visible_message("<span class='danger'>[user] is sent flying by pressure!</span>","<span class='userdanger'>The pressure sends you flying!</span>")

	// if get_dir(src, user) is not 0, target is the edge_target_turf on that dir
	// otherwise, edge_target_turf uses a random cardinal direction
	// range is pressures / 250
	// speed is pressures / 1250
	user.throw_at(get_edge_target_turf(user, get_dir(src, user) || pick(GLOB.cardinals)), pressures / 250, pressures / 1250)

/obj/machinery/atmospherics/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		if(can_unwrench)
			var/obj/item/pipe/stored = new construction_type(loc, null, dir, src)
			stored.setPipingLayer(pipe_layer)
			if(!disassembled)
				stored.obj_integrity = stored.max_integrity * 0.5
			transfer_fingerprints_to(stored)
	..()

/obj/machinery/atmospherics/singularity_pull(S, current_size)
	if(current_size >= STAGE_FIVE)
		deconstruct(FALSE)
	return ..()
