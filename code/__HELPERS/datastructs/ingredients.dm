//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//* INGREDIENTS SYSTEM - Check [code/__DEFINES/ingredients.dm] *//

/// Ingredients are specially formatted lists.
/// These procs allow standardized operations on them.
/// Make sure these sync to Ingredients.tsx

/**
 * checks an ingredients list and a list of selected ingredients against an items list
 *
 * @return is everything there?
 */
/proc/check_ingredients(list/ingredients, list/selection, list/obj/item/items)
	var/list/materials = list()
	var/list/reagents = list()
	var/list/stacks = list()
	for(var/i in 1 to length(ingredients))
		if(i > length(selection))
			break
		var/list/ingredient_list = ingredients[i]
		var/type = ingredient_list[INGREDIENT_DATA_TYPE]
		var/amt = ingredient_list[INGREDIENT_DATA_AMOUNT]
		var/selected = selection[i]
		switch(type)
			if(INGREDIENT_TYPE_MATERIAL)
				materials[selected] += amt
			if(INGREDIENT_TYPE_REAGENT)
				reagents[selected] += amt
			if(INGREDIENT_TYPE_STACK)
				stacks[selected] += amt
			if(INGREDIENT_TYPE_ITEM)
				var/obj/item/I = locate(selected) in items
				if(isnull(I))
					return FALSE
	// todo: reagents
	for(var/obj/item/I as anything in items)
		if(istype(I, /obj/item/stack))
			var/obj/item/stack/S = I
			if(istype(I, /obj/item/stack/material))
				var/obj/item/stack/material/M = S
				var/mat_id = M.material.id
				if(materials[mat_id])
					materials[mat_id] -= M.amount * SHEET_MATERIAL_AMOUNT
					if(materials[mat_id] <= 0)
						materials -= mat_id
			else
				if(stacks[S.type])
					stacks[S.type] -= S.amount
					if(stacks[S.type] <= 0)
						stacks -= S.type
	if(length(stacks) || length(materials)) // something wasn't consumed
		return FALSE
	return TRUE

/**
 * returns a list of things by key.
 * anything unkeyed gets deleted.
 *
 * @return list of data by key ; datatype depends on the ingredient type.
 */
/proc/use_ingredients(list/ingredients, list/selection, list/obj/item/items)
	. = list()
	var/list/materials = list()
	var/list/reagents = list()
	var/list/stacks = list()
	for(var/i in 1 to length(ingredients))
		if(i > length(selection))
			break
		var/list/ingredient_list = ingredients[i]
		var/type = ingredient_list[INGREDIENT_DATA_TYPE]
		var/amt = ingredient_list[INGREDIENT_DATA_AMOUNT]
		var/key = ingredient_list[INGREDIENT_DATA_KEY]
		var/selected = selection[i]
		switch(type)
			if(INGREDIENT_TYPE_MATERIAL)
				materials[selected] += amt
			if(INGREDIENT_TYPE_REAGENT)
				reagents[selected] += amt
			if(INGREDIENT_TYPE_STACK)
				stacks[selected] += amt
			if(INGREDIENT_TYPE_ITEM)
				var/obj/item/I = locate(selected) in items
				if(isnull(I))
					continue
				if(isnull(key))
					qdel(I)
				.[key] = I
	// todo: reagents
	for(var/obj/item/I as anything in items)
		if(istype(I, /obj/item/stack))
			var/obj/item/stack/S = I
			if(istype(I, /obj/item/stack/material))
				var/obj/item/stack/material/M = S
				var/mat_id = M.material.id
				if(materials[mat_id])
					var/used = M.use(materials[mat_id] / SHEET_MATERIAL_AMOUNT)
					materials[M.type] -= used * SHEET_MATERIAL_AMOUNT
					if(materials[M.type] <= 0)
						materials -= M.type
			else
				if(stacks[S.type])
					var/used = S.use(stacks[S.type])
					stacks[S.type] -= used
					if(stacks[S.type] <= 0)
						stacks -= S.type

/proc/ui_ingredients_needed(list/ingredients)
	return ingredients

/proc/ui_ingredients_available(list/obj/item/items)
	. = list()
	var/list/materials = list()
	var/list/material_lookup = list()
	var/list/reagents = list()
	var/list/reagent_lookup = list()
	var/list/stacks = list()
	var/list/stack_lookup = list()
	var/list/item_instances = list()
	var/list/mass_items = list()
	var/list/mass_item_lookup = list()

	for(var/obj/item/I as anything in items)
		if(istype(I, /obj/item/stack/material))
			var/obj/item/stack/material/M = I
			materials[M.material.id] += M.amount
			if(isnull(material_lookup[M.material.id]))
				material_lookup[M.material.id] = M.material.display_name || M.material.name
		else if(istype(I, /obj/item/stack))
			var/obj/item/stack/S = I
			stacks[S.type] += S.amount
			if(isnull(stack_lookup[S.type]))
				stack_lookup[S.type] = S.singular_name || S.name
		else if(I.item_flags & ITEM_MASS_INGREDIENT)
			mass_items[I.type] += 1
			if(isnull(mass_item_lookup[I.type]))
				mass_item_lookup[I.type] = I.name
		else
			item_instances[++item_instances.len] = list(
				"name" = I.name,
				"ref" = ref(I),
				"path" = I.type,
			)
		// todo: reagents

	return list(
		"materials" = materials,
		"materialLookup" = material_lookup,
		"reagents" = reagents,
		"reagentLookup" = reagent_lookup,
		"stacks" = stacks,
		"stackLookup" = stack_lookup,
		"items" = item_instances,
		"massItems" = mass_items,
		"massItemLookup" = mass_item_lookup,
	)
