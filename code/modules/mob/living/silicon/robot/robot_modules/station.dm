GLOBAL_LIST_INIT(robot_modules, list(
	"Standard"		= /obj/item/robot_module/robot/standard,
	"Service" 		= /obj/item/robot_module/robot/clerical/butler,
	"Clerical" 		= /obj/item/robot_module/robot/clerical/general,
	"Research" 		= /obj/item/robot_module/robot/research,
	"Miner" 		= /obj/item/robot_module/robot/miner,
	"Medical" 		= /obj/item/robot_module/robot/medical/surgeon,
	"Security" 		= /obj/item/robot_module/robot/security/general,
	"Combat" 		= /obj/item/robot_module/robot/security/combat,
	"Engineering"	= /obj/item/robot_module/robot/engineering/general,
//	"Construction"	= /obj/item/robot_module/robot/engineering/construction,
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
	w_class = ITEMSIZE_NO_CONTAINER
	item_state = "std_mod"
	var/hide_on_manifest = 0
	var/channels = list()
	var/networks = list()
	var/sprites = list()
	var/can_be_pushed = 1
	var/no_slip = 0
	/// Affects emotes.
	var/is_the_law = FALSE
	/// Enables a verb.
	var/can_shred = FALSE

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

	var/list/modules = list()
	var/list/datum/matter_synth/synths = list()
	var/list/synths_by_kind = list()
	var/obj/item/emag = null
	var/obj/item/borg/upgrade/jetpack = null
	var/obj/item/borg/upgrade/advhealth = null
	var/list/subsystems = list()
	var/list/obj/item/borg/upgrade/supported_upgrades = list()

	// Bookkeeping
	var/list/original_languages = list()
	var/list/added_networks = list()

/obj/item/robot_module/Initialize(mapload)
	. = ..()
	var/mob/living/silicon/robot/R = loc
	R.module = src

	add_camera_networks(R)
	add_languages(R)
	add_subsystems(R)
	apply_status_flags(R)

	if(R.radio)
		if(R.shell)
			channels = R.mainframe.aiRadio.channels
		R.radio.recalculateChannels()

	handle_custom_item(R)

	R.set_module_sprites(sprites)

	// TODO: REFACTOR CYBORGS THEY ARE ALL SHITCODE
	INVOKE_ASYNC(R, TYPE_PROC_REF(/mob/living/silicon/robot, choose_icon), R.module_sprites.len + 1, R.module_sprites)

	// Setup synths, modules, and modules with custom init code.
	synths_by_kind = get_synths(R)
	for (var/key in synths_by_kind)
		synths += synths_by_kind[key]

	for (var/entry in get_modules())
		modules += new entry(src)

	for (var/thing in handle_special_module_init(R))
		modules += thing

	for(var/obj/item/I in modules)
		ADD_TRAIT(I, TRAIT_ITEM_NODROP, CYBORG_MODULE_TRAIT)

/obj/item/robot_module/proc/Reset(var/mob/living/silicon/robot/R)
	remove_camera_networks(R)
	remove_languages(R)
	remove_subsystems(R)
	remove_status_flags(R)

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

/obj/item/robot_module/Destroy()
	for(var/module in modules)
		qdel(module)
	for(var/synth in synths)
		qdel(synth)
	modules.Cut()
	synths.Cut()
	synths_by_kind = null
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
	add_verb(R, subsystems)

/obj/item/robot_module/proc/remove_subsystems(var/mob/living/silicon/robot/R)
	remove_verb(R, subsystems)

/obj/item/robot_module/proc/apply_status_flags(var/mob/living/silicon/robot/R)
	if(!can_be_pushed)
		R.status_flags &= ~STATUS_CAN_PUSH

/obj/item/robot_module/proc/remove_status_flags(var/mob/living/silicon/robot/R)
	if(!can_be_pushed)
		R.status_flags |= STATUS_CAN_PUSH

/// This is different from the dogborg or wideborg vars -- this is specifically if the module is a *dog* - if it should be able to do dog things like bark.
/obj/item/robot_module/proc/is_dog()
	return FALSE

/obj/item/robot_module/robot/get_modules()
	. = ..()
	// Common items that all modules have.
	. |= list(
		/obj/item/flash/robot,
		/obj/item/tool/crowbar/cyborg,
		/obj/item/extinguisher,
		/obj/item/gps/robot
	)

/obj/item/robot_module/robot/quad

/obj/item/robot_module/robot/quad/Initialize()
	. = ..()
	var/mob/living/silicon/robot/R = loc
	ASSERT(istype(R))

	R.icon = 'icons/mob/robots_wide.dmi'
	R.set_base_pixel_x(-16)
	R.dogborg = TRUE
	R.wideborg = TRUE
	R.icon_x_dimension = 64
	add_verb(R, list(
		/mob/living/silicon/robot/proc/ex_reserve_refill,
		/mob/living/silicon/robot/proc/rest_style
	))
	if (can_shred)
		add_verb(R, TYPE_PROC_REF(/mob/living, shred_limb))

/obj/item/robot_module/robot/quad/Reset(mob/living/silicon/robot/R)
	. = ..()
	// Reset a bunch of wideborg specific things.
	R.pixel_x = initial(R.pixel_x)
	R.pixel_y = initial(R.pixel_y)
	R.icon = initial(R.icon)
	R.base_pixel_x = initial(R.pixel_x)
	remove_verb(R, list(
		/mob/living/silicon/robot/proc/ex_reserve_refill,
		/mob/living/proc/shred_limb,
		/mob/living/silicon/robot/proc/rest_style
	))
	R.scrubbing = FALSE
	R.dogborg = FALSE
	R.wideborg = FALSE

/obj/item/robot_module/robot/quad/get_modules()
	. = ..()
	. |= list(
		/obj/item/dogborg/boop_module //Boop people on the nose.
	)

/obj/item/robot_module/robot/quad/get_synths(mob/living/silicon/robot/R)
	. = ..()
	var/datum/matter_synth/water = new /datum/matter_synth(500)
	water.name = "Water reserves"
	water.recharge_rate = 0
	R.water_res = water
	.[MATSYN_WATER] = water

/obj/item/robot_module/robot/quad/handle_special_module_init(mob/living/silicon/robot/R)
	. = ..()

	var/obj/item/dogborg/tongue/T = new /obj/item/dogborg/tongue(src)
	T.water = synths_by_kind[MATSYN_WATER]
	. += T

/obj/item/robot_module/robot/quad/is_dog()
	var/mob/living/silicon/robot/R = loc
	ASSERT(istype(R))
	// This is the only non-canid dogborg type right now.
	return R.icontype != "F3-LINE"

// Custom sprite stuff. There's a dedicated system for this, not sure why this is done separately.

/obj/item/robot_module/robot/quad/engi/handle_custom_item(mob/living/silicon/robot/R)
	. = ..()
	if (R.client?.ckey == "nezuli")
		sprites["Alina"] = "alina-eng"

/obj/item/robot_module/robot/quad/medi/handle_custom_item(mob/living/silicon/robot/R)
	. = ..()
	if (R.client?.ckey == "nezuli")
		sprites["Alina"] = "alina-med"

/obj/item/robot_module/robot/quad/sec/handle_custom_item(mob/living/silicon/robot/R)
	. = ..()
	if (R.client?.ckey == "nezuli")
		sprites["Alina"] = "alina-sec"
