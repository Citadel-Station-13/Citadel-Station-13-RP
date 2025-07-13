/*
*	Here is where any supply packs
*	related to recreation live.
*/


/datum/supply_pack/nanotrasen/recreation
	abstract_type = /datum/supply_pack/nanotrasen/recreation
	category = "Recreation"

/datum/supply_pack/nanotrasen/recreation/foam_weapons
	name = "Foam Weapon Crate"
	contains = list(
		/obj/item/material/sword/foam = 2,
		/obj/item/material/twohanded/baseballbat/foam = 2,
		/obj/item/material/twohanded/spear/foam = 2,
		/obj/item/material/twohanded/fireaxe/foam = 2,
	)
	worth = 300

/datum/supply_pack/nanotrasen/recreation/lasertag
	name = "Lasertag equipment"
	contains = list(
		/obj/item/gun/projectile/energy/lasertag/red,
		/obj/item/clothing/suit/redtag,
		/obj/item/gun/projectile/energy/lasertag/blue,
		/obj/item/clothing/suit/bluetag,
	)
	container_type = /obj/structure/closet
	container_name = "Lasertag Closet"
	worth = 100

/datum/supply_pack/nanotrasen/recreation/artscrafts
	name = "Arts and Crafts supplies"
	contains = list(
		/obj/item/storage/fancy/crayons,
		/obj/item/storage/fancy/markers,
		/obj/item/camera,
		/obj/item/camera_film = 2,
		/obj/item/storage/photo_album,
		/obj/item/packageWrap,
		/obj/item/reagent_containers/glass/paint/red,
		/obj/item/reagent_containers/glass/paint/green,
		/obj/item/reagent_containers/glass/paint/blue,
		/obj/item/reagent_containers/glass/paint/yellow,
		/obj/item/reagent_containers/glass/paint/purple,
		/obj/item/reagent_containers/glass/paint/black,
		/obj/item/reagent_containers/glass/paint/white,
		/obj/item/poster,
		/obj/item/wrapping_paper = 3,
	)
	worth = 350

/datum/supply_pack/nanotrasen/recreation/painters
	name = "Station Painting Supplies"
	contains = list(
		/obj/item/pipe_painter = 2,
		/obj/item/floor_painter = 2,
	)
	worth = 500 // this is pretty much just clowning supplies

/datum/supply_pack/nanotrasen/recreation/cheap_bait
	name = "Cheap Fishing Bait"
	container_name = "cheap bait crate"
	container_type = /obj/structure/closet/crate/freezer
	contains = list(
		/obj/item/storage/box/wormcan/sickly = 5,
	)
	worth = 100

/datum/supply_pack/nanotrasen/recreation/less_cheap_bait
	name = "Deluxe Fishing Bait"
	container_type = /obj/structure/closet/crate/freezer
	lazy_gacha_amount = 5
	lazy_gacha_contained = list(
		/obj/item/storage/box/wormcan,
		/obj/item/storage/box/wormcan/deluxe,
	)
	worth = 400

// todo: this is dumb because you're just spawning turrets in, why the fuck?
// /datum/supply_pack/nanotrasen/recreation/ltagturrets
// 	name = "Laser Tag Turrets"
// 	cost = 40
// 	container_name = "laser tag turret crate"
// 	container_type = /obj/structure/closet/crate
// 	contains = list(
// 		/obj/machinery/porta_turret/lasertag/blue,
// 		/obj/machinery/porta_turret/lasertag/red
// 	)

/datum/supply_pack/nanotrasen/recreation/jukebox
	name = "Jukebox crate"
	contains = list (
		/obj/machinery/media/jukebox = 1,
	)
	worth = 500

