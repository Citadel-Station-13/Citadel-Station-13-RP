//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//! Hear Module
//! Contains all relevant core procs for receiving transmitted messages, visible or audible.

// todo: atom /say()code rewrite

/**
 * receive a visible message or action
 *
 * called on things with ATOM_HEAR flag.
 *
 * @params
 * * e_args - event_args of the visible message [/datum/event_args/visible_message]
 */
/atom/proc/see(message)
	#warn impl

/**
 * hear an audible message or action
 *
 * called on things with ATOM_HEAR flag.
 *
 * @params
 * * e_args - event_args of the audible message [/datum/event_args/audible_message]
 */
/atom/proc/hear(message)
	#warn impl
