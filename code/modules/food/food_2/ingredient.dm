/obj/item/reagent_containers/food/snacks/ingredient
	name = "generic ingredient"
	desc = "This is a generic ingredient. It's so perfectly generic you're having a hard time even looking at it."
	icon_state = "meat"
	nutriment_amt = 5
	//cookstage_information is a list of lists
	//it contains a bunch of information about: how long it takes, what nutrition multiplier the ingredient has, what taste the ingredient has at various cook stages (raw, cooked, overcooked, burnt)
	//an example one would be list(list(0, 0.5, "raw meat"), list(10 SECONDS, 1.2, "cooked meat"), list(16 SECONDS, 0.9, "rubbery and chewy meat"), list(20 SECONDS, 0.1, "charcoal"))
	//these are defines, so to get the taste of a raw slab of meat you would do cookstage_information[RAW][COOKINFO_TASTE]
	var/list/cookstage_information = list(list(0, 0.5, "raw genericness"), list(10 SECONDS, 1.2, "cooked genericness"), list(16 SECONDS, 0.9, "rubbery genericness"), list(20 SECONDS, 0.1, "gneric sharcoal"))
	//how much cooking time (effective) have we accumulated
	var/accumulated_time_cooked
	//what stage we're in
	var/cookstage = RAW

	//How much effective cook time is added per actual unit of cook time on the setting
	//E.g 1 SECOND on low heat > 1 * 0.5 seconds effective cook time
	// 1 second on high heat > 1 * 2 seconds effective cook time
	var/cooktime_mult_low = 0.5
	var/cooktime_mult_mid = 1
	var/cooktime_mult_high = 2

	//how many servings it will give when added to stuff
	var/serving_amount = 1

	//should be everything for now


/obj/item/reagent_containers/food/snacks/ingredient/examine(mob/user, dist)
	. = ..()
	. += SPAN_NOTICE("<b>Alt-click</b> to split off servings.")
	. += cooking_information(TRUE)


/obj/item/reagent_containers/food/snacks/ingredient/attackby(obj/item/I, mob/user)
	if(I.type != type)
		return ..()
	var/obj/item/reagent_containers/food/snacks/ingredient/add_ingredient = I
	if((((accumulated_time_cooked - INGREDIENT_COOKTIME_MAX_SEPERATION) < add_ingredient.accumulated_time_cooked) && (add_ingredient.accumulated_time_cooked < (accumulated_time_cooked + INGREDIENT_COOKTIME_MAX_SEPERATION))) && (add_ingredient.cookstage = cookstage))
		to_chat(user, SPAN_NOTICE("You combine [I] into [src]."))
		merge_ingredient(I)
	

/obj/item/reagent_containers/food/snacks/ingredient/AltClick(mob/user)
	if(!isliving(user))
		return ..()
	if(serving_amount < 1)
		to_chat(user, SPAN_WARNING("There's not enough of [src] to split off!"))
		return
	var/amount = input("How much to split?", "Split ingredient") as null|num
	amount = round(amount) //0.2 > 1
	if(amount && amount < serving_amount)
		var/final_ratio = amount/serving_amount
		serving_amount -= amount
		var/obj/item/reagent_containers/food/snacks/ingredient/split_ingredient = new type(src)
		split_ingredient.accumulated_time_cooked = accumulated_time_cooked
		split_ingredient.reagents.clear_reagents()
		split_ingredient.reagents.trans_to_holder(reagents, reagents.total_volume * final_ratio, 1, TRUE)
		split_ingredient.serving_amount = amount
		user.put_in_hands_or_drop(split_ingredient)
		to_chat(user, SPAN_NOTICE("You split off [src]."))
	else
		to_chat(user, SPAN_WARNING("There's not enough serves in the [src]!"))


/obj/item/reagent_containers/food/snacks/ingredient/proc/process_cooked(var/time_cooked, var/heat_level, var/cook_method)
	switch(heat_level)
		if(HEAT_LOW)
			accumulated_time_cooked += cooktime_mult_low * time_cooked
		if(HEAT_MID)
			accumulated_time_cooked += cooktime_mult_mid * time_cooked
		if(HEAT_HIGH)
			accumulated_time_cooked += cooktime_mult_high * time_cooked
	if(cookstage >= BURNT)
		return //we dont need to do anything if we're burnt
	var/next_cookstage = cookstage + 1

	if(accumulated_time_cooked >= cookstage_information[next_cookstage][COOKINFO_TIME])
		cookstage = next_cookstage
		var/datum/reagent/nutriment/our_nutrient = reagents.get_reagent("nutriment")
		our_nutrient.data = list()
		our_nutrient.data[cookstage_information[cookstage][COOKINFO_TASTE]] = serving_amount
		if(istype(loc, /obj/item/reagent_containers/food_holder))
			var/turf/T = get_turf(src)
			T.visible_message("The [src] is checking recipe completion in [loc]")
			var/obj/item/reagent_containers/food_holder/FH = loc
			FH.check_recipe_completion()
		on_cooked(cookstage, cook_method)

