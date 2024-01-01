/obj/item/reagent_containers/food_holder
	name = "cooking pot"
	desc = "A debug cooking container. For making sphagetti, and other various copypasta-based dishes."
	icon = 'icons/obj/cooking_machines.dmi'
	icon_state = "ovendish"

	var/food_name_override 

	//is this it? yeah, it it is

/obj/item/reagent_containers/food_holder/examine(mob/user, dist)
	. = ..()
	. += SPAN_NOTICE("<b>Alt-click</b> to remove something from this.")

/obj/item/reagent_containers/food_holder/proc/tick_heat(var/time_cooked, var/heat_level, var/cook_method)
	for(var/obj/item/reagent_containers/food/snacks/ingredient/cooking_ingredient in contents)
		cooking_ingredient.process_cooked(time_cooked, heat_level, cook_method) //handles all the cooking stuff actually


/obj/item/reagent_containers/food_holder/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/ingredient))
		for(var/obj/item/reagent_containers/food/snacks/ingredient/compare_ingredient in contents)
			if(compare_ingredient.type == I.type)
				try_merge(I, compare_ingredient, user)
		if(!user.attempt_insert_item_for_installation(I, src))
			user.visible_message("<span class='notice'>[user] puts [I] into [src].</span>", "<span class='notice'>You put [I] into [src].</span>")
			return
		return
	return ..()

/obj/item/reagent_containers/food_holder/AltClick(mob/living/user)
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
	to_chat(user, "lazylen [LAZYLEN(removables)]")
	var/remove_item = removables[1]
	to_chat(user, "You attempt remove [remove_item] ([removables[remove_item]]) from [src]")
	if(LAZYLEN(removables) > 1)
		remove_item = input(user, "What to remove?", "Remove from container", null) as null|anything in removables
	to_chat(user, "You attempt remove [remove_item] ([removables[remove_item]]) from [src]")
	if(remove_item)
		user.put_in_hands_or_drop(removables[remove_item])
		return TRUE
	return FALSE

/obj/item/reagent_containers/food_holder/proc/try_merge(obj/item/reagent_containers/food/snacks/ingredient/I, obj/item/reagent_containers/food/snacks/ingredient/compare_ingredient, mob/user)
	if(!istype(I))
		return
	if(((compare_ingredient.accumulated_time_cooked - INGREDIENT_COOKTIME_MAX_SEPERATION) < I.accumulated_time_cooked && I.accumulated_time_cooked < (compare_ingredient.accumulated_time_cooked + INGREDIENT_COOKTIME_MAX_SEPERATION)) 	&& (compare_ingredient.cookstage = I.cookstage))
		if(user.attempt_insert_item_for_installation(I, src))
			compare_ingredient.merge_ingredient(I)


/obj/item/reagent_containers/food_holder/proc/generate_serving(var/obj/item/food_serving/FS, mob/user)
	var/obj/item/reagent_containers/food/snacks/food_serving/generated_serving = new /obj/item/reagent_containers/food/snacks/food_serving(null)
	var/list/tally_flavours = list()
	generated_serving.name = "a [FS.serving_type] of "
	generated_serving.name += generate_food_name()
	for(var/obj/item/reagent_containers/food/snacks/ingredient/tally_ingredient in contents)
		tally_flavours[tally_ingredient.cookstage_information[tally_ingredient.cookstage][COOKINFO_TASTE]] = tally_ingredient.serving_amount //the more it is the stronger it'll taste
		var/total_volume_transferred = (1 / tally_ingredient.serving_amount)
		tally_ingredient.reagents.trans_to_holder(generated_serving.reagents, total_volume_transferred, tally_ingredient.cookstage_information[tally_ingredient.cookstage][COOKINFO_NUTRIMULT])
		generated_serving.trash = FS
	FS.forceMove(generated_serving)
	user.put_in_hands_or_drop(generated_serving)


/obj/item/reagent_containers/food_holder/proc/generate_food_name()
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

/*
/obj/item/reagent_containers/food_holder/proc/check_recipe_completion()
	for(var/obj/item/reagent_containers/food/snacks/ingredient/tally_ingredient in contents)
		if((tally_ingredient.cookstage == RAW) || (tally_ingredient.cookstage == BURNT))
			return


	var/list_recipes = subtypesof(/datum/cooking_recipe)
	for(var/datum/recipe/check_recipe in list_recipes)
		for(var/obj/item/reagent_containers/food/snacks/ingredient/check_ingredient in contents)
			if(istype(check_ingredient, /obj/item/reagent_containers/food/snacks/grown))
				var/obj/item/reagent_containers/food/snacks/grown/fruit = check_ingredient
				if(fruit.seed.kitchen_tag && (fruit.seed.kitchen_tag in check_recipe.recipe_fruit))
					continue // correct type of fruit, move on
				else
					return FALSE //wrong fruit, we dont make anything
			if(!is_type_in_list(O, check_recipe.recipe_items))
				return FALSE
		for(var/check_reagent in check_recipe.recipe_reagents)
			var/available_reagent_amount = reagents.get_reagent_amount(check_reagent)
			if(available_reagent_amount >= reagents[check_reagent])
				return FALSE
*/

		

