/datum/material/wax
	id = "wax"
	name = "wax"
	stack_type = /obj/item/stack/material/wax
	icon_colour = "#ebe6ac"
	melting_point = T0C+300
	weight = 1
	hardness = 20
	integrity = 100
	pass_stack_colors = TRUE

/datum/material/wax/generate_recipes()
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
		product = /obj/item/ammo_casing/organic/wax,
		cost = 1,
	)
	. += create_stack_recipe_datum(
		name = "royal throne",
		product = /obj/structure/bed/chair/apidean,
		cost = 10,
		time = 2 SECONDS,
	)
	. += create_stack_recipe_datum(
		name = "apidean stool",
		product = /obj/structure/bed/chair/apidean_stool,
		cost = 5,
	)
