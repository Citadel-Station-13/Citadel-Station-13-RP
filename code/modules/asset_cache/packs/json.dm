
/// A subtype to generate a JSON file from a list
/datum/asset_pack/json
	abstract_type = /datum/asset_pack/json
	/// The filename, will be suffixed with ".json"
	var/name

/datum/asset_pack/json/send(client)
	return SSassets.transport.send_assets(client, "[name].json")

/datum/asset_pack/json/get_url_mappings()
	return list(
		"[name].json" = SSassets.transport.get_asset_url("[name].json"),
	)

/datum/asset_pack/json/register()
	var/filename = "data/[name].json"
	fdel(filename)
	text2file(json_encode(generate()), filename)
	SSassets.transport.register_asset("[name].json", fcopy_rsc(filename))
	fdel(filename)

/// Returns the data that will be JSON encoded
/datum/asset_pack/json/proc/generate()
	SHOULD_CALL_PARENT(FALSE)
	CRASH("generate() not implemented for [type]!")
