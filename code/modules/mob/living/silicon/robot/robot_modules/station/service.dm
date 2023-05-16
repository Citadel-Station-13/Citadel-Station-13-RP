/obj/item/robot_module/robot/janitor
	name = "janitorial robot module"
	channels = list("Service" = 1)
	sprites = list(
		"M-USE NanoTrasen" = "robotJani",
		"Arachne" = "crawler",
		"Cabeiri" = "eyebot-janitor",
		"Haruka" = "marinaJN",
		"Telemachus" = "toiletbotjanitor",
		"WTOperator" = "sleekjanitor",
		"XI-ALP" = "heavyRes",
		"Basic" = "JanBot2",
		"Mopbot"  = "janitorrobot",
		"Mop Gear Rex" = "mopgearrex",
		"Drone" = "drone-janitor",
		"Misato" = "tall2janitor",
		"L3P1-D0T" = "Glitterfly-Janitor",
		"Miss M" = "miss-janitor",
		"Cleriffin" = "coffin-Clerical",
		"Coffstodial" = "coffin-Custodial",
		"Handy" = "handy-janitor",
		"Acheron" = "mechoid-Janitor",
		"Shellguard Noble" = "Noble-CLN",
		"ZOOM-BA" = "zoomba-janitor",
		"W02M" = "worm-janitor"
	)

/obj/item/robot_module/robot/janitor/get_modules()
	. = ..()
	. |= list(
		/obj/item/soap/nanotrasen,
		/obj/item/storage/bag/trash,
		/obj/item/mop,
		/obj/item/lightreplacer
	)

/obj/item/robot_module/robot/janitor/handle_special_module_init(mob/living/silicon/robot/R)
	. = ..()
	src.emag = new /obj/item/reagent_containers/spray(src)
	src.emag.reagents.add_reagent("lube", 250)
	src.emag.name = "Lube spray"

/obj/item/robot_module/robot/janitor/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/lightreplacer/LR = locate() in src.modules
	LR.Charge(R, amount)
	if(src.emag)
		var/obj/item/reagent_containers/spray/S = src.emag
		S.reagents.add_reagent("lube", 2 * amount)

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
		"M-USE NanoTrasen" = "robotServ",
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

/obj/item/robot_module/robot/clerical/butler/Initialize(mapload)
	. = ..()
	src.modules += new /obj/item/gripper/service(src)
	src.modules += new /obj/item/reagent_containers/glass/bucket(src)
	src.modules += new /obj/item/material/minihoe(src)
	src.modules += new /obj/item/material/knife/machete/hatchet(src)
	src.modules += new /obj/item/analyzer/plant_analyzer(src)
	src.modules += new /obj/item/storage/bag/plants(src)
	src.modules += new /obj/item/robot_harvester(src)
	src.modules += new /obj/item/material/knife(src)
	src.modules += new /obj/item/material/kitchen/rollingpin(src)
	src.modules += new /obj/item/multitool(src) //to freeze trays

	var/obj/item/rsf/M = new /obj/item/rsf(src)
	M.stored_matter = 30
	src.modules += M

	src.modules += new /obj/item/reagent_containers/dropper/industrial(src)

	var/obj/item/flame/lighter/zippo/L = new /obj/item/flame/lighter/zippo(src)
	L.lit = 1
	src.modules += L

	src.modules += new /obj/item/tray/robotray(src)
	src.modules += new /obj/item/reagent_containers/borghypo/service(src)
	src.emag = new /obj/item/reagent_containers/food/drinks/bottle/small/beer(src)

	var/datum/reagents/R = new/datum/reagents(50)
	src.emag.reagents = R
	R.my_atom = src.emag
	R.add_reagent("beer2", 50)
	src.emag.name = "Mickey Finn's Special Brew"

/obj/item/robot_module/robot/clerical/butler/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/reagent_containers/food/condiment/enzyme/E = locate() in src.modules
	E.reagents.add_reagent("enzyme", 2 * amount)
	if(src.emag)
		var/obj/item/reagent_containers/food/drinks/bottle/small/beer/B = src.emag
		B.reagents.add_reagent("beer2", 2 * amount)

