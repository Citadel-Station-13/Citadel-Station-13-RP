/datum/material/marble
	id = "marble"
	name = "marble"
	icon_colour = "#AAAAAA"
	weight = 26
	hardness = 30
	integrity = 201 //hack to stop kitchen benches being flippable, todo: refactor into weight system
	stack_type = /obj/item/stack/material/marble
	icon_base = 'icons/turf/walls/stone_wall.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_stone.dmi'
	icon_reinf_directionals = TRUE
	shard_type = SHARD_STONE_PIECE
	protectiveness = 5 // 20%
	conductive = 0
	conductivity = 5
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	table_icon_base = "stone"
	tgui_icon_key = "marble"

/datum/material/marble/generate_recipes()
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
