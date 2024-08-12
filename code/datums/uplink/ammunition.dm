/*************
* Ammunition *
*************/
/datum/uplink_item/item/ammo
	item_cost = 20
	category = /datum/uplink_category/ammunition
	blacklisted = 1

/datum/uplink_item/item/ammo/a357
	name = ".357 Speedloader"
	path = /obj/item/ammo_magazine/a357/speedloader

/datum/uplink_item/item/ammo/mc9mm_compact
	name = "Compact Pistol Magazine (9mm)"
	path = /obj/item/ammo_magazine/a9mm/compact

/datum/uplink_item/item/ammo/mc9mm
	name = "Pistol Magazine (9mm)"
	path = /obj/item/ammo_magazine/a9mm

/datum/uplink_item/item/ammo/mc9mm_large
	name = "Large Capacity Pistol Magazine (9mm)"
	path = /obj/item/ammo_magazine/a9mm/large
	item_cost = 40

/datum/uplink_item/item/ammo/c45m
	name = "Pistol Magazine (.45)"
	path = /obj/item/ammo_magazine/a45

/datum/uplink_item/item/ammo/c45map
	name = "Pistol Magazine (.45 AP)"
	path = /obj/item/ammo_magazine/a45/ap

/datum/uplink_item/item/ammo/s45m
	name = "Speedloader (.45)"
	path = /obj/item/ammo_magazine/a45/speedloader

/datum/uplink_item/item/ammo/s45map
	name = "Speedloader  (.45 AP)"
	path = /obj/item/ammo_magazine/a45/speedloader/ap

/datum/uplink_item/item/ammo/tommymag
	name = "Tommy Gun Magazine (.45)"
	path = /obj/item/ammo_magazine/a45/tommy

/datum/uplink_item/item/ammo/tommymagap
	name = "Tommy Gun Magazine (.45 AP)"
	path = /obj/item/ammo_magazine/a45/tommy/ap

/datum/uplink_item/item/ammo/tommydrum
	name = "Tommy Gun Drum Magazine (.45)"
	path = /obj/item/ammo_magazine/a45/tommy/drum
	item_cost = 40

/datum/uplink_item/item/ammo/tommydrumap
	name = "Tommy Gun Drum Magazine (.45 AP)"
	path = /obj/item/ammo_magazine/a45/tommy/drum/ap

/datum/uplink_item/item/ammo/darts
	name = "Darts"
	path = /obj/item/ammo_magazine/chemdart
	item_cost = 5

/datum/uplink_item/item/ammo/sniperammo
	name = "Anti-Materiel Rifle ammo box (12.7mm)"
	path = /obj/item/storage/box/sniperammo

/datum/uplink_item/item/ammo/c545
	name = "Rifle Magazine (5.56mm)"
	path = /obj/item/ammo_magazine/a5_56mm

/datum/uplink_item/item/ammo/c545/ext
	name = "Rifle Magazine (5.56mm Extended)"
	path = /obj/item/ammo_magazine/a5_56mm/ext

/datum/uplink_item/item/ammo/c545/ap
	name = "Rifle Magazine (5.56mm AP)"
	path = /obj/item/ammo_magazine/a5_56mm/ap

/datum/uplink_item/item/ammo/c545/ap/ext
	name = "Rifle Magazine (5.56mm AP Extended)"
	path = /obj/item/ammo_magazine/a5_56mm/ap/ext

/datum/uplink_item/item/ammo/c762
	name = "Rifle Magazine (7.62mm)"
	path = /obj/item/ammo_magazine/a7_62mm

/datum/uplink_item/item/ammo/c762/ap
	name = "Rifle Magazine (7.62mm AP)"
	path = /obj/item/ammo_magazine/a7_62mm/ap

/datum/uplink_item/item/ammo/a10mm
	name = "SMG Magazine (10mm)"
	path = /obj/item/ammo_magazine/a10mm

/datum/uplink_item/item/ammo/a556
	name = "Machinegun Magazine (5.56mm)"
	path = /obj/item/ammo_magazine/a5_56mm/saw

/datum/uplink_item/item/ammo/a556/ap
	name = "Machinegun Magazine (5.56mm AP)"
	path = /obj/item/ammo_magazine/a5_56mm/saw/ap

/datum/uplink_item/item/ammo/g12
	name = "12g Shotgun Ammo Box (Slug)"
	path = /obj/item/storage/box/shotgunammo

/datum/uplink_item/item/ammo/g12/beanbag
	name = "12g Shotgun Ammo Box (Beanbag)"
	path = /obj/item/storage/box/beanbags
	item_cost = 10 // Discount due to it being LTL.

/datum/uplink_item/item/ammo/g12/pellet
	name = "12g Shotgun Ammo Box (Pellet)"
	path = /obj/item/storage/box/shotgunshells

/datum/uplink_item/item/ammo/g12/stun
	name = "12g Shotgun Ammo Box (Stun)"
	path = /obj/item/storage/box/stunshells
	item_cost = 10 // Discount due to it being LTL.

/datum/uplink_item/item/ammo/g12/flash
	name = "12g Shotgun Ammo Box (Flash)"
	path = /obj/item/storage/box/flashshells
	item_cost = 10 // Discount due to it being LTL.

/datum/uplink_item/item/ammo/weapon_cell
	name = "weapon power cell"
	path = /obj/item/cell/weapon

/datum/uplink_item/item/ammo/small
	name = "small power cell"
	path = /obj/item/cell/small

/datum/uplink_item/item/ammo/medium_cell
	name = "medium power cell"
	path = /obj/item/cell/medium

/datum/uplink_item/item/ammo/large_cell
	name = "large power cell"
	path = /obj/item/cell/large
