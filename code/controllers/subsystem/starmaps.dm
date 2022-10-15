SUBSYSTEM_DEF(starmaps)
	name = "Starmaps"
	subsystem_flags = SS_NO_FIRE
	init_order = INIT_ORDER_STARMAPS

	/// the core galaxy lore map
	var/datum/starmap/galaxy

/datum/controller/subsystem/starmaps/Initialize()
	build_static()
	return ..()

/datum/controller/subsystem/starmaps/proc/build_static()
	galaxy = new /datum/starmap/loremap
	galaxy.Initialize()
