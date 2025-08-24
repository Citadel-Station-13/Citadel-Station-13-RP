//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Master click handling entrypoint file for both actual clicks and
 * remote control (direct click interaction chain invocation) clicks.
 *
 * A 'natural' clickchain is approximately as follows;
 * * Click/DblClick/MouseWheel/... (native procs) called on the client. Security handling and misc hooks happen here.
 * * Click/DblClick/MouseWheel/... (native procs) called on the clicked atom. Overrides are allowed but discouraged here.
 * * click_on/double_click_on/... called on the mob. The majority of sanity checks, bindings, etc, are handled here.
 * * on_x_click called on the atom if it's a special modifier click. Various behaviors are here.
 * --- Above cannot be touched by remote control ---
 * * If not, the click is passsed off to `click_interaction_chain()` for standard handling of what you'd
 *   usually consider 'interacting' with something.
 *
 * How remote control of mobs (will) work is that clicks are sent to click_interaction_chain().
 */

//* Native /atom Procs *//

/atom/Click(location, control, params)
	if(!(atom_flags & ATOM_INITIALIZED))
		to_chat(usr, SPAN_WARNING("[src] ([type]) not yet initialized; please contact a coder with this message."))
		return
	usr.click_on(src, location, control, params)

/atom/DblClick(location, control, params)
	if(!(atom_flags & ATOM_INITIALIZED))
		to_chat(usr, SPAN_WARNING("[src] ([type]) not yet initialized; please contact a coder with this message."))
		return
	usr.double_click_on(src, location, control, params)

/atom/MouseWheel(delta_x, delta_y, location, control, params)
	if(!(atom_flags & ATOM_INITIALIZED))
		return
	usr.mouse_wheel_on(src, delta_x, delta_y, location, control, params)

// TODO: other click procs should be here too

//* Single Click *//

/**
 * Entrypoint of clickchain processing.
 * * This should never be called other than as a **verb** executed by our own client.
 */
/mob/proc/click_on(atom/target, location, control, raw_params)
	SHOULD_NOT_OVERRIDE(TRUE)
	// make sure no one's doing something insane
	if(usr != src)
		CRASH("non-src usr click_on in mob. someone is abusing the proc and likely incorrectly so.")
	// handle legacy; in the future, things like buildmode clicks (pre-throttle) happen here
	if(legacy_click_on(target, location, control, raw_params))
		return TRUE
	// Throttle self outbound clicks to once per tick.
	if(world.time < next_click)
		return FALSE
	next_click = world.time + world.tick_lag

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
 * @return clickchain flags
 */
/mob/proc/click_interaction(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	var/obj/item/active_item = get_active_held_item()
	return click_interaction_chain(clickchain, clickchain_flags, active_item)

/**
 * The proc that actually does something with a held item. Override this to do something else.
 * * Also handles standard unarmed behavior.
 * @return clickchain flags
 */
/mob/proc/click_interaction_chain(datum/event_args/actor/clickchain/clickchain, clickchain_flags, obj/item/active_item)
	face_atom(clickchain.target)

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

/**
 * pretty much just for hooks that happen before standard handling and I'm too lazy to rewrite.
 */
/mob/proc/legacy_click_on(atom/target, location, control, params)
	if(client.buildmode)
		build_click(src, client.buildmode, params, target)
		return TRUE
	return FALSE

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

//* Double Click *//

/**
 * A click entrypoint proc.
 * * This should never be called other than as a **verb** executed by our own client.
 */
/mob/proc/double_click_on(atom/target, location, control, raw_params)
	// make sure no one's doing something insane
	if(usr != src)
		CRASH("non-src usr double_click_on in mob. someone is abusing the proc and likely incorrectly so.")
	// Throttle self outbound clicks to once per tick.
	if(world.time < next_click)
		return FALSE
	next_click = world.time + world.tick_lag
	return FALSE

//* Mouse Wheel *//

/**
 * A click entrypoint proc.
 * * This should never be called other than as a **verb** executed by our own client.
 */
/mob/proc/mouse_wheel_on(atom/target, delta_x, delta_y, location, control, raw_params)
	SHOULD_NOT_OVERRIDE(TRUE)
	// make sure no one's doing something insane
	if(usr != src)
		CRASH("non-src usr mouse_wheel_on in mob. someone is abusing the proc and likely incorrectly so.")
	return FALSE
