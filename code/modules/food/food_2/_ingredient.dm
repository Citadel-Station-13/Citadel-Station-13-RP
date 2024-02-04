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

	var/cooker_overlay = "meat" //what overlay we use for the cooker
	var/finished_overlay //what overlay we use for the finished item, if null we dont do anything special

	var/extra_serving_overlay_threshold = 2 //for every extra_serving_overlay_threshold we gain a overlay
	var/max_servings = 10 //max amount of servings we can have
	//should be everything for now

/obj/item/reagent_containers/food/snacks/ingredient/Initialize(mapload)
	. = ..()
	var/datum/reagent/nutriment/our_nutrient = reagents.get_reagent("nutriment")
	our_nutrient.data = list()
	our_nutrient.data[cookstage_information[RAW][COOKINFO_TASTE]] = serving_amount

/obj/item/reagent_containers/food/snacks/ingredient/examine(mob/user, dist)
	. = ..()
	. += SPAN_NOTICE("<b>Alt-click</b> to split off servings.")
	. += cooking_information(TRUE)

/obj/item/reagent_containers/food/snacks/ingredient/update_icon()
	cut_overlays()
	var/overlay_amount = FLOOR(serving_amount/extra_serving_overlay_threshold, 1)
	if(overlay_amount > 1)
		for(var/i, i<=overlay_amount, i++)
			var/mutable_appearance/stuff_overlay = mutable_appearance(icon, icon_state)
			stuff_overlay.color = color
			stuff_overlay.pixel_x = pick(rand(-12,-6), rand(6,12))
			stuff_overlay.pixel_y = pick(rand(-12,-6), rand(6,12))
			add_overlay(stuff_overlay)

/obj/item/reagent_containers/food/snacks/ingredient/attackby(obj/item/I, mob/user)
	if(I.type != type)
		return ..()
	if(check_merge(I, user))
		to_chat(user, SPAN_NOTICE("You combine [I] into [src]."))
		merge_ingredient(I)


/obj/item/reagent_containers/food/snacks/ingredient/proc/check_merge(/obj/item/reagent_containers/food/snacks/ingredient/add_ingredient, mob/user)
	if((((accumulated_time_cooked - INGREDIENT_COOKTIME_MAX_SEPERATION) < add_ingredient.accumulated_time_cooked) && (add_ingredient.accumulated_time_cooked < (accumulated_time_cooked + INGREDIENT_COOKTIME_MAX_SEPERATION))) && (add_ingredient.cookstage = cookstage))
		if((add_ingredient.serving_amount + serving_amount) < max_servings)
			return TRUE
		to_chat(user, SPAN_NOTICE("There's too much to combine!"))
		return FALSE
	else
		to_chat(user, SPAN_NOTICE("You can't mix raw and cooked ingredients."))
		return FALSE

/obj/item/reagent_containers/food/snacks/ingredient/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	if(istype(target, /obj/singularity/energy_ball)) //snowflaked for sing/tesla
		var/obj/singularity/energy_ball/tesla_ball = target
		user.visible_message("<span class=\"warning\">\The [user] holds up [src] to \the [tesla_ball]!</span>",\
		"<span class=\"danger\">You hold up [src] to \the [tesla_ball]!",\
		"<span class=\"warning\">Everything suddenly goes quiet.</span>")
		while(do_after(user, 1 SECOND))
			var/cooktime = 0 SECOND
			switch(tesla_ball.orbiting_balls.len)
				if(-INFINITY to 0)
					cooktime += 1 SECOND
				if(1 to 2)
					cooktime += 2 SECOND
				if(3 to 5)
					cooktime += 4 SECOND
				if(5 to 7)
					cooktime += 8 SECOND
				if(7 to INFINITY)
					cooktime += 10 SECOND
			process_cooked(cooktime, HEAT_HIGH, METHOD_ENERGETIC_ANOMALY)

	else if(istype(target, /obj/singularity))
		var/obj/singularity/mr_singulo = target
		user.visible_message("<span class=\"warning\">\The [user] holds up [src] to \the [mr_singulo]...</span>")
		while(do_after(user, 1 SECOND))
			process_cooked(1, HEAT_LOW, METHOD_ENERGETIC_ANOMALY) //it's hawking radiation what do you expect
		return



/obj/item/reagent_containers/food/snacks/ingredient/AltClick(mob/user)
	if(!isliving(user))
		return ..()
	if(serving_amount < 1)
		to_chat(user, SPAN_WARNING("There's not enough of [src] to split off!"))
		return
	var/amount = input("How much to split?", "Split ingredient") as null|num
	amount = round(amount) //0.6 >> 1
	if(amount && amount < serving_amount)
		var/final_ratio = amount/serving_amount
		serving_amount -= amount
		update_icon()
		var/obj/item/reagent_containers/food/snacks/ingredient/split_ingredient = new type(src)
		split_ingredient.cookstage = cookstage
		split_ingredient.accumulated_time_cooked = accumulated_time_cooked
		split_ingredient.reagents.clear_reagents() //so we aren't making it taste raw on init
		split_ingredient.reagents.trans_to_holder(reagents, reagents.total_volume * final_ratio, 1, TRUE)
		split_ingredient.serving_amount = amount
		split_ingredient.update_icon()
		user.put_in_hands_or_drop(split_ingredient)
		to_chat(user, SPAN_NOTICE("You split off [src]."))
	else
		to_chat(user, SPAN_WARNING("There's not enough serves in the [src]!"))

