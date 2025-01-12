/datum/prototype/robot_module/nanotrasen/service
	use_robot_module_path = /obj/item/robot_module/robot/service
	allowed_frames = list(
	)

/datum/prototype/robot_module/nanotrasen/service/create_mounted_item_descriptors(list/normal_out, list/emag_out)
	..()
	if(normal_out)
		normal_out |= list(
			/obj/item/soap/nanotrasen,
			/obj/item/storage/bag/trash,
			/obj/item/gripper/service,
			/obj/item/reagent_containers/glass/bucket,
			/obj/item/reagent_containers/dropper/industrial,
			/obj/item/flame/lighter/zippo,
			/obj/item/reagent_containers/borghypo/service,
			/obj/item/material/minihoe,
			/obj/item/material/knife/machete/hatchet,
			/obj/item/plant_analyzer,
			/obj/item/storage/bag/plants,
			/obj/item/robot_harvester,
			/obj/item/material/knife,
			/obj/item/material/kitchen/rollingpin,
			/obj/item/pen/robopen,
			/obj/item/form_printer,
			/obj/item/gripper/paperwork,
			/obj/item/hand_labeler,
			/obj/item/stamp,
			/obj/item/stamp/denied,
			/obj/item/tray/robotray,
			/obj/item/rsf/loaded,
		)

/datum/prototype/robot_module/nanotrasen/service/provision_resource_store(datum/robot_resource_store/store)
	..()

/obj/item/robot_module/robot/clerical/butler/Initialize(mapload)
	. = ..()

	src.emag = new /obj/item/reagent_containers/food/drinks/bottle/small/beer(src)

	var/datum/reagent_holder/R = new/datum/reagent_holder(50)
	src.emag.reagents = R
	R.my_atom = src.emag
	R.add_reagent("beer2", 50)
	src.emag.name = "Mickey Finn's Special Brew"

#warn translate chassis below

/obj/item/robot_module/robot/clerical
	name = "service robot module"
	channels = list("Service" = 1)
	languages = list(
		LANGUAGE_AKHANI		= 1,
		LANGUAGE_BIRDSONG	= 1,
		LANGUAGE_CANILUNZT	= 1,
		LANGUAGE_DAEMON		= 1,
		LANGUAGE_EAL		= 1,
		LANGUAGE_ECUREUILIAN= 1,
		LANGUAGE_ENOCHIAN	= 1,
		LANGUAGE_GUTTER		= 1,
		LANGUAGE_ROOTLOCAL	= 0,
		LANGUAGE_SAGARU		= 1,
		LANGUAGE_SCHECHI	= 1,
		LANGUAGE_SIGN		= 0,
		LANGUAGE_SIIK		= 1,
		LANGUAGE_SKRELLIAN	= 1,
		LANGUAGE_SKRELLIANFAR = 0,
		LANGUAGE_SOL_COMMON	= 1,
		LANGUAGE_SQUEAKISH	= 1,
		LANGUAGE_TERMINUS	= 1,
		LANGUAGE_TRADEBAND	= 1,
		LANGUAGE_UNATHI		= 1,
		LANGUAGE_ZADDAT		= 1
	)

/obj/item/robot_module/robot/clerical/butler
	sprites = list(
		"M-USE Nanotrasen" = "robotServ",
		"Cabeiri" = "eyebot-standard",
		"Haruka" = "marinaSV",
		"Michiru" = "maidbot",
		"Usagi" = "tallgreen",
		"Telemachus" = "toiletbot",
		"WTOperator" = "sleekservice",
		"WTOmni" = "omoikane",
		"XI-GUS" = "spider",
		"XI-ALP" = "heavyServ",
		"Standard" = "Service2",
		"Waitress" = "Service",
		"Bro" = "Brobot",
		"Rich" = "maximillion",
		"Drone - Service" = "drone-service",
		"Drone - Hydro" = "drone-hydro",
		"Misato" = "tall2service",
		"L3P1-D0T" = "Glitterfly-Service",
		"Miss M" = "miss-service",
		"Handy - Service" = "handy-service",
		"Handy - Hydro" = "handy-hydro",
		"Acheron" = "mechoid-Service",
		"Shellguard Noble" = "Noble-SRV",
		"ZOOM-BA" = "zoomba-service",
		"W02M" = "worm-service"
	)

