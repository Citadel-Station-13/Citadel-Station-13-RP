/obj/item/reagent_containers/food_holder
	name = "cooking pot"
	desc = "A debug cooking container. For making sphagetti, and other various copypasta-based dishes."
	icon = 'icons/obj/cooking_machines.dmi'
	icon_state = "ovendish"

	//is this it? yeah, it it is

/obj/item/reagent_containers/food_holder/examine(mob/user, dist)
	. = ..()
	. += SPAN_NOTICE("<b>Alt-click</b> to remove something from this.")

/obj/item/reagent_containers/food_holder/proc/tick_heat(var/time_cooked, var/heat_level, var/cook_method)
	for(var/obj/item/reagent_containers/food/snacks/ingredient/cooking_ingredient in contents)
		cooking_ingredient.process_cooked(time_cooked, heat_level, cook_method) //handles all the cooking stuff actually


/obj/item/reagent_containers/food_holder/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/ingredient))
		if(is_type_in_list(I, contents))
			try_merge(I, user)
		else if(!user.attempt_insert_item_for_installation(I, src))
			return
		user.visible_message("<span class='notice'>[user] puts [I] into [src].</span>", "<span class='notice'>You put [I] into [src].</span>")
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
		remove_item = input(user, "What to remove?", "Remove from cooker", null) as null|anything in removables
	to_chat(user, "You attempt remove [remove_item] ([removables[remove_item]]) from [src]")
	if(remove_item)
		user.put_in_hands_or_drop(removables[remove_item])
		return TRUE
	return FALSE

/obj/item/reagent_containers/food_holder/proc/try_merge(obj/item/reagent_containers/food/snacks/ingredient/I, mob/user)
	if(!istype(I))
		return
	for(var/obj/item/reagent_containers/food/snacks/ingredient/compare_ingredient in contents)
		if(compare_ingredient.type == I.type)
			if((compare_ingredient.accumulated_time_cooked - INGREDIENT_COOKTIME_MAX_SEPERATION) < I.accumulated_time_cooked && I.accumulated_time_cooked < (compare_ingredient.accumulated_time_cooked + INGREDIENT_COOKTIME_MAX_SEPERATION))
				if(user.attempt_insert_item_for_installation(I, src))
					compare_ingredient.merge_ingredient(I)


/obj/item/reagent_containers/food_holder/proc/generate_serving(var/obj/item/food_serving/FS, mob/user)
	var/obj/item/reagent_containers/food/snacks/food_serving/generated_serving = new /obj/item/reagent_containers/food/snacks/food_serving(null)
	var/list/tally_flavours = list()
	generated_serving.name = "a [FS.serving_type] of" += generate_food_name()
	for(var/obj/item/reagent_containers/food/snacks/ingredient/tally_ingredient in contents)
		tally_flavours[cookstage_information[tally_ingredient.cookstage][COOKINFO_TASTE]] = tally_ingredient.serving_amount
serving_type


/obj/item/reagent_containers/food_holder/proc/generate_food_name()
	return "indescribable melange"
