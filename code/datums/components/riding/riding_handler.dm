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
	/// pixel offsets to set mobs to. list (x, y) OR list((x, y), (x, y), (x, y), (x, y)) for NESW OR list(list(NESW offsets of lists(x, y))) for positionals.
	var/list/offset_pixel = list(0, 0)
	/// same as offset pixel, but without the third option. set to null to not modify.
	var/list/offset_vehicle

	//! component-controlled movemnet
	/// default allowed turf handling - set to off if you override the var!!
	var/default_turf_checks = TRUE
	/// allowed turf types - turned into typecache.
	VAR_PRIVATE/list/allowed_turf_types
	/// forbidden turf types - turned into typecache.
	VAR_PRIVATE/list/forbid_turf_types
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

/datum/component/riding_handler/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, list(
		COMSIG_MOVABLE_MOB_BUCKLED,
		COMSIG_MOVABLE_MOB_UNBUCKLED,
		COMSIG_MOVABLE_MOVED,
		COMSIG_ATOM_DIR_CHANGE,
		COMSIG_ATOM_RELAYMOVE_FROM_BUCKLED
	))

/datum/component/riding_handler/proc/signal_hook_mob_buckled(atom/movable/source, mob/M, buckle_flags, mob/user)
	SIGNAL_HANDLER
	apply_rider(M)

/datum/component/riding_handler/proc/signal_hook_mob_unbuckled(atom/movable/source, mob/M, buckle_flags, mob/user)
	SIGNAL_HANDLER
	reset_rider(M)
	if(!source.has_buckled_mobs() && (riding_handler_flags & CF_RIDING_HANDLER_EPHEMERAL))
		qdel(src)

/datum/component/riding_handler/proc/signal_hook_handle_move(atom/movable/source, atom/old_loc, dir)
	SIGNAL_HANDLER
	update_riders_on_move(old_loc, dir)

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
	var/atom/movable/AM = parent
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

/**
 * returns a layer **offset** for a rider to be set to.
 * riders will default to our plane and layer. this is added onto layer.
 */
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

/**
 * returns list(x, y) of pixel offsets for a rider
 */
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

/**
 * returns what dir riders should be set to
 */
/datum/component/riding_handler/proc/rider_dir_offset(dir, index = 1)
	return dir

/datum/component/riding_handler/proc/signal_hook_handle_relaymove(datum/source, mob/M, dir)
	attempt_drive(M, dir)
	return COMPONENT_RELAYMOVE_HANDLED

/**
 * called to check if a mob has keys to us
 */
/datum/component/riding_handler/proc/keycheck(mob/M)
	return !keytype || M.is_holding_item_of_type(keytype)

/**
 * handles building our typecaches
 */
/datum/component/riding_handler/proc/build_turf_typecaches()
	allowed_turf_types = typelist(NAMEOF(allowed_turf_types), allowed_turf_types)
	forbid_turf_types = typelist(NAMEOF(src, forbid_turf_types), forbid_turf_types)
	if(!default_turf_checks)
		return
	if(has_typelist(NAMEOF(src, allowed_turf_typecache)))
		allowed_turf_typecache = get_typelist(NAMEOF(src, allowed_turf_typecache))
	else
		allowed_turf_typecache = typelist(NAMEOF(src, allowed_turf_typecache), typecacheof(allowed_turf_types))
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
			// allow if next isn't fine but current is fine,
			#warn impl
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
	if(!loc)
		return FALSE
	// cheap checks first
	if(world.time < next_vehicle_move)
		return
	// then expensive
	if(!keycheck(M))
		if(CHATSPAM_THROTTLE_DEFAULT)
			to_chat(M, SPAN_WARNING("You must have one of the keys in your hand to drive [parent]!"))
		return FALSE
	var/turf/next = get_step(src, dir)
	if(!_check_turf(next))
		if(CHATSPAM_THROTTLE_DEFAULT)
			to_chat(M, SPAN_WARNING("[parent] cannot drive onto [next]!"))
			#warn impl border cross message
		return FALSE
	if(!process_spacemove(dir))
		return FALSE
	// move
	last_vehicle_move = world.time
	next_vehicle_move = world.time + (last_move_diagonal? SQRT_2 : 1) * vehicle_move_delay
	var/atom/movable/AM = parent
	step(AM, dir)
	last_move_diagonal = (AM.loc == next) && (ISDIAGONALDIR(dir))
	return TRUE

/**
 * handles checks/updates when we move
 */
/datum/component/riding_handler/proc/update_riders_on_move(atom/old_loc, dir)
	// first check ridden mob
	if(!check_ridden(parent))
		// kick everyone off
		for(var/mob/M as anything in AM.buckled_mobs)
			force_dismount(M)
		return
	for(var/mob/M as anything in AM.buckled_mobs)
		if(!ride_check(M))
			continue	// don't do rest of logic

/**
 * checks if a person can stay on us. if not, they'll be kicked off by ride_check()
 */
/datum/component/riding_handler/proc/check_rider(mob/M)
	return check_entity(M, rider_check_flags)

/**
 * checks if the vehicle is usable right now.
 * if not, kicks everyone off.
 */
/datum/component/riding_handler/proc/check_ridden(atom/movable/AM)
	return check_entity(M, ridden_check_flags)

/**
 * checks an atom of riding flags
 */
/datum/component/riding_handler/proc/check_entity(atom/movable/AM, flags)
	var/mob/M = ismob(AM) && AM
	if(M && flags & CF_RIDING_CHECK_ARMS))
		// unimplemented
		pass()
		// unimplemented
	if(M && (flags & CF_RIDING_CHECK_LEGS))
		// unimplemented
		pass()
	if(M && (flags & CF_RIDING_CHECK_RESTRAINED) && M.restrained())
		return FALSE
	if(M && (flags & CF_RIDING_CHECK_UNCONSCIOUS) && !STAT_IS_CONSCIOUS(M))
		return FALES
	return TRUE

/**
 * checks if someone can stay on. if they can't, kick them off.
 */
/datum/component/riding_handler/proc/ride_check(mob/M)
	var/atom/movable/AM = parent
	if(!check_rider(M))
		force_dismonut(M)
		return FALSE
	return TRUE

/**
 * kicks off a rider
 */
/datum/component/riding_handler/proc/force_dismount(mob/M)
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
