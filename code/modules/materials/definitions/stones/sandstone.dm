/datum/prototype/material/sandstone
	id = "sandstone"
	name = "sandstone"
	stack_type = /obj/item/stack/material/sandstone
	icon_base = 'icons/turf/walls/stone_wall.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_stone.dmi'
	icon_reinf_directionals = TRUE
	icon_colour = "#D9C179"
	shard_type = SHARD_STONE_PIECE
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	table_icon_base = "stone"
	tgui_icon_key = "sandstone"

	relative_integrity = 0.7
	weight_multiplier = 4
	density = 8 * 0.7
	relative_conductivity = 0
	relative_permeability = 0.05
	relative_reactivity = 0.4
	hardness = MATERIAL_RESISTANCE_LOW
	toughness = MATERIAL_RESISTANCE_HIGH
	refraction = MATERIAL_RESISTANCE_VULNERABLE
	absorption = MATERIAL_RESISTANCE_MODERATE
	nullification = MATERIAL_RESISTANCE_VULNERABLE

	worth = 1.25

	material_constraints = MATERIAL_CONSTRAINT_RIGID

/datum/prototype/material/sandstone/generate_recipes()
	. = ..()
	. += create_stack_recipe_datum(category = "statues", name = "assistant statue", product = /obj/structure/statue/sandstone/assistant, amount = 10)
	. += create_stack_recipe_datum(
		name = "planting bed",
		product = /obj/machinery/portable_atmospherics/hydroponics/soil,
		cost = 3,
		time = 1 SECONDS,
	)
	. += create_stack_recipe_datum(
		name = "sandstone floor tile",
		product = /obj/item/stack/tile/floor/sandstone,
		cost = 1,
		amount = 3,
	)
	. += create_stack_recipe_datum(
		name = "sandstone jar",
		product = /obj/item/reagent_containers/glass/bucket/sandstone,
		cost = 2
	)
