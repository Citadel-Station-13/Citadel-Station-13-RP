/*
*	Here is where any supply packs that may or may not be legal
*	  and require modification of the supply controller live.
*/


/datum/supply_pack/randomised/contraband
	num_contained = 5
	contains = list(
			/obj/item/seeds/bloodtomatoseed,
			/obj/item/storage/pill_bottle/zoom,
			/obj/item/storage/pill_bottle/happy,
			/obj/item/reagent_containers/food/drinks/bottle/pwine,
			/obj/item/reagent_containers/food/drinks/cans/geometer = 2
			)

	name = "Contraband crate"
	cost = 25
	container_type = /obj/structure/closet/crate
	container_name = "Unlabeled crate"
	contraband = 1
	group = "Supplies"

/datum/supply_pack/security/specialops
	name = "Special Ops supplies"
	contains = list(
			/obj/item/storage/box/emps,
			/obj/item/grenade/smokebomb = 4,
			/obj/item/grenade/chem_grenade/incendiary
			)
	cost = 25
	container_type = /obj/structure/closet/crate
	container_name = "Special Ops crate"
	contraband = 1

/datum/supply_pack/supply/moghes
	name = "Moghes imports"
	contains = list(
			/obj/item/reagent_containers/food/drinks/bottle/redeemersbrew = 2,
			/obj/item/reagent_containers/food/snacks/unajerky = 4
			)
	cost = 25
	container_type = /obj/structure/closet/crate/unathi
	container_name = "Moghes imports crate"
	contraband = 1

/datum/supply_pack/munitions/bolt_rifles_militia
    name = "Weapon - Misplaced militia rifles"
    contains = list(
            /obj/item/gun/ballistic/shotgun/pump/rifle = 3,
            /obj/item/ammo_magazine/clip/c762 = 6
            )
    cost = 50
    contraband = 1
    container_type = /obj/structure/closet/crate/secure/weapon
    container_name = "Ballistic weapons crate"
    access = ACCESS_SECURITY_ARMORY

/datum/supply_pack/randomised/misc/telecrate //you get something awesome, a couple of decent things, and a few weak/filler things
	name = "ERR_NULL_ENTRY" //null crate! also dream maker is hell,
	num_contained = 1
	contains = list(
		/obj/item/storage/box/cargo_null_entry_kit/ops,
		/obj/item/storage/box/cargo_null_entry_kit/doctor,
		/obj/item/storage/box/cargo_null_entry_kit/sapper,
		/obj/item/storage/box/cargo_null_entry_kit/spy,
		/obj/item/storage/box/cargo_null_entry_kit/pro
	)
	cost = 250 //more than a hat crate!,
	contraband = 1
	container_type = /obj/structure/largecrate
	container_name = "Suspicious crate"

/obj/item/storage/box/cargo_null_entry_kit
	desc = "What's in here?"

/obj/item/storage/box/cargo_null_entry_kit/ops
	name = "operator's kit"

/obj/item/storage/box/cargo_null_entry_kit/ops/PopulateContents()
	new /obj/item/gun/ballistic/shotgun/pump/combat(src)
	new /obj/item/clothing/suit/storage/vest/heavy/merc(src)
	new /obj/item/clothing/glasses/night(src)
	new /obj/item/storage/box/anti_photons(src)
	new /obj/item/ammo_magazine/clip/c12g/pellet(src)
	new /obj/item/ammo_magazine/clip/c12g(src)

/obj/item/storage/box/cargo_null_entry_kit/doctor
	name = "doctor's kit"

/obj/item/storage/box/cargo_null_entry_kit/doctor/PopulateContents()
	new /obj/item/storage/firstaid/combat(src)
	new /obj/item/gun/ballistic/dartgun(src)
	new /obj/item/reagent_containers/hypospray(src)
	new /obj/item/reagent_containers/glass/bottle/chloralhydrate(src)
	new /obj/item/reagent_containers/glass/bottle/cyanide(src)
	new /obj/item/ammo_magazine/chemdart(src)

/obj/item/storage/box/cargo_null_entry_kit/sapper
	name = "sapper's kit"

/obj/item/storage/box/cargo_null_entry_kit/sapper/PopulateContents()
	new /obj/item/melee/energy/sword/ionic_rapier(src)
	new /obj/item/storage/box/syndie_kit/space(src)
	new /obj/item/storage/box/syndie_kit/demolitions(src)
	new /obj/item/multitool/ai_detector(src)
	new /obj/item/plastique(src)
	new /obj/item/storage/toolbox/syndicate/powertools(src)

