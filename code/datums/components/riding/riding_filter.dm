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
	/// del ourselves after riding component is made. obviously, the riding component shouldn't also have auto deletion on unbuckle.
	var/ephemeral = FALSE

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
	if(implements_can_buckle_hints)
		RegisterSignal(parent, COMSIG_MOVABLE_CAN_BUCKLE_MOB, .proc/signal_hook_can_buckle)

/datum/component/riding_filter/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, list(
		COMSIG_MOVABLE_PRE_MOB_BUCKLED,
		COMSIG_MOVABLE_MOB_BUCKLED,
		COMSIG_MOVABLE_CAN_BUCKLE_MOB
	))

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
	if(ephemerals)
		qdel(src)

/**
 * if implemented (set `implements_can_buckle_hints` to TRUE), allows us to hint early
 * that something can't buckle, rather than interrupting last moment during pre_buckle.
 *
 * it is good practice, but not required, to do this.
 */
/datum/component/riding_filter/proc/signal_hook_can_buckle(atom/movable/source, mob/M, flags, mob/user)
	SIGNAL_HANDLER
	return check_mount_attempt(M, flags, user)? COMPONENT_FORCE_BUCKLE_OPERATION : COMPONENT_BLOCK_BUCKLE_OPERATION

/datum/component/riding_filter/proc/on_mount_attempt(mob/M, buckle_flags, mob/user)
	if(!check_mount_attempt(M, buckle_flags, user))
		return FALSE
	. = TRUE
	var/datum/component/riding_handler/handler = create_riding_handler(M, buckle_flags, user)
	pre_buckle_handler_tweak(handler, M, buckle_flags, user)

/datum/component/riding_filter/proc/check_mount_attempt(mob/M, buckle_flags, mob/user)
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
