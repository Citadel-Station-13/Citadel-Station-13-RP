/*
*	Here is where any supply packs
*	related to weapons live.
*/

/datum/supply_pack2/nanotrasen/munitions
	abstract_type = /datum/supply_pack2/nanotrasen/munitions
	category = "Munitions"
	supply_pack_flags = SUPPLY_PACK_LOCK_PRIVATE_ORDERS | SUPPLY_PACK_RESTRICT_PRIVATE_ORDERS
	container_access = list(
		/datum/access/station/security/armory,
	)

/datum/supply_pack2/nanotrasen/munitions/weapons
	name = "Weapons - Security basic equipment"
	contains = list(
		/obj/item/flash = 2,
		/obj/item/reagent_containers/spray/pepper = 2,
		/obj/item/melee/baton/loaded = 2,
		/obj/item/gun/energy/taser = 2,
		/obj/item/gunbox = 2,
		/obj/item/storage/box/flashbangs = 2,
	)
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Security equipment crate"
	access = ACCESS_SECURITY_EQUIPMENT

/datum/supply_pack2/nanotrasen/munitions/egunpistol
	name = "Weapons - Energy sidearms"
	contains = list(/obj/item/gun/energy/gun = 2)
	cost = 50
	container_type = /obj/structure/closet/crate/secure/weapon
	container_name = "Energy sidearms crate"
	access = ACCESS_SECURITY_ARMORY

/datum/supply_pack2/nanotrasen/munitions/flareguns
	name = "Weapons - Flare guns"
	contains = list(
			/obj/item/gun/ballistic/shotgun/flare = 2,
			/obj/item/storage/box/flashshells = 2
			)
	cost = 25
	container_type = /obj/structure/closet/crate/secure/gear
	container_name = "Flare gun crate"
	access = ACCESS_SECURITY_ARMORY

/datum/supply_pack2/nanotrasen/munitions/eweapons
	name = "Weapons - Experimental weapons crate"
	contains = list(
			/obj/item/gun/energy/xray = 2,
			/obj/item/shield/energy = 2)
	cost = 100
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Experimental weapons crate"
	access = ACCESS_SECURITY_ARMORY

/datum/supply_pack2/nanotrasen/munitions/energyweapons
	name = "Weapons - Laser rifle crate"
	contains = list(/obj/item/gun/energy/laser = 2)
	cost = 50
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Energy weapons crate"
	access = ACCESS_SECURITY_ARMORY

/datum/supply_pack2/nanotrasen/munitions/shotgun
	name = "Weapons - Shotgun crate"
	contains = list(
			/obj/item/storage/box/shotgunammo,
			/obj/item/storage/box/shotgunshells,
			/obj/item/gun/ballistic/shotgun/pump/combat = 2
			)
	cost = 50
	container_type = /obj/structure/closet/crate/secure/corporate/ward
	container_name = "Shotgun crate"
	access = ACCESS_SECURITY_ARMORY

/datum/supply_pack2/nanotrasen/munitions/erifle
	name = "Weapons - Energy marksman"
	contains = list(/obj/item/gun/energy/sniperrifle = 2)
	cost = 100
	container_type = /obj/structure/closet/crate/secure/corporate/heph
	container_name = "Energy marksman crate"
	access = ACCESS_SECURITY_ARMORY

/datum/supply_pack2/nanotrasen/munitions/burstlaser
	name = "Weapons - Burst laser"
	contains = list(/obj/item/gun/energy/gun/burst = 2)
	cost = 50
	container_type = /obj/structure/closet/crate/secure/weapon
	container_name = "Burst laser crate"
	access = ACCESS_SECURITY_ARMORY

/datum/supply_pack2/nanotrasen/munitions/ionweapons
	name = "Weapons - Electromagnetic Rifles"
	contains = list(
			/obj/item/gun/energy/ionrifle = 2,
			/obj/item/storage/box/empslite
			)
	cost = 50
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Electromagnetic weapons crate"
	access = ACCESS_SECURITY_ARMORY

