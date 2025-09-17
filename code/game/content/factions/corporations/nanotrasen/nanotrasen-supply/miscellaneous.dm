/*
*	Here is where any supply packs
*	that don't belong elsewhere live.
*/

/datum/supply_pack/nanotrasen/misc
	category = "Miscellaneous"

/datum/supply_pack/nanotrasen/misc/card_packs
	lazy_gacha_amount = 5
	lazy_gacha_contained = list(
			/obj/item/pack/cardemon,
			/obj/item/pack/spaceball,
			/obj/item/deck/holder
			)
	name = "Trading Card Crate"
	worth = 350
	container_type = /obj/structure/closet/crate/corporate/allico
	container_name = "cards crate"

/datum/supply_pack/nanotrasen/misc/dnd
	lazy_gacha_amount = 4
	lazy_gacha_contained = list(
			/obj/item/toy/character/alien,
			/obj/item/toy/character/warrior,
			/obj/item/toy/character/cleric,
			/obj/item/toy/character/thief,
			/obj/item/toy/character/wizard,
			/obj/item/toy/character/voidone,
			/obj/item/toy/character/lich
			)
	name = "Miniatures Crate"
	worth = 350
	container_type = /obj/structure/closet/crate/corporate/allico
	container_name = "Miniature Crate"

/datum/supply_pack/nanotrasen/misc/plushies
	name = "Plushies Crate"
	lazy_gacha_amount = 5
	lazy_gacha_contained = list(
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
		/obj/item/toy/plushie/squid/pink,
	)
	worth = 350
	container_type = /obj/structure/closet/crate/corporate/allico
	container_name = "Plushies Crate"

/datum/supply_pack/nanotrasen/misc/eftpos
	name = "EFTPOS scanner"
	contains = list(
		/obj/item/eftpos,
	)
	worth = 150

/datum/supply_pack/nanotrasen/misc/chaplaingear
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
		/obj/item/reagent_containers/food/drinks/bottle/holywater,
	)
	worth = 850 // lmao larper tax

/datum/supply_pack/nanotrasen/misc/hoverpod
	name = "Hoverpod Shipment"
	container_type = /obj/structure/largecrate/hoverpod
	worth = 1000

/datum/supply_pack/nanotrasen/misc/webbing
	name = "Webbing crate"
	lazy_gacha_amount = 4
	lazy_gacha_contained = list(
			/obj/item/clothing/accessory/storage/black_vest,
			/obj/item/clothing/accessory/storage/brown_vest,
			/obj/item/clothing/accessory/storage/white_vest,
			/obj/item/clothing/accessory/storage/black_drop_pouches,
			/obj/item/clothing/accessory/storage/brown_drop_pouches,
			/obj/item/clothing/accessory/storage/white_drop_pouches,
			/obj/item/clothing/accessory/storage/webbing
			)
	worth = 150
	container_type = /obj/structure/closet/crate
	container_name = "Webbing crate"

/datum/supply_pack/nanotrasen/misc/holoplant
	name = "Holoplant Pot"
	contains = list(
		/obj/machinery/holoplant/shipped,
	)
	worth = 50

/datum/supply_pack/nanotrasen/misc/glucose_hypos
	name = "Glucose Hypoinjectors"
	contains = list(
		/obj/item/reagent_containers/hypospray/autoinjector/biginjector/glucose = 5,
	)
	worth = 100

/datum/supply_pack/nanotrasen/misc/mre_rations
	name = "Emergency - MREs"
	contains = list(
		/obj/item/storage/single_use/mre,
		/obj/item/storage/single_use/mre/menu2,
		/obj/item/storage/single_use/mre/menu3,
		/obj/item/storage/single_use/mre/menu4,
		/obj/item/storage/single_use/mre/menu5,
		/obj/item/storage/single_use/mre/menu6,
		/obj/item/storage/single_use/mre/menu7,
		/obj/item/storage/single_use/mre/menu8,
		/obj/item/storage/single_use/mre/menu9,
		/obj/item/storage/single_use/mre/menu10,
	)
	worth = 300
	container_type = /obj/structure/closet/crate/corporate/centauri

/datum/supply_pack/nanotrasen/misc/paste_rations
	name = "Emergency - Paste"
	contains = list(
		/obj/item/storage/single_use/mre/menu11 = 2,
	)
	worth = 75
	container_type = /obj/structure/closet/crate/corporate/centauri

/datum/supply_pack/nanotrasen/misc/medical_rations
	name = "Emergency - VitaPaste"
	contains = list(
		/obj/item/storage/single_use/mre/menu13 = 2,
	)
	worth = 100
	container_type = /obj/structure/closet/crate/corporate/centauri

