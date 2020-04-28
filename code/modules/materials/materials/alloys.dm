/datum/material/steel
	id = /datum/material/steel
	stack_type = /obj/item/stack/material/steel
	integrity = 150
	conductivity = 11 // Assuming this is carbon steel, it would actually be slightly less conductive than iron, but lets ignore that.
	protectiveness = 10 // 33%
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = "#666666"

/datum/material/steel/hull
	id = /datum/material/steelHULL
	stack_type = /obj/item/stack/material/steel/hull
	integrity = 250
	explosion_resistance = 10
	icon_base = "hull"
	icon_reinf = "reinf_mesh"
	icon_colour = "#666677"

/datum/material/steel/hull/place_sheet(var/turf/target) //Deconstructed into normal steel sheets.
	new /obj/item/stack/material/steel(target)

/datum/material/steel/holographic
	id = "holo" + /datum/material/steel
	display_name = /datum/material/steel
	stack_type = null
	shard_type = SHARD_NONE

/datum/material/plasteel
	id = "plasteel"
	stack_type = /obj/item/stack/material/plasteel
	integrity = 400
	melting_point = 6000
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = "#777777"
	explosion_resistance = 25
	hardness = 80
	weight = 23
	protectiveness = 20 // 50%
	conductivity = 13 // For the purposes of balance.
	stack_origin_tech = list(TECH_MATERIAL = 2)
	composite_material = list(/datum/material/steel = SHEET_MATERIAL_AMOUNT, "platinum" = SHEET_MATERIAL_AMOUNT) //todo
	radiation_resistance = 14

/datum/material/plasteel/hull
	id = MAT_PLASTEELHULL
	stack_type = /obj/item/stack/material/plasteel/hull
	integrity = 600
	icon_base = "hull"
	icon_reinf = "reinf_mesh"
	icon_colour = "#777788"
	explosion_resistance = 40

/datum/material/plasteel/hull/place_sheet(var/turf/target) //Deconstructed into normal plasteel sheets.
	new /obj/item/stack/material/plasteel(target)

// Very rare alloy that is reflective, should be used sparingly.
/datum/material/durasteel
	id = "durasteel"
	stack_type = /obj/item/stack/material/durasteel
	integrity = 600
	melting_point = 7000
	icon_base = "metal"
	icon_reinf = "reinf_metal"
	icon_colour = "#6EA7BE"
	explosion_resistance = 75
	hardness = 100
	weight = 28
	protectiveness = 60 // 75%
	reflectivity = 0.7 // Not a perfect mirror, but close.
	stack_origin_tech = list(TECH_MATERIAL = 8)
	composite_material = list("plasteel" = SHEET_MATERIAL_AMOUNT, "diamond" = SHEET_MATERIAL_AMOUNT) //shrug

/datum/material/durasteel/hull //The 'Hardball' of starship hulls.
	id = MAT_DURASTEELHULL
	icon_base = "hull"
	icon_reinf = "reinf_mesh"
	icon_colour = "#45829a"
	explosion_resistance = 90
	reflectivity = 0.9

/datum/material/durasteel/hull/place_sheet(var/turf/target) //Deconstructed into normal durasteel sheets.
	new /obj/item/stack/material/durasteel(target)