/obj/item/reagent_containers/food/snacks/ingredient/proc/on_cooked(var/reached_stage, var/cook_method)
	return //we dont do anything special

/obj/item/reagent_containers/food/snacks/ingredient/proc/cooking_information(var/detailed = FALSE)
	var/info = ""
	var/cooked_span = "userdanger"
	var/cooked_info = "unfathomable"
	if(detailed)
		info += "<span class='notice'>It's usable as an ingredient in cooking. \n</span>"
		info += "<span class='notice'>It takes [cookstage_information[COOKED][COOKINFO_TIME] / 10] second[cookstage_information[COOKED][COOKINFO_TIME] > 10 ? "s" : ""] to cook fully. \n</span>"
		info += "<span class='notice'>If cooked for longer than [cookstage_information[OVERCOOKED][COOKINFO_TIME] / 10] second[cookstage_information[OVERCOOKED][COOKINFO_TIME] > 10 ? "s" : ""], it will become overcooked.\n</span>"
		info += "<span class='notice'>If cooked for longer than [cookstage_information[BURNT][COOKINFO_TIME] / 10] second[cookstage_information[BURNT][COOKINFO_TIME] > 10 ? "s" : ""], it will burn.\n</span>"
	switch(cookstage)
		if(RAW)
			cooked_span = "rose"
			cooked_info = "raw."
		if(COOKED)
			cooked_span = "boldnicegreen"
			cooked_info = "perfectly cooked!"
		if(OVERCOOKED)
			cooked_span = "yellow"
			cooked_info = "a little overcooked."
		if(BURNT)
			cooked_span = "tajaran_signlang"
			cooked_info = "thorougly burnt."
	info += "<span class='notice'>It looks </span><span class='[cooked_span]'>[cooked_info] \n</span>"
	info += "<span class='notice'>It's been cooked for about [accumulated_time_cooked / 10] seconds. \n</span>" //do we want this on final? trait that lets you see exact cooking time and people without it see general? cooking goggles that let you analyze it??
	return info

/obj/item/reagent_containers/food/snacks/ingredient/proc/cookstage2text()
	switch(cookstage)
		if(RAW)
			return "raw"
		if(COOKED)
			return "cooked"
		if(OVERCOOKED)
			return "overcooked"
		if(BURNT)
			return "burnt"

/obj/item/reagent_containers/food/snacks/ingredient/proc/merge_ingredient(obj/item/reagent_containers/food/snacks/ingredient/I)
	I.reagents.trans_to_holder(reagents, I.reagents.total_volume, 1, TRUE)
	accumulated_time_cooked = (accumulated_time_cooked + I.accumulated_time_cooked) / 2
	serving_amount += I.serving_amount
	qdel(I)

/obj/item/reagent_containers/food/snacks/ingredient/proc/consume_serving(var/remove_amount = 1)
	serving_amount -= remove_amount
	if(serving_amount <= 0)
		qdel(src)

/obj/item/reagent_containers/food/snacks/ingredient/plant
	name = "plant based generic ingredient"
	desc = "This is a generic ingredient. It's so perfectly generic you're having a hard time even looking at it."
	icon_state = "loadedbakedpotato"
	//cookstage_information is a list of lists
	//it contains a bunch of information about: how long it takes, what nutrition multiplier the ingredient has, what taste the ingredient has at various cook stages (raw, cooked, overcooked, burnt)
	//an example one would be list(list(0, 0.5, "raw meat"), list(10 SECONDS, 1.2, "cooked meat"), list(16 SECONDS, 0.9, "rubbery and chewy meat"), list(20 SECONDS, 0.1, "charcoal"))
	//these are defines, so to get the taste of a raw slab of meat you would do cookstage_information[RAW][COOKINFO_TASTE]
	cookstage_information = list(list(0, 0.5, "raw vegetable"), list(4 SECONDS, 1.2, "cooked vegetable"), list(16 SECONDS, 0.9, "mushy vegetable"), list(20 SECONDS, 0.1, "charcoal vegetable"))
	//how much cooking time (effective) have we accumulated
