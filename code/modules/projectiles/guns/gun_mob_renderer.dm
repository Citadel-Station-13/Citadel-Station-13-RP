//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

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

/datum/gun_mob_renderer/New(use_firemode, render_slots)
	if(!isnull(use_firemode))
		src.use_firemode = use_firemode
	if(!isnull(render_slots))
		src.render_slots = render_slots

/datum/gun_mob_renderer/proc/render(obj/item/gun/gun)
	CRASH("attempted to render with abstract gun renderer")

/**
 * uses a copy of a segment to render inventory/world
 *
 * if use_firemode is set, the firemode append will be appended before our default appends.
 * if independent_firemode is set, the firemode overlay will be overlaid independently from segments
 *
 * segment state is "[gun.base_icon_state]-ammo"
 * empty state is "[gun.base_icon_state]-empty"
 */
/datum/gun_mob_renderer/states
	/// how many states there are
	var/count = 0
	/// use this state when empty; either "-0", "-empty", or another user-defined one
	///
	/// * otherwise, we don't use any state.
	var/empty_state

/datum/gun_mob_renderer/segments/New(count, empty_state, use_firemode, render_slots)
	..(use_firemode, render_slots)
	if(!isnull(count))
		src.count = count
	if(!isnull(empty_state))
		src.empty_state = empty_state

/datum/gun_mob_renderer/segments/render(obj/item/gun/gun)
	#warn impl
