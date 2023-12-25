/obj/item/reagent_containers/food_holder
	name = "cooking pot"
	desc = "A debug cooking container. For making sphagetti, and other various pasta-based dishes."

	//is this it? yeah, it it is


/obj/item/reagent_containers/food_holder/proc/tick_heat(var/time_cooked, var/heat_level, var/cook_method)
	for(var/obj/item/reagent_containers/food/snacks/ingredient/cooking_ingredient in contents)
		cooking_ingredient.process_cooked(time_cooked, heat_level, cook_method) //handles all the cooking stuff actually
