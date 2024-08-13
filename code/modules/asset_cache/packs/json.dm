
/// A subtype to generate a JSON file from a list
/datum/asset_pack/json
	abstract_type = /datum/asset_pack/json
	/// The filename, will be suffixed with ".json"
	var/name

/datum/asset_pack/json/register(generation)
	var/filename = "tmp/assets/[name].json"
	fdel(filename)
	text2file(json_encode(generate()), filename)
	return list(
		"[name].json" = file(filename),
	)
