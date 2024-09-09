
//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * gun render system
 *
 * if use_firemode is set, the firemode append will be appended before our default appends.
 *
 * todo: better documentation
 */
/datum/gun_mob_renderer
	/// firemode state is taken into account
	var/use_firemode = FALSE
	/// render to worn_state, not just inhand_state
	var/render_slots = FALSE

/**
 * Writes necessary states to gun.
 *
 * @return TRUE if gun needs to change inventory state.
 */
/datum/gun_mob_renderer/proc/render(obj/item/gun/gun, ammo_ratio, firemode_key)
	CRASH("attempted to render with abstract gun renderer")

/**
 * our de-duping key
 */
/datum/gun_mob_renderer/proc/dedupe_key()
	CRASH("dedupe was not implemented on this renderer")

/**
 * renders via inhand_state or worn_state if [render_slots] is on
 *
 * when not empty, adds -[n] for the state
 * when empty, adds -empty for the state, but only if empty_state is on.
 */
/datum/gun_mob_renderer/states
	/// how many states there are
	var/count = 0
	/// add "-empty" when empty; otherwise, we don't add anything at all
	var/empty_state = FALSE

/datum/gun_mob_renderer/states/render(obj/item/gun/gun, ammo_ratio, firemode_key)
	// todo: do we really need to always return TRUE and force an update?
	var/base_icon_state = gun.render_mob_base || gun.base_icon_state || initial(gun.icon_state)
	if(!ammo_ratio)
		if(empty_state)
			gun.inhand_state = "[base_icon_state][firemode_key && use_firemode && "-[firemode_key]"]-empty"
		else
			gun.inhand_state = base_icon_state
		if(render_slots)
			gun.worn_state = gun.inhand_state
		return
	gun.inhand_state = "[base_icon_state][use_firemode && firemode_key && "-[firemode_key]"]-[ceil(count * ammo_ratio)]"
	if(render_slots)
		gun.worn_state = gun.inhand_state
	return TRUE

/datum/gun_mob_renderer/states/dedupe_key()
	return "states-[use_firemode]-[count]-[empty_state]"