/datum/supply_pack2/nanotrasen/munitions/ionpistols
	name = "Weapons - Electromagnetic pistols"
	contains = list(
			/obj/item/gun/energy/ionrifle/pistol = 2,
			/obj/item/storage/box/empslite
			)
	cost = 30
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Electromagnetic weapons crate"
	access = ACCESS_SECURITY_ARMORY

/datum/supply_pack2/nanotrasen/munitions/bsmg
	name = "Weapons - Ballistic SMGs"
	contains = list(/obj/item/gun/ballistic/automatic/wt550 = 2)
	cost = 50
	container_type = /obj/structure/closet/crate/secure/corporate/ward
	container_name = "Ballistic weapon crate"
	access = ACCESS_SECURITY_ARMORY

/datum/supply_pack2/nanotrasen/munitions/brifle
	name = "Weapons - Ballistic Rifles"
	contains = list(/obj/item/gun/ballistic/automatic/z8 = 2)
	cost = 80
	container_type = /obj/structure/closet/crate/secure/weapon
	container_name = "Ballistic weapon crate"
	access = ACCESS_SECURITY_ARMORY

/datum/supply_pack2/nanotrasen/munitions/bolt_rifles_competitive
 	name = "Weapons - Competitive shooting rifles"
 	contains = list(
 			/obj/item/assembly/timer,
 			/obj/item/gun/ballistic/shotgun/pump/rifle/practice = 2,
 			/obj/item/ammo_magazine/clip/c762/practice = 4,
 			/obj/item/target = 2,
 			/obj/item/target/alien = 2,
 			/obj/item/target/syndicate = 2
 			)
 	cost = 40
 	container_type = /obj/structure/closet/crate/secure/weapon
 	container_name = "Ballistic Weapons crate"
 	access = ACCESS_SECURITY_ARMORY

/datum/supply_pack2/nanotrasen/munitions/mrifle
	name = "Weapons - Magnetic Rifles"
	contains = list(/obj/item/gun/magnetic/railgun/heater = 2)
	cost = 120
	container_type = /obj/structure/closet/crate/secure/weapon
	container_name = "Magnetic weapon crate"
	access = ACCESS_SECURITY_ARMORY

/datum/supply_pack2/nanotrasen/munitions/mpistol
	name = "Weapons - Magnetic Pistols"
	contains = list(/obj/item/gun/magnetic/railgun/heater/pistol = 2)
	cost = 200
	container_type = /obj/structure/closet/crate/secure/weapon
	container_name = "Magnetic weapon crate"
	access = ACCESS_SECURITY_ARMORY

/datum/supply_pack2/nanotrasen/munitions/mcarbine
	name = "Weapons - Magnetic Carbines"
	contains = list(/obj/item/gun/magnetic/railgun/flechette/sif = 2)
	cost = 130
	container_type = /obj/structure/closet/crate/secure/weapon
	container_name = "Magnetic weapon crate"
	access = ACCESS_SECURITY_ARMORY

/datum/supply_pack2/nanotrasen/munitions/shotgunammo
	name = "Ammunition - Shotgun shells"
	contains = list(
			/obj/item/storage/box/shotgunammo = 2,
			/obj/item/storage/box/shotgunshells = 2
			)
	cost = 25
	container_type = /obj/structure/closet/crate/secure
	container_name = "Ballistic ammunition crate"
	access = ACCESS_SECURITY_ARMORY

/datum/supply_pack2/nanotrasen/munitions/beanbagammo
	name = "Ammunition - Beanbag shells"
	contains = list(/obj/item/storage/box/beanbags = 3)
	cost = 25
	container_type = /obj/structure/closet/crate
	container_name = "Ballistic ammunition crate"
	access = ACCESS_SECURITY_ARMORY // Guns are for the armory.

/datum/supply_pack2/nanotrasen/munitions/bsmgammo
	name = "Ammunition - 9mm top mounted lethal"
	contains = list(/obj/item/ammo_magazine/m9mmt = 6)
	cost = 25
	container_type = /obj/structure/closet/crate/secure
	container_name = "Ballistic ammunition crate"
	access = ACCESS_SECURITY_ARMORY

/datum/supply_pack2/nanotrasen/munitions/bsmgammorubber
	name = "Ammunition - 9mm top mounted rubber"
	contains = list(/obj/item/ammo_magazine/m9mmt/rubber = 6)
	cost = 25
	container_type = /obj/structure/closet/crate/secure
	container_name = "Ballistic ammunition crate"
	access = ACCESS_SECURITY_EQUIPMENT

/datum/supply_pack2/nanotrasen/munitions/brifleammo
	name = "Ammunition - 7.62mm lethal"
	contains = list(/obj/item/ammo_magazine/m762 = 6)
	cost = 25
	container_type = /obj/structure/closet/crate/secure
	container_name = "Ballistic ammunition crate"
	access = ACCESS_SECURITY_ARMORY

/datum/supply_pack2/nanotrasen/munitions/pcellammo
	name = "Ammunition - Power cell"
	contains = list(/obj/item/cell/device/weapon = 3)
	cost = 50
	container_type = /obj/structure/closet/crate/secure/corporate/einstein
	container_name = "Energy ammunition crate"
	access = ACCESS_SECURITY_EQUIPMENT

/datum/supply_pack2/nanotrasen/munitions/firingpins
	name = "Weapons - Standard firing pins"
	contains = list(/obj/item/storage/box/firingpins = 3)
	cost = 10
	container_type = /obj/structure/closet/crate/secure
	container_name = "Firing pin crate"
	access = ACCESS_SECURITY_ARMORY

/datum/supply_pack2/nanotrasen/munitions/expeditionguns
	name = "Frontier phaser (station-locked) crate"
	contains = list(
			/obj/item/gun/energy/frontier/locked = 2,
			/obj/item/gun/energy/frontier/locked/holdout = 1,
			)
	cost = 35
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "frontier phaser crate"
	access = ACCESS_GENERAL_EXPLORER

//Culture Update
/datum/supply_pack2/nanotrasen/munitions/weaponry_apidean
	name = "Apidean Weaponry Crate"
	contains = list(
			/obj/item/gun/ballistic/apinae_stinger = 1,
			/obj/item/gun/ballistic/apinae_pistol = 2,
			/obj/item/grenade/spawnergrenade/manhacks/apidean = 3
			)
	cost = 150
	container_type = /obj/structure/closet/crate/secure/gear
	container_name = "Apidean Weaponry crate"
	access = ACCESS_SECURITY_EQUIPMENT

/datum/supply_pack2/nanotrasen/munitions/weaponry_tyrmalin
	name = "Tyrmalin Weaponry Crate"
	contains = list(
			/obj/item/gun/energy/ermitter = 1,
			/obj/item/gun/ballistic/rocket/tyrmalin = 1,
			/obj/item/ammo_casing/rocket/weak = 2,
			/obj/item/gun/ballistic/pirate/junker_pistol = 2,
			/obj/item/gun/energy/ionrifle/pistol/tyrmalin = 1
			)
	cost = 175
	container_type = /obj/structure/closet/crate/secure/gear
	container_name = "Tyrmalin Weaponry crate"
	access = ACCESS_SECURITY_EQUIPMENT

/datum/supply_pack2/nanotrasen/munitions/battlerifle
	name = "Battle Rifle Pack"
	contains = list(
			/obj/item/gun/ballistic/automatic/battlerifle = 2,
			/obj/item/ammo_magazine/m95 = 4
			)
	cost = 60
	container_type = /obj/structure/closet/crate/secure/corporate/heph
	access = ACCESS_SECURITY_ARMORY

/datum/supply_pack2/nanotrasen/munitions/quadshot
	name = "Quad Shotgun Pack"
	contains = list(
			/obj/item/gun/ballistic/shotgun/doublebarrel/quad = 2,
			/obj/item/storage/box/shotgunshells = 2,
			/obj/item/storage/belt/security/tactical/bandolier = 2,
			)
	cost = 70
	container_type = /obj/structure/closet/crate/secure/corporate/heph
	access = ACCESS_SECURITY_ARMORY
