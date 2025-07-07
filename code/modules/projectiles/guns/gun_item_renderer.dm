
//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * gun render system
 *
 * todo: better documentation
 */
/datum/gun_item_renderer

/**
 * Writes necessary states to gun.
 */
/datum/gun_item_renderer/proc/render(obj/item/gun/gun, ammo_ratio, firemode_key, firemode_color)
	CRASH("attempted to render with abstract gun renderer")

/**
 * our de-duping key
 */
/datum/gun_item_renderer/proc/dedupe_key()
	CRASH("dedupe was not implemented on this renderer")

/**
 * uses a copy of a segment to render inventory/world
 *
 * if use_firemode is set, the firemode append will be appended before our default appends.
 * if independent_firemode is set, the firemode overlay will be overlaid independently from segments
 *
 * segment state is "[gun.base_icon_state]-ammo"
 * empty state is "[gun.base_icon_state]-empty"
 *
 * * you probably don't need both use_firemode and use_firemode.
 * * firemode is not taken into account for empty state.
 */
/datum/gun_item_renderer/segments
	/// total count of segments, from 1 to amount
	var/count = 0
	/// initial pixel x offset
	var/initial_x = 0
	/// initial pixel y offset
	var/initial_y = 0
	/// pixel x offset to apply on every consequetive segment
	var/offset_x = 0
	/// pixel y offset to apply on every consequetive segment
	var/offset_y = 0
	/// render -empty while empty
	var/use_empty = FALSE
	/// additionally, add "-[firemode]" to the segment
	var/use_firemode
	/// use gun requested render color on ammo bar
	var/use_color
	/// additionally, add an "-firemode" overlay that's colored by the firemode's render color
	var/independent_colored_firemode
	/// additionally, add an "-[firemode]" overlay for our firemode's render_key
	/// * overrides [independent_colored_firemode]
	var/independent_firemode

/datum/gun_item_renderer/segments/render(obj/item/gun/gun, base_icon_state, ammo_ratio, firemode_key, firemode_color)
	if(gun.render_skip)
		gun.icon_state = base_icon_state
		return
	var/list/to_add = list()
	if(independent_firemode)
		if(firemode_key)
			to_add += "[base_icon_state]-[firemode_key]"
	else if(independent_colored_firemode)
		var/image/colored_firemode_overlay = new /image
		colored_firemode_overlay.icon_state = "[base_icon_state]-firemode"
		colored_firemode_overlay.color = firemode_color
		to_add += colored_firemode_overlay
	if(!ammo_ratio)
		if(use_empty)
			to_add += "[base_icon_state]-empty"
	else
		var/x = initial_x
		var/y = initial_y
		var/ammo_state = "[base_icon_state][use_firemode ? (firemode_key ? firemode_key : "") : ""]-ammo"
		for(var/i in 1 to min(count, ceil(count * ammo_ratio)))
			var/image/segment = new /image
			segment.icon_state = ammo_state
			segment.pixel_x = x
			segment.pixel_y = y
			x += offset_x
			y += offset_y
			if(use_color)
				segment.color = firemode_color
			to_add += segment
	gun.add_overlay(to_add)

/datum/gun_item_renderer/segments/dedupe_key()
	return "segments-[use_firemode]-[count]-[initial_x]-[initial_y]-[offset_x]-[offset_y]-[use_empty]-[independent_firemode ? 1 : (independent_colored_firemode ? 2 : 0)]-[use_color]"

/**
 * uses either 1 to n or only the nth overlay to render inventory/world
 *
 * if use_firemode is set, the firemode append will be appended before our default appends.
 * if independent_firemode is set, the firemode overlay will be overlaid independently from segments
 *
 * overlay state is "[gun.base_icon_state]-[n]"
 * empty state append is -empty
 *
 * if use_single_overlay is set, we only render the -n'th state,
 * otherwise we render -1 to -n, or -empty if empty (and use empty state is on)
 *
 * * firemode is not taken into account for empty state.
 * * "[base]-[firemode]-[count]"
 */
/datum/gun_item_renderer/overlays
	/// total count of overlays, from 1 to amount
	/// * example: "[base]-[count]"
	var/count
	/// add "-empty" overlay when we're empty, instead of adding nothing
	var/use_empty
	/// only use the n-th overlay, instead of adding 1 to n
	var/use_single
	/// additionally, add "-[firemode]" to the overlay, before the count
	/// * example: "[base]-[firemode]-[count]"
	var/use_firemode
	/// use gun requested render color on ammo bar
	var/use_color
	/// additionally, add an "-firemode" that's colored by the firemode's render color
	var/independent_colored_firemode
	/// additionally, add an "-[firemode]" state for our firemode's render_key
	/// * overrides [independent_colored_firemode]
	var/independent_firemode

