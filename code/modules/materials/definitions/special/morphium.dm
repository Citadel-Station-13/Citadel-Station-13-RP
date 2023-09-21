/datum/material/morphium
	name = MAT_MORPHIUM
	id = "morphium"
	stack_type = /obj/item/stack/material/morphium
	icon_base = 'icons/turf/walls/metal.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_metal.dmi'
	door_icon_base = "metal"
	icon_colour = "#37115A"
	protectiveness = 60
	integrity = 900
	conductive = 0
	conductivity = 1.5
	hardness = 80
	shard_type = SHARD_SHARD
	weight = 30
	negation = 25
	explosion_resistance = 85
	reflectivity = 0.2
	radiation_resistance = 10
	stack_origin_tech = list(TECH_MATERIAL = 8, TECH_MAGNET = 8, TECH_PHORON = 6, TECH_BLUESPACE = 6, TECH_ARCANE = 3)

/datum/material/morphium/hull
	name = MAT_MORPHIUMHULL
	id = "morphium_hull"
	stack_type = /obj/item/stack/material/morphium/hull
	icon_base = 'icons/turf/walls/hull.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_mesh.dmi'
