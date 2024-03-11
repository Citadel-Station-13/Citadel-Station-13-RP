SUBSYSTEM_DEF(early_init)
	name = "Early Init"
	init_order = INIT_ORDER_EARLY_INIT
	flags = SS_NO_FIRE

/datum/controller/subsystem/early_init/Initialize()
	init_inventory_slot_meta()
	init_crayon_decal_meta()
	return SS_INIT_SUCCESS
