/datum/prototype/robot_module/nanotrasen/janitor
	use_robot_module_path = /obj/item/robot_module/robot/janitor
	allowed_frames = list(
	)

/datum/prototype/robot_module/nanotrasen/janitor/create_mounted_item_descriptors(list/normal_out, list/emag_out)
	..()
	if(normal_out)
		normal_out |= list(
			/obj/item/soap/nanotrasen,
			/obj/item/storage/bag/trash,
			/obj/item/mop/advanced,
			/obj/item/lightreplacer,
			/obj/item/gripper/service,
		)
	if(emag_out)
		var/obj/item/reagent_containers/spray/lube_spray = new
		lube_spray.reagents.add_reagent(/datum/reagent/lube, 250)
		lube_spray.name = "lube spray"
		emag_out |= lube_spray

/datum/prototype/robot_module/nanotrasen/service/provision_resource_store(datum/robot_resource_store/store)
	..()

#warn translate chassis below

/obj/item/robot_module/robot/janitor
	name = "janitorial robot module"
	channels = list("Service" = 1)
	sprites = list(
		"M-USE Nanotrasen" = "robotJani",
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

/obj/item/robot_module/robot/janitor/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/lightreplacer/LR = locate() in src.modules
	LR.Charge(R, amount)
	if(src.emag)
		var/obj/item/reagent_containers/spray/S = src.emag
		S.reagents.add_reagent("lube", 2 * amount)

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
		/obj/item/pupscrubber,
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

	src.emag = new /obj/item/robot_builtin/dog_pounce(src) //Pounce

	//Sheet refiners can only produce raw sheets.
	var/obj/item/stack/material/cyborg/steel/M = new (src)
	M.name = "steel recycler"
	M.desc = "A device that refines recycled steel into sheets."
	M.synths = list(synths_by_kind[MATSYN_METAL])
	M.explicit_recipes = list(
		create_stack_recipe_datum(name = "steel sheet", product = /obj/item/stack/material/steel, cost = 1)
	)
	. += M

	var/obj/item/stack/material/cyborg/glass/G = new (src)
	G.name = "glass recycler"
	G.desc = "A device that refines recycled glass into sheets."
	G.allow_window_autobuild = FALSE
	G.synths = list(synths_by_kind[MATSYN_GLASS])
	M.explicit_recipes = list(
		create_stack_recipe_datum(name = "glass sheet", product = /obj/item/stack/material/glass, cost = 1)
	)
	. += G
