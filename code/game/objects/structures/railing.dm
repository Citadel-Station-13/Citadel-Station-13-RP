// Based on railing.dmi from https://github.com/Endless-Horizon/CEV-Eris
/obj/structure/railing
	name = "railing"
	desc = "A standard steel railing.  Play stupid games, win stupid prizes."
	icon = 'icons/obj/railing.dmi'
	density = TRUE
	pass_flags_self = ATOM_PASS_THROWN | ATOM_PASS_CLICK | ATOM_PASS_TABLE | ATOM_PASS_OVERHEAD_THROW | ATOM_PASS_CLICK | ATOM_PASS_BUCKLED
	climb_allowed = TRUE
	depth_level = 24
	layer = WINDOW_LAYER
	anchored = TRUE
	atom_flags = ATOM_BORDER
	icon_state = "railing0"

	integrity = 150
	integrity_max = 150
	hit_sound_brute = 'sound/effects/grillehit.ogg'

	var/broken = FALSE
	var/check = 0

/obj/structure/railing/grey
	name = "grey railing"
	desc = "A standard steel railing. Prevents stupid people from falling to their doom."
	icon_state = "grey_railing0"

/obj/structure/railing/Initialize(mapload, constructed = FALSE)
	. = ..()
	// TODO - "constructed" is not passed to us. We need to find a way to do this safely.
	if (constructed) // player-constructed railings
		anchored = 0
	if(src.anchored)
		update_icon(0)

/obj/structure/railing/Destroy()
	var/turf/location = loc
	. = ..()
	for(var/obj/structure/railing/R in orange(location, 1))
		R.update_icon()

/obj/structure/railing/CanAllowThrough(atom/movable/mover, turf/target)
	if(!(get_dir(mover, target) & turn(dir, 180)))
		return TRUE
	return ..()

/obj/structure/railing/CheckExit(atom/movable/mover, atom/newLoc)
	if(check_standard_flag_pass(mover))
		return TRUE
	if(!(get_dir(src, newLoc) & dir))
		return TRUE
	if(isliving(mover))
		var/mob/living/L = mover
		if((L.depth_current >= depth_level) && !(obj_flags & OBJ_IGNORE_MOB_DEPTH))
			return TRUE
	return !density

/obj/structure/railing/proc/NeighborsCheck(var/UpdateNeighbors = 1)
	check = 0
	//if (!anchored) return
	var/Rturn = turn(src.dir, -90)
	var/Lturn = turn(src.dir, 90)

	for(var/obj/structure/railing/R in src.loc)
		if ((R.dir == Lturn) && R.anchored)
			check |= 32
			if (UpdateNeighbors)
				R.update_icon(UpdateNeighbors = FALSE)
		if ((R.dir == Rturn) && R.anchored)
			check |= 2
			if (UpdateNeighbors)
				R.update_icon(UpdateNeighbors = FALSE)

	for (var/obj/structure/railing/R in get_step(src, Lturn))
		if ((R.dir == src.dir) && R.anchored)
			check |= 16
			if (UpdateNeighbors)
				R.update_icon(UpdateNeighbors = FALSE)
	for (var/obj/structure/railing/R in get_step(src, Rturn))
		if ((R.dir == src.dir) && R.anchored)
			check |= 1
			if (UpdateNeighbors)
				R.update_icon(UpdateNeighbors = FALSE)

	for (var/obj/structure/railing/R in get_step(src, (Lturn + src.dir)))
		if ((R.dir == Rturn) && R.anchored)
			check |= 64
			if (UpdateNeighbors)
				R.update_icon(UpdateNeighbors = FALSE)
	for (var/obj/structure/railing/R in get_step(src, (Rturn + src.dir)))
		if ((R.dir == Lturn) && R.anchored)
			check |= 4
			if (UpdateNeighbors)
				R.update_icon(UpdateNeighbors = FALSE)

/obj/structure/railing/update_icon(updates, UpdateNeighbors = TRUE)
	NeighborsCheck(UpdateNeighbors)
	//layer = (dir == SOUTH) ? FLY_LAYER : initial(layer) // wtf does this even do
	cut_overlays()

	if (!check || !anchored)//|| !anchored
		icon_state = "railing0"
	else
		icon_state = "railing1"
		if (check & 32)
			add_overlay("corneroverlay")
		if ((check & 16) || !(check & 32) || (check & 64))
			add_overlay("frontoverlay_l")
		if (!(check & 2) || (check & 1) || (check & 4))
			var/list/overlays_to_add = list(
				"frontoverlay_r"
			)
			if(check & 4)
				switch (src.dir)
					if (NORTH)
						overlays_to_add += image('icons/obj/railing.dmi', "mcorneroverlay", pixel_x = 32)
					if (SOUTH)
						overlays_to_add += image('icons/obj/railing.dmi', "mcorneroverlay", pixel_x = -32)
					if (EAST)
						overlays_to_add += image('icons/obj/railing.dmi', "mcorneroverlay", pixel_y = -32)
					if (WEST)
						overlays_to_add += image('icons/obj/railing.dmi', "mcorneroverlay", pixel_y = 32)

			add_overlay(overlays_to_add)

