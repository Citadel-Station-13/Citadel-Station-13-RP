/datum/material/gold
	id = "gold"
	name = "gold"
	stack_type = /obj/item/stack/material/gold
	icon_colour = "#EDD12F"
	weight = 24
	hardness = 40
	conductivity = 41
	stack_origin_tech = list(TECH_MATERIAL = 4)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	tgui_icon_key = "gold"

/datum/material/gold/generate_recipes()
	. = ..()
	. += create_stack_recipe_datum(category = "statues", name = "head of security statue", product = /obj/structure/statue/gold/hos, cost = 10, time = 2 SECONDS)
	. += create_stack_recipe_datum(category = "statues", name = "head of personnel statue", product = /obj/structure/statue/gold/hop, cost = 10, time = 2 SECONDS)
	. += create_stack_recipe_datum(category = "statues", name = "chief medical officer statue", product = /obj/structure/statue/gold/cmo, cost = 10, time = 2 SECONDS)
	. += create_stack_recipe_datum(category = "statues", name = "chief engineer statue", product = /obj/structure/statue/gold/ce, cost = 10, time = 2 SECONDS)
	. += create_stack_recipe_datum(category = "statues", name = "research director statue", product = /obj/structure/statue/gold/rd, cost = 10, time = 2 SECONDS)
	. += create_stack_recipe_datum(name = "gold floor tiles", product = /obj/item/stack/tile/gold, amount = 4)
	. += create_stack_recipe_datum(name = "golden crown", product = /obj/item/clothing/head/crown, cost = 5, time = 3 SECONDS)
