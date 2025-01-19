GLOBAL_LIST_INIT(robot_modules, list(
	"Standard"		= /obj/item/robot_module/robot/standard,
	"Service" 		= /obj/item/robot_module/robot/clerical/butler,
	"Clerical" 		= /obj/item/robot_module/robot/clerical/general,
	"Research" 		= /obj/item/robot_module/robot/research,
	"Miner" 		= /obj/item/robot_module/robot/miner,
	"Medical" 		= /obj/item/robot_module/robot/medical/surgeon,
	"Security" 		= /obj/item/robot_module/robot/security/general,
	"Combat" 		= /obj/item/robot_module/robot/security/combat,
	"Engineering"	= /obj/item/robot_module/robot/engineering,
	"Janitor" 		= /obj/item/robot_module/robot/janitor,
	"Quadruped"		= /obj/item/robot_module/robot/quad/basic,
	"MediQuad"		= /obj/item/robot_module/robot/quad/medi,
	"SecuriQuad"	= /obj/item/robot_module/robot/quad/sec,
	"JaniQuad"		= /obj/item/robot_module/robot/quad/jani,
	"SciQuad"		= /obj/item/robot_module/robot/quad/sci,
	"EngiQuad"		= /obj/item/robot_module/robot/quad/engi,
	"Mining Quad"	= /obj/item/robot_module/robot/quad/miner,
	"Service Quad"	= /obj/item/robot_module/robot/quad/serv,
	"ERT"			= /obj/item/robot_module/robot/quad/ert
	))

/obj/item/robot_module
	name = "robot module"
	icon = 'icons/obj/module.dmi'
	icon_state = "std_module"
	w_class = WEIGHT_CLASS_HUGE
	item_state = "std_mod"
	var/channels = list()
	var/networks = list()
	var/sprites = list()

	var/languages = list(
		LANGUAGE_AKHANI = 0,
		LANGUAGE_BIRDSONG = 0,
		LANGUAGE_CANILUNZT = 0,
		LANGUAGE_DAEMON = 0,
		LANGUAGE_ECUREUILIAN = 0,
		LANGUAGE_ENOCHIAN = 0,
		LANGUAGE_GUTTER = 0,
		LANGUAGE_SAGARU = 0,
		LANGUAGE_SCHECHI = 0,
		LANGUAGE_SIIK = 0,
		LANGUAGE_SIGN = 0,
		LANGUAGE_SKRELLIAN = 0,
		LANGUAGE_SOL_COMMON = 1,
		LANGUAGE_TERMINUS = 1,
		LANGUAGE_TRADEBAND = 1,
		LANGUAGE_UNATHI = 0,
		LANGUAGE_ZADDAT = 0
		)

	var/list/subsystems = list()
	var/list/obj/item/robot_upgrade/supported_upgrades = list()

	// Bookkeeping
	var/list/original_languages = list()
	var/list/added_networks = list()

/obj/item/robot_module/Initialize(mapload)
	. = ..()
	var/mob/living/silicon/robot/R = loc
	R.module_legacy = src

	add_camera_networks(R)
	add_languages(R)
	add_subsystems(R)

	if(R.radio)
		if(R.shell)
			channels = R.mainframe.aiRadio.channels
		R.radio.recalculateChannels()

	handle_custom_item(R)

	R.set_module_sprites(sprites)

	// TODO: REFACTOR CYBORGS THEY ARE ALL SHITCODE
	INVOKE_ASYNC(R, TYPE_PROC_REF(/mob/living/silicon/robot, choose_icon), R.module_sprites.len + 1, R.module_sprites)

/obj/item/robot_module/proc/Reset(var/mob/living/silicon/robot/R)
	remove_camera_networks(R)
	remove_languages(R)
	remove_subsystems(R)

	if(R.radio)
		R.radio.recalculateChannels()

/// Get a list of all matter synths available to this module. Executes before handle_special_module_init.
/obj/item/robot_module/proc/get_synths(mob/living/silicon/robot/R)
	. = list()

/// Get a list of typepaths that should be put into the modules list.
/obj/item/robot_module/proc/get_modules()
	SHOULD_CALL_PARENT(TRUE)
	return list()

// This is for modules that need special handling, not just being added to the modules list.
/obj/item/robot_module/proc/handle_special_module_init(mob/living/silicon/robot/R)
	SHOULD_CALL_PARENT(TRUE)
	. = list()

/obj/item/robot_module/proc/handle_custom_item(mob/living/silicon/robot/R)
	return

/obj/item/robot_module/proc/add_languages(var/mob/living/silicon/robot/R)
	// Stores the languages as they were before receiving the module, and whether they could be synthezized.
	for(var/datum/prototype/language/language_datum in R.languages)
		original_languages[language_datum] = (language_datum in R.speech_synthesizer_langs)

	for(var/language in languages)
		R.add_language(language, languages[language])

/obj/item/robot_module/proc/remove_languages(var/mob/living/silicon/robot/R)
	// Clear all added languages, whether or not we originally had them.
	for(var/language in languages)
		R.remove_language(language)

	// Then add back all the original languages, and the relevant synthezising ability
	for(var/original_language in original_languages)
		R.add_language(original_language, original_languages[original_language])
	original_languages.Cut()

/obj/item/robot_module/proc/add_camera_networks(var/mob/living/silicon/robot/R)
	if(R.camera && (NETWORK_ROBOTS in R.camera.network))
		for(var/network in networks)
			if(!(network in R.camera.network))
				R.camera.add_network(network)
				added_networks |= network

/obj/item/robot_module/proc/remove_camera_networks(var/mob/living/silicon/robot/R)
	if(R.camera)
		R.camera.remove_networks(added_networks)
	added_networks.Cut()

/obj/item/robot_module/proc/add_subsystems(var/mob/living/silicon/robot/R)
	add_verb(R, subsystems)

/obj/item/robot_module/proc/remove_subsystems(var/mob/living/silicon/robot/R)
	remove_verb(R, subsystems)

/obj/item/robot_module/robot/quad/Initialize()
	. = ..()
	var/mob/living/silicon/robot/R = loc
	ASSERT(istype(R))

	R.dogborg = TRUE
	add_verb(R, list(
		/mob/living/silicon/robot/proc/rest_style
	))

/obj/item/robot_module/robot/quad/Reset(mob/living/silicon/robot/R)
	. = ..()
	// Reset a bunch of wideborg specific things.
	remove_verb(R, list(
		/mob/living/silicon/robot/proc/rest_style
	))
	R.scrubbing = FALSE
	R.dogborg = FALSE

#warn parse this crap