/obj/item/robot_module/robot/clerical/butler/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/reagent_containers/food/condiment/enzyme/E = locate() in src.modules
	E.reagents.add_reagent("enzyme", 2 * amount)
	if(src.emag)
		var/obj/item/reagent_containers/food/drinks/bottle/small/beer/B = src.emag
		B.reagents.add_reagent("beer2", 2 * amount)

/obj/item/robot_module/robot/clerical/general
	name = "clerical robot module"
	sprites = list(
		"M-USE Nanotrasen" = "robotCler",
		"Cabeiri" = "eyebot-standard",
		"Haruka" = "marinaSV",
		"Usagi" = "tallgreen",
		"Telemachus" = "toiletbot",
		"WTOperator" = "sleekclerical",
		"WTOmni" = "omoikane",
		"XI-GUS" = "spidercom",
		"XI-ALP" = "heavyServ",
		"Waitress" = "Service",
		"Bro" = "Brobot",
		"Rich" = "maximillion",
		"Default" = "Service2",
		"Drone" = "drone-blu",
		"Misato" = "tall2service",
		"L3P1-D0T" = "Glitterfly-Clerical",
		"Miss M" = "miss-service",
		"Handy" = "handy-clerk",
		"Acheron" = "mechoid-Service",
		"Shellguard Noble" = "Noble-SRV",
		"ZOOM-BA" = "zoomba-clerical",
		"W02M" = "worm-service"
	)

/obj/item/robot_module/robot/clerical/general/handle_special_module_init(mob/living/silicon/robot/R)
	. = ..()
	// cba to make emags support more than one item
	if (prob(50))
		src.emag = new /obj/item/stamp/chameleon(src)
	else
		src.emag = new /obj/item/pen/chameleon(src)

// Uses modified K9 sprites.
/obj/item/robot_module/robot/quad/serv
	name = "Service Quadruped module"
	sprites = list(
		"Blackhound" = "k50",
		"Pinkhound" = "k69",
		"ServicehoundV2" = "serve2",
		"ServicehoundV2 Darkmode" = "servedark",
		"F3-LINE" = "FELI-Service"
	)
	languages = list(
		LANGUAGE_AKHANI		= 1,
		LANGUAGE_BIRDSONG	= 1,
		LANGUAGE_CANILUNZT	= 1,
		LANGUAGE_DAEMON		= 1,
		LANGUAGE_EAL		= 1,
		LANGUAGE_ECUREUILIAN= 1,
		LANGUAGE_ENOCHIAN	= 1,
		LANGUAGE_GUTTER		= 1,
		LANGUAGE_ROOTLOCAL	= 0,
		LANGUAGE_SAGARU		= 1,
		LANGUAGE_SCHECHI	= 1,
		LANGUAGE_SIGN		= 0,
		LANGUAGE_SIIK		= 1,
		LANGUAGE_SKRELLIAN	= 1,
		LANGUAGE_SKRELLIANFAR = 0,
		LANGUAGE_SOL_COMMON	= 1,
		LANGUAGE_SQUEAKISH	= 1,
		LANGUAGE_TERMINUS	= 1,
		LANGUAGE_TRADEBAND	= 1,
		LANGUAGE_UNATHI		= 1,
		LANGUAGE_ZADDAT		= 1
	)
	channels = list("Service" = 1)
	can_be_pushed = 0

// In a nutshell, basicly service/butler robot but in dog form.
/obj/item/robot_module/robot/quad/serv/handle_special_module_init(mob/living/silicon/robot/R)
	. = ..()
	src.emag = new /obj/item/robot_builtin/dog_pounce(src)

	// These get a larger water synth.
	synths_by_kind[MATSYN_WATER]:max_energy = 1000

	var/obj/item/rsf/M = new /obj/item/rsf(src)
	M.stored_matter = 30
	. += M

	var/obj/item/flame/lighter/zippo/L = new /obj/item/flame/lighter/zippo(src)
	L.lit = 1
	. += L
