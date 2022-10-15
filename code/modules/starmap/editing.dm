/datum/starmap/proc/insert_entity(datum/starmap_entity/E, mob/user)

/datum/starmap/proc/delete_entity(datum/starmap_entity/E, mob/user)

/datum/starmap/proc/lock_for_editing()
	if(volatile)
		return
	volatile = TRUE
	load_file()
	build_editing_caches()

/datum/starmap/proc/unlock_from_editing()
	if(!volatile)
		return
	volatile = FALSE
	if(dirty)
		repack()
		save_file()
		rebuild_assets()
	clear_editing_caches()

/datum/starmap/proc/build_editing_caches()
	entity_by_id = list()
	for(var/datum/starmap_entity/E as anything in entities)
		if(!istype(E))
			// throw out garbage right here and now
			entities -= E
			continue
		if(entity_by_id[E.id])
			// throw out dupes right here and now, people should know better
			entities -= E
			continue
		entity_by_id[E.id] = E

/datum/starmap/proc/clear_editing_caches()
	entity_by_id = null
