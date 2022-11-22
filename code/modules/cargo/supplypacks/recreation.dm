/*
*	Here is where any supply packs
*	related to recreation live.
*/


/datum/supply_pack/recreation
	group = "Recreation"

/datum/supply_pack/randomised/recreation
	group = "Recreation"
	access = access_security

/datum/supply_pack/recreation/foam_weapons
	name = "Foam Weapon Crate"
	contains = list(
			/obj/item/material/sword/foam = 2,
			/obj/item/material/twohanded/baseballbat/foam = 2,
			/obj/item/material/twohanded/spear/foam = 2,
			/obj/item/material/twohanded/fireaxe/foam = 2
			)
	cost = 50
	container_type = /obj/structure/closet/crate
	container_name = "foam weapon crate"

/datum/supply_pack/recreation/lasertag
	name = "Lasertag equipment"
	contains = list(
			/obj/item/gun/energy/lasertag/red,
			/obj/item/clothing/suit/redtag,
			/obj/item/gun/energy/lasertag/blue,
			/obj/item/clothing/suit/bluetag
			)
	container_type = /obj/structure/closet
	container_name = "Lasertag Closet"
	cost = 10

/datum/supply_pack/recreation/artscrafts
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
			/obj/item/contraband/poster,
			/obj/item/wrapping_paper = 3
			)
	cost = 10
	container_type = /obj/structure/closet/crate
	container_name = "Arts and Crafts crate"

/datum/supply_pack/recreation/painters
	name = "Station Painting Supplies"
	cost = 10
	container_name = "station painting supplies crate"
	container_type = /obj/structure/closet/crate
	contains = list(
			/obj/item/pipe_painter = 2,
			/obj/item/floor_painter = 2,
			/obj/item/closet_painter = 2
			)

/datum/supply_pack/recreation/cheapbait
	name = "Cheap Fishing Bait"
	cost = 10
	container_name = "cheap bait crate"
	container_type = /obj/structure/closet/crate/freezer
	contains = list(
			/obj/item/storage/box/wormcan/sickly = 5
			)

/datum/supply_pack/randomised/recreation/cheapbait
	name = "Deluxe Fishing Bait"
	cost = 40
	container_name = "deluxe bait crate"
	container_type = /obj/structure/closet/crate/freezer
	num_contained = 8
	contains = list(
			/obj/item/storage/box/wormcan,
			/obj/item/storage/box/wormcan/deluxe
			)

/datum/supply_pack/recreation/ltagturrets
	name = "Laser Tag Turrets"
	cost = 40
	container_name = "laser tag turret crate"
	container_type = /obj/structure/closet/crate
	contains = list(
			/obj/machinery/porta_turret/lasertag/blue,
			/obj/machinery/porta_turret/lasertag/red
			)

/datum/supply_pack/recreation/jukebox
	name = "Jukebox crate"
	cost = 50
	container_name = "Jukebox crate"
	container_type = /obj/structure/closet/crate
	contains = list (/obj/machinery/media/jukebox = 1)


/datum/supply_pack/recreation/restraints
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
			/obj/item/material/twohanded/fluff/riding_crop,
			/obj/item/clothing/under/fluff/latexmaid
			)
	container_type = /obj/structure/closet/crate
	container_name = "Restraints crate"
	cost = 30

/datum/supply_pack/recreation/wolfgirl_cosplay_crate
	name = "Wolfgirl Cosplay Crate"
	contains = list(
			/obj/item/clothing/head/fluff/wolfgirl = 1,
			/obj/item/clothing/shoes/fluff/wolfgirl = 1,
			/obj/item/clothing/under/fluff/wolfgirl = 1,
			/obj/item/melee/fluffstuff/wolfgirlsword = 1,
			/obj/item/shield/fluff/wolfgirlshield = 1
			)
	cost = 50
	container_type = /obj/structure/closet/crate
	container_name = "wolfgirl cosplay crate"

/datum/supply_pack/randomised/recreation/figures
	name = "Action figures crate"
	num_contained = 5
	contains = list(
			/obj/random/action_figure/supplypack
			)
	cost = 200
	container_type = /obj/structure/closet/crate/allico
	container_name = "Action figures crate"

/datum/supply_pack/recreation/characters
	name = "Tabletop miniatures"
	contains = list(
			/obj/item/storage/box/characters
			)
	container_type = /obj/structure/closet/crate
	container_name = "Tabletop miniatures crate"
	cost = 50

/datum/supply_pack/randomised/recreation/plushies
	name = "Plushies crate"
	num_contained = 3
	contains = list(
			/obj/random/plushie
			)
	cost = 60
	container_type = /obj/structure/closet/crate/allico
	container_name = "Plushies crate"

/datum/supply_pack/recreation/collars
	name = "Collar bundle"
	contains = list(
			/obj/item/clothing/accessory/collar/shock = 1,
			/obj/item/clothing/accessory/collar/spike = 1,
			/obj/item/clothing/accessory/collar/silver = 1,
			/obj/item/clothing/accessory/collar/gold = 1,
			/obj/item/clothing/accessory/collar/bell = 1,
			/obj/item/clothing/accessory/collar/pink = 1,
			/obj/item/clothing/accessory/collar/holo = 1
			)
	cost = 25
	container_type = /obj/structure/closet/crate
	container_name = "collar crate"

//DONKsoft
/datum/supply_pack/recreation/donksoft
	name = "DONKsoft Skirmish Bundle"
	contains = list(
			/obj/item/gunbox/donksoft = 2,
			/obj/item/gunbox/donksoft/shotgun = 2,
			/obj/item/gunbox/donksoft/smg = 2,
			/obj/item/material/sword/foam = 2,
			/obj/item/shield/riot/foam = 2
			)
	cost = 40
	container_type = /obj/structure/closet/crate
	container_name = "DONKsoft Skirmish crate"

/datum/supply_pack/recreation/donksoft_exotic
	name = "DONKsoft Exotic Weaponry Bundle"
	contains = list(
			/obj/item/gun/projectile/automatic/c20r/foam = 2,
			/obj/item/gun/projectile/automatic/l6_saw/foam = 1,
			/obj/item/ammo_magazine/mfoam/c20 = 4,
			/obj/item/ammo_magazine/mfoam/lmg = 2,
			/obj/item/material/twohanded/spear/foam = 2,
			/obj/item/material/twohanded/fireaxe/foam = 1
			)
	cost = 80
	container_type = /obj/structure/closet/crate
	container_name = "DONKsoft Exotic Weaponry crate"

/datum/supply_pack/recreation/donksoft_ammo
	name = "DONKsoft Resupply Bundle"
	contains = list(
			/obj/item/storage/box/foamdart= 4
			)
	cost = 20
	container_type = /obj/structure/closet/crate
	container_name = "DONKsoft Resupply crate"
