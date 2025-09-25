//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/atom/movable/laser_designator_target
	#warn sprite
	/// allow weapons guidance
	var/allow_weapons_guidance = FALSE
	/// we are visible
	var/visible_dot

/atom/movable/laser_designator_target/Initialize(mapload, allow_weapons_guidance, visible_dot)
	src.allow_weapons_guidance = allow_weapons_guidance
	src.visible_dot = visible_dot
	AddComponent(/datum/component/spatial_grid, SSspatial_grids.laser_designations)
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

	/// active laser designator target
	var/atom/movable/laser_designator_target/active_laser_target

	/// active icon dot color
	var/icon_dot_color

	/// currently being zoomed
	/// * THIS IS NOT NECESSARILY THE PERSON HOLDING US.
	var/mob/currently_zoomed_in

#warn impl

/obj/item/rangefinder/Destroy()
	QDEL_NULL(active_laser_target)
	return ..()

/obj/item/rangefinder/proc/update_icon()
	cut_overlays()
	if(active_laser_target)
		icon_dot_color = "#ff0000"
	else if(is_rangefinder || is_designator)
		icon_dot_color = "#00aa00"
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
	if(.)
		return
	#warn zoom mode

/obj/item/rangefinder/proc/create_laser_designator_target(atom/target)
	#warn impl

/obj/item/rangefinder/proc/destroy_laser_designator_target()
	if(!QDELETED(active_laser_target))
		qdel(active_laser_target)
	active_laser_target = null

/obj/item/rangefinder/proc/on_laser_designator_target_deleted(datum/source)
	destroy_laser_designator_target()

/obj/item/rangefinder/on_attack_self(datum/event_args/actor/e_args)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	#warn impl

/obj/item/rangefinder/on_inv_equipped(mob/wearer, datum/inventory/inventory, slot_id_or_index, inv_op_flags, datum/event_args/actor/actor)
	..()
	RegisterSignal(wearer, COMSIG_MOB_EXAMINATE, PROC_REF(on_user_examine))
	#warn impl

/obj/item/rangefinder/on_inv_unequipped(mob/wearer, datum/inventory/inventory, slot_id_or_index, inv_op_flags, datum/event_args/actor/actor)
	..()
	UnregisterSignal(wearer, COMSIG_MOB_EXAMINATE)
	#warn impl

/obj/item/rangefinder/proc/start_zooming(mob/viewing)

/obj/item/rangefinder/proc/stop_zooming()

/obj/item/rangefinder/proc/on_user_examine(mob/source, atom/target, list/examine_list)
	SIGNAL_HANDLER
	if(!examine_list)
		return
	#warn impl
	examine_list += SPAN_NOTICE("[icon2html(src, source)]: Its ")

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

/obj/item/rangefinder/laser_designator
	name = "laser designator"
	desc = "An upgraded rangefinder that can mark an entity with a laser beam visible from high altitude."
	is_designator = TRUE
