//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/mob
	//* Actionspeed *//
	/// List of action speed modifiers applying to this mob
	/// * Lazy list, see mob_movespeed.dm
	var/list/actionspeed_modifiers
	/// List of action speed modifiers ignored by this mob. List -> List (id) -> List (sources)
	/// * Lazy list, see mob_movespeed.dm
	var/list/actionspeed_modifier_immunities

	//* HUD (Atom) *//
	/// HUDs to initialize, typepaths
	var/list/atom_huds_to_initialize

	//* Buckling *//
	/// Atom we're buckled to
	var/atom/movable/buckled
	/// Atom we're buckl**ing** to. Used to stop stuff like lava from incinerating those who are mid buckle.
	//  todo: can this be put in an existing bitfield somewhere else?
	var/atom/movable/buckling

	//* Emotes *//
	/// running emotes, associated to context the emote can set
	var/list/datum/emote/emotes_running
	/// our default emote classes
	var/emote_class = EMOTE_CLASS_IS_BODY

	//* Impairments *//
	/// active feign_impairment types
	/// * lazy list
	var/list/impairments_feigned

	//* Movespeed *//
	/// List of movement speed modifiers applying to this mob
	/// * This is a lazy list.
	var/list/movespeed_modifiers
	/// List of movement speed modifiers ignored by this mob. List -> List (id) -> List (sources)
	/// * This is a lazy list.
	var/list/movespeed_modifier_immunities
	/// The calculated mob speed slowdown based on the modifiers list
	var/movespeed_hyperbolic

	//* Status Indicators *//
	/// datum path = list of sources
	var/list/status_indicators
	var/list/status_indicator_overlays

/mob/Initialize(mapload)
	// mob lists
	mob_list_register(stat)
	// actions
	actions_controlled = new /datum/action_holder/mob_actor(src)
	actions_innate = new /datum/action_holder/mob_actor(src)
	// physiology
	init_physiology()
	// atom HUDs
	prepare_huds()
	set_key_focus(src)
	// signal
	SEND_GLOBAL_SIGNAL(COMSIG_GLOBAL_MOB_NEW, src)
	// abilities
	init_abilities()
	// inventory
	init_inventory()
	// rendering
	init_rendering()
	// resize
	update_transform()
	// offset
	reset_pixel_offsets()
	// update gravity
	update_gravity()
	// movespeed
	update_movespeed_base()
	// actionspeed
	initialize_actionspeed()
	// ssd overlay
	update_ssd_overlay()
	// iff factions
	init_iff()
	return ..()

/mob/Destroy()
	// status effects
	for(var/id in status_effects)
		var/datum/status_effect/effect = status_effects[id]
		qdel(effect)
	status_effects = null
	// mob lists
	mob_list_unregister(stat)
	// signal
	SEND_GLOBAL_SIGNAL(COMSIG_GLOBAL_MOB_DEL, src)
	// abilities
	dispose_abilities()
	// actions
	QDEL_NULL(actions_controlled)
	QDEL_NULL(actions_innate)
	// this kicks out client
	ghostize()
	// run legacy actions
	LegacyDestroy()
	// get rid of our shit and nullspace everything first..
	..()
	// rendering
	if(hud_used)
		QDEL_NULL(hud_used)
	dispose_rendering()
	// perspective; it might be gone now because self perspective is destroyed in ..()
	using_perspective?.remove_mob(src, TRUE)
	// physiology
	QDEL_NULL(physiology)
	physiology_modifiers = null
	// movespeed
	movespeed_modifiers = null
	// actionspeed
	actionspeed_modifiers = null
	return QDEL_HINT_HARDDEL

//* Mob List Registration *//

/mob/proc/mob_list_register(for_stat)
	GLOB.mob_list += src
	if(for_stat == DEAD)
		dead_mob_list += src
	else
		living_mob_list += src

/mob/proc/mob_list_unregister(for_stat)
	GLOB.mob_list -= src
	if(for_stat == DEAD)
		dead_mob_list -= src
	else
		living_mob_list -= src

/mob/proc/mob_list_update_stat(old_stat, new_stat)
	mob_list_unregister(old_stat)
	mob_list_register(new_stat)

// TODO: /verbs folder these

