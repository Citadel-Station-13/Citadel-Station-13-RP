//* INGREDIENTS SYSTEM - Check [code/__DEFINES/ingredients.dm] *//

/// Ingredients are specially formatted lists.
/// These procs allow standardized operations on them.
/// Make sure these sync to Ingredients.tsx

/proc/check_ingredients(list/ingredients, list/selection, list/obj/item/items)
	#warn impl

/proc/use_ingredients(list/ingredients, list/selection, list/obj/item/items)
	#warn impl

/proc/ui_ingredients_needed(list/ingredients)
	return ingredients

/proc/ui_ingredients_available(list/obj/item/items)
	. = list()
	var/list/materials = (.["materials"] = list())
	var/list/material_lookup = (.["materialLookup"] = list())
	var/list/reagents = (.["reagents"] = list())
	var/list/reagent_lookup = (.["reagentLookup"] = list())
	var/list/stacks = (.["stacks"] = list())
	var/list/stack_lookup = (.["stackLookup"] = list())
	var/list/items = (.["items"] = list())

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
		else
			items[++items.len] = list(
				"name" = I.name,
				"ref" = ref(I),
				"path" = I.type,
			)
		// todo: reagents
