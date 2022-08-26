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
 */
/datum/component/riding_filter
	/// expected typepath of what we're to be filtering for
	var/expected_typepath
	/// the path of the riding handler component we're going to make
	var/handler_typepath = /datum/component/riding_handler

/datum/component/riding_filter/Initialize()

/datum/component/riding_filter/RegisterWithParent()
	. = ..()


/datum/component/riding_filter/UnregisterFromParent()
	. = ..()

#warn impl

/datum/component/riding_filter/proc/signal_hook_pre_buckle(datum/source, mob/M, flags, mob/user)
	SIGNAL_HANDLER

/datum/component/riding_filter/proc/signal_hook_post_buckle(datum/source, mob/M, flags, mob/user)
	SIGNAL_HANDLER

/datum/component/riding_filter/proc/on_mount_attempt(mob/M, buckle_flags, mob/user)

/datum/component/riding_filter/proc/check_mount_attempt(mob/M, buckle_flags, mob/user)


/datum/component/riding_filter/proc/create_riding_handler(mob/M, buckle_flags, mob/user, ...)

/datum/component/riding_filter/proc/pre_buckle_handler_tweak(datum/component/riding_handler/handler, mob/M, flags, mob/user, ...)

/datum/component/riding_filter/proc/post_buckle_handler_tweak(datum/component/riding_handler/handler, mob/M, flags, mob/user, ...)

#warn COMSIG_
