
/// If you don't need anything complicated.
/datum/asset_pack/simple
	abstract_type = /datum/asset_pack/simple
	/**
	 * List of assets for this datum in the form of:
	 * * filename = file
	 * At runtime the asset file will be converted into a asset_item datum.
	 */
	var/assets = list()

/datum/asset_pack/simple/New(id, list/assets)
	..(id)
	if(!isnull(assets))
		src.assets = assets.Copy()

/datum/asset_pack/simple/register()
	. = list()
	for(var/key in assets)
		var/value = assets[key]
		if(isfile(value))
			.[key] = value
		else
			.[key] = file(value)
