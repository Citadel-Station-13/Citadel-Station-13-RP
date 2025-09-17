/datum/prototype/material/platinum
	name = "platinum"
	id = MAT_PLATINUM
	stack_type = /obj/item/stack/material/platinum
	icon_colour = "#9999FF"
	stack_origin_tech = list(TECH_MATERIAL = 2)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	tgui_icon_key = "ingots"

	worth = 25

	relative_integrity = 0.8
	weight_multiplier = 1
	density = 8 * 1.75
	relative_conductivity = 1.5
	relative_permeability = 0
	relative_reactivity = 0.05
	hardness = MATERIAL_RESISTANCE_LOW
	toughness = MATERIAL_RESISTANCE_MODERATE
	refraction = MATERIAL_RESISTANCE_MODERATE
	absorption = MATERIAL_RESISTANCE_LOW
	nullification = MATERIAL_RESISTANCE_HIGH

	material_constraints = MATERIAL_CONSTRAINT_RIGID
