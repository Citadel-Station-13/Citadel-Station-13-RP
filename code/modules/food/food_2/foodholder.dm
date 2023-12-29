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
	if(istype(I, /obj/item/reagent_containers/food_holder) || istype(I, /obj/item/reagent_containers/food/snacks/ingredient))
		if(!user.attempt_insert_item_for_installation(I, src))
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
