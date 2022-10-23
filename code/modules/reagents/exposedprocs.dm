/// Spray bottle style, intended for use with afterattack. See '/obj/effect/water/proc/set_up' for more details.
/obj/item/proc/spray_at(atom/A as mob|obj, proximity_flag, amount_per_transfer_from_this = 10, spray_size = 3, delay = 10)
	playsound(src.loc, 'sound/effects/spray2.ogg', 50, 1, -6)
	if (A.density && proximity_flag)
		A.visible_message("[src.loc] sprays [A] with [src].")
		reagents.splash(A, amount_per_transfer_from_this)
	else
		spawn(0)
			var/obj/effect/water/chempuff/D = new/obj/effect/water/chempuff(get_turf(src))
			var/turf/my_target = get_turf(A)
			D.create_reagents(amount_per_transfer_from_this)
			if(!src)
				return
			reagents.trans_to_obj(D, amount_per_transfer_from_this)
			D.set_color()
			D.set_up(my_target, spray_size, delay)
	return

/// Chem thrower style spray. If spray_size = null a random value from 6-8 will be chosen.
/obj/item/proc/spray_at_wide(atom/A as mob|obj, var/amount_per_transfer_from_this = 10, var/spray_size = null, var/delay = 2)
	var/direction = get_dir(src, A)
	var/turf/T = get_turf(A)
	var/turf/T1 = get_step(T,turn(direction, 90))
	var/turf/T2 = get_step(T,turn(direction, -90))
	var/list/the_targets = list(T, T1, T2)

	for(var/a = 1 to 3)
		spawn(0)
			if(reagents.total_volume < 1) break
			var/obj/effect/water/chempuff/D = new/obj/effect/water/chempuff(get_turf(src))
			var/turf/my_target = the_targets[a]
			D.create_reagents(amount_per_transfer_from_this)
			if(!src)
				return
			playsound(src.loc, 'sound/effects/spray2.ogg', 50, 1, -6)
			reagents.trans_to_obj(D, amount_per_transfer_from_this)
			D.set_color()
			spray_size ? null : (spray_size = rand(6, 8))
			D.set_up(my_target, spray_size, delay)
	return

/// Extinguisher spray, intended for use with afterattack. See '/obj/effect/water/proc/set_up' for more details.
/obj/item/proc/extinguish_spray(atom/A as mob|obj|turf, var/mob/living/user, var/amount_per_transfer_from_this = 10, var/spray_size = 3, var/delay = 10, var/spray_particles = 3)
	var/direction = get_dir(src, A)
	if(user && user.buckled && isobj(user.buckled))
		spawn(0)
			ex_propel_object(usr.buckled, user, turn(direction,180))

	var/turf/T = get_turf(A)
	var/turf/T1 = get_step(T,turn(direction, 90))
	var/turf/T2 = get_step(T,turn(direction, -90))

	var/list/the_targets = list(T,T1,T2)

	for(var/a = 1 to spray_particles)
		spawn(0)
			if(!src || !reagents.total_volume) return

			var/obj/effect/water/W = new /obj/effect/water(get_turf(src))
			var/turf/my_target
			if(a <= the_targets.len)
				my_target = the_targets[a]
			else
				my_target = pick(the_targets)
			W.create_reagents(amount_per_transfer_from_this)
			if(!src)
				return
			playsound(src.loc, 'sound/effects/extinguish.ogg', 75, 1, -3)
			reagents.trans_to_obj(W, amount_per_transfer_from_this)
			W.set_color()
			W.set_up(my_target)

	if((istype(usr.loc, /turf/space)) || (usr.lastarea.has_gravity == 0))
		user.newtonian_move(get_dir(A, user))

// Propel an object backwards in the same form as a fire extinguisher.
/obj/item/proc/ex_propel_object(var/obj/O, mob/user, movementdirection)
	if(O.anchored) return

	var/obj/structure/bed/chair/C
	if(istype(O, /obj/structure/bed/chair))
		C = O

	var/list/move_speed = list(1, 1, 1, 2, 2, 3)
	for(var/i in 1 to 6)
		if(C) C.propelled = (6-i)
		O.Move(get_step(user,movementdirection), movementdirection)
		sleep(move_speed[i])

	//additional movement
	for(var/i in 1 to 3)
		O.Move(get_step(user,movementdirection), movementdirection)
		sleep(3)
