SUBSYSTEM_DEF(lore)
	name = "Lore"
	init_order = INIT_ORDER_LORE
	flags = SS_NO_FIRE

	var/list/lore_info_by_name = list()
	var/list/lore_info_by_path = list()
	var/list/tagged_info = list()

/datum/controller/subsystem/lore/proc/get_all_entries_tagged_with(var/token)
	return tagged_info[token]

/datum/controller/subsystem/lore/Initialize(timeofday)
	. = ..()
	for(var/ftype in typesof(/decl/lore_info)-/decl/lore_info)
		var/decl/lore_info/culture = ftype
		if(!initial(culture.name))
			continue
		culture = new culture
		if(lore_info_by_name[culture.name])
			crash_with("Duplicate cultural datum ID - [culture.name] - [ftype]")
		lore_info_by_name[culture.name] = culture
		lore_info_by_path[ftype] = culture
		if(culture.category && !culture.hidden)
			if(!tagged_info[culture.category])
				tagged_info[culture.category] = list()
			var/list/tag_list = tagged_info[culture.category]
			tag_list[culture.name] = culture

/datum/controller/subsystem/lore/proc/get_culture(var/culture_ident)
	return lore_info_by_name[culture_ident] ? lore_info_by_name[culture_ident] : lore_info_by_path[culture_ident]
