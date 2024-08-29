/datum/asset_pack/spritesheet/crayons
	name = "crayon-graffiti"

/datum/asset_pack/spritesheet/crayons/generate()
	for(var/datum/crayon_decal_meta/crayon_data in GLOB.crayon_data)
		insert_all(crayon_data.name, crayon_data.icon_ref)
