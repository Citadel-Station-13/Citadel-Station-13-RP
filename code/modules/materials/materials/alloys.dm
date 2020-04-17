// Very rare alloy that is reflective, should be used sparingly.
/datum/material/durasteel
	id = MATERIAL_ID_DURASTEEL
	display_name = "durasteel"
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
	id = MATERIAL_ID_DURASTEEL_HULL
	icon_base = "hull"
	icon_reinf = "reinf_mesh"
	icon_colour = "#45829a"
	explosion_resistance = 90
	reflectivity = 0.9

/datum/material/gold/bronze //placeholder for ashtrays
	id = MATERIAL_ID_BRONZE
	display_name = "bronze"
	icon_colour = "#EDD12F"
