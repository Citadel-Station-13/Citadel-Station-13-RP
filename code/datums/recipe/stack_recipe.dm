//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * why is this here?
 *
 * to avoid a constructor for /datum/stack_recipe
 *
 * why? because this is easier to regex later if it turns out silicons code design(tm) was terrible
 */
/proc/create_stack_recipe_datum(name, product, cost = 1, amount = 1, sanity_checks = TRUE, time = 0, recipe_type = /datum/stack_recipe, category, exclusitivity, list/recipe_args)
	// check this isn't being misused
	ASSERT(!ispath(recipe_type, /datum/stack_recipe/material))
	var/datum/stack_recipe/creating = isnull(recipe_args)? (new recipe_type) : (new recipe_type(arglist(recipe_args)))
	creating.name = name
	creating.category = category
	creating.result_type = product
	creating.cost = cost
	creating.result_amount = amount
	creating.result_is_stack = ispath(product, /obj/item/stack)
	creating.no_automatic_sanity_checks = !sanity_checks
	creating.time = time
	creating.exclusitivity = exclusitivity
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
	/// max amount to allow crafting at once. null for 1 non stack, infinity stack
	var/max_amount
	/// we're a border object
	var/on_border = FALSE
	// todo: material constraints

	//* Product Descriptors *//

	/// Automatically create empty storage / cells / containers / whatever
	/// * Usually this is on, because usually stacks are not meant to create the insides of a container.
	var/product_auto_create_empty = TRUE

	//* Internal *//

	/// preloader callback, do not touch
	var/datum/callback/preloader_callback

/datum/stack_recipe/New()
	if(ispath(result_type, /obj/item/stack))
		result_is_stack = TRUE

	var/atom/casted = result_type
	on_border = !!(initial(casted.atom_flags) & ATOM_BORDER)

	preloader_callback = CALLBACK(src, PROC_REF(make_preload_hook))

/datum/stack_recipe/Destroy()
	QDEL_NULL(preloader_callback)
	return ..()

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
/datum/stack_recipe/proc/craft(atom/where, amount, obj/item/stack/stack, mob/user, silent, use_dir = user?.dir)
	if(!check(where, amount, stack, user, silent, use_dir))
		return FALSE
	return make(where, amount, stack, user, silent, use_dir)

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
/datum/stack_recipe/proc/check(atom/where, amount, obj/item/stack/stack, mob/user, silent, use_dir = user?.dir)
	if(!no_automatic_sanity_checks)
		var/atom/movable/casted_result = result_type
		if(initial(casted_result.density))
			for(var/atom/movable/AM as anything in where)
				if(AM == user)
					continue
				// border only collides with other border objs in the same dir
				if((AM.atom_flags & ATOM_BORDER) && (!on_border || (AM.dir != use_dir)))
					continue
				if(AM.density)
					if(!silent)
						user.action_feedback(SPAN_WARNING("[AM] is in the way."))
					return FALSE
	if(!isnull(exclusitivity))
		for(var/atom/movable/AM as anything in where)
			if(AM == user)
				continue
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
 * * When overriding this proc you **must** ensure list/created has a = list() in the args, if it doesn't call ..() first. Otherwise, the pattern being used will runtime.
 *
 * @params
 * * where - where to spawn result
 * * amount - amount
 * * stack - stack used
 * * user - (optional) person crafting
 * * silent - (optional) suppress feedback to user
 * * use_dir - (optional) override dir if no user to get it from
 * * creating - (optional) list will be populated of objects created. supply a list so you can read it, or don't to ignore.
 */
/datum/stack_recipe/proc/make(atom/where, amount, obj/item/stack/stack, mob/user, silent, use_dir, list/created = list())
	if(result_is_stack)
		var/obj/item/stack/casted = result_type
		var/max_amount = initial(casted.max_amount)
		var/safety = 50
		while(amount)
			if(!--safety)
				CRASH("safety hit")
			var/making_amount = min(amount, max_amount)
			var/obj/item/stack/creating = SSatoms.instance_atom_immediate_with_preloader(result_type, FALSE, preloader_callback, where, making_amount)
			amount -= making_amount
			created += creating
	else
		for(var/i in 1 to min(amount, 50))
			var/atom/movable/creating = SSatoms.instance_atom_immediate_with_preloader(result_type, FALSE, preloader_callback, where)
			creating.setDir(use_dir)
			created += creating
	return TRUE

/**
 * preloads an atom we make
 */
/datum/stack_recipe/proc/make_preload_hook(atom/product)
	SHOULD_NOT_SLEEP(TRUE)
	product.preloading_from_stack_recipe(src)

/**
 * tgui stack recipe data
 */
/datum/stack_recipe/proc/tgui_recipe_data()
	// todo: better way than ref? we don't want to do uids but refs are kinda ass to use in UIs for security/checking purposes.
	return list(
		"sortOrder" = sort_order,
		"name" = name,
		"category" = category,
		"resultType" = result_type,
		"resultAmt" = result_amount,
		"time" = time,
		"noAutoSanity" = no_automatic_sanity_checks,
		"isStack" = result_is_stack,
		"ref" = ref(src),
		"maxAmount" = max_amount,
		"cost" = cost,
	)
