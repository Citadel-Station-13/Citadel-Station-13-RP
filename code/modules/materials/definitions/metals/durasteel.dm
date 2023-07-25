/datum/material/durasteel
	id = "durasteel"
	name = "durasteel"
	stack_type = /obj/item/stack/material/durasteel
	melting_point = 7000
	icon_base = 'icons/turf/walls/metal_wall.dmi'
	icon_reinf = 'icons/turf/walls/solid_wall_reinforced.dmi'
	icon_colour = "#6EA7BE"
	explosion_resistance = 75
	stack_origin_tech = list(TECH_MATERIAL = 8)
	composite_material = list(MAT_PLASTEEL = SHEET_MATERIAL_AMOUNT, MAT_DIAMOND = SHEET_MATERIAL_AMOUNT) //shrug
	table_icon_base = "metal"
	tgui_icon_key = "durasteel"

	relative_integrity = 2
	relative_density = 3
	relative_conductivity = 0.3
	relative_permeability = 0
	relative_reactivity = 0.5
	regex_this_hardness = MATERIAL_RESISTANCE_HIGH
	toughness = MATERIAL_RESISTANCE_HIGH
	refraction = MATERIAL_RESISTANCE_MODERATE
	absorption = MATERIAL_RESISTANCE_HIGH
	nullification = MATERIAL_RESISTANCE_LOW

/datum/material/durasteel/hull //The 'Hardball' of starship hulls.
	id = "durasteel_hull"
	name = MAT_DURASTEELHULL
	icon_colour = "#45829a"
	explosion_resistance = 90
	relative_integrity = 2.5

/datum/material/durasteel/hull/place_sheet(var/turf/target) //Deconstructed into normal durasteel sheets.
	new /obj/item/stack/material/durasteel(target)
