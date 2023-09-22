/datum/material/plasteel
	id = "plasteel"
	name = "plasteel"
	stack_type = /obj/item/stack/material/plasteel
	integrity = 400
	melting_point = 6000
	icon_base = 'icons/turf/walls/metal_wall.dmi'
	icon_reinf = 'icons/turf/walls/solid_wall_reinforced.dmi'
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
	tgui_icon_key = "plasteel"

/datum/material/plasteel/generate_recipes()
	. = ..()
	. += create_stack_recipe_datum(
		name = "AI core",
		product = /obj/structure/AIcore,
		cost = 4,
		time = 4 SECONDS,
	)
	. += create_stack_recipe_datum(
		name = "crate",
		product = /obj/structure/closet/crate,
		cost = 5,
		time = 3 SECONDS,
	)
	. += create_stack_recipe_datum(
		name = "knife grip",
		product = /obj/item/material/butterflyhandle,
		cost = 3,
		time = 2 SECONDS,
	)
	. += create_stack_recipe_datum(
		name = "dark floor tile",
		product = /obj/item/stack/tile/floor/dark,
		amount = 4,
	)
	. += create_stack_recipe_datum(
		name = "roller bed",
		product = /obj/item/roller,
		cost = 3,
		time = 3 SECONDS,
	)
	. += create_stack_recipe_datum(
		name = "whetstone",
		product = /obj/item/whetstone,
		cost = 2,
		time = 5 SECONDS,
	)
	. += create_stack_recipe_datum(
		name = "reinforced skateboard assembly",
		product = /obj/item/heavy_skateboard_frame,
		cost = 5,
		time = 4 SECONDS,
	)
	. += create_stack_recipe_datum(
		name = "plasteel floor tile",
		product = /obj/item/stack/tile/plasteel,
		cost = 1,
		amount = 4,
	)

/datum/material/plasteel/hull
	id = "plasteel_hull"
	name = MAT_PLASTEELHULL
	stack_type = /obj/item/stack/material/plasteel/hull
	integrity = 600
	icon_colour = "#777788"
	explosion_resistance = 40

/datum/material/plasteel/hull/place_sheet(var/turf/target) //Deconstructed into normal plasteel sheets.
	new /obj/item/stack/material/plasteel(target)
