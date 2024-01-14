/obj/item/reagent_containers/glass/food_holder
	name = "cooking pot"
	desc = "A debug cooking container. For making sphagetti, and other various copypasta-based dishes."
	icon = 'icons/obj/cooking_machines.dmi'
	icon_state = "ovendish"
	atom_flags = OPENCONTAINER

	var/food_name_override

	var/last_cooking_method

	var/cooker_overlay

	//is this it? yeah, it it is
/obj/item/reagent_containers/glass/food_holder/Initialize(mapload)
	. = ..()
	reagents.reagent_holder_flags |= TRANSPARENT
/obj/item/reagent_containers/glass/food_holder/examine(mob/user, dist) //todo: show food inside
	. = ..()
	. += SPAN_NOTICE("<b>Alt-click</b> to remove an ingredient from this.")
	. += SPAN_NOTICE("<b>Alt-click</b> in grab intent to retrieve a serving of food.")
	. += SPAN_NOTICE("It contains:")
	for(var/obj/item/reagent_containers/food/snacks/ingredient/examine_ingredient in contents)
		var/cooked_span = "userdanger"
		switch(examine_ingredient.cookstage)
			if(RAW)
				cooked_span = "rose"
			if(COOKED)
				cooked_span = "boldnicegreen"
			if(OVERCOOKED)
				cooked_span = "yellow"
			if(BURNT)
				cooked_span = "tajaran_signlang"
		. += "<span class='notice'>[icon2html(thing = examine_ingredient, target = user)] The [examine_ingredient.name], which looks </span><span class='[cooked_span]'>[examine_ingredient.cookstage2text()]</span><span class='notice'> and has been cooked for about [examine_ingredient.accumulated_time_cooked / 10] seconds.</span>"

/obj/item/reagent_containers/glass/food_holder/proc/tick_heat(var/time_cooked, var/heat_level, var/cook_method)
	last_cooking_method = cook_method
	for(var/obj/item/reagent_containers/food/snacks/ingredient/cooking_ingredient in contents)
		cooking_ingredient.process_cooked(time_cooked, heat_level, cook_method) //handles all the cooking stuff actually


/obj/item/reagent_containers/glass/food_holder/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/ingredient))
		for(var/obj/item/reagent_containers/food/snacks/ingredient/compare_ingredient in contents)
			if(compare_ingredient.type == I.type)
				try_merge(I, compare_ingredient, user)
		if(!user.attempt_insert_item_for_installation(I, src))
			user.visible_message("<span class='notice'>[user] puts [I] into [src].</span>", "<span class='notice'>You put [I] into [src].</span>")
			return
		return
	else if(istype(I, /obj/item/food_serving))
		generate_serving(I, user)
	return ..()

/obj/item/reagent_containers/glass/food_holder/AltClick(mob/living/user)
	if(user.a_intent == INTENT_GRAB)
		generate_serving(null, user)
		return
	var/list/removables = list()
	var/counter = 0
	for(var/obj/item/reagent_containers/food/snacks/ingredient/I in contents)
		if(counter)
			removables["[I.name] ([counter]) \[[I.cookstage2text()]\]"] = I
			to_chat(user, "Option [I.name] ([counter]) \[[I.cookstage2text()]\] = [I]")
		else
			removables["[I.name] \[[I.cookstage2text()]\]"] = I
			to_chat(user, "Option [I.name] \[[I.cookstage2text()]\] = [I]")
		counter++
	var/remove_item = removables[1]
	if(LAZYLEN(removables) > 1)
		remove_item = input(user, "What to remove?", "Remove from container", null) as null|anything in removables
	if(remove_item)
		user.put_in_hands_or_drop(removables[remove_item])
		return TRUE
	return FALSE

/obj/item/reagent_containers/glass/food_holder/proc/try_merge(obj/item/reagent_containers/food/snacks/ingredient/I, obj/item/reagent_containers/food/snacks/ingredient/compare_ingredient, mob/user)
	if(!istype(I))
		return
	if(((compare_ingredient.accumulated_time_cooked - INGREDIENT_COOKTIME_MAX_SEPERATION) < I.accumulated_time_cooked && I.accumulated_time_cooked < (compare_ingredient.accumulated_time_cooked + INGREDIENT_COOKTIME_MAX_SEPERATION)) 	&& (compare_ingredient.cookstage = I.cookstage))
		if(user.attempt_insert_item_for_installation(I, src))
			compare_ingredient.merge_ingredient(I)


