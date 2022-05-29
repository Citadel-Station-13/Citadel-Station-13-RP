/*
*	Here is where any supply packs
*	related to weapons live.
*/

/datum/supply_pack/munitions
	group = "Munitions"

/datum/supply_pack/randomised/munitions
	group = "Munitions"

/datum/supply_pack/munitions/weapons
	name = "Weapons - Security basic equipment"
	contains = list(
			/obj/item/flash = 2,
			/obj/item/reagent_containers/spray/pepper = 2,
			/obj/item/melee/baton/loaded = 2,
			/obj/item/gun/energy/taser = 2,
			/obj/item/gunbox = 2,
			/obj/item/storage/box/flashbangs = 2
			)
	cost = 40
	container_type = /obj/structure/closet/crate/secure/gear
	container_name = "Security equipment crate"
	access = access_security

/datum/supply_pack/munitions/egunpistol
	name = "Weapons - Energy sidearms"
	contains = list(/obj/item/gun/energy/gun = 2)
	cost = 50
	container_type = /obj/structure/closet/crate/secure/weapon
	container_name = "Energy sidearms crate"
	access = access_armory

/datum/supply_pack/munitions/flareguns
	name = "Weapons - Flare guns"
	contains = list(
			/obj/item/gun/projectile/shotgun/flare = 2,
			/obj/item/storage/box/flashshells = 2
			)
	cost = 25
	container_type = /obj/structure/closet/crate/secure/gear
	container_name = "Flare gun crate"
	access = access_armory

/datum/supply_pack/munitions/eweapons
	name = "Weapons - Experimental weapons crate"
	contains = list(
			/obj/item/gun/energy/xray = 2,
			/obj/item/shield/energy = 2)
	cost = 100
	container_type = /obj/structure/closet/crate/secure/science
	container_name = "Experimental weapons crate"
	access = access_armory

/datum/supply_pack/munitions/energyweapons
	name = "Weapons - Laser rifle crate"
	contains = list(/obj/item/gun/energy/laser = 2)
	cost = 50
	container_type = /obj/structure/closet/crate/secure/weapon
	container_name = "Energy weapons crate"
	access = access_armory

/datum/supply_pack/munitions/shotgun
	name = "Weapons - Shotgun crate"
	contains = list(
			/obj/item/storage/box/shotgunammo,
			/obj/item/storage/box/shotgunshells,
			/obj/item/gun/projectile/shotgun/pump/combat = 2
			)
	cost = 50
	container_type = /obj/structure/closet/crate/secure/weapon
	container_name = "Shotgun crate"
	access = access_armory

/datum/supply_pack/munitions/erifle
	name = "Weapons - Energy marksman"
	contains = list(/obj/item/gun/energy/sniperrifle = 2)
	cost = 100
	container_type = /obj/structure/closet/crate/secure/weapon
	container_name = "Energy marksman crate"
	access = access_armory

/datum/supply_pack/munitions/burstlaser
	name = "Weapons - Burst laser"
	contains = list(/obj/item/gun/energy/gun/burst = 2)
	cost = 50
	container_type = /obj/structure/closet/crate/secure/weapon
	container_name = "Burst laser crate"
	access = access_armory

/datum/supply_pack/munitions/ionweapons
	name = "Weapons - Electromagnetic Rifles"
	contains = list(
			/obj/item/gun/energy/ionrifle = 2,
			/obj/item/storage/box/empslite
			)
	cost = 50
	container_type = /obj/structure/closet/crate/secure/weapon
	container_name = "Electromagnetic weapons crate"
	access = access_armory

/datum/supply_pack/munitions/ionpistols
	name = "Weapons - Electromagnetic pistols"
	contains = list(
			/obj/item/gun/energy/ionrifle/pistol = 2,
			/obj/item/storage/box/empslite
			)
	cost = 30
	container_type = /obj/structure/closet/crate/secure/weapon
	container_name = "Electromagnetic weapons crate"
	access = access_armory

/datum/supply_pack/munitions/bsmg
	name = "Weapons - Ballistic SMGs"
	contains = list(/obj/item/gun/projectile/automatic/wt550 = 2)
	cost = 50
	container_type = /obj/structure/closet/crate/secure/weapon
	container_name = "Ballistic weapon crate"
	access = access_armory

/datum/supply_pack/munitions/brifle
	name = "Weapons - Ballistic Rifles"
	contains = list(/obj/item/gun/projectile/automatic/z8 = 2)
	cost = 80
	container_type = /obj/structure/closet/crate/secure/weapon
	container_name = "Ballistic weapon crate"
	access = access_armory

/datum/supply_pack/munitions/bolt_rifles_competitive
 	name = "Weapons - Competitive shooting rifles"
 	contains = list(
 			/obj/item/assembly/timer,
 			/obj/item/gun/projectile/shotgun/pump/rifle/practice = 2,
 			/obj/item/ammo_magazine/clip/c762/practice = 4,
 			/obj/item/target = 2,
 			/obj/item/target/alien = 2,
 			/obj/item/target/syndicate = 2
 			)
 	cost = 40
 	container_type = /obj/structure/closet/crate/secure/weapon
 	container_name = "Ballistic Weapons crate"
 	access = access_armory

