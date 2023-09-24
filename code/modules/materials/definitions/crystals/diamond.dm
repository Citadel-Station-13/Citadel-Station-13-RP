/datum/material/diamond
	id = "diamond"
	name = "diamond"
	stack_type = /obj/item/stack/material/diamond
	flags = MATERIAL_UNMELTABLE
	cut_delay = 60
	icon_colour = "#00FFE1"
	opacity = 0.4
	reflectivity = 0.6
	conductivity = 1
	shard_type = SHARD_SHARD
	tableslam_noise = 'sound/effects/Glasshit.ogg'
	hardness = 100
	stack_origin_tech = list(TECH_MATERIAL = 6)
	tgui_icon_key = "diamond"

/datum/material/diamond/generate_recipes()
	. = ..()
	. += create_stack_recipe_datum(category = "statues", name = "ai hologram statue", product = /obj/structure/statue/diamond/ai1, cost = 10, time = 2 SECONDS)
	. += create_stack_recipe_datum(category = "statues", name = "ai core statue", product = /obj/structure/statue/diamond/ai2, cost = 10, time = 2 SECONDS)
	. += create_stack_recipe_datum(category = "statues", name = "captain statue", product = /obj/structure/statue/diamond/captain, cost = 10, time = 2 SECONDS)
	. += create_stack_recipe_datum(name = "diamond floor tiles", product = /obj/item/stack/tile/diamond, amount = 4)
