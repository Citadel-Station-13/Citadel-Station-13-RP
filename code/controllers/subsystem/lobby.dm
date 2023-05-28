/**
 * manager for everything involving the lobby, including the title screen
 */
SUBSYSTEM_DEF(lobby)
	name = "Lobby Manager"
	subsystem_flags = SS_NO_FIRE

	/// our titlescreen
	var/datum/cutscene/titlescreen
