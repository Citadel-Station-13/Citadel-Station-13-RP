/*
*	Here is where any supply packs that may or may not be legal
*	  and require modification of the supply controller live.
*/

// todo: wow this sucks
/datum/supply_pack/nanotrasen/contraband
	contains_some = list(
		list(
			"amount" = 5,
			"entities" = list(
				/obj/item/seeds/bloodtomatoseed,
				/obj/item/storage/pill_bottle/zoom,
				/obj/item/storage/pill_bottle/happy,
				/obj/item/reagent_containers/food/drinks/bottle/pwine,
				/obj/item/reagent_containers/food/drinks/cans/geometer = 2,
			),
		),
	)

	worth = 250

	name = "Contraband crate"
	container_type = /obj/structure/closet/crate
	container_name = "Unlabeled crate"
	legacy_contraband = 1
	category = "Supplies"

/datum/supply_pack/nanotrasen/security/specialops
	name = "Special Ops supplies"
	contains = list(
			/obj/item/storage/box/emps,
			/obj/item/grenade/simple/smoke = 4,
			/obj/item/grenade/simple/chemical/premade/incendiary,
			)
	container_type = /obj/structure/closet/crate
	container_name = "Special Ops crate"
	legacy_contraband = 1

/datum/supply_pack/nanotrasen/munitions/bolt_rifles_militia
    name = "Weapon - Misplaced militia rifles"
    contains = list(
		/obj/item/gun/projectile/ballistic/shotgun/pump/rifle = 3,
		/obj/item/ammo_magazine/a7_62mm/clip = 6,
	)
    legacy_contraband = 1
    container_type = /obj/structure/closet/crate/secure/weapon
    container_name = "Ballistic weapons crate"
    container_access = ACCESS_SECURITY_ARMORY

/datum/supply_pack/nanotrasen/misc/telecrate //you get something awesome, a couple of decent things, and a few weak/filler things
	name = "ERR_NULL_ENTRY" //null crate! also dream maker is hell,
	contains_some = list(
		list(
			"entities" = list(
				/obj/item/storage/box/cargo_null_entry_kit/ops,
				/obj/item/storage/box/cargo_null_entry_kit/doctor,
				/obj/item/storage/box/cargo_null_entry_kit/sapper,
				/obj/item/storage/box/cargo_null_entry_kit/spy,
				/obj/item/storage/box/cargo_null_entry_kit/pro,
			),
			"amount" = 1,
		),
	)
	worth = 5000
	legacy_contraband = 1
	container_type = /obj/structure/largecrate
	container_name = "Suspicious crate"

/obj/item/storage/box/cargo_null_entry_kit
	desc = "What's in here?"

/obj/item/storage/box/cargo_null_entry_kit/ops
	name = "operator's kit"

/obj/item/storage/box/cargo_null_entry_kit/ops/legacy_spawn_contents()
	new /obj/item/gun/projectile/ballistic/shotgun/pump/combat(src)
	new /obj/item/clothing/suit/storage/vest/heavy/merc(src)
	new /obj/item/clothing/glasses/night(src)
	new /obj/item/storage/box/anti_photons(src)
	new /obj/item/ammo_magazine/a12g/clip/pellet(src)
	new /obj/item/ammo_magazine/a12g/clip(src)

/obj/item/storage/box/cargo_null_entry_kit/doctor
	name = "doctor's kit"

/obj/item/storage/box/cargo_null_entry_kit/doctor/legacy_spawn_contents()
	new /obj/item/storage/firstaid/combat(src)
	new /obj/item/gun/projectile/ballistic/dartgun(src)
	new /obj/item/reagent_containers/hypospray(src)
	new /obj/item/reagent_containers/glass/bottle/chloralhydrate(src)
	new /obj/item/reagent_containers/glass/bottle/cyanide(src)
	new /obj/item/ammo_magazine/chemdart(src)

/obj/item/storage/box/cargo_null_entry_kit/sapper
	name = "sapper's kit"

/obj/item/storage/box/cargo_null_entry_kit/sapper/legacy_spawn_contents()
	new /obj/item/melee/transforming/energy/sword/ionic_rapier(src)
	new /obj/item/storage/box/syndie_kit/space(src)
	new /obj/item/storage/box/syndie_kit/demolitions(src)
	new /obj/item/multitool/ai_detector(src)
	new /obj/item/plastique(src)
	new /obj/item/storage/toolbox/syndicate/powertools(src)

/obj/item/storage/box/cargo_null_entry_kit/spy
	name = "spy's kit"

/obj/item/storage/box/cargo_null_entry_kit/spy/legacy_spawn_contents()
	new /obj/item/gun/projectile/ballistic/silenced(src)
	new /obj/item/storage/box/syndie_kit/chameleon(src)
	new /obj/item/encryptionkey/syndicate(src)
	new /obj/item/card/id/syndicate(src)
	new /obj/item/clothing/mask/gas/voice(src)
	new /obj/item/makeover(src)

