/**
 * Riding filter components
 *
 * Filters who can/can't ride this mob and in what circumstances.
 *
 * They also handle initializing the handler.
 *
 * **The only reason this is not an element is admin abuse.**
 * I'm not even joking. Oh, and I guess adding support for one time fuckery.
 * Elements cache the datum, which is usually how you save memory because we don't have to write complex lists/whatnot.
 * However, they still hanve to register signals.
 *
 * We can achieve the same effect to a lighter degree due to this, by just not overriding variables with non constant instances (like lists, etc)
 *
 * **Avoid LoadComponent and GetComponent.** It's better to subtype these than to fuck around with manual var overrides
 * If people start doing the latter outside of absolute necessity I'll just make these all an element because you SHOULDN'T DO THAT!
 *
 * ! Right now, we DO use LoadComponent as "assert riding component exists" in this.
 * ! The other option is put check logic on riding components only and always instantiate, rather than on success.
 * ! I picked this poison rather than the other. If you think the other is good and can write it well, feel free to refactor.
 *
 * ? This component overrides all normal can buckles and will force operations if needed. Be careful.
 */
/datum/component/riding_filter
	//? disabled as we don't have dupe handling
	can_transfer = FALSE
	dupe_mode = COMPONENT_DUPE_UNIQUE
	dupe_type = /datum/component/riding_filter
	/// filter flags
	var/riding_filter_flags = CF_RIDING_FILTER_AUTO_BUCKLE_TOGGLE
	/// expected typepath of what we're to be filtering for
	var/expected_typepath = /atom/movable
	/// the path of the riding handler component we're going to make.
	var/handler_typepath = /datum/component/riding_handler
	/// implements smart can_buckle checks rather than just pre_buckle
	var/implements_can_buckle_hints = FALSE
	/// offhands required on people buckled to us
	var/offhands_needed_rider = 0
	/// hard requirement of offhands? if not, we won't try to equip more than they have hands to equip
	var/offhand_requirements_are_rigid = TRUE
	/// ~~our overlays~~ e-er, I mean our_offhands.
	var/list/our_offhands

/datum/component/riding_filter/Initialize(handler_typepath)
	. = ..()
	if(. & COMPONENT_INCOMPATIBLE)
		return
	if(!istype(parent, expected_typepath))
		return COMPONENT_INCOMPATIBLE
	if(handler_typepath)
		if(!ispath(handler_typepath, /datum/component/riding_handler))
			. = COMPONENT_INCOMPATIBLE
			CRASH("bad handler typepath passed in")
		src.handler_typepath = handler_typepath

/datum/component/riding_filter/Destroy()
	for(var/obj/item/offhand/riding/R in our_offhands)
		R._silently_erase()
	our_offhands = null
	return ..()

/datum/component/riding_filter/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_MOVABLE_PRE_BUCKLE_MOB, .proc/signal_hook_pre_buckle)
	RegisterSignal(parent, COMSIG_MOVABLE_MOB_BUCKLED, .proc/signal_hook_post_buckle)
	RegisterSignal(parent, COMSIG_MOVABLE_USER_BUCKLE_MOB, .proc/signal_hook_user_buckle)
	RegisterSignal(parent, COMSIG_MOVABLE_MOB_UNBUCKLED, .proc/signal_hook_mob_unbuckle)
	if(implements_can_buckle_hints)
		RegisterSignal(parent, COMSIG_MOVABLE_CAN_BUCKLE_MOB, .proc/signal_hook_can_buckle)

/datum/component/riding_filter/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, list(
		COMSIG_MOVABLE_PRE_BUCKLE_MOB,
		COMSIG_MOVABLE_MOB_BUCKLED,
		COMSIG_MOVABLE_CAN_BUCKLE_MOB,
		COMSIG_MOVABLE_USER_BUCKLE_MOB,
		COMSIG_MOVABLE_MOB_UNBUCKLED
	))

