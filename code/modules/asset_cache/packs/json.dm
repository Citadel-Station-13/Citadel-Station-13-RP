
/// A subtype to generate a JSON file from a list
/datum/asset_pack/json
	abstract_type = /datum/asset_pack/json
	/// The filename, will be suffixed with ".json"
	var/name

/datum/asset_pack/json/register(generation)
	var/filename = "data/asset-cache/assets/[name].json"
	fdel(filename)
	text2file(json_encode(generation), filename)
	return list(
		"[name].json" = file(filename),
	)

/datum/asset_pack/json/generate()
	return list()
