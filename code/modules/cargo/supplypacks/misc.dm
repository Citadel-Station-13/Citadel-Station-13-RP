/*
*	Here is where any supply packs
*	that don't belong elsewhere live.
*/

/datum/supply_pack/misc
	group = "Miscellaneous"

/datum/supply_pack/randomised/misc
	group = "Miscellaneous"

/datum/supply_pack/randomised/misc/card_packs
	num_contained = 5
	contains = list(
			/obj/item/pack/cardemon,
			/obj/item/pack/spaceball,
			/obj/item/deck/holder
			)
	name = "Trading Card Crate"
	cost = 10
	container_type = /obj/structure/closet/crate
	container_name = "cards crate"

/datum/supply_pack/randomised/misc/dnd
	num_contained = 4
	contains = list(
			/obj/item/toy/character/alien,
			/obj/item/toy/character/warrior,
			/obj/item/toy/character/cleric,
			/obj/item/toy/character/thief,
			/obj/item/toy/character/wizard,
			/obj/item/toy/character/voidone,
			/obj/item/toy/character/lich
			)
	name = "Miniatures Crate"
	cost = 200
	container_type = /obj/structure/closet/crate
	container_name = "Miniature Crate"

/datum/supply_pack/randomised/misc/plushies
	num_contained = 5
	contains = list(
			/obj/item/toy/plushie/nymph,
			/obj/item/toy/plushie/mouse,
			/obj/item/toy/plushie/kitten,
			/obj/item/toy/plushie/lizard,
			/obj/item/toy/plushie/spider,
			/obj/item/toy/plushie/farwa,
			/obj/item/toy/plushie/corgi,
			/obj/item/toy/plushie/girly_corgi,
			/obj/item/toy/plushie/robo_corgi,
			/obj/item/toy/plushie/octopus,
			/obj/item/toy/plushie/face_hugger,
			/obj/item/toy/plushie/red_fox,
			/obj/item/toy/plushie/black_fox,
			/obj/item/toy/plushie/marble_fox,
			/obj/item/toy/plushie/blue_fox,
			/obj/item/toy/plushie/coffee_fox,
			/obj/item/toy/plushie/pink_fox,
			/obj/item/toy/plushie/purple_fox,
			/obj/item/toy/plushie/crimson_fox,
			/obj/item/toy/plushie/deer,
			/obj/item/toy/plushie/black_cat,
			/obj/item/toy/plushie/grey_cat,
			/obj/item/toy/plushie/white_cat,
			/obj/item/toy/plushie/orange_cat,
			/obj/item/toy/plushie/siamese_cat,
			/obj/item/toy/plushie/tabby_cat,
			/obj/item/toy/plushie/tuxedo_cat,
			/obj/item/toy/plushie/squid/green,
			/obj/item/toy/plushie/squid/mint,
			/obj/item/toy/plushie/squid/blue,
			/obj/item/toy/plushie/squid/orange,
			/obj/item/toy/plushie/squid/yellow,
			/obj/item/toy/plushie/squid/pink
			)
	name = "Plushies Crate"
	cost = 15
	container_type = /obj/structure/closet/crate
	container_name = "Plushies Crate"

/datum/supply_pack/misc/eftpos
	contains = list(/obj/item/eftpos)
	name = "EFTPOS scanner"
	cost = 10
	container_type = /obj/structure/closet/crate
	container_name = "EFTPOS crate"

/datum/supply_pack/misc/chaplaingear
	name = "Chaplain equipment"
	contains = list(
			/obj/item/clothing/under/rank/chaplain,
			/obj/item/clothing/shoes/black,
			/obj/item/clothing/suit/nun,
			/obj/item/clothing/head/nun_hood,
			/obj/item/clothing/suit/storage/hooded/chaplain_hoodie,
			/obj/item/clothing/suit/storage/hooded/chaplain_hoodie/whiteout,
			/obj/item/clothing/suit/holidaypriest,
			/obj/item/clothing/under/wedding/bride_white,
			/obj/item/storage/backpack/cultpack,
			/obj/item/storage/fancy/candle_box = 3,
			/obj/item/reagent_containers/food/drinks/bottle/holywater
			)
	cost = 10
	container_type = /obj/structure/closet/crate
	container_name = "Chaplain equipment crate"

/datum/supply_pack/misc/hoverpod
	name = "Hoverpod Shipment"
	contains = list()
	cost = 80
	container_type = /obj/structure/largecrate/hoverpod
	container_name = "Hoverpod Crate"

