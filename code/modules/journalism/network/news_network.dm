//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * Loads all networks.
 */

/**
 * A collection of channels
 */
/datum/news_network
	/// database UID int **as string**
	var/id
	/// database key, if any; can be null
	var/key
	/// is this a hardcoded network?
	var/hardocded = FALSE
	/// network flags
	var/news_network_flags = NONE
	/// our name
	var/name

#warn a
