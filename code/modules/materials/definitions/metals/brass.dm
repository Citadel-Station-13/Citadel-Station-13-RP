/datum/material/brass
	id = "brass"
	name = "brass"
	icon_colour = "#CAC955"
	integrity = 150
	stack_type = /obj/item/stack/material/brass
	tgui_icon_key = "brass"

/datum/material/brass/generate_recipes()
	. = ..()
	. += create_stack_recipe_datum(name = "brass floor tiles", product = /obj/item/stack/tile/brass, amount = 4)
