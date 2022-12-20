/obj/machinery/mineral/equipment_vendor/survey
	name = "exploration equipment vendor"
	desc = "An equipment vendor for explorers, points collected with a survey scanner can be spent here."
	icon = 'icons/obj/machines/mining_machines_vr.dmi'
	icon_state = "exploration"
	density = TRUE
	anchored = TRUE
	circuit = /obj/item/circuitboard/exploration_equipment_vendor
	icon_deny = "exploration-deny"
	var/icon_vend = "exploration-vend"
	child = TRUE
	prize_list = list(
		new /datum/data/mining_equipment("1 Marker Beacon",				/obj/item/stack/marker_beacon,								1),
		new /datum/data/mining_equipment("10 Marker Beacons",			/obj/item/stack/marker_beacon/ten,							10),
		new /datum/data/mining_equipment("30 Marker Beacons",			/obj/item/stack/marker_beacon/thirty,						30),
		new /datum/data/mining_equipment("GPS Device",					/obj/item/gps/explorer,										10),
		new /datum/data/mining_equipment("Whiskey",						/obj/item/reagent_containers/food/drinks/bottle/whiskey,	10),
		new /datum/data/mining_equipment("Absinthe",					/obj/item/reagent_containers/food/drinks/bottle/absinthe,	10),
		new /datum/data/mining_equipment("Cigar",						/obj/item/clothing/mask/smokable/cigarette/cigar/havana,	15),
		new /datum/data/mining_equipment("Soap",						/obj/item/soap/nanotrasen,									20),
		new /datum/data/mining_equipment("Laser Pointer",				/obj/item/laser_pointer,									90),
		new /datum/data/mining_equipment("Geiger Counter",				/obj/item/geiger_counter,											75),
		new /datum/data/mining_equipment("Plush Toy",					/obj/random/plushie,										30),
		new /datum/data/mining_equipment("Extraction Equipment - Fulton Beacon",	/obj/item/fulton_core,							300),
		new /datum/data/mining_equipment("Extraction Equipment - Fulton Pack",		/obj/item/extraction_pack,						125),
		new /datum/data/mining_equipment("Umbrella",					/obj/item/melee/umbrella/random,							20),
		new /datum/data/mining_equipment("Shelter Capsule",				/obj/item/survivalcapsule,									50),
		new /datum/data/mining_equipment("Point Transfer Card",			/obj/item/card/mining_point_card/survey,					50),
		new /datum/data/mining_equipment("Survival Medipen",			/obj/item/reagent_containers/hypospray/autoinjector/miner,	50),
		new /datum/data/mining_equipment("Injector (L) - Glucose",		/obj/item/reagent_containers/hypospray/autoinjector/biginjector/glucose,	50),
		new /datum/data/mining_equipment("Injector (L) - Panacea",		/obj/item/reagent_containers/hypospray/autoinjector/biginjector/purity,		50),
		new /datum/data/mining_equipment("Injector (L) - Trauma",		/obj/item/reagent_containers/hypospray/autoinjector/biginjector/brute,		50),
		new /datum/data/mining_equipment("Digital Tablet - Standard",	/obj/item/modular_computer/tablet/preset/custom_loadout/standard,			50),
		new /datum/data/mining_equipment("Digital Tablet - Advanced",	/obj/item/modular_computer/tablet/preset/custom_loadout/advanced,			100),
		new /datum/data/mining_equipment("Nanopaste Tube",				/obj/item/stack/nanopaste,									100),
		new /datum/data/mining_equipment("Mini-Translocator",			/obj/item/perfect_tele/one_beacon,							120),
		//new /datum/data/mining_equipment("UAV - Recon Skimmer",			/obj/item/uav,												400),
		new /datum/data/mining_equipment("Binoculars",					/obj/item/binoculars,										100),
		new /datum/data/mining_equipment("100 Thalers",					/obj/item/spacecash/c100,									100),
		new /datum/data/mining_equipment("1000 Thalers",					/obj/item/spacecash/c1000,									1000),
		new /datum/data/mining_equipment("Jump Boots",					/obj/item/clothing/shoes/bhop,								250),
		new /datum/data/mining_equipment("Luxury Shelter Capsule",		/obj/item/survivalcapsule/luxury,							310),
		new /datum/data/mining_equipment("Industrial Equipment - Phoron Bore",	/obj/item/gun/magnetic/matfed,						300),
		new	/datum/data/mining_equipment("Colonial Recce Pack",			/obj/item/storage/lockbox/colonial,							350),
		new	/datum/data/mining_equipment("Gateway Guardian Pack",		/obj/item/storage/lockbox/gateway,							800),
		new	/datum/data/mining_equipment("Cyan Posse Pack",				/obj/item/storage/lockbox/cowboy,							800),
		new	/datum/data/mining_equipment("Conscript Pack",				/obj/item/storage/lockbox/russian,							250),
		new	/datum/data/mining_equipment("Holy Crusade Pack",			/obj/item/storage/lockbox/crusade,							200),
		new	/datum/data/mining_equipment("Maniple Pack",				/obj/item/storage/lockbox/maniple,							200),
		new /datum/data/mining_equipment("Away Team Pack",				/obj/item/storage/lockbox/away,								550),
		new /datum/data/mining_equipment("Survey Tools - Shovel",		/obj/item/shovel,											40),
		new /datum/data/mining_equipment("Survey Tools - Mechanical Trap",	/obj/item/beartrap,										50),
		new /datum/data/mining_equipment("Defense Equipment - Smoke Bomb",/obj/item/grenade/smokebomb,								10),
		new /datum/data/mining_equipment("Defense Equipment - Razor Drone Deployer",/obj/item/grenade/spawnergrenade/manhacks/station/locked,	100),
		new /datum/data/mining_equipment("Defense Equipment - Sentry Drone Deployer",/obj/item/grenade/spawnergrenade/ward,			150),
		new /datum/data/mining_equipment("Defense Equipment - Steel Machete",	/obj/item/material/knife/machete,					75),
		new /datum/data/mining_equipment("Defense Equipment - Kinetic Dagger",	/obj/item/kinetic_crusher/dagger,					75),
		new /datum/data/mining_equipment("Defense Equipment - Marksman Box",	/obj/item/gunbox/marksman,							1500),
		new /datum/data/mining_equipment("Fishing Net",					/obj/item/material/fishing_net,								50),
		new /datum/data/mining_equipment("Titanium Fishing Rod",		/obj/item/material/fishing_rod/modern,						100),
		new /datum/data/mining_equipment("Durasteel Fishing Rod",		/obj/item/material/fishing_rod/modern/strong,				750),
		new /datum/data/mining_equipment("Bar Shelter Capsule",			/obj/item/survivalcapsule/luxurybar,						1000)
		)

