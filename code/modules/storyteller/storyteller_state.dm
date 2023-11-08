//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/storyteller_state
	//* state
	/// arbitrary blackboard assoc list
	/// will eventually be persistent
	/// useful for state tracking in the future
	///
	/// values must be a number, string, or an assoc/index list consisting only of those.
	var/list/persistent = list()
	/// arbitrary blackboard assoc
	/// does not persist and is round-local
	///
	/// values must be a number, string, or an assoc/index list consisting only of those.
	var/list/volatile = list()

	//* references
	/// storyteller faction instance of primary faction
	var/datum/storyteller_faction/primary_faction
	/// world location instances of where the ma pis
	var/list/datum/storyteller_location/active_locations
	/// active factions
	var/list/datum/storyteller_faction/active_factions
	/// active pawns
	var/list/datum/storyteller_pawn/active_pawns

	#warn uhh


#warn this is currently unused, pending parsing
