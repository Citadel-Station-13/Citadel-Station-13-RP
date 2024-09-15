
//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * gun render system
 *
 * if use_firemode is set, the firemode append will be appended before our default appends.
 *
 * todo: better documentation
 */
/datum/gun_item_renderer
	/// firemode state is taken into account
	var/use_firemode = FALSE

/**
 * Writes necessary states to gun.
 */
/datum/gun_item_renderer/proc/render(obj/item/gun/gun, ammo_ratio, firemode_key)
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
 * * you probably don't need both use_firemode and independent_firemode.
 * * firemode is not taken into account for empty state.
 */
/datum/gun_item_renderer/segments
	var/count = 0
	var/initial_x = 0
	var/initial_y = 0
	var/offset_x = 0
	var/offset_y = 0
	var/use_empty = FALSE
	var/independent_firemode = FALSE

/datum/gun_item_renderer/segments/render(obj/item/gun/gun, ammo_ratio, firemode_key)
	var/base_icon_state = gun.base_icon_state || initial(gun.icon_state)
	if(gun.render_additional_state)
		gun.add_overlay("[base_icon_state]-[gun.render_additional_state]")
	if(gun.render_additional_exclusive)
		return
	if(independent_firemode && firemode_key)
		gun.add_overlay("[base_icon_state]-[firemode_key]")
	if(!ammo_ratio)
		if(use_empty)
			gun.add_overlay("[base_icon_state]-empty")
		return
	var/x = initial_x
	var/y = initial_y
	var/append = "[use_firemode && firemode_key && "-[firemode_key]"]"
	for(var/i in 1 to ceil(count * ammo_ratio))
		var/image/creating = image(gun.icon, "[base_icon_state][append]-ammo", null, null, x, y)
		x += offset_x
		y += offset_y
		gun.add_overlay(creating)

/datum/gun_item_renderer/segments/dedupe_key()
	return "segments-[use_firemode]-[count]-[initial_x]-[initial_y]-[offset_x]-[offset_y]-[use_empty]-[use_firemode]-[independent_firemode]"

/**
 * uses either 1 to n or only the nth overlay to render inventory/world
 *
 * if use_firemode is set, the firemode append will be appended before our default appends.
 * if independent_firemode is set, the firemode overlay will be overlaid independently from overlays
 *
 * overlay state is "[gun.base_icon_state]-[n]"
 * empty state append is -empty
 *
 * if use_single_overlay is set, we only render the -n'th state,
 * otherwise we render -1 to -n, or -empty if empty (and use empty state is on)
 *
 * * firemode is not taken into account for empty state.
 */
/datum/gun_item_renderer/overlays
	var/count
	var/use_empty
	var/use_single
	var/independent_firemode

/datum/gun_item_renderer/overlays/render(obj/item/gun/gun, ammo_ratio, firemode_key)
	var/base_icon_state = gun.base_icon_state || initial(gun.icon_state)
	if(gun.render_additional_state)
		gun.add_overlay("[base_icon_state]-[gun.render_additional_state]")
	if(gun.render_additional_exclusive)
		return
	if(independent_firemode && firemode_key)
		gun.add_overlay("[base_icon_state]-[firemode_key]")
	if(!ammo_ratio)
		if(use_empty)
			gun.add_overlay("[base_icon_state]-empty")
		return
	var/append = "[use_firemode && firemode_key && "-[firemode_key]"]"
	if(use_single)
		gun.add_overlay("[base_icon_state]-[append]-[ceil(count * ammo_ratio)]")
	else
		for(var/i in 1 to ceil(count * ammo_ratio))
			gun.add_overlay("[base_icon_state]-[append]-[i]")

/datum/gun_item_renderer/overlays/dedupe_key()
	return "overlays-[use_firemode]-[count]-[use_empty]-[use_single]-[independent_firemode]"

/**
 * uses icon states to render inventory/world
 *
 * if use_firemode is set, the firemode append will be appended before our default appends.
 *
 * gun's icon state is changed to "[gun.base_icon_state][use_firemode && "[firemode]-"]-[n]"
 * empty state append is -empty
 */
/datum/gun_item_renderer/states
	var/use_empty
	var/use_firemode_empty
	var/count

/datum/gun_item_renderer/states/render(obj/item/gun/gun, ammo_ratio, firemode_key)
	var/base_icon_state = gun.base_icon_state || initial(gun.icon_state)
	if(gun.render_additional_exclusive)
		gun.icon_state = "[base_icon_state][gun.render_additional_state ? "-[gun.render_additional_state]" : ""]"
		return
	if(!ammo_ratio)
		if(use_empty)
			gun.icon_state = "[base_icon_state][firemode_key && use_firemode_empty && "-[firemode_key]"]-empty"
		else
			gun.icon_state = base_icon_state
		return
	gun.icon_state = "[base_icon_state][gun.render_additional_state ? "-[gun.render_additional_state]" : ""]-[use_firemode && firemode_key && "-[firemode_key]"]-[ceil(count * ammo_ratio)]"

/datum/gun_item_renderer/states/dedupe_key()
	return "states-[use_firemode]-[count]-[use_empty]-[use_firemode_empty]"

/**
 * standard "full or empty" renderer
 */
/datum/gun_item_renderer/states/all_or_nothing
	count = 1
