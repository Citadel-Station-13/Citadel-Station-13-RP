//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/atom/Click(location, control, params)
	if(!(atom_flags & ATOM_INITIALIZED))
		to_chat(usr, SPAN_WARNING("[src] ([type]) not yet initialized; please contact a coder with this message."))
		return
	usr.click_on(src, location, control, params)

// TODO: other click procs

/**
 * Entrypoint of clickchain processing.
 * * This should never be called other than as a **verb** executed by our own client.
 */
/mob/proc/click_on(atom/target, location, control, raw_params)
	SHOULD_NOT_OVERRIDE(TRUE)
	// make sure no one's doing something insane
	if(usr != src)
		CRASH("non-src usr click_on in mob. someone is abusing the proc and likely incorrectly so.")
	// Throttle self outbound clicks to once per tick.
	if(world.time < next_click)
		return FALSE
	next_click = world.time + world.tick_lag

	if(legacy_click_on(target, location, control, raw_params))
		return TRUE

	var/list/params = params2list(raw_params)

	/**
	 * If you've noticed we are missing a few of the usual modifiers, that's correct.
	 * /mob level only defines the 'standard' keys that are considered to be so
	 * ubiquitous across ss13 that we are choosing not to change them.
	 *
	 * Special behaviors like ctrl shift middle click whatnots should go to subtypes of mobs.
	 *
	 * In the future, we'll need a dynamic rebind system for click behaviors.
	 *
	 * For laptop compatibility, middle click is not considered a standard bind. While we can
	 * and will use it, please opt to not make it too standardized.
	 */

	/**
	 * Furthermore, note that 'button' is the mouse button being pressed or released.
	 * 'left' 'right' 'middle' being set in params just means it's still being held.
	 * This means that detecting specific clicks is actually somewhat complicated.
	 * It'll be a project for another time to determine what is the ultimately 'correct' behavior
	 * for this.
	 * Generally, we consider the button being pressed/depressed as the active cilck button.
	 */
	if(click_on_special(target, location, control, params))
		return TRUE
	if(params["shift"])
		if(params["button"] == "middle")
			if(shift_middle_click_on(target, location, control, params))
				return TRUE
		if(params["ctrl"])
			if(ctrl_shift_click_on(target, location, control, params))
				return TRUE
		if(shift_click_on(target, location, control, params))
			return TRUE
	else if(params["button"] == "middle")
		if(middle_click_on(target, location, control, params))
			return TRUE
	else if(params["alt"])
		if(alt_click_on(target, location, control, params))
			return TRUE
	else if(params["ctrl"])
		if(ctrl_click_on(target, location, control, params))
			return TRUE


#warn impl

/**
 * Standard world-click interaction chain.
 * * Routes as needed to item/melee/tool interaction chains.
 * * This can be called by remote control handling directly.
 */
/mob/proc/click_interaction_chain(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	face_atom(clickchain.target)

	var/obj/item/active_item = get_active_held_item()
	if(active_item == clickchain.target)
		active_item.attack_self(src, clickchain)
		//! legacy
		trigger_aiming(TARGET_CAN_CLICK)
		//! end
		return clickchain_flags | CLICKCHAIN_DID_SOMETHING

	// check if we can click 'out' from our current location
	// TODO: refactor this, maybe?
	var/ranged_generics_allowed = loc?.AllowClick(src, clickchain.target, active_item)

	// check if we should route to melee or ranged interaction chains
	if(Reachability(clickchain.target, null, active_item?.reach, active_item))
		if(active_item)
			. = active_item.melee_interaction_chain(clickchain, clickchain_flags)
		else
			. = melee_interaction_chain(clickchain, clickchain_flags)
		//! legacy
		trigger_aiming(TARGET_CAN_CLICK)
		//! end
		return
	else if(ranged_generics_allowed)
		if(active_item)
			. = active_item.ranged_interaction_chain(clickchain, clickchain_flags)
		else
			. = ranged_interaction_chain(clickchain, clickchain_flags)
		//! legacy
		trigger_aiming(TARGET_CAN_CLICK)
		//! end
		return


//* Special modifiers; these are often routed per-mob. *//

/**
 * @return TRUE to break regular click handling logic.
 */
/mob/proc/click_on_special(atom/target, location, control, list/params)
	return FALSE

/**
 * * Standard binding; usually used for soft context menu.
 * @return TRUE to break regular click handling logic.
 */
/mob/proc/ctrl_shift_click_on(atom/target, location, control, list/params)
	return FALSE

/**
 * * Nonstandard binding.
 * * Usually 'point-at'.
 * @return TRUE to break regular click handling logic.
 */
/mob/proc/shift_middle_click_on(atom/target, location, control, list/params)
	return FALSE

/**
 * * Nonstandard binding.
 * * Usually rigsuit activation.
 * @return TRUE to break regular click handling logic.
 */
/mob/proc/middle_click_on(atom/target, location, control, list/params)
	return FALSE

/**
 * * Standard binding; usually 'examine'.
 * @return TRUE to break regular click handling logic.
 */
/mob/proc/shift_click_on(atom/target, location, control, list/params)
	return FALSE

/**
 * * Standard binding; usually 'pull'.
 * @return TRUE to break regular click handling logic.
 */
/mob/proc/ctrl_click_on(atom/target, location, control, list/params)
	return FALSE

/**
 * * Standard binding; usually 'list turf'.
 * @return TRUE to break regular click handling logic.
 */
/mob/proc/alt_click_on(atom/target, location, control, list/params)
	return FALSE
