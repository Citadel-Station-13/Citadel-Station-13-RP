/**
 * builds & stores the asset entry used when not editing
 * while not editing, we send data using asset cache system
 */
/datum/starmap/proc/build_assets()
	ASSERT(!volatile)
	var/path = path()
	var/buffer = fcopy_rsc(path)
	var/pack_name = "starmap_[id].json"
	SSassets.register_dynamic_asset(pack_name, buffer)
	entity_pack_name = pack_name

/**
 * clears the asset entry to lock for editing
 * while editing, we send data using ui data
 */
/datum/starmap/proc/clear_assets()
	ASSERT(volatile)
	if(!entity_pack_name)
		return
	SSassets.delete_dynamic_asset(entity_pack_name)
	entity_pack_name = null