/datum/supply_pack/munitions/mrifle
	name = "Weapons - Magnetic Rifles"
	contains = list(/obj/item/gun/magnetic/railgun/heater = 2)
	cost = 120
	container_type = /obj/structure/closet/crate/secure/weapon
	container_name = "Magnetic weapon crate"
	access = access_armory

/datum/supply_pack/munitions/mpistol
	name = "Weapons - Magnetic Pistols"
	contains = list(/obj/item/gun/magnetic/railgun/heater/pistol = 2)
	cost = 200
	container_type = /obj/structure/closet/crate/secure/weapon
	container_name = "Magnetic weapon crate"
	access = access_armory

/datum/supply_pack/munitions/mcarbine
	name = "Weapons - Magnetic Carbines"
	contains = list(/obj/item/gun/magnetic/railgun/flechette/sif = 2)
	cost = 130
	container_type = /obj/structure/closet/crate/secure/weapon
	container_name = "Magnetic weapon crate"
	access = access_armory

/datum/supply_pack/munitions/shotgunammo
	name = "Ammunition - Shotgun shells"
	contains = list(
			/obj/item/storage/box/shotgunammo = 2,
			/obj/item/storage/box/shotgunshells = 2
			)
	cost = 25
	container_type = /obj/structure/closet/crate/secure
	container_name = "Ballistic ammunition crate"
	access = access_armory

/datum/supply_pack/munitions/beanbagammo
	name = "Ammunition - Beanbag shells"
	contains = list(/obj/item/storage/box/beanbags = 3)
	cost = 25
	container_type = /obj/structure/closet/crate
	container_name = "Ballistic ammunition crate"
	access = access_armory // Guns are for the armory.

/datum/supply_pack/munitions/bsmgammo
	name = "Ammunition - 9mm top mounted lethal"
	contains = list(/obj/item/ammo_magazine/m9mmt = 6)
	cost = 25
	container_type = /obj/structure/closet/crate/secure
	container_name = "Ballistic ammunition crate"
	access = access_armory

/datum/supply_pack/munitions/bsmgammorubber
	name = "Ammunition - 9mm top mounted rubber"
	contains = list(/obj/item/ammo_magazine/m9mmt/rubber = 6)
	cost = 25
	container_type = /obj/structure/closet/crate/secure
	container_name = "Ballistic ammunition crate"
	access = access_security

/datum/supply_pack/munitions/brifleammo
	name = "Ammunition - 7.62mm lethal"
	contains = list(/obj/item/ammo_magazine/m762 = 6)
	cost = 25
	container_type = /obj/structure/closet/crate/secure
	container_name = "Ballistic ammunition crate"
	access = access_armory

/datum/supply_pack/munitions/pcellammo
	name = "Ammunition - Power cell"
	contains = list(/obj/item/cell/device/weapon = 3)
	cost = 50
	container_type = /obj/structure/closet/crate/secure
	container_name = "Energy ammunition crate"
	access = access_security

/datum/supply_pack/munitions/firingpins
	name = "Weapons - Standard firing pins"
	contains = list(/obj/item/storage/box/firingpins = 3)
	cost = 10
	container_type = /obj/structure/closet/crate/secure
	container_name = "Firing pin crate"
	access = access_armory

/datum/supply_pack/munitions/expeditionguns
	name = "Frontier phaser (station-locked) crate"
	contains = list(
			/obj/item/gun/energy/frontier/locked = 2,
			/obj/item/gun/energy/frontier/locked/holdout = 1,
			)
	cost = 35
	container_type = /obj/structure/closet/crate/secure
	container_name = "frontier phaser crate"
	access = access_explorer

//Culture Update
/datum/supply_pack/munitions/weaponry_apidean
	name = "Apidean Weaponry Crate"
	contains = list(
			/obj/item/gun/projectile/apinae_stinger = 1,
			/obj/item/gun/projectile/apinae_pistol = 2,
			/obj/item/grenade/spawnergrenade/manhacks/apidean = 3
			)
	cost = 150
	container_type = /obj/structure/closet/crate/secure/gear
	container_name = "Apidean Weaponry crate"
	access = access_security

/datum/supply_pack/misc/weaponry_tyrmalin
	name = "Tyrmalin Weaponry Crate"
	contains = list(
			/obj/item/gun/energy/ermitter = 1,
			/obj/item/gun/projectile/rocket/tyrmalin = 1,
			/obj/item/ammo_casing/rocket/weak = 2,
			/obj/item/gun/projectile/pirate/junker_pistol = 2,
			/obj/item/gun/energy/ionrifle/pistol/tyrmalin = 1
			)
	cost = 175
	container_type = /obj/structure/closet/crate/secure/gear
	container_name = "Tyrmalin Weaponry crate"
	access = access_security
