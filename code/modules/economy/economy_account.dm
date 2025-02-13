//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * An account; usually held as part of an economy faction. Or not. Maybe.
 */
/datum/economy_account
	/// Our account number.
	/// * Account numbers must be **globally unique** at time of writing.
	#warn impl uniqueness
	#warn audit access
	var/account_number

	/// Amount of money in it.
	var/balance = 0

	/// our faction id, if we're part of a faction
	var/faction_id
	/// our id, if we're a keyed account for our factoin
	var/faction_account_key
