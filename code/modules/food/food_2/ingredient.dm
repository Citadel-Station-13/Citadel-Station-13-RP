/obj/item/reagent_containers/food/snacks/ingredient
	name = "generic ingredient"
	desc = "This is a generic ingredient. It's so perfectly generic you're having a hard time even looking at it."
	icon_state = "meat"
	//cookstage_information is a list of lists
	//it contains a bunch of information about: how long it takes, what nutrition multiplier the ingredient has, what taste the ingredient has at various cook stages (raw, cooked, overcooked, burnt)
	//an example one would be list(list(0, 0.5, "raw meat"), list(10 SECONDS, 1.2, "cooked meat"), list(16 SECONDS, 0.9, "rubbery and chewy meat"), list(20 SECONDS, 0.1, "charcoal"))
	//these are defines, so to get the taste of a raw slab of meat you would do cookstage_information[RAW][COOKINFO_TASTE]
	var/list/cookstage_information = list(list(0, 0.5, "genericness"), list(10 SECONDS, 1.2, "cooked genericness"), list(16 SECONDS, 0.9, "rubbery genericness"), list(20 SECONDS, 0.1, "gneric sharcoal"))
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
		on_cooked(cookstage, cook_method)

/obj/item/reagent_containers/food/snacks/ingredient/proc/on_cooked(var/reached_stage, var/cook_method)
	return //we dont do anything special


/obj/item/reagent_containers/food/snacks/ingredient/examine(mob/user, dist)
	. = ..()
	. += cooking_information(TRUE)

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
