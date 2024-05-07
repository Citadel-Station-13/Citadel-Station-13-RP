/datum/asset_pack/spritesheet/simple
	abstract_type = /datum/asset_pack/spritesheet/simple
	var/list/assets

/datum/asset_pack/spritesheet/simple/create_spritesheets()
	for (var/key in assets)
		Insert(key, assets[key])