/obj/item/robot_module/robot/clerical/general
	name = "clerical robot module"
	sprites = list(
		"M-USE NanoTrasen" = "robotCler",
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

/obj/item/robot_module/robot/clerical/general/get_modules()
	. = ..()
	. |= list(
		/obj/item/pen/robopen,
		/obj/item/form_printer,
		/obj/item/gripper/paperwork,
		/obj/item/hand_labeler,
		/obj/item/stamp,
		/obj/item/stamp/denied
	)

/obj/item/robot_module/robot/clerical/general/handle_special_module_init(mob/living/silicon/robot/R)
	. = ..()
	// cba to make emags support more than one item
	if (prob(50))
		src.emag = new /obj/item/stamp/chameleon(src)
	else
		src.emag = new /obj/item/pen/chameleon(src)

/obj/item/robot_module/robot/quad/jani
	name = "JaniQuad module"
	sprites = list(
		"Custodial Hound" = "scrubpup",
		"Borgi" = "borgi-jani",
		"Otieborg" = "otiej",
		"Janihound, J9" = "J9",
		"F3-LINE" = "FELI-Janitor",
		"Drake" = "drakejanit"
	)
	channels = list("Service" = 1)
	can_be_pushed = 0
	can_shred = TRUE

/obj/item/robot_module/robot/quad/jani/get_modules()
	. = ..()
	. |= list(
		/obj/item/dogborg/jaws/small,
		/obj/item/pupscrubber
	)

/obj/item/robot_module/robot/quad/jani/get_synths()
	. = ..()
	//Starts empty. Can only recharge with recycled material.
	.[MATSYN_METAL] = new /datum/matter_synth/metal {
		name = "Steel reserves";
		recharge_rate = 0;
		max_energy = 50000;
		energy = 0;
	}

	.[MATSYN_GLASS] = new /datum/matter_synth/glass {
		name = "Glass reserves";
		recharge_rate = 0;
		max_energy = 50000;
		energy = 0;
	}

/obj/item/robot_module/robot/quad/jani/handle_special_module_init(mob/living/silicon/robot/R)
	. = ..()

	src.emag = new /obj/item/dogborg/pounce(src) //Pounce

	var/obj/item/lightreplacer/dogborg/LR = new /obj/item/lightreplacer/dogborg(src)
	LR.glass = synths_by_kind[MATSYN_GLASS]
	. += LR

	var/obj/item/dogborg/sleeper/compactor/C = new /obj/item/dogborg/sleeper/compactor(src)
	C.metal = synths_by_kind[MATSYN_METAL]
	C.glass = synths_by_kind[MATSYN_GLASS]
	C.water = synths_by_kind[MATSYN_WATER]
	. += C

	//Sheet refiners can only produce raw sheets.
	var/obj/item/stack/material/cyborg/steel/M = new (src)
	M.name = "steel recycler"
	M.desc = "A device that refines recycled steel into sheets."
	M.synths = list(synths_by_kind[MATSYN_METAL])
	M.recipes = list(
		new/datum/stack_recipe("steel sheet", /obj/item/stack/material/steel, 1, 1, 20)
	)
	. += M

	var/obj/item/stack/material/cyborg/glass/G = new (src)
	G.name = "glass recycler"
	G.desc = "A device that refines recycled glass into sheets."
	G.allow_window_autobuild = FALSE
	G.synths = list(synths_by_kind[MATSYN_GLASS])
	G.recipes = list(
		new/datum/stack_recipe("glass sheet", /obj/item/stack/material/glass, 1, 1, 20)
	)
	. += G

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

/obj/item/robot_module/robot/quad/serv/get_modules()
	. = ..()
	. |= list(
		/obj/item/gripper/service,
		/obj/item/reagent_containers/glass/bucket,
		/obj/item/material/minihoe,
		/obj/item/material/knife/machete/hatchet,
		/obj/item/analyzer/plant_analyzer,
		/obj/item/storage/bag/dogborg,
		/obj/item/robot_harvester,
		/obj/item/material/knife,
		/obj/item/material/kitchen/rollingpin,
		/obj/item/multitool, //to freeze trays
		/obj/item/dogborg/jaws/small,
		/obj/item/reagent_containers/dropper/industrial,
		/obj/item/tray/robotray,
		/obj/item/reagent_containers/borghypo/service,
		/obj/item/storage/bag/trash
	)

// In a nutshell, basicly service/butler robot but in dog form.
/obj/item/robot_module/robot/quad/serv/handle_special_module_init(mob/living/silicon/robot/R)
	. = ..()
	src.emag = new /obj/item/dogborg/pounce(src)

	// These get a larger water synth.
	synths_by_kind[MATSYN_WATER]:max_energy = 1000

	var/obj/item/rsf/M = new /obj/item/rsf(src)
	M.stored_matter = 30
	. += M

	var/obj/item/flame/lighter/zippo/L = new /obj/item/flame/lighter/zippo(src)
	L.lit = 1
	. += L

/* // I don't know what kind of sleeper to put here, but also no need if you already have "Robot Nom" verb.
	var/obj/item/dogborg/sleeper/K9/B = new /obj/item/dogborg/sleeper/K9(src)
	B.water = water
	src.modules += B
*/
