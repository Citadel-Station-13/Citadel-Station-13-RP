SUBSYSTEM_DEF(sounds)
	name = "Sounds"
	subsystem_flags = SS_NO_FIRE
	init_order = INIT_ORDER_SOUNDS
	init_stage = INIT_STAGE_BACKEND

/datum/controller/subsystem/sounds/Initialize()
	setup_available_channels()
	setup_soundbytes()
	return SS_INIT_SUCCESS
