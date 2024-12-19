/datum/prototype/robot_module/nanotrasen/medical
	use_robot_module_path = /obj/item/robot_module/robot/
	allowed_frames = list(
	)

/datum/prototype/robot_module/nanotrasen/medical/create_mounted_item_descriptors(list/normal_out, list/emag_out)
	..()
	if(normal_out)
		normal_out |=  list(
			/obj/item/healthanalyzer,
			/obj/item/reagent_containers/borghypo/surgeon,
			/obj/item/autopsy_scanner,
			/obj/item/reagent_scanner/adv,
			/obj/item/roller_holder,
			/obj/item/reagent_containers/glass/beaker/large,
			/obj/item/surgical/scalpel/cyborg,
			/obj/item/surgical/hemostat/cyborg,
			/obj/item/surgical/retractor/cyborg,
			/obj/item/surgical/cautery/cyborg,
			/obj/item/surgical/bonegel/cyborg,
			/obj/item/surgical/FixOVein/cyborg,
			/obj/item/surgical/bonesetter/cyborg,
			/obj/item/surgical/circular_saw/cyborg,
			/obj/item/surgical/surgicaldrill/cyborg,
			/obj/item/gripper/no_use/organ,
			/obj/item/gripper/medical,
			/obj/item/shockpaddles/robot,
			/obj/item/reagent_containers/dropper, // Allows surgeon borg to fix necrosis
			/obj/item/reagent_containers/syringe,
			/obj/item/robot_builtin/dog_mirrortool,
		)

/datum/prototype/robot_module/nanotrasen/medical/provision_resource_store(datum/robot_resource_store/store)
	..()
	store.provisioned_stack_store[/obj/item/stack/medical/advanced/bruise_pack] = new /datum/robot_resource/provisioned/preset/bandages/advanced
	store.provisioned_stack_store[/obj/item/stack/medical/advanced/ointment] = new /datum/robot_resource/provisioned/preset/ointment/advanced
	store.provisioned_stack_store[/obj/item/stack/nanopaste] = new /datum/robot_resource/provisioned/preset/nanopaste

#warn translate chassis below

/obj/item/robot_module/robot/medical
	name = "medical robot module"
	channels = list("Medical" = 1)
	networks = list(NETWORK_MEDICAL)
	subsystems = list(/mob/living/silicon/proc/subsystem_crew_monitor)
	can_be_pushed = 0

/obj/item/robot_module/robot/medical/surgeon
	name = "medical robot module"
	sprites = list(
		"M-USE Nanotrasen" = "robotMedi",
		"Cabeiri" = "eyebot-medical",
		"Haruka" = "marinaMD",
		"Minako" = "arachne",
		"Usagi" = "tallwhite",
		"Telemachus" = "toiletbotsurgeon",
		"WTOperator" = "sleekcmo",
		"XI-ALP" = "heavyMed",
		"Basic" = "Medibot",
		"Advanced Droid" = "droid-medical",
		"Needles" = "medicalrobot",
		"Drone" = "drone-surgery",
		"Handy" = "handy-med",
		"Insekt" = "insekt-Med",
		"Misato" = "tall2medical",
		"L3P1-D0T" = "Glitterfly-Surgeon",
		"Miss M" = "miss-medical",
		"Coffical" = "coffin-Medical",
		"Coffcue" = "coffin-Rescue",
		"X-88" = "xeightyeight-medical",
		"Acheron" = "mechoid-Medical",
		"Shellguard Noble" = "Noble-MED",
		"ZOOM-BA" = "zoomba-medical",
		"W02M" = "worm-crisis"
	)

/obj/item/robot_module/robot/medical/surgeon/handle_special_module_init(mob/living/silicon/robot/R)
	. = ..()

	src.emag = new /obj/item/reagent_containers/spray(src)
	src.emag.reagents.add_reagent("pacid", 250)
	src.emag.name = "Polyacid spray"

/obj/item/robot_module/robot/medical/surgeon/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/reagent_containers/syringe/S = locate() in src.modules
	if(S.mode == 2)
		S.reagents.clear_reagents()
		S.mode = initial(S.mode)
		S.desc = initial(S.desc)
		S.update_icon()
	if(src.emag)
		var/obj/item/reagent_containers/spray/PS = src.emag
		PS.reagents.add_reagent("pacid", 2 * amount)
	..()

/obj/item/robot_module/robot/quad/medi
	name = "MediQuad module"
	channels = list("Medical" = 1)
	networks = list(NETWORK_MEDICAL)
	subsystems = list(/mob/living/silicon/proc/subsystem_crew_monitor)
	can_be_pushed = 0
	can_shred = TRUE
	sprites = list(
		"Medical Hound" = "medihound",
		"Dark Medical Hound" = "medihounddark",
		"Mediborg model V-2" = "vale",
		"Borgi" = "borgi-medi",
		"F3-LINE" = "FELI-Medical",
		"Drake" = "drakemed"
	)
