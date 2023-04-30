//* INGREDIENTS SYSTEM - Check [code/__DEFINES/ingredients.dm] *//

/// Ingredients are specially formatted lists.
/// These procs allow standardized operations on them.
/// Make sure these sync to Ingredients.tsx

/**
 * checks an ingredients list and a list of selected ingredients against an items list
 *
 *
 */
/proc/check_ingredients(list/ingredients, list/selection, list/obj/item/items)
	#warn impl

/proc/use_ingredients(list/ingredients, list/selection, list/obj/item/items)
	#warn impl

/proc/ui_ingredients_needed(list/ingredients)
	return ingredients

/proc/ui_ingredients_available(list/obj/item/items)
	. = list()
	var/list/materials = list()
	var/list/materials = list()
	var/list/material_lookup = list()
	var/list/reagents = list()
	var/list/reagent_lookup = list()
	var/list/stacks = list()
	var/list/stack_lookup = list()
	var/list/items = list()
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
			items[++items.len] = list(
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
		"items" = items,
		"massItems" = mass_items,
		"massItemLookup" = mass_item_lookup,
	)
