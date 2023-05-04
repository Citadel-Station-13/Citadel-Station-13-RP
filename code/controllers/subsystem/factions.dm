SUBSYSTEM_DEF(factions)
	name = "Factions"
	subsystem_flags = SS_NO_FIRE
	init_order = INIT_ORDER_FACTIONS

	/// all factions by id
	var/list/factions = list()

/datum/controller/subsystem/factions/Initialize()
	initialize_factions()
	return ..()

/datum/controller/subsystem/factions/Recover()
	if(isnull(SSfactions))
		..()
		return FALSE
	. = ..()
	if(islist(SSfactions.factions))
		factions = SSfactions.factions
		for(var/id in factions)
			if(!id)
				factions -= id
				. = FALSE
			var/datum/faction/faction = factions[id]
			if(!istype(faction))
				factions -= id
				. = FALSE
	else
		. = FALSE

/datum/controller/subsystem/factions/proc/initialize_factions()
	if(islist(factions))
		QDEL_LIST(factions)
	factions = list()
	for(var/datum/faction/path as anything in subtypesof(/datum/faction))
		if(path == initial(path.abstract_type))
			continue
		var/datum/faction/F = new path
		if(!F.register())
			qdel(F)
