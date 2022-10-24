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
	dupe_mode = COMPONENT_DUPE_UNIQUE
	dupe_type = /datum/component/riding_handler
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
	/**
	 * holds vehicle offsets
	 *
	 * list(x, y) OR list(list(x, y), list(x, y), list(x, y), list(x, y)) for NESW
	 */
	var/list/vehicle_offsets = list(0, 0)
	/**
	 * holds rider offsets
	 * first: x
	 * second: y
	 * third: layer
	 * fourth: dir
	 *
	 * see [code/__DEFINES/dcs/components/riding.dm]
	 */
	var/list/rider_offsets = list(0, 0, 0, null)
	/// see [code/__DEFINES/dcs/components/riding.dm]
	var/rider_offset_format = CF_RIDING_OFFSETS_SIMPLE

	//! component-controlled movemnet
	/// default allowed turf handling - set to off if you override the var!!
	var/default_turf_checks = TRUE
	/// allowed turf types - turned into typecache.
	var/list/allowed_turf_types
	/// forbidden turf types - turned into typecache.
	var/list/forbid_turf_types
	/// tick delay between movements
	var/vehicle_move_delay = 2
	/// key type needed, if it is needed
	var/keytype
	/// verb for controlling this
	var/drive_verb = "drive"

	//! operational - general
	/// last dir. used to avoid redoing expensive setdir stuff
	var/tmp/_last_dir

	//! operational - driving
	/// typecache of allowed turfs
	VAR_PRIVATE/tmp/list/allowed_turf_typecache
	/// typecache of forbidden turfs
	VAR_PRIVATE/tmp/list/forbid_turf_typecache
	/// last time we moved via driving
	var/last_move_time = 0
	/// next time we can move via driving
	var/next_move_time
	/// was the last move diagonal?
	var/last_move_diagonal = FALSE
	/// last turf we were on
	var/turf/last_turf

/datum/component/riding_handler/Initialize()
	. = ..()
	if(. & COMPONENT_INCOMPATIBLE)
		return
	if(!istype(parent, expected_typepath))
		return COMPONENT_INCOMPATIBLE
	build_turf_typecaches()

/datum/component/riding_handler/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_MOVABLE_MOB_BUCKLED, .proc/signal_hook_mob_buckled)
	RegisterSignal(parent, COMSIG_MOVABLE_MOB_UNBUCKLED, .proc/signal_hook_mob_unbuckled)
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, .proc/signal_hook_handle_move)
	RegisterSignal(parent, COMSIG_ATOM_DIR_CHANGE, .proc/signal_hook_handle_turn)
	RegisterSignal(parent, COMSIG_ATOM_RELAYMOVE_FROM_BUCKLED, .proc/signal_hook_handle_relaymove)
	RegisterSignal(parent, COMSIG_MOVABLE_PRE_BUCKLE_MOB, .proc/signal_hook_pre_buckle_mob)
	RegisterSignal(parent, COMSIG_MOVABLE_PIXEL_OFFSET_CHANGED, .proc/signal_hook_pixel_offset_changed)

/datum/component/riding_handler/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, list(
		COMSIG_MOVABLE_MOB_BUCKLED,
		COMSIG_MOVABLE_MOB_UNBUCKLED,
		COMSIG_MOVABLE_MOVED,
		COMSIG_ATOM_DIR_CHANGE,
		COMSIG_ATOM_RELAYMOVE_FROM_BUCKLED,
		COMSIG_MOVABLE_PRE_BUCKLE_MOB
	))

/datum/component/riding_handler/proc/signal_hook_mob_buckled(atom/movable/source, mob/M, buckle_flags, mob/user, semantic)
	SIGNAL_HANDLER
	on_rider_buckled(M, semantic)

/datum/component/riding_handler/proc/signal_hook_mob_unbuckled(atom/movable/source, mob/M, buckle_flags, mob/user, semantic)
	SIGNAL_HANDLER
	on_rider_unbuckled(M, semantic)
	if(!source.has_buckled_mobs() && (riding_handler_flags & CF_RIDING_HANDLER_EPHEMERAL))
		qdel(src)

