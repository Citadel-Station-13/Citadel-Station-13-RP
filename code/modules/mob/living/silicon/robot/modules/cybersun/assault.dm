GENERATE_ROBOT_MODULE_PRESET(/cybersun/assault)
/datum/prototype/robot_module/cybersun/assault
	use_robot_module_path = /obj/item/robot_module/robot/
	allowed_frames = list(
	)

/datum/prototype/robot_module/cybersun/assault/provision_resource_store(datum/robot_resource_store/store)
	..()

#warn translate chassis below

/obj/item/robot_module/robot/syndicate
	name = "illegal robot module"
	languages = list(
		LANGUAGE_SOL_COMMON = 1,
		LANGUAGE_TRADEBAND = 1,
		LANGUAGE_UNATHI = 0,
		LANGUAGE_SIIK	= 0,
		LANGUAGE_AKHANI = 0,
		LANGUAGE_SKRELLIAN = 0,
		LANGUAGE_SKRELLIANFAR = 0,
		LANGUAGE_ROOTLOCAL = 0,
		LANGUAGE_GUTTER = 1,
		LANGUAGE_SCHECHI = 0,
		LANGUAGE_EAL	 = 1,
		LANGUAGE_SIGN	 = 0,
		LANGUAGE_TERMINUS = 1,
		LANGUAGE_ZADDAT = 0
	)
	sprites = list(
		"Cerberus" = "syndie_bloodhound",
		"Cerberus - Treaded" = "syndie_treadhound",
		"Ares" = "squats",
		"Telemachus" = "toiletbotantag",
		"WTOperator" = "hosborg",
		"XI-GUS" = "spidersyndi",
		"XI-ALP" = "syndi-heavy"
	)
	var/id

// All syndie modules get these, and the base borg items (flash, crowbar, etc).
/obj/item/robot_module/robot/syndicate/get_modules()
	. = ..()
	. |= list(
		/obj/item/pinpointer/shuttle/merc,
		/obj/item/melee/transforming/energy/sword
	)

/obj/item/robot_module/robot/syndicate/handle_special_module_init(mob/living/silicon/robot/R)
	. = ..()
	var/jetpack = new/obj/item/tank/jetpack/carbondioxide(src)
	. += jetpack
	R.internals = jetpack

	id = R.idcard
	. += id

/obj/item/robot_module/robot/syndicate/Destroy()
	src.modules -= id
	id = null
	return ..()

// Gets a big shield and a gun that shoots really fast to scare the opposing force.
/obj/item/robot_module/robot/syndicate/protector
	name = "protector robot module"
	sprites = list(
		"Cerberus - Treaded" = "syndie_treadhound",
		"Cerberus" = "syndie_bloodhound",
		"Ares" = "squats",
		"XI-ALP" = "syndi-heavy"
	)

/obj/item/robot_module/robot/syndicate/protector/get_modules()
	. = ..()
	. |= list(
		/obj/item/shield_projector/rectangle/weak,
		/obj/item/gun/energy/dakkalaser,
		/obj/item/handcuffs/cyborg,
		/obj/item/melee/baton/robot
	)
