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

/obj/item/robot_module/robot/medical/surgeon/Initialize(mapload)
	. = ..()
	src.modules += new /obj/item/healthanalyzer(src)
	src.modules += new /obj/item/reagent_containers/borghypo/surgeon(src)
	src.modules += new /obj/item/autopsy_scanner(src)
	src.modules += new /obj/item/reagent_scanner/adv(src)
	src.modules += new /obj/item/roller_holder(src)
	src.modules += new /obj/item/reagent_containers/glass/beaker/large(src)
	src.modules += new /obj/item/surgical/scalpel/cyborg(src)
	src.modules += new /obj/item/surgical/hemostat/cyborg(src)
	src.modules += new /obj/item/surgical/retractor/cyborg(src)
	src.modules += new /obj/item/surgical/cautery/cyborg(src)
	src.modules += new /obj/item/surgical/bonegel/cyborg(src)
	src.modules += new /obj/item/surgical/FixOVein/cyborg(src)
	src.modules += new /obj/item/surgical/bonesetter/cyborg(src)
	src.modules += new /obj/item/surgical/circular_saw/cyborg(src)
	src.modules += new /obj/item/surgical/surgicaldrill/cyborg(src)
	src.modules += new /obj/item/gripper/no_use/organ(src)
	src.modules += new /obj/item/gripper/medical(src)
	src.modules += new /obj/item/shockpaddles/robot(src)
	src.modules += new /obj/item/reagent_containers/dropper(src) // Allows surgeon borg to fix necrosis
	src.modules += new /obj/item/reagent_containers/syringe(src)
	src.modules += new /obj/item/dogborg/mirrortool(src)
	src.emag = new /obj/item/reagent_containers/spray(src)
	src.emag.reagents.add_reagent("pacid", 250)
	src.emag.name = "Polyacid spray"

	var/datum/matter_synth/medicine = new /datum/matter_synth/medicine(15000)
	synths += medicine

	var/obj/item/stack/medical/advanced/ointment/O = new /obj/item/stack/medical/advanced/ointment(src)
	var/obj/item/stack/nanopaste/N = new /obj/item/stack/nanopaste(src)
	var/obj/item/stack/medical/advanced/bruise_pack/B = new /obj/item/stack/medical/advanced/bruise_pack(src)
	O.uses_charge = 1
	O.charge_costs = list(1000)
	O.synths = list(medicine)
	N.uses_charge = 1
	N.charge_costs = list(1000)
	N.synths = list(medicine)
	B.uses_charge = 1
	B.charge_costs = list(1000)
	B.synths = list(medicine)
	src.modules += O
	src.modules += N
	src.modules += B

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

/obj/item/robot_module/robot/quad_medi
	name = "MediQuad module"
	channels = list("Medical" = 1)
	networks = list(NETWORK_MEDICAL)
	subsystems = list(/mob/living/silicon/proc/subsystem_crew_monitor)
	can_be_pushed = 0
	sprites = list(
					"Medical Hound" = "medihound",
					"Dark Medical Hound" = "medihounddark",
					"Mediborg model V-2" = "vale",
					"Borgi" = "borgi-medi",
					"F3-LINE" = "FELI-Medical"
					)

/obj/item/robot_module/robot/quad_medi/Initialize(mapload)
	. = ..()
	var/mob/living/silicon/robot/R = loc
	src.modules += new /obj/item/dogborg/jaws/small(src) //In case a patient is being attacked by carp.
	src.modules += new /obj/item/dogborg/boop_module(src) //Boop the crew.
	src.modules += new /obj/item/healthanalyzer(src) // See who's hurt specificially.
	src.modules += new /obj/item/autopsy_scanner(src)
	src.modules += new /obj/item/roller_holder(src) // Sometimes you just can't buckle someone to yourself because of taurcode. this is for those times.
	src.modules += new /obj/item/reagent_scanner/adv(src)
	src.modules += new /obj/item/reagent_containers/syringe(src) //In case the chemist is nice!
	src.modules += new /obj/item/reagent_containers/glass/beaker/large(src)//For holding the chemicals when the chemist is nice
	// src.modules += new /obj/item/sleevemate(src) //Lets them scan people.
	src.modules += new /obj/item/shockpaddles/robot/hound(src) //Paws of life
	src.emag 	 = new /obj/item/dogborg/pounce(src) //Pounce

	//New surgery tools + grippers
	src.modules += new /obj/item/surgical/scalpel/cyborg(src)
	src.modules += new /obj/item/surgical/hemostat/cyborg(src)
	src.modules += new /obj/item/surgical/retractor/cyborg(src)
	src.modules += new /obj/item/surgical/cautery/cyborg(src)
	src.modules += new /obj/item/surgical/bonegel/cyborg(src)
	src.modules += new /obj/item/surgical/FixOVein/cyborg(src)
	src.modules += new /obj/item/surgical/bonesetter/cyborg(src)
	src.modules += new /obj/item/surgical/circular_saw/cyborg(src)
	src.modules += new /obj/item/surgical/surgicaldrill/cyborg(src)
	src.modules += new /obj/item/gripper/no_use/organ(src)
	src.modules += new /obj/item/gripper/medical(src)
	src.modules += new /obj/item/dogborg/mirrortool(src)


	var/datum/matter_synth/water = new /datum/matter_synth(500)
	water.name = "Water reserves"
	water.recharge_rate = 0
	R.water_res = water
	synths += water

	var/obj/item/reagent_containers/borghypo/hound/H = new /obj/item/reagent_containers/borghypo/hound(src)
	H.water = water
	src.modules += H

	var/obj/item/dogborg/tongue/T = new /obj/item/dogborg/tongue(src)
	T.water = water
	src.modules += T

	var/obj/item/dogborg/sleeper/B = new /obj/item/dogborg/sleeper(src) //So they can nom people and heal them
	B.water = water
	src.modules += B

	var/datum/matter_synth/medicine = new /datum/matter_synth/medicine(15000) // BEGIN CITADEL CHANGES - adds trauma kits to medihounds
	synths += medicine
	var/obj/item/stack/nanopaste/P = new /obj/item/stack/nanopaste(src)
	var/obj/item/stack/medical/advanced/ointment/K = new /obj/item/stack/medical/advanced/ointment(src)
	var/obj/item/stack/medical/advanced/bruise_pack/L = new /obj/item/stack/medical/advanced/bruise_pack(src)
	P.uses_charge = 1
	P.charge_costs = list(1000)
	P.synths = list(medicine)
	K.uses_charge = 1
	K.charge_costs = list(1000)
	K.synths = list(medicine)
	L.uses_charge = 1
	L.charge_costs = list(1000)
	L.synths = list(medicine)
	src.modules += K
	src.modules += L
	src.modules += P
	// END CITADEL CHANGES

	R.icon = 'icons/mob/robots_wide.dmi'
	R.set_base_pixel_x(-16)
	R.dogborg = TRUE
	R.wideborg = TRUE
	R.icon_dimension_x = 64
	add_verb(R, /mob/living/silicon/robot/proc/ex_reserve_refill)
	add_verb(R, /mob/living/proc/shred_limb)
	add_verb(R, /mob/living/silicon/robot/proc/rest_style)

	if(R.client && (R.client.ckey in list("nezuli")))
		sprites += "Alina"
		sprites["Alina"] = "alina-med"
		. = ..()
