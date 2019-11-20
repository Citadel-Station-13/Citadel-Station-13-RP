/datum/material/gold
	id = MATERIAL_ID_GOLD
	display_name = "gold"
	stack_type = /obj/item/stack/material/gold
	icon_colour = "#EDD12F"
	weight = 24
	hardness = 40
	conductivity = 41
	stack_origin_tech = list(TECH_MATERIAL = 4)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"

/datum/material/gold/bronze //placeholder for ashtrays
	id = MATERIAL_ID_BRONZE
	display_name = "bronze"
	icon_colour = "#EDD12F"

/datum/material/silver
	id = MATERIAL_ID_SILVER
	display_name = "silver"
	stack_type = /obj/item/stack/material/silver
	icon_colour = "#D1E6E3"
	weight = 22
	hardness = 50
	conductivity = 63
	stack_origin_tech = list(TECH_MATERIAL = 3)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"

// Datum definitions follow.
/datum/material/uranium
	id = MATERIAL_ID_URANIUM
	display_name = "uranium"
	stack_type = /obj/item/stack/material/uranium
	radioactivity = 12
	icon_base = "stone"
	icon_reinf = "reinf_stone"
	icon_colour = "#007A00"
	weight = 22
	stack_origin_tech = list(TECH_MATERIAL = 5)
	door_icon_base = "stone"

/datum/material/plasteel/titanium
	id = MATERIAL_ID_TITANIUM
	stack_type = null
	conductivity = 2.38
	icon_base = "metal"
	door_icon_base = "metal"
	icon_colour = "#D1E6E3"
	icon_reinf = "reinf_metal"

/datum/material/plasteel/titanium/hull
	id = MATERIAL_ID_TITANIUM_HULL
	stack_type = null
	icon_base = "hull"
	icon_reinf = "reinf_mesh"

/datum/material/osmium
	id = MATERIAL_ID_OSMIUM
	display_name = "osnium"
	stack_type = /obj/item/stack/material/osmium
	icon_colour = "#9999FF"
	stack_origin_tech = list(TECH_MATERIAL = 5)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"

/datum/material/tritium
	id = MATERIAL_ID_TRITIUM
	display_name = "tritium"
	stack_type = /obj/item/stack/material/tritium
	icon_colour = "#777777"
	stack_origin_tech = list(TECH_MATERIAL = 5)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	is_fusion_fuel = 1

/datum/material/deuterium
	id = MATERIAL_ID_DEUTERIUM
	display_name = "deuterium"
	stack_type = /obj/item/stack/material/deuterium
	icon_colour = "#999999"
	stack_origin_tech = list(TECH_MATERIAL = 3)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	is_fusion_fuel = 1

/datum/material/mhydrogen
	id = MATERIAL_ID_METALLIC_HYDROGEN
	display_name = "metallic hydrogen"
	stack_type = /obj/item/stack/material/mhydrogen
	icon_colour = "#E6C5DE"
	stack_origin_tech = list(TECH_MATERIAL = 6, TECH_POWER = 6, TECH_MAGNET = 5)
	conductivity = 100
	is_fusion_fuel = 1

/datum/material/platinum
	id = MATERIAL_ID_PLATINUM
	display_name = "platnium"
	stack_type = /obj/item/stack/material/platinum
	icon_colour = "#9999FF"
	weight = 27
	conductivity = 9.43
	stack_origin_tech = list(TECH_MATERIAL = 2)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"

/datum/material/iron
	id = MATERIAL_ID_IRON
	display_name = "iron"
	stack_type = /obj/item/stack/material/iron
	icon_colour = "#5C5454"
	weight = 22
	conductivity = 10
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"

/datum/material/lead
	id = MATERIAL_ID_LEAD
	display_name = "lead"
	stack_type = /obj/item/stack/material/lead
	icon_colour = "#273956"
	weight = 23 // Lead is a bit more dense than silver IRL, and silver has 22 ingame.
	conductivity = 10
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	radiation_resistance = 25 // Lead is Special and so gets to block more radiation than it normally would with just weight, totalling in 48 protection.