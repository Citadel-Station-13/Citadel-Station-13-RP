/*
*	Here is where any supply packs
*	related to weapons live.
*/

/datum/supply_pack/nanotrasen/munitions
	abstract_type = /datum/supply_pack/nanotrasen/munitions
	category = "Munitions"
	supply_pack_flags = SUPPLY_PACK_LOCK_PRIVATE_ORDERS | SUPPLY_PACK_RESTRICT_PRIVATE_ORDERS
	container_type = /obj/structure/closet/crate/secure/weapon
	container_access = list(
		/datum/access/station/security/armory,
	)

/datum/supply_pack/nanotrasen/munitions/egunpistol
	name = "Weapons - Energy sidearms"
	contains = list(
		/obj/item/gun/projectile/energy/gun = 2,
	)
	container_name = "Energy sidearms crate"

/datum/supply_pack/nanotrasen/munitions/flareguns
	name = "Weapons - Flare guns"
	contains = list(
		/obj/item/gun/projectile/ballistic/shotgun/flare = 2,
		/obj/item/storage/box/flashshells = 2,
	)
	container_type = /obj/structure/closet/crate/secure/gear
	container_name = "Flare gun crate"

/datum/supply_pack/nanotrasen/munitions/eweapons
	name = "Weapons - Experimental weapons crate"
	contains = list(
		/obj/item/gun/projectile/energy/xray = 2,
		/obj/item/shield/transforming/energy = 2,
	)
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Experimental weapons crate"

/datum/supply_pack/nanotrasen/munitions/energyweapons
	name = "Weapons - Laser rifle crate"
	contains = list(
		/obj/item/gun/projectile/energy/laser = 2,
	)
	container_type = /obj/structure/closet/crate/secure/corporate/heph
	container_name = "Energy weapons crate"

/datum/supply_pack/nanotrasen/munitions/shotgun
	name = "Weapons - Shotgun crate"
	contains = list(
		/obj/item/storage/box/shotgunammo,
		/obj/item/storage/box/shotgunshells,
		/obj/item/gun/projectile/ballistic/shotgun/pump/combat = 2,
	)
	container_type = /obj/structure/closet/crate/secure/corporate/ward
	container_name = "Shotgun crate"

/datum/supply_pack/nanotrasen/munitions/erifle
	name = "Weapons - Energy marksman"
	contains = list(
		/obj/item/gun/projectile/energy/sniperrifle = 2,
	)
	container_type = /obj/structure/closet/crate/secure/corporate/heph
	container_name = "Energy marksman crate"

/datum/supply_pack/nanotrasen/munitions/burstlaser
	name = "Weapons - Burst laser"
	contains = list(
		/obj/item/gun/projectile/energy/gun/burst = 2,
	)
	container_type = /obj/structure/closet/crate/secure/weapon
	container_name = "Burst laser crate"

/datum/supply_pack/nanotrasen/munitions/ionweapons
	name = "Weapons - Electromagnetic Rifles"
	contains = list(
		/obj/item/gun/projectile/energy/ionrifle = 2,
		/obj/item/storage/box/empslite,
	)
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Electromagnetic weapons crate"

/datum/supply_pack/nanotrasen/munitions/ionpistols
	name = "Weapons - Electromagnetic pistols"
	contains = list(
		/obj/item/gun/projectile/energy/ionrifle/pistol = 2,
		/obj/item/storage/box/empslite,
	)
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Electromagnetic weapons crate"

/datum/supply_pack/nanotrasen/munitions/bsmg
	name = "Weapons - Ballistic SMGs"
	contains = list(
		/obj/item/gun/projectile/ballistic/automatic/wt550 = 2,
	)
	container_type = /obj/structure/closet/crate/secure/corporate/ward
	container_name = "Ballistic weapon crate"

/datum/supply_pack/nanotrasen/munitions/brifle
	name = "Weapons - Ballistic Rifles"
	contains = list(
		/obj/item/gun/projectile/ballistic/automatic/z8 = 2,
	)
	container_name = "Ballistic weapon crate"

/datum/supply_pack/nanotrasen/munitions/bolt_rifles_competitive
	name = "Weapons - Competitive shooting rifles"
	contains = list(
		/obj/item/assembly/timer,
		/obj/item/gun/projectile/ballistic/shotgun/pump/rifle/practice = 2,
		/obj/item/ammo_magazine/a7_62mm/clip/practice = 4,
		/obj/item/target = 2,
		/obj/item/target/alien = 2,
		/obj/item/target/syndicate = 2,
	)
	worth = 500
	container_name = "Ballistic Weapons crate"

/datum/supply_pack/nanotrasen/munitions/mrifle
	name = "Weapons - Magnetic Rifles"
	contains = list(
		/obj/item/gun/projectile/magnetic/railgun/heater = 2,
	)
	container_name = "Magnetic weapon crate"

