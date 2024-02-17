/datum/material/plasteel/titanium
	id = MAT_TITANIUM
	name = MAT_TITANIUM
	stack_type = /obj/item/stack/material/titanium
	door_icon_base = "metal"
	icon_colour = "#D1E6E3"
	table_icon_base = "metal"
	tgui_icon_key = "titanium"
	icon_base = 'icons/turf/walls/metal/wall.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_metal.dmi'
	wall_stripe_icon = null

	relative_integrity = 1
	density = 8 * 0.5
	relative_conductivity = 1.27
	hardness = MATERIAL_RESISTANCE_HIGH
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
	stack_origin_tech = list(TECH_MATERIAL = 2)
	composite_material = list(MAT_STEEL = SHEET_MATERIAL_AMOUNT, MAT_PLATINUM = SHEET_MATERIAL_AMOUNT) //todo
	table_icon_base = "metal"

	relative_integrity = 2
