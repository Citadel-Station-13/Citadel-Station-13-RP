/obj/structure/bed/chair/wheelchair
	name = "wheelchair"
	desc = "You sit in this. Either by will or force."
	icon_state = "wheelchair"
	anchored = 0
	buckle_movable = 1

	var/last_active_move = 0
	var/driving = 0
	var/mob/living/pulling_along = null
	var/bloodiness
	var/move_delay = 2		//5 TPS

/obj/structure/bed/chair/wheelchair/update_icon()
	return

/obj/structure/bed/chair/wheelchair/setDir()
	..()
	overlays = null
	var/image/O = image(icon = 'icons/obj/furniture.dmi', icon_state = "w_overlay", layer = FLY_LAYER, dir = src.dir)
	overlays += O
	if(has_buckled_mobs())
		for(var/A in buckled_mobs)
			var/mob/living/L = A
			L.setDir(dir)

/obj/structure/bed/chair/wheelchair/attackby(obj/item/W as obj, mob/user as mob)
	if(W.is_wrench() || W.is_wirecutter() || istype(W,/obj/item/stack))
		return
	..()

/obj/structure/bed/chair/wheelchair/relaymove(mob/user, direction)
	// Redundant check?

	if(world.time < last_active_move + move_delay)
		return

	if(user.stat || user.stunned || user.weakened || user.paralysis || user.lying || user.restrained())
		if(user==pulling_along)
			pulling_along = null
			user.pulledby = null
			to_chat(user, "<span class='warning'>You lost your grip!</span>")
		return
	if(has_buckled_mobs() && pulling_along && user in buckled_mobs)
		if(pulling_along.stat || pulling_along.stunned || pulling_along.weakened || pulling_along.paralysis || pulling_along.lying || pulling_along.restrained())
			pulling_along.pulledby = null
			pulling_along = null
	if(user.pulling && (user == pulling_along))
		pulling_along = null
		user.pulledby = null
		return
	if(propelled)
		return
	if(pulling_along && (get_dist(src, pulling_along) > 1))
		pulling_along = null
		user.pulledby = null
		if(user==pulling_along)
			return
	if(pulling_along && (get_dir(src.loc, pulling_along.loc) == direction))
		to_chat(user, "<span class='warning'>You cannot go there.</span>")
		return
	if(pulling_along && has_buckled_mobs() && (user in buckled_mobs))
		to_chat(user, "<span class='warning'>You cannot drive while being pushed.</span>")
		return


 	last_active_move = world.time


	// Let's roll
	driving = 1
	var/turf/T = null
	//--1---Move occupant---1--//
	if(has_buckled_mobs())
		for(var/A in buckled_mobs)
			var/mob/living/L = A
			L.buckled = null
			step(L, direction)
			L.buckled = src
	//--2----Move driver----2--//
	if(pulling_along)
		T = pulling_along.loc
		if(get_dist(src, pulling_along) >= 1)
			step(pulling_along, get_dir(pulling_along.loc, src.loc))
	//--3--Move wheelchair--3--//
	step(src, direction)
	if(has_buckled_mobs()) // Make sure it stays beneath the occupant
		var/mob/living/L = buckled_mobs[1]
		Move(L.loc)
	setDir(direction)
	if(pulling_along) // Driver
		if(pulling_along.loc == src.loc) // We moved onto the wheelchair? Revert!
			pulling_along.forceMove(T)
		else
			spawn(0)
			if(get_dist(src, pulling_along) > 1) // We are too far away? Losing control.
				pulling_along = null
				user.pulledby = null
			pulling_along.setDir(get_dir(pulling_along, src)) // When everything is right, face the wheelchair
	if(bloodiness)
		create_track()
	driving = 0

/obj/structure/bed/chair/wheelchair/Move()
	..()
	if(has_buckled_mobs())
		for(var/A in buckled_mobs)
			var/mob/living/occupant = A
			if(!driving)
				occupant.buckled = null
				occupant.Move(src.loc)
				occupant.buckled = src
				if (occupant && (src.loc != occupant.loc))
					if (propelled)
						for (var/mob/O in src.loc)
							if (O != occupant)
								Bump(O)
					else
						unbuckle_mob()
				if (pulling_along && (get_dist(src, pulling_along) > 1))
					pulling_along.pulledby = null
					to_chat(pulling_along, "<span class='warning'>You lost your grip!</span>")
					pulling_along = null
			else
				if (occupant && (src.loc != occupant.loc))
					src.forceMove(occupant.loc) // Failsafe to make sure the wheelchair stays beneath the occupant after driving

