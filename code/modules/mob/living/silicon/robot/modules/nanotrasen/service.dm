GENERATE_ROBOT_MODULE_PRESET(/nanotrasen/service)
/datum/prototype/robot_module/nanotrasen/service
	id = "nt-service"
	use_robot_module_path = /obj/item/robot_module/robot/clerical
	light_color = "#6AED63"
	allowed_frames = list(
		/datum/robot_frame{
			name = "M-USE (Nanotrasen)";
			robot_chassis = /datum/prototype/robot_chassis/baseline;
			robot_iconset = /datum/prototype/robot_iconset/baseline_standard/service;
		},
		/datum/robot_frame{
			name = "M-USE (Nanotrasen) - Clerical";
			robot_chassis = /datum/prototype/robot_chassis/baseline;
			robot_iconset = /datum/prototype/robot_iconset/baseline_standard/clerical;
		},
		/datum/robot_frame{
			name = "Cabeiri";
			robot_chassis = /datum/prototype/robot_chassis/baseline;
			robot_iconset = /datum/prototype/robot_iconset/hover_eyebot/standard;
		},
		/datum/robot_frame{
			name = "Canine - Pinkhound";
			robot_chassis = /datum/prototype/robot_chassis/quadruped/canine;
			robot_iconset = /datum/prototype/robot_iconset/dog_k9/pink;
		},
		/datum/robot_frame{
			name = "Canine - Blackhound";
			robot_chassis = /datum/prototype/robot_chassis/quadruped/canine;
			robot_iconset = /datum/prototype/robot_iconset/dog_k9/grey;
		},
		/datum/robot_frame{
			name = "Canine - Hound";
			robot_chassis = /datum/prototype/robot_chassis/quadruped/canine;
			robot_iconset = /datum/prototype/robot_iconset/dog_vale/service;
		},
		/datum/robot_frame{
			name = "Canine - Hound V2";
			robot_chassis = /datum/prototype/robot_chassis/quadruped/canine;
			robot_iconset = /datum/prototype/robot_iconset/dog_vale/service_dark;
		},
		/datum/robot_frame{
			name = "F3-LINE";
			robot_chassis = /datum/prototype/robot_chassis/quadruped/feline;
			robot_iconset = /datum/prototype/robot_iconset/cat_feli/service;
		},
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
			/obj/item/reagent_containers/food/condiment/enzyme,
		)
	if(emag_out)
		emag_out |= list(
			/obj/item/stamp/chameleon,
			/obj/item/pen/chameleon,
		)

/datum/prototype/robot_module/nanotrasen/service/provision_resource_store(datum/robot_resource_store/store)
	..()

/datum/prototype/robot_module/nanotrasen/service/legacy_custom_regenerate_resources(mob/living/silicon/robot/robot, dt, multiplier)
	var/obj/item/reagent_containers/food/condiment/enzyme/E = locate() in robot
	E.reagents.add_reagent("enzyme", 2 * multiplier * dt)


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

/obj/item/robot_module/robot/clerical/general
	name = "clerical robot module"
	sprites = list(
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

// In a nutshell, basicly service/butler robot but in dog form.
/obj/item/robot_module/robot/quad/serv/handle_special_module_init(mob/living/silicon/robot/R)
	. = ..()

	// These get a larger water synth.
	synths_by_kind[MATSYN_WATER]:max_energy = 1000
