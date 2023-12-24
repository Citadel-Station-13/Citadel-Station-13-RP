/obj/item/reagent_containers/food_holder
	name = "cooking pot"
	desc = "A debug cooking container. For making sphagetti, and other various pasta-based dishes."

	//is this it? yeah, it it is


/obj/item/reagent_containers/food_holder/proc/tick_heat(var/time_cooked, var/heat_level)
	for(var/obj/item/reagent_containers/food/snacks/ingredient/cooking_ingredient in contents)
		switch(heat_level)
			if(HEAT_LOW)
				cooking_ingredient.accumulated_time_cooked += cooking_ingredient.cooktime_mult_low * time_cooked
			if(HEAT_MID)
				cooking_ingredient.accumulated_time_cooked += cooking_ingredient.cooktime_mult_mid * time_cooked
			if(HEAT_HIGH)
				cooking_ingredient.accumulated_time_cooked += cooking_ingredient.cooktime_mult_high * time_cooked
		cooking_ingredient.process_cooked() //handles all the cooking stuff actually
