/obj/item/robot_module/robot/medical
	name = "medical robot module"
	channels = list("Medical" = 1)
	networks = list(NETWORK_MEDICAL)
	subsystems = list(/mob/living/silicon/proc/subsystem_crew_monitor)
	can_be_pushed = 0

/obj/item/robot_module/robot/medical/surgeon
	name = "medical robot module"
	sprites = list(
		"M-USE NanoTrasen" = "robotMedi",
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

/obj/item/robot_module/robot/medical/surgeon/get_modules()
	. = ..()
	. |= list(
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
		/obj/item/dogborg/mirrortool
	)

/obj/item/robot_module/robot/medical/surgeon/get_synths(mob/living/silicon/robot/R)
	. = ..()
	MATTER_SYNTH(MATSYN_DRUGS, medicine, 15000)

/obj/item/robot_module/robot/medical/surgeon/handle_special_module_init(mob/living/silicon/robot/R)
	. = ..()

	src.emag = new /obj/item/reagent_containers/spray(src)
	src.emag.reagents.add_reagent("pacid", 250)
	src.emag.name = "Polyacid spray"

	var/obj/item/stack/medical/advanced/ointment/O = new /obj/item/stack/medical/advanced/ointment(src)
	O.uses_charge = 1
	O.charge_costs = list(1000)
	O.synths = list(synths_by_kind[MATSYN_DRUGS])
	. += O

	var/obj/item/stack/nanopaste/N = new /obj/item/stack/nanopaste(src)
	N.uses_charge = 1
	N.charge_costs = list(1000)
	N.synths = list(synths_by_kind[MATSYN_DRUGS])
	. += N

	var/obj/item/stack/medical/advanced/bruise_pack/B = new /obj/item/stack/medical/advanced/bruise_pack(src)
	B.uses_charge = 1
	B.charge_costs = list(1000)
	B.synths = list(synths_by_kind[MATSYN_DRUGS])
	. += B

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

//Crisis module removed - 5/2/2021

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

/obj/item/robot_module/robot/quad/medi/get_modules()
	. = ..()
	. |= list(
		/obj/item/dogborg/jaws/small, //In case a patient is being attacked by carp.
		/obj/item/healthanalyzer, // See who's hurt specificially.
		/obj/item/autopsy_scanner,
		/obj/item/roller_holder, // Sometimes you just can't buckle someone to yourself because of taurcode. this is for those times.
		/obj/item/reagent_scanner/adv,
		/obj/item/reagent_containers/syringe, //In case the chemist is nice!
		/obj/item/reagent_containers/glass/beaker/large,//For holding the chemicals when the chemist is nice
		// /obj/item/sleevemate, //Lets them scan people.
		/obj/item/shockpaddles/robot/hound, //Paws of life
		//New surgery tools + grippers
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
		/obj/item/dogborg/mirrortool
	)

/obj/item/robot_module/robot/quad/medi/get_synths(mob/living/silicon/robot/R)
	. = ..()
	MATTER_SYNTH(MATSYN_DRUGS, medicine, 15000)

/obj/item/robot_module/robot/quad/medi/handle_special_module_init(mob/living/silicon/robot/R)
	. = ..()
	src.emag 	 = new /obj/item/dogborg/pounce(src) //Pounce

	var/obj/item/reagent_containers/borghypo/hound/H = new /obj/item/reagent_containers/borghypo/hound(src)
	H.water = synths_by_kind[MATSYN_WATER]
	. += H

	var/obj/item/dogborg/sleeper/B = new /obj/item/dogborg/sleeper(src) //So they can nom people and heal them
	B.water = synths_by_kind[MATSYN_WATER]
	src.modules += B

	var/medicine = synths_by_kind[MATSYN_DRUGS]

	var/obj/item/stack/nanopaste/P = new /obj/item/stack/nanopaste(src)
	P.uses_charge = 1
	P.charge_costs = list(1000)
	P.synths = list(medicine)
	. += P

	var/obj/item/stack/medical/advanced/ointment/K = new /obj/item/stack/medical/advanced/ointment(src)
	K.uses_charge = 1
	K.charge_costs = list(1000)
	K.synths = list(medicine)
	. += K

	var/obj/item/stack/medical/advanced/bruise_pack/L = new /obj/item/stack/medical/advanced/bruise_pack(src)
	L.uses_charge = 1
	L.charge_costs = list(1000)
	L.synths = list(medicine)
	. += L
