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
 * * message - raw message of what we should see. this might already be HTML-formatted by the sender.
 */
/atom/proc/see(message)
	#warn impl

/**
 * hear an audible message or action
 *
 * called on things with ATOM_HEAR flag.
 *
 * @params
 * * message - raw message of what we should hear. this might already be HTML-formatted by the sender.
 */
/atom/proc/hear(message)
	#warn impl
