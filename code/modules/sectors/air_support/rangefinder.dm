//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/atom/movable/laser_designator_target
	name = "rangefinding laser"
	desc = "Stop staring at the laser and start staring at the sky, because \
	something's probably about to fall out of it."
	plane = ABOVE_LIGHTING_PLANE
	layer = ABOVE_LIGHTING_LAYER_MAIN
	icon = 'icons/modules/sectors/air_support/rangefinder.dmi'
	icon_state = "turf-laser"
	/// allow weapons guidance
	//  TODO: unimplemented
	var/allow_weapons_guidance = FALSE
	/// we are visible
	var/visible_dot

/atom/movable/laser_designator_target/Initialize(mapload, allow_weapons_guidance, visible_dot)
	src.allow_weapons_guidance = allow_weapons_guidance
	src.visible_dot = visible_dot
	alpha = visible_dot ? initial(alpha) : 0

	var/datum/component/high_altitude_signal/signal_comp = AddComponent(/datum/component/high_altitude_signal, "rangefinding laser")
	signal_comp.on_get_effective_turf = CALLBACK(src, PROC_REF(get_effective_turf))
	signal_comp.require_effective_turf_high_altitude_visibility = TRUE

	if(ismovable(loc))
		var/atom/movable/thingy = loc
		thingy.vis_contents += src
	return ..()

/atom/movable/laser_designator_target/Destroy()
	if(ismovable(loc))
		var/atom/movable/thingy = loc
		thingy.vis_contents -= src
	return ..()

/atom/movable/laser_designator_target/proc/get_effective_turf()
	SIGNAL_HANDLER
	if(isturf(loc))
		return loc
	if(ismovable(loc) && isturf(loc.loc))
		return loc.loc
	return null

/atom/movable/laser_designator_target/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change)
	..()
	if(ismovable(old_loc))
		var/atom/movable/old_thingy = old_loc
		old_thingy.vis_contents -= src
	if(ismovable(loc))
		var/atom/movable/new_thingy = loc
		new_thingy.vis_contents += src

/**
 * citadel rp's rangefinders / LDs work somewhat differently from CM's
 *
 * mostly because we're not balancing this for CAS, we're balancing this for utility functions
 *
 * short list:
 *
 * * the zoom works very differently
 * * LDs can track targets
 * * LDs are not usually visible to the target
 * * (backend) rangefinders are designed in a way to be usable as a component of another object, which is usually not what i do for this use case but whatever
 */
/obj/item/rangefinder
	name = "rangefinder"
	desc = "A handy pair of binoculars used to perform rangefinding."
	icon = 'icons/modules/sectors/air_support/rangefinder.dmi'
	icon_state = "rangefinder"
	base_icon_state = "rangefinder"

	/// can be used as a rangefinder
	var/is_rangefinder = TRUE
	/// can be used as a laser designator
	var/is_designator = FALSE

	/// laser designation time
	var/laser_time = 7.5 SECONDS
	/// laser designation is visible to target
	///
	/// TODO: laser designation should be visible to user if this is off
	var/laser_visible = TRUE
	/// allow weapon guidance - if you turn this on without turning on laser_visible i will replace your eyelids with lemons
	var/laser_weapons_guidance = TRUE

	var/drop_laser_on_unzoom = FALSE
	var/drop_laser_on_move = TRUE

	/// active laser designator target
	var/atom/movable/laser_designator_target/active_laser_target
	var/turf/active_laser_last_self_turf

	/// active icon dot color
	var/icon_dot_color

	/// currently being zoomed
	/// * THIS IS NOT NECESSARILY THE PERSON HOLDING US.
	var/mob/currently_zoomed_in

	var/zoom_range_in_tiles = 21

	var/sfx_lasing_start = /datum/soundbyte/nightvision_chargeup
	var/sfx_lasing_start_vol = 35
	var/sfx_lasing_start_vary = FALSE

	var/sfx_lasing_lock = /datum/soundbyte/target_lock_1
	var/sfx_lasing_lock_vol = 35
	var/sfx_lasing_lock_vary = FALSE

	var/last_laser_retrace

	var/atom/lasing_target
	var/datum/event_args/actor/lasing_actor

