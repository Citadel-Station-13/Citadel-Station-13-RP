/obj/vehicle/ridden/skateboard
	name = "The essence of tony hawk"
	desc = "You shouldn't be seeing this. Contact an Admin."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "skateboard"
	density = FALSE
	integrity = 100
	integrity_max = 100
	movedelay = 1.5
	riding_handler_type = /datum/component/riding_handler/vehicle/ridden/skateboard

	var/board_item_type
	var/next_crash
	var/rough_terrain

/datum/component/riding_handler/vehicle/ridden/skateboard
	rider_offsets = list(
		list(
			list(0, 4, 0.1, 4),
			list(0, 4, 0.1, 2),
			list(0, 4, 0.1, 8),
			list(0, 4, 0.1, 1)
		)
	)
	rider_offset_format = CF_RIDING_OFFSETS_ENUMERATED
	rider_check_flags = list(CF_RIDING_CHECK_ARMS,
	CF_RIDING_CHECK_RESTRAINED,
	CF_RIDING_CHECK_UNCONSCIOUS,
	CF_RIDING_CHECK_INCAPACITATED
	)
	riding_handler_flags = list(CF_RIDING_HANDLER_ALLOW_BORDER,
	CF_RIDING_HANDLER_IS_CONTROLLABLE)

	vehicle_move_delay = 1
	allowed_turf_types = list(
		/turf/simulated,
		/turf/unsimulated
	)

//Running into things tosses you like salad.
/obj/vehicle/ridden/skateboard/Bump(atom/A)
	//If a board shreds in the forest. And a man isn't there to hear. Does it make a sound? No.
	if(!(A.density && occupant_amount()))
		return

	var/mob/living/H = occupants[1]
	playsound(src, 'sound/effects/bang.ogg', 40, TRUE)
	if(!iscarbon(H) || /*grinding ||*/ world.time < next_crash || prob(60) || rough_terrain)
		unbuckle_mob(H)
		H.throw_at_random(FALSE, 2, 2)

		//Surface injuries
		H.adjustBruteLoss(rand(3, 5))
		//Check if victim is wearing a helmet. If not 5% chance for severe drain bamage, 95% for minor brain bramage.
		if(!SLOT_HEAD || !(istype(SLOT_HEAD,/obj/item/clothing/head/helmet) || istype(SLOT_HEAD,/obj/item/clothing/head/hardhat)))
			if(prob(5))
				var/obj/item/organ/external/egg = H.get_organ(BP_HEAD)
				egg?.fracture()
				H.adjustBrainLoss(rand(5, 10))
				H.afflict_paralyze(20 * 10)
				visible_message("<span class='danger'>[src] crashes into [A], sending [H] flying! They land on their head, that doesn't look good...</span>")
			else
				H.adjustBrainLoss(rand(1, 2))
				visible_message("<span class='danger'>[src] crashes into [A], sending [H] flying!</span>")
			H.update_health()
		H.afflict_paralyze(20*2)
	else
		Move(get_step(src, turn(dir, 180)))
		H.spin(4, 1)
	next_crash = world.time + 10

// Drag the board onto yourself to pick it up. Converts it to an item defined in board_item_type.
/obj/vehicle/ridden/skateboard/OnMouseDrop(atom/over, mob/user, proximity, params)
	. = ..()
	if(!istype(user) || user.incapacitated() || !proximity)
		return
	if(has_buckled_mobs() && over == user)
		to_chat(user, "<span class='warning'>You can't lift this up when somebody's on it.</span>")
		return
	if(over == user)
		var/board = new board_item_type(get_turf(user))
		user.put_in_hands(board)
		qdel(src)




// ----Skateboards----
/obj/vehicle/ridden/skateboard/improv
	name = "improvised skateboard"
	desc = "A crude assembly which can only barely be called a skateboard. It's still rideable, but probably unsafe. Looks like you'll need to add a few rods to make handlebars."
	board_item_type = /obj/item/melee/skateboard/improv
	icon_state = "skateboard"

/obj/vehicle/ridden/skateboard/beginner
	name = "skateboard"
	desc = "A XTREME SPORTZ brand skateboard for beginners. Ages 8 and up."
	board_item_type = /obj/item/melee/skateboard/beginner
	icon_state = "skateboard"

/obj/vehicle/ridden/skateboard/pro
	name = "skateboard"
	desc = "A RaDSTORMz brand professional skateboard. Looks a lot more stable than the average board."
	board_item_type = /obj/item/melee/skateboard/pro
	icon_state = "skateboard2"
	movedelay = 1

/obj/vehicle/ridden/skateboard/hoverboard
	name = "hoverboard"
	desc = "A blast from the past, so retro!"
	board_item_type = /obj/item/melee/skateboard/hoverboard
	icon_state = "hoverboard_red"
	movedelay = 0

/obj/vehicle/ridden/skateboard/hoverboard/admin
	name = "\improper Board Of Directors"
	desc = "The engineering complexity of a spaceship concentrated inside of a board. Just as expensive, too."
	board_item_type = /obj/item/melee/skateboard/hoverboard/admin
	icon_state = "hoverboard_nt"
	movedelay = -1

//If this was the 90's you'd be killed for this
/obj/vehicle/ridden/skateboard/scooter
	name = "scooter"
	desc = "A fun way to get around."
	icon_state = "scooter"
	board_item_type = /obj/item/melee/skateboard/scooter

// ----Construction----
/obj/item/skate_wheels
	name = "rubberized wheels"
	desc = "These rubberized wheels encase ball bearings which ensure a smooth rotation. They could possibly be mounted on an appropriate frame."
	icon_state = "skate_wheels"

/obj/item/skateboard_frame
	name = "skateboard frame"
	desc = "This roughly shaped board of flexible steel seems like it could be used to travel in style. It's just missing something..."
	icon = 'icons/obj/items.dmi'
	icon_state = "skate_assembly0"
	damage_force = 3.0
	throw_force = 3.0
	throw_speed = 2
	throw_range = 5
	w_class = WEIGHT_CLASS_NORMAL
	var/build_step = 0

/obj/item/heavy_skateboard_frame
	name = "reinforced skateboard frame"
	desc = "This bulky board of reinforced steel seems like it could be used to travel in radical style. It's just missing something..."
	icon = 'icons/obj/items.dmi'
	icon_state = "skate_assembly0"
	damage_force = 6.0
	throw_force = 6.0
	throw_speed = 2
	throw_range = 4
	w_class = WEIGHT_CLASS_NORMAL
	var/build_step = 0

//Improv Board Construction
/obj/item/skateboard_frame/attackby(var/obj/item/W as obj, var/mob/user)
	..()
	switch(build_step)
		if(0)
			if(istype(W, /obj/item/stack/material/steel))
				var/obj/item/stack/material/M = W
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
				var/obj/item/stack/material/M = W
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
				new /obj/vehicle/ridden/skateboard/improv(T)
				qdel(src)

//Pro Board Construction
/obj/item/heavy_skateboard_frame/attackby(var/obj/item/W as obj, var/mob/user)
	..()
	switch(build_step)
		if(0)
			if(istype(W, /obj/item/stack/material/steel))
				var/obj/item/stack/material/M = W
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
				var/obj/item/stack/material/M = W
				if(M.amount >= 10)
					M.use(10)
					build_step++
					to_chat(user, "<span class='notice'>You use \the [W] to enhance \the [src] frame.</span>")
					name = "skateboard frame (enhanced frame)"
		if(3)
			if(istype(W, /obj/item/stack/material/plastic))
				var/obj/item/stack/material/M = W
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
				new /obj/vehicle/ridden/skateboard/pro(T)
				qdel(src)

