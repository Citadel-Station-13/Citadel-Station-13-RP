// fuck this

/datum/material/bananium

/datum/material/bananium/generate_recipes()
	. = ..()
	. += create_stack_recipe_datum(category = "statues", name = "bananium statue", product = /obj/structure/statue/bananium, cost = 10, time = 2 SECONDS)
	. += create_stack_recipe_datum(category = "statues", name = "clown statue", product = /obj/structure/statue/bananium/clown, cost = 10, time = 2 SECONDS)
	. += create_stack_recipe_datum(name = "bananium floor tiles", product = /obj/item/stack/tile/bananium, amount = 4)

/datum/material/silencium

/datum/material/silencium/generate_recipes()
	. = ..()
	. += create_stack_recipe_datum(name = "silencium floor tiles", product = /obj/item/stack/tile/silencium, amount = 4)
