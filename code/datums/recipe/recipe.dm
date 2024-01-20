// todo: damn, 2011? sounds like ripe time for refactor / optimizations round 'ere-- [user was banned for this post]

/* * * * * * * * * * * * * * * * * * * * * * * * * *
 * /datum/recipe by rastaf0            13 apr 2011 *
 * * * * * * * * * * * * * * * * * * * * * * * * * *
 * This is powerful and flexible recipe system.
 * It exists not only for food.
 * supports both reagents and objects as prerequisites.
 * In order to use this system you have to define a deriative from /datum/recipe
 * * reagents are reagents. Acid, milc, booze, etc.
 * * items are objects. Fruits, tools, circuit boards.
 * * result is type to create as new object
 * * time is optional parameter, you shall use in in your machine,
     default /datum/recipe/ procs does not rely on this parameter.
 *
 *  Functions you need:
 *  /datum/recipe/proc/make(var/obj/container as obj)
 *    Creates result inside container,
 *    deletes prerequisite reagents,
 *    transfers reagents from prerequisite objects,
 *    deletes all prerequisite objects (even not needed for recipe at the moment).
 *
 *  /proc/select_recipe(list/datum/recipe/available_recipes, obj/obj as obj, exact = 1)
 *    Wonderful function that select suitable recipe for you.
 *    obj is a machine (or magik hat) with prerequisites,
 *    exact = 0 forces algorithm to ignore superfluous stuff.
 *
 *
 *  Functions you do not need to call directly but could:
 *  /datum/recipe/proc/check_reagents(var/datum/reagents/avail_reagents)
 *  /datum/recipe/proc/check_items(var/obj/container as obj)
 *
 * */

	///Reagents in the ingredients are discarded.
#define RECIPE_REAGENT_REPLACE		0
	//Only the reagents present in the result at compiletime are used
	///The result will contain the maximum of each reagent present between the two pools. Compiletime result, and sum of ingredients
#define RECIPE_REAGENT_MAX	1
	///As above, but the minimum, ignoring zero values.
#define RECIPE_REAGENT_MIN 2
	///The entire quantity of the ingredients are added to the result
#define RECIPE_REAGENT_SUM 3

/datum/recipe
	var/list/reagents // example: = list("berryjuice" = 5) // do not list same reagent twice. coating reagents should go here
	var/list/items    // example: = list(/obj/item/crowbar = 1, /obj/item/welder = 2) // place /foo/bar before /foo
	var/list/fruit    // example: = list("fruit" = 3)


	var/result        // example: = /obj/item/reagent_containers/food/snacks/donut/normal
	var/result_quantity = 1 //number of instances of result that are created.
	var/time = 50    // 1/10 part of second // Citadel change, increases recipe speed.



	var/reagent_mix = RECIPE_REAGENT_MAX	//How to handle reagent differences between the ingredients and the results

	var/required_method = METHOD_MICROWAVE //Which method this recipe can be made in.
	//List of defines are in _DEFINES/cooking.dm, but for reference:
	/*
			#define METHOD_OVEN "oven"
			#define METHOD_GRILL "grill"
			#define METHOD_STOVE "stove"
			#define METHOD_DEEPFRY "deep fryer"
			#define METHOD_BLOWTORCH "blowtorch" //i know a welder isn't actually one but you actually use blowtorches in cooking
			#define METHOD_ENERGETIC_ANOMALY "energetic anomaly" //supermatter, tesla, etc
	*/
	//This is a bitfield, more than one type can be used
	//Grill is presently unused and not listed

/datum/recipe/proc/check_reagents(var/datum/reagents/avail_reagents)
	if(!reagents || !reagents.len)
		return 1

	if(!avail_reagents)
		return 0

	. = 1
	for(var/r_r in reagents)
		var/aval_r_amnt = avail_reagents.get_reagent_amount(r_r)
		if(aval_r_amnt - reagents[r_r] >= 0)
			if(aval_r_amnt>reagents[r_r])
				. = 0
		else
			return -1

	if((reagents?(reagents.len):(0)) < avail_reagents.reagent_list.len)
		return 0
	return .

