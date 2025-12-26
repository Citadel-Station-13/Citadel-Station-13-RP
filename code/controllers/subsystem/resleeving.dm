//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

SUBSYSTEM_DEF(resleeving)
	name = "Resleeving"
	subsystem_flags = SS_NO_FIRE | SS_NO_INIT

	/// keyed bodyscan store of /datum/mind_ref to /datum/resleeving_body_backup
	///
	/// ## why is this here
	///
	/// with transcore removed, there is nowhere to store the state of bodies
	/// without mirrors
	///
	/// this is required so you can take an active (mind-containing) brain
	/// to a sleevepod and grow that character's body back if it's in here
	/// by looking up their mindref datum
	///
	/// this should be removed when in game genetics is good enough to allow
	/// appearance edits, as at that point it's an IC issue
	var/static/list/round_local_body_backups = list()

/**
 * Imprints someone's body backup for the round.
 *
 * * ONLY CALL THIS WHEN THEY ARE BEING SPAWNED IN; THIS OVERWRITES THE OLD ENTRY.
 *
 * @return TRUE/FALSE success/failure
 */
/datum/controller/subsystem/resleeving/proc/store_round_local_body_backup(datum/mind/for_mind, mob/for_body)
	var/datum/resleeving_body_backup/backup = new(for_body)
	var/datum/mind_ref/mind_key = for_mind.get_mind_ref()

	round_local_body_backups[mind_key] = backup
