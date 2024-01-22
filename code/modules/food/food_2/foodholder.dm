/obj/item/reagent_containers/glass/food_holder
	name = "cooking pot"
	desc = "A cooking pot, for making various types of dishes."
	icon = 'icons/obj/food_ingredients/cooking_container.dmi'
	icon_state = "pot"
	atom_flags = OPENCONTAINER

	var/food_name_override

	var/last_cooking_method

	var/cooker_overlay = "pot"


	//is this it? yeah, it it is
/obj/item/reagent_containers/glass/food_holder/Initialize(mapload)
	. = ..()
	reagents.reagent_holder_flags |= TRANSPARENT

/obj/item/reagent_containers/glass/food_holder/examine(mob/user, dist) //todo: show food inside
	. = ..()
	. += SPAN_NOTICE("<b>Alt-click</b> to remove an ingredient from this.")
	. += SPAN_NOTICE("<b>Control-click</b> in grab intent to retrieve a serving of food.")
	. += SPAN_NOTICE("It contains:")
	for(var/obj/item/examine_item in contents)
		if(!istype(examine_item, /obj/item/reagent_containers/food/snacks/ingredient))
			. += "<span class='notice'>[icon2html(thing = examine_item, target = user)] The [examine_item].</span>"
			continue
		
		var/obj/item/reagent_containers/food/snacks/ingredient/examine_ingredient = examine_item
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

/obj/item/reagent_containers/glass/food_holder/update_icon()
	var/mutable_appearance/filling_overlay = mutable_appearance(icon, "[icon_state]_filling_overlay")
	if(LAZYLEN(contents) || reagents.total_volume)
		filling_overlay.color = tally_color()
		add_overlay(filling_overlay)


/obj/item/reagent_containers/glass/proc/tally_color()
	var/newcolor
	var/overlay_color

	for(var/obj/item/reagent_containers/food/snacks/ingredient/color_tally in contents)
		newcolor = color_tally.filling_color != "#FFFFFF" ? color_tally.filling_color : AverageColor(get_flat_icon(color_tally, color_tally.dir, 0), 1, 1)
		if(!overlay_color)
			overlay_color = newcolor
		overlay_color = BlendRGB(overlay_color, newcolor, 1/contents.len)

	if(!overlay_color)
		overlay_color = reagents.get_color()
	overlay_color = BlendRGB(overlay_color, reagents.get_color(), 0.6)
	return overlay_color

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

/obj/item/reagent_containers/glass/food_holder/CtrlClick(mob/living/user)
	if(user.a_intent == INTENT_GRAB)
		generate_serving(null, user)
		return

/obj/item/reagent_containers/glass/food_holder/AltClick(mob/living/user)
	var/list/removables = list()
	var/counter = 0
	for(var/obj/item/removeding in contents)
		if(!istype(removeding, /obj/item/reagent_containers/food/snacks/ingredient))
			user.put_in_hands_or_drop(removeding)
			continue
		var/obj/item/reagent_containers/food/snacks/ingredient/I = removeding
		if(counter)
			removables["[I.name] ([counter]) \[[I.cookstage2text()]\]"] = I
			to_chat(user, "Option [I.name] ([counter]) \[[I.cookstage2text()]\] = [I]")
		else
			removables["[I.name] \[[I.cookstage2text()]\]"] = I
			to_chat(user, "Option [I.name] \[[I.cookstage2text()]\] = [I]")
		counter++
	if(!LAZYLEN(removables))
		return
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
	var/list/fancy_overlay_to_add = list()
	var/food_color
	var/serving_thing_name = "handful"

	var/fs_icon = FS ? FS.icon : 'icons/obj/food_ingredients/custom_food.dmi'
	var/fs_iconstate = FS ? FS.icon_state : "handful"

	for(var/obj/item/reagent_containers/food/snacks/ingredient/tally_ingredient in contents)
		tally_flavours[tally_ingredient.cookstage_information[tally_ingredient.cookstage][COOKINFO_TASTE]] = tally_ingredient.serving_amount //the more it is the stronger it'll taste
		var/total_volume_transferred = (1 / tally_ingredient.serving_amount)
		tally_ingredient.reagents.trans_to_holder(generated_serving.reagents, total_volume_transferred, tally_ingredient.cookstage_information[tally_ingredient.cookstage][COOKINFO_NUTRIMULT])
		tally_ingredient.consume_serving()

		var/ingredient_fillcolor = tally_ingredient.filling_color != "#FFFFFF" ? tally_ingredient.filling_color : AverageColor(get_flat_icon(tally_ingredient, tally_ingredient.dir, 0), 1, 1)
		if(tally_ingredient.finished_overlay)
			var/mutable_appearance/filling_overlay = mutable_appearance(fs_icon, "[fs_iconstate]_filling_[tally_ingredient.finished_overlay]")
			filling_overlay.color = ingredient_fillcolor
			fancy_overlay_to_add += filling_overlay
		if(food_color)
			food_color = BlendRGB(food_color, ingredient_fillcolor, 0.5)
		else
			food_color = ingredient_fillcolor

		var/mutable_appearance/mixed_stuff_overlay = mutable_appearance(fs_icon, "[fs_iconstate]_filling")
		mixed_stuff_overlay.color = food_color
		fancy_overlay_to_add += mixed_stuff_overlay

	if(FS)
		serving_thing_name = FS.serving_type
		generated_serving.trash = FS
		FS.forceMove(generated_serving)

	generated_serving.name = "a [serving_thing_name] of "
	generated_serving.name += generate_food_name()
	generated_serving.icon = fs_icon
	generated_serving.icon_state = fs_iconstate
	generated_serving.add_overlay(fancy_overlay_to_add)
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
	var/datum/recipe/our_recipe = select_recipe(GLOB.cooking_recipes, src)
	if (!our_recipe)
		return
	our_recipe.make_food(src)