/obj/item/storage/box/cargo_null_entry_kit/spy
	name = "spy's kit"

/obj/item/storage/box/cargo_null_entry_kit/spy/PopulateContents()
	new /obj/item/gun/ballistic/silenced(src)
	new /obj/item/chameleon(src)
	new /obj/item/storage/box/syndie_kit/chameleon(src)
	new /obj/item/encryptionkey/syndicate(src)
	new /obj/item/card/id/syndicate(src)
	new /obj/item/clothing/mask/gas/voice(src)
	new /obj/item/makeover(src)

/obj/item/storage/box/cargo_null_entry_kit/pro
	name = "professional's kit"

/obj/item/storage/box/cargo_null_entry_kit/pro/PopulateContents()
	new /obj/item/gun/ballistic/silenced(src)
	new /obj/item/gun/energy/ionrifle/pistol(src)
	new /obj/item/clothing/glasses/thermal/syndi(src)
	new /obj/item/card/emag(src)
	new /obj/item/ammo_magazine/m45/ap(src)
	new /obj/item/material/knife/tacknife/combatknife(src)
	new /obj/item/clothing/mask/balaclava(src)

/datum/supply_pack/supply/stolen
	name = "Stolen Supply Crate"
	contains = list(/obj/item/stolenpackage = 1)
	cost = 75
	container_type = /obj/structure/closet/crate
	container_name = "shady crate"
	contraband = 1

/datum/supply_pack/randomised/stolenplus
	name = "Bulk Stolen Supply Crate"
	num_contained = 4
	contains = list(
		/obj/item/stolenpackage,
		/obj/item/stolenpackageplus,
		) // uh oh
	cost = 375 //slight discount? still contraband tho glhf
	container_type = /obj/structure/closet/crate
	container_name = "shadier crate"
	contraband = 1
	group = "Supplies"

/datum/supply_pack/supply/wolfgirl
	name = "Wolfgirl Crate"
	cost = 200 //I mean, it's a whole wolfgirl
	container_type = /obj/structure/largecrate/animal/wolfgirl
	container_name = "Wolfgirl crate"
	contraband = 1

/datum/supply_pack/supply/medieval
	name = "Knight set crate"
	contains = list(
			/obj/item/clothing/head/helmet/medieval/red = 1,
			/obj/item/clothing/head/helmet/medieval/green = 1,
			/obj/item/clothing/head/helmet/medieval/blue = 1,
			/obj/item/clothing/head/helmet/medieval/orange = 1,
			/obj/item/clothing/suit/armor/medieval/red = 1,
			/obj/item/clothing/suit/armor/medieval/green = 1,
			/obj/item/clothing/suit/armor/medieval/blue = 1,
			/obj/item/clothing/suit/armor/medieval/orange = 1
			)
	cost = 120
	container_type = /obj/structure/closet/crate
	container_name = "knight set crate"
	contraband = 1

/datum/supply_pack/supply/deusvult_templar
	name = "Templar set crate"
	contains = list(
			/obj/item/clothing/head/helmet/medieval/crusader/templar,
			/obj/item/clothing/suit/armor/medieval/crusader/cross/templar,
			/obj/item/clothing/accessory/poncho/roles/cloak/custom/crusade/templar
			)
	cost = 30
	container_type = /obj/structure/closet/crate
	container_name = "templar armor crate"
	contraband = 1

/datum/supply_pack/supply/deusvult_hospitaller
	name = "Hospitaller set crate"
	contains = list(
			/obj/item/clothing/head/helmet/medieval/crusader,
			/obj/item/clothing/suit/armor/medieval/crusader/cross/hospitaller,
			/obj/item/clothing/accessory/poncho/roles/cloak/custom/crusade/hospitaller
			)
	cost = 30
	container_type = /obj/structure/closet/crate
	container_name = "hospitaller armor crate"
	contraband = 1

/datum/supply_pack/supply/deusvult_teutonic
	name = "Teutonic set crate"
	contains = list(
			/obj/item/clothing/head/helmet/medieval/crusader/horned,
			/obj/item/clothing/head/helmet/medieval/crusader/winged,
			/obj/item/clothing/suit/armor/medieval/crusader/cross,
			/obj/item/clothing/suit/armor/medieval/crusader/cross/teutonic,
			/obj/item/clothing/accessory/poncho/roles/cloak/custom/crusade,
			/obj/item/clothing/accessory/poncho/roles/cloak/custom/crusade/teutonic
			)
	cost = 40
	container_type = /obj/structure/closet/crate
	container_name = "teutonic armor crate"
	contraband = 1