/obj/item/storage/box/cargo_null_entry_kit/pro
	name = "professional's kit"

/obj/item/storage/box/cargo_null_entry_kit/pro/legacy_spawn_contents()
	new /obj/item/gun/projectile/ballistic/silenced(src)
	new /obj/item/gun/projectile/energy/ionrifle/pistol(src)
	new /obj/item/clothing/glasses/thermal/syndi(src)
	new /obj/item/card/emag(src)
	new /obj/item/ammo_magazine/a45/doublestack/ap(src)
	new /obj/item/material/knife/tacknife/combatknife(src)
	new /obj/item/clothing/mask/balaclava(src)

/datum/supply_pack/nanotrasen/supply/stolen
	name = "Stolen Supply Crate"
	contains = list(
		/obj/item/stolenpackage = 1,
	)
	container_type = /obj/structure/closet/crate
	container_name = "shady crate"
	legacy_contraband = 1

/datum/supply_pack/nanotrasen/stolenplus
	name = "Bulk Stolen Supply Crate"
	contains_some = list(
		list(
			"amount" = 4,
			"entities" = list(
				/obj/item/stolenpackage,
				/obj/item/stolenpackageplus,
			),
		),
	)
	worth = /obj/item/stolenpackageplus::worth_intrinsic * 4
	container_type = /obj/structure/closet/crate
	container_name = "shadier crate"
	legacy_contraband = 1
	category = "Supplies"

/datum/supply_pack/nanotrasen/supply/medieval
	name = "Knight set crate"
	contains = list(
		/obj/item/clothing/head/helmet/medieval/red = 1,
		/obj/item/clothing/head/helmet/medieval/green = 1,
		/obj/item/clothing/head/helmet/medieval/blue = 1,
		/obj/item/clothing/head/helmet/medieval/orange = 1,
		/obj/item/clothing/suit/armor/medieval/red = 1,
		/obj/item/clothing/suit/armor/medieval/green = 1,
		/obj/item/clothing/suit/armor/medieval/blue = 1,
		/obj/item/clothing/suit/armor/medieval/orange = 1,
	)
	container_type = /obj/structure/closet/crate
	container_name = "knight set crate"
	legacy_contraband = 1

/datum/supply_pack/nanotrasen/supply/deusvult_templar
	name = "Templar set crate"
	contains = list(
		/obj/item/clothing/head/helmet/medieval/crusader/templar,
		/obj/item/clothing/suit/armor/medieval/crusader/cross/templar,
		/obj/item/clothing/accessory/poncho/roles/cloak/custom/crusade/templar,
	)
	container_type = /obj/structure/closet/crate
	container_name = "templar armor crate"
	legacy_contraband = 1

/datum/supply_pack/nanotrasen/supply/deusvult_hospitaller
	name = "Hospitaller set crate"
	contains = list(
		/obj/item/clothing/head/helmet/medieval/crusader,
		/obj/item/clothing/suit/armor/medieval/crusader/cross/hospitaller,
		/obj/item/clothing/accessory/poncho/roles/cloak/custom/crusade/hospitaller,
	)
	container_type = /obj/structure/closet/crate
	container_name = "hospitaller armor crate"
	legacy_contraband = 1

/datum/supply_pack/nanotrasen/supply/deusvult_teutonic
	name = "Teutonic set crate"
	contains = list(
		/obj/item/clothing/head/helmet/medieval/crusader/horned,
		/obj/item/clothing/head/helmet/medieval/crusader/winged,
		/obj/item/clothing/suit/armor/medieval/crusader/cross,
		/obj/item/clothing/suit/armor/medieval/crusader/cross/teutonic,
		/obj/item/clothing/accessory/poncho/roles/cloak/custom/crusade,
		/obj/item/clothing/accessory/poncho/roles/cloak/custom/crusade/teutonic,
	)
	container_type = /obj/structure/closet/crate
	container_name = "teutonic armor crate"
	legacy_contraband = 1

/datum/supply_pack/nanotrasen/robotics/salvage
	name = "Redirected Mech Salvage"
	contains = list(
		/obj/item/mechasalvage = 6,
	)
	container_type = /obj/structure/closet/crate
	container_name = "oil-stained crate"
	legacy_contraband = 1

/datum/supply_pack/nanotrasen/material/rareores
	name = "Smuggled Ores and Materials"
	contains_some = list(
		list(
			"amount" = 20,
			"entities" = list(
				/obj/item/stack/material/bananium,
				/obj/item/stack/material/diamond,
				/obj/item/stack/material/durasteel,
				/obj/item/stack/material/morphium,
				/obj/item/stack/material/platinum,
				/obj/item/stack/material/verdantium,
				/obj/item/stack/material/mhydrogen,
				/obj/item/stack/material/silencium,
				/obj/item/stack/material/valhollide,
			),
		),
	)
	worth = 1000
	container_type = /obj/structure/closet/crate
	container_name = "dented mining crate"
	legacy_contraband = 1
	category = "Materials"