/datum/component/riding_handler/proc/signal_hook_handle_move(atom/movable/source, atom/old_loc, dir)
	SIGNAL_HANDLER
	update_riders_on_move(old_loc, dir)
	last_turf = isturf(old_loc)? old_loc : null

/datum/component/riding_handler/proc/signal_hook_handle_turn(atom/movable/source, old_dir, new_dir)
	SIGNAL_HANDLER
	update_vehicle_on_turn(new_dir)
	full_update_riders(new_dir)

/datum/component/riding_handler/proc/signal_hook_pre_buckle_mob(atom/movable/source, mob/M, flags, mob/user, semantic)
	SIGNAL_HANDLER_DOES_SLEEP
	if(!check_rider(M, semantic, TRUE, user = user))
		return COMPONENT_BLOCK_BUCKLE_OPERATION

/datum/component/riding_handler/proc/signal_hook_pixel_offset_changed(atom/movable/source)
	full_update_riders(null, TRUE)

/datum/component/riding_handler/proc/update_vehicle_on_turn(dir)
	if(!vehicle_offsets)
		return
	var/atom/movable/AM = parent
	var/opx = AM.get_managed_pixel_x()
	var/opy = AM.get_managed_pixel_y()
	if(islist(vehicle_offsets[1]))
		// NESW format
		switch(dir)
			if(NORTH)
				AM.pixel_x = vehicle_offsets[1][1] + opx
				AM.pixel_y = vehicle_offsets[1][2] + opy
			if(EAST)
				AM.pixel_x = vehicle_offsets[2][1] + opx
				AM.pixel_y = vehicle_offsets[2][2] + opy
			if(SOUTH)
				AM.pixel_x = vehicle_offsets[3][1] + opx
				AM.pixel_y = vehicle_offsets[3][2] + opy
			if(WEST)
				AM.pixel_x = vehicle_offsets[4][1] + opx
				AM.pixel_y = vehicle_offsets[4][2] + opy
	else
		AM.pixel_x = vehicle_offsets[1] + opx
		AM.pixel_y = vehicle_offsets[2] + opy

/datum/component/riding_handler/proc/on_rider_buckled(mob/rider, semantic)
	full_update_riders(force = TRUE)

/datum/component/riding_handler/proc/on_rider_unbuckled(mob/rider, semantic)
	reset_rider(rider, semantic)
	full_update_riders(force = TRUE)

/datum/component/riding_handler/proc/reset_rider(mob/rider, semantic)
	rider.reset_plane_and_layer()
	rider.reset_pixel_shifting()
	rider.reset_pixel_offsets()

/datum/component/riding_handler/proc/update_riders_on_turn(dir)
	full_update_riders()

