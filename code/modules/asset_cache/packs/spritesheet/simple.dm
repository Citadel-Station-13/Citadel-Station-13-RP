/datum/asset_pack/spritesheet/simple
	abstract_type = /datum/asset_pack/spritesheet/simple
	/**
	 * key = value list of icon_state = icon
	 *
	 * e.g.
	 * "enzyme" = 'icons/runtime/assets/condiments/enzyme.png'
	 *
	 * keys must be unique, obviously.
	 */
	var/list/assets

/datum/asset_pack/spritesheet/simple/generate()
	for (var/key in assets)
		insert(key, assets[key])
