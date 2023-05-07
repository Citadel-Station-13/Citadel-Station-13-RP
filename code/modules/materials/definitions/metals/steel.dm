/datum/material/steel
	id = "steel"
	name = MAT_STEEL
	stack_type = /obj/item/stack/material/steel
	integrity = 150
	conductivity = 11 // Assuming this is carbon steel, it would actually be slightly less conductive than iron, but lets ignore that.
	protectiveness = 10 // 33%
	icon_base = 'icons/turf/walls/solid.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_solid.dmi'
	icon_colour = "#666666"
	table_icon_base = "metal"

/datum/material/steel/hull
	id = "steel_hull"
	name = MAT_STEELHULL
	stack_type = /obj/item/stack/material/steel/hull
	integrity = 250
	explosion_resistance = 10
	icon_base = 'icons/turf/walls/hull.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_mesh.dmi'
	icon_colour = "#666677"

/datum/material/steel/hull/place_sheet(var/turf/target) //Deconstructed into normal steel sheets.
	new /obj/item/stack/material/steel(target)

/datum/material/steel/holographic
	id = "steel_holo"
	name = "holo" + MAT_STEEL
	display_name = "steel"
	stack_type = null
	shard_type = SHARD_NONE