/datum/recipe/proc/check_fruit(var/obj/container)
	if(!fruit || !fruit.len)
		return 1
	. = 1
	if(fruit && fruit.len)
		var/list/checklist = list()
		 // You should trust Copy().
		checklist = fruit.Copy()
		for(var/obj/item/reagent_containers/food/snacks/ingredient/grown/G in container)
			if(!G.seed || !G.seed.kitchen_tag || isnull(checklist[G.seed.kitchen_tag]))
				continue

			checklist[G.seed.kitchen_tag] -= G.serving_amount
		for(var/ktag in checklist)
			if(!isnull(checklist[ktag]))
				if(checklist[ktag] < 0)
					. = 0
				else if(checklist[ktag] > 0)
					. = -1
					break
	return .

/datum/recipe/proc/check_items(var/obj/container as obj)
	if(!items || !items.len)
		return 1
	. = 1
	if(items && items.len)
		var/list/checklist = list()
		checklist = items.Copy() // You should really trust Copy
		for(var/obj/O in container)
			if(istype(O,/obj/item/reagent_containers/food/snacks/ingredient/grown))
				continue // Fruit is handled in check_fruit().
			if((is_exact_type_in_list(O, checklist)))
				if(istype(O, /obj/item/reagent_containers/food/snacks/ingredient))
					var/obj/item/reagent_containers/food/snacks/ingredient/our_ingredient
					checklist[our_ingredient] -= our_ingredient.serving_amount
				else
					checklist[O]--
			else
				return 0

		if(checklist.len)
			. = -1

	return .

//general version
/datum/recipe/proc/make(var/obj/container as obj)
	var/obj/result_obj = new result(container)
	if(istype(container, /obj/machinery))
		var/obj/machinery/machine = container
		for(var/obj/O in ((machine.contents-result_obj - machine.component_parts) - machine.circuit))
			O.reagents.trans_to_obj(result_obj, O.reagents.total_volume)
			qdel(O)
	else
		for(var/obj/O in (container.contents-result_obj))
			O.reagents.trans_to_obj(result_obj, O.reagents.total_volume)
			qdel(O)
	container.reagents.clear_reagents()
	return result_obj

// food-related
//This proc is called under the assumption that the container has already been checked and found to contain the necessary ingredients
/datum/recipe/proc/make_food(var/obj/container)
	if(!result)
		return


