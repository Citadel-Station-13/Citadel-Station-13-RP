
//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * gun render system
 *
 * todo: better documentation
 */
/datum/gun_mob_renderer
	/// render to worn_state, not just inhand_state
	var/render_slots = FALSE

/**
 * Writes necessary states to gun.
 *
 * @return TRUE if gun needs to update mob state.
 */
/datum/gun_mob_renderer/proc/render(obj/item/gun/gun, base_worn_state, ammo_ratio, firemode_key, firemode_color)
	CRASH("attempted to render with abstract gun renderer")

/**
 * Returns states to write to an on-mob overlay.
 *
 * * States will automatically be appended with something like '_left', '_right', '_all', etc, by the gun.
 */
/datum/gun_mob_renderer/proc/render_overlays(obj/item/gun/gun, base_worn_state, ammo_ratio, firemode_key, firemode_color) as /list
	return list()

/**
 * our de-duping key
 */
/datum/gun_mob_renderer/proc/dedupe_key()
	CRASH("dedupe was not implemented on this renderer")

/**
 * renders via inhand_state or worn_state if [render_slots] is on
 *
 * when not empty, adds -[n] for the state
 * when empty, adds -empty for the state, but only if use_empty is on.
 */
/datum/gun_mob_renderer/states
	/// how many states there are
	var/count = 0
	/// add "-empty" when empty; otherwise, we don't add anything at all
	var/use_empty = FALSE
	/// add "-[firemode]" before the "-[n]" is added to the state
	var/use_firemode = FALSE

/datum/gun_mob_renderer/states/render(obj/item/gun/gun, base_worn_state, ammo_ratio, firemode_key, firemode_color)
	// todo: do we really need to always return TRUE and force an update?
	if(!ammo_ratio)
		if(use_empty)
			gun.inhand_state = "[base_worn_state][firemode_key && use_firemode && "-[firemode_key]"]-empty"
		else
			gun.inhand_state = base_worn_state
		if(render_slots)
			gun.worn_state = gun.inhand_state
		return
	gun.inhand_state = "[base_worn_state][use_firemode && firemode_key && "-[firemode_key]"]-[ceil(count * ammo_ratio)]"
	if(render_slots)
		gun.worn_state = gun.inhand_state
	return TRUE

/datum/gun_mob_renderer/states/dedupe_key()
	return "states-[render_slots]-[use_firemode]-[count]-[use_empty]"


/**
 * uses either 1 to n or only the nth overlay to render on-mob
 *
 * if use_firemode is set, the firemode append will be appended before our default appends.
 * if independent_firemode is set, the firemode overlay will be overlaid independently from overlays
 *
 * overlay state is "[gun.base_worn_state]-[n]"
 * empty state append is -empty
 *
 * if `use_single` is set, we only render the -n'th state,
 * otherwise we render -1 to -n, or -empty if empty (and use empty state is on)
 *
 * * firemode is not taken into account for empty state.
 * * "[base]-[firemode]-[count]"
 */
/datum/gun_mob_renderer/overlays
	/// total count of overlays, from 1 to amount
	var/count
	/// add "-empty" overlay when we're empty, instead of adding nothing
	var/use_empty
	/// only use the n-th overlay, instead of adding 1 to n
	var/use_single
	/// add "-[firemode]" before the "-[n]" for the overlays
	var/use_firemode = FALSE
	/// use gun requested render color on ammo bar
	var/use_color
	/// additionally, add an "-firemode" overlay that's colored by the firemode's render color
	var/independent_colored_firemode
	/// additionally, add an "-[firemode]" overlay for our firemode's render_key
	/// * overrides [independent_colored_firemode]
	var/independent_firemode

/datum/gun_mob_renderer/overlays/render(obj/item/gun/gun, base_worn_state, ammo_ratio, firemode_key, firemode_color)
	// todo: do we really need to always return TRUE and force an update?
	gun.inhand_state = base_worn_state
	if(render_slots)
		gun.worn_state = gun.inhand_state
	return TRUE

/datum/gun_mob_renderer/overlays/render_overlays(obj/item/gun/gun, base_worn_state, ammo_ratio, firemode_key, firemode_color)
	. = list()
	if(gun.render_skip)
		return
	if(independent_firemode)
		if(firemode_key)
			. += "[base_worn_state]-[firemode_key]"
	else if(independent_colored_firemode)
		var/image/colored_firemode_overlay = new /image
		colored_firemode_overlay.icon_state = "[base_worn_state]-firemode"
		colored_firemode_overlay.color = firemode_color
		. += colored_firemode_overlay
	if(!ammo_ratio)
		if(use_empty)
			. += "[base_worn_state]-empty"
	else
		if(use_single)
			var/single_state = "[base_worn_state][use_firemode ? (firemode_key ? firemode_key : "") : ""]-[ceil(count * ammo_ratio)]"
			if(use_color)
				var/image/colored_single_overlay = new /image
				colored_single_overlay.icon_state = single_state
				colored_single_overlay.color = firemode_color
				. += colored_single_overlay
			else
				. += single_state
		else
			var/base_ammo_prepend = "[base_worn_state][use_firemode ? (firemode_key ? firemode_key : "") : ""]-"
			if(use_color)
				for(var/i in 1 to min(count, ceil(count * ammo_ratio)))
					var/image/colored_ammo_overlay = new /image
					colored_ammo_overlay.icon_state = "[base_ammo_prepend][i]"
					if(use_color)
						colored_ammo_overlay.color = firemode_color
					. += colored_ammo_overlay
			else
				for(var/i in 1 to min(count, ceil(count * ammo_ratio)))
					. += "[base_ammo_prepend][i]"

/datum/gun_mob_renderer/overlays/dedupe_key()
	return "states-[render_slots]-[independent_firemode ? 1 : (independent_colored_firemode ? 2 : 0)]-[count]-[use_firemode]-[use_empty]-[use_single]-[use_color]"
