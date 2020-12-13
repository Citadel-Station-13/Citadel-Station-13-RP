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
					"Drone" = "drone-janitor"
					)

/obj/item/robot_module/robot/janitor/New()
	..()
	src.modules += new /obj/item/soap/nanotrasen(src)
	src.modules += new /obj/item/storage/bag/trash(src)
	src.modules += new /obj/item/mop(src)
	src.modules += new /obj/item/lightreplacer(src)
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
					LANGUAGE_SOL_COMMON	= 1,
					LANGUAGE_UNATHI		= 1,
					LANGUAGE_SIIK		= 1,
					LANGUAGE_AKHANI		= 1,
					LANGUAGE_SKRELLIAN	= 1,
					LANGUAGE_SKRELLIANFAR = 0,
					LANGUAGE_ROOTLOCAL	= 0,
					LANGUAGE_TRADEBAND	= 1,
					LANGUAGE_GUTTER		= 1,
					LANGUAGE_SCHECHI	= 1,
					LANGUAGE_EAL		= 1,
					LANGUAGE_TERMINUS	= 1,
					LANGUAGE_SIGN		= 0,
					LANGUAGE_ZADDAT		= 1,
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
					"Drone - Hydro" = "drone-hydro"
				  	)

/obj/item/robot_module/robot/clerical/butler/New()
	..()
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
					"Drone" = "drone-blu"
					)

/obj/item/robot_module/robot/clerical/general/New()
	..()
	src.modules += new /obj/item/pen/robopen(src)
	src.modules += new /obj/item/form_printer(src)
	src.modules += new /obj/item/gripper/paperwork(src)
	src.modules += new /obj/item/hand_labeler(src)
	src.modules += new /obj/item/stamp(src)
	src.modules += new /obj/item/stamp/denied(src)
	src.emag = new /obj/item/stamp/chameleon(src)
	src.emag = new /obj/item/pen/chameleon(src)

/obj/item/robot_module/general/butler/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/reagent_containers/food/condiment/enzyme/E = locate() in src.modules
	E.reagents.add_reagent("enzyme", 2 * amount)
	if(src.emag)
		var/obj/item/reagent_containers/food/drinks/bottle/small/beer/B = src.emag
		B.reagents.add_reagent("beer2", 2 * amount)

/obj/item/robot_module/robot/scrubpup
	name = "Custodial Hound module"
	sprites = list(
					"Custodial Hound" = "scrubpup",
					"Borgi" = "borgi-jani",
					"Otieborg" = "otiej"
					)
	channels = list("Service" = 1)
	can_be_pushed = 0

/obj/item/robot_module/robot/scrubpup/New(var/mob/living/silicon/robot/R)
	src.modules += new /obj/item/dogborg/jaws/small(src)
	src.modules += new /obj/item/dogborg/boop_module(src)
	src.modules += new /obj/item/pupscrubber(src)
	src.emag 	 = new /obj/item/dogborg/pounce(src) //Pounce

	//Starts empty. Can only recharge with recycled material.
	var/datum/matter_synth/metal = new /datum/matter_synth/metal()
	metal.name = "Steel reserves"
	metal.recharge_rate = 0
	metal.max_energy = 50000
	metal.energy = 0
	var/datum/matter_synth/glass = new /datum/matter_synth/glass()
	glass.name = "Glass reserves"
	glass.recharge_rate = 0
	glass.max_energy = 50000
	glass.energy = 0
	var/datum/matter_synth/water = new /datum/matter_synth(500)
	water.name = "Water reserves"
	water.recharge_rate = 0
	R.water_res = water

	synths += metal
	synths += glass
	synths += water

	var/obj/item/dogborg/tongue/T = new /obj/item/dogborg/tongue(src)
	T.water = water
	src.modules += T

	var/obj/item/lightreplacer/dogborg/LR = new /obj/item/lightreplacer/dogborg(src)
	LR.glass = glass
	src.modules += LR

	var/obj/item/dogborg/sleeper/compactor/C = new /obj/item/dogborg/sleeper/compactor(src)
	C.metal = metal
	C.glass = glass
	C.water = water
	src.modules += C

	//Sheet refiners can only produce raw sheets.
	var/obj/item/stack/material/cyborg/steel/M = new (src)
	M.name = "steel recycler"
	M.desc = "A device that refines recycled steel into sheets."
	M.synths = list(metal)
	M.recipes = list()
	M.recipes += new/datum/stack_recipe("steel sheet", /obj/item/stack/material/steel, 1, 1, 20)
	src.modules += M

	var/obj/item/stack/material/cyborg/glass/G = new (src)
	G.name = "glass recycler"
	G.desc = "A device that refines recycled glass into sheets."
	G.allow_window_autobuild = FALSE
	G.synths = list(glass)
	G.recipes = list()
	G.recipes += new/datum/stack_recipe("glass sheet", /obj/item/stack/material/glass, 1, 1, 20)
	src.modules += G

	R.icon 		 = 'icons/mob/widerobot_vr.dmi'
	R.hands.icon = 'icons/mob/screen1_robot_vr.dmi'
	R.ui_style_vr = TRUE
	R.pixel_x 	 = -16
	R.old_x 	 = -16
	R.default_pixel_x = -16
	R.dogborg = TRUE
	R.wideborg = TRUE
	R.verbs |= /mob/living/silicon/robot/proc/ex_reserve_refill
	R.verbs |= /mob/living/silicon/robot/proc/robot_mount
	R.verbs |= /mob/living/proc/shred_limb
	R.verbs |= /mob/living/silicon/robot/proc/rest_style
	..()

