/datum/material/plasteel
	id = "plasteel"
	name = "plasteel"
	stack_type = /obj/item/stack/material/plasteel
	melting_point = 6000
	icon_base = 'icons/turf/walls/metal_wall.dmi'
	icon_reinf = 'icons/turf/walls/solid_wall_reinforced.dmi'
	icon_colour = "#777777"
	explosion_resistance = 25
	// great reinforcing material, shite conductor
	relative_conductivity = 0.5
	stack_origin_tech = list(TECH_MATERIAL = 2)
	composite_material = list(MAT_STEEL = SHEET_MATERIAL_AMOUNT, MAT_PLATINUM = SHEET_MATERIAL_AMOUNT) //todo
	table_icon_base = "metal"
	tgui_icon_key = "plasteel"

	relative_integrity = 1.5
	relative_weight = 1
	relative_density = 1.75
	relative_conductivity = 0.1
	relative_permeability = 0
	relative_reactivity = 0.05
	regex_this_hardness = MATERIAL_RESISTANCE_HIGH
	toughness = MATERIAL_RESISTANCE_HIGH
	refraction = MATERIAL_RESISTANCE_LOW
	absorption = MATERIAL_RESISTANCE_HIGH
	nullification = MATERIAL_RESISTANCE_NONE

/datum/material/plasteel/hull
	id = "plasteel_hull"
	name = MAT_PLASTEELHULL
	stack_type = /obj/item/stack/material/plasteel/hull
	relative_integrity = 2.5
	icon_colour = "#777788"
	explosion_resistance = 40

/datum/material/plasteel/hull/place_sheet(var/turf/target) //Deconstructed into normal plasteel sheets.
	new /obj/item/stack/material/plasteel(target)
