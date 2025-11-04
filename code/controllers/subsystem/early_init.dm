SUBSYSTEM_DEF(early_init)
	name = "Early Init"
	init_order = INIT_ORDER_EARLY_INIT
	init_stage = INIT_STAGE_EARLY
	subsystem_flags = SS_NO_FIRE

/datum/controller/subsystem/early_init/Initialize()
	init_bitfield_meta()
	init_emote_meta()
	init_crayon_decal_meta()
	init_inventory_slot_meta()
	return SS_INIT_SUCCESS
