/datum/prototype/material/wax
	id = "wax"
	name = "wax"
	stack_type = /obj/item/stack/material/wax
	icon_colour = "#ebe6ac"
	melting_point = T0C+300
	pass_stack_colors = TRUE

	relative_integrity = 0.3
	weight_multiplier = 0.5
	density = 8 * 0.3
	relative_conductivity = 0.1
	relative_permeability = 0.1
	relative_reactivity = 0.8
	hardness = MATERIAL_RESISTANCE_VERY_VULNERABLE
	toughness = MATERIAL_RESISTANCE_VULNERABLE
	refraction = MATERIAL_RESISTANCE_NONE
	absorption = MATERIAL_RESISTANCE_LOW
	nullification = MATERIAL_RESISTANCE_VULNERABLE

/datum/prototype/material/wax/generate_recipes()
	. = ..()
	. += create_stack_recipe_datum(
		name = "candle",
		product = /obj/item/flame/candle,
		cost = 1,
	)
	. += create_stack_recipe_datum(
		name = "wax floor tile",
		product = /obj/item/stack/tile/wax,
		cost = 1,
		amount = 4,
	)
	. += create_stack_recipe_datum(
		name = "honeycomb floor tile",
		product = /obj/item/stack/tile/honeycomb,
		cost = 1,
		amount = 4,
	)
	. += create_stack_recipe_datum(
		name = "wax globule",
		product = /obj/item/ammo_casing/biomatter/wax,
		cost = 1,
	)
	. += create_stack_recipe_datum(
		name = "apidean chair",
		product = /obj/structure/bed/chair/apidean,
		cost = 5,
	)
	. += create_stack_recipe_datum(
		name = "apidean throne",
		product = /obj/structure/bed/chair/apidean_throne,
		cost = 10,
		time = 2 SECONDS,
	)
	. += create_stack_recipe_datum(
		name = "apidean stool",
		product = /obj/structure/bed/chair/apidean_stool,
		cost = 5,
	)
