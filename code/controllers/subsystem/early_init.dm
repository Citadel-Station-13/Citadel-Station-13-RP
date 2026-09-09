SUBSYSTEM_DEF(early_init)
	name = "Early Init"
	init_stage = INIT_STAGE_EARLY
	subsystem_flags = SS_NO_FIRE

/datum/controller/subsystem/early_init/Initialize()
	if (!GLOB.catalogue_data)
		GLOB.catalogue_data = new
	if (!ntnet_global)
		ntnet_global = new // temporary house
	ntnet_global.initialize_ntnet()
	CHECK_TICK

	init_bitfield_meta()
	init_emote_meta()
	init_crayon_decal_meta()
	init_inventory_slot_meta()
	return SS_INIT_SUCCESS
