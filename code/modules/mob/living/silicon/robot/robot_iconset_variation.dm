//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Things to note:
 * * indicator state must be set for us to have primary lighting indicator + emissives while using this variation
 * * cover state must be set for ... (you get the deal)
 */
/datum/robot_iconset_variation
	/// id; must be unique
	var/id

	/// icon override
	/// * applies to **all** overlays
	var/icon_override

	/// state override
	/// * overrides [icon_state_append]
	var/icon_state
	/// state append to override our state with
	var/icon_state_append
	/// primary indicator lighting overlay override state
	/// * overrides [icon_state_indicator_append]
	var/icon_state_indicator
	/// state append to override our indicator state with
	var/icon_state_indicator_append
	/// cover overlay override state
	/// * overrides [icon_state_cover_append]
	var/icon_state_cover
	/// state append to override our cover state with
	var/icon_state_cover_append

	/// is the player allowed to choose it while resting?
	var/alt_resting_state = FALSE

/datum/robot_iconset_variation/dead
	id = "dead"
	icon_state_append = "-wreck"

/datum/robot_iconset_variation/resting
	id = "resting"
	icon_state_append = "-rest"
	alt_resting_state = TRUE

/datum/robot_iconset_variation/sitting
	id = "sitting"
	icon_state_append = "-sit"
	alt_resting_state = TRUE

/datum/robot_iconset_variation/bellyup
	id = "bellyup"
	icon_state_append = "-bellyup"
	alt_resting_state = TRUE