/datum/supply_pack/nanotrasen/misc/beltminer
	name = "Belt-miner gear crate"
	contains = list(
		/obj/item/gun/projectile/energy/particle = 2,
		/obj/item/cell/device/weapon = 2,
		/obj/item/storage/firstaid/regular = 1,
		/obj/item/gps = 2,
		/obj/item/storage/box/traumainjectors = 1,
	)
	worth = 500
	container_type = /obj/structure/closet/crate/secure/corporate/grayson

/datum/supply_pack/nanotrasen/misc/eva_rig
	name = "eva hardsuit (empty)"
	contains = list(
		/obj/item/hardsuit/eva = 1,
	)
	worth = 750
	container_type = /obj/structure/closet/crate/secure/gear

/datum/supply_pack/nanotrasen/misc/mining_rig
	name = "industrial hardsuit (empty)"
	contains = list(
		/obj/item/hardsuit/industrial = 1,
	)
	worth = 750
	container_type = /obj/structure/closet/crate/secure/corporate/grayson

/datum/supply_pack/nanotrasen/misc/medical_rig
	name = "medical hardsuit (empty)"
	contains = list(
		/obj/item/hardsuit/medical = 1,
	)
	worth = 750

/datum/supply_pack/nanotrasen/misc/phoronoid
	name  = "Spare Phoronoid containment suits"
	contains = list(
		/obj/item/clothing/suit/space/void/plasman = 3,
		/obj/item/clothing/mask/breath = 3,
		/obj/item/tank/vox = 3,
	)
	worth = 500

/datum/supply_pack/nanotrasen/misc/security_rig
	name = "hazard hardsuit (empty)"
	contains = list(
		/obj/item/hardsuit/hazard = 1,
	)
	worth = 750
	container_type = /obj/structure/closet/crate/secure/gear
	container_access = list(
		/datum/access/station/security/equipment,
	)

/datum/supply_pack/nanotrasen/misc/science_rig
	name = "ami hardsuit (empty)"
	contains = list(
		/obj/item/hardsuit/hazmat = 1,
	)
	worth = 750

/datum/supply_pack/nanotrasen/misc/ce_rig
	name = "advanced hardsuit (empty)"
	contains = list(
		/obj/item/hardsuit/ce = 1,
	)
	worth = 750
	container_type = /obj/structure/closet/crate/secure/corporate/aether

/datum/supply_pack/nanotrasen/misc/colored_lights
	name = "Colored Lights Bundle"
	contains = list(
		/obj/item/storage/box/lights/bulbs_colored = 2,
		/obj/item/storage/box/lights/tubes_colored = 2,
		/obj/item/storage/box/lights/mixed_colored = 1,
	)

/datum/supply_pack/nanotrasen/misc/neon_lights
	name = "Neon Lights Bundle"
	contains = list(
		/obj/item/storage/box/lights/bulbs_neon = 2,
		/obj/item/storage/box/lights/tubes_neon = 2,
		/obj/item/storage/box/lights/mixed_neon = 1,
	)

//Culture Crates
/datum/supply_pack/nanotrasen/misc/culture_apidean
	name = "Apidean Culture Crate"
	contains = list(
		/obj/fiftyspawner/wax = 2,
		/obj/item/healthanalyzer/apidean = 1,
		/obj/item/atmos_analyzer/apidean = 1,
		/obj/item/reagent_scanner/apidean = 1,
		/mob/living/bot/medibot/apidean = 1,
		/obj/item/reagent_containers/food/drinks/bottle/ambrosia_mead = 2,
		/obj/item/reagent_containers/food/drinks/bottle/royaljelly = 1,
	)
	worth = 1000

/datum/supply_pack/nanotrasen/misc/culture_tyrmalin
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
		/obj/item/reagent_containers/food/drinks/bottle/greenstuff = 1,
	)
	worth = 1000

/datum/supply_pack/nanotrasen/misc/culture_alraune
	name = "Alraune Culture Crate"
	contains = list(
		/obj/item/reagent_containers/food/snacks/wrapped/alraune_bar = 3,
		/obj/item/reagent_containers/food/snacks/boxed/bugsnacks = 3,
		/obj/item/reagent_containers/food/drinks/cans/alraune = 3,
	)
	worth = 1000

/datum/supply_pack/nanotrasen/misc/music_players
	name = "Portable Music Players"
	contains = list(
		/obj/item/device/walkpod = 3,
	)
	worth = 75
