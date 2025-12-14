/obj/machinery/point_redemption_vendor/survey
	name = "exploration equipment vendor"
	desc = "An equipment vendor for explorers, points collected with a survey scanner can be spent here."
	icon = 'icons/machinery/point_redemption_vendor/survey.dmi'
	icon_state = "vendor"
	icon_state_append_deny = "-deny"
	icon_state_append_open = "-open"
	icon_state_append_off = "-off"
	icon_state_append_broken = "-broken"
	icon_state_append_vend = "-vend"
	point_type = POINT_REDEMPTION_TYPE_SURVEY
	circuit = /obj/item/circuitboard/point_redemption_vendor/survey
	prize_list = list(
		new /datum/point_redemption_item("1 Marker Beacon",				/obj/item/stack/marker_beacon,								1),
		new /datum/point_redemption_item("10 Marker Beacons",			/obj/item/stack/marker_beacon/ten,							10),
		new /datum/point_redemption_item("GPS Device",					/obj/item/gps/explorer,										10),
		new /datum/point_redemption_item("Defense Equipment - Smoke Bomb",/obj/item/grenade/simple/smoke,								10),
		new /datum/point_redemption_item("Whiskey",						/obj/item/reagent_containers/food/drinks/bottle/whiskey,	10),
		new /datum/point_redemption_item("Absinthe",					/obj/item/reagent_containers/food/drinks/bottle/absinthe,	10),
		new /datum/point_redemption_item("Cigar",						/obj/item/clothing/mask/smokable/cigarette/cigar/havana,	15),
		new /datum/point_redemption_item("Soap",						/obj/item/soap/nanotrasen,									20),
		new /datum/point_redemption_item("Umbrella",					/obj/item/melee/umbrella/random,							20),
		new /datum/point_redemption_item("30 Marker Beacons",			/obj/item/stack/marker_beacon/thirty,						30),
		new /datum/point_redemption_item("Plush Toy",					/obj/random/plushie,										30),
		new /datum/point_redemption_item("Survey Tools - Shovel",		/obj/item/shovel,											40),
		new /datum/point_redemption_item("Survey Tools - Mechanical Trap",	/obj/item/beartrap,										50),
		new /datum/point_redemption_item("Shelter Capsule",				/obj/item/survivalcapsule,									50),
		new /datum/point_redemption_item("Point Transfer Card",			/obj/item/point_redemption_voucher/preloaded/survey/c50,					50),
		new /datum/point_redemption_item("Regular Firstaid Kit",		/obj/item/storage/firstaid/regular,							50),
	//	new /datum/point_redemption_item("Advanced Firstaid Kit",		/obj/item/storage/firstaid/adv,								50),
	//	new /datum/point_redemption_item("Bone Restoration Medicine",	/obj/item/storage/firstaid/bonemed,							50),
	//	new /datum/point_redemption_item("Clotting Kit",				/obj/item/storage/firstaid/clotting,						50),
		new /datum/point_redemption_item("Survival Medipen",			/obj/item/reagent_containers/hypospray/autoinjector/miner,	50),
		new /datum/point_redemption_item("Injector (L) - Glucose",		/obj/item/reagent_containers/hypospray/autoinjector/biginjector/glucose,	50),
		new /datum/point_redemption_item("Injector (L) - Panacea",		/obj/item/reagent_containers/hypospray/autoinjector/biginjector/purity,		50),
		new /datum/point_redemption_item("Injector (L) - Trauma",		/obj/item/reagent_containers/hypospray/autoinjector/biginjector/brute,		50),
		new /datum/point_redemption_item("Digital Tablet - Standard",	/obj/item/modular_computer/tablet/preset/custom_loadout/standard,			50),
		new /datum/point_redemption_item("Geiger Counter",				/obj/item/geiger_counter,									75),
		new /datum/point_redemption_item("Defense Equipment - Steel Machete",	/obj/item/material/knife/machete,					75),
		new /datum/point_redemption_item("Defense Equipment - Kinetic Dagger",	/obj/item/kinetic_crusher/dagger,					75),
		new /datum/point_redemption_item("Laser Pointer",				/obj/item/laser_pointer,									90),
		new /datum/point_redemption_item("Digital Tablet - Advanced",	/obj/item/modular_computer/tablet/preset/custom_loadout/advanced,				100),
		new /datum/point_redemption_item("Nanopaste Tube",				/obj/item/stack/nanopaste,									100),
		new /datum/point_redemption_item("Binoculars",					/obj/item/binoculars,										100),
		new /datum/point_redemption_item("100 Thalers",					/obj/item/spacecash/c100,									100),
		new /datum/point_redemption_item("Defense Equipment - Razor Drone Deployer",	/obj/item/grenade/simple/spawner/manhacks/station/locked,		100),
		new /datum/point_redemption_item("Explosive Excavation Kit - Plastic Charge",/obj/item/plastique/seismic/locked,					100),
		new /datum/point_redemption_item("Mini-Translocator",			/obj/item/perfect_tele/one_beacon,							120),
		new /datum/point_redemption_item("Extraction Equipment - Fulton Pack",		/obj/item/extraction_pack,						125),
		new /datum/point_redemption_item("Defense Equipment - Sentry Drone Deployer",	/obj/item/grenade/simple/spawner/ward,							150),
		new	/datum/point_redemption_item("Holy Crusade Pack",			/obj/item/storage/lockbox/crusade,							200),
		new	/datum/point_redemption_item("Maniple Pack",				/obj/item/storage/lockbox/maniple,							200),
		new /datum/point_redemption_item("Jump Boots",					/obj/item/clothing/shoes/bhop,								250),
		new	/datum/point_redemption_item("Defense Equipment - AXHS Gun Case",	/obj/item/storage/lockbox/axhs,						250),
		new	/datum/point_redemption_item("Conscript Pack",				/obj/item/storage/lockbox/russian,							250),
		new /datum/point_redemption_item("Extraction Equipment - Fulton Beacon",	/obj/item/fulton_core,							300),
		new /datum/point_redemption_item("Industrial Equipment - Phoron Bore",	/obj/item/gun/projectile/magnetic/matfed,						300),
		new /datum/point_redemption_item("Luxury Shelter Capsule",		/obj/item/survivalcapsule/luxury,							310),
		new	/datum/point_redemption_item("Colonial Recce Pack",			/obj/item/storage/lockbox/colonial,							350),
		//uav code is cursed  new /datum/point_redemption_item("UAV - Recon Skimmer",			/obj/item/uav,												400),
		new /datum/point_redemption_item("Away Team Pack",				/obj/item/storage/lockbox/away,								550),
		new	/datum/point_redemption_item("Gateway Guardian Pack",		/obj/item/storage/lockbox/gateway,							800),
		new	/datum/point_redemption_item("Cyan Posse Pack",				/obj/item/storage/lockbox/cowboy,							800),
		new /datum/point_redemption_item("Bar Shelter Capsule",			/obj/item/survivalcapsule/luxurybar,						1000),
		new /datum/point_redemption_item("1000 Thalers",				/obj/item/spacecash/c1000,									1000),
		new /datum/point_redemption_item("Defense Equipment - Marksman Box",	/obj/item/gunbox/marksman,							1000),
		)
