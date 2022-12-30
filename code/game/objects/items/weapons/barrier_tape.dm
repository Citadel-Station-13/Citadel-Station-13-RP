//Define all tape types in policetape.dm
/obj/item/barrier_tape_roll
	name = "tape roll"
	icon = 'icons/policetape.dmi'
	icon_state = "tape"
	w_class = ITEMSIZE_SMALL

	tool_speed = 3 //You can use it in surgery. It's stupid, but you can.

	var/turf/start
	var/turf/end
	var/tape_type = /obj/item/barrier_tape_segment
	var/icon_base = "tape"

	var/apply_tape = FALSE

/obj/item/barrier_tape_roll/Initialize(mapload)
	. = ..()
	if(apply_tape)
		var/turf/T = get_turf(src)
		if(!T)
			return
		var/obj/machinery/door/door = locate(/obj/machinery/door) in T
		if((door == /obj/machinery/door/airlock) || (door == /obj/machinery/door/firedoor))
			afterattack(door, null, TRUE)
		return INITIALIZE_HINT_QDEL


var/list/image/hazard_overlays
var/list/tape_roll_applications = list()

/obj/item/barrier_tape_segment
	name = "tape"
	icon = 'icons/policetape.dmi'
	anchored = 1
	layer = WINDOW_LAYER
	var/lifted = 0
	var/crumpled = 0
	var/tape_dir = 0
	var/icon_base = "tape"

/obj/item/barrier_tape_segment/update_icon()
	//Possible directional bitflags: 0 (AIRLOCK), 1 (NORTH), 2 (SOUTH), 4 (EAST), 8 (WEST), 3 (VERTICAL), 12 (HORIZONTAL)
	switch (tape_dir)
		if(0)  // AIRLOCK
			icon_state = "[icon_base]_door_[crumpled]"
		if(3)  // VERTICAL
			icon_state = "[icon_base]_v_[crumpled]"
		if(12) // HORIZONTAL
			icon_state = "[icon_base]_h_[crumpled]"
		else   // END POINT (1|2|4|8)
			icon_state = "[icon_base]_dir_[crumpled]"
			dir = tape_dir

/obj/item/barrier_tape_segment/Initialize(mapload)
	. = ..()
	if(!hazard_overlays)
		hazard_overlays = list()
		hazard_overlays["[NORTH]"]	= new/image('icons/effects/warning_stripes.dmi', icon_state = "N")
		hazard_overlays["[EAST]"]	= new/image('icons/effects/warning_stripes.dmi', icon_state = "E")
		hazard_overlays["[SOUTH]"]	= new/image('icons/effects/warning_stripes.dmi', icon_state = "S")
		hazard_overlays["[WEST]"]	= new/image('icons/effects/warning_stripes.dmi', icon_state = "W")
	update_icon()

/obj/item/barrier_tape_roll/medical
	name = "medical tape"
	desc = "A roll of medical tape used to block off patients from the public."
	tape_type = /obj/item/barrier_tape_segment/medical
	color = COLOR_WHITE

/obj/item/barrier_tape_segment/medical
	name = "medical tape"
	desc = "A length of medical tape.  Do not cross."
	req_access = list(access_medical)
	color = COLOR_WHITE

/obj/item/barrier_tape_roll/police
	name = "police tape"
	desc = "A roll of police tape used to block off crime scenes from the public."
	tape_type = /obj/item/barrier_tape_segment/police
	color = COLOR_RED_LIGHT

/obj/item/barrier_tape_segment/police
	name = "police tape"
	desc = "A length of police tape.  Do not cross."
	req_access = list(access_security)
	color = COLOR_RED_LIGHT

/obj/item/barrier_tape_roll/engineering
	name = "engineering tape"
	desc = "A roll of engineering tape used to block off working areas from the public."
	tape_type = /obj/item/barrier_tape_segment/engineering
	color = COLOR_YELLOW

/obj/item/barrier_tape_roll/engineering/applied
	apply_tape = TRUE

/obj/item/barrier_tape_segment/engineering
	name = "engineering tape"
	desc = "A length of engineering tape. Better not cross it."
	req_one_access = list(access_engine,access_atmospherics)
	color = COLOR_YELLOW

/obj/item/barrier_tape_roll/atmos
	name = "atmospherics tape"
	desc = "A roll of atmospherics tape used to block off working areas from the public."
	tape_type = /obj/item/barrier_tape_segment/atmos
	color = COLOR_DEEP_SKY_BLUE

/obj/item/barrier_tape_segment/atmos
	name = "atmospherics tape"
	desc = "A length of atmospherics tape. Better not cross it."
	req_one_access = list(access_engine,access_atmospherics)
	color = COLOR_DEEP_SKY_BLUE

/obj/item/barrier_tape_roll/update_icon()
	cut_overlays()
	var/image/overlay = image(icon = src.icon)
	overlay.appearance_flags = RESET_COLOR
	if(ismob(loc))
		if(!start)
			overlay.icon_state = "start"
		else
			overlay.icon_state = "stop"
		add_overlay(overlay)


