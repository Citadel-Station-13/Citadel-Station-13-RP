//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * Loads all networks.
 */

/**
 * A collection of channels
 */
/datum/news_network
	/// database UID int
	var/id
	/// database key, if any; can be null
	var/key
	/// is this a hardcoded network?
	var/hardocded = FALSE
	/// should this be hidden?
	var/hidden = FALSE
	/// network flags
	var/news_network_flags = NONE
	/// our name
	var/name
	/// creator ckey, if any
	var/creator_ckey
	/// creator player id, if any
	var/creator_player


#warn a
