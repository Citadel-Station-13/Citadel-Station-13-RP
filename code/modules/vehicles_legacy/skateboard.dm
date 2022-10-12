// TODO: port to modern vehicles. If you're in this file, STOP FUCKING WITH IT AND PORT IT OVER.
/obj/vehicle_old/skateboard
	name = "skaetbord"
	desc = "You shouldn't be seeing this. Contact an Admin."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "skateboard"

	mechanical = FALSE // If false, doesn't care for things like cells, engines, EMP, keys, etc.
	health = 100	//do not forget to set health for your vehicle!
	maxhealth = 100
	charge_use = 0
	move_delay = 1.5	//set this to limit the speed of the vehicle

	mob_offset_y = 4		//pixel_y offset for mob overlay

	anchored = FALSE
	density = FALSE

	var/datum/effect_system/spark_spread/sparks
	var/grinding = FALSE
	var/next_crash
	var/board_icon = "skateboard"
	var/board_item_type = null
	var/rough_terrain = FALSE

/obj/vehicle_old/skateboard/Initialize(mapload)
	. = ..()
	sparks = new
	sparks.set_up(1, 0, src)
	sparks.attach(src)

/obj/vehicle_old/skateboard/Destroy()
	if(sparks)
		QDEL_NULL(sparks)
	. = ..()

/obj/vehicle_old/skateboard/load(var/atom/movable/C, var/mob/user as mob)
	var/mob/living/M = C
	if(!istype(C)) return 0
	if(M.buckled || M.restrained() || !Adjacent(M) || !M.Adjacent(src))
		return 0
	return ..(M, user)

/obj/vehicle_old/skateboard/MouseDroppedOnLegacy(var/atom/movable/C, var/mob/user as mob)
	if(!load(C, user))
		to_chat(user, "<span class='warning'> You were unable to load \the [C] onto \the [src].</span>")
		return

/obj/vehicle_old/skateboard/attack_hand(var/mob/user as mob)
	if(user == load)
		unbuckle_mob(load, user)
		to_chat(user, "You unbuckle yourself from \the [src].")
	else if(!load && load(user, user))
		to_chat(user, "You buckle yourself to \the [src].")

/obj/vehicle_old/skateboard/relaymove(mob/user, direction)
	if(user != load || grinding || world.time < next_crash)
		return 0
	if(Move(get_step(src, direction), direction))
		return 0
	return 0

/obj/vehicle_old/skateboard/Move(var/turf/destination, var/mob/living/H)
	if(istype(destination,/turf/space) || istype (destination,/turf/simulated/floor/water) || istype(destination,/turf/simulated/floor/outdoors))
		rough_terrain = TRUE
		return 1
	else
		rough_terrain = FALSE
	return ..()

/obj/vehicle_old/skateboard/mob_buckled(mob/M, flags, mob/user, semantic)
	. = ..()
	density = TRUE

/obj/vehicle_old/skateboard/mob_unbuckled(mob/M, flags, mob/user, semantic)
	. = ..()
	if(!has_buckled_mobs(M))
		density = FALSE

/obj/vehicle_old/skateboard/Bump(atom/A)
	if(A.density && has_buckled_mobs())
		var/mob/living/H = buckled_mobs[1]
		playsound(src, 'sound/effects/bang.ogg', 40, TRUE)
		if(!iscarbon(H) || grinding || world.time < next_crash|| prob(60))
			var/list/throw_dirs = list(1, 2, 4, 8, 5, 6, 9, 10)
			var/turf/T2 = get_step(A, pick(throw_dirs))
			unload(H)
			H.throw_at_old(T2, 1, 1, src)
			var/head_slot = SLOT_HEAD
			if(!head_slot || !(istype(head_slot,/obj/item/clothing/head/helmet) || istype(head_slot,/obj/item/clothing/head/hardhat)))
				H.setBrainLoss(2,5)
				H.updatehealth()
			visible_message("<span class='danger'>[src] crashes into [A], sending [H] flying!</span>")
			H.Weaken(12)
		else if (rough_terrain)
			var/list/throw_dirs = list(1, 2, 4, 8, 5, 6, 9, 10)
			var/turf/T2 = get_step(A, pick(throw_dirs))
			unload(H)
			H.throw_at_old(T2, 1, 1, src)
			var/head_slot = SLOT_HEAD
			if(!head_slot || !(istype(head_slot,/obj/item/clothing/head/helmet) || istype(head_slot,/obj/item/clothing/head/hardhat)))
				H.setBrainLoss(2,5)
				H.updatehealth()
			visible_message("<span class='danger'>[src] crashes into [A], sending [H] flying!</span>")
			H.Weaken(12)
		else
			var/backdir = turn(dir, 180)
			Move(backdir)
			H.spin(4, 1)
	next_crash = world.time + 10

