//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * something assigned to modify a map before atom initialization happens
 *
 * * injections generally happen after map initializations for map helpers
 * * do not hardcode coordinates using map injections unless absolutely necessary. make a map helper that marks it for you.
 * * injections should read map helpers that hook into initalizations to determine coordinates.
 *
 * pov: i coded too much TGUI and now i'm spamming middleware wyd :skull: :joy: :ok_hand: :100: this is a cry for help
 */
/datum/map_injection

/datum/map_injection/proc/injection(datum/dmm_context/context)
	return
