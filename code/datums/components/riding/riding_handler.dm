/**
 * Riding handler components
 *
 * Handles the motion tracking/pixel offsetting/etc of riding
 *
 * This component takes over **after** something is buckled to the atom.
 * Before that, riding_filter handles it.
 */
/datum/component/riding_handler
	//? disabled as we don't have dupe handling
	can_transfer = FALSE
	//! main
	/// expected typepath of what we're handling for
	var/expected_typepath = /atom/movable

	//! check flags
	/// rider check flags : kicks people off if they don't meet these requirements.
	var/rider_check_flags = NONE
	/// ridden check flags : kicks people off if the parent atom doesn't meet these requirements.
	var/ridden_check_flags = NONE
	/// handler flags : determines some of our behavior
	var/riding_handler_flags = CF_RIDING_HANDLER_ALLOW_BORDER

	//! offsets - highly optimized, eat my ass if you can't handle it, we need high performance for /Move()s.
	/// layer offset to set mobs to. list or single number. plane will always be set to vehicle's plane. if list, format is (north, east, south, west). lists can be nested to provide different offsets based on index.
	var/list/offset_layer = 0
	/// pixel offsets to set mobs to. list (x, y) OR list((x, y), (x, y), (x, y), (x, y)) for NESW OR list(list(list(NESW offsets))) for positionals.
	var/list/offset_pixel = list(0, 0)
	/// same as offset pixel, but without the third option. set to null to not modify.
	var/list/offset_vehicle

	//! component-controlled movemnet

	//! operational
	/// last dir. used to avoid redoing expensive setdir stuff
	var/tmp/_last_dir



	var/last_vehicle_move = 0 //used for move delays
	var/last_move_diagonal = FALSE
	var/vehicle_move_delay = 2 //tick delay between movements, lower = faster, higher = slower
	var/keytype

	var/slowed = FALSE
	var/slowvalue = 1

	var/list/riding_offsets = list()	//position_of_user = list(dir = list(px, py)), or RIDING_OFFSET_ALL for a generic one.
	var/list/directional_vehicle_layers = list()	//["[DIRECTION]"] = layer. Don't set it for a direction for default, set a direction to null for no change.
	var/list/directional_vehicle_offsets = list()	//same as above but instead of layer you have a list(px, py)
	var/list/allowed_turf_typecache
	var/list/forbid_turf_typecache					//allow typecache for only certain turfs, forbid to allow all but those. allow only certain turfs will take precedence.
	var/drive_verb = "drive"

/datum/component/riding_handler/Initialize()
	. = ..()
	if(. & COMPONENT_INCOMPATIBLE)
		return
	if(!istype(parent, expected_typepath))
		return COMPONENT_INCOMPATIBLE

/datum/component/riding_handler/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_MOVABLE_MOB_BUCKLED, .proc/signal_hook_mob_buckled)
	RegisterSignal(parent, COMSIG_MOVABLE_MOB_UNBUCKLED, .proc/signal_hook_mob_unbuckled)
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, .proc/signal_hook_handle_move)
	RegisterSignal(parent, COMSIG_ATOM_DIR_CHANGE, .proc/signal_hook_handle_turn)

/datum/component/riding_handler/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, list(
		COMSIG_MOVABLE_MOB_BUCKLED,
		COMSIG_MOVABLE_MOB_UNBUCKLED,
		COMSIG_MOVABLE_MOVED,
		COMSIG_ATOM_DIR_CHANGE
	))

/datum/component/riding_handler/proc/signal_hook_mob_buckled(atom/movable/source, mob/M, buckle_flags, mob/user)
	SIGNAL_HANDLER

/datum/component/riding_handler/proc/signal_hook_mob_unbuckled(atom/movable/source, mob/M, buckle_flags, mob/user)
	SIGNAL_HANDLER

	if(!source.has_buckled_mobs() && (riding_handler_flags & CF_RIDING_HANDLER_EPHEMERAL))
		qdel(src)

/datum/component/riding_handler/proc/signal_hook_handle_move(atom/movable/source, atom/old_loc, dir)
	SIGNAL_HANDLER

/datum/component/riding_handler/proc/signal_hook_handle_turn(atom/movable/source, old_dir, new_dir)
	SIGNAL_HANDLER
	update_vehicle_on_turn(new_dir)
	update_riders_on_turn(new_dir)