/datum/component/riding_handler/proc/full_update_riders(dir, force)
	var/atom/movable/AM = parent
	if(!dir)
		dir = AM.dir
	if(_last_dir == dir && !force)
		return
	_last_dir = dir
	var/ppx = AM.get_centering_pixel_x_offset(dir)
	var/ppy = AM.get_centering_pixel_y_offset(dir)
	var/list/offsets
	var/i
	var/mob/M
	var/semantic
	var/dir_override
	// determine offset format
	switch(rider_offset_format)
		if(CF_RIDING_OFFSETS_SIMPLE)
			for(i in 1 to length(AM.buckled_mobs))
				M = AM.buckled_mobs[i]
				semantic = AM.buckled_mobs[M]
				offsets = rider_offsets(M, i, semantic, rider_offsets, dir)
				dir_override = offsets[4] || dir
				if(dir_override != M.dir)
					M.setDir(offsets[4])
				M.reset_pixel_shifting()
				M.set_base_layer(offsets[3] + AM.layer)
				M.pixel_x = ppx + M.get_standard_pixel_x_offset() - M.get_centering_pixel_x_offset(dir) + offsets[1]
				M.pixel_y = ppy + M.get_standard_pixel_y_offset() - M.get_centering_pixel_y_offset(dir) + offsets[2]
		if(CF_RIDING_OFFSETS_DIRECTIONAL)
			var/list/relevant
			switch(dir)
				if(NORTH)
					relevant = rider_offsets[1]
				if(SOUTH)
					relevant = rider_offsets[3]
				if(EAST)
					relevant = rider_offsets[2]
				if(WEST)
					relevant = rider_offsets[4]
			for(i in 1 to length(AM.buckled_mobs))
				M = AM.buckled_mobs[i]
				semantic = AM.buckled_mobs[M]
				offsets = rider_offsets(M, i, semantic, relevant, dir)
				dir_override = offsets[4] || dir
				if(dir_override != M.dir)
					M.setDir(offsets[4])
				M.reset_pixel_shifting()
				M.set_base_layer(offsets[3] + AM.layer)
				M.pixel_x = ppx + M.get_standard_pixel_x_offset() - M.get_centering_pixel_x_offset(dir) + offsets[1]
				M.pixel_y = ppy + M.get_standard_pixel_y_offset() - M.get_centering_pixel_y_offset(dir) + offsets[2]
		if(CF_RIDING_OFFSETS_ENUMERATED)
			var/list/relevant
			var/rider_offsets_len = length(rider_offsets)
			for(i in 1 to length(AM.buckled_mobs))
				relevant = rider_offsets[min(rider_offsets_len, i)]
				switch(dir)
					if(NORTH)
						relevant = relevant[1]
					if(SOUTH)
						relevant = relevant[3]
					if(EAST)
						relevant = relevant[2]
					if(WEST)
						relevant = relevant[4]
				M = AM.buckled_mobs[i]
				semantic = AM.buckled_mobs[M]
				offsets = rider_offsets(M, i, semantic, relevant, dir)
				dir_override = offsets[4] || dir
				if(dir_override != M.dir)
					M.setDir(offsets[4])
				M.reset_pixel_shifting()
				M.set_base_layer(offsets[3] + AM.layer)
				M.pixel_x = ppx + M.get_standard_pixel_x_offset() - M.get_centering_pixel_x_offset(dir) + offsets[1]
				M.pixel_y = ppy + M.get_standard_pixel_y_offset() - M.get_centering_pixel_y_offset(dir) + offsets[2]

/**
 * returns transformed rider offset list
 *
 * DO NOT CHANGE DEFAULT FOR THE LOVE OF GOD, COPY IT IF YOU ARE CHANGING IT!!
 */
/datum/component/riding_handler/proc/rider_offsets(mob/rider, pos, semantic, list/default, dir)
	return default

/datum/component/riding_handler/proc/signal_hook_handle_relaymove(datum/source, mob/M, dir)
	attempt_drive(M, dir)
	return COMPONENT_RELAYMOVE_HANDLED

/**
 * called to check if a mob has keys to us
 */
/datum/component/riding_handler/proc/keycheck(mob/M)
	return !keytype || M.get_held_item_of_type(keytype)

/**
 * handles building our typecaches
 */
/datum/component/riding_handler/proc/build_turf_typecaches()
	allowed_turf_types = typelist(NAMEOF(src, allowed_turf_types), allowed_turf_types)
	forbid_turf_types = typelist(NAMEOF(src, forbid_turf_types), forbid_turf_types)
	if(!default_turf_checks)
		return
	if(LAZYLEN(allowed_turf_types))
		if(has_typelist(NAMEOF(src, allowed_turf_typecache)))
			allowed_turf_typecache = get_typelist(NAMEOF(src, allowed_turf_typecache))
		else
			allowed_turf_typecache = typelist(NAMEOF(src, allowed_turf_typecache), typecacheof(allowed_turf_types))
	if(LAZYLEN(forbid_turf_types))
		if(has_typelist(NAMEOF(src, forbid_turf_typecache)))
			forbid_turf_typecache = get_typelist(NAMEOF(src, forbid_turf_typecache))
		else
			forbid_turf_typecache = typelist(NAMEOF(src, forbid_turf_typecache), typecacheof(forbid_turf_types))