/obj/item/reagent_containers/food/snacks/ingredient/initialize_slice(obj/item/reagent_containers/food/snacks/slice, reagents_per_slice)
	reagents.trans_to_obj(slice, reagents_per_slice)
	if(name != initial(name))
		slice.name = "slice of [name]"
	if(desc != initial(desc))
		slice.desc = "[desc]"
	var/obj/item/reagent_containers/food/snacks/ingredient/slice_ingredient = slice
	slice_ingredient.cookstage = cookstage
	slice_ingredient.accumulated_time_cooked = min(slice_ingredient.cookstage_information[cookstage][COOKINFO_TIME], accumulated_time_cooked)


/obj/item/reagent_containers/food/snacks/ingredient/welder_act(obj/item/I, datum/event_args/actor/clickchain/e_args, flags, hint)
	while(use_welder(I, e_args, flags, 1 SECONDS, 0.25, TOOL_USAGE_INADVISABLE | TOOL_USAGE_COOKING))
		e_args.visible_feedback(
		target = src,
		range = MESSAGE_RANGE_CONSTRUCTION,
		visible = SPAN_NOTICE("[e_args.performer] starts heating [src] with [I]."),
		audible = SPAN_WARNING("You hear the sound of a welding torch being used on something organic."),
		otherwise_self = SPAN_NOTICE("You cook [src] with [I]."),
		)
		process_cooked(1 SECOND, pick(HEAT_HIGH, HEAT_MID), METHOD_BLOWTORCH)


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
		if(our_nutrient)
			our_nutrient.data = list()
			our_nutrient.data[cookstage_information[cookstage][COOKINFO_TASTE]] = serving_amount
		if(istype(loc, /obj/item/reagent_containers/glass/food_holder))
			var/obj/item/reagent_containers/glass/food_holder/FH = loc
			FH.check_recipe_completion(cook_method)
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
	update_icon()
	qdel(I)

/obj/item/reagent_containers/food/snacks/ingredient/proc/consume_serving(var/remove_amount = 1)
	serving_amount -= remove_amount
	update_icon()
	if(serving_amount <= 0)
		qdel(src)

/obj/item/reagent_containers/food/snacks/ingredient/plant //for testing, delete before merge
	name = "plant based generic ingredient"
	desc = "This is a generic ingredient. It's so perfectly generic you're having a hard time even looking at it."
	icon_state = "loadedbakedpotato"
	//cookstage_information is a list of lists
	//it contains a bunch of information about: how long it takes, what nutrition multiplier the ingredient has, what taste the ingredient has at various cook stages (raw, cooked, overcooked, burnt)
	//an example one would be list(list(0, 0.5, "raw meat"), list(10 SECONDS, 1.2, "cooked meat"), list(16 SECONDS, 0.9, "rubbery and chewy meat"), list(20 SECONDS, 0.1, "charcoal"))
	//these are defines, so to get the taste of a raw slab of meat you would do cookstage_information[RAW][COOKINFO_TASTE]
	cookstage_information = list(list(0, 0.5, "raw vegetable"), list(4 SECONDS, 1.2, "cooked vegetable"), list(16 SECONDS, 0.9, "mushy vegetable"), list(20 SECONDS, 0.1, "charcoal vegetable"))
	//how much cooking time (effective) have we accumulated

/obj/item/reagent_containers/food/snacks/ingredient/transformable
	name = "transforming generic ingredient"
	var/list/transform_list = list(METHOD_STOVE = /obj/item/reagent_containers/food/snacks/ingredient, METHOD_OVEN = /obj/item/reagent_containers/food/snacks/ingredient) //example
	var/obj/item/reagent_containers/food/snacks/fallback_create = /obj/item/reagent_containers/food/snacks/ingredient


/obj/item/reagent_containers/food/snacks/ingredient/transformable/on_cooked(reached_stage, cook_method)
	if(reached_stage == COOKED)
		var/obj/item/reagent_containers/food/snacks/create_item
		if(cook_method in transform_list)
			create_item = transform_list[cook_method]
		else
			create_item = fallback_create
		create_item = new(loc)
		reagents.del_reagent("nutriment") //remove nutrient so we dont get weird tastes
		create_item.reagents.trans_to_holder(reagents, reagents.total_volume, 1, TRUE)
		if(istype(create_item, /obj/item/reagent_containers/food/snacks/ingredient))
			var/obj/item/reagent_containers/food/snacks/ingredient/create_ingredient = create_item
			create_ingredient.accumulated_time_cooked = accumulated_time_cooked
			create_ingredient.cookstage = cookstage
			var/datum/reagent/nutriment/our_nutrient = create_ingredient.reagents.get_reagent("nutriment")
			our_nutrient.data = list()
			our_nutrient.data[create_ingredient.cookstage_information[cookstage][COOKINFO_TASTE]] = serving_amount
		qdel(src)
	return


/obj/item/reagent_containers/food/snacks/ingredient/slice
	slice_path = null //not further sliceable
	bitesize = 2 //smol
