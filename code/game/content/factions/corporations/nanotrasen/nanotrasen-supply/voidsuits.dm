/datum/supply_pack2/nanotrasen/voidsuit
	group = "Voidsuits"

/**
 * for single types of voidsuits
 *
 * * voidsuit & its helmet must have worth set
 * * voidsuit must have its helmet_type var set
 */
/datum/supply_pack2/nanotrasen/voidsuit/single
	var/voidsuit_type = /obj/item/clothing/suit/space/void
	var/amount = 1
	/// if it doesn't start with boots, spawn boots in the package
	var/automatically_include_boots = TRUE
	/// if it doesn't start with an oxygen tank or cooler, spawn life support in the package
	var/automatically_include_life_support = TRUE

/datum/supply_pack2/nanotrasen/voidsuit/single/populate()
	..()
	var/obj/item/clothing/suit/space/void/casted = voidsuit_type
	contains[voidsuit_type] = amount + contains[voidsuit_type]

	if(!initial(casted.starts_with_helmet))
		contains[initial(casted.helmet_type)] = amount + contains[initial(casted.helmet_type)]
	if(!initial(casted.starts_with_boots) && automatically_include_boots)
		contains[initial(casted.boots_type)] = amount + contains[initial(casted.boots_type)]
	if(!initial(casted.starts_with_life_support) && automatically_include_life_support)
		contains[initial(casted.tank_type)] = amount + contains[initial(casted.tank_type)]

/datum/supply_pack2/nanotrasen/voidsuit/single/atmos
	name = "Atmospherics voidsuits"
	voidsuit_type = /obj/item/clothing/suit/space/void/atmos
	amount = 2
	container_type = /obj/structure/closet/crate/secure/corporate/aether
	container_name = "atmospherics voidsuit crate"

/datum/supply_pack2/nanotrasen/voidsuit/single/atmos/alt
	name = "Heavy Duty Atmospherics voidsuits"
	voidsuit_type = /obj/item/clothing/suit/space/void/atmos/alt
	amount = 2
	container_type = /obj/structure/closet/crate/secure/corporate/aether
	container_name = "heavy duty atmospherics voidsuit crate"

/datum/supply_pack2/nanotrasen/voidsuit/single/engineering
	name = "Engineering voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/engineering = 2,
			/obj/item/clothing/head/helmet/space/void/engineering = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/clothing/shoes/magboots = 2,
			/obj/item/tank/oxygen = 2
			)
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Engineering voidsuit crate"
	access = ACCESS_ENGINEERING_ENGINE

/datum/supply_pack2/nanotrasen/voidsuit/single/engineering/construction
	name = "Engineering Construction voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/engineering/construction = 2,
			/obj/item/clothing/head/helmet/space/void/engineering/construction = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/clothing/shoes/magboots = 2,
			/obj/item/tank/oxygen = 2
			)
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Engineering Construction voidsuit crate"
	access = ACCESS_ENGINEERING_ENGINE

/datum/supply_pack2/nanotrasen/voidsuit/single/engineering/hazmat
	name = "Engineering Hazmat voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/engineering/hazmat = 2,
			/obj/item/clothing/head/helmet/space/void/engineering/hazmat = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/clothing/shoes/magboots = 2,
			/obj/item/tank/oxygen = 2
			)
	container_type = /obj/structure/closet/crate/secure/corporate/aether
	container_name = "Engineering Hazmat voidsuit crate"
	access = ACCESS_ENGINEERING_ENGINE

/datum/supply_pack2/nanotrasen/voidsuit/single/engineering/alt
	name = "Reinforced Engineering voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/engineering/alt = 2,
			/obj/item/clothing/head/helmet/space/void/engineering/alt = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/clothing/shoes/magboots = 2,
			/obj/item/tank/oxygen = 2
			)
	container_type = /obj/structure/closet/crate/secure/corporate/aether
	container_name = "Reinforced Engineering voidsuit crate"
	access = ACCESS_ENGINEERING_ENGINE

/datum/supply_pack2/nanotrasen/voidsuit/single/medical
	name = "Medical voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/medical = 2,
			/obj/item/clothing/head/helmet/space/void/medical = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/clothing/shoes/magboots = 2,
			/obj/item/tank/oxygen = 2
			)
	container_type = /obj/structure/closet/crate/secure
	container_name = "Medical voidsuit crate"
	access = ACCESS_MEDICAL_EQUIPMENT

/datum/supply_pack2/nanotrasen/voidsuit/single/medical/emt
	name = "Medical EMT voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/medical/emt = 2,
			/obj/item/clothing/head/helmet/space/void/medical/emt = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/clothing/shoes/magboots = 2,
			/obj/item/tank/oxygen = 2
			)
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Medical EMT voidsuit crate"

