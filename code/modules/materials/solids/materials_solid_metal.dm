/datum/material/solid/metal
	abstract_type = /datum/material/solid/metal
	// default_solid_form = /obj/item/stack/material/ingot

	name = null
	// reflectiveness = MAT_VALUE_SHINY
	// removed_by_welder = TRUE
	// wall_name = "bulkhead"
	// weight = MAT_VALUE_HEAVY
	// hardness = MAT_VALUE_RIGID
	// wall_support_value = MAT_VALUE_HEAVY
	// wall_flags = PAINT_PAINTABLE
	wall_icon = 'icons/turf/walls/metal.dmi'
	wall_reinf_icon = 'icons/turf/walls/reinf_metal.dmi'
	table_icon = 'icons/obj/structures/tables/metal.dmi'
	// wall_blend_icons = list(
	// 	'icons/turf/walls/wood.dmi' = TRUE,
	// 	'icons/turf/walls/stone.dmi' = TRUE,
	// )
	door_icon_base = "metal"


/datum/material/solid/metal/steel
	name = MAT_STEEL
	stack_type = /obj/item/stack/material/steel
	integrity = 150
	conductivity = 11 // Assuming this is carbon steel, it would actually be slightly less conductive than iron, but lets ignore that.
	protectiveness = 10 // 33%

	wall_icon = 'icons/turf/walls/solid.dmi'
	wall_reinf_icon = 'icons/turf/walls/reinf.dmi'
	table_icon = 'icons/obj/structures/tables/metal.dmi'
	color = "#666666"


/datum/material/solid/metal/steel/hull
	name = MAT_STEELHULL
	stack_type = /obj/item/stack/material/steel/hull
	integrity = 250

	wall_icon = 'icons/turf/walls/hull.dmi'
	wall_reinf_icon = 'icons/turf/walls/reinf_mesh.dmi'
	texture_layer_icon_state = "mesh"
	color = "#666677"

/datum/material/solid/metal/steel/hull/place_sheet(turf/target) //Deconstructed into normal steel sheets.
	new /obj/item/stack/material/steel(target)


/datum/material/solid/metal/steel/holographic
	name = "holo" + MAT_STEEL
	display_name = MAT_STEEL
	stack_type = null
	shard_type = SHARD_NONE


/datum/material/solid/metal/plasteel
	name = "plasteel"
	stack_type = /obj/item/stack/material/plasteel
	integrity = 400
	melting_point = 6000
	hardness = 80
	weight = 23
	protectiveness = 20 // 50%
	conductivity = 13 // For the purposes of balance.
	stack_origin_tech = list(TECH_MATERIAL = 2)
	composite_material = list(MAT_STEEL = SHEET_MATERIAL_AMOUNT, MAT_PLATINUM = SHEET_MATERIAL_AMOUNT) //todo
	radiation_resistance = 14

	wall_icon = 'icons/turf/walls/solid.dmi'
	wall_reinf_icon = 'icons/turf/walls/reinf.dmi'
	table_icon = 'icons/obj/structures/tables/metal.dmi'
	// color = "#777777" using steel's color cause of our current walls. @Zandario
	color = "#666666"


/datum/material/solid/metal/plasteel/hull
	name = MAT_PLASTEELHULL
	stack_type = /obj/item/stack/material/plasteel/hull
	integrity = 600

	wall_icon = 'icons/turf/walls/hull.dmi'
	wall_reinf_icon = 'icons/turf/walls/reinf_mesh.dmi'
	color = "#777788"

/datum/material/solid/metal/plasteel/hull/place_sheet(turf/target) //Deconstructed into normal plasteel sheets.
	new /obj/item/stack/material/plasteel(target)


/datum/material/solid/metal/plasteel/titanium
	name = MAT_TITANIUM
	stack_type = /obj/item/stack/material/titanium
	conductivity = 2.38
	wall_icon = 'icons/turf/walls/metal.dmi'
	door_icon_base = "metal"
	color = "#D1E6E3"
	wall_reinf_icon = 'icons/turf/walls/reinf_metal.dmi'


/datum/material/solid/metal/plasteel/titanium/hull
	name = MAT_TITANIUMHULL
	stack_type = null
	wall_icon = 'icons/turf/walls/hull.dmi'
	wall_reinf_icon = 'icons/turf/walls/reinf_mesh.dmi'


/// Very rare alloy that is reflective, should be used sparingly.
/datum/material/solid/metal/durasteel
	name = "durasteel"
	stack_type = /obj/item/stack/material/durasteel
	integrity = 600
	melting_point = 7000
	wall_icon = 'icons/turf/walls/metal.dmi'
	wall_reinf_icon = 'icons/turf/walls/reinf_metal.dmi'
	color = "#6EA7BE"
	hardness = 100
	weight = 28
	protectiveness = 60 // 75%
	reflectivity = 0.7 // Not a perfect mirror, but close.
	stack_origin_tech = list(TECH_MATERIAL = 8)
	composite_material = list(MAT_PLASTEEL = SHEET_MATERIAL_AMOUNT, MAT_DIAMOND = SHEET_MATERIAL_AMOUNT) //shrug


/datum/material/solid/metal/durasteel/hull //The 'Hardball' of starship hulls.
	name = MAT_DURASTEELHULL
	wall_icon = 'icons/turf/walls/hull.dmi'
	wall_reinf_icon = 'icons/turf/walls/reinf_mesh.dmi'
	color = "#45829a"
	reflectivity = 0.9

/datum/material/solid/metal/durasteel/hull/place_sheet(turf/target) //Deconstructed into normal durasteel sheets.
	new /obj/item/stack/material/durasteel(target)

/datum/material/solid/metal/iron
	name = "iron"
	stack_type = /obj/item/stack/material/iron
	color = "#5C5454"
	weight = 22
	conductivity = 10
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"

/datum/material/solid/metal/lead
	name = MAT_LEAD
	stack_type = /obj/item/stack/material/lead
	color = "#273956"
	weight = 23 // Lead is a bit more dense than silver IRL, and silver has 22 ingame.
	conductivity = 10
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	radiation_resistance = 25 // Lead is Special and so gets to block more radiation than it normally would with just weight, totalling in 48 protection.

/datum/material/solid/metal/gold
	name = MAT_GOLD
	stack_type = /obj/item/stack/material/gold
	color = "#EDD12F"
	weight = 24
	hardness = 40
	conductivity = 41
	stack_origin_tech = list(TECH_MATERIAL = 4)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"

/datum/material/solid/metal/gold/bronze //placeholder for ashtrays
	name = MAT_BRONZE
	color = "#EDD12F"
