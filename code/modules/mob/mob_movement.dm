/mob/CanPass(atom/movable/mover, turf/target)
	return TRUE				//There's almost no cases where non /living mobs should be used in game as actual mobs, other than ghosts.

/mob/proc/setMoveCooldown(var/timeout)
	move_delay = max(world.time + timeout, move_delay)

/mob/proc/check_move_cooldown()
	if(world.time < src.move_delay)
		return FALSE // Need to wait more.
	return TRUE

/client/proc/client_dir(input, direction=-1)
	return turn(input, direction*dir2angle(dir))

/client/Northeast()
	diagonal_action(NORTHEAST)
/client/Northwest()
	diagonal_action(NORTHWEST)
/client/Southeast()
	diagonal_action(SOUTHEAST)
/client/Southwest()
	diagonal_action(SOUTHWEST)

/client/proc/diagonal_action(direction)
	switch(client_dir(direction, 1))
		if(NORTHEAST)
			swap_hand()
			return
		if(SOUTHEAST)
			attack_self()
			return
		if(SOUTHWEST)
			if(isliving(usr))
				var/mob/living/carbon/C = usr
				C.toggle_throw_mode()
			else
				usr << "<font color='red'>This mob type cannot throw items.</font>"
			return
		if(NORTHWEST)
			if(isliving(usr))
				var/mob/living/carbon/C = usr
				if(!C.get_active_hand())
					usr << "<font color='red'>You have nothing to drop in your hand.</font>"
					return
				drop_item()
			else
				usr << "<font color='red'>This mob type cannot drop items.</font>"
			return

//This gets called when you press the delete button.
/client/verb/delete_key_pressed()
	set hidden = 1

	if(!usr.pulling)
		usr << "<font color='blue'>You are not pulling anything.</font>"
		return
	usr.stop_pulling()

