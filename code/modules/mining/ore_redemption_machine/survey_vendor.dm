/obj/machinery/mineral/equipment_vendor/survey
	name = "exploration equipment vendor"
	desc = "An equipment vendor for explorers, points collected with a survey scanner can be spent here."
	icon = 'icons/obj/machines/mining_machines_vr.dmi'
	icon_state = "exploration"
	density = TRUE
	anchored = TRUE
	circuit = /obj/item/circuitboard/exploration_equipment_vendor
	icon_deny = "exploration-deny"

/obj/machinery/mineral/equipment_vendor/survey/Initialize(mapload)
	. = ..()
	prize_list = list()
	prize_list["Gear"] = list(
		EQUIPMENT("Defense Equipment - Plasteel Machete",		/obj/item/material/knife/machete,							500),
		EQUIPMENT("Defense Equipment - Razor Drone Deployer",	/obj/item/grenade/spawnergrenade/manhacks/station/locked,	1000),
		EQUIPMENT("Defense Equipment - Sentry Drone Deployer",	/obj/item/grenade/spawnergrenade/ward,						1500),
		EQUIPMENT("Defense Equipment - Smoke Bomb",				/obj/item/grenade/smokebomb,								100),
		EQUIPMENT("Durasteel Fishing Rod",						/obj/item/material/fishing_rod/modern/strong,				7500),
		EQUIPMENT("Fishing Net",								/obj/item/material/fishing_net,								500),
		EQUIPMENT("Titanium Fishing Rod",						/obj/item/material/fishing_rod/modern,						1000),
		EQUIPMENT("Fulton Beacon",								/obj/item/fulton_core,										500),
		EQUIPMENT("Geiger Counter",								/obj/item/geiger,											750),
		EQUIPMENT("GPS Device",									/obj/item/gps/mining,										100),
		EQUIPMENT("Jump Boots",									/obj/item/clothing/shoes/bhop,								2500),
		EQUIPMENT("Mini-Translocator",							/obj/item/perfect_tele/one_beacon,							1200),
		//EQUIPMENT("Survival Equipment - Insulated Poncho",		/obj/random/thermalponcho,									750),
	)
	prize_list["Consumables"] = list(
		EQUIPMENT("1 Marker Beacon",		/obj/item/stack/marker_beacon,												10),
		EQUIPMENT("10 Marker Beacons",		/obj/item/stack/marker_beacon/ten,											100),
		EQUIPMENT("30 Marker Beacons",		/obj/item/stack/marker_beacon/thirty,										300),
		EQUIPMENT("Fulton Pack",			/obj/item/extraction_pack,													1200),
		EQUIPMENT("Injector (L) - Glucose",	/obj/item/reagent_containers/hypospray/autoinjector/biginjector/glucose,	500),
		EQUIPMENT("Injector (L) - Panacea",	/obj/item/reagent_containers/hypospray/autoinjector/biginjector/purity,		500),
		EQUIPMENT("Injector (L) - Trauma",	/obj/item/reagent_containers/hypospray/autoinjector/biginjector/brute,		500),
		EQUIPMENT("Nanopaste Tube",			/obj/item/stack/nanopaste,													1000),
		EQUIPMENT("Point Transfer Card",	/obj/item/card/mining_point_card/survey,									500),
		EQUIPMENT("Shelter Capsule",		/obj/item/survivalcapsule,													500),
		//EQUIPMENT("Burn Medipen",			/obj/item/reagent_containers/hypospray/autoinjector/burn,					250),
		EQUIPMENT("Detox Medipen",			/obj/item/reagent_containers/hypospray/autoinjector/detox,					250),
		//EQUIPMENT("Oxy Medipen",			/obj/item/reagent_containers/hypospray/autoinjector/oxy,					250),
		//EQUIPMENT("Trauma Medipen",			/obj/item/reagent_containers/hypospray/autoinjector/trauma,					250),
	)
	prize_list["Digging Tools"] = list(
		EQUIPMENT("Survey Tools - Shovel",			/obj/item/shovel,	40),
		EQUIPMENT("Survey Tools - Mechanical Trap",	/obj/item/beartrap,	50),
	)
	prize_list["Miscellaneous"] = list(
		EQUIPMENT("Absinthe",					/obj/item/reagent_containers/food/drinks/bottle/absinthe,			125),
		EQUIPMENT("Bar Shelter Capsule",		/obj/item/survivalcapsule/luxurybar,								10000),
		EQUIPMENT("Cigar",						/obj/item/clothing/mask/smokable/cigarette/cigar/havana,			150),
		EQUIPMENT("Digital Tablet - Advanced",	/obj/item/modular_computer/tablet/preset/custom_loadout/advanced,	1000),
		EQUIPMENT("Digital Tablet - Standard",	/obj/item/modular_computer/tablet/preset/custom_loadout/standard,	500),
		EQUIPMENT("Industrial Equipment - Phoron Bore",	/obj/item/gun/magnetic/matfed,								3000),
		EQUIPMENT("Laser Pointer",				/obj/item/laser_pointer,											900),
		EQUIPMENT("Luxury Shelter Capsule",		/obj/item/survivalcapsule/luxury,									3100),
		EQUIPMENT("Plush Toy",					/obj/random/plushie,												300),
		EQUIPMENT("Soap",						/obj/item/soap/nanotrasen,											200),
		EQUIPMENT("Thalers - 100",				/obj/item/spacecash/c100,											1000),
		EQUIPMENT("Umbrella",					/obj/item/melee/umbrella/random,									200),
		EQUIPMENT("UAV - Recon Skimmer",		/obj/item/uav,														400),
		EQUIPMENT("Whiskey",					/obj/item/reagent_containers/food/drinks/bottle/whiskey,			125),
	)

/obj/machinery/mineral/equipment_vendor/survey/get_points(obj/item/card/id/target)
	if(!istype(target))
		return FALSE
	return target.survey_points

/obj/machinery/mineral/equipment_vendor/survey/remove_points(obj/item/card/id/target, amt)
	target.survey_points -= amt