//We will subtract all the ingredients from the container, and transfer their reagents into a holder
//We will not touch things which are not required for this recipe. They will be left behind for the caller
//to decide what to do. They may be used again to make another recipe or discarded, or merged into the results,
//thats no longer the concern of this proc
	var/obj/temp = new /obj(null)
	temp.create_reagents(1000000000)


	//Find fruits
	if(fruit && fruit.len)
		var/list/checklist = list()
		checklist = fruit.Copy()

		for(var/obj/item/reagent_containers/food/snacks/ingredient/grown/G in container)
			if(!G.seed || !G.seed.kitchen_tag || isnull(checklist[G.seed.kitchen_tag]))
				continue

			if(checklist[G.seed.kitchen_tag] > 0)
				//We found a thing we need
				var/amount_to_consume = checklist[G.seed.kitchen_tag]
				checklist[G.seed.kitchen_tag] -= G.serving_amount
				if(G && G.reagents)
					G.reagents.trans_to_holder(temp.reagents, G.reagents.total_volume * (amount_to_consume / G.serving_amount))
				G.consume_serving(amount_to_consume)


	//Find items we need
	if(items && items.len)
		for(var/i in items)
			var/obj/item/I = locate(i) in container
			if(!I)
				continue
			if(istype(I, /obj/item/reagent_containers/food/snacks/ingredient))
				var/obj/item/reagent_containers/food/snacks/ingredient/IN = I
				var/consume_amount = items[IN.type]
				I.reagents.trans_to_holder(temp.reagents, I.reagents.total_volume * (consume_amount / IN.serving_amount))
				continue
			if(I.reagents)
				I.reagents.trans_to_holder(temp.reagents,I.reagents.total_volume)
			qdel(I)



	//And lastly deduct necessary quantities of reagents
	if(reagents && reagents.len)
		for(var/r in reagents)
			//Doesnt matter whether or not there's enough, we assume that check is done before
			container.reagents.trans_id_to(temp, r, reagents[r])

	/*
	Now we've removed all the ingredients that were used and we have the buffer containing the total of
	all their reagents.

	Next up we create the result, and then handle the merging of reagents depending on the mix setting
	*/
	var/tally = 0

	/*
	If we have multiple results, holder will be used as a buffer to hold reagents for the result objects.
	If, as in the most common case, there is only a single result, then it will just be a reference to
	the single-result's reagents
	*/
	var/obj/tempholder = new(src)
	tempholder.create_reagents(100000000)
	var/list/results = list()
	while (tally < result_quantity)
		var/obj/result_obj = new result(container)
		results.Add(result_obj)

		if(!result_obj.reagents)//This shouldn't happen
			//If the result somehow has no reagents defined, then create a new holder
			result_obj.create_reagents(temp.reagents.total_volume*1.5)

		if(result_quantity == 1)
			qdel(tempholder.reagents)
			tempholder.reagents = result_obj.reagents
		else
			result_obj.reagents.trans_to(tempholder.reagents, result_obj.reagents.total_volume)
		tally++


	switch(reagent_mix)
		if(RECIPE_REAGENT_REPLACE)
			//We do no transferring
		if(RECIPE_REAGENT_SUM)
			//Sum is easy, just shove the entire buffer into the result
			temp.reagents.trans_to_holder(tempholder.reagents, temp.reagents.total_volume)
		if(RECIPE_REAGENT_MAX)
			//We want the highest of each.
			//Iterate through everything in buffer. If the target has less than the buffer, then top it up
			for(var/datum/reagent/R in temp.reagents.reagent_list)
				var/rvol = tempholder.reagents.get_reagent_amount(R.id)
				if(rvol < R.volume)
					//Transfer the difference
					temp.reagents.trans_id_to(tempholder, R.id, R.volume-rvol)

		if(RECIPE_REAGENT_MIN)
			//Min is slightly more complex. We want the result to have the lowest from each side
			//But zero will not count. Where a side has zero its ignored and the side with a nonzero value is used
			for(var/datum/reagent/R in temp.reagents.reagent_list)
				var/rvol = tempholder.reagents.get_reagent_amount(R.id)
				if(rvol == 0) //If the target has zero of this reagent
					temp.reagents.trans_id_to(tempholder, R.id, R.volume)
					//Then transfer all of ours

				else if(rvol > R.volume)
					//if the target has more than ours
					//Remove the difference
					tempholder.reagents.remove_reagent(R.id, rvol-R.volume)


	if(results.len > 1)
		//If we're here, then holder is a buffer containing the total reagents for all the results.
		//So now we redistribute it among them
		var/total = tempholder.reagents.total_volume
		for(var/i in results)
			var/atom/a = i //optimisation
			tempholder.reagents.trans_to(a, total / results.len)
	return results

//When exact is false, extraneous ingredients are ignored
//When exact is true, extraneous ingredients will fail the recipe
//In both cases, the full complement of required inredients is still needed
/proc/select_recipe(var/list/datum/recipe/available_recipes, var/obj/obj as obj, var/exact = 0)
	var/list/datum/recipe/possible_recipes = list()
	for(var/datum/recipe/recipe in available_recipes)
		if((recipe.check_reagents(obj.reagents) < exact) || (recipe.check_items(obj) < exact) || (recipe.check_fruit(obj) < exact))
			continue
		possible_recipes |= recipe
	if(!possible_recipes.len)
		return null
	else if(possible_recipes.len == 1)
		return possible_recipes[1]
	else //okay, let's select the most complicated recipe
		tim_sort(possible_recipes, GLOBAL_PROC_REF(cmp_recipe_complexity_dsc))
		return possible_recipes[1]
