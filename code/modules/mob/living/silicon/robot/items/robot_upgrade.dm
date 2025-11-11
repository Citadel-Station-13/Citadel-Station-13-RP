//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/robot_upgrade
	name = "robot upgrade module"
	desc = "An upgrade module for a robot platform."
	#warn sprite reorg
	icon = 'icons/obj/module.dmi'
	icon_state = "cyborg_upgrade"

	//* Actions *//
	/// actions to give the owner of this upgrade
	///
	/// valid starting values include:
	/// * list of actions / typepaths
	/// * single action / typepath
	var/list/datum/action/upgrade_actions
	/// set to a string to initialize upgrade_actions with a generic action of this name
	var/upgrade_action_name
	/// description for upgrade action; defaults to [desc]
	var/upgrade_action_desc

	/// Who we're installed in.
	var/mob/living/silicon/robot/owner
	/// Items provided
	/// * Lazy-inited
	var/list/obj/item/mounted_items
	/// Lazy man's create_mounted_item_descriptor injection.
	/// * This shouldn't be used at compile time; just override the proc.
	#warn hook
	var/list/mounted_item_descriptor_inject

/obj/item/robot_upgrade/Destroy()
	owner?.uninstall_upgrade(src, TRUE)
	QDEL_LIST(mounted_items)
	return ..()

/obj/item/robot_upgrade/using_as_item(atom/target, datum/event_args/actor/clickchain/e_args, clickchain_flags, datum/callback/reachability_check)
	. = ..()
	if(.)
		return
	if(!isrobot(target))
		return
	var/mob/living/silicon/robot/robot_target = target
	robot_target.install_upgrade(src, actor = e_args)
	return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING

/obj/item/robot_upgrade/proc/ensure_mounted_items_loaded()
	if(mounted_items)
		return
	create_mounted_items()

/obj/item/robot_upgrade/proc/create_mounted_items()
	var/list/descriptors = create_mounted_item_descriptors()
	#warn impl
	#warn handle item deletions

/**
 * See: `/datum/prototype/robot_module/proc/create_mounted_item_descriptors`.
 *
 * This uses the exact same format and is handled in a similar way.
 */
/obj/item/robot_upgrade/proc/create_mounted_item_descriptors(list/out_list)
	return

/**
 * Called when checking if we can be applied
 *
 * * Robot has final say for hard conflicts. (we won't be called in that case)
 * * We have final say for soft conflicts.
 *
 * @params
 * * target - robot we're attempting to be installed in
 * * robot_opinion - what the robot says about it
 * * actor - (optional) person doing the install
 * * silent - (optional) do not emit feedback to the actor
 *
 * @return TRUE / FALSE
 */
/obj/item/robot_upgrade/proc/can_install(mob/living/silicon/robot/target, robot_opinion, datum/event_args/actor/actor, silent)
	return TRUE

/**
 * Called when being applied.
 *
 * * Destructive operations here (like deleting ourselves) is allowed.
 * * This is where 'consumable' upgrades like 'enable emag items' are put.
 */
/obj/item/robot_upgrade/proc/being_installed(mob/living/silicon/robot/target)
	return

/**
 * Called on install.
 */
/obj/item/robot_upgrade/proc/on_install(mob/living/silicon/robot/target)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)

	grant_upgrade_actions(target)

/**
 * Called on uninstall.
 *
 * * We're uninstalled if the robot is deleted.
 */
/obj/item/robot_upgrade/proc/on_uninstall(mob/living/silicon/robot/target)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)

	revoke_upgrade_actions(target)

//* Actions *//

/obj/item/robot_upgrade/proc/ensure_upgrade_actions_loaded()
	if(islist(upgrade_actions))
		for(var/i in 1 to length(upgrade_actions))
			var/key = upgrade_actions[i]
			if(ispath(key, /datum/action))
				upgrade_actions[i] = key = new key(src)
	else if(ispath(upgrade_actions, /datum/action))
		upgrade_actions = new upgrade_actions
	else if(istype(upgrade_actions, /datum/action))
	else if(upgrade_action_name)
		var/datum/action/robot_upgrade_action/creating = new(src)
		upgrade_actions = creating
		creating.name = upgrade_action_name
		creating.desc = upgrade_action_desc || desc

/obj/item/robot_upgrade/proc/grant_upgrade_actions(mob/target)
	if(islist(upgrade_actions))
		for(var/datum/action/action in upgrade_actions)
			action.grant(target.actions_innate)
	else if(istype(upgrade_actions, /datum/action))
		var/datum/action/action = upgrade_actions
		action.grant(target.actions_innate)

/obj/item/robot_upgrade/proc/revoke_upgrade_actions(mob/target)
	if(islist(upgrade_actions))
		for(var/datum/action/action in upgrade_actions)
			action.revoke(target.actions_innate)
	else if(istype(upgrade_actions, /datum/action))
		var/datum/action/action = upgrade_actions
		action.revoke(target.actions_innate)
