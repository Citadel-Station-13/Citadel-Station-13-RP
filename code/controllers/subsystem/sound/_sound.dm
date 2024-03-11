
SUBSYSTEM_DEF(sounds)
	name = "Sounds"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_SOUNDS

/datum/controller/subsystem/sounds/Initialize()
	setup_available_channels()
	setup_soundbytes()
	return ..()
