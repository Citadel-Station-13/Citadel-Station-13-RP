//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * WIP
 *
 * todo: unified role system
 * todo: /datum/prototype? or maybe not? should this be loaded by map
 *       and shuttle / offmap / ghostrole spawner datums / objects?
 */
/datum/role
	abstract_type = /datum/role

	//* Basics *//

	/// unique id
	/// * must be globally unique, roles may be persistable!
	var/id

	//* Economy *//

	/// starting money multiplier
	var/economy_payscale = 1 * ECONOMY_PAYSCALE_JOB_DEFAULT