/datum/supply_pack2/nanotrasen/voidsuit/single/medical/bio
	name = "Medical Biohazard voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/medical/bio = 2,
			/obj/item/clothing/head/helmet/space/void/medical/bio = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/clothing/shoes/magboots = 2,
			/obj/item/tank/oxygen = 2
			)
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Medical Biohazard voidsuit crate"
	access = ACCESS_MEDICAL_EQUIPMENT

/datum/supply_pack2/nanotrasen/voidsuit/single/medical/alt
	name = "Vey-Med Medical voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/medical/alt = 2,
			/obj/item/clothing/head/helmet/space/void/medical/alt = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/clothing/shoes/magboots = 2,
			/obj/item/tank/oxygen = 2
			)
	container_type = /obj/structure/closet/crate/secure/corporate/veymed
	container_name = "Vey-Med Medical voidsuit crate"
	access = ACCESS_MEDICAL_EQUIPMENT

/datum/supply_pack2/nanotrasen/voidsuit/single/medical/alt2
	name = "Vey-Med Plated Medical voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/medical/alt_plated = 2,
			/obj/item/clothing/head/helmet/space/void/medical/alt_plated = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/clothing/shoes/magboots = 2,
			/obj/item/tank/oxygen = 2
			)
	container_type = /obj/structure/closet/crate/secure/corporate/veymed
	container_name = "Vey-Med Medical voidsuit crate"
	access = ACCESS_MEDICAL_EQUIPMENT

/datum/supply_pack2/nanotrasen/voidsuit/single/security
	name = "Security voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/security = 2,
			/obj/item/clothing/head/helmet/space/void/security = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/clothing/shoes/magboots = 2,
			/obj/item/tank/oxygen = 2
			)
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Security voidsuit crate"
	access = ACCESS_SECURITY_ARMORY

/datum/supply_pack2/nanotrasen/voidsuit/single/security/crowd
	name = "Security Crowd Control voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/security/riot = 2,
			/obj/item/clothing/head/helmet/space/void/security/riot = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/clothing/shoes/magboots = 2,
			/obj/item/tank/oxygen = 2
			)
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Security Crowd Control voidsuit crate"
	access = ACCESS_SECURITY_ARMORY

/datum/supply_pack2/nanotrasen/voidsuit/single/security/alt
	name = "Security EVA Riot voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/security/alt = 2,
			/obj/item/clothing/head/helmet/space/void/security/alt = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/clothing/shoes/magboots = 2,
			/obj/item/tank/oxygen = 2
			)
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Security EVA Riot voidsuit crate"
	access = ACCESS_SECURITY_ARMORY

/datum/supply_pack2/nanotrasen/voidsuit/single/supply
	name = "Mining voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/mining = 2,
			/obj/item/clothing/head/helmet/space/void/mining = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/tank/oxygen = 2
			)
	container_type = /obj/structure/closet/crate/secure/corporate/grayson
	container_name = "Mining voidsuit crate"
	access = ACCESS_SUPPLY_MINE

/datum/supply_pack2/nanotrasen/voidsuit/single/supply/alt
	name = "Frontier Mining voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/mining/alt = 2,
			/obj/item/clothing/head/helmet/space/void/mining/alt = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/tank/oxygen = 2
			)
	container_type = /obj/structure/closet/crate/secure/corporate/grayson
	container_name = "Frontier Mining voidsuit crate"
	access = ACCESS_SUPPLY_MINE

/datum/supply_pack2/nanotrasen/voidsuit/single/zaddat
	name = "Zaddat Shroud"
	contains = list(
		/obj/item/clothing/suit/space/void/zaddat = 1,
		/obj/item/clothing/mask/gas/zaddat = 1
		)
	container_type = /obj/structure/closet/crate
	container_name = "Zaddat Shroud crate"
	access = null

/datum/supply_pack2/nanotrasen/voidsuit/single/supply
	name = "Mining voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/mining = 3,
			/obj/item/clothing/head/helmet/space/void/mining = 3,
			/obj/item/clothing/mask/breath = 3,
			/obj/item/tank/oxygen = 3
			)

/datum/supply_pack2/nanotrasen/voidsuit/single/explorer
	name = "Exploration voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/exploration = 3,
			/obj/item/clothing/head/helmet/space/void/exploration = 3,
			/obj/item/clothing/mask/breath = 3,
			/obj/item/clothing/shoes/magboots = 3,
			/obj/item/tank/oxygen = 3
			)
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Exploration voidsuit crate"
	access = ACCESS_GENERAL_EXPLORER

