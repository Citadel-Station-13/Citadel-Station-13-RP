/datum/prototype/material/silver
	id = MAT_SILVER
	name = "silver"
	stack_type = /obj/item/stack/material/silver
	icon_colour = "#D1E6E3"
	stack_origin_tech = list(TECH_MATERIAL = 3)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	tgui_icon_key = "silver"

	worth = 12.5

	relative_integrity = 0.7
	weight_multiplier = 1
	density = 8 * 1.4
	relative_conductivity = 2.5
	relative_permeability = 0
	relative_reactivity = 0.05
	hardness = MATERIAL_RESISTANCE_LOW
	toughness = MATERIAL_RESISTANCE_LOW
	refraction = MATERIAL_RESISTANCE_MODERATE
	absorption = MATERIAL_RESISTANCE_LOW
	nullification = MATERIAL_RESISTANCE_MODERATE

	material_constraints = MATERIAL_CONSTRAINT_RIGID

/datum/prototype/material/silver/generate_recipes()
	. = ..()
	. += create_stack_recipe_datum(category = "statues", name = "head of security statue", product = /obj/structure/statue/silver/hos, cost = 10, time = 2 SECONDS)
	. += create_stack_recipe_datum(category = "statues", name = "medical doctor statue", product = /obj/structure/statue/silver/md, cost = 10, time = 2 SECONDS)
	. += create_stack_recipe_datum(category = "statues", name = "janitor statue", product = /obj/structure/statue/silver/janitor, cost = 10, time = 2 SECONDS)
	. += create_stack_recipe_datum(category = "statues", name = "security statue", product = /obj/structure/statue/silver/sec, cost = 10, time = 2 SECONDS)
	. += create_stack_recipe_datum(category = "statues", name = "secborg statue", product = /obj/structure/statue/silver/secborg, cost = 10, time = 2 SECONDS)
	. += create_stack_recipe_datum(category = "statues", name = "medborg statue", product = /obj/structure/statue/silver/medborg, cost = 10, time = 2 SECONDS)
	. += create_stack_recipe_datum(name = "silver floor tiles", product = /obj/item/stack/tile/silver, amount = 4)
