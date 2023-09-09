/datum/material/sandstone
	id = "sandstone"
	name = "sandstone"
	stack_type = /obj/item/stack/material/sandstone
	icon_base = 'icons/turf/walls/stone_wall.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_stone.dmi'
	icon_reinf_directionals = TRUE
	icon_colour = "#D9C179"
	shard_type = SHARD_STONE_PIECE
	weight = 22
	hardness = 55
	protectiveness = 5 // 20%
	conductive = 0
	conductivity = 5
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	table_icon_base = "stone"
	tgui_icon_key = "sandstone"

/datum/material/sandstone/generate_recipes()
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
