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
	for(var/datum/starmap_view/V in views)
		to_chat(V.user, SPAN_WARNING("Reloading starmap [id] for editing."))
		V.reload()

/datum/starmap/proc/unlock_from_editing()
	if(!volatile)
		return
	if(dirty)
		repack()
		save_file()
	entity_by_id = null
	volatile = FALSE
	build_assets()
	for(var/datum/starmap_view/V in views)
		to_chat(V.user, SPAN_WARNING("Reloading starmap [id] for viewing."))
		V.reload()
