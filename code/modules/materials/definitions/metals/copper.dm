/datum/prototype/material/copper
	id = MAT_COPPER
	name = "copper"
	icon_colour = "#b45c13"
	stack_type = /obj/item/stack/material/copper
	tgui_icon_key = "copper"

	worth = 3.5

	relative_integrity = 0.8
	density = 8 * 0.9
	relative_conductivity = 0.9
	relative_reactivity = 1.1
	relative_permeability = 0
	hardness = MATERIAL_RESISTANCE_LOW
	toughness = MATERIAL_RESISTANCE_LOW
	refraction = MATERIAL_RESISTANCE_NONE
	absorption = MATERIAL_RESISTANCE_HIGH
	nullification = MATERIAL_RESISTANCE_NONE

	material_constraints = MATERIAL_CONSTRAINT_RIGID | MATERIAL_CONSTRAINT_CONDUCTIVE