/* // Putting this in for reference if I want the door to open later.
/obj/vehicle_old/train/security/engine/Bump(atom/Obstacle)
	var/obj/machinery/door/D = Obstacle
	var/mob/living/carbon/human/H = load
	if(istype(D) && istype(H))
		D.Bumped(H)		//a little hacky, but hey, it works, and respects access rights

	..()
*/

///Moves the vehicle forward and if it lands on a table, repeats
/obj/vehicle_old/skateboard/proc/grind()
	Move(dir)
	if(has_buckled_mobs() && locate(/obj/structure/table) in loc.contents)
		var/mob/living/L = buckled_mobs[1]
		if (prob (15))
			playsound(src, 'sound/effects/bang.ogg', 20, TRUE)
			unbuckle_mob(L)
			var/atom/throw_target = get_edge_target_turf(src)
			L.throw_at_old(throw_target, 2, 2)
			visible_message("<span class='danger'>[L] loses their footing and slams on the ground!</span>")
			L.Weaken(40)
			grinding = FALSE
			icon_state = board_icon
			return
		else
			playsound(src, 'sound/weapons/skateboard_ollie.ogg', 50, TRUE)
			if(prob (50))
				sparks.start() //the most radical way to start plasma fires
			addtimer(CALLBACK(src, .proc/grind), 2)
			return
	else
		grinding = FALSE
		icon_state = board_icon

/obj/vehicle_old/skateboard/OnMouseDropLegacy(atom/over_object)
	. = ..()
	var/mob/living/carbon/M = usr
	if(!istype(M) || M.incapacitated() || !Adjacent(M))
		return
	if(has_buckled_mobs() && over_object == M)
		to_chat(M, "<span class='warning'>You can't lift this up when somebody's on it.</span>")
		return
	if(over_object == M)
		var/board = new board_item_type(get_turf(M))
		M.put_in_hands(board)
		qdel(src)

/* //I've got little code context for these. Gonna leave it commented out until I can translate it in depth, or rewrite it.
//The moves!

/datum/action/vehicle/skateboard/verb/ollie()
	name = "Ollie"
	desc = "Get some air! Land on a table to do a gnarly grind."
	///Cooldown to next jump
	var/next_ollie

/datum/action/vehicle/skateboard/ollie/Trigger()
	if(world.time > next_ollie)
		var/obj/vehicle_old/skateboard/V = vehicle_target
		if (V.grinding)
			return
		var/mob/living/L = owner
		var/turf/landing_turf = get_step(V.loc, V.dir)
		L.adjustStaminaLoss(V.instability*2)
		if (L.getStaminaLoss() >= 100)
			playsound(src, 'sound/effects/bang.ogg', 20, TRUE)
			V.unbuckle_mob(L)
			L.throw_at_old(landing_turf, 2, 2)
			L.Knockdown(40)
			V.visible_message("<span class='danger'>[L] misses the landing and falls on [L.p_their()] face!</span>")
		else
			L.spin(4, 1)
			animate(L, pixel_y = -6, time = 4)
			animate(V, pixel_y = -6, time = 3)
			playsound(V, 'sound/vehicles/skateboard_ollie.ogg', 50, TRUE)
			pass_table_on(L, VEHICLE_TRAIT)
			V.pass_flags |= ATOM_PASS_TABLE
			L.Move(landing_turf, vehicle_target.dir)
			pass_table_off(L, VEHICLE_TRAIT)
			V.pass_flags &= ~ATOM_PASS_TABLE
		if(locate(/obj/structure/table) in V.loc.contents)
			V.grinding = TRUE
			V.icon_state = "[V.board_icon]-grind"
			addtimer(CALLBACK(V, /obj/vehicle_old/skateboard/.proc/grind), 2)
		next_ollie = world.time + 5
*/

//Subsets

/obj/vehicle_old/skateboard/improv
	name = "improvised skateboard"
	desc = "A crude assembly which can only barely be called a skateboard. It's still rideable, but probably unsafe. Looks like you'll need to add a few rods to make handlebars."
	board_item_type = /obj/item/melee/skateboard/improv
	icon_state = "skateboard"
	board_icon = "skateboard"

