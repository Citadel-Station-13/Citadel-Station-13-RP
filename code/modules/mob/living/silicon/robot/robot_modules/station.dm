GLOBAL_LIST_INIT(robot_modules, list(
	"Standard"		= /obj/item/robot_module/robot/standard,
	"Service" 		= /obj/item/robot_module/robot/clerical/butler,
	"Clerical" 		= /obj/item/robot_module/robot/clerical/general,
	"Research" 		= /obj/item/robot_module/robot/research,
	"Miner" 		= /obj/item/robot_module/robot/miner,
	"Crisis" 		= /obj/item/robot_module/robot/medical/crisis,
	"Surgeon" 		= /obj/item/robot_module/robot/medical/surgeon,
	"Security" 		= /obj/item/robot_module/robot/security/general,
	"Combat" 		= /obj/item/robot_module/robot/security/combat,
	"Engineering"	= /obj/item/robot_module/robot/engineering/general,
//	"Construction"	= /obj/item/robot_module/robot/engineering/construction,
	"Janitor" 		= /obj/item/robot_module/robot/janitor,
	"Medihound"		= /obj/item/robot_module/robot/medihound,
	"K9"		= /obj/item/robot_module/robot/knine,
	"ERT"		= /obj/item/robot_module/robot/ert,
	"Janihound"		= /obj/item/robot_module/robot/scrubpup,
	"Sci-Hound"		= /obj/item/robot_module/robot/science,
	"Pupdozer"		= /obj/item/robot_module/robot/engiedog,
	"Service-Hound"		= /obj/item/robot_module/robot/clerical/brodog
	))

/obj/item/robot_module
	name = "robot module"
	icon = 'icons/obj/module.dmi'
	icon_state = "std_module"
	w_class = ITEMSIZE_NO_CONTAINER
	item_state = "std_mod"
	var/hide_on_manifest = 0
	var/channels = list()
	var/networks = list()
	var/vr_sprites = list()
	languages = list(LANGUAGE_SOL_COMMON= 1,
					LANGUAGE_TRADEBAND	= 1,
					LANGUAGE_UNATHI		= 0,
					LANGUAGE_SIIK		= 0,
					LANGUAGE_SKRELLIAN	= 0,
					LANGUAGE_GUTTER		= 0,
					LANGUAGE_SCHECHI	= 0,
					LANGUAGE_SIGN		= 0,
					LANGUAGE_BIRDSONG	= 0,
					LANGUAGE_SAGARU		= 0,
					LANGUAGE_CANILUNZT	= 0,
					LANGUAGE_ECUREUILIAN= 0,
					LANGUAGE_DAEMON		= 0,
					LANGUAGE_ENOCHIAN	= 0
					)
	var/sprites = list()
	var/can_be_pushed = 1
	var/no_slip = 0
	var/list/modules = list()
	var/list/datum/matter_synth/synths = list()
	var/obj/item/emag = null
	var/obj/item/borg/upgrade/jetpack = null
	var/obj/item/borg/upgrade/advhealth = null
	var/list/subsystems = list()
	var/list/obj/item/borg/upgrade/supported_upgrades = list()

	// Bookkeeping
	var/list/original_languages = list()
	var/list/added_networks = list()

/obj/item/robot_module/New(var/mob/living/silicon/robot/R)
	..()
	R.module = src

	add_camera_networks(R)
	add_languages(R)
	add_subsystems(R)
	apply_status_flags(R)

	if(R.radio)
		if(R.shell)
			channels = R.mainframe.aiRadio.channels
		R.radio.recalculateChannels()

	vr_add_sprites() // For vorestation only sprites

	R.set_module_sprites(sprites)
	R.choose_icon(R.module_sprites.len + 1, R.module_sprites)

	for(var/obj/item/I in modules)
		I.canremove = 0

/obj/item/robot_module/proc/Reset(var/mob/living/silicon/robot/R)
	remove_camera_networks(R)
	remove_languages(R)
	remove_subsystems(R)
	remove_status_flags(R)

	if(R.radio)
		R.radio.recalculateChannels()
	R.choose_icon(0, R.set_module_sprites(list("Default" = "robot")))

/obj/item/robot_module/Destroy()
	for(var/module in modules)
		qdel(module)
	for(var/synth in synths)
		qdel(synth)
	modules.Cut()
	synths.Cut()
	qdel(emag)
	qdel(jetpack)
	emag = null
	jetpack = null
	return ..()

/obj/item/robot_module/emp_act(severity)
	if(modules)
		for(var/obj/O in modules)
			O.emp_act(severity)
	if(emag)
		emag.emp_act(severity)
	if(synths)
		for(var/datum/matter_synth/S in synths)
			S.emp_act(severity)
	..()
	return

/obj/item/robot_module/proc/respawn_consumable(var/mob/living/silicon/robot/R, var/rate)
	if(!synths || !synths.len)
		return

	for(var/datum/matter_synth/T in synths)
		T.add_charge(T.recharge_rate * rate)

/obj/item/robot_module/proc/rebuild()//Rebuilds the list so it's possible to add/remove items from the module
	var/list/temp_list = modules
	modules = list()
	for(var/obj/O in temp_list)
		if(O)
			modules += O

/obj/item/robot_module/proc/add_languages(var/mob/living/silicon/robot/R)
	// Stores the languages as they were before receiving the module, and whether they could be synthezized.
	for(var/datum/language/language_datum in R.languages)
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
	R.verbs |= subsystems

/obj/item/robot_module/proc/remove_subsystems(var/mob/living/silicon/robot/R)
	R.verbs -= subsystems

/obj/item/robot_module/proc/apply_status_flags(var/mob/living/silicon/robot/R)
	if(!can_be_pushed)
		R.status_flags &= ~CANPUSH

/obj/item/robot_module/proc/remove_status_flags(var/mob/living/silicon/robot/R)
	if(!can_be_pushed)
		R.status_flags |= CANPUSH

// Cyborgs (non-drones), default loadout. This will be given to every module.
/obj/item/robot_module/robot/New()
	..()
	src.modules += new /obj/item/flash/robot(src)
	src.modules += new /obj/item/tool/crowbar/cyborg(src)
	src.modules += new /obj/item/extinguisher(src)
	src.modules += new /obj/item/gps/robot(src)