/datum/component/riding_filter/proc/signal_hook_user_buckle(atom/movable/source, mob/M, flags, mob/user, semantic)
	SIGNAL_HANDLER_DOES_SLEEP
	return check_user_mount(M, flags, user, semantic)? COMPONENT_FORCE_BUCKLE_OPERATION : COMPONENT_BLOCK_BUCKLE_OPERATION

/datum/component/riding_filter/proc/signal_hook_pre_buckle(atom/movable/source, mob/M, flags, mob/user, semantic)
	SIGNAL_HANDLER
	return on_mount_attempt(M, flags, user, semantic)? COMPONENT_FORCE_BUCKLE_OPERATION : COMPONENT_BLOCK_BUCKLE_OPERATION

/datum/component/riding_filter/proc/signal_hook_post_buckle(atom/movable/source, mob/M, flags, mob/user, semantic)
	SIGNAL_HANDLER
	var/datum/component/riding_handler/handler = handler_instantiated()
	if(!handler)
		// don't care
		return
	post_buckle_handler_tweak(handler, M, flags, user, semantic)

/datum/component/riding_filter/proc/signal_hook_mob_unbuckle(atom/movable/source, mob/M, flags, mob/user, semantic)
	SIGNAL_HANDLER
	cleanup_rider(M, semantic)

/**
 * if implemented (set `implements_can_buckle_hints` to TRUE), allows us to hint early
 * that something can't buckle, rather than interrupting last moment during pre_buckle.
 *
 * it is good practice, but not required, to do this.
 */
/datum/component/riding_filter/proc/signal_hook_can_buckle(atom/movable/source, mob/M, flags, mob/user, semantic)
	SIGNAL_HANDLER
	return check_mount_attempt(M, flags, user, semantic)? COMPONENT_FORCE_BUCKLE_OPERATION : COMPONENT_BLOCK_BUCKLE_OPERATION

/**
 * called on buckling process right before point of no return
 * overrides atom opinion.
 */
/datum/component/riding_filter/proc/on_mount_attempt(mob/M, buckle_flags, mob/user, semantic)
	if(!check_mount_attempt(M, buckle_flags, user, semantic))
		return FALSE
	. = TRUE
	var/datum/component/riding_handler/handler = create_riding_handler(M, buckle_flags, user, semantic)
	pre_buckle_handler_tweak(handler, M, buckle_flags, user, semantic)

/**
 * checks if we should allow someone to mount.
 * overrides atom opinion.
 */
/datum/component/riding_filter/proc/check_mount_attempt(mob/M, buckle_flags, mob/user, semantic)
	if(!mount_allocate_offhands(M, buckle_flags, user, semantic))
		return FALSE
	return TRUE

/**
 * checks if we should allow an entity to buckle another entity to us
 * overrides atom opinion
 */
/datum/component/riding_filter/proc/check_user_mount(mob/M, buckle_flags, mob/user, semantic)
	return TRUE

/datum/component/riding_filter/proc/create_riding_handler(mob/M, buckle_flags, mob/user, semantic, ...)
	return handler_instantiated() || parent.LoadComponent(handler_typepath)

/datum/component/riding_filter/proc/handler_instantiated()
	RETURN_TYPE(/datum/component/riding_handler)
	return parent.GetComponent(/datum/component/riding_handler)

/datum/component/riding_filter/proc/pre_buckle_handler_tweak(datum/component/riding_handler/handler, mob/M, flags, mob/user, semantic, ...)
	return

/datum/component/riding_filter/proc/post_buckle_handler_tweak(datum/component/riding_handler/handler, mob/M, flags, mob/user, semantic, ...)
	return

/datum/component/riding_filter/proc/cleanup_rider(mob/rider, semantic)
	cleanup_rider_offhands(rider)
	check_offhands(rider, TRUE)

/**
 * handles offhand allocation on mount
 */