/obj/vehicle_old/skateboard/beginner
	name = "skateboard"
	desc = "A XTREME SPORTZ brand skateboard for beginners. Ages 8 and up."
	board_item_type = /obj/item/melee/skateboard/beginner
	icon_state = "skateboard"
	board_icon = "skateboard"

/obj/vehicle_old/skateboard/pro
	name = "skateboard"
	desc = "A RaDSTORMz brand professional skateboard. Looks a lot more stable than the average board."
	board_item_type = /obj/item/melee/skateboard/pro
	icon_state = "skateboard2"
	board_icon = "skateboard2"
	move_delay = 1

/*
/obj/vehicle_old/skateboard/pro/Bump(atom/A)
	if(A.density && has_buckled_mobs())
		var/mob/living/H = buckled_mobs[1]
		playsound(src, 'sound/effects/bang.ogg', 40, TRUE)
		if(!iscarbon(H) || grinding || world.time < next_crash|| prob(30))
			var/list/throw_dirs = list(1, 2, 4, 8, 5, 6, 9, 10)
			var/turf/T2 = get_step(A, pick(throw_dirs))
			unload(H)
			H.throw_at_old(T2, 1, 1, src)
			var/head_slot = SLOT_HEAD
			if(!head_slot || !(istype(head_slot,/obj/item/clothing/head/helmet) || istype(head_slot,/obj/item/clothing/head/hardhat)))
				H.setBrainLoss(2,5)
				H.updatehealth()
			visible_message("<span class='danger'>[src] crashes into [A], sending [H] flying!</span>")
			H.Weaken(12)
		else if (rough_terrain || prob(70))
			var/list/throw_dirs = list(1, 2, 4, 8, 5, 6, 9, 10)
			var/turf/T2 = get_step(A, pick(throw_dirs))
			unload(H)
			H.throw_at_old(T2, 1, 1, src)
			var/head_slot = SLOT_HEAD
			if(!head_slot || !(istype(head_slot,/obj/item/clothing/head/helmet) || istype(head_slot,/obj/item/clothing/head/hardhat)))
				H.setBrainLoss(2,5)
				H.updatehealth()
			visible_message("<span class='danger'>[src] crashes into [A], sending [H] flying!</span>")
			H.Weaken(12)
		else
			var/backdir = turn(dir, 180)
			Move(backdir)
			H.spin(4, 1)
	next_crash = world.time + 10
*/
// who the fuck wrote this
// this doesn't even fucking work

//Hoverboards

/obj/vehicle_old/skateboard/hoverboard
	name = "hoverboard"
	desc = "A blast from the past, so retro!"
	board_item_type = /obj/item/melee/skateboard/hoverboard
	icon_state = "hoverboard_red"
	board_icon = "hoverboard_red"
	move_delay = 0

/obj/vehicle_old/skateboard/hoverboard/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/stack/rods))
		return
	else if(istype(I, /obj/item/tool/screwdriver))
		return
	else
		return ..()

/obj/vehicle_old/skateboard/hoverboard/Move(var/turf/destination, var/mob/living/H)
	if(istype(destination,/turf/space) || istype (destination,/turf/simulated/floor/water) || istype(destination,/turf/simulated/floor/outdoors))
		rough_terrain = FALSE
		return 0
	else
		rough_terrain = FALSE
	return ..()

/obj/vehicle_old/skateboard/hoverboard/Bump(atom/A)
	if(A.density && has_buckled_mobs())
		var/mob/living/H = buckled_mobs[1]
		playsound(src, 'sound/effects/bang.ogg', 40, TRUE)
		if(!iscarbon(H) || grinding || world.time < next_crash|| prob(10))
			var/list/throw_dirs = list(1, 2, 4, 8, 5, 6, 9, 10)
			var/turf/T2 = get_step(A, pick(throw_dirs))
			unload(H)
			H.throw_at_old(T2, 1, 1, src)
			var/head_slot = SLOT_HEAD
			if(!head_slot || !(istype(head_slot,/obj/item/clothing/head/helmet) || istype(head_slot,/obj/item/clothing/head/hardhat)))
				H.setBrainLoss(2,5)
				H.updatehealth()
			visible_message("<span class='danger'>[src] crashes into [A], sending [H] flying!</span>")
			H.Weaken(12)
		else
			var/backdir = turn(dir, 180)
			Move(backdir)
			H.spin(4, 1)
	next_crash = world.time + 10

