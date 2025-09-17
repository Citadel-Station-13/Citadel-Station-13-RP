//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//! New action logging file. Global helpers for things like attack, construction, say, etc, will go in here. !//

// todo: flesh this file out
// todo: redo everything again lmao we need structured logging

/**
 * Logs a construction action / step
 *
 * @params
 * * target - target
 * * message - the message
 */
/mob/proc/actor_construction_log(atom/target, message)
	add_construction_logs(src, target, message)

/proc/add_construction_logs(mob/actor, atom/target, message)
	log_game("LEGACY CONSTRUCTION: [actor] --> [target] ([COORD(target)]): [message]")

// todo: remove above

/**
 * Log construction action
 *
 * todo: log initiator
 */
/proc/log_construction(datum/event_args/actor/e_args, atom/target, message)
	// todo: better handling
	log_game("CONSTRUCTION: [key_name(e_args?.performer)] [COORD(e_args?.performer)] -> [target] [COORD(target)]: [message]")

/**
 * log click - context menu
 */
/proc/log_click_context(datum/event_args/actor/e_args, atom/target, message)
	log_click("CONTEXT: [key_name(e_args.initiator)][e_args.performer != e_args.initiator? " via [key_name(e_args.performer)]" : ""] -> [target] [target.audit_loc()]: [message]")

/**
 * log click - action buttons
 */
/proc/log_click_action(datum/event_args/actor/e_args, datum/action/action, message)
	log_click("ACTION: [key_name(e_args.initiator)][e_args.performer != e_args.initiator? " via [key_name(e_args.performer)]" : ""] -> [action]: [message]")

/**
 * Log stack crafting
 *
 * todo: log initiator
 */
/proc/log_stackcrafting(mob/user, obj/item/stack/stack, name, amount, used, turf/where = get_turf(user))
	log_game("STACKCRAFT: [key_name(user)] crafted [amount] of [name] with [used] of [stack] at [where]")
