/datum/material/hydrogen
	abstract_type = /datum/material/hydrogen

	relative_integrity = 0.2
	relative_density = 0.2
	relative_conductivity = 5
	relative_permeability = 0.7
	relative_reactivity = 3
	regex_this_hardness = MATERIAL_RESISTANCE_LOW
	toughness = MATERIAL_RESISTANCE_LOW
	refraction = MATERIAL_RESISTANCE_LOW
	absorption = MATERIAL_RESISTANCE_LOW
	nullification = MATERIAL_RESISTANCE_HIGH

/datum/material/hydrogen/mhydrogen
	name = "mhydrogen"
	id = "mhydrogen"
	stack_type = /obj/item/stack/material/mhydrogen
	icon_colour = "#E6C5DE"
	stack_origin_tech = list(TECH_MATERIAL = 6, TECH_POWER = 6, TECH_MAGNET = 5)
	is_fusion_fuel = 1
	tgui_icon_key = "mhydrogen"

/datum/material/hydrogen/tritium
	name = "tritium"
	id = "tritium"
	stack_type = /obj/item/stack/material/tritium
	icon_colour = "#777777"
	stack_origin_tech = list(TECH_MATERIAL = 5)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	is_fusion_fuel = 1
	tgui_icon_key = "ingots"

/datum/material/hydrogen/deuterium
	name = "deuterium"
	id = "deuterium"
	stack_type = /obj/item/stack/material/deuterium
	icon_colour = "#999999"
	stack_origin_tech = list(TECH_MATERIAL = 3)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	is_fusion_fuel = 1
	tgui_icon_key = "ingots"
