/datum/starmap/proc/insert_entity(datum/starmap_entity/E)
	ASSERT(volatile)

/datum/starmap/proc/delete_entity(datum/starmap_entity/E)
	ASSERT(volatile)


	#warn will have to clear out the group data from entities with this group too

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
	volatile = FALSE
	if(dirty)
		repack()
		save_file()
	entity_by_id = null
	build_assets()

	#warn close all uis for asset reload
