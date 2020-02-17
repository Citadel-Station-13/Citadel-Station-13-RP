var/global/datum/global_init/init = new ()

/*
	Pre-map initialization stuff should go here.
*/
/datum/global_init/New()
	log_world("global init datum started")

	makeDatumRefLists()

	initialize_chemical_reagents()
	initialize_chemical_reactions()
	initialize_integrated_circuits_list()
	log_world("global init datum finished")
	qdel(src) //we're done

/datum/global_init/Destroy()
	global.init = null
	return 2 // QDEL_HINT_IWILLGC

/proc/load_configuration()
	config = new /datum/configuration_legacy()
	config_legacy.load("config/legacy/config.txt")
	config_legacy.load("config/legacy/game_options.txt","game_options")
	config_legacy.loadsql("config/legacy/dbconfig_legacy.txt")
	config_legacy.loadforumsql("config/legacy/forumdbconfig_legacy.txt")
