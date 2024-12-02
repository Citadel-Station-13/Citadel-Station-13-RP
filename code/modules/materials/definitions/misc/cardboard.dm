/datum/prototype/material/cardboard
	id = "cardboard"
	name = "cardboard"
	stack_type = /obj/item/stack/material/cardboard
	icon_base = 'icons/turf/walls/solid_wall.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_solid.dmi'
	icon_colour = "#AAAAAA"
	ignition_point = T0C+232 //"the temperature at which book-paper catches fire, and burns." close enough
	melting_point = T0C+232 //temperature at which cardboard walls would be destroyed
	stack_origin_tech = list(TECH_MATERIAL = 1)
	door_icon_base = "wood"
	destruction_desc = "crumples"
	pass_stack_colors = TRUE

	worth = 1

	relative_integrity = 0.25
	weight_multiplier = 1
	density = 8 * 0.2
	relative_conductivity = 0.3
	relative_permeability = 0.45
	relative_reactivity = 1.7
	hardness = MATERIAL_RESISTANCE_NONE
	toughness = MATERIAL_RESISTANCE_LOW
	refraction = MATERIAL_RESISTANCE_NONE
	absorption = MATERIAL_RESISTANCE_LOW
	nullification = MATERIAL_RESISTANCE_NONE

/datum/prototype/material/cardboard/generate_recipes()
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
	. += create_stack_recipe_datum(category = "folders", name = "blue folder", product = /obj/item/folder/blue, cost = 1)
	. += create_stack_recipe_datum(category = "folders", name = "grey folder", product = /obj/item/folder, cost = 1)
	. += create_stack_recipe_datum(category = "folders", name = "red folder", product = /obj/item/folder/red, cost = 1)
	. += create_stack_recipe_datum(category = "folders", name = "white folder", product = /obj/item/folder/white, cost = 1)
	. += create_stack_recipe_datum(category = "folders", name = "yellow folder", product = /obj/item/folder/yellow, cost = 1)
