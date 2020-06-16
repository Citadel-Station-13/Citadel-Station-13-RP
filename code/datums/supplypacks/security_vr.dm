/*/datum/supply_pack/security/guardbeast //VORESTATION AI TEMPORARY REMOVAL
	name = "VARMAcorp autoNOMous security solution"
	cost = 150
	containertype = /obj/structure/largecrate/animal/guardbeast
	containername = "VARMAcorp autoNOMous security solution crate"
	access = list(
			access_security,
			access_xenobiology)
	one_access = TRUE

/datum/supply_pack/security/guardmutant
	name = "VARMAcorp autoNOMous security solution for hostile environments"
	cost = 250
	containertype = /obj/structure/largecrate/animal/guardmutant
	containername = "VARMAcorp autoNOMous security phoron-proof solution crate"
	access = list(
			access_security,
			access_xenobiology)
	one_access = TRUE
*/


/datum/supply_pack/security/biosuit
	contains = list(
			/obj/item/clothing/head/bio_hood/security = 3,
			/obj/item/clothing/under/rank/security = 3,
			/obj/item/clothing/suit/bio_suit/security = 3,
			/obj/item/clothing/shoes/white = 3,
			/obj/item/clothing/mask/gas = 3,
			/obj/item/tank/oxygen = 3,
			/obj/item/clothing/gloves/sterile/latex,
			/obj/item/storage/box/gloves
			)
	cost = 40

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
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "Kevlar Upgrade Kits"
	access = access_security

/datum/supply_pack/security/pcarriers/merc
	name = "Armor - heavy plate carrier equipment"
	contains = list(
			/obj/item/clothing/accessory/armor/armorplate/merc = 3,
			/obj/item/clothing/accessory/armor/armguards/merc = 3,
			/obj/item/clothing/accessory/armor/legguards/merc = 3,
			/obj/item/clothing/head/helmet/merc = 3,
			)
	cost = 65
	containertype = /obj/structure/closet/crate/secure
	containername = "Plate carrier heavy crate"
	access = access_security
	contraband = 1

/datum/supply_pack/security/helmets
	name = "Armor - Helmet pack"
	contains = list(
			/obj/item/clothing/head/helmet = 3,
			/obj/item/clothing/head/helmet/warden = 1,
			/obj/item/clothing/head/helmet/HoS = 1,
			)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	access = access_security

/datum/supply_pack/security/wardengear
	name = "Tracking Implants"
	contains = list(
			/obj/item/storage/box/trackimp = 1
			)
	cost = 30
	containertype = /obj/structure/closet/crate/secure
	access = access_armory