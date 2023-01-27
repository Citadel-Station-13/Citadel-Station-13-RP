/////SINGULARITY SPAWNER
/obj/machinery/the_singularitygen/
	name = "Gravitational Singularity Generator"
	desc = "An Odd Device which produces a Gravitational Singularity when set up."
	icon = 'icons/obj/singularity.dmi'
	icon_state = "TheSingGen"
	anchored = 0
	density = 1
	use_power = USE_POWER_OFF
	var/energy = 0
	var/creation_type = /obj/singularity

/obj/machinery/the_singularitygen/process(delta_time)
	var/turf/T = get_turf(src)
	if(src.energy >= 200)
		new creation_type(T, 50)
		if(src) qdel(src)

/obj/machinery/the_singularitygen/attackby(obj/item/W, mob/user)
	if(W.is_wrench())
		anchored = !anchored
		playsound(src, W.tool_sound, 75, 1)
		if(anchored)
			user.visible_message("[user.name] secures [src.name] to the floor.", \
				"You secure the [src.name] to the floor.", \
				"You hear a ratchet.")
		else
			user.visible_message("[user.name] unsecures [src.name] from the floor.", \
				"You unsecure the [src.name] from the floor.", \
				"You hear a ratchet.")
		return
	if(W.is_screwdriver())
		panel_open = !panel_open
		playsound(loc, W.tool_sound, 50, 1)
		visible_message(SPAN_NOTICE("\The [user] adjusts \the [src]'s mechanisms."))
		if(panel_open && do_after(user, 30))
			to_chat(user, SPAN_NOTICE("\The [src] looks like it could be modified."))
			if(panel_open && do_after(user, 80 * W.tool_speed))	// We don't have skills, so a delayed hint for engineers will have to do for now. (Panel open check for sanity)
				playsound(loc, W.tool_sound, 50, 1)
				to_chat(user, SPAN_CULT("\The [src] looks like it could be adapted to forge advanced materials via particle acceleration, somehow.."))
		else
			to_chat(user, SPAN_NOTICE("\The [src]'s mechanisms look secure."))
	if(istype(W, /obj/item/smes_coil/super_io) && panel_open)
		visible_message(SPAN_NOTICE("\The [user] begins to modify \the [src] with \the [W]."))
		if(do_after(user, 10 SECONDS))
			if(!user.attempt_consume_item_for_construction(W))
				return
			visible_message(SPAN_NOTICE("\The [user] installs \the [W] onto \the [src]."))
			var/turf/T = get_turf(src)
			var/new_machine = /obj/machinery/particle_smasher
			new new_machine(T)
			qdel(src)
	return ..()
