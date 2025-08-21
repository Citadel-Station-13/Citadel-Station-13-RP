/datum/prototype/material/marble
	id = "marble"
	name = "marble"
	icon_colour = "#AAAAAA"
	stack_type = /obj/item/stack/material/marble
	icon_base = 'icons/turf/walls/stone_wall.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_stone.dmi'
	icon_reinf_directionals = TRUE
	shard_type = SHARD_STONE_PIECE
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	table_icon_base = "stone"
	tgui_icon_key = "marble"

	relative_integrity = 0.7
	weight_multiplier = 4
	density = 8 * 1
	relative_conductivity = 0
	relative_permeability = 0.05
	relative_reactivity = 0.4
	hardness = MATERIAL_RESISTANCE_LOW
	toughness = MATERIAL_RESISTANCE_HIGH
	refraction = MATERIAL_RESISTANCE_VULNERABLE
	absorption = MATERIAL_RESISTANCE_MODERATE
	nullification = MATERIAL_RESISTANCE_VULNERABLE

	worth = 2

	material_constraints = MATERIAL_CONSTRAINT_RIGID

/datum/prototype/material/marble/generate_recipes()
	. = ..()
	. += create_stack_recipe_datum(
		name = "light marble floor tile",
		product = /obj/item/stack/tile/wmarble,
		cost = 1,
		amount = 4
	)
	. += create_stack_recipe_datum(
		name = "dark marble floor tile",
		product = /obj/item/stack/tile/bmarble,
		cost = 1,
		amount = 4
	)
	. += create_stack_recipe_datum(category = "statues", name = "male statue", product = /obj/structure/statue/marble/male, cost = 15, time = 4 SECONDS)
	. += create_stack_recipe_datum(category = "statues", name = "female statue", product = /obj/structure/statue/marble/female, cost = 15, time = 4 SECONDS)
	. += create_stack_recipe_datum(category = "statues", name = "monkey statue", product = /obj/structure/statue/marble/monkey, cost = 15, time = 4 SECONDS)
	. += create_stack_recipe_datum(category = "statues", name = "corgi statue", product = /obj/structure/statue/marble/corgi, cost = 15, time = 4 SECONDS)
