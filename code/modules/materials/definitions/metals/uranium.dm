/datum/material/uranium
	id = "uranium"
	name = "uranium"
	stack_type = /obj/item/stack/material/uranium
	radioactivity = RAD_INTENSITY_MAT_URANIUM
	icon_base = 'icons/turf/walls/stone_wall.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_stone.dmi'
	icon_reinf_directionals = TRUE
	icon_colour = "#007A00"
	weight = 22
	stack_origin_tech = list(TECH_MATERIAL = 5)
	door_icon_base = "stone"
	tgui_icon_key = "uranium"

/datum/material/uranium/generate_recipes()
	. = ..()
	. += create_stack_recipe_datum(category = "statues", name = "engineer statue", product = /obj/structure/statue/uranium/eng, cost = 10, time = 2 SECONDS)
	. += create_stack_recipe_datum(category = "statues", name = "nuke statue", product = /obj/structure/statue/uranium/nuke, cost = 10, time = 2 SECONDS)
	. += create_stack_recipe_datum(name = "uranium floor tiles", product = /obj/item/stack/tile/uranium, amount = 4)
