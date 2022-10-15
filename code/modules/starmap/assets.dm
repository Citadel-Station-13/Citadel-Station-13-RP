/**
 * builds & stores the asset entry used when not editing
 * while not editing, we send data using asset cache system
 */
/datum/starmap/proc/build_assets()
	ASSERT(!volatile)

	#warn load json, register


/**
 *
/// A subtype to generate a JSON file from a list
/datum/asset/json
	_abstract = /datum/asset/json
	/// The filename, will be suffixed with ".json"
	var/name

/datum/asset/json/send(client)
	return SSassets.transport.send_assets(client, "[name].json")

/datum/asset/json/get_url_mappings()
	return list(
		"[name].json" = SSassets.transport.get_asset_url("[name].json"),
	)

/datum/asset/json/register()
	var/filename = "data/[name].json"
	fdel(filename)
	text2file(json_encode(generate()), filename)
	SSassets.transport.register_asset("[name].json", fcopy_rsc(filename))
	fdel(filename)

/// Returns the data that will be JSON encoded
/datum/asset/json/proc/generate()
	SHOULD_CALL_PARENT(FALSE)
	CRASH("generate() not implemented for [type]!")

 */


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
