/obj/item/robot_module_legacy
	var/channels = list()
	var/networks = list()

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

	// Bookkeeping
	var/list/original_languages = list()
	var/list/added_networks = list()

/obj/item/robot_module_legacy/Initialize(mapload)
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

/obj/item/robot_module_legacy/proc/Reset(var/mob/living/silicon/robot/R)
	remove_camera_networks(R)
	remove_languages(R)
	remove_subsystems(R)

	if(R.radio)
		R.radio.recalculateChannels()

/obj/item/robot_module_legacy/proc/add_languages(var/mob/living/silicon/robot/R)
	// Stores the languages as they were before receiving the module, and whether they could be synthezized.
	for(var/datum/prototype/language/language_datum in R.languages)
		original_languages[language_datum] = (language_datum in R.speech_synthesizer_langs)

	for(var/language in languages)
		R.add_language(language, languages[language])

/obj/item/robot_module_legacy/proc/remove_languages(var/mob/living/silicon/robot/R)
	// Clear all added languages, whether or not we originally had them.
	for(var/language in languages)
		R.remove_language(language)

	// Then add back all the original languages, and the relevant synthezising ability
	for(var/original_language in original_languages)
		R.add_language(original_language, original_languages[original_language])
	original_languages.Cut()

/obj/item/robot_module_legacy/proc/add_camera_networks(var/mob/living/silicon/robot/R)
	if(R.camera && (NETWORK_ROBOTS in R.camera.network))
		for(var/network in networks)
			if(!(network in R.camera.network))
				R.camera.add_network(network)
				added_networks |= network

/obj/item/robot_module_legacy/proc/remove_camera_networks(var/mob/living/silicon/robot/R)
	if(R.camera)
		R.camera.remove_networks(added_networks)
	added_networks.Cut()

/obj/item/robot_module_legacy/proc/add_subsystems(var/mob/living/silicon/robot/R)
	add_verb(R, subsystems)

/obj/item/robot_module_legacy/proc/remove_subsystems(var/mob/living/silicon/robot/R)
	remove_verb(R, subsystems)
