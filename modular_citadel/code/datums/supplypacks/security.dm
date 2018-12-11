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
	cost = 25
	containertype = /obj/structure/closet/crate/secure
	containername = "Plate carrier crate"
	access = access_security

/datum/supply_pack/security/pcarrierswebbing
	name = "Armor - Plate carrier webbings"
	num_contained = 6
	contains = list(
			/obj/item/clothing/accessory/storage/pouches,
			/obj/item/clothing/accessory/storage/pouches/large
			)
	cost = 25
	containertype = /obj/structure/closet/crate/secure
	containername = "Plate carrier crate"
	access = access_security

/datum/supply_pack/security/pcarriersriot
	name = "Armor - Plate carrier kit (general)"
	contains = list(
			/obj/item/clothing/accessory/armor/armorplate/medium = 3,
			/obj/item/clothing/accessory/armor/armguards = 3,
			/obj/item/clothing/accessory/armor/legguards = 3,
			)
	cost = 30
	containertype = /obj/structure/closet/crate/secure
	containername = "Plate carrier crate"
	access = access_security
