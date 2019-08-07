/datum/admins/proc/auto_aghost_orbit(atom/target)
	if(!check_rights(R_EVENT|R_MOD|R_ADMIN|R_SERVER|R_EVENT))
		return
	var/client/C = usr.client
	if(!isobserver(usr))
		C.admin_ghost()
	var/mob/observer/dead/G = C.mob
	G.ManualFollow(target)

/datum/admins/proc/teleport_movable_atom(atom/movable/AM, atom/targetloc)
	var/message = "[owner == usr? "[key_name_admin(usr)]" : "[key_name_admin(usr)] (usr) [key_name_admin(owner)] owner"] teleported [AM]([REF(AM)]) to [targetloc]([ADMIN_COORDJMP(targetloc)])."
	log_admin(message)
	message_admins(message)
	AM.forceMove(targetloc)

/// Allow admin to add or remove traits of datum
/datum/admins/proc/modify_traits(datum/D)
	if(!D)
		return

	var/add_or_remove = input("Remove/Add?", "Trait Remove/Add") as null|anything in list("Add","Remove")
	if(!add_or_remove)
		return
	var/list/availible_traits = list()

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
	chosen_trait = availible_traits[chosen_trait]

	var/source = "adminabuse"
	switch(add_or_remove)
		if("Add") //Not doing source choosing here intentionally to make this bit faster to use, you can always vv it.
			ADD_TRAIT(D,chosen_trait,source)
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
			REMOVE_TRAIT(D,chosen_trait,source)