// Uses modified K9 sprites.
/obj/item/robot_module/robot/clerical/brodog
	name = "service-hound module"
	sprites = list(
					"Blackhound" = "k50",
					"Pinkhound" = "k69",
					"ServicehoundV2" = "serve2",
					"ServicehoundV2 Darkmode" = "servedark",
					)
	channels = list("Service" = 1)
	can_be_pushed = 0

// In a nutshell, basicly service/butler robot but in dog form.
/obj/item/robot_module/robot/clerical/brodog/New(var/mob/living/silicon/robot/R)
	src.modules += new /obj/item/gripper/service(src)
	src.modules += new /obj/item/reagent_containers/glass/bucket(src)
	src.modules += new /obj/item/material/minihoe(src)
	src.modules += new /obj/item/material/knife/machete/hatchet(src)
	src.modules += new /obj/item/analyzer/plant_analyzer(src)
	src.modules += new /obj/item/storage/bag/dogborg(src)
	src.modules += new /obj/item/robot_harvester(src)
	src.modules += new /obj/item/material/knife(src)
	src.modules += new /obj/item/material/kitchen/rollingpin(src)
	src.modules += new /obj/item/multitool(src) //to freeze trays
	src.modules += new /obj/item/dogborg/jaws/small(src)
	src.modules += new /obj/item/dogborg/boop_module(src)
	src.emag 	 = new /obj/item/dogborg/pounce(src) //Pounce

	var/datum/matter_synth/water = new /datum/matter_synth(500) // buffy fix, was 0
	water.name = "Water reserves"
	water.recharge_rate = 0
	water.max_energy = 1000
	R.water_res = water
	synths += water


	var/obj/item/dogborg/tongue/T = new /obj/item/dogborg/tongue(src)
	T.water = water
	src.modules += T

	var/obj/item/rsf/M = new /obj/item/rsf(src)
	M.stored_matter = 30
	src.modules += M

	src.modules += new /obj/item/reagent_containers/dropper/industrial(src)

	var/obj/item/flame/lighter/zippo/L = new /obj/item/flame/lighter/zippo(src)
	L.lit = 1
	src.modules += L

	src.modules += new /obj/item/tray/robotray(src)
	src.modules += new /obj/item/reagent_containers/borghypo/service(src)
	src.modules += new /obj/item/storage/bag/trash(src)

/* // I don't know what kind of sleeper to put here, but also no need if you already have "Robot Nom" verb.
	var/obj/item/dogborg/sleeper/K9/B = new /obj/item/dogborg/sleeper/K9(src)
	B.water = water
	src.modules += B
*/

	R.icon 		 = 'icons/mob/widerobot_vr.dmi'
	R.hands.icon = 'icons/mob/screen1_robot_vr.dmi'
	R.ui_style_vr = TRUE
	R.pixel_x 	 = -16
	R.old_x 	 = -16
	R.default_pixel_x = -16
	R.dogborg = TRUE
	R.wideborg = TRUE
	R.verbs |= /mob/living/silicon/robot/proc/ex_reserve_refill
	R.verbs |= /mob/living/silicon/robot/proc/robot_mount
	R.verbs |= /mob/living/silicon/robot/proc/rest_style
	..()

/obj/item/robot_module/Reset(var/mob/living/silicon/robot/R)
	R.pixel_x = initial(pixel_x)
	R.pixel_y = initial(pixel_y)
	R.icon = initial(R.icon)
	R.dogborg = FALSE
	R.wideborg = FALSE
	R.ui_style_vr = FALSE
	R.default_pixel_x = initial(pixel_x)
	R.scrubbing = FALSE
	R.verbs -= /mob/living/silicon/robot/proc/ex_reserve_refill
	R.verbs -= /mob/living/silicon/robot/proc/robot_mount
	R.verbs -= /mob/living/proc/shred_limb
	R.verbs -= /mob/living/silicon/robot/proc/rest_style
	..()