/obj/item/rangefinder/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/rangefinder/Destroy()
	QDEL_NULL(active_laser_target)
	stop_zooming()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/item/rangefinder/update_icon()
	cut_overlays()
	if(active_laser_target)
		icon_dot_color = "#ff0000"
	else if(is_rangefinder || is_designator)
		icon_dot_color = "#00aa00"
	var/new_inhand_state = "[base_icon_state][currently_zoomed_in ? "_eyes" : ""]"
	if(new_inhand_state != inhand_state)
		inhand_state = new_inhand_state
		update_worn_icon()
	. = ..()
	if(icon_dot_color)
		var/image/dot_overlay = image(icon, "[base_icon_state]-dot")
		dot_overlay.color = icon_dot_color
		add_overlay(dot_overlay)

/obj/item/rangefinder/proc/set_icon_dot_color(new_color)
	icon_dot_color = new_color
	update_icon()

/obj/item/rangefinder/on_attack_self(datum/event_args/actor/e_args)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	// listen no TK fuckery allowed
	if(e_args.performer != inv_inside.owner)
		return
	if(currently_zoomed_in == e_args.performer)
		stop_zooming()
	else
		start_zooming(inv_inside.owner)

/obj/item/rangefinder/on_inv_unequipped(mob/wearer, datum/inventory/inventory, slot_id_or_index, inv_op_flags, datum/event_args/actor/actor)
	stop_zooming()
	..()

/obj/item/rangefinder/proc/create_laser_designator_target(atom/target)
	if(active_laser_target)
		destroy_laser_designator_target()
	active_laser_target = new(target, laser_weapons_guidance, laser_visible)
	active_laser_last_self_turf = get_turf(src)
	START_PROCESSING(SSprocessing, src)

/obj/item/rangefinder/proc/destroy_laser_designator_target()
	if(!active_laser_target)
		return
	if(!QDELETED(active_laser_target))
		qdel(active_laser_target)
	active_laser_target = null
	STOP_PROCESSING(SSprocessing, src)

/obj/item/rangefinder/proc/on_laser_designator_target_deleted(datum/source)
	destroy_laser_designator_target()

/obj/item/rangefinder/proc/reconsider_laser_designation()
	if(drop_laser_on_move)
		if(get_turf(src) != active_laser_last_self_turf)
			destroy_laser_designator_target()
			return
		active_laser_last_self_turf = get_turf(src)
	var/turf/target_turf = get_turf(active_laser_target)
	var/list/turf/traced = trace_laser_designation(target_turf)
	last_laser_retrace = world.time
	for(var/turf/T as anything in traced)
		if(T.has_opaque_atom)
			destroy_laser_designator_target()
			return

/obj/item/rangefinder/proc/trace_laser_designation(turf/target) as /list
	var/turf/our_turf = get_turf(src)
	if(!our_turf)
		return null
	return getline(our_turf, target)

/obj/item/rangefinder/proc/start_zooming(mob/viewing)
	if(currently_zoomed_in)
		stop_zooming()
	currently_zoomed_in = viewing
	currently_zoomed_in.AddComponent(/datum/component/mob_zoom_binding/freezoom, null, null, 14)
	currently_zoomed_in.visible_message(
		SPAN_NOTICE("[currently_zoomed_in] looks through [src]."),
		SPAN_NOTICE("You start looking through [src]."),
		range = MESSAGE_RANGE_COMBAT_SUBTLE,
	)
	update_icon()
	return TRUE

/obj/item/rangefinder/proc/stop_zooming()
	if(!currently_zoomed_in)
		return
	if(drop_laser_on_unzoom)
		destroy_laser_designator_target()
	currently_zoomed_in.DelComponent(/datum/component/mob_zoom_binding)
	currently_zoomed_in.visible_message(
		SPAN_NOTICE("[currently_zoomed_in] looks up from [src]."),
		SPAN_NOTICE("You stop looking through [src]."),
		range = MESSAGE_RANGE_COMBAT_SUBTLE,
	)
	currently_zoomed_in = null
	update_icon()

