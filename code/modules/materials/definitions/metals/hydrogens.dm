/datum/prototype/material/hydrogen
	abstract_type = /datum/prototype/material/hydrogen

	relative_integrity = 0.2
	density = 8 * 0.2
	relative_conductivity = 5
	relative_permeability = 0.7
	relative_reactivity = 3
	hardness = MATERIAL_RESISTANCE_LOW
	toughness = MATERIAL_RESISTANCE_LOW
	refraction = MATERIAL_RESISTANCE_LOW
	absorption = MATERIAL_RESISTANCE_LOW
	nullification = MATERIAL_RESISTANCE_HIGH


/datum/prototype/material/hydrogen/mhydrogen
	name = "mhydrogen"
	id = MAT_METALHYDROGEN
	stack_type = /obj/item/stack/material/mhydrogen
	icon_colour = "#E6C5DE"
	stack_origin_tech = list(TECH_MATERIAL = 6, TECH_POWER = 6, TECH_MAGNET = 5)
	is_fusion_fuel = 1
	tgui_icon_key = "mhydrogen"
	worth = 50

	material_constraints = MATERIAL_CONSTRAINT_RIGID | MATERIAL_CONSTRAINT_CONDUCTIVE

/datum/prototype/material/hydrogen/tritium
	name = "tritium"
	id = "tritium"
	stack_type = /obj/item/stack/material/tritium
	icon_colour = "#777777"
	stack_origin_tech = list(TECH_MATERIAL = 5)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	is_fusion_fuel = 1
	tgui_icon_key = "ingots"
	worth = 35

/datum/prototype/material/hydrogen/deuterium
	name = "deuterium"
	id = "deuterium"
	stack_type = /obj/item/stack/material/deuterium
	icon_colour = "#999999"
	stack_origin_tech = list(TECH_MATERIAL = 3)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	is_fusion_fuel = 1
	tgui_icon_key = "ingots"
	worth = 22.5
