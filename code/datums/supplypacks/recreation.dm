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
	containertype = /obj/structure/closet/crate
	containername = "foam weapon crate"

/datum/supply_pack/recreation/lasertag
	name = "Lasertag equipment"
	contains = list(
			/obj/item/gun/energy/lasertag/red,
			/obj/item/clothing/suit/redtag,
			/obj/item/gun/energy/lasertag/blue,
			/obj/item/clothing/suit/bluetag
			)
	containertype = /obj/structure/closet
	containername = "Lasertag Closet"
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
	containertype = /obj/structure/closet/crate
	containername = "Arts and Crafts crate"

/datum/supply_pack/recreation/painters
	name = "Station Painting Supplies"
	cost = 10
	containername = "station painting supplies crate"
	containertype = /obj/structure/closet/crate
	contains = list(
			/obj/item/pipe_painter = 2,
			/obj/item/floor_painter = 2,
			/obj/item/closet_painter = 2
			)

/datum/supply_pack/recreation/cheapbait
	name = "Cheap Fishing Bait"
	cost = 10
	containername = "cheap bait crate"
	containertype = /obj/structure/closet/crate/freezer
	contains = list(
			/obj/item/storage/box/wormcan/sickly = 5
			)

/datum/supply_pack/randomised/recreation/cheapbait
	name = "Deluxe Fishing Bait"
	cost = 40
	containername = "deluxe bait crate"
	containertype = /obj/structure/closet/crate/freezer
	num_contained = 8
	contains = list(
			/obj/item/storage/box/wormcan,
			/obj/item/storage/box/wormcan/deluxe
			)

/datum/supply_pack/recreation/ltagturrets
	name = "Laser Tag Turrets"
	cost = 40
	containername = "laser tag turret crate"
	containertype = /obj/structure/closet/crate
	contains = list(
			/obj/machinery/porta_turret/lasertag/blue,
			/obj/machinery/porta_turret/lasertag/red
			)

/datum/supply_pack/recreation/jukebox
	name = "Jukebox crate"
	cost = 50
	containername = "Jukebox crate"
	containertype = /obj/structure/closet/crate
	contains = list (/obj/machinery/media/jukebox = 1)


/datum/supply_pack/recreation/rover
	name = "NT Humvee"
	contains = list(
			/obj/vehicle/train/rover/engine
			)
	containertype = /obj/structure/largecrate
	containername = "NT Humvee Crate"
	cost = 500

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
	containertype = /obj/structure/closet/crate
	containername = "Restraints crate"
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
	containertype = /obj/structure/closet/crate
	containername = "wolfgirl cosplay crate"

/datum/supply_pack/randomised/recreation/figures
	name = "Action figures crate"
	num_contained = 5
	contains = list(
			/obj/random/action_figure/supplypack
			)
	cost = 200
	containertype = /obj/structure/closet/crate
	containername = "Action figures crate"

/datum/supply_pack/recreation/characters_vr
	name = "Tabletop miniatures"
	contains = list(
			/obj/item/storage/box/characters
			)
	containertype = /obj/structure/closet/crate
	containername = "Tabletop miniatures crate"
	cost = 50

/datum/supply_pack/randomised/recreation/plushies_vr
	name = "Plushies crate"
	num_contained = 3
	contains = list(
			/obj/random/plushie
			)
	cost = 60
	containertype = /obj/structure/closet/crate
	containername = "Plushies crate"

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
	containertype = /obj/structure/closet/crate
	containername = "collar crate"
