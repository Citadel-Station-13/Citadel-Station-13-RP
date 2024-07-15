SUBSYSTEM_DEF(early_init)
	name = "Early Init"
	init_order = INIT_ORDER_EARLY_INIT
	subsystem_flags = SS_NO_FIRE

/datum/controller/subsystem/early_init/Initialize()
	init_bodyset_lookup()
	init_inventory_slot_lookup()
	init_crayon_decal_meta()
	return ..()