/**
 * checks if we can move onto a turf
 */
/datum/component/riding_handler/proc/turfcheck(turf/next)
	if(!default_turf_checks)
		stack_trace("default turf checks was off even though we use them")
		default_turf_checks = TRUE
	return (!allowed_turf_typecache || allowed_turf_typecache[next.type]) && (!forbid_turf_typecache || !forbid_turf_typecache[next.type])

/**
 * handles checking if we can go on a turf
 * don't override this, override turfcheck().
 */
/datum/component/riding_handler/proc/_check_turf(turf/next)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(riding_handler_flags & CF_RIDING_HANDLER_ALLOW_BORDER)
		// allow one off
		if(riding_handler_flags & CF_RIDING_HANDLER_FORBID_BORDER_CROSS)
			// allow if last was fine, or if next and current are fine
			var/current_fine = turfcheck(get_turf(parent))
			// this WILL let us skip over diagonal boundaries, so you have to design around that!
			return current_fine ? (turfcheck(next) || turfcheck(last_turf)) : (turfcheck(next) && (get_dist(next, last_turf) <= 1))
		else
			// allow either if next or current is fine, which lets us cross 1-wide borders
			return turfcheck(next) || turfcheck(get_turf(parent))
	else
		// don't
		return turfcheck(next)

/**
 * called when a mob wants to drive us
 */
/datum/component/riding_handler/proc/attempt_drive(mob/M, dir)
	if(!(riding_handler_flags & CF_RIDING_HANDLER_IS_CONTROLLABLE))
		return FALSE
	var/atom/movable/AM = parent
	if(!AM.loc)
		return FALSE
	// cheap checks first
	if(world.time < next_move_time)
		return
	// then expensive
	if(!driver_check(M))
		return
	if(!keycheck(M))
		if(CHATSPAM_THROTTLE_DEFAULT)
			to_chat(M, SPAN_WARNING("You must have one of the keys in your hand to drive [AM]!"))
		return FALSE
	var/turf/next = get_step(AM, dir)
	if(!_check_turf(next))
		if(CHATSPAM_THROTTLE_DEFAULT)
			to_chat(M, SPAN_WARNING("[parent] cannot drive onto [next]!"))
		return FALSE
	if(!process_spacemove(dir))
		return FALSE
	// move
	last_move_time = world.time
	next_move_time = world.time + (last_move_diagonal? SQRT_2 : 1) * vehicle_move_delay
	step(AM, dir)
	last_move_diagonal = (AM.loc == next) && (ISDIAGONALDIR(dir))
	return TRUE

/**
 * arbitrary driver check for a mob
 */
/datum/component/riding_handler/proc/driver_check(mob/M)
	return TRUE

/**
 * handles checks/updates when we move
 */
/datum/component/riding_handler/proc/update_riders_on_move(atom/old_loc, dir)
	var/atom/movable/AM = parent
	// first check ridden mob
	if(!check_ridden(parent, TRUE))
		// kick everyone off
		for(var/mob/M as anything in AM.buckled_mobs)
			force_dismount(M)
		return
	for(var/mob/M as anything in AM.buckled_mobs)
		if(!check_rider(M, AM.buckled_mobs[M], TRUE))
			force_dismount(M)
			continue	// don't do rest of logic

/**
 * checks if a person can stay on us. if not, they'll be kicked off by ride_check()
 */
/datum/component/riding_handler/proc/check_rider(mob/M, semantic, notify, mob/user)
	return check_entity(M, rider_check_flags, semantic, notify, user)

/**
 * checks if the vehicle is usable right now.
 * if not, kicks everyone off.
 */
/datum/component/riding_handler/proc/check_ridden(atom/movable/AM, notify, mob/user)
	return check_entity(AM, ridden_check_flags, BUCKLE_SEMANTIC_WE_ARE_THE_VEHICLE, notify, user)

/**
 * checks an atom of riding flags
 */