/datum/gun_item_renderer/overlays/render(obj/item/gun/gun, base_icon_state, ammo_ratio, firemode_key, firemode_color)
	gun.icon_state = base_icon_state
	if(gun.render_skip)
		return
	var/list/to_add = list()
	if(independent_firemode)
		if(firemode_key)
			to_add += "[base_icon_state]-[firemode_key]"
	else if(independent_colored_firemode)
		var/image/colored_firemode_overlay = new /image
		colored_firemode_overlay.icon_state = "[base_icon_state]-firemode"
		colored_firemode_overlay.color = firemode_color
		to_add += colored_firemode_overlay
	if(!ammo_ratio)
		if(use_empty)
			to_add += "[base_icon_state]-empty"
	else
		if(use_single)
			var/single_state = "[base_icon_state][use_firemode ? (firemode_key ? firemode_key : "") : ""]-[ceil(count * ammo_ratio)]"
			if(use_color)
				var/image/colored_single_overlay = new /image
				colored_single_overlay.icon_state = single_state
				colored_single_overlay.color = firemode_color
				to_add += colored_single_overlay
			else
				to_add += single_state
		else
			var/base_ammo_prepend = "[base_icon_state][use_firemode ? (firemode_key ? firemode_key : "") : ""]-"
			if(use_color)
				for(var/i in 1 to min(count, ceil(count * ammo_ratio)))
					var/image/colored_ammo_overlay = new /image
					colored_ammo_overlay.icon_state = "[base_ammo_prepend][i]"
					if(use_color)
						colored_ammo_overlay.color = firemode_color
					to_add += colored_ammo_overlay
			else
				for(var/i in 1 to min(count, ceil(count * ammo_ratio)))
					to_add += "[base_ammo_prepend][i]"
	gun.add_overlay(to_add)

/datum/gun_item_renderer/overlays/dedupe_key()
	return "overlays-[use_firemode]-[count]-[use_empty]-[use_single]-[independent_firemode ? 1 : (independent_colored_firemode ? 2 : 0)]-[use_color]"

/**
 * uses icon states to render inventory/world
 *
 * if use_firemode is set, the firemode append will be appended before our default appends.
 *
 * gun's icon state is changed to "[gun.base_icon_state][use_firemode && "[firemode]-"]-[n]"
 * empty state append is -empty
 */
/datum/gun_item_renderer/states
	/// additionally, add an "-[firemode]" state for our firemode's render_key
	var/use_firemode
	var/use_empty
	var/use_firemode_empty
	var/count

/datum/gun_item_renderer/states/render(obj/item/gun/gun, base_icon_state, ammo_ratio, firemode_key, firemode_color)
	gun.icon_state = base_icon_state
	if(gun.render_skip)
		return
	if(!ammo_ratio)
		if(use_empty)
			gun.icon_state = "[base_icon_state][firemode_key && use_firemode_empty ? "-[firemode_key]" : ""]-empty"
		else
			gun.icon_state = base_icon_state
		return
	gun.icon_state = "[base_icon_state][use_firemode && firemode_key && "-[firemode_key]"]-[ceil(count * ammo_ratio)]"

/datum/gun_item_renderer/states/dedupe_key()
	return "states-[use_firemode]-[count]-[use_empty]-[use_firemode_empty]"

/**
 * standard "full or empty" renderer
 */
/datum/gun_item_renderer/states/all_or_nothing
	count = 1

/**
 * just swaps icon state to "-empty"
 *
 * * can optionally append a firemode key
 */
/datum/gun_item_renderer/empty_state
	/// additionally, add an "-[firemode]" state for our firemode's render_key
	var/use_firemode

/datum/gun_item_renderer/empty_state/render(obj/item/gun/gun, base_icon_state, ammo_ratio, firemode_key, firemode_color)
	if(gun.render_skip)
		gun.icon_state = base_icon_state
		return
	gun.icon_state = "[base_icon_state][firemode_key && use_firemode ? "-[firemode_key]" : ""][ammo_ratio ? "" : "-empty"]"

/datum/gun_item_renderer/empty_state/dedupe_key()
	return "empty_state-[use_firemode]"

/**
 * just swaps icon state to base_icon_state
 *
 * * can optionally append a firemode key
 */
/datum/gun_item_renderer/nothing
	/// additionally, add an "-[firemode]" state for our firemode's render_key
	var/use_firemode

/datum/gun_item_renderer/nothing/render(obj/item/gun/gun, base_icon_state, ammo_ratio, firemode_key, firemode_color)
	if(gun.render_skip)
		gun.icon_state = base_icon_state
		return
	gun.icon_state = "[base_icon_state][firemode_key && use_firemode ? "-[firemode_key]" : ""]"

/datum/gun_item_renderer/nothing/dedupe_key()
	return "nothing-[use_firemode]"
