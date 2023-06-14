/datum/material/solid/metal/gold
	id = "gold"
	name = "gold"
	stack_type = /obj/item/stack/material/gold
	icon_colour = "#EDD12F"
	weight = 24
	hardness = 40
	conductivity = 41
	stack_origin_tech = list(TECH_MATERIAL = 4)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	ore_type_value = ORE_PRECIOUS

/datum/material/solid/metal/gold/bronze //placeholder for ashtrays
	id = "bronze"
	name = "bronze"
	icon_colour = "#EDD12F"

/datum/material/solid/metal/silver
	id = "silver"
	name = "silver"
	stack_type = /obj/item/stack/material/silver
	icon_colour = "#D1E6E3"
	weight = 22
	hardness = 50
	conductivity = 63
	stack_origin_tech = list(TECH_MATERIAL = 3)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	ore_type_value = ORE_PRECIOUS

/datum/material/solid/metal/steel
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

/datum/material/solid/metal/steel/hull
	id = "steel_hull"
	name = MAT_STEELHULL
	stack_type = /obj/item/stack/material/steel/hull
	integrity = 250
	explosion_resistance = 10
	icon_base = 'icons/turf/walls/hull.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_mesh.dmi'
	icon_colour = "#666677"

/datum/material/solid/metal/steel/hull/place_sheet(var/turf/target) //Deconstructed into normal steel sheets.
	new /obj/item/stack/material/steel(target)

/datum/material/solid/metal/steel/holographic
	id = "steel_holo"
	name = "holo" + MAT_STEEL
	display_name = "steel"
	stack_type = null
	shard_type = SHARD_NONE

/datum/material/solid/metal/plasteel
	id = "plasteel"
	name = "plasteel"
	stack_type = /obj/item/stack/material/plasteel
	integrity = 400
	melting_point = 6000
	icon_base = 'icons/turf/walls/solid.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_solid.dmi'
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

/datum/material/solid/metal/plasteel/hull
	id = "plasteel_hull"
	name = MAT_PLASTEELHULL
	stack_type = /obj/item/stack/material/plasteel/hull
	integrity = 600
	icon_base = 'icons/turf/walls/hull.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_mesh.dmi'
	icon_colour = "#777788"
	explosion_resistance = 40

/datum/material/solid/metal/plasteel/hull/place_sheet(var/turf/target) //Deconstructed into normal plasteel sheets.
	new /obj/item/stack/material/plasteel(target)

// Very rare alloy that is reflective, should be used sparingly.
/datum/material/solid/metal/durasteel
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

/datum/material/solid/metal/durasteel/hull //The 'Hardball' of starship hulls.
	id = "durasteel_hull"
	name = MAT_DURASTEELHULL
	icon_base = 'icons/turf/walls/hull.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_mesh.dmi'
	icon_colour = "#45829a"
	explosion_resistance = 90
	reflectivity = 0.9

/datum/material/solid/metal/durasteel/hull/place_sheet(var/turf/target) //Deconstructed into normal durasteel sheets.
	new /obj/item/stack/material/durasteel(target)

/datum/material/solid/metal/plasteel/titanium
	id = "titanium"
	name = MAT_TITANIUM
	stack_type = /obj/item/stack/material/titanium
	conductivity = 2.38
	icon_base = 'icons/turf/walls/metal.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_metal.dmi'
	door_icon_base = "metal"
	icon_colour = "#D1E6E3"
	table_icon_base = "metal"

/datum/material/solid/metal/plasteel/titanium/hull
	id = "titanium_hull"
	name = MAT_TITANIUMHULL
	stack_type = null
	icon_base = 'icons/turf/walls/hull.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_mesh.dmi'

/datum/material/solid/metal/osmium
	name = "osmium"
	id = "osmium"
	stack_type = /obj/item/stack/material/osmium
	icon_colour = "#9999FF"
	stack_origin_tech = list(TECH_MATERIAL = 5)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	conductivity = 100
	ore_type_value = ORE_EXOTIC

/datum/material/solid/metal/platinum
	name = "platinum"
	id = "platinum"
	stack_type = /obj/item/stack/material/platinum
	icon_colour = "#9999FF"
	weight = 27
	conductivity = 9.43
	stack_origin_tech = list(TECH_MATERIAL = 2)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	ore_type_value = ORE_PRECIOUS

/datum/material/solid/metal/iron
	name = "iron"
	id = "iron"
	stack_type = /obj/item/stack/material/iron
	icon_colour = "#5C5454"
	weight = 22
	conductivity = 10
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	ore_type_value = ORE_SURFACE

/datum/material/solid/metal/lead
	name = MAT_LEAD
	id = "lead"
	stack_type = /obj/item/stack/material/lead
	icon_colour = "#273956"
	weight = 23 // Lead is a bit more dense than silver IRL, and silver has 22 ingame.
	conductivity = 10
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	radiation_resistance = 25 // Lead is Special and so gets to block more radiation than it normally would with just weight, totalling in 48 protection.
	ore_type_value = ORE_SURFACE

/datum/material/solid/metal/bananium
	id = "bananium"
	name = "bananium"
	stack_type = /obj/item/stack/material/bananium
	integrity = 150
	conductivity = 0 // Weird rubber metal.
	protectiveness = 10 // 33%
	icon_colour = "#d6c100"

/datum/material/solid/metal/brass
	id = "brass"
	name = "brass"
	icon_colour = "#CAC955"
	integrity = 150
	stack_type = /obj/item/stack/material/brass

/datum/material/solid/metal/copper
	id = "copper"
	name = "copper"
	icon_colour = "#b45c13"
	weight = 15
	hardness = 30
	conductivity = 35
	stack_type = /obj/item/stack/material/copper
	ore_type_value = ORE_SURFACE

/datum/material/solid/metal/uranium
	id = "uranium"
	name = "uranium"
	stack_type = /obj/item/stack/material/uranium
	radioactivity = RAD_INTENSITY_MAT_URANIUM
	icon_base = 'icons/turf/walls/stone.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_stone.dmi'
	icon_reinf_directionals = TRUE
	icon_colour = "#007A00"
	weight = 22
	stack_origin_tech = list(TECH_MATERIAL = 5)
	door_icon_base = "stone"
	ore_type_value = ORE_NUCLEAR