/obj/vehicle_old/skateboard/hoverboard/admin
	name = "\improper Board Of Directors"
	desc = "The engineering complexity of a spaceship concentrated inside of a board. Just as expensive, too."
	board_item_type = /obj/item/melee/skateboard/hoverboard/admin
	icon_state = "hoverboard_nt"
	board_icon = "hoverboard_nt"
	move_delay = -1

/obj/vehicle_old/skateboard/hoverboard/admin/Bump(atom/A)
	if(A.density && has_buckled_mobs())
		var/mob/living/H = buckled_mobs[1]
		playsound(src, 'sound/effects/bang.ogg', 40, TRUE)
		if(!iscarbon(H) || grinding || world.time < next_crash|| prob(1))
			var/list/throw_dirs = list(1, 2, 4, 8, 5, 6, 9, 10)
			var/turf/T2 = get_step(A, pick(throw_dirs))
			unload(H)
			H.throw_at_old(T2, 1, 1, src)
			var/head_slot = SLOT_HEAD
			if(!head_slot || !(istype(head_slot,/obj/item/clothing/head/helmet) || istype(head_slot,/obj/item/clothing/head/hardhat)))
				H.setBrainLoss(2,5)
				H.updatehealth()
			visible_message("<span class='danger'>[src] crashes into [A], sending [H] flying!</span>")
			H.Weaken(12)
		else
			var/backdir = turn(dir, 180)
			Move(backdir)
			H.spin(4, 1)
	next_crash = world.time + 10

//Construction Items

/obj/item/skate_wheels
	name = "rubberized wheels"
	desc = "These rubberized wheels encase ball bearings which ensure a smooth rotation. They could possibly be mounted on an appropriate frame."
	icon_state = "skate_wheels"

/obj/item/skateboard_frame
	name = "skateboard frame"
	desc = "This roughly shaped board of flexible steel seems like it could be used to travel in style. It's just missing something..."
	icon = 'icons/obj/items.dmi'
	icon_state = "skate_assembly0"
	force = 3.0
	throw_force = 3.0
	throw_speed = 2
	throw_range = 5
	w_class = ITEMSIZE_NORMAL
	var/build_step = 0

/obj/item/heavy_skateboard_frame
	name = "reinforced skateboard frame"
	desc = "This bulky board of reinforced steel seems like it could be used to travel in radical style. It's just missing something..."
	icon = 'icons/obj/items.dmi'
	icon_state = "skate_assembly0"
	force = 6.0
	throw_force = 6.0
	throw_speed = 2
	throw_range = 4
	w_class = ITEMSIZE_NORMAL
	var/build_step = 0

//Basic Board Construction

/obj/item/skateboard_frame/attackby(var/obj/item/W as obj, var/mob/user)
	..()

	switch(build_step)
		if(0)
			if(istype(W, /obj/item/stack/material/steel))
				var/obj/item/stack/material/steel/M = W
				if(M.amount >= 10)
					M.use(10)
					build_step++
					to_chat(user, "<span class='notice'>You use \the [W] to fashion trucks for \the [src].</span>")
					name = "skateboard frame (loose trucks)"
					icon_state = "skate_assembly1"

		if(1)
			if(istype(W, /obj/item/tool/wrench))
				build_step++
				name = "skateboard frame (tight trucks)"
				to_chat(user, "<span class='notice'>You tighten the trucks onto \the [src].</span>")
				playsound(src, 'sound/items/ratchet.ogg', 40, TRUE)

		if(2)
			if(istype(W, /obj/item/stack/material/plastic))
				var/obj/item/stack/material/steel/M = W
				if(M.amount >= 5)
					M.use(5)
					build_step++
					to_chat(user, "<span class='notice'>You secure the plastic grip sheeting to \the [src].</span>")
					name = "skateboard frame (grip sheeting)"
					icon_state = "skate_assembly2"

		if(3)
			if(istype(W, /obj/item/skate_wheels))
				if(!user.attempt_consume_item_for_construction(W))
					return
				build_step++
				to_chat(user, "<span class='notice'>You mount \the [W] on \the [src] trucks.</span>")
				name = "skateboard frame (loose wheels)"
				icon_state = "skate_assembly3"

		if(4)
			if(istype(W, /obj/item/tool/wrench))
				build_step++
				name = "skateboard frame (tight wheels)"
				to_chat(user, "<span class='notice'>You tighten the wheels onto \the [src] trucks.</span>")
				playsound(src, 'sound/items/ratchet.ogg', 40, TRUE)

		if(5)
			if(istype(W, /obj/item/tool/screwdriver))
				build_step++
				to_chat(user, "<span class='notice'>You complete the skateboard assembly.</span>")
				playsound(src, 'sound/items/screwdriver.ogg', 40, TRUE)
				var/turf/T = get_turf(src)
				new /obj/vehicle_old/skateboard/improv(T)
				qdel(src)

