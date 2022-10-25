/datum/starmap/proc/insert_entity(datum/starmap_entity/E)
	ASSERT(volatile)

/datum/starmap/proc/delete_entity(datum/starmap_entity/E)
	ASSERT(volatile)

/datum/starmap/proc/lock_for_editing()
	if(volatile)
		return
	volatile = TRUE
	clear_assets()
	entity_by_id = list()
	load_file()

	#warn close all uis for asset reload

/datum/starmap/proc/unlock_from_editing()
	if(!volatile)
		return
	if(dirty)
		repack()
		save_file()
	entity_by_id = null
	volatile = FALSE
	build_assets()

	#warn close all uis for asset reload