/mob/verb/set_self_relative_layer()
	set name = "Set relative layer"
	set desc = "Set your relative layer to other mobs on the same layer as yourself"
	set src = usr
	set category = VERB_CATEGORY_IC

	var/new_layer = input(src, "What do you want to shift your layer to? (-100 to 100)", "Set Relative Layer", clamp(relative_layer, -100, 100))
	new_layer = clamp(new_layer, -100, 100)
	set_relative_layer(new_layer)

/mob/verb/shift_relative_behind()
	set name = "Move Behind"
	set desc = "Move behind of a mob with the same base layer as yourself"
	set src = usr
	set category = VERB_CATEGORY_IC

	if(!client.throttle_verb())
		return

	var/mob/M = tgui_input_list(src, "What mob to move behind?", "Move Behind", get_relative_shift_targets())

	if(QDELETED(M))
		return

	set_relative_layer(M.relative_layer - 1)

/mob/verb/shift_relative_infront()
	set name = "Move Infront"
	set desc = "Move infront of a mob with the same base layer as yourself"
	set src = usr
	set category = VERB_CATEGORY_IC

	if(!client.throttle_verb())
		return

	var/mob/M = tgui_input_list(src, "What mob to move infront?", "Move Infront", get_relative_shift_targets())

	if(QDELETED(M))
		return

	set_relative_layer(M.relative_layer + 1)

/mob/proc/get_relative_shift_targets()
	. = list()
	var/us = isnull(base_layer)? layer : base_layer
	for(var/mob/M in range(1, src))
		if(M.plane != plane)
			continue
		if(us == (isnull(M.base_layer)? M.layer : M.base_layer))
			. += M
	. -= src

//* Abilities *//

/mob/proc/init_abilities()
	var/list/built = list()
	var/list/registering = list()
	for(var/datum/ability/ability_path as anything in abilities)
		if(istype(ability_path))
			built += ability_path // don't re-associate existing ones.
		else if(ispath(ability_path, /datum/ability))
			registering += new ability_path
	abilities = built
	for(var/datum/ability/ability as anything in registering)
		ability.associate(src)

/mob/proc/dispose_abilities()
	for(var/datum/ability/ability in abilities)
		ability.disassociate(src)
	abilities = null

/**
 * mob side registration of abilities. must be called from /datum/ability/proc/associate!
 */
/mob/proc/register_ability(datum/ability/ability)
	LAZYINITLIST(abilities)
	abilities += ability

/**
 * mob side unregistration of abilities. must be called from /datum/ability/proc/disassociate!
 */
/mob/proc/unregister_ability(datum/ability/ability)
	LAZYREMOVE(abilities, ability)

//* Atom HUDs *//

/**
 * Initializes all atom HUDs for us
 * todo: this should be atom level but uhh lmao lol don't call it on atom/Initialize() either
 */
/mob/proc/prepare_huds()
	if(!atom_huds_to_initialize)
		return
	for(var/hud in atom_huds_to_initialize)
		update_atom_hud_provider(src, hud)
	atom_huds_to_initialize = null

//* Radioactivity *//

/mob/clean_radiation(str, mul, cheap)
	. = ..()
	if(cheap)
		return
	for(var/obj/item/I as anything in get_equipped_items(TRUE, TRUE))
		I.clean_radiation(str, mul, cheap)

//* Reachability *//

/mob/CanReachOut(atom/movable/mover, atom/target, obj/item/tool, list/cache)
	return FALSE

/mob/CanReachIn(atom/movable/mover, atom/target, obj/item/tool, list/cache)
	return FALSE

//* Pixel Offsets *//

/mob/proc/get_buckled_pixel_x_offset()
	if(!buckled)
		return 0
	// todo: this doesn't properly take into account all transforms of both us and the buckled object
	. = get_centering_pixel_x_offset(dir)
	if(lying != 0)
		. *= cos(lying)
		. += sin(lying) * get_centering_pixel_y_offset(dir)
	return buckled.pixel_x + . - buckled.get_centering_pixel_x_offset(buckled.dir) + buckled.get_buckled_x_offset(src)

/mob/proc/get_buckled_pixel_y_offset()
	if(!buckled)
		return 0
	// todo: this doesn't properly take into account all transforms of both us and the buckled object
	. = get_centering_pixel_y_offset(dir)
	if(lying != 0)
		. *= cos(lying)
		. += sin(lying) * get_centering_pixel_x_offset(dir)
	return buckled.pixel_y + . - buckled.get_centering_pixel_y_offset(buckled.dir) + buckled.get_buckled_y_offset(src)

