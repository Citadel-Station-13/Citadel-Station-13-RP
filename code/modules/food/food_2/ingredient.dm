/obj/item/reagent_containers/food/snacks/ingredient
	name = 'generic ingredient'
	desc = "This is a generic ingredient. It's so perfectly generic you're having a hard time even looking at it."
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


/obj/item/reagent_containers/food/snacks/ingredient/proc/process_cooked()
	if(cookstage >= BURNT)
		return //we dont need to do anything if we're burnt
	var/next_cookstage = cookstage + 1

	if(accumulated_time_cooked >= cookstage_information[next_cookstage][COOKINFO_TIME])
		cookstage = next_cookstage
		on_cooked(cookstage)

/obj/item/reagent_containers/food/snacks/ingredient/proc/on_cooked(var/reached_stage)
	return //we dont do anything special
