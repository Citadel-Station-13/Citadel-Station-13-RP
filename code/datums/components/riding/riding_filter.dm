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
	/// expected typepath of what we're to be filtering for
	var/expected_typepath = /atom/movable
	/// the path of the riding handler component we're going to make
	var/handler_typepath = /datum/component/riding_handler
	/// implements smart can_buckle checks rather than just pre_buckle
	var/implements_can_buckle_hints = FALSE
	/// offhands required on people buckled to us
	var/offhands_needed_rider = 0
	/// hard requirement of offhands? if not, we won't try to equip more than they have hands to equip
	var/offhand_requirements_are_rigid = TRUE
	/// ~~our overlays~~ e-er, I mean our_offhands.
	var/list/our_offhands

/datum/component/riding_filter/Initialize()
	. = ..()
	if(. & COMPONENT_INCOMPATIBLE)
		return
	if(!istype(parent, expected_typepath))
		return COMPONENT_INCOMPATIBLE

/datum/component/riding_filter/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_MOVABLE_PRE_MOB_BUCKLED, .proc/signal_hook_pre_buckle)
	RegisterSignal(parent, COMSIG_MOVABLE_MOB_BUCKLED, .proc/signal_hook_post_buckle)
	RegisterSignal(parent, COMSIG_MOVABLE_USER_BUCKLE_MOB, .proc/signal_hook_user_buckle)
	if(implements_can_buckle_hints)
		RegisterSignal(parent, COMSIG_MOVABLE_CAN_BUCKLE_MOB, .proc/signal_hook_can_buckle)

/datum/component/riding_filter/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, list(
		COMSIG_MOVABLE_PRE_MOB_BUCKLED,
		COMSIG_MOVABLE_MOB_BUCKLED,
		COMSIG_MOVABLE_CAN_BUCKLE_MOB,
		COMSIG_MOVABLE_USER_BUCKLE_MOB
	))

/datum/component/riding_filter/proc/signal_hook_user_buckle(atom/movable/source, mob/M, flags, mob/user)
	SIGNAL_HANDLER_DOES_SLEEP
	return check_user_mount(M, flags, user)? COMPONENT_FORCE_BUCKLE_OPERATION : COMPONENT_BLOCK_BUCKLE_OPERATION

/datum/component/riding_filter/proc/signal_hook_pre_buckle(atom/movable/source, mob/M, flags, mob/user)
	SIGNAL_HANDLER
	return on_mount_attempt(M, flags, user)? COMPONENT_FORCE_BUCKLE_OPERATION : COMPONENT_BLOCK_BUCKLE_OPERATION

/datum/component/riding_filter/proc/signal_hook_post_buckle(atom/movable/source, mob/M, flags, mob/user)
	SIGNAL_HANDLER
	var/datum/component/riding_handler/handler = handler_instantiated()
	if(!handler)
		// don't care
		return
	post_buckle_handler_tweak(handler, M, flags, user)

/**
 * if implemented (set `implements_can_buckle_hints` to TRUE), allows us to hint early
 * that something can't buckle, rather than interrupting last moment during pre_buckle.
 *
 * it is good practice, but not required, to do this.
 */
/datum/component/riding_filter/proc/signal_hook_can_buckle(atom/movable/source, mob/M, flags, mob/user)
	SIGNAL_HANDLER
	return check_mount_attempt(M, flags, user)? COMPONENT_FORCE_BUCKLE_OPERATION : COMPONENT_BLOCK_BUCKLE_OPERATION

/**
 * called on buckling process right before point of no return
 * overrides atom opinion.
 */
/datum/component/riding_filter/proc/on_mount_attempt(mob/M, buckle_flags, mob/user)
	if(!check_mount_attempt(M, buckle_flags, user))
		return FALSE
	. = TRUE
	var/datum/component/riding_handler/handler = create_riding_handler(M, buckle_flags, user)
	pre_buckle_handler_tweak(handler, M, buckle_flags, user)

/**
 * checks if we should allow someone to mount.
 * overrides atom opinion.
 */
/datum/component/riding_filter/proc/check_mount_attempt(mob/M, buckle_flags, mob/user)
	if(offhands_needed_rider)
		var/list/obj/item/offhand/riding/created = list()
		for(var/i in (offhand_requirements_are_rigid? offhands_needed_rider : (min(M.get_number_of_hands(), offhands_needed_rider))))
			var/obj/item/offhand/riding/creating = try_equip_offhand_to_rider(M)
			if(!creating)
				// destroy all existing
				QDEL_LIST(created)
				created = null
				break
			created += creating
		if(!created)
			// we failed
			return FALSE
	return TRUE

/**
 * checks if we should allow an entity to buckle another entity to us
 * overrides atom opinion
 */
/datum/componnet/riding_filter/proc/check_user_mount(mob/M, buckle_flags, mob/user)
	return TRUE

/datum/component/riding_filter/proc/create_riding_handler(mob/M, buckle_flags, mob/user, ...)
	return handler_instantiated() || parent.LoadComponent(handler_typepath)

/datum/component/riding_filter/proc/handler_instantiated()
	RETURN_TYPE(/datum/component/riding_handler)
	return LoadComponent(/datum/component/riding_handler)

/datum/component/riding_filter/proc/pre_buckle_handler_tweak(datum/component/riding_handler/handler, mob/M, flags, mob/user, ...)
	return

/datum/component/riding_filter/proc/post_buckle_handler_tweak(datum/component/riding_handler/handler, mob/M, flags, mob/user, ...)
	return

/**
 * ensures offhands required are equipped
 * pass in a rider to only check them, else we check all.
 */
/datum/component/riding_filter/proc/check_offhands(mob/rider)
	if(!offhands_needed_rider)
		return
	if(rider)

	else

		#warn impl above
	var/atom/movable/AM = parent
	var/list/buckled = AM.buckled_mobs.Copy()
	for(var/obj/item/offhand/riding/R as anything in our_offhands)
		buckled -= R.worn_mob()
	for(var/mob/rider in buckled)
		rider.visible_message(
			SPAN_WARNING("[rider] falls off [AM]."),
			SPAN_WARNING("You slide off [AM].")
		)
		AM.unbuckle_mob(rider, BUCKLE_OP_FORCE)

/datum/component/riding_filter/proc/offhand_destroyed(obj/item/offhand/riding/offhand)
	our_offhands -= offhand
	check_offhands(rider)

/datum/component/riding_filter/proc/try_equip_offhand_to_rider(mob/rider)
	var/obj/item/offhand/riding/R = new(rider)
	if(rider.put_in_hands(R))
		R.filter = src
		return TRUE
	qdel(R)
	return FALSE

/obj/item/offhand/riding
	name = "riding offhand"
	desc = "Your hand is full carrying someone on you!"
	/// riding handler component
	var/datum/component/riding_filter/mob/filter

/obj/item/offhand/riding/Destroy()
	filter?.offhand_destroyed(src)
	return ..()
