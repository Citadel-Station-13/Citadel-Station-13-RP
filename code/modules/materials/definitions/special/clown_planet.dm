/datum/material/bananium
	id = MAT_BANANIUM
	name = "bananium"
	stack_type = /obj/item/stack/material/bananium
	integrity = 200
	icon_colour = "#fff127"
	explosion_resistance = 25
	hardness = 5 //pretty sure something rubbery isn't that sharp
	weight = 30 // potent blunt weapons.
	opacity = 0.8
	protectiveness = 50 // boing.
	reflectivity = 0.2 // boing.
	negation = 5 // boing.
	conductive = 0 // described as rubbery and a good insulator
	conductivity = 0
	stack_origin_tech = list(TECH_MATERIAL = 5, TECH_ILLEGAL = 3)
	radiation_resistance = 20 //not as good as lead but still pretty good
	tgui_icon_key = "bananium"

/datum/material/bananium/generate_recipes()
	. = ..()
	. += create_stack_recipe_datum(category = "statues", name = "bananium statue", product = /obj/structure/statue/bananium, cost = 10, time = 2 SECONDS)
	. += create_stack_recipe_datum(category = "statues", name = "clown statue", product = /obj/structure/statue/bananium/clown, cost = 10, time = 2 SECONDS)
	. += create_stack_recipe_datum(name = "bananium floor tiles", cost = 1, product = /obj/item/stack/tile/bananium, amount = 4)

/datum/material/silencium
	id = MAT_SILENCIUM
	name = "silencium"
	stack_type = /obj/item/stack/material/silencium
	integrity = 400
	melting_point = 12000 //described as a good heatsink
	icon_colour = "#d3d3d3"
	explosion_resistance = 10 //described as brittle but probably not like glass
	hardness = 100 //sharp as durasteel
	weight = 20
	protectiveness = 55 // described as dense and sturdy
	conductivity = 30 //heatsink
	stack_origin_tech = list(TECH_MATERIAL = 7, TECH_ILLEGAL = 1)
	radiation_resistance = 15
	tgui_icon_key = "silencium"

/datum/material/silencium/generate_recipes()
	. = ..()
	. += create_stack_recipe_datum(name = "silencium floor tiles", cost = 1, product = /obj/item/stack/tile/silencium, amount = 4)