/datum/supply_pack/nanotrasen/munitions/mpistol
	name = "Weapons - Magnetic Pistols"
	contains = list(
		/obj/item/gun/projectile/magnetic/railgun/heater/pistol = 2,
	)
	container_name = "Magnetic weapon crate"

/datum/supply_pack/nanotrasen/munitions/mcarbine
	name = "Weapons - Magnetic Carbines"
	contains = list(
		/obj/item/gun/projectile/magnetic/railgun/flechette/sif = 2,
	)
	container_name = "Magnetic weapon crate"

/datum/supply_pack/nanotrasen/munitions/shotgunammo
	name = "Ammunition - Shotgun shells"
	contains = list(
		/obj/item/storage/box/shotgunammo = 2,
		/obj/item/storage/box/shotgunshells = 2,
	)
	container_name = "Ballistic ammunition crate"

/datum/supply_pack/nanotrasen/munitions/beanbagammo
	name = "Ammunition - Beanbag shells"
	contains = list(
		/obj/item/storage/box/beanbags = 3,
	)
	container_name = "Ballistic ammunition crate"

/datum/supply_pack/nanotrasen/munitions/bsmgammo
	name = "Ammunition - 9mm top mounted lethal"
	contains = list(
		/obj/item/ammo_magazine/a9mm/top_mount = 6,
	)
	worth = 250
	container_name = "Ballistic ammunition crate"

/datum/supply_pack/nanotrasen/munitions/bsmgammorubber
	name = "Ammunition - 9mm top mounted rubber"
	contains = list(
		/obj/item/ammo_magazine/a9mm/top_mount/rubber = 6,
	)
	worth = 250
	container_type = /obj/structure/closet/crate/secure
	container_name = "Ballistic ammunition crate"

/datum/supply_pack/nanotrasen/munitions/brifleammo
	name = "Ammunition - 7.62mm lethal"
	contains = list(
		/obj/item/ammo_magazine/a7_62mm = 6,
	)
	worth = 250
	container_type = /obj/structure/closet/crate/secure
	container_name = "Ballistic ammunition crate"

/datum/supply_pack/nanotrasen/munitions/pcellammo
	name = "Ammunition - Power cell"
	contains = list(
		/obj/item/cell/device/weapon = 3,
	)
	container_access = list()

/datum/supply_pack/nanotrasen/munitions/firingpins
	name = "Weapons - Standard firing pins"
	contains = list(
		/obj/item/storage/box/firingpins = 3,
	)
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Firing pin crate"

/datum/supply_pack/nanotrasen/munitions/expeditionguns
	name = "frontier phasers (station-locked)"
	contains = list(
		/obj/item/gun/projectile/energy/frontier/locked = 2,
		/obj/item/gun/projectile/energy/frontier/locked/holdout = 1,
	)
	worth = 1000 // powergamer guns lmao
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen

//Culture Update
/datum/supply_pack/nanotrasen/munitions/weaponry_apidean
	name = "Apidean Weaponry Crate"
	contains = list(
		/obj/item/gun/projectile/ballistic/apinae_stinger = 1,
		/obj/item/gun/projectile/ballistic/apinae_pistol = 2,
		/obj/item/grenade/simple/spawner/manhacks/apidean = 3,
	)
	worth = 750
	container_type = /obj/structure/closet/crate/secure/gear
	container_name = "Apidean Weaponry crate"

/datum/supply_pack/nanotrasen/munitions/weaponry_tyrmalin
	name = "Tyrmalin Weaponry Crate"
	contains = list(
		/obj/item/gun/projectile/energy/ermitter = 1,
		/obj/item/gun/projectile/ballistic/rocket/tyrmalin = 1,
		/obj/item/ammo_casing/rocket/weak = 2,
		/obj/item/gun/projectile/ballistic/pirate/junker_pistol = 2,
		/obj/item/gun/projectile/energy/ionrifle/pistol/tyrmalin = 1,
	)
	worth = 1500
	container_type = /obj/structure/closet/crate/secure/gear
	container_name = "Tyrmalin Weaponry crate"

/datum/supply_pack/nanotrasen/munitions/battlerifle
	name = "Battle Rifle Pack"
	contains = list(
		/obj/item/gun/projectile/ballistic/automatic/battlerifle = 2,
		/obj/item/ammo_magazine/m95 = 4,
	)
	worth = 1500
	container_type = /obj/structure/closet/crate/secure/corporate/heph

/datum/supply_pack/nanotrasen/munitions/quadshot
	name = "Quad Shotgun Pack"
	contains = list(
		/obj/item/gun/projectile/ballistic/shotgun/doublebarrel/quad = 2,
		/obj/item/storage/box/shotgunshells = 2,
		/obj/item/storage/belt/security/tactical/bandolier = 2,
	)
	worth = 1250
	container_type = /obj/structure/closet/crate/secure/corporate/heph
