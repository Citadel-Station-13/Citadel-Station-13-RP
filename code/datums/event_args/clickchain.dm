//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

// todo: mob.generate_simulated_clickchain(...) to generate a simulated click

/**
 * used to hold data about a click (melee/ranged/other) action
 *
 * * The click may be real or fake.
 * * Clickchain flags are deliberately not stored in here; you're supposed to modify and return them a ton, so it's inefficient to put it in here.
 * * This is required for item swings / interaction, usually, not just base /event_args/actor.
 *   While it's technically called a clickchain, it also stores a lot of other data like targeting.
 * * **This should always be clone()'d if you are invoking, semantically, a new attack from an existing attack.**
 *   Otherwise, modifiers might apply twice and all kinds of fuckery can occur.
 *
 * todo: helpers for true clickchain event generation / simulation
 */
/datum/event_args/actor/clickchain
	//* Using Data *//

	/// (optional) action intent
	var/using_intent
	/// (optional) hand index
	var/using_hand_index

	/// (optional) using weapon
	/// * not for tools; this is only for melee
	var/obj/item/using_melee_weapon
	/// (optional) using melee style
	/// * not for tools; this is only for melee
	var/datum/melee_attack/using_melee_attack

	//* Click Data *//

	/// optional: click params
	var/list/click_params
	/// did we unpack click params?
	var/tmp/click_params_unpacked = FALSE
	/// pixel x on tile clicked
	var/tmp/click_params_tile_px
	/// pixel y on tile clicked
	var/tmp/click_params_tile_py
	/// tile x from bottom left of screen, starting at 1
	var/tmp/click_params_screen_tx
	/// tile y from bottom left of screen, starting at 1
	var/tmp/click_params_screen_ty

	/// clickdelay base out
	var/click_cooldown_base = 0
	/// clickdelay multiplier out
	/// * the proc that invoked the clickchain handling this event_args should
	///   handle this. clickchain will not handle clickdelay itself!
	var/click_cooldown_multiplier = 1

	//* Target Data *//

	/// optional: target atom
	var/atom/target
	/// optional: target zone
	var/target_zone

	//* Attack Data *//

	/// Overall damage multiplier
	///
	/// * Allowed to be changed by shieldcalls and other intercepts
	var/attack_melee_multiplier = 1
	/// Overall impact multiplier
	///
	/// * Allowed to be changed by shieldcalls and other intercepts
	/// * Unlike 'attack melee multiplier', this will block everything else too.
	///   This is for shieldcalls to inject into to say 'hey, we blocked any contact, not just dampened damage'.
	var/attack_contact_multiplier = 1

	//* Resolved Data *//

	/// Resolved angle from performer
	/// * This is in degrees clockwise of north.
	var/tmp/resolved_angle_from_performer

	//* Out Data *//

	/// total damage inflicted; set by target
	var/out_damage_inflicted = 0

/datum/event_args/actor/clickchain/New(mob/performer, mob/initiator, atom/target, list/params, intent)
	..()
	// using //
	src.using_intent = intent
	// click //
	src.click_params = params || list()
	// target //
	src.target = target

	//! LEGACY AUTO FILL !//
	if(isnull(src.using_intent))
		src.using_intent = performer?.a_intent
	if(isnull(src.target_zone))
		src.target_zone = performer?.zone_sel?.selecting || BP_TORSO
	//! END !//

/datum/event_args/actor/clickchain/clone()
	var/datum/event_args/actor/clickchain/cloning = ..()
	cloning.using_intent = using_intent
	cloning.using_hand_index = using_hand_index
	cloning.using_melee_attack = using_melee_attack
	cloning.using_melee_weapon = using_melee_weapon
	cloning.click_params = click_params
	cloning.click_cooldown_base = click_cooldown_base
	cloning.click_cooldown_multiplier = click_cooldown_multiplier
	cloning.target = target
	cloning.target_zone = target_zone
	cloning.attack_melee_multiplier = attack_melee_multiplier
	cloning.attack_contact_multiplier = attack_contact_multiplier
	cloning.out_damage_inflicted = out_damage_inflicted
	return cloning

/**
 * Resolves the angle of the clicked pixel from a given entity.
 *
 * * This defaults to the clickchain's performer.
 * * This means that this proc should correctly offset the effective angle if the entity is not the center of the
 *   initiator's screen!
 * * Calling this with no arguments or with the clickchain's performer will also resolve the pixel x/y
 *   of the click
 *
 * @return degrees clockwise from north, or null if failed to resolve
 */
/datum/event_args/actor/clickchain/proc/resolve_click_angle(atom/from_entity = performer)
	if((from_entity == performer) && !isnull(resolved_angle_from_performer))
		return resolved_angle_from_performer
	// todo: this relies on a client existing. this shouldn't be necessary for a true click simulation!
	if(!initiator?.client)
		return
	if(!click_params)
		return
	unpack_click_params()
	// target x/y from bottom left of screen
	var/target_x = click_params_screen_tx * WORLD_ICON_SIZE + click_params_tile_px - WORLD_ICON_SIZE
	var/target_y = click_params_screen_ty * WORLD_ICON_SIZE + click_params_tile_py - WORLD_ICON_SIZE
	// origin x/y of the performing mob on the screen
	// todo: this doesn't take into account if the performer isn't the eye of the initiator's client!
	//       that'll need to be added for remote control to work.
	var/origin_x = (initiator.client.current_viewport_width * WORLD_ICON_SIZE * 0.5) - initiator.client.pixel_x
	var/origin_y = (initiator.client.current_viewport_height * WORLD_ICON_SIZE * 0.5) - initiator.client.pixel_y
	// atan args are reversed for clockwise from north instead of counterclockwise from east
	. = arctan(target_y - origin_y, target_x - origin_x)
	if(from_entity == performer)
		resolved_angle_from_performer = .

/datum/event_args/actor/clickchain/proc/unpack_click_params()
	if(click_params_unpacked)
		return
	click_params_unpacked = TRUE
	if(!click_params)
		return
	// Handle `screen-loc`, specified as "tile_x:pixel_x,tile_y:pixel_y"
	var/list/x_y_split = splittext(click_params["screen-loc"], ",")
	if(length(x_y_split))
		var/list/x_split = splittext(x_y_split[1], ":")
		var/list/y_split = splittext(x_y_split[2], ":")
		click_params_screen_tx = text2num(x_split[1])
		click_params_screen_ty = text2num(y_split[1])
		click_params_tile_px = text2num(x_split[2])
		click_params_tile_py = text2num(y_split[2])

/datum/event_args/actor/clickchain/proc/legacy_get_target_zone()
	return initiator?.zone_sel?.selecting