/datum/supply_pack2/nanotrasen/voidsuit/single/pilot
	name = "Pilot voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/pilot = 1,
			/obj/item/clothing/head/helmet/space/void/pilot = 1,
			/obj/item/clothing/mask/breath = 1,
			/obj/item/clothing/shoes/magboots = 1,
			/obj/item/tank/oxygen = 1
			)
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Pilot voidsuit crate"
	access = ACCESS_GENERAL_PILOT

//Cryosuits
/datum/supply_pack2/nanotrasen/voidsuit/single/cryosec
	name = "Security cryosuits"
	contains = list(
			/obj/item/clothing/suit/space/void/security/cryo = 1,
			/obj/item/clothing/head/helmet/space/void/security/cryo = 1,
			/obj/item/clothing/mask/breath = 1,
			/obj/item/clothing/shoes/magboots = 1,
			/obj/item/tank/oxygen = 1
			)
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Security cryosuit crate"
	access = ACCESS_SECURITY_ARMORY

/datum/supply_pack2/nanotrasen/voidsuit/single/cryoengi
	name = "Engineering cryosuits"
	contains = list(
			/obj/item/clothing/suit/space/void/engineering/cryo = 1,
			/obj/item/clothing/head/helmet/space/void/engineering/cryo = 1,
			/obj/item/clothing/mask/breath = 1,
			/obj/item/clothing/shoes/magboots = 1,
			/obj/item/tank/oxygen = 1
			)
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Engineering cryosuit crate"
	access = ACCESS_ENGINEERING_MAIN

/datum/supply_pack2/nanotrasen/voidsuit/single/cryoatmos
	name = "Atmospherics cryosuits"
	contains = list(
			/obj/item/clothing/suit/space/void/atmos/cryo = 1,
			/obj/item/clothing/head/helmet/space/void/atmos/cryo = 1,
			/obj/item/clothing/mask/breath = 1,
			/obj/item/clothing/shoes/magboots = 1,
			/obj/item/tank/oxygen = 1
			)
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Atmospherics cryosuit crate"
	access = ACCESS_ENGINEERING_ATMOS

/datum/supply_pack2/nanotrasen/voidsuit/single/cryomining
	name = "Mining cryosuits"
	contains = list(
			/obj/item/clothing/suit/space/void/mining/cryo = 1,
			/obj/item/clothing/head/helmet/space/void/mining/cryo = 1,
			/obj/item/clothing/mask/breath = 1,
			/obj/item/clothing/shoes/magboots = 1,
			/obj/item/tank/oxygen = 1
			)
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Mining cryosuit crate"
	access = ACCESS_SUPPLY_MINE

//ODST Suits

/datum/supply_pack2/nanotrasen/voidsuit/single/odst
	name = "Hephaestus Icarus Combat Suits"
	contains = list(
			/obj/item/clothing/suit/space/void/odst = 2,
			/obj/item/clothing/head/helmet/space/void/odst = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/clothing/shoes/magboots = 2,
			/obj/item/tank/oxygen = 2
			)
	container_type = /obj/structure/closet/crate/secure/corporate/heph
	container_name = "Icarus Combat Suit crate"

/datum/supply_pack2/nanotrasen/voidsuit/single/odst_med
	name = "Hephaestus Icarus Medic Suits"
	contains = list(
			/obj/item/clothing/suit/space/void/odst_med = 2,
			/obj/item/clothing/head/helmet/space/void/odst_med = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/clothing/shoes/magboots = 2,
			/obj/item/tank/oxygen = 2
			)
	container_type = /obj/structure/closet/crate/secure/corporate/heph
	container_name = "Hephaestheus Icarus Medic crate"
	access = ACCESS_MEDICAL_EQUIPMENT

/datum/supply_pack2/nanotrasen/voidsuit/single/odst_eng
	name = "Hephaestus Icarus Engineer Suits"
	contains = list(
			/obj/item/clothing/suit/space/void/odst_eng = 2,
			/obj/item/clothing/head/helmet/space/void/odst_eng = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/clothing/shoes/magboots = 2,
			/obj/item/tank/oxygen = 2
			)
	container_type = /obj/structure/closet/crate/secure/corporate/heph
	container_name = "Hephaestheus Icarus Engineer crate"
	access = ACCESS_ENGINEERING_ENGINE

/datum/supply_pack2/nanotrasen/voidsuit/single/odst_exp
	name = "Hephaestus Icarus Frontier Suits"
	contains = list(
			/obj/item/clothing/suit/space/void/odst_exp = 2,
			/obj/item/clothing/head/helmet/space/void/odst_exp = 2,
			/obj/item/clothing/mask/breath = 3,
			/obj/item/clothing/shoes/magboots = 3,
			/obj/item/tank/oxygen = 3
			)
	container_type = /obj/structure/closet/crate/secure/corporate/heph
	container_name = "Hephaestheus Icarus Frontier crate"
	access = ACCESS_GENERAL_EXPLORER