/datum/component/riding_handler/proc/update_vehicle_on_turn(dir)
	if(!offset_vehicle)
		return
	var/atom/movable/AM = parent
	if(islist(offset_vehicle[1]))
		// NESW format
		switch(dir)
			if(NORTH)
				AM.pixel_x = offset_vehicle[1][1]
				AM.pixel_y = offset_vehicle[1][2]
			if(EAST)
				AM.pixel_x = offset_vehicle[2][1]
				AM.pixel_y = offset_vehicle[2][2]
			if(SOUTH)
				AM.pixel_x = offset_vehicle[3][1]
				AM.pixel_y = offset_vehicle[3][2]
			if(WEST)
				AM.pixel_x = offset_vehicle[4][1]
				AM.pixel_y = offset_vehicle[4][2]
	else
		AM.pixel_x = offset_vehicle[1]
		AM.pixel_y = offset_vehicle[2]

/datum/component/riding_handler/proc/reset_rider(mob/rider)
	rider.reset_plane_and_layer()
	rider.reset_pixel_offsets()

/datum/component/riding_handler/proc/apply_rider(mob/rider)
	var/atom/movable/AM = parent
	var/position = AM.buckled_mobs.Find(rider)
	apply_rider_layer(rider, M.dir, position)
	apply_rider_offsets(rider, M.dir, position)

/datum/component/riding_handler/proc/update_riders_on_turn(dir)
	if(_last_dir == dir)
		return
	_last_dir = dir
	for(var/i in 1 to length(AM.buckled_mobs))
		var/mob/M = AM.buckled_mobs[i]
		apply_rider_layer(M, dir, i)
		apply_rider_offsets(M, dir, i, AM.pixel_x, AM.pixel_y)
		M.setDir(rider_dir_offset(dir, i))

/datum/component/riding_handler/proc/apply_rider_offsets(mob/rider, dir, pos, opx, opy)
	var/list/offsets = rider_layer_offset(dir, pos)
	rider.pixel_x = offsets[1] + opx
	rider.pixel_y = offsets[2] + opy

/datum/component/riding_handler/proc/apply_rider_layer(mob/rider, dir, pos)
	var/atom/movable/AM = parent
	rider.plane = AM.plane
	rider.layer = AM.layer + rider_layer_offset(dir, pos)

/datum/component/riding_handler/proc/rider_layer_offset(dir, index = 1)
	if(isnum(offset_layer))
		return offset_layer
	var/indexed = islist(offset_layer[1])
	if(indexed)
		var/list/relevant = offset_layer[min(offset_layer.len, index)]
		switch(dir)
			if(NORTH)
				return relevant[1]
			if(EAST)
				return relevant[2]
			if(SOUTH)
				return relevant[3]
			if(WEST)
				return relevant[4]
	else
		switch(dir)
			if(NORTH)
				return offset_layer[1]
			if(EAST)
				return offset_layer[2]
			if(SOUTH)
				return offset_layer[3]
			if(WEST)
				return offset_layer[4]

/datum/component/riding_handler/proc/rider_pixel_offsets(dir, index = 1)
	RETURN_TYPE(/list)
	// format: x, y
	if(!islist(offset_pixel[1]))
		return offset_pixel
	// format: list(list(x, y), ...) for NESW
	if(!islist(offset_pixel[1][1]))
		switch(dir)
			if(NORTH)
				return offset_pixel[1]
			if(EAST)
				return offset_pixel[2]
			if(SOUTH)
				return offset_pixel[3]
			if(WEST)
				return offset_pixel[4]
	// format: list(list(x, y), ...) for NESW), ...) for indexes
	var/list/relevant = offset_pixel[min(offset_pixel.len, index)]
	switch(dir)
		if(NORTH)
			return relevant[1]
		if(EAST)
			return relevant[2]
		if(SOUTH)
			return relevant[3]
		if(WEST)
			return relevant[4]

/datum/component/riding_handler/proc/rider_dir_offset(dir, index = 1)
	return dir

#warn parse below

/datum/component/riding_handler/proc/handle_vehicle_layer()
	var/atom/movable/AM = parent
	var/static/list/defaults = list(TEXT_NORTH = OBJ_LAYER, TEXT_SOUTH = ABOVE_MOB_LAYER, TEXT_EAST = ABOVE_MOB_LAYER, TEXT_WEST = ABOVE_MOB_LAYER)
	. = defaults["[AM.dir]"]
	if(directional_vehicle_layers["[AM.dir]"])
		. = directional_vehicle_layers["[AM.dir]"]
	if(isnull(.))	//you can set it to null to not change it.
		. = AM.layer
	AM.layer = .

/datum/component/riding_handler/proc/set_vehicle_dir_layer(dir, layer)
	directional_vehicle_layers["[dir]"] = layer

/datum/component/riding_handler/proc/vehicle_moved(datum/source)
	var/atom/movable/AM = parent
	for(var/i in AM.buckled_mobs)
		ride_check(i)
	handle_vehicle_offsets()
	handle_vehicle_layer()

