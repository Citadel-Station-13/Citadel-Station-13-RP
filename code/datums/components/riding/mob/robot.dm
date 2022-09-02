/datum/component/riding_filter/mob/robot
	expected_typepath = /mob/living/silicon/robot
	handler_typepath = /datum/component/riding_handler/mob/robot

/datum/component/riding_handler/mob/robot
	expected_typepath = /mob/living/silicon/robot






/datum/component/riding_handler/cyborg
	del_on_unbuckle_all = TRUE

/datum/component/riding_handler/cyborg/ride_check(mob/user)
	var/atom/movable/AM = parent
	if(user.incapacitated())
		var/kick = TRUE
		if(iscyborg(AM))
			var/mob/living/silicon/robot/R = AM
			if(R.module && R.module.ride_allow_incapacitated)
				kick = FALSE
		if(kick)
			to_chat(user, "<span class='userdanger'>You fall off of [AM]!</span>")
			Unbuckle(user)
			return
	if(iscarbon(user))
		var/mob/living/carbon/carbonuser = user
		if(!carbonuser.get_num_arms())
			Unbuckle(user)
			to_chat(user, "<span class='warning'>You can't grab onto [AM] with no hands!</span>")
			return

/datum/component/riding_handler/cyborg/handle_vehicle_layer()
	var/atom/movable/AM = parent
	if(AM.buckled_mobs && AM.buckled_mobs.len)
		if(AM.dir == SOUTH)
			AM.layer = ABOVE_MOB_LAYER
		else
			AM.layer = OBJ_LAYER
	else
		AM.layer = MOB_LAYER

/datum/component/riding_handler/cyborg/get_offsets(pass_index) // list(dir = x, y, layer)
	return list(TEXT_NORTH = list(0, 4), TEXT_SOUTH = list(0, 4), TEXT_EAST = list(-6, 3), TEXT_WEST = list( 6, 3))

/datum/component/riding_handler/cyborg/handle_vehicle_offsets()
	var/atom/movable/AM = parent
	if(AM.has_buckled_mobs())
		for(var/mob/living/M in AM.buckled_mobs)
			M.setDir(AM.dir)
			if(iscyborg(AM))
				var/mob/living/silicon/robot/R = AM
				if(istype(R.module))
					M.pixel_x = R.module.ride_offset_x[dir2text(AM.dir)]
					M.pixel_y = R.module.ride_offset_y[dir2text(AM.dir)]
			else
				..()

/datum/component/riding_handler/cyborg/force_dismount(mob/living/M)
	var/atom/movable/AM = parent
	AM.unbuckle_mob(M)
	var/turf/target = get_edge_target_turf(AM, AM.dir)
	var/turf/targetm = get_step(get_turf(AM), AM.dir)
	M.Move(targetm)
	M.visible_message("<span class='warning'>[M] is thrown clear of [AM]!</span>", \
					"<span class='warning'>You're thrown clear of [AM]!</span>")
	M.throw_at(target, 14, 5, AM)
	M.Paralyze(60)
