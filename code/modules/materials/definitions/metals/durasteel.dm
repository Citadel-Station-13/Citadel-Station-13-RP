/datum/material/durasteel
	id = MAT_DURASTEEL
	name = "durasteel"
	stack_type = /obj/item/stack/material/durasteel
	integrity = 600
	melting_point = 7000
	icon_base = 'icons/turf/walls/metal_wall.dmi'
	icon_reinf = 'icons/turf/walls/solid_wall_reinforced.dmi'
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

/datum/material/durasteel/generate_recipes()
	. = ..()
	. += create_stack_recipe_datum(name = "durasteel floor tiles", product = /obj/item/stack/tile/durasteel, amount = 4)

/datum/material/durasteel/hull //The 'Hardball' of starship hulls.
	id = "durasteel_hull"
	name = MAT_DURASTEELHULL
	icon_colour = "#45829a"
	explosion_resistance = 90
	reflectivity = 0.9

/datum/material/durasteel/hull/place_sheet(var/turf/target) //Deconstructed into normal durasteel sheets.
	new /obj/item/stack/material/durasteel(target)