/obj/item/rangefinder/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	. = ..()
	if(. & CLICKCHAIN_DO_NOT_PROPAGATE)
		return
	if(clickchain_flags & CLICKCHAIN_HAS_PROXIMITY)
		return
	to_chat(user, SPAN_NOTICE("[icon2html(src, user)] [rangefinder_output(user, target)]"))

/obj/item/rangefinder/proc/rangefinder_output(mob/user, atom/target)
	var/turf/source_turf = get_turf(user)
	var/turf/target_turf = get_turf(target)
	var/list/coords = SSmapping.get_virtual_coords_x_y(target_turf)
	var/dist = target.z == user.z ? get_turf_euclidean_dist(source_turf, target_turf) : SSmapping.get_virtual_horizontal_euclidean_dist(source_turf, target_turf)
	return "rangefinder estimate [round(dist, 0.1)]m @ [coords[1]]x, [coords[2]]y"

/obj/item/rangefinder/item_ctrl_click_interaction_chain(datum/event_args/actor/clickchain/clickchain, clickchain_flags, obj/item/active_item)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	if(!is_designator)
		return .
	attempt_clickchain_laser_designate(clickchain, clickchain_flags)
	return . | CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE

/**
 * this doesn't check if we're a laser designator!
 */
/obj/item/rangefinder/proc/attempt_clickchain_laser_designate(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	// already lasing
	if(lasing_target)
		clickchain.chat_feedback(
			SPAN_WARNING("[src] is busy!"),
			target = src,
		)
		return
	if(active_laser_target)
		destroy_laser_designator_target()

	var/list/traced
	var/turf/target_turf
	var/atom/target = clickchain.target

	target_turf = get_turf(target)
	traced = trace_laser_designation(target_turf)

	var/no_los = FALSE
	for(var/turf/T as anything in traced)
		if(T.has_opaque_atom)
			no_los = TRUE
			break

	if(no_los)
		clickchain.chat_feedback(
			SPAN_WARNING("Your line of sight to [target] is blocked by something."),
			target = src,
		)
		return TRUE

	var/effective_delay = laser_time

	clickchain.visible_feedback(
		target = src,
		range = MESSAGE_RANGE_COMBAT_SUBTLE,
		visible = SPAN_WARNING("[currently_zoomed_in] levels [src] and begins to aim its targeting laser."),
		otherwise_self = SPAN_WARNING("You start [src]'s target acquisition process, aiming at [target]."),
	)

	if(effective_delay > 0.5 SECONDS)
		playsound(src, sfx_lasing_start, sfx_lasing_start_vol, sfx_lasing_start_vary, -4)

	lasing_target = target
	lasing_actor = clickchain
	do
		. = do_after(clickchain.performer, effective_delay, src, additional_checks = CALLBACK(src, PROC_REF(continue_to_laser)))
	while(FALSE)
	lasing_actor = null
	lasing_target = null
	if(!.)
		return

	clickchain.chat_feedback(
		// TODO: the icon2html is bad
		SPAN_WARNING("[icon2html(src, clickchain.performer)]: Target locked, currently at [rangefinder_output(clickchain.performer, target)].")
	)

	create_laser_designator_target(target)

	playsound(src, sfx_lasing_lock, sfx_lasing_lock_vol, sfx_lasing_lock_vary, -4)

/obj/item/rangefinder/proc/continue_to_laser(list/do_after_args)
	if(world.time < last_laser_retrace + 0.35 SECONDS)
		return TRUE
	last_laser_retrace = world.time
	var/list/turfs = trace_laser_designation(lasing_target)
	for(var/turf/T as anything in turfs)
		if(T.has_opaque_atom)
			lasing_actor?.chat_feedback(
				SPAN_WARNING("Something on [T] breaks your targeting laser's beam."),
				target = T,
			)
			return FALSE
	return TRUE

/obj/item/rangefinder/process(delta_time)
	if(active_laser_target)
		reconsider_laser_designation()

/obj/item/rangefinder/laser_designator
	name = "laser designator"
	desc = "An upgraded rangefinder that can mark an entity with a laser beam visible from high altitude."
	is_designator = TRUE