//Pro Board

/obj/item/heavy_skateboard_frame/attackby(var/obj/item/W as obj, var/mob/user)
	..()

	switch(build_step)
		if(0)
			if(istype(W, /obj/item/stack/material/steel))
				var/obj/item/stack/material/steel/M = W
				if(M.amount >= 10)
					M.use(10)
					build_step++
					to_chat(user, "<span class='notice'>You use \the [W] to fashion trucks for \the [src].</span>")
					name = "skateboard frame (loose trucks)"
					icon_state = "skate_assembly1"

		if(1)
			if(istype(W, /obj/item/tool/wrench))
				build_step++
				name = "skateboard frame (tight trucks)"
				to_chat(user, "<span class='notice'>You tighten the trucks onto \the [src].</span>")
				playsound(src, 'sound/items/ratchet.ogg', 40, TRUE)

		if(2)
			if(istype(W, /obj/item/stack/rods))
				var/obj/item/stack/material/steel/M = W
				if(M.amount >= 10)
					M.use(10)
					build_step++
					to_chat(user, "<span class='notice'>You use \the [W] to enhance \the [src] frame.</span>")
					name = "skateboard frame (enhanced frame)"

		if(3)
			if(istype(W, /obj/item/stack/material/plastic))
				var/obj/item/stack/material/steel/M = W
				if(M.amount >= 5)
					M.use(5)
					build_step++
					to_chat(user, "<span class='notice'>You secure the reinforced plastic grip sheeting to \the [src].</span>")
					name = "skateboard frame (grip sheeting)"
					icon_state = "skate_rassembly2"

		if(4)
			if(istype(W, /obj/item/skate_wheels))
				if(!user.attempt_consume_item_for_construction(W))
					return
				build_step++
				to_chat(user, "<span class='notice'>You mount \the [W] on \the [src] trucks.</span>")
				name = "skateboard frame (loose wheels)"
				icon_state = "skate_rassembly3"

		if(5)
			if(istype(W, /obj/item/tool/wrench))
				build_step++
				name = "skateboard frame (tight wheels)"
				to_chat(user, "<span class='notice'>You tighten the wheels onto \the [src] trucks.</span>")
				playsound(src, 'sound/items/ratchet.ogg', 40, TRUE)

		if(6)
			if(istype(W, /obj/item/tool/screwdriver))
				build_step++
				to_chat(user, "<span class='notice'>You complete the skateboard assembly.</span>")
				playsound(src, 'sound/items/screwdriver.ogg', 40, TRUE)
				var/turf/T = get_turf(src)
				new /obj/vehicle_old/skateboard/pro(T)
				qdel(src)

// Scooters

/obj/vehicle_old/skateboard/scooter
	name = "scooter"
	desc = "A fun way to get around."
	icon_state = "scooter"
	board_item_type = /obj/item/melee/skateboard/scooter

/obj/vehicle_old/skateboard/scooter/Initialize(mapload)
	. = ..()

/obj/vehicle_old/skateboard/scooter/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/tool/wrench))
		to_chat(user, "<span class='notice'>You begin to remove the handlebars...</span>")
		var/obj/vehicle_old/skateboard/S = new(drop_location())
		new /obj/item/stack/rods(drop_location(), 2)
		to_chat(user, "<span class='notice'>You remove the handlebars from [src].</span>")
		if(has_buckled_mobs())
			var/mob/living/carbon/H = buckled_mobs[1]
			unbuckle_mob(H)
			S.buckle_mob(H)
		qdel(src)

/obj/vehicle_old/skateboard/scooter/Moved()
	. = ..()

//CONSTRUCTION

/obj/item/scooter_frame
	name = "scooter frame"
	desc = "A metal frame for building a scooter. Looks like you'll need to add some metal to make wheels."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "scooter_frame"
	w_class = WEIGHT_CLASS_NORMAL
	var/build_step = 0

