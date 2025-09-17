/datum/prototype/material/plasteel
	id = MAT_PLASTEEL
	name = "plasteel"
	stack_type = /obj/item/stack/material/plasteel
	melting_point = 6000
	icon_base = 'icons/turf/walls/metal_wall.dmi'
	icon_reinf = 'icons/turf/walls/solid_wall_reinforced.dmi'
	icon_colour = "#777777"
	explosion_resistance = 25
	// great reinforcing material, shite conductor
	relative_conductivity = 0.5
	stack_origin_tech = list(TECH_MATERIAL = 2)
	composite_material = list(MAT_STEEL = SHEET_MATERIAL_AMOUNT, MAT_PLATINUM = SHEET_MATERIAL_AMOUNT) //todo
	table_icon_base = "metal"
	tgui_icon_key = "plasteel"

	worth = 17

	relative_integrity = 1.5
	weight_multiplier = 1
	density = 8 * 1.75
	relative_conductivity = 0.1
	relative_permeability = 0
	relative_reactivity = 0.05
	hardness = MATERIAL_RESISTANCE_ABOVE_MODERATE(0.75)
	toughness = MATERIAL_RESISTANCE_HIGH
	refraction = MATERIAL_RESISTANCE_ABOVE_LOW(0.5)
	absorption = MATERIAL_RESISTANCE_ABOVE_MODERATE(0.75)
	nullification = MATERIAL_RESISTANCE_ABOVE_NONE(0.5)

	material_constraints = MATERIAL_CONSTRAINT_RIGID

/datum/prototype/material/plasteel/generate_recipes()
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

/datum/prototype/material/plasteel/hull
	id = "plasteel_hull"
	name = MAT_PLASTEELHULL
	stack_type = /obj/item/stack/material/plasteel/hull
	relative_integrity = 2.5
	icon_colour = "#777788"
	explosion_resistance = 40

/datum/prototype/material/plasteel/hull/place_sheet(var/turf/target) //Deconstructed into normal plasteel sheets.
	new /obj/item/stack/material/plasteel(target)
