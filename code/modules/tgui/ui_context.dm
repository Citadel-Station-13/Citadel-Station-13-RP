//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * A context for an open UI window.
 *
 * * This context is passed down through child UIs, and is how child UIs are able to
 *   derive data about what their access should be through parent UIs.
 */
/datum/ui_context
	/// The real mob using this window.
	var/mob/user
