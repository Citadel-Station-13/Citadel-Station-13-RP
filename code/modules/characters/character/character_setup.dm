//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Iterator, browser, and editor for characters.
 */
/datum/character_setup
	/**
	 * Bound backend. If this is deleted, so are we.
	 */
	var/datum/character_backend/s_backend
