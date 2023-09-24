/datum/material/phoron
	id = "phoron"
	name = "phoron"
	stack_type = /obj/item/stack/material/phoron
	ignition_point = PHORON_MINIMUM_BURN_TEMPERATURE
	icon_base = 'icons/turf/walls/solid_wall.dmi'
	icon_reinf = 'icons/turf/walls/solid_wall_reinforced.dmi'
	icon_colour = "#FC2BC5"
	shard_type = SHARD_SHARD
	hardness = 30
	stack_origin_tech = list(TECH_MATERIAL = 2, TECH_PHORON = 2)
	door_icon_base = "stone"
	sheet_singular_name = "crystal"
	sheet_plural_name = "crystals"

/datum/material/phoron/generate_recipes()
	. = ..()
	. += create_stack_recipe_datum(category = "statues", name = "scientist statue", product = /obj/structure/statue/phoron/scientist, cost = 10, time = 2 SECONDS)
	. += create_stack_recipe_datum(category = "statues", name = "xenomorph statue", product = /obj/structure/statue/phoron/xeno, cost = 10, time = 2 SECONDS)
	. += create_stack_recipe_datum(name = "phoron floor tiles", product = /obj/item/stack/tile/phoron, amount = 4)