/datum/component/riding_handler/proc/check_entity(atom/movable/AM, flags, semantic, notify, mob/user)
	var/mob/M = ismob(AM)? AM : null
	if(!user)
		user = M
	var/we_are_the_vehicle = semantic == BUCKLE_SEMANTIC_WE_ARE_THE_VEHICLE
	if(M && flags & CF_RIDING_CHECK_ARMS)
		// unimplemented
		pass()
	if(M && (flags & CF_RIDING_CHECK_LEGS))
		// unimplemented
		pass()
	if(M && (flags & CF_RIDING_CHECK_RESTRAINED) && M.restrained())
		if(notify && user)
			if(we_are_the_vehicle)
				to_chat(user, SPAN_WARNING("You cannot carry people while restrained!"))
			else if(user == AM)
				to_chat(user, SPAN_WARNING("You cannot ride on [parent] while restrained!"))
			else
				to_chat(user, SPAN_WARNING("[AM] cannot ride on [parent] whlie restrained!"))
		return FALSE
	if(M && (flags & CF_RIDING_CHECK_UNCONSCIOUS) && !IS_CONSCIOUS(M))
		if(notify && user)
			if(we_are_the_vehicle)
				to_chat(user, SPAN_WARNING("You cannot carry people while unconscious!"))
			else if(user == AM)
				to_chat(user, SPAN_WARNING("You cannot ride on [parent] while unconscious!"))
			else
				to_chat(user, SPAN_WARNING("[AM] cannot ride on [parent] whlie unconscious!"))
		return FALSE
	if(M && (flags & CF_RIDING_CHECK_RESTRAINED) && M.restrained())
		if(notify && user)
			if(we_are_the_vehicle)
				to_chat(user, SPAN_WARNING("You cannot carry people while restrained!"))
			else if(user == AM)
				to_chat(user, SPAN_WARNING("You cannot ride on [parent] while restrained!"))
			else
				to_chat(user, SPAN_WARNING("[AM] cannot ride on [parent] whlie restrained!"))
		return FALSE
	if(M && (flags & CF_RIDING_CHECK_INCAPACITATED) && M.incapacitated())
		if(notify && user)
			if(we_are_the_vehicle)
				to_chat(user, SPAN_WARNING("You cannot carry people while incapacitated!"))
			else if(user == AM)
				to_chat(user, SPAN_WARNING("You cannot ride on [parent] while incapacitated!"))
			else
				to_chat(user, SPAN_WARNING("[AM] cannot ride on [parent] whlie incapacitated!"))
		return FALSE
	if(M && (flags & CF_RIDING_CHECK_LYING) && M.lying)
		if(notify && user)
			if(we_are_the_vehicle)
				to_chat(user, SPAN_WARNING("You cannot carry people while laying down!"))
			else if(user == AM)
				to_chat(user, SPAN_WARNING("You cannot ride on [parent] while laying down!"))
			else
				to_chat(user, SPAN_WARNING("[AM] cannot ride on [parent] whlie laying down!"))
		return FALSE
	return TRUE

/**
 * checks if someone can stay on. if they can't, kick them off.
 */
/datum/component/riding_handler/proc/ride_check(mob/M)
	var/atom/movable/AM = parent
	if(!check_rider(M, AM.buckled_mobs[M]))
		force_dismount(M, AM.buckled_mobs[M])
		return FALSE
	return TRUE

/**
 * kicks off a rider
 */
/datum/component/riding_handler/proc/force_dismount(mob/M, semantic)
	var/atom/movable/AM = parent
	AM.visible_message(
		SPAN_WARNING("[M] falls off of [AM]!"),
		SPAN_WARNING("You fall off of [AM]!")
	)
	AM.unbuckle_mob(M, BUCKLE_OP_FORCE)

/datum/component/riding_handler/proc/process_spacemove()
	var/atom/movable/AM = parent
	// todo: process_spacemove() on atom movable instead of hasgrav.
	return (riding_handler_flags & CF_RIDING_HANDLER_FORCED_SPACEMOVE) || AM.has_gravity()