/client/verb/swap_hand()
	set hidden = 1
	if(istype(mob, /mob/living))
		var/mob/living/L = mob
		L.swap_hand()
	if(istype(mob,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = mob
		R.cycle_modules()
	return



/client/verb/attack_self()
	set hidden = 1
	if(mob)
		mob.mode()
	return


/client/verb/toggle_throw_mode()
	set hidden = 1
	if(!istype(mob, /mob/living/carbon))
		return
	if (!mob.stat && isturf(mob.loc) && !mob.restrained())
		mob:toggle_throw_mode()
	else
		return


/client/verb/drop_item()
	set hidden = 1
	if(!isrobot(mob) && mob.stat == CONSCIOUS && isturf(mob.loc))
		return mob.drop_item()
	return


/client/Center()
	/* No 3D movement in 2D spessman game. dir 16 is Z Up
	if (isobj(mob.loc))
		var/obj/O = mob.loc
		if (mob.canmove)
			return O.relaymove(mob, 16)
	*/
	return

/client/proc/Move_object(direct)
	if(mob && mob.control_object)
		if(mob.control_object.density)
			step(mob.control_object,direct)
			if(!mob.control_object)	return
			mob.control_object.dir = direct
		else
			mob.control_object.forceMove(get_step(mob.control_object,direct))
	return


/client/Move(n, direct)
	if(!mob)
		return // Moved here to avoid nullrefs below

	if(mob.control_object)	Move_object(direct)

	if(mob.incorporeal_move && isobserver(mob))
		Process_Incorpmove(direct)
		return

	if(moving)	return 0

	if(!mob.check_move_cooldown())
		return

	if(locate(/obj/effect/stop/, mob.loc))
		for(var/obj/effect/stop/S in mob.loc)
			if(S.victim == mob)
				return

	if(mob.stat==DEAD && isliving(mob) && !mob.forbid_seeing_deadchat)
		mob.ghostize()
		return

	// handle possible Eye movement
	if(mob.eyeobj)
		return mob.EyeMove(n,direct)

	if(mob.transforming)	return//This is sota the goto stop mobs from moving var

	if(isliving(mob))
		var/mob/living/L = mob
		if(L.incorporeal_move)//Move though walls
			Process_Incorpmove(direct)
			return
		if(mob.client)
			if(mob.client.view != world.view) // If mob moves while zoomed in with device, unzoom them.
				for(var/obj/item/item in mob.contents)
					if(item.zoom)
						item.zoom()
						break
				/*
				if(locate(/obj/item/gun/energy/sniperrifle, mob.contents))		// If mob moves while zoomed in with sniper rifle, unzoom them.
					var/obj/item/gun/energy/sniperrifle/s = locate() in mob
					if(s.zoom)
						s.zoom()
				if(locate(/obj/item/device/binoculars, mob.contents))		// If mob moves while zoomed in with binoculars, unzoom them.
					var/obj/item/device/binoculars/b = locate() in mob
					if(b.zoom)
						b.zoom()
				*/

	if(Process_Grab())	return

	if(!mob.canmove)
		return

	//if(istype(mob.loc, /turf/space) || (mob.flags & NOGRAV))
	//	if(!mob.Process_Spacemove(0))	return 0

	if(!mob.lastarea)
		mob.lastarea = get_area(mob.loc)

	if((istype(mob.loc, /turf/space)) || (mob.lastarea.has_gravity == 0))
		if(!mob.process_spacemove(direct))	return 0

	if(isobj(mob.loc) || ismob(mob.loc))//Inside an object, tell it we moved
		var/atom/O = mob.loc
		return O.relaymove(mob, direct)

	if(isturf(mob.loc))

		if(mob.restrained())//Why being pulled while cuffed prevents you from moving
			for(var/mob/M in range(mob, 1))
				if(M.pulling == mob)
					if(!M.restrained() && M.stat == 0 && M.canmove && mob.Adjacent(M))
						src << "<font color='blue'>You're restrained! You can't move!</font>"
						return 0
					else
						M.stop_pulling()

		if(mob.pinned.len)
			src << "<font color='blue'>You're pinned to a wall by [mob.pinned[1]]!</font>"
			return 0

		mob.move_delay = world.time//set move delay

		switch(mob.m_intent)
			if("run")
				if(mob.drowsyness > 0)
					mob.move_delay += 6
				mob.move_delay += config.run_speed
			if("walk")
				mob.move_delay += config.walk_speed
		mob.move_delay += mob.movement_delay()

		if(istype(mob.buckled, /obj/vehicle))
			//manually set move_delay for vehicles so we don't inherit any mob movement penalties
			//specific vehicle move delays are set in code\modules\vehicles\vehicle.dm
			mob.move_delay = world.time
			//drunk driving
			if(mob.confused && prob(20)) //vehicles tend to keep moving in the same direction
				direct = turn(direct, pick(90, -90))
			return mob.buckled.relaymove(mob,direct)

		if(istype(mob.machine, /obj/machinery))
			if(mob.machine.relaymove(mob,direct))
				return

		if(mob.pulledby || mob.buckled) // Wheelchair driving!
			if(istype(mob.loc, /turf/space))
				return // No wheelchair driving in space
			if(istype(mob.pulledby, /obj/structure/bed/chair/wheelchair))
				return mob.pulledby.relaymove(mob, direct)
			else if(istype(mob.buckled, /obj/structure/bed/chair/wheelchair))
				if(ishuman(mob))
					var/mob/living/carbon/human/driver = mob
					var/obj/item/organ/external/l_hand = driver.get_organ("l_hand")
					var/obj/item/organ/external/r_hand = driver.get_organ("r_hand")
					if((!l_hand || l_hand.is_stump()) && (!r_hand || r_hand.is_stump()))
						return // No hands to drive your chair? Tough luck!
				//drunk wheelchair driving
				else if(mob.confused)
					switch(mob.m_intent)
						if("run")
							if(prob(50))	direct = turn(direct, pick(90, -90))
						if("walk")
							if(prob(25))	direct = turn(direct, pick(90, -90))
				mob.move_delay += 2
				return mob.buckled.relaymove(mob,direct)

		//We are now going to move
		moving = 1
		//Something with pulling things
		if(locate(/obj/item/weapon/grab, mob))
			mob.move_delay = max(mob.move_delay, world.time + 7)
			var/list/L = mob.ret_grab()
			if(istype(L, /list))
				if(L.len == 2)
					L -= mob
					var/mob/M = L[1]
					if(M)
						if ((get_dist(mob, M) <= 1 || M.loc == mob.loc))
							var/turf/T = mob.loc
							. = ..()
							if (isturf(M.loc))
								var/diag = get_dir(mob, M)
								if ((diag - 1) & diag)
								else
									diag = null
								if ((get_dist(mob, M) > 1 || diag))
									step(M, get_dir(M.loc, T))
				else
					for(var/mob/M in L)
						M.other_mobs = 1
						if(mob != M)
							M.animate_movement = 3
					for(var/mob/M in L)
						spawn( 0 )
							step(M, direct)
							return
						spawn( 1 )
							M.other_mobs = null
							M.animate_movement = 2
							return

		else
			if(mob.confused)
				switch(mob.m_intent)
					if("run")
						if(prob(75))
							direct = turn(direct, pick(90, -90))
							n = get_step(mob, direct)
					if("walk")
						if(prob(25))
							direct = turn(direct, pick(90, -90))
							n = get_step(mob, direct)
			. = mob.SelfMove(n, direct)

		for (var/obj/item/weapon/grab/G in mob)
			if (G.state == GRAB_NECK)
				mob.setDir(reverse_dir[direct])
			G.adjust_position()
		for (var/obj/item/weapon/grab/G in mob.grabbed_by)
			G.adjust_position()

		moving = 0

		return .

	return

/mob/proc/SelfMove(turf/n, direct)
	return Move(n, direct)


///Process_Incorpmove
///Called by client/Move()
///Allows mobs to run though walls
/client/proc/Process_Incorpmove(direct)
	var/turf/mobloc = get_turf(mob)

	switch(mob.incorporeal_move)
		if(1)
			var/turf/T = get_step(mob, direct)
			if(!T)
				return
			if(mob.check_holy(T))
				mob << "<span class='warning'>You cannot get past holy grounds while you are in this plane of existence!</span>"
				return
			else
				mob.forceMove(T)
				mob.setDir(direct)
		if(2)
			if(prob(50))
				var/locx
				var/locy
				switch(direct)
					if(NORTH)
						locx = mobloc.x
						locy = (mobloc.y+2)
						if(locy>world.maxy)
							return
					if(SOUTH)
						locx = mobloc.x
						locy = (mobloc.y-2)
						if(locy<1)
							return
					if(EAST)
						locy = mobloc.y
						locx = (mobloc.x+2)
						if(locx>world.maxx)
							return
					if(WEST)
						locy = mobloc.y
						locx = (mobloc.x-2)
						if(locx<1)
							return
					else
						return
				mob.forceMove(locate(locx,locy,mobloc.z))
				spawn(0)
					var/limit = 2//For only two trailing shadows.
					for(var/turf/T in getline(mobloc, mob.loc))
						spawn(0)
							anim(T,mob,'icons/mob/mob.dmi',,"shadow",,mob.dir)
						limit--
						if(limit<=0)	break
			else
				spawn(0)
					anim(mobloc,mob,'icons/mob/mob.dmi',,"shadow",,mob.dir)
				mob.forceMove(get_step(mob, direct))
			mob.dir = direct
	mob.Post_Incorpmove()
	return 1

/mob/proc/Post_Incorpmove()
	return

/mob/proc/Check_Shoegrip()
	return 0

/mob/proc/mob_has_gravity(turf/T)
	return has_gravity(src, T)

/*
// The real Move() proc is above, but touching that massive block just to put this in isn't worth it.
/mob/Move(var/newloc, var/direct)
	. = ..(newloc, direct)
	if(.)
		post_move(newloc, direct)
*/
// Called when a mob successfully moves.
// Would've been an /atom/movable proc but it caused issues.
/mob/Moved(atom/oldloc)
	. = ..()
	for(var/obj/O in contents)
		O.on_loc_moved(oldloc)

// Received from Moved(), useful for items that need to know that their loc just moved.
/obj/proc/on_loc_moved(atom/oldloc)
	return

/obj/item/weapon/storage/on_loc_moved(atom/oldloc)
	for(var/obj/O in contents)
		O.on_loc_moved(oldloc)

/client/verb/moveup()
	set name = ".moveup"
	set instant = 1
	Move(get_step(mob, NORTH), NORTH)
/client/verb/movedown()
	set name = ".movedown"
	set instant = 1
	Move(get_step(mob, SOUTH), SOUTH)
/client/verb/moveright()
	set name = ".moveright"
	set instant = 1
	Move(get_step(mob, EAST), EAST)
/client/verb/moveleft()
	set name = ".moveleft"
	set instant = 1
	Move(get_step(mob, WEST), WEST)






/mob/process_spacemove(movement_dir = NONE)
	if(spacewalk || ..())
		return TRUE
	var/atom/movable/backup = get_spacemove_backup()
	if(backup)
		if(istype(backup) && movement_dir && !backup.anchored)
			if(backup.newtonian_move(turn(movement_dir, 180))) //You're pushing off something movable, so it moves
				to_chat(src, "<span class='info'>You push off of [backup] to propel yourself.</span>")
		return TRUE
	return FALSE

/mob/proc/update_gravity(has_gravity)
	update_floating(has_gravity)

/mob/get_spacemove_backup()
	for(var/A in orange(1, get_turf(src)))
		if(isarea(A))
			continue
		else if(isturf(A))
			var/turf/turf = A
			if(isspaceturf(turf))
				continue
			if(!turf.density && !mob_negates_gravity())
				continue
			return A
		else
			var/atom/movable/AM = A
			if(AM == buckled)
				continue
			if(ismob(AM))
				var/mob/M = AM
				if(M.buckled)
					continue
			if(!AM.CanPass(src) || AM.density)
				if(AM.anchored)
					return AM
				if(pulling == AM)
					continue
				. = AM
