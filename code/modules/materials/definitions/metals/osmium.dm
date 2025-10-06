/datum/prototype/material/osmium
	name = "osmium"
	id = MAT_OSMIUM
	stack_type = /obj/item/stack/material/osmium
	icon_colour = "#9999FF"
	stack_origin_tech = list(TECH_MATERIAL = 5)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	tgui_icon_key = "ingots"

	worth = 17.5

	relative_integrity = 0.8
	density = 8 * 1.5
	relative_conductivity = 2
	relative_permeability = 0
	relative_reactivity = 0.1
	hardness = MATERIAL_RESISTANCE_MODERATE
	toughness = MATERIAL_RESISTANCE_MODERATE
	refraction = MATERIAL_RESISTANCE_MODERATE
	absorption = MATERIAL_RESISTANCE_LOW
	nullification = MATERIAL_RESISTANCE_LOW

	material_constraints = MATERIAL_CONSTRAINT_RIGID
