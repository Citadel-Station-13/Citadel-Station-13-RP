/datum/prototype/material/diamond
	id = MAT_DIAMOND
	name = "diamond"
	stack_type = /obj/item/stack/material/diamond
	cut_delay = 60
	icon_colour = "#00FFE1"
	opacity = 0.4
	shard_type = SHARD_SHARD
	tableslam_noise = 'sound/effects/Glasshit.ogg'
	stack_origin_tech = list(TECH_MATERIAL = 6)
	tgui_icon_key = "diamond"

	relative_integrity = 1.25
	relative_reactivity = 0.05
	relative_permeability = 0
	hardness = MATERIAL_RESISTANCE_HIGH
	toughness = MATERIAL_RESISTANCE_LOW
	refraction = MATERIAL_RESISTANCE_MODERATE
	absorption = MATERIAL_RESISTANCE_LOW
	nullification = MATERIAL_RESISTANCE_LOW
	density = 8 * 0.8
	relative_conductivity = 0

	worth = 37.5

/datum/prototype/material/diamond/generate_recipes()
	. = ..()
	. += create_stack_recipe_datum(category = "statues", name = "ai hologram statue", product = /obj/structure/statue/diamond/ai1, cost = 10, time = 2 SECONDS)
	. += create_stack_recipe_datum(category = "statues", name = "ai core statue", product = /obj/structure/statue/diamond/ai2, cost = 10, time = 2 SECONDS)
	. += create_stack_recipe_datum(category = "statues", name = "captain statue", product = /obj/structure/statue/diamond/captain, cost = 10, time = 2 SECONDS)
	. += create_stack_recipe_datum(name = "diamond floor tiles", product = /obj/item/stack/tile/diamond, amount = 4)
