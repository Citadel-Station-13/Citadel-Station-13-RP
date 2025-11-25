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
	/// Provisioning
	/// * Not destroyed across different owners, this owns our items and more.
	var/datum/robot_provisioning/provisioning
	/// Lazy man's create_mounted_item_descriptor injection.
	/// * This shouldn't be used at compile time; just override the proc.
	VAR_PRIVATE/list/provisioning_inject_item_descriptors

/obj/item/robot_upgrade/Destroy()
	owner?.uninstall_upgrade(src, TRUE)
	QDEL_NULL(provisioning)
	return ..()

/obj/item/robot_upgrade/using_as_item(atom/target, datum/event_args/actor/clickchain/clickchain, clickchain_flags, datum/callback/reachability_check)
	. = ..()
	if(.)
		return
	if(!isrobot(target))
		return
	var/mob/living/silicon/robot/robot_target = target
	if(!robot_target.opened)
		clickchain.chat_feedback(
			SPAN_WARNING("[robot_target] needs to havea their cover opened for you to access their internals!"),
			target = robot_target,
		)
		return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
	robot_target.user_install_upgrade(src, actor = clickchain)
	return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING

/obj/item/robot_upgrade/proc/load_provisioning_if_needed()
	if(provisioning)
		return
	create_provisioning()

/obj/item/robot_upgrade/proc/create_provisioning() as /datum/robot_provisioning
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	// obliterate existing if there
	QDEL_NULL(provisioning)
	// make new one
	var/datum/robot_provisioning/creating = new
	. = creating
	var/list/items = create_mounted_items()
	for(var/obj/item/item as anything in items)
		creating.add_item(item)
	return creating

/obj/item/robot_upgrade/proc/create_mounted_items() as /list
	var/list/obj/item/items = list()

	var/list/i_normal = list()
	create_mounted_item_descriptors(i_normal)
	for(var/obj/item/descriptor as anything in i_normal)
		var/obj/item/resolved
		if(istype(descriptor))
			resolved = descriptor
		else if(ispath(descriptor))
			resolved = new descriptor
		else if(IS_ANONYMOUS_TYPEPATH(descriptor))
			resolved = new descriptor
		else
			stack_trace("invalid descriptor [descriptor] on [id] ([type])")
			continue
		items += resolved

	return items

/**
 * See: `/datum/prototype/robot_module/proc/create_mounted_item_descriptors`.
 *
 * This uses the exact same format and is handled in a similar way.
 */
/obj/item/robot_upgrade/proc/create_mounted_item_descriptors(list/out_list)
	out_list.Add(provisioning_inject_item_descriptors)

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
