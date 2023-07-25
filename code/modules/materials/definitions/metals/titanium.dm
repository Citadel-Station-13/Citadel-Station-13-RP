/datum/material/plasteel/titanium
	id = "titanium"
	name = MAT_TITANIUM
	stack_type = /obj/item/stack/material/titanium
	conductivity = 2.38
	icon_base = 'icons/turf/walls/metal_wall.dmi'
	icon_reinf = 'icons/turf/walls/solid_wall_reinforced.dmi'
	door_icon_base = "metal"
	icon_colour = "#D1E6E3"
	table_icon_base = "metal"
	tgui_icon_key = "titanium"

	relative_integrity = 1
	relative_density = 0.5
	relative_conductivity = 1.2
	regex_this_hardness = MATERIAL_RESISTANCE_HIGH
	toughness = MATERIAL_RESISTANCE_HIGH
	refraction = MATERIAL_RESISTANCE_NONE
	absorption = MATERIAL_RESISTANCE_LOW
	nullification = MATERIAL_RESISTANCE_NONE

/datum/material/plasteel/titanium/hull
	id = "titanium_hull"
	name = MAT_TITANIUMHULL
	stack_type = null
	melting_point = 6000
	icon_colour = "#777777"
	explosion_resistance = 25
	conductivity = 13 // For the purposes of balance.
	stack_origin_tech = list(TECH_MATERIAL = 2)
	composite_material = list(MAT_STEEL = SHEET_MATERIAL_AMOUNT, MAT_PLATINUM = SHEET_MATERIAL_AMOUNT) //todo
	table_icon_base = "metal"

	relative_integrity = 2
