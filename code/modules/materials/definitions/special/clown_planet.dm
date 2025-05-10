/datum/prototype/material/bananium
	id = MAT_BANANIUM
	name = "bananium"
	stack_type = /obj/item/stack/material/bananium
	icon_colour = "#fff127"
	explosion_resistance = 25
	opacity = 0.8
	negation = 5 // boing.
	stack_origin_tech = list(TECH_MATERIAL = 5, TECH_ILLEGAL = 3)
	tgui_icon_key = "bananium"

	relative_integrity = 2
	density = 8 * 3
	relative_conductivity = 0.3
	relative_permeability = 0
	relative_reactivity = 0.5
	hardness = MATERIAL_RESISTANCE_HIGH
	toughness = MATERIAL_RESISTANCE_HIGH
	refraction = MATERIAL_RESISTANCE_MODERATE
	absorption = MATERIAL_RESISTANCE_HIGH
	nullification = MATERIAL_RESISTANCE_LOW

	material_constraints = MATERIAL_CONSTRAINT_RIGID

/datum/prototype/material/bananium/generate_recipes()
	. = ..()
	. += create_stack_recipe_datum(category = "statues", name = "bananium statue", product = /obj/structure/statue/bananium, cost = 10, time = 2 SECONDS)
	. += create_stack_recipe_datum(category = "statues", name = "clown statue", product = /obj/structure/statue/bananium/clown, cost = 10, time = 2 SECONDS)
	. += create_stack_recipe_datum(name = "bananium floor tiles", cost = 1, product = /obj/item/stack/tile/bananium, amount = 4)

/datum/prototype/material/silencium
	id = MAT_SILENCIUM
	name = "silencium"
	stack_type = /obj/item/stack/material/silencium
	melting_point = 12000 //described as a good heatsink
	icon_colour = "#d3d3d3"
	explosion_resistance = 10 //described as brittle but probably not like glass
	stack_origin_tech = list(TECH_MATERIAL = 7, TECH_ILLEGAL = 1)
	tgui_icon_key = "silencium"

	relative_integrity = 2
	density = 8 * 3
	relative_conductivity = 0.3
	relative_permeability = 0
	relative_reactivity = 0.5
	hardness = MATERIAL_RESISTANCE_HIGH
	toughness = MATERIAL_RESISTANCE_HIGH
	refraction = MATERIAL_RESISTANCE_MODERATE
	absorption = MATERIAL_RESISTANCE_HIGH
	nullification = MATERIAL_RESISTANCE_LOW

	material_constraints = MATERIAL_CONSTRAINT_RIGID

/datum/prototype/material/silencium/generate_recipes()
	. = ..()
	. += create_stack_recipe_datum(name = "silencium floor tiles", cost = 1, product = /obj/item/stack/tile/silencium, amount = 4)