/obj/item/barrier_tape_roll/dropped(mob/user, flags, atom/newLoc)
	update_icon()
	return ..()

/obj/item/barrier_tape_roll/pickup(mob/user, flags, atom/oldLoc)
	update_icon()
	return ..()

/obj/item/barrier_tape_roll/attack_hand()
	update_icon()
	return ..()

/obj/item/barrier_tape_roll/attack_self(mob/user as mob)
	if(!start)
		start = get_turf(src)
		to_chat(user, "<span class='notice'>You place the first end of \the [src].</span>")
		update_icon()
	else
		end = get_turf(src)
		if(start.y != end.y && start.x != end.x || start.z != end.z)
			start = null
			update_icon()
			to_chat(user, "<span class='notice'>\The [src] can only be laid horizontally or vertically.</span>")
			return

		if(start == end)
			// spread tape in all directions, provided there is a wall/window
			var/turf/T
			var/possible_dirs = 0
			for(var/dir in GLOB.cardinal)
				T = get_step(start, dir)
				if(T && T.density)
					possible_dirs |= dir
				else
					for(var/obj/structure/window/W in T)
						if(W.is_fulltile() || W.dir == GLOB.reverse_dir[dir])
							possible_dirs |= dir
			for(var/obj/structure/window/window in start)
				if(istype(window) && !window.is_fulltile())
					possible_dirs |= window.dir
			if(!possible_dirs)
				start = null
				update_icon()
				to_chat(user, "<span class='notice'>You can't place \the [src] here.</span>")
				return
			if(possible_dirs & (NORTH|SOUTH))
				var/obj/item/barrier_tape_segment/TP = new tape_type(start)
				for(var/dir in list(NORTH, SOUTH))
					if (possible_dirs & dir)
						TP.tape_dir += dir
				TP.update_icon()
			if(possible_dirs & (EAST|WEST))
				var/obj/item/barrier_tape_segment/TP = new tape_type(start)
				for(var/dir in list(EAST, WEST))
					if (possible_dirs & dir)
						TP.tape_dir += dir
				TP.update_icon()
			start = null
			update_icon()
			to_chat(user, "<span class='notice'>You finish placing \the [src].</span>")
			return

		var/turf/cur = start
		var/orientation = get_dir(start, end)
		var/dir = 0
		switch(orientation)
			if(NORTH, SOUTH)	dir = NORTH|SOUTH	// North-South taping
			if(EAST,   WEST)	dir =  EAST|WEST	// East-West taping

		var/can_place = 1
		while (can_place)
			if(cur.density == 1)
				can_place = 0
			else if (istype(cur, /turf/space))
				can_place = 0
			else
				for(var/obj/O in cur)
					if(istype(O, /obj/structure/window))
						var/obj/structure/window/window = O
						if(window.is_fulltile())
							can_place = 0
							break
						if(cur == start)
							if(window.dir == orientation)
								can_place = 0
								break
							else
								continue
						else if(cur == end)
							if(window.dir == GLOB.reverse_dir[orientation])
								can_place = 0
								break
							else
								continue
						else if (window.dir == GLOB.reverse_dir[orientation] || window.dir == orientation)
							can_place = 0
							break
						else
							continue
					if(O.density)
						can_place = 0
						break
			if(cur == end)
				break
			cur = get_step_towards(cur,end)
		if (!can_place)
			start = null
			update_icon()
			to_chat(user, "<span class='warning'>You can't run \the [src] through that!</span>")
			return

		cur = start
		var/tapetest
		var/tape_dir
		while (1)
			tapetest = 0
			tape_dir = dir
			if(cur == start)
				var/turf/T = get_step(start, GLOB.reverse_dir[orientation])
				if(T && !T.density)
					tape_dir = orientation
					for(var/obj/structure/window/W in T)
						if(W.is_fulltile() || W.dir == orientation)
							tape_dir = dir
				for(var/obj/structure/window/window in cur)
					if(istype(window) && !window.is_fulltile() && window.dir == GLOB.reverse_dir[orientation])
						tape_dir = dir
			else if(cur == end)
				var/turf/T = get_step(end, orientation)
				if(T && !T.density)
					tape_dir = GLOB.reverse_dir[orientation]
					for(var/obj/structure/window/W in T)
						if(W.is_fulltile() || W.dir == GLOB.reverse_dir[orientation])
							tape_dir = dir
				for(var/obj/structure/window/window in cur)
					if(istype(window) && !window.is_fulltile() && window.dir == orientation)
						tape_dir = dir
			for(var/obj/item/barrier_tape_segment/T in cur)
				if((T.tape_dir == tape_dir) && (T.icon_base == icon_base))
					tapetest = 1
					break
			if(!tapetest)
				var/obj/item/barrier_tape_segment/T = new tape_type(cur)
				T.tape_dir = tape_dir
				T.update_icon()
				if(tape_dir & SOUTH)
					T.layer += 0.1 // Must always show above other tapes
			if(cur == end)
				break
			cur = get_step_towards(cur,end)
		start = null
		update_icon()
		to_chat(user, "<span class='notice'>You finish placing \the [src].</span>")
		return