/obj/machinery/mineral/equipment_vendor/survey/interact(mob/user)
	user.set_machine(src)

	var/dat
	dat +="<div class='statusDisplay'>"
	if(istype(inserted_id))
		dat += "You have [inserted_id.survey_points] survey points collected. <A href='?src=\ref[src];choice=eject'>Eject ID.</A><br>"
	else
		dat += "No ID inserted.  <A href='?src=\ref[src];choice=insert'>Insert ID.</A><br>"
	dat += "</div>"
	dat += "<br><b>Equipment point cost list:</b><BR><table border='0' width='100%'>"
	for(var/datum/data/mining_equipment/prize in prize_list)
		dat += "<tr><td>[prize.equipment_name]</td><td>[prize.cost]</td><td><A href='?src=\ref[src];purchase=\ref[prize]'>Purchase</A></td></tr>"
	dat += "</table>"
	var/datum/browser/popup = new(user, "miningvendor", "Survey Equipment Vendor", 400, 600)
	popup.set_content(dat)
	popup.open()

/obj/machinery/mineral/equipment_vendor/survey/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["choice"])
		if(istype(inserted_id))
			if(href_list["choice"] == "eject")
				to_chat(usr, "<span class='notice'>You eject the ID from [src]'s card slot.</span>")
				usr.put_in_hands_or_drop(inserted_id)
				inserted_id = null
		else if(href_list["choice"] == "insert")
			var/obj/item/card/id/I = usr.get_active_held_item()
			if(istype(I) && !inserted_id)
				if(!usr.attempt_insert_item_for_installation(I, src))
					return
				inserted_id = I
				interact(usr)
				to_chat(usr, "<span class='notice'>You insert the ID into [src]'s card slot.</span>")
			else
				to_chat(usr, "<span class='warning'>No valid ID.</span>")
				flick(icon_deny, src)

	if(href_list["purchase"])
		if(istype(inserted_id))
			var/datum/data/mining_equipment/prize = locate(href_list["purchase"])
			if (!prize || !(prize in prize_list))
				to_chat(usr, "<span class='warning'>Error: Invalid choice!</span>")
				flick(icon_deny, src)
				return
			if(prize.cost > inserted_id.survey_points)
				to_chat(usr, "<span class='warning'>Error: Insufficent points for [prize.equipment_name]!</span>")
				flick(icon_deny, src)
			else
				inserted_id.survey_points -= prize.cost
				to_chat(usr, "<span class='notice'>[src] clanks to life briefly before vending [prize.equipment_name]!</span>")
				flick(icon_vend, src)
				new prize.equipment_path(drop_location())
		else
			to_chat(usr, "<span class='warning'>Error: Please insert a valid ID!</span>")
			flick(icon_deny, src)
	updateUsrDialog()
