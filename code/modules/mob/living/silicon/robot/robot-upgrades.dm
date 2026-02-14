//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * hard check
 */
/mob/living/silicon/robot/proc/can_install_upgrade(obj/item/robot_upgrade/upgrade, datum/event_args/actor/actor, silent, force)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	if(!upgrade.dupe_allowed)
		var/check_type = upgrade.dupe_type || upgrade.type
		for(var/obj/item/robot_upgrade/other as anything in upgrades)
			if(istype(other, check_type))
				if(!silent)
					actor?.chat_feedback(
						span_warning("There's already an upgrade of the same type in [src]."),
						target = src,
					)
				return FALSE

	return force || upgrade.can_install(src, ., actor, silent)

/mob/living/silicon/robot/proc/can_fit_upgrade(obj/item/robot_upgrade/upgrade, datum/event_args/actor/actor, silent)
	return TRUE

/mob/living/silicon/robot/proc/user_install_upgrade(obj/item/robot_upgrade/upgrade, datum/event_args/actor/actor)
	SHOULD_NOT_OVERRIDE(TRUE)

	if(actor)
		if(actor.performer && actor.performer.is_in_inventory(upgrade))
			if(!actor.performer.can_unequip(upgrade, upgrade.worn_slot))
				actor.chat_feedback(
					span_warning("[upgrade] is stuck to your hand!"),
					target = src,
				)
				return FALSE
	if(!install_upgrade(upgrade, actor))
		return FALSE
	// TODO: sound
	return TRUE

/**
 * * moves the upgrade into us if it wasn't already
 */
/mob/living/silicon/robot/proc/install_upgrade(obj/item/robot_upgrade/upgrade, datum/event_args/actor/actor, silent, force)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	ASSERT(!upgrade.owner)

	if(!can_install_upgrade(upgrade, actor, silent, force))
		return FALSE

	if(upgrade.loc != src)
		upgrade.forceMove(src)

	// todo: logging
	upgrade.being_installed(src)
	if(!QDELETED(upgrade))
		upgrade.owner = src
		upgrade.on_install(src)
		LAZYADD(upgrades, upgrade)

	if(!silent)
		actor?.visible_feedback(
			target = src,
			visible = span_notice("[actor.performer] slots [upgrade] into [src]."),
			range = MESSAGE_RANGE_CONFIGURATION,
		)

	return TRUE

/mob/living/silicon/robot/proc/user_uninstall_upgrade(obj/item/robot_upgrade/upgrade, datum/event_args/actor/actor, put_in_hands)
	SHOULD_NOT_OVERRIDE(TRUE)

	var/obj/item/uninstalled = uninstall_upgrade(upgrade, actor, new_loc = src)
	if(put_in_hands && actor?.performer)
		actor.performer.put_in_hands_or_drop(uninstalled)
	else
		var/atom/where_to_drop = drop_location()
		ASSERT(where_to_drop)
		uninstalled.forceMove(where_to_drop)
	// TODO: sound
	return TRUE

/**
 * * deletes the upgrade if no location is provided to move it to
 *
 * @return uninstalled item
 */
/mob/living/silicon/robot/proc/uninstall_upgrade(obj/item/robot_upgrade/upgrade, datum/event_args/actor/actor, silent, force, atom/new_loc)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	ASSERT(upgrade.owner == src)

	// todo: logging
	upgrade.on_uninstall(src)
	upgrade.owner = null
	LAZYREMOVE(upgrades, upgrade)

	if(!silent)
		actor?.visible_feedback(
			target = src,
			visible = span_notice("[actor.performer] pulls [upgrade] out of [src]."),
			range = MESSAGE_RANGE_CONFIGURATION,
		)

	if(new_loc)
		upgrade.forceMove(new_loc)
		. = upgrade
	else
		qdel(upgrade)
		. = null
