/datum/asset/spritesheet/materials
	name = "sheetmaterials"

/datum/asset/spritesheet/materials/create_spritesheets()



	InsertAll("material-stack-", 'icons/obj/stacks.dmi')
	//InsertAll("", 'icons/obj/stack_objects.dmi')

	// Special case to handle Bluespace Crystals
	Insert("polycrystal", 'icons/obj/telescience.dmi', "polycrystal")
	#warn icons/interface/materials.dmi
