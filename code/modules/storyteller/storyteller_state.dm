//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/storyteller_state
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
	#warn uhh

#warn this is currently unused, pending parsing