/datum/supply_pack/randomised/misc/webbing
	name = "Webbing crate"
	num_contained = 4
	contains = list(
			/obj/item/clothing/accessory/storage/black_vest,
			/obj/item/clothing/accessory/storage/brown_vest,
			/obj/item/clothing/accessory/storage/white_vest,
			/obj/item/clothing/accessory/storage/black_drop_pouches,
			/obj/item/clothing/accessory/storage/brown_drop_pouches,
			/obj/item/clothing/accessory/storage/white_drop_pouches,
			/obj/item/clothing/accessory/storage/webbing
			)
	cost = 10
	container_type = /obj/structure/closet/crate
	container_name = "Webbing crate"

/datum/supply_pack/misc/holoplant
	name = "Holoplant Pot"
	contains = list(/obj/machinery/holoplant/shipped)
	cost = 15
	container_type = /obj/structure/closet/crate
	container_name = "Holoplant crate"

/datum/supply_pack/misc/glucose_hypos
	name = "Glucose Hypoinjectors"
	contains = list(
			/obj/item/reagent_containers/hypospray/autoinjector/biginjector/glucose = 5
			)
	cost = 25
	container_type = /obj/structure/closet/crate
	container_name = "Glucose Hypo Crate"

/datum/supply_pack/misc/mre_rations
	// num_contained = 6		i'm just commenting this out because whoever made this should have looked and seen that this doesn't work for non randomized crates
	// screw you for causing me a compile error
	name = "Emergency - MREs"
	contains = list(/obj/item/storage/mre,
					/obj/item/storage/mre/menu2,
					/obj/item/storage/mre/menu3,
					/obj/item/storage/mre/menu4,
					/obj/item/storage/mre/menu5,
					/obj/item/storage/mre/menu6,
					/obj/item/storage/mre/menu7,
					/obj/item/storage/mre/menu8,
					/obj/item/storage/mre/menu9,
					/obj/item/storage/mre/menu10)
	cost = 50
	container_type = /obj/structure/closet/crate/freezer
	container_name = "ready to eat rations"

/datum/supply_pack/misc/paste_rations
	name = "Emergency - Paste"
	contains = list(
			/obj/item/storage/mre/menu11 = 2
			)
	cost = 25
	container_type = /obj/structure/closet/crate/freezer
	container_name = "emergency rations"

/datum/supply_pack/misc/medical_rations
	name = "Emergency - VitaPaste"
	contains = list(
			/obj/item/storage/mre/menu13 = 2
			)
	cost = 40
	container_type = /obj/structure/closet/crate/freezer
	container_name = "emergency rations"

/datum/supply_pack/misc/beltminer
	name = "Belt-miner gear crate"
	contains = list(
			/obj/item/gun/energy/particle = 2,
			/obj/item/cell/device/weapon = 2,
			/obj/item/storage/firstaid/regular = 1,
			/obj/item/gps = 2,
			/obj/item/storage/box/traumainjectors = 1
			)
	cost = 50
	container_type = /obj/structure/closet/crate/secure/gear
	container_name = "Belt-miner gear crate"
	access = access_mining

/datum/supply_pack/misc/eva_rig
	name = "eva hardsuit (empty)"
	contains = list(
			/obj/item/rig/eva = 1
			)
	cost = 150
	container_type = /obj/structure/closet/crate/secure/gear
	container_name = "eva hardsuit crate"
	access = list(access_mining,
				  access_eva,
				  access_explorer,
				  access_pilot)
	one_access = TRUE

/datum/supply_pack/misc/mining_rig
	name = "industrial hardsuit (empty)"
	contains = list(
			/obj/item/rig/industrial = 1
			)
	cost = 150
	container_type = /obj/structure/closet/crate/secure/gear
	container_name = "industrial hardsuit crate"
	access = list(access_mining,
				  access_eva)
	one_access = TRUE

/datum/supply_pack/misc/medical_rig
	name = "medical hardsuit (empty)"
	contains = list(
			/obj/item/rig/medical = 1
			)
	cost = 150
	container_type = /obj/structure/closet/crate/secure/gear
	container_name = "medical hardsuit crate"
	access = access_medical

/datum/supply_pack/misc/phoronoid
	name  = "Spare Phoronoid containment suits"
	contains = list(
	/obj/item/clothing/suit/space/plasman = 3,
	/obj/item/clothing/head/helmet/space/plasman = 3,
	/obj/item/clothing/mask/breath = 3,
	/obj/item/tank/vox = 3,
	)
	cost = 40
	container_name = "spare phoronoid suits"

/datum/supply_pack/misc/security_rig
	name = "hazard hardsuit (empty)"
	contains = list(
			/obj/item/rig/hazard = 1
			)
	cost = 150
	container_type = /obj/structure/closet/crate/secure/gear
	container_name = "hazard hardsuit crate"
	access = access_armory

