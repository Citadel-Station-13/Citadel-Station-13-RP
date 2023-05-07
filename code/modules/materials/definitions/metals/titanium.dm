/datum/material/plasteel/titanium
	id = "titanium"
	name = MAT_TITANIUM
	stack_type = /obj/item/stack/material/titanium
	conductivity = 2.38
	icon_base = 'icons/turf/walls/metal.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_metal.dmi'
	door_icon_base = "metal"
	icon_colour = "#D1E6E3"
	table_icon_base = "metal"
	tgui_icon_key = "titanium"

/datum/material/plasteel/titanium/hull
	id = "titanium_hull"
	name = MAT_TITANIUMHULL
	stack_type = null
	icon_base = 'icons/turf/walls/hull.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_mesh.dmi'
	integrity = 400
	melting_point = 6000
	icon_colour = "#777777"
	explosion_resistance = 25
	hardness = 80
	weight = 23
	protectiveness = 20 // 50%
	conductivity = 13 // For the purposes of balance.
	stack_origin_tech = list(TECH_MATERIAL = 2)
	composite_material = list(MAT_STEEL = SHEET_MATERIAL_AMOUNT, MAT_PLATINUM = SHEET_MATERIAL_AMOUNT) //todo
	radiation_resistance = 14
	table_icon_base = "metal"