/datum/component/riding_filter/proc/mount_allocate_offhands(mob/M, buckle_flags, mob/user, semantic)
	var/list/allocating = list()
	if(!allocate_offhands(M, semantic, allocating))
		for(var/obj/item/offhand/riding/R in allocating)
			R._silently_erase()
		our_offhands -= allocating
	return TRUE

/**
 * ensures offhands required are equipped
 * pass in a rider to only check them, else we check all.
 * pass in unbuckling if checking after unbuckling, so we can destroy offhands without triggering a loop.
 *
 * ! This proc is shitcode, don't fuck with this without knowing what you're doing.
 */
/datum/component/riding_filter/proc/check_offhands(mob/rider, unbuckling)
	if(unbuckling)
		return		// base level don't care as of now
	var/atom/movable/AM = parent
	if(rider)
		// verify their offhands are there
		var/buckled = (rider in AM.buckled_mobs)
		// if buckled and not enough
		if(buckled && (length(get_offhands_of_rider(rider)) < rider_offhands_needed(rider, AM.buckled_mobs[rider])))
			// kick off
			AM.unbuckle_mob(rider, BUCKLE_OP_FORCE)
	else
		// verify all offhands are there
		for(var/mob/M in AM.buckled_mobs)
			if(length(get_offhands_of_rider(M)) < rider_offhands_needed(M, AM.buckled_mobs[M]))
				// kick off if not enough
				M.visible_message(
					SPAN_NOTICE("[M] slides off [AM]."),
					SPAN_NOTICE("You slide off [AM].")
				)
				AM.unbuckle_mob(M, BUCKLE_OP_FORCE)

/datum/component/riding_filter/proc/rider_offhands_needed(mob/rider, semantic)
	return offhands_needed_rider

/datum/component/riding_filter/proc/get_offhands_of_rider(mob/rider)
	RETURN_TYPE(/list)
	. = list()
	for(var/obj/item/offhand/riding/R as anything in rider.get_held_items_of_type(/obj/item/offhand/riding))
		if(R.filter == src)
			. += R

/**
 * called to register offhands for a new rider
 * returns true/false based on success/failure
 */
/datum/component/riding_filter/proc/allocate_offhands(mob/rider, semantic, list/offhands)
	ASSERT(islist(offhands))
	var/amount_needed = rider_offhands_needed(rider, semantic)
	if(!offhand_requirements_are_rigid)
		amount_needed = min(amount_needed, rider.get_number_of_hands())
	if(!amount_needed)
		return TRUE
	for(var/i in 1 to amount_needed)
		var/obj/item/offhand/riding/R = try_equip_offhand_to_rider(rider)
		if(!R)
			return FALSE
		offhands += R
	return TRUE

/datum/component/riding_filter/proc/offhand_destroyed(obj/item/offhand/riding/offhand, mob/rider)
	check_offhands(rider)

/datum/component/riding_filter/proc/try_equip_offhand_to_rider(mob/rider)
	var/obj/item/offhand/riding/R = rider.allocate_offhand(/obj/item/offhand/riding)
	if(!R)
		return
	R.filter = src
	R.owner = rider
	LAZYADD(our_offhands, R)
	return R

/datum/component/riding_filter/proc/cleanup_rider_offhands(mob/rider)
	for(var/obj/item/offhand/riding/R as anything in rider.get_held_items_of_type(/obj/item/offhand/riding))
		R._silently_erase()
		LAZYREMOVE(our_offhands, R)

/**
 * grab all necessary offhands
 * qdel the entire list on failure.
 */

/obj/item/offhand/riding
	name = "riding offhand"
	desc = "Your hand is full carrying someone on you!"
	/// riding handler component
	var/datum/component/riding_filter/mob/filter
	/// person
	var/mob/owner

/obj/item/offhand/riding/Destroy()
	if(filter)
		filter.offhand_destroyed(src, owner)
		LAZYREMOVE(filter.our_offhands, src)
	filter = null
	owner = null
	return ..()

/obj/item/offhand/riding/proc/_silently_erase()
	filter = null
	owner = null
	qdel(src)