/datum/supply_pack/misc/science_rig
	name = "ami hardsuit (empty)"
	contains = list(
			/obj/item/rig/hazmat = 1
			)
	cost = 150
	container_type = /obj/structure/closet/crate/secure/gear
	container_name = "ami hardsuit crate"
	access = access_rd

/datum/supply_pack/misc/ce_rig
	name = "advanced voidsuit (empty)"
	contains = list(
			/obj/item/rig/ce = 1
			)
	cost = 150
	container_type = /obj/structure/closet/crate/secure/gear
	container_name = "advanced voidsuit crate"
	access = access_ce

/datum/supply_pack/misc/skatepack1
	name = "Beginner Skateboard Pack"
	contains = list(
			/obj/vehicle_old/skateboard/beginner = 3,
			/obj/item/clothing/head/helmet/bike_helmet/random = 3
			)
	cost = 100
	container_type = /obj/structure/closet/crate
	container_name = "Skateboard Crate - Beginner"

/datum/supply_pack/misc/skatepack2
	name = "Professional Skateboard Pack"
	contains = list(
			/obj/vehicle_old/skateboard/pro = 2,
			/obj/item/clothing/head/helmet/bike_helmet/random = 2
			)
	cost = 200
	container_type = /obj/structure/closet/crate
	container_name = "Skateboard Crate - Professional"

/datum/supply_pack/misc/skatepack3
	name = "Hoverboard Pack"
	contains = list(
			/obj/vehicle_old/skateboard/hoverboard = 2,
			/obj/item/clothing/head/helmet/bike_helmet/random = 2
			)
	cost = 300
	container_type = /obj/structure/closet/crate
	container_name = "Hoverboard Crate"

/datum/supply_pack/misc/colored_lights
	name = "Colored Lights Bundle"
	contains = list(
			/obj/item/storage/box/lights/bulbs_colored = 2,
			/obj/item/storage/box/lights/tubes_colored = 2,
			/obj/item/storage/box/lights/mixed_colored = 1
			)
	cost = 50
	container_type = /obj/structure/closet/crate
	container_name = "Colored Lights crate"

/datum/supply_pack/misc/neon_lights
	name = "Neon Lights Bundle"
	contains = list(
			/obj/item/storage/box/lights/bulbs_neon = 2,
			/obj/item/storage/box/lights/tubes_neon = 2,
			/obj/item/storage/box/lights/mixed_neon = 1
			)
	cost = 50
	container_type = /obj/structure/closet/crate
	container_name = "Neon Lights crate"

//Culture Crates
/datum/supply_pack/misc/culture_apidean
	name = "Apidean Culture Crate"
	contains = list(
			/obj/fiftyspawner/wax = 2,
			/obj/item/healthanalyzer/apidean = 1,
			/obj/item/analyzer/apidean = 1,
			/obj/item/reagent_scanner/apidean = 1,
			/mob/living/bot/medibot/apidean = 1,
			/obj/item/reagent_containers/food/drinks/bottle/ambrosia_mead = 2,
			/obj/item/reagent_containers/food/drinks/bottle/royaljelly = 1
			)
	cost = 50
	container_type = /obj/structure/closet/crate
	container_name = "Apidean Culture crate"

/datum/supply_pack/misc/culture_tyrmalin
	name = "Tyrmalin Culture Crate"
	contains = list(
			/obj/item/tool/wrench/goblin = 2,
			/obj/item/weldingtool/welder_spear = 2,
			/obj/item/clothing/accessory/skullcodpiece = 2,
			/obj/item/reagent_containers/food/snacks/cavemoss_can = 2,
			/obj/item/reagent_containers/food/snacks/diggerstew_can = 2,
			/obj/item/reagent_containers/food/snacks/canned_bettles = 2,
			/obj/item/reagent_containers/food/snacks/rust_can = 2,
			/obj/item/reagent_containers/food/drinks/bottle/phobos = 1,
			/obj/item/reagent_containers/food/drinks/bottle/greenstuff = 1
			)
	cost = 50
	container_type = /obj/structure/closet/crate
	container_name = "Tyrmalin Culture crate"

/datum/supply_pack/misc/culture_alraune
	name = "Alraune Culture Crate"
	contains = list(
			/obj/item/reagent_containers/food/snacks/alraune_bar = 3,
			/obj/item/reagent_containers/food/snacks/bugsnacks = 3,
			/obj/item/reagent_containers/food/drinks/cans/alraune = 3
			)
	cost = 50
	container_type = /obj/structure/closet/crate
	container_name = "Alraune Culture crate"
