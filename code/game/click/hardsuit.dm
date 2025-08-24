//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * This should **not** be called by remote control. This is a direct route from click handling.
 * Remote control of hardsuits should route to the hardsuit's clickchain receiver directly.
 */
/mob/proc/attempt_hardsuit_click(datum/event_args/actor/clickchain/clickchain, clickchain_flags)

#warn push these to files
/mob/living/middle_click_on(atom/target, location, control, list/params)
	if(client?.hardsuit_click_mode == MIDDLE_CLICK)
		if(HardsuitClickOn(A))
			return TRUE
	return ..()

/mob/living/alt_click_on(atom/target, location, control, list/params)
	if(client?.hardsuit_click_mode == ALT_CLICK)
		if(HardsuitClickOn(A))
			return TRUE
	return ..()

/mob/living/ctrl_click_on(atom/target, location, control, list/params)
	if(client?.hardsuit_click_mode == CTRL_CLICK)
		if(HardsuitClickOn(A))
			return TRUE
	return ..()