/datum/supply_pack/nanotrasen/recreation/restraints
	name = "Recreational Restraints"
	contains = list(
		/obj/item/clothing/mask/muzzle,
		/obj/item/clothing/glasses/sunglasses/blindfold,
		/obj/item/handcuffs/fuzzy,
		/obj/item/duct_tape_roll,
		/obj/item/stack/cable_coil/random,
		/obj/item/clothing/accessory/collar/shock,
		/obj/item/clothing/suit/straight_jacket,
		/obj/item/handcuffs/legcuffs/fuzzy,
		/obj/item/melee/fluff/holochain/mass,
		/obj/item/fluff/riding_crop,
		/obj/item/clothing/under/fluff/latexmaid,
	)
	worth = 500
	legacy_contraband = TRUE

/datum/supply_pack/nanotrasen/recreation/wolfgirl_cosplay_crate
	name = "Wolfgirl Cosplay Crate"
	contains = list(
		/obj/item/clothing/head/fluff/wolfgirl = 1,
		/obj/item/clothing/shoes/fluff/wolfgirl = 1,
		/obj/item/clothing/under/fluff/wolfgirl = 1,
		/obj/item/melee/fluffstuff/wolfgirlsword = 1,
		/obj/item/shield/fluff/wolfgirlshield = 1,
	)
	worth = 750

/datum/supply_pack/nanotrasen/recreation/figures
	name = "Action figures crate"
	contains = list(
		/obj/random/action_figure/supplypack = 5,
	)
	worth = 750
	container_type = /obj/structure/closet/crate/corporate/allico

/datum/supply_pack/nanotrasen/recreation/characters
	name = "Tabletop miniatures"
	contains = list(
		/obj/item/storage/box/characters,
	)
	worth = 750
	container_name = "Tabletop miniatures crate"

/datum/supply_pack/nanotrasen/recreation/plushies
	name = "Plushies crate"
	contains = list(
		/obj/random/plushie = 3,
	)
	worth = 300
	container_type = /obj/structure/closet/crate/corporate/allico

/datum/supply_pack/nanotrasen/recreation/collars
	name = "Collar bundle"
	contains = list(
		/obj/item/clothing/accessory/collar/shock = 1,
		/obj/item/clothing/accessory/collar/spike = 1,
		/obj/item/clothing/accessory/collar/silver = 1,
		/obj/item/clothing/accessory/collar/gold = 1,
		/obj/item/clothing/accessory/collar/bell = 1,
		/obj/item/clothing/accessory/collar/pink = 1,
		/obj/item/clothing/accessory/collar/holo = 1,
		/obj/item/bikehorn/clicker/random = 3, // i'm sorry
	)
	worth = 500

//DONKsoft
/datum/supply_pack/nanotrasen/recreation/donksoft
	name = "DONKsoft Skirmish Bundle"
	contains = list(
		/obj/item/gunbox/donksoft = 2,
		/obj/item/gunbox/donksoft/shotgun = 2,
		/obj/item/gunbox/donksoft/smg = 2,
		/obj/item/material/sword/foam = 2,
		/obj/item/shield/riot/foam = 2,
	)
	worth = 750

/datum/supply_pack/nanotrasen/recreation/donksoft_exotic
	name = "DONKsoft Exotic Weaponry Bundle"
	contains = list(
		/obj/item/gun/projectile/ballistic/automatic/c20r/foam = 2,
		/obj/item/gun/projectile/ballistic/automatic/lmg/foam = 1,
		/obj/item/ammo_magazine/foam/smg = 4,
		/obj/item/ammo_magazine/foam/lmg = 2,
		/obj/item/material/twohanded/spear/foam = 2,
		/obj/item/material/twohanded/fireaxe/foam = 1,
	)
	worth = 1500

/datum/supply_pack/nanotrasen/recreation/donksoft_ammo
	name = "DONKsoft Resupply Bundle"
	contains = list(
		/obj/item/ammo_magazine/foam/box= 4,
	)
	worth = 250

/datum/supply_pack/nanotrasen/recreation/pelletgun
	name = "Recreational Pellet Gun"
	contains = list(
		/obj/item/gun/projectile/ballistic/caseless/pellet,
		/obj/item/ammo_magazine/pellets,
	)
	worth = 75
