/datum/supply_pack/randomised/security/holster
	num_contained = 5
	contains = list(
			/obj/item/clothing/accessory/holster,
			/obj/item/clothing/accessory/holster/armpit,
			/obj/item/clothing/accessory/holster/waist,
			/obj/item/clothing/accessory/holster/hip,
			/obj/item/clothing/accessory/holster/leg
			)

/datum/supply_pack/security/kevlarkit
	name = "Misc - Kevlar Upgrade Kits"
	contains = list(
			/obj/item/kevlarupgrade = 5,
			)
	cost = 35
	containertype = /obj/structure/closet/crate/secure
	containername = "Kevlar Upgrade Kits"
	access = access_security

/datum/supply_pack/security/pcarriers //time 2 get modular up in this bitch -hatterhat
	name = "Armor - Empty plate carriers"
	contains = list(
			/obj/item/clothing/suit/armor/pcarrier = 3,
			)
	cost = 15
	containertype = /obj/structure/closet/crate/secure
	containername = "Plate carrier crate"
	access = access_security

/datum/supply_pack/security/pcarrierspouches
	name = "Armor - Plate carrier - storage pouches"
	contains = list(
			/obj/item/clothing/accessory/storage/pouches = 3,
			/obj/item/clothing/accessory/storage/pouches/large = 3,
			)
	cost = 10
	containertype = /obj/structure/closet/crate/secure
	containername = "Plate carrier pouch crate"
	access = access_security

/datum/supply_pack/security/pcarriers/patches/blood
	name = "Armor - Plate carrier kit - blood type patches"
	contains = list(
		/obj/item/clothing/accessory/armor/tag/opos = 2,
		/obj/item/clothing/accessory/armor/tag/oneg = 2,
		/obj/item/clothing/accessory/armor/tag/apos = 2,
		/obj/item/clothing/accessory/armor/tag/aneg = 2,
		/obj/item/clothing/accessory/armor/tag/bpos = 2,
		/obj/item/clothing/accessory/armor/tag/bneg = 2,
		/obj/item/clothing/accessory/armor/tag/abpos = 2,
		/obj/item/clothing/accessory/armor/tag/abneg = 2
		)
	cost = 10
	containertype = /obj/structure/closet/crate/secure
	containername = "Plate carrier patch crate"
	access = access_security

/datum/supply_pack/security/pcarriers/patches/decorative
	name = "Armor - Plate carrier kit - decorative patches"
	contains = list(
		/obj/item/clothing/accessory/armor/tag/sec = 3,
		/obj/item/clothing/accessory/armor/tag/nt = 3,
		/obj/item/clothing/accessory/armor/tag/pcrc = 3,
		/obj/item/clothing/accessory/armor/helmcover/blue = 3,
		/obj/item/clothing/accessory/armor/helmcover/nt = 3,
		/obj/item/clothing/accessory/armor/helmcover/pcrc = 3
		)
	cost = 10
	containertype = /obj/structure/closet/crate/secure
	containername = "Plate carrier patch crate"
	access = access_security

/datum/supply_pack/security/pcarriers/standard
	name = "Armor - Plate carrier kit - general attachments"
	contains = list(
			/obj/item/clothing/accessory/armor/armorplate/medium = 3,
			/obj/item/clothing/accessory/armor/armguards = 3,
			/obj/item/clothing/accessory/armor/legguards = 3,
			)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "Plate carrier crate"
	access = access_security

/datum/supply_pack/security/pcarriers/riot
	name = "Armor - Plate carrier kit - riot control attachments"
	contains = list(
			/obj/item/clothing/accessory/armor/armorplate/medium = 3,
			/obj/item/clothing/accessory/armor/armguards/riot = 3,
			/obj/item/clothing/accessory/armor/legguards/riot = 3,
			)
	cost = 25
	containertype = /obj/structure/closet/crate/secure
	containername = "Plate carrier riot crate"
	access = access_security

/datum/supply_pack/security/pcarriers/bulletproof
	name = "Armor - Plate carrier kit - ballistics-resistant attachments"
	contains = list(
			/obj/item/clothing/accessory/armor/armorplate/medium = 3,
			/obj/item/clothing/accessory/armor/armguards/bulletproof = 3,
			/obj/item/clothing/accessory/armor/legguards/bulletproof = 3,
			)
	cost = 30
	containertype = /obj/structure/closet/crate/secure
	containername = "Plate carrier bulletproof crate"
	access = access_security

/datum/supply_pack/security/pcarriers/laserproof
	name = "Armor - Plate carrier kit - energy-resistant attachments"
	contains = list(
			/obj/item/clothing/accessory/armor/armorplate/tactical = 3,
			/obj/item/clothing/accessory/armor/armguards/laserproof = 3,
			/obj/item/clothing/accessory/armor/legguards/laserproof = 3,
			)
	cost = 30
	containertype = /obj/structure/closet/crate/secure
	containername = "Plate carrier ablative crate"
	access = access_security
/*
/datum/supply_pack/security/pcarriers/tactical
	name = "Armor - Plate carrier kit - tactical plates"
	contains = list(
			/obj/item/clothing/accessory/armor/armorplate/tactical = 3,
			)
	cost = 30
	containertype = /obj/structure/closet/crate/secure
	containername = "Plate carrier crate"
	access = access_security
*/
/datum/supply_pack/security/pcarriers/merc
	name = "Armor - Plate carrier kit - heavy equipment"
	contains = list(
			/obj/item/clothing/accessory/armor/armorplate/merc = 1,
			/obj/item/clothing/accessory/armor/armguards/merc = 1,
			/obj/item/clothing/accessory/armor/legguards/merc = 1,
			/obj/item/clothing/head/helmet/merc = 1,
			)
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "Plate carrier heavy crate"
	access = access_security
	contraband = 1
