//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Base type of a character record.
 */
/datum/character_record
	/// string date of application
	///
	/// * set by serializer / deserializer; do not touch
	var/timestamp

	/// was this sealed?
	///
	/// * usually from ic sources
	var/sealed = FALSE
	/// was this soft-deleted?
	///
	/// * only admins can do this
	var/deleted = FALSE

	/// real ckey of writer
	///
	/// * this can be null if unknown.
	/// * this is not always accurate; the game tries to guess this from usually-accurate metrics.
	/// * if you're reading this as an admin, do your own investigation, seriously; don't follow this blindly.
	/// * this is OOC information and should never be viewable by players
	var/audit_player_id
	/// real character ID of writer
	///
	/// * this can be null if unknown.
	/// * this is not always accurate; the game tries to guess this from usually-accurate metrics.
	/// * if you're reading this as an admin, do your own investigation, seriously; don't follow this blindly.
	/// * this is OOC information and should never be viewable by players
	var/audit_character_id

	// TODO: how do we record characters if names are not UIDs?

#warn impl
