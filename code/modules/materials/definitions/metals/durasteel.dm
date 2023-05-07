/datum/material/durasteel
	id = "durasteel"
	name = "durasteel"
	stack_type = /obj/item/stack/material/durasteel
	integrity = 600
	melting_point = 7000
	icon_base = 'icons/turf/walls/metal.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_metal.dmi'
	icon_colour = "#6EA7BE"
	explosion_resistance = 75
	hardness = 100
	weight = 28
	protectiveness = 60 // 75%
	reflectivity = 0.7 // Not a perfect mirror, but close.
	stack_origin_tech = list(TECH_MATERIAL = 8)
	composite_material = list(MAT_PLASTEEL = SHEET_MATERIAL_AMOUNT, MAT_DIAMOND = SHEET_MATERIAL_AMOUNT) //shrug
	table_icon_base = "metal"
	tgui_icon_key = "durasteel"

/datum/material/durasteel/hull //The 'Hardball' of starship hulls.
	id = "durasteel_hull"
	name = MAT_DURASTEELHULL
	icon_base = 'icons/turf/walls/hull.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_mesh.dmi'
	icon_colour = "#45829a"
	explosion_resistance = 90
	reflectivity = 0.9

/datum/material/durasteel/hull/place_sheet(var/turf/target) //Deconstructed into normal durasteel sheets.
	new /obj/item/stack/material/durasteel(target)
