/datum/asset/spritesheet/crayons
	name = "crayon-graffiti"

/datum/asset/spritesheet/crayons/create_spritesheets()
	for(var/datum/crayon_decal_meta/crayon_data in GLOB.crayon_data)
		InsertAll(crayon_data.name, crayon_data.icon_ref)
