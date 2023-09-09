/datum/material/cardboard
	id = "cardboard"
	name = "cardboard"
	stack_type = /obj/item/stack/material/cardboard
	flags = MATERIAL_BRITTLE
	integrity = 10
	icon_base = 'icons/turf/walls/solid.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_solid.dmi'
	icon_colour = "#AAAAAA"
	hardness = 1
	weight = 1
	protectiveness = 0 // 0%
	conductive = 0
	ignition_point = T0C+232 //"the temperature at which book-paper catches fire, and burns." close enough
	melting_point = T0C+232 //temperature at which cardboard walls would be destroyed
	stack_origin_tech = list(TECH_MATERIAL = 1)
	door_icon_base = "wood"
	destruction_desc = "crumples"
	radiation_resistance = 1
	pass_stack_colors = TRUE

/datum/material/cardboard/generate_recipes()
	. = ..()
	. += create_stack_recipe_datum(
		name = "box",
		product = /obj/item/storage/box,
		cost = 1,
	)
	. += create_stack_recipe_datum(
		name = "donut box",
		product = /obj/item/storage/box/donut/empty,
		cost = 1,
	)
	. += create_stack_recipe_datum(
		name = "egg box",
		product = /obj/item/storage/fancy/egg_box,
		cost = 1,
	)
	. += create_stack_recipe_datum(
		name = "light tubes box",
		product = /obj/item/storage/box/lights/tubes,
		cost = 1,
	)
	. += create_stack_recipe_datum(
		name = "light bulbs box",
		product = /obj/item/storage/box/lights/bulbs,
		cost = 1,
	)
	. += create_stack_recipe_datum(
		name = "mouse traps box",
		product = /obj/item/storage/box/mousetraps,
		cost = 1,
	)
	. += create_stack_recipe_datum(
		name = "cardborg suit",
		product = /obj/item/clothing/suit/cardborg,
		cost = 3,
	)
	. += create_stack_recipe_datum(
		name = "cardborg helmet",
		product = /obj/item/clothing/head/cardborg,
		cost = 1,
	)
	. += create_stack_recipe_datum(
		name = "pizza box",
		product = /obj/item/pizzabox,
		cost = 1,
	)
	. += create_stack_recipe_datum(
		name = "large cardboard box",
		product = /obj/structure/closet/largecardboard,
		cost = 3,
		time = 2.5 SECONDS,
	)