/obj/structure/bed/chair/wheelchair/attack_hand(mob/living/user as mob)
	if (pulling_along)
		MouseDrop(usr)
	else
		if(has_buckled_mobs())
			for(var/A in buckled_mobs)
				user_unbuckle_mob(A, user)
	return

/obj/structure/bed/chair/wheelchair/CtrlClick(var/mob/user)
	if(in_range(src, user))
		if(!ishuman(user))	return
		if(has_buckled_mobs() && user in buckled_mobs)
			to_chat(user, "<span class='warning'>You realize you are unable to push the wheelchair you sit in.</span>")
			return
		if(!pulling_along)
			pulling_along = user
			user.pulledby = src
			if(user.pulling)
				user.stop_pulling()
			user.setDir(get_dir(user, src))
			to_chat(user, "You grip \the [name]'s handles.")
		else
			to_chat(usr, "You let go of \the [name]'s handles.")
			pulling_along.pulledby = null
			pulling_along = null
		return

/obj/structure/bed/chair/wheelchair/Bump(atom/A)
	..()
	if(!has_buckled_mobs())	return

	if(propelled || (pulling_along && (pulling_along.a_intent == INTENT_HARM)))
		var/mob/living/occupant = unbuckle_mob()

		if (pulling_along && (pulling_along.a_intent == INTENT_HARM))
			occupant.throw_at(A, 3, 3, pulling_along)
		else if (propelled)
			occupant.throw_at(A, 3, propelled)

		var/def_zone = ran_zone()
		var/blocked = occupant.run_armor_check(def_zone, "melee")
		var/soaked = occupant.get_armor_soak(def_zone, "melee")
		occupant.throw_at(A, 3, propelled)
		occupant.apply_effect(6, STUN, blocked)
		occupant.apply_effect(6, WEAKEN, blocked)
		occupant.apply_effect(6, STUTTER, blocked)
		occupant.apply_damage(10, BRUTE, def_zone, soaked)
		playsound(src.loc, 'sound/weapons/punch1.ogg', 50, 1, -1)
		if(istype(A, /mob/living))
			var/mob/living/victim = A
			def_zone = ran_zone()
			blocked = victim.run_armor_check(def_zone, "melee")
			soaked = victim.get_armor_soak(def_zone, "melee")
			victim.apply_effect(6, STUN, blocked)
			victim.apply_effect(6, WEAKEN, blocked)
			victim.apply_effect(6, STUTTER, blocked)
			victim.apply_damage(10, BRUTE, def_zone, soaked)
		if(pulling_along)
			occupant.visible_message("<span class='danger'>[pulling_along] has thrusted \the [name] into \the [A], throwing \the [occupant] out of it!</span>")

			add_attack_logs(pulling_along,occupant,"Crashed their [name] into [A]")
		else
			occupant.visible_message("<span class='danger'>[occupant] crashed into \the [A]!</span>")

/obj/structure/bed/chair/wheelchair/proc/create_track()
	var/obj/effect/decal/cleanable/blood/tracks/B = new(loc)
	var/newdir = get_dir(get_step(loc, dir), loc)
	if(newdir == dir)
		B.setDir(newdir)
	else
		newdir = newdir | dir
		if(newdir == 3)
			newdir = 1
		else if(newdir == 12)
			newdir = 4
		B.setDir(newdir)
	bloodiness--

/obj/structure/bed/chair/wheelchair/buckle_mob(mob/M as mob, mob/user as mob)
	if(M == pulling_along)
		pulling_along = null
		usr.pulledby = null
	..()

/obj/item/wheelchair
	name = "wheelchair"
	desc = "A folded wheelchair that can be carried around."
	icon = 'icons/obj/furniture.dmi'
	icon_state = "wheelchair_folded"
	item_state = "wheelchair"
	w_class = ITEMSIZE_HUGE // Can't be put in backpacks. Oh well.

/obj/item/wheelchair/attack_self(mob/user)
		var/obj/structure/bed/chair/wheelchair/R = new /obj/structure/bed/chair/wheelchair(user.loc)
		R.add_fingerprint(user)
		R.name = src.name
		R.color = src.color
		qdel(src)

/obj/structure/bed/chair/wheelchair/MouseDrop(over_object, src_location, over_location)
	..()
	if((over_object == usr && (in_range(src, usr) || usr.contents.Find(src))))
		if(!ishuman(usr))	return
		if(has_buckled_mobs())	return 0
		visible_message("[usr] collapses \the [src.name].")
		var/obj/item/wheelchair/R = new/obj/item/wheelchair(get_turf(src))
		R.name = src.name
		R.color = src.color
		spawn(0)
			qdel(src)
		return