/obj/item/barrier_tape_roll/afterattack(var/atom/A, mob/user as mob, proximity)
	if(!proximity)
		return

	if (istype(A, /obj/machinery/door))
		var/turf/T = get_turf(A)
		if(locate(/obj/item/barrier_tape_segment, A.loc))
			to_chat(user, "There's already tape over that door!")
		else
			var/obj/item/barrier_tape_segment/P = new tape_type(T)
			P.update_icon()
			P.layer = WINDOW_LAYER
			to_chat(user, "<span class='notice'>You finish placing \the [src].</span>")

	if (istype(A, /turf/simulated/floor) ||istype(A, /turf/unsimulated/floor))
		var/turf/F = A
		var/direction = user.loc == F ? user.dir : turn(user.dir, 180)
		var/icon/hazard_overlay = hazard_overlays["[direction]"]
		if(tape_roll_applications[F] == null)
			tape_roll_applications[F] = 0

		if(tape_roll_applications[F] & direction) // hazard_overlay in F.overlays wouldn't work.
			user.visible_message("\The [user] uses the adhesive of \the [src] to remove area markings from \the [F].", "You use the adhesive of \the [src] to remove area markings from \the [F].")
			F.cut_overlay(hazard_overlay)
			tape_roll_applications[F] &= ~direction
		else
			user.visible_message("\The [user] applied \the [src] on \the [F] to create area markings.", "You apply \the [src] on \the [F] to create area markings.")
			F.add_overlay(hazard_overlay)
			tape_roll_applications[F] |= direction
		return

/obj/item/barrier_tape_segment/proc/crumple()
	if(!crumpled)
		crumpled = 1
		update_icon()
		name = "crumpled [name]"

/obj/item/barrier_tape_segment/Crossed(atom/movable/AM, oldloc)
	. = ..()
	if(!lifted && isliving(AM))
		var/mob/living/M = AM //so that ghosts don't get spammed
		add_fingerprint(M)
		if(!allowed(M))	//only select few learn art of not crumpling the tape
			to_chat(M, SPAN_WARNING( "You are not supposed to go past \the [src]..."))
			if(M.a_intent == INTENT_HELP && !(istype(M, /mob/living/simple_mob)))
				return FALSE
			crumple()

/obj/item/barrier_tape_segment/attackby(obj/item/W as obj, mob/user as mob)
	breaktape(user)

/obj/item/barrier_tape_segment/attack_hand(mob/user as mob)
	if (user.a_intent == INTENT_HELP && src.allowed(user))
		user.show_viewers("<span class='notice'>\The [user] lifts \the [src], allowing passage.</span>")
		for(var/obj/item/barrier_tape_segment/T in gettapeline())
			T.lift(100) //~10 seconds
	else
		breaktape(user)

/obj/item/barrier_tape_segment/proc/lift(time)
	lifted = 1
	plane = MOB_PLANE
	layer = ABOVE_MOB_LAYER
	spawn(time)
		lifted = 0
		reset_plane_and_layer()

// Returns a list of all tape objects connected to src, including itself.
/obj/item/barrier_tape_segment/proc/gettapeline()
	var/list/dirs = list()
	if(tape_dir & NORTH)
		dirs += NORTH
	if(tape_dir & SOUTH)
		dirs += SOUTH
	if(tape_dir & WEST)
		dirs += WEST
	if(tape_dir & EAST)
		dirs += EAST

	var/list/obj/item/barrier_tape_segment/tapeline = list()
	for (var/obj/item/barrier_tape_segment/T in get_turf(src))
		tapeline += T
	for(var/dir in dirs)
		var/turf/cur = get_step(src, dir)
		var/not_found = 0
		while (!not_found)
			not_found = 1
			for (var/obj/item/barrier_tape_segment/T in cur)
				tapeline += T
				not_found = 0
			cur = get_step(cur, dir)
	return tapeline

/obj/item/barrier_tape_segment/proc/breaktape(mob/user)
	if(user.a_intent == INTENT_HELP)
		to_chat(user, "<span class='warning'>You refrain from breaking \the [src].</span>")
		return
	user.visible_message("<span class='notice'>\The [user] breaks \the [src]!</span>","<span class='notice'>You break \the [src].</span>")

	for (var/obj/item/barrier_tape_segment/T in gettapeline())
		if(T == src)
			continue
		if(T.tape_dir & get_dir(T, src))
			qdel(T)

	qdel(src) //TODO: Dropping a trash item holding fibers/fingerprints of all broken tape parts
	return
