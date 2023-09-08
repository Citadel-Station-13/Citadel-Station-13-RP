//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * why is this here?
 *
 * to avoid a constructor for /datum/stack_recipe
 *
 * why? because this is easier to regex later if it turns out silicons code design(tm) was terrible
 */
/proc/create_stack_recipe_datum(name, product, cost, amount = 1, sanity_checks = TRUE, time = 0, recipe_type = /datum/stack_recipe, category)
	// check this isn't being misused
	ASSERT(!ispath(recipe_type, /datum/stack_recipe/material))
	var/datum/stack_recipe/creating = new recipe_type
	creating.name = name
	creating.category = category
	creating.result_type = product
	creating.cost = cost
	creating.result_amount = amount
	creating.result_is_stack = ispath(product, /obj/item/stack)
	creating.no_automatic_sanity_checks = !sanity_checks
	creating.time = time
	return creating

/datum/stack_recipe
	abstract_type = /datum/stack_recipe
	/// sort order - lower is first
	var/sort_order = 0
	/// recipe name
	var/name = "???"
	/// category (so the dropdown we appear under). categories are always sorted to top, and then alphabetically.
	/// null to have something on main panel
	var/category
	/// result type
	var/result_type = /obj/item/clothing/mask/ninjascarf
	/// result amount; stacks will be processed accordingly
	var/result_amount = 1
	/// the amount of time to craft result_amount of result_type
	var/time = 3 SECONDS
	/// bypass checks for preventing turf stacking/whatnot
	var/no_automatic_sanity_checks = FALSE
	/// how many of the stack we need
	var/cost = 1
	/// this is a stack product
	var/result_is_stack = FALSE
	/// type to check against to make sure there's nothing in the way
	var/exclusitivity
	// todo: material constraints

/datum/stack_recipe/New()
	if(ispath(result_type, /obj/item/stack))
		result_is_stack = TRUE

/**
 * attepmt to craft
 *
 * @params
 * * where - where to spawn result
 * * amount - amount
 * * stack - stack used
 * * user - (optional) person crafting
 * * silent - (optional) suppress feedback to user
 * * use_dir - (optional) override dir if no user to get it from
 *
 * @return TRUE/FALSE success
 */
/datum/stack_recipe/proc/craft(atom/where, amount, obj/item/stack/stack, mob/user, silent, use_dir)
	if(!check(where, amount, stack, user, silent))
		return FALSE
	return make(where, amount, stack, user, silent)

/**
 * see if it's valid to make the recipe
 *
 * @params
 * * where - where to spawn result
 * * amount - amount
 * * stack - stack used
 * * user - (optional) person crafting
 * * silent - (optional) suppress feedback to user
 * * use_dir - (optional) override dir if no user to get it from
 *
 * @return TRUE/FALSE success
 */
/datum/stack_recipe/proc/check(atom/where, amount, obj/item/stack/stack, mob/user, silent, use_dir)
	if(!no_automatic_sanity_checks)
		#warn check turf, density, etc
	if(!isnull(exclusitivity))
		for(var/atom/movable/AM as anything in where)
			if(istype(AM, exclusitivity))
				if(!silent && !isnull(user))
					user.action_feedback(SPAN_WARNING("[AM] is in the way."))
				return FALSE
	return TRUE

/**
 * actually spawn the object in
 * this is past point of no return
 * shouldn't cancel under any circumstances
 *
 * @params
 * * where - where to spawn result
 * * amount - amount
 * * stack - stack used
 * * user - (optional) person crafting
 * * silent - (optional) suppress feedback to user
 * * use_dir - (optional) override dir if no user to get it from
 */
/datum/stack_recipe/proc/make(atom/where, amount, obj/item/stack/stack, mob/user, silent, use_dir)
	#warn impl

/**
 * tgui stack recipe data
 */
/datum/stack_recipe/proc/tgui_recipe_data()
	#warn .tsx file
	return list(
		"sortOrder" = sort_order,
		"name" = name,
		"category" = category,
		"resultType" = result_type,
		"resultAmt" = result_amount,
		"time" = time,
		"noAutoSanity" = no_automatic_sanity_checks,
		"isStack" = result_is_stack,
	)