/datum/component/riding_handler/proc/ride_check(mob/living/M)
	var/atom/movable/AM = parent
	var/mob/AMM = AM
	if((ride_check_rider_restrained && M.restrained(TRUE)) || (ride_check_rider_incapacitated && M.incapacitated(FALSE, TRUE)) || (ride_check_ridden_incapacitated && istype(AMM) && AMM.incapacitated(FALSE, TRUE)))
		M.visible_message("<span class='warning'>[M] falls off of [AM]!</span>", \
						"<span class='warning'>You fall off of [AM]!</span>")
		AM.unbuckle_mob(M)
	return TRUE

/datum/component/riding_handler/proc/force_dismount(mob/rider)
	var/atom/movable/AM = parent
	AM.unbuckle_mob(M, BUCKLE_OP_FORCE)

//KEYS
/datum/component/riding_handler/proc/keycheck(mob/user)
	return !keytype || user.is_holding_item_of_type(keytype)

//MOVEMENT
/datum/component/riding_handler/proc/turf_check(turf/next, turf/current)
	if(allowed_turf_typecache && !allowed_turf_typecache[next.type])
		return (allow_one_away_from_valid_turf && allowed_turf_typecache[current.type])
	else if(forbid_turf_typecache && forbid_turf_typecache[next.type])
		return (allow_one_away_from_valid_turf && !forbid_turf_typecache[current.type])
	return TRUE

/datum/component/riding_handler/proc/handle_ride(mob/user, direction)
	var/atom/movable/AM = parent
	if(user.incapacitated())
		Unbuckle(user)
		return

	if(world.time < last_vehicle_move + ((last_move_diagonal? 2 : 1) * vehicle_move_delay))
		return
	last_vehicle_move = world.time

	if(keycheck(user))
		var/turf/next = get_step(AM, direction)
		var/turf/current = get_turf(AM)
		if(!istype(next) || !istype(current))
			return	//not happening.
		if(!turf_check(next, current))
			to_chat(user, "<span class='warning'>Your \the [AM] can not go onto [next]!</span>")
			return
		if(!Process_Spacemove(direction) || !isturf(AM.loc))
			return
		step(AM, direction)

		if((direction & (direction - 1)) && (AM.loc == next))		//moved diagonally
			last_move_diagonal = TRUE
		else
			last_move_diagonal = FALSE

		handle_vehicle_layer()
		handle_vehicle_offsets()
	else
		to_chat(user, "<span class='warning'>You'll need the keys in one of your hands to [drive_verb] [AM].</span>")

/datum/component/riding_handler/proc/Unbuckle(atom/movable/M)
	addtimer(CALLBACK(parent, /atom/movable/.proc/unbuckle_mob, M), 0, TIMER_UNIQUE)

/datum/component/riding_handler/proc/Process_Spacemove(direction)
	var/atom/movable/AM = parent
	return override_allow_spacemove || AM.has_gravity()

/datum/component/riding_handler/proc/account_limbs(mob/living/M)
	if(M.get_num_legs() < 2 && !slowed)
		vehicle_move_delay = vehicle_move_delay + slowvalue
		slowed = TRUE
	else if(slowed)
		vehicle_move_delay = vehicle_move_delay - slowvalue
		slowed = FALSE

///////Yes, I said humans. No, this won't end well...//////////
/datum/component/riding_handler/human
	del_on_unbuckle_all = TRUE

/datum/component/riding_handler/human/Initialize()
	. = ..()
	RegisterSignal(parent, COMSIG_HUMAN_MELEE_UNARMED_ATTACK, .proc/on_host_unarmed_melee)

/datum/component/riding_handler/human/proc/on_host_unarmed_melee(atom/target)
	var/mob/living/carbon/human/H = parent
	if(H.a_intent == INTENT_DISARM && (target in H.buckled_mobs))
		force_dismount(target)

/datum/component/riding_handler/human/handle_vehicle_layer()
	var/atom/movable/AM = parent
	if(AM.buckled_mobs && AM.buckled_mobs.len)
		for(var/mob/M in AM.buckled_mobs) //ensure proper layering of piggyback and carry, sometimes weird offsets get applied
			M.layer = MOB_LAYER
		if(!AM.buckle_lying)
			if(AM.dir == SOUTH)
				AM.layer = ABOVE_MOB_LAYER
			else
				AM.layer = OBJ_LAYER
		else
			if(AM.dir == NORTH)
				AM.layer = OBJ_LAYER
			else
				AM.layer = ABOVE_MOB_LAYER
	else
		AM.layer = MOB_LAYER

/datum/component/riding_handler/human/force_dismount(mob/living/user)
	var/atom/movable/AM = parent
	AM.unbuckle_mob(user)
	user.Paralyze(60)
	user.visible_message("<span class='warning'>[AM] pushes [user] off of [AM.p_them()]!</span>", \
						"<span class='warning'>[AM] pushes you off of [AM.p_them()]!</span>")

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
