/datum/prototype/material/brass
	id = "brass"
	name = "brass"
	icon_colour = "#CAC955"
	stack_type = /obj/item/stack/material/brass
	tgui_icon_key = "brass"

	relative_integrity = 1.3
	hardness = MATERIAL_RESISTANCE_MODERATE
	toughness = MATERIAL_RESISTANCE_MODERATE
	refraction = MATERIAL_RESISTANCE_NONE
	absorption = MATERIAL_RESISTANCE_MODERATE
	nullification = MATERIAL_RESISTANCE_NONE
	density = 8 * 0.9
	relative_conductivity = 0.8
	relative_reactivity = 0.5
	relative_permeability = 0

	worth = 7.5

	material_constraints = MATERIAL_CONSTRAINT_RIGID

/datum/prototype/material/brass/generate_recipes()
	. = ..()
	. += create_stack_recipe_datum(name = "brass floor tiles", product = /obj/item/stack/tile/brass, amount = 4)
