/**
 * manager for everything involving the lobby, including the title screen
 */
SUBSYSTEM_DEF(lobby)
	name = "Lobby Manager"
	subsystem_flags = SS_NO_FIRE
	init_order = INIT_ORDER_LOBBY

	/// our titlescreen
	var/datum/cutscene/titlescreen

/datum/controller/subsystem/lobby/Initialize()
	#warn impl
	return ..()

/datum/controller/subsystem/lobby/proc/initialize_title_scene()
	if(!isnull(titlescreen))
		QDEL_NULL(titlescreen)
	make_title_scene()

/datum/controller/subsystem/lobby/proc/make_title_scene()
