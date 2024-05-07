/datum/asset/spritesheet/simple
	abstract_type = /datum/asset/spritesheet/simple
	var/list/assets

/datum/asset/spritesheet/simple/create_spritesheets()
	for (var/key in assets)
		Insert(key, assets[key])
