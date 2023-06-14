SUBSYSTEM_DEF(legacy_lore)
	name = "Loremaster (Legacy)"
	init_order = INIT_ORDER_LEGACY_LORE

	var/list/organizations = list()

/datum/controller/subsystem/legacy_lore/Initialize()
	var/list/paths = subtypesof(/datum/lore/organization)
	for(var/path in paths)
		// Some intermediate paths are not real organizations (ex. /datum/lore/organization/mil). Only do ones with names
		var/datum/lore/organization/instance = path
		if(initial(instance.name))
			instance = new path()
			organizations[path] = instance
	return ..()