/mob/get_managed_pixel_x()
	return ..() + shift_pixel_x + get_buckled_pixel_x_offset()

/mob/get_managed_pixel_y()
	return ..() + shift_pixel_y + get_buckled_pixel_y_offset()

/mob/get_centering_pixel_x_offset(dir)
	. = ..()
	. += shift_pixel_x

/mob/get_centering_pixel_y_offset(dir)
	. = ..()
	. += shift_pixel_y

/mob/proc/reset_pixel_shifting()
	if(!shifted_pixels)
		return
	shifted_pixels = FALSE
	pixel_x -= shift_pixel_x
	pixel_y -= shift_pixel_y
	wallflowering = NONE
	shift_pixel_x = 0
	shift_pixel_y = 0
	SEND_SIGNAL(src, COMSIG_MOVABLE_PIXEL_OFFSET_CHANGED)

/mob/proc/set_pixel_shift_x(val)
	if(!val)
		return
	shifted_pixels = TRUE
	pixel_x += (val - shift_pixel_x)
	shift_pixel_x = val
	switch(val)
		if(-INFINITY to -WALLFLOWERING_PIXEL_SHIFT)
			wallflowering = (wallflowering & ~(EAST)) | WEST
		if(-WALLFLOWERING_PIXEL_SHIFT + 1 to WALLFLOWERING_PIXEL_SHIFT - 1)
			wallflowering &= ~(EAST|WEST)
		if(WALLFLOWERING_PIXEL_SHIFT to INFINITY)
			wallflowering = (wallflowering & ~(WEST)) | EAST
	SEND_SIGNAL(src, COMSIG_MOVABLE_PIXEL_OFFSET_CHANGED)

/mob/proc/set_pixel_shift_y(val)
	if(!val)
		return
	shifted_pixels = TRUE
	pixel_y += (val - shift_pixel_y)
	shift_pixel_y = val
	switch(val)
		if(-INFINITY to -WALLFLOWERING_PIXEL_SHIFT)
			wallflowering = (wallflowering & ~(NORTH)) | SOUTH
		if(-WALLFLOWERING_PIXEL_SHIFT + 1 to WALLFLOWERING_PIXEL_SHIFT - 1)
			wallflowering &= ~(NORTH|SOUTH)
		if(WALLFLOWERING_PIXEL_SHIFT to INFINITY)
			wallflowering = (wallflowering & ~(SOUTH)) | NORTH
	SEND_SIGNAL(src, COMSIG_MOVABLE_PIXEL_OFFSET_CHANGED)

/mob/proc/adjust_pixel_shift_x(val)
	if(!val)
		return
	shifted_pixels = TRUE
	shift_pixel_x += val
	pixel_x += val
	switch(shift_pixel_x)
		if(-INFINITY to -WALLFLOWERING_PIXEL_SHIFT)
			wallflowering = (wallflowering & ~(EAST)) | WEST
		if(-WALLFLOWERING_PIXEL_SHIFT + 1 to WALLFLOWERING_PIXEL_SHIFT - 1)
			wallflowering &= ~(EAST|WEST)
		if(WALLFLOWERING_PIXEL_SHIFT to INFINITY)
			wallflowering = (wallflowering & ~(WEST)) | EAST
	SEND_SIGNAL(src, COMSIG_MOVABLE_PIXEL_OFFSET_CHANGED)

/mob/proc/adjust_pixel_shift_y(val)
	if(!val)
		return
	shifted_pixels = TRUE
	shift_pixel_y += val
	pixel_y += val
	switch(shift_pixel_y)
		if(-INFINITY to -WALLFLOWERING_PIXEL_SHIFT)
			wallflowering = (wallflowering & ~(NORTH)) | SOUTH
		if(-WALLFLOWERING_PIXEL_SHIFT + 1 to WALLFLOWERING_PIXEL_SHIFT - 1)
			wallflowering &= ~(NORTH|SOUTH)
		if(WALLFLOWERING_PIXEL_SHIFT to INFINITY)
			wallflowering = (wallflowering & ~(SOUTH)) | NORTH
	SEND_SIGNAL(src, COMSIG_MOVABLE_PIXEL_OFFSET_CHANGED)
