// todo: this is just a placeholder
/datum/prototype/material/bronze
	id = "bronze"
	name = "bronze"
	icon_colour = "#EDD12F"
	stack_type = /obj/item/stack/material/gold
	stack_origin_tech = list(TECH_MATERIAL = 4)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	tgui_icon_key = "bronze"

	relative_integrity = 0.8
	density = 8 * 0.9
	relative_conductivity = 0.7
	relative_reactivity = 1
	relative_permeability = 0
	hardness = MATERIAL_RESISTANCE_MODERATE
	toughness = MATERIAL_RESISTANCE_MODERATE
	refraction = MATERIAL_RESISTANCE_NONE
	absorption = MATERIAL_RESISTANCE_LOW
	nullification = MATERIAL_RESISTANCE_NONE

	worth = 7.5

	material_constraints = MATERIAL_CONSTRAINT_RIGID
