//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * A role is something you can join the game as, usually from the lobby or from the observer panel.
 */
/datum/prototype/role
	abstract_type = /datum/prototype/role

/datum/prototype/role/can_be_unloaded()
	// We have round-local temporaries.
	// TODO: but do we really? should we, really?
	return FALSE