/obj/item/reagent_containers/glass/food_holder/proc/generate_serving(var/obj/item/food_serving/FS, mob/user)
	if(!istype(FS))
		return
	var/obj/item/reagent_containers/food/snacks/food_serving/generated_serving = new /obj/item/reagent_containers/food/snacks/food_serving(null)
	var/list/tally_flavours = list()
	var/serving_thing_name = "handful"

	for(var/obj/item/reagent_containers/food/snacks/ingredient/tally_ingredient in contents)
		tally_flavours[tally_ingredient.cookstage_information[tally_ingredient.cookstage][COOKINFO_TASTE]] = tally_ingredient.serving_amount //the more it is the stronger it'll taste
		var/total_volume_transferred = (1 / tally_ingredient.serving_amount)
		tally_ingredient.reagents.trans_to_holder(generated_serving.reagents, total_volume_transferred, tally_ingredient.cookstage_information[tally_ingredient.cookstage][COOKINFO_NUTRIMULT])
		tally_ingredient.consume_serving()
	if(FS)
		serving_thing_name = FS.serving_type
		generated_serving.trash = FS
		FS.forceMove(generated_serving)
	generated_serving.name = "a [serving_thing_name] of "
	generated_serving.name += generate_food_name()
	user.put_in_hands_or_drop(generated_serving)


/obj/item/reagent_containers/glass/food_holder/proc/generate_food_name()
	if(food_name_override)
		return food_name_override
	var/list/ingredients_names = list()
	for(var/obj/item/I in contents)
		ingredients_names |= I.name
	ingredients_names = english_list(ingredients_names)
	if(reagents.total_volume >= (reagents.maximum_volume / 2)) //greater than 50%)
		return "[ingredients_names] soup"
	if(reagents.total_volume >= (reagents.maximum_volume / 4)) //greater than 25%)
		return "[ingredients_names] stew"
	return "[ingredients_names] melange"



/obj/item/reagent_containers/glass/food_holder/proc/check_recipe_completion()
	for(var/obj/item/reagent_containers/food/snacks/ingredient/tally_ingredient in contents)
		if((tally_ingredient.cookstage == RAW) || (tally_ingredient.cookstage == BURNT))
			return FALSE
	var/list/list_recipes = subtypesof(/datum/cooking_recipe)
	for(var/i in list_recipes)
		var/datum/cooking_recipe/check_recipe = new i
		if(last_cooking_method != check_recipe.required_method)
			continue
		if(LAZYLEN(check_recipe.recipe_items))
			if(!check_ingredient_for_recipe(check_recipe))
				continue
		if(check_recipe.recipe_reagents)
			if(!check_reagent_for_recipe(check_recipe))
				continue
		reagents.clear_reagents()
		for(var/obj/item/I in contents)
			qdel(I)
		for(var/j=0,j<check_recipe.result_quantity,j++)
			new check_recipe.result(get_turf(src))
		qdel(i)
		return

/obj/item/reagent_containers/glass/food_holder/proc/check_ingredient_for_recipe(var/datum/cooking_recipe/R)
	for(var/obj/item/reagent_containers/food/snacks/ingredient/check_ingredient in contents)
		to_chat(world, "checking ingredient [check_ingredient] for recipe [R]")
		if(R.recipe_fruit)
			if(istype(check_ingredient, /obj/item/reagent_containers/food/snacks/ingredient/grown))
				to_chat(world, "checking growns for recipe [R]")
				var/obj/item/reagent_containers/food/snacks/ingredient/grown/fruit = check_ingredient
				if(!(fruit.seed.kitchen_tag in R.recipe_fruit))
					to_chat(world, "wrong grown")
					return FALSE //wrong fruit, we dont make anything
				if(R.recipe_fruit[fruit.seed.kitchen_tag] > fruit.serving_amount)
					to_chat(world, "not enough fruit ([R.recipe_fruit[fruit.seed.kitchen_tag]] > [fruit.serving_amount])")
					return FALSE
					
		if(!(is_exact_type_in_list(check_ingredient, R.recipe_items)))
			to_chat(world, "wrong ingredient ([is_type_in_list(check_ingredient, R.recipe_items)])")
			return FALSE //wrong stuff
		if(R.recipe_items[check_ingredient] > check_ingredient.serving_amount)
			to_chat(world, "not enough ingredient ([R.recipe_items[check_ingredient]] > [check_ingredient.serving_amount])")
			return FALSE
	return TRUE	

/obj/item/reagent_containers/glass/food_holder/proc/check_reagent_for_recipe(var/datum/cooking_recipe/R)
	for(var/check_reagent in R.recipe_reagents)
		var/available_reagent_amount = reagents.get_reagent_amount(check_reagent)
		to_chat(world, "reagent [check_reagent] has amount [available_reagent_amount] we need [R.recipe_reagents[check_reagent]]")
		if(available_reagent_amount < R.recipe_reagents[check_reagent])
			to_chat(world, "not enough reagent")
			return FALSE
	return TRUE
