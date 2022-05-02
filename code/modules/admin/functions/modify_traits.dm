/// Allow admin to add or remove traits of datum
/datum/admins/proc/modify_traits(datum/D)
	if(!D)
		return

	var/add_or_remove = input("Remove/Add?", "Trait Remove/Add") as null|anything in list("Add","Remove")
	if(!add_or_remove)
		return
	var/list/availible_traits = list("Custom")

	switch(add_or_remove)
		if("Add")
			for(var/key in GLOB.traits_by_type)
				if(istype(D,key))
					availible_traits += GLOB.traits_by_type[key]
		if("Remove")
			if(!GLOB.trait_name_map)
				GLOB.trait_name_map = generate_trait_name_map()
			for(var/trait in D.status_traits)
				var/name = GLOB.trait_name_map[trait] || trait
				availible_traits[name] = trait

	var/chosen_trait = input("Select trait to modify", "Trait") as null|anything in availible_traits
	if(!chosen_trait)
		return
	if(chosen_trait != "Custom")
		chosen_trait = availible_traits[chosen_trait]

	var/source = ADMIN_TRAIT
	switch(add_or_remove)
		if("Add") //Not doing source choosing here intentionally to make this bit faster to use, you can always vv it.
			if(chosen_trait == "Custom")
				var/list/adding = list()
				do
					chosen_trait = input("Input trait string (CASE SENSITIVE)", "Custom Add") as text|null
					if(chosen_trait)
						adding += chosen_trait
				while(chosen_trait)
				ADD_TRAIT(D, adding, source)
			else
				ADD_TRAIT(D, chosen_trait, source)
		if("Remove")
			var/specific = input("All or specific source ?", "Trait Remove/Add") as null|anything in list("All","Specific")
			if(!specific)
				return
			switch(specific)
				if("All")
					source = null
				if("Specific")
					source = input("Source to be removed","Trait Remove/Add") as null|anything in D.status_traits[chosen_trait]
					if(!source)
						return
			if(chosen_trait == "Custom")
				var/list/adding = list()
				do
					chosen_trait = input("Input trait string (CASE SENSITIVE)", "Custom Remove") as text|null
					if(chosen_trait)
						adding += chosen_trait
				while(chosen_trait)
				REMOVE_TRAIT(D, adding, source)
			else
				REMOVE_TRAIT(D, chosen_trait, source)