/obj/item/scooter_frame/attackby(var/obj/item/W as obj, var/mob/user)
	..()

	switch(build_step)
		if(0)
			if(istype(W, /obj/item/stack/rods))
				var/obj/item/stack/material/steel/M = W
				if(M.amount >= 2)
					M.use(2)
					build_step++
					to_chat(user, "<span class='notice'>You attach handlebars to \the [src].</span>")
					name = "scooter frame (handlebars)"

		if(1)
			if(istype(W, /obj/item/skate_wheels))
				if(!user.attempt_consume_item_for_construction(W))
					return
				build_step++
				to_chat(user, "<span class='notice'>You install \the [W] on \the [src].</span>")
				name = "scooter frame (loose wheels)"

		if(2)
			if(istype(W, /obj/item/tool/screwdriver))
				build_step++
				to_chat(user, "<span class='notice'>You complete the skateboard assembly.</span>")
				playsound(src, 'sound/items/screwdriver.ogg', 40, TRUE)
				var/turf/T = get_turf(src)
				new /obj/vehicle_old/skateboard/scooter(T)
				qdel(src)

//Decontstruction

/obj/item/scooter_frame/attackby(obj/item/W, mob/user)
	. = ..()
	if(istype(W, /obj/item/tool/wrench))
		to_chat(user, "<span class='notice'>You deconstruct \the [src].</span>")
		new /obj/item/stack/rods(drop_location(), 10)
		playsound(src, 'sound/items/ratchet.ogg', 40, TRUE)
		qdel(src)
	return

/obj/vehicle_old/skateboard/scooter/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/tool/screwdriver))
		to_chat(user, "<span class='notice'>You uninstall the wheels and handlebars from \the [src].</span>")
		new /obj/item/stack/rods(drop_location(), 2)
		new /obj/item/stack/material/plastic(drop_location(), 6)
		var/turf/T = get_turf(src)
		new /obj/item/scooter_frame(T)
		qdel(src)
	if(has_buckled_mobs())
		var/mob/living/carbon/H = buckled_mobs[1]
		unbuckle_mob(H)
	return

/*
//Look at this atrocity. Stowing this for later, most definitely.

//Wheelys
/obj/vehicle_old/ridden/scooter/wheelys
	name = "Wheely-Heels"
	desc = "Uses patented retractable wheel technology. Never sacrifice speed for style - not that this provides much of either."
	icon = null
	density = FALSE

/obj/vehicle_old/ridden/scooter/wheelys/Initialize(mapload)
	. = ..()
	var/datum/component/riding/D = LoadComponent(/datum/component/riding)
	D.vehicle_move_delay = 1
	D.set_vehicle_dir_layer(SOUTH, ABOVE_MOB_LAYER)
	D.set_vehicle_dir_layer(NORTH, OBJ_LAYER)
	D.set_vehicle_dir_layer(EAST, OBJ_LAYER)
	D.set_vehicle_dir_layer(WEST, OBJ_LAYER)

/obj/vehicle_old/ridden/scooter/wheelys/post_unbuckle_mob(mob/living/M)
	if(!has_buckled_mobs())
		to_chat(M, "<span class='notice'>You pop the Wheely-Heel's wheels back into place.</span>")
		moveToNullspace()
	return ..()

/obj/vehicle_old/ridden/scooter/wheelys/post_buckle_mob(mob/living/M)
	to_chat(M, "<span class='notice'>You pop out the Wheely-Heel's wheels.</span>")
	return ..()

/obj/vehicle_old/ridden/scooter/wheelys/Bump(atom/A)
	. = ..()
	if(A.density && has_buckled_mobs())
		var/mob/living/H = buckled_mobs[1]
		var/atom/throw_target = get_edge_target_turf(H, pick(GLOB.cardinals))
		unbuckle_mob(H)
		H.throw_at_old(throw_target, 4, 3)
		H.DefaultCombatKnockdown(30)
		H.adjustStaminaLoss(30)
		var/head_slot = H.get_item_by_slot(SLOT_HEAD)
		if(!head_slot || !(istype(head_slot,/obj/item/clothing/head/helmet) || istype(head_slot,/obj/item/clothing/head/hardhat)))
			H.adjustOrganLoss(ORGAN_SLOT_BRAIN, 1)
			H.updatehealth()
		visible_message("<span class='danger'>[src] crashes into [A], sending [H] flying!</span>")
		playsound(src, 'sound/effects/bang.ogg', 50, 1)
*/