/obj/structure/railing/verb/rotate_counterclockwise()
	set name = "Rotate Railing Counter-Clockwise"
	set category = "Object"
	set src in oview(1)

	if(usr.incapacitated())
		return 0

	if (!can_touch(usr) || ismouse(usr))
		return

	if(anchored)
		to_chat(usr, "It is fastened to the floor therefore you can't rotate it!")
		return 0

	src.setDir(turn(src.dir, 90))
	update_icon()
	return

/obj/structure/railing/verb/rotate_clockwise()
	set name = "Rotate Railing Clockwise"
	set category = "Object"
	set src in oview(1)

	if(usr.incapacitated())
		return 0

	if (!can_touch(usr) || ismouse(usr))
		return

	if(anchored)
		to_chat(usr, "It is fastened to the floor therefore you can't rotate it!")
		return 0

	src.setDir(turn(src.dir, 270))
	update_icon()
	return

/obj/structure/railing/verb/flip() // This will help push railing to remote places, such as open space turfs
	set name = "Flip Railing"
	set category = "Object"
	set src in oview(1)

	if(usr.incapacitated())
		return 0

	if (!can_touch(usr) || ismouse(usr))
		return

	if(anchored)
		to_chat(usr, "It is fastened to the floor therefore you can't flip it!")
		return 0

	var/obj/occupied = neighbor_turf_impassable()
	if(occupied)
		to_chat(usr, "You can't flip \the [src] because there's \a [occupied] in the way.")
		return 0

	src.loc = get_step(src, src.dir)
	setDir(turn(dir, 180))
	update_icon()
	return

/obj/structure/railing/welder_act(obj/item/I, mob/user, flags, hint)
	if(integrity >= integrity_max)
		user.action_feedback(SPAN_WARNING("[src] is at full health."), src)
		return FALSE
	if(!use_welder(I, user, flags, 2 SECONDS, 1, TOOL_USAGE_REPAIR | TOOL_USAGE_BUILDING_FRAMEWORK))
		return FALSE
	user.visible_action_feedback(SPAN_NOTICE("[user] repairs some damage to [src]."), src, MESSAGE_RANGE_CONSTRUCTION)
	heal_integrity(integrity_max * 0.2)
	return TRUE

/obj/structure/railing/attackby(obj/item/W as obj, mob/user as mob)
	// Dismantle
	if(W.is_wrench() && !anchored)
		playsound(src.loc, W.tool_sound, 50, 1)
		if(do_after(user, 20, src))
			user.visible_message("<span class='notice'>\The [user] dismantles \the [src].</span>", "<span class='notice'>You dismantle \the [src].</span>")
			new /obj/item/stack/material/steel(get_turf(usr), 2)
			qdel(src)
			return

	// Install
	if(W.is_screwdriver())
		user.visible_message(anchored ? "<span class='notice'>\The [user] begins unscrewing \the [src].</span>" : "<span class='notice'>\The [user] begins fasten \the [src].</span>" )
		playsound(loc, W.tool_sound, 75, 1)
		if(do_after(user, 10, src))
			to_chat(user, (anchored ? "<span class='notice'>You have unfastened \the [src] from the floor.</span>" : "<span class='notice'>You have fastened \the [src] to the floor.</span>"))
			anchored = !anchored
			update_icon()
			return

	// Handle harm intent grabbing/tabling.
	if(istype(W, /obj/item/grab) && get_dist(src,user)<2)
		var/obj/item/grab/G = W
		if (istype(G.affecting, /mob/living))
			var/mob/living/M = G.affecting
			var/obj/occupied = turf_is_crowded()
			if(occupied)
				to_chat(user, "<span class='danger'>There's \a [occupied] in the way.</span>")
				return
			if (G.state < 2)
				if(user.a_intent == INTENT_HARM)
					if (prob(15))
						M.afflict_paralyze(20 * 5)
					M.apply_damage(8,def_zone = "head")
					damage_integrity(8)
					visible_message("<span class='danger'>[G.assailant] slams [G.affecting]'s face against \the [src]!</span>")
					playsound(loc, 'sound/effects/grillehit.ogg', 50, 1)
				else
					to_chat(user, "<span class='danger'>You need a better grip to do that!</span>")
					return
			else
				if (get_turf(G.affecting) == get_turf(src))
					G.affecting.forceMove(get_step(src, src.dir))
				else
					G.affecting.forceMove(get_turf(src))
				G.affecting.afflict_paralyze(20 * 5)
				visible_message("<span class='danger'>[G.assailant] throws [G.affecting] over \the [src]!</span>")
			qdel(W)
			return
	return ..()

/obj/structure/railing/legacy_ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
		if(2.0)
			qdel(src)
		if(3.0)
			qdel(src)

// TODO - This here might require some investigation
// todo: no, this here needs to be thrown out, we have depth system now
/obj/structure/proc/neighbor_turf_impassable()
	var/turf/T = get_step(src, src.dir)
	if(!T || !istype(T))
		return 0
	if(T.density == 1)
		return T
	for(var/obj/O in T.contents)
		if(istype(O,/obj/structure))
			var/obj/structure/S = O
			if(S.climb_allowed)
				continue
		if(O && O.density && !(O.atom_flags & ATOM_BORDER && !(turn(O.dir, 180) & dir)))
			return O

/obj/structure/railing/do_climb_target(mob/living/climber)
	return climber.loc == get_turf(src)? get_step(src, dir) : ..()
