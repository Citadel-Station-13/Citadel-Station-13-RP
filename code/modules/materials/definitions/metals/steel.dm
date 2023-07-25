/datum/material/steel
	id = "steel"
	name = MAT_STEEL
	stack_type = /obj/item/stack/material/steel
	icon_base = 'icons/turf/walls/metal_wall.dmi'
	icon_reinf = 'icons/turf/walls/solid_wall_reinforced.dmi'
	icon_colour = "#666666"
	table_icon_base = "metal"
	tgui_icon_key = "metal"

	// the true neutral material

	relative_integrity = 1
	relative_density = 1
	relative_conductivity = 1
	relative_permeability = 0
	relative_reactivity = 1
	regex_this_hardness = MATERIAL_RESISTANCE_MODERATE
	toughness = MATERIAL_RESISTANCE_HIGH
	refraction = MATERIAL_RESISTANCE_NONE
	absorption = MATERIAL_RESISTANCE_MODERATE
	nullification = MATERIAL_RESISTANCE_NONE

/datum/material/steel/hull
	id = "steel_hull"
	name = MAT_STEELHULL
	stack_type = /obj/item/stack/material/steel/hull
	relative_integrity = 2
	explosion_resistance = 10
	icon_colour = "#666677"

/datum/material/steel/hull/place_sheet(var/turf/target) //Deconstructed into normal steel sheets.
	new /obj/item/stack/material/steel(target)

/datum/material/steel/holographic
	id = "steel_holo"
	name = "holo" + MAT_STEEL
	display_name = "steel"
	stack_type = null
	shard_type = SHARD_NONE
