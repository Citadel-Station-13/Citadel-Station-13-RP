SUBSYSTEM_DEF(lore)
	name = "Lore"
	init_order = INIT_ORDER_LORE
	flags = SS_NO_FIRE

	var/list/lore_info_by_name = list()
	var/list/lore_info_by_path = list()
	var/list/tagged_info =       list()

/datum/controller/subsystem/lore/proc/get_all_entries_tagged_with(var/token)
	return tagged_info[token]

/datum/controller/subsystem/lore/Initialize(timeofday)
	. = ..()
	for(var/ftype in typesof(/datum/lore_info))
		var/datum/lore_info/lore = ftype
		if(!initial(lore.name))
			continue
		lore = new lore
		if(lore_info_by_name[lore.name])
			crash_with("Duplicate cultural datum ID - [lore.name] - [ftype]")
		lore_info_by_name[lore.name] = lore
		lore_info_by_path[ftype] = lore
		if(lore.category && !lore.hidden)
			if(!tagged_info[lore.category])
				tagged_info[lore.category] = list()
			var/list/tag_list = tagged_info[lore.category]
			tag_list[lore.name] = lore

/datum/controller/subsystem/lore/proc/get_lore(var/lore_ident)
	return lore_info_by_name[lore_ident] ? lore_info_by_name[lore_ident] : lore_info_by_path[lore_ident]
