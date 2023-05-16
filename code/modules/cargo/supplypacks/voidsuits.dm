/*
*	Here is where any supply packs
*	related to voidsuits live.
*/


/datum/supply_pack/voidsuits
	group = "Voidsuits"

/datum/supply_pack/voidsuits/atmos
	name = "Atmospheric voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/atmos = 2,
			/obj/item/clothing/head/helmet/space/void/atmos = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/clothing/shoes/magboots = 2,
			/obj/item/tank/oxygen = 2,
			)
	cost = 40
	container_type = /obj/structure/closet/crate/secure/aether
	container_name = "Atmospheric voidsuit crate"
	access = ACCESS_ENGINEERING_ATMOS

/datum/supply_pack/voidsuits/atmos/alt
	name = "Heavy Duty Atmospheric voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/atmos/alt = 2,
			/obj/item/clothing/head/helmet/space/void/atmos/alt = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/clothing/shoes/magboots = 2,
			/obj/item/tank/oxygen = 2,
			)
	cost = 50
	container_type = /obj/structure/closet/crate/secure/aether
	container_name = "Heavy Duty Atmospheric voidsuit crate"
	access = ACCESS_ENGINEERING_ATMOS

/datum/supply_pack/voidsuits/engineering
	name = "Engineering voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/engineering = 2,
			/obj/item/clothing/head/helmet/space/void/engineering = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/clothing/shoes/magboots = 2,
			/obj/item/tank/oxygen = 2
			)
	cost = 40
	container_type = /obj/structure/closet/crate/secure/nanotrasen
	container_name = "Engineering voidsuit crate"
	access = ACCESS_ENGINEERING_ENGINE

/datum/supply_pack/voidsuits/engineering/construction
	name = "Engineering Construction voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/engineering/construction = 2,
			/obj/item/clothing/head/helmet/space/void/engineering/construction = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/clothing/shoes/magboots = 2,
			/obj/item/tank/oxygen = 2
			)
	cost = 40
	container_type = /obj/structure/closet/crate/secure/nanotrasen
	container_name = "Engineering Construction voidsuit crate"
	access = ACCESS_ENGINEERING_ENGINE

/datum/supply_pack/voidsuits/engineering/hazmat
	name = "Engineering Hazmat voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/engineering/hazmat = 2,
			/obj/item/clothing/head/helmet/space/void/engineering/hazmat = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/clothing/shoes/magboots = 2,
			/obj/item/tank/oxygen = 2
			)
	cost = 45
	container_type = /obj/structure/closet/crate/secure/aether
	container_name = "Engineering Hazmat voidsuit crate"
	access = ACCESS_ENGINEERING_ENGINE

/datum/supply_pack/voidsuits/engineering/alt
	name = "Reinforced Engineering voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/engineering/alt = 2,
			/obj/item/clothing/head/helmet/space/void/engineering/alt = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/clothing/shoes/magboots = 2,
			/obj/item/tank/oxygen = 2
			)
	cost = 50
	container_type = /obj/structure/closet/crate/secure/aether
	container_name = "Reinforced Engineering voidsuit crate"
	access = ACCESS_ENGINEERING_ENGINE

/datum/supply_pack/voidsuits/medical
	name = "Medical voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/medical = 2,
			/obj/item/clothing/head/helmet/space/void/medical = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/clothing/shoes/magboots = 2,
			/obj/item/tank/oxygen = 2
			)
	cost = 40
	container_type = /obj/structure/closet/crate/secure
	container_name = "Medical voidsuit crate"
	access = ACCESS_MEDICAL_EQUIPMENT

/datum/supply_pack/voidsuits/medical/emt
	name = "Medical EMT voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/medical/emt = 2,
			/obj/item/clothing/head/helmet/space/void/medical/emt = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/clothing/shoes/magboots = 2,
			/obj/item/tank/oxygen = 2
			)
	cost = 40
	container_type = /obj/structure/closet/crate/secure/nanotrasen
	container_name = "Medical EMT voidsuit crate"
	access = ACCESS_MEDICAL_EQUIPMENT

/datum/supply_pack/voidsuits/medical/bio
	name = "Medical Biohazard voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/medical/bio = 2,
			/obj/item/clothing/head/helmet/space/void/medical/bio = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/clothing/shoes/magboots = 2,
			/obj/item/tank/oxygen = 2
			)
	cost = 45
	container_type = /obj/structure/closet/crate/secure/nanotrasen
	container_name = "Medical Biohazard voidsuit crate"
	access = ACCESS_MEDICAL_EQUIPMENT

/datum/supply_pack/voidsuits/medical/alt
	name = "Vey-Med Medical voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/medical/alt = 2,
			/obj/item/clothing/head/helmet/space/void/medical/alt = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/clothing/shoes/magboots = 2,
			/obj/item/tank/oxygen = 2
			)
	cost = 60
	container_type = /obj/structure/closet/crate/secure/veymed
	container_name = "Vey-Med Medical voidsuit crate"
	access = ACCESS_MEDICAL_EQUIPMENT

/datum/supply_pack/voidsuits/medical/alt2
	name = "Vey-Med Plated Medical voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/medical/alt_plated = 2,
			/obj/item/clothing/head/helmet/space/void/medical/alt_plated = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/clothing/shoes/magboots = 2,
			/obj/item/tank/oxygen = 2
			)
	cost = 50
	container_type = /obj/structure/closet/crate/secure/veymed
	container_name = "Vey-Med Medical voidsuit crate"
	access = ACCESS_MEDICAL_EQUIPMENT

/datum/supply_pack/voidsuits/security
	name = "Security voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/security = 2,
			/obj/item/clothing/head/helmet/space/void/security = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/clothing/shoes/magboots = 2,
			/obj/item/tank/oxygen = 2
			)
	cost = 40
	container_type = /obj/structure/closet/crate/secure/nanotrasen
	container_name = "Security voidsuit crate"

/datum/supply_pack/voidsuits/security/crowd
	name = "Security Crowd Control voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/security/riot = 2,
			/obj/item/clothing/head/helmet/space/void/security/riot = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/clothing/shoes/magboots = 2,
			/obj/item/tank/oxygen = 2
			)
	cost = 40
	container_type = /obj/structure/closet/crate/secure/nanotrasen
	container_name = "Security Crowd Control voidsuit crate"
	access = ACCESS_SECURITY_ARMORY

/datum/supply_pack/voidsuits/security/alt
	name = "Security EVA Riot voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/security/alt = 2,
			/obj/item/clothing/head/helmet/space/void/security/alt = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/clothing/shoes/magboots = 2,
			/obj/item/tank/oxygen = 2
			)
	cost = 50
	container_type = /obj/structure/closet/crate/secure/nanotrasen
	container_name = "Security EVA Riot voidsuit crate"
	access = ACCESS_SECURITY_ARMORY

/datum/supply_pack/voidsuits/supply
	name = "Mining voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/mining = 2,
			/obj/item/clothing/head/helmet/space/void/mining = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/tank/oxygen = 2
			)
	cost = 40
	container_type = /obj/structure/closet/crate/secure/grayson
	container_name = "Mining voidsuit crate"
	access = ACCESS_SUPPLY_MINE

/datum/supply_pack/voidsuits/supply/alt
	name = "Frontier Mining voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/mining/alt = 2,
			/obj/item/clothing/head/helmet/space/void/mining/alt = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/tank/oxygen = 2
			)
	cost = 50
	container_type = /obj/structure/closet/crate/secure/grayson
	container_name = "Frontier Mining voidsuit crate"
	access = ACCESS_SUPPLY_MINE

/datum/supply_pack/voidsuits/zaddat
	name = "Zaddat Shroud"
	contains = list(
		/obj/item/clothing/suit/space/void/zaddat = 1,
		/obj/item/clothing/mask/gas/zaddat = 1
		)
	cost = 30
	container_type = /obj/structure/closet/crate
	container_name = "Zaddat Shroud crate"
	access = null

/datum/supply_pack/voidsuits/atmos
	contains = list(
			/obj/item/clothing/suit/space/void/atmos = 3,
			/obj/item/clothing/head/helmet/space/void/atmos = 3,
			/obj/item/clothing/mask/breath = 3,
			/obj/item/clothing/shoes/magboots = 3,
			/obj/item/tank/oxygen = 3,
			)

/datum/supply_pack/voidsuits/engineering
	contains = list(
			/obj/item/clothing/suit/space/void/engineering = 3,
			/obj/item/clothing/head/helmet/space/void/engineering = 3,
			/obj/item/clothing/mask/breath = 3,
			/obj/item/clothing/shoes/magboots = 3,
			/obj/item/tank/oxygen = 3
			)

/datum/supply_pack/voidsuits/medical
	contains = list(
			/obj/item/clothing/suit/space/void/medical = 3,
			/obj/item/clothing/head/helmet/space/void/medical = 3,
			/obj/item/clothing/mask/breath = 3,
			/obj/item/clothing/shoes/magboots = 3,
			/obj/item/tank/oxygen = 3
			)

/datum/supply_pack/voidsuits/medical/alt
	contains = list(
			/obj/item/clothing/suit/space/void/medical/alt = 3,
			/obj/item/clothing/head/helmet/space/void/medical/alt = 3,
			/obj/item/clothing/mask/breath = 3,
			/obj/item/clothing/shoes/magboots = 3,
			/obj/item/tank/oxygen = 3
			)

/datum/supply_pack/voidsuits/security
	contains = list(
			/obj/item/clothing/suit/space/void/security = 3,
			/obj/item/clothing/head/helmet/space/void/security = 3,
			/obj/item/clothing/mask/breath = 3,
			/obj/item/clothing/shoes/magboots = 3,
			/obj/item/tank/oxygen = 3
			)

/datum/supply_pack/voidsuits/security/crowd
	contains = list(
			/obj/item/clothing/suit/space/void/security/riot = 3,
			/obj/item/clothing/head/helmet/space/void/security/riot = 3,
			/obj/item/clothing/mask/breath = 3,
			/obj/item/clothing/shoes/magboots = 3,
			/obj/item/tank/oxygen = 3
			)

/datum/supply_pack/voidsuits/security/alt
	contains = list(
			/obj/item/clothing/suit/space/void/security/alt = 3,
			/obj/item/clothing/head/helmet/space/void/security/alt = 3,
			/obj/item/clothing/mask/breath = 3,
			/obj/item/clothing/shoes/magboots = 3,
			/obj/item/tank/oxygen = 3
			)

/datum/supply_pack/voidsuits/supply
	name = "Mining voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/mining = 3,
			/obj/item/clothing/head/helmet/space/void/mining = 3,
			/obj/item/clothing/mask/breath = 3,
			/obj/item/tank/oxygen = 3
			)

/datum/supply_pack/voidsuits/explorer
	name = "Exploration voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/exploration = 3,
			/obj/item/clothing/head/helmet/space/void/exploration = 3,
			/obj/item/clothing/mask/breath = 3,
			/obj/item/clothing/shoes/magboots = 3,
			/obj/item/tank/oxygen = 3
			)
	cost = 50
	container_type = /obj/structure/closet/crate/secure/nanotrasen
	container_name = "Exploration voidsuit crate"
	access = ACCESS_GENERAL_EXPLORER

/datum/supply_pack/voidsuits/pilot
	name = "Pilot voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/pilot = 1,
			/obj/item/clothing/head/helmet/space/void/pilot = 1,
			/obj/item/clothing/mask/breath = 1,
			/obj/item/clothing/shoes/magboots = 1,
			/obj/item/tank/oxygen = 1
			)
	cost = 20
	container_type = /obj/structure/closet/crate/secure/nanotrasen
	container_name = "Pilot voidsuit crate"
	access = ACCESS_GENERAL_PILOT

//Cryosuits
/datum/supply_pack/voidsuits/cryosec
	name = "Security cryosuits"
	contains = list(
			/obj/item/clothing/suit/space/void/security/cryo = 1,
			/obj/item/clothing/head/helmet/space/void/security/cryo = 1,
			/obj/item/clothing/mask/breath = 1,
			/obj/item/clothing/shoes/magboots = 1,
			/obj/item/tank/oxygen = 1
			)
	cost = 20
	container_type = /obj/structure/closet/crate/secure/nanotrasen
	container_name = "Security cryosuit crate"
	access = ACCESS_SECURITY_ARMORY

/datum/supply_pack/voidsuits/cryoengi
	name = "Engineering cryosuits"
	contains = list(
			/obj/item/clothing/suit/space/void/engineering/cryo = 1,
			/obj/item/clothing/head/helmet/space/void/engineering/cryo = 1,
			/obj/item/clothing/mask/breath = 1,
			/obj/item/clothing/shoes/magboots = 1,
			/obj/item/tank/oxygen = 1
			)
	cost = 20
	container_type = /obj/structure/closet/crate/secure/nanotrasen
	container_name = "Engineering cryosuit crate"
	access = ACCESS_ENGINEERING_MAIN

/datum/supply_pack/voidsuits/cryoatmos
	name = "Atmospherics cryosuits"
	contains = list(
			/obj/item/clothing/suit/space/void/atmos/cryo = 1,
			/obj/item/clothing/head/helmet/space/void/atmos/cryo = 1,
			/obj/item/clothing/mask/breath = 1,
			/obj/item/clothing/shoes/magboots = 1,
			/obj/item/tank/oxygen = 1
			)
	cost = 20
	container_type = /obj/structure/closet/crate/secure/nanotrasen
	container_name = "Atmospherics cryosuit crate"
	access = ACCESS_ENGINEERING_ATMOS

/datum/supply_pack/voidsuits/cryomining
	name = "Mining cryosuits"
	contains = list(
			/obj/item/clothing/suit/space/void/mining/cryo = 1,
			/obj/item/clothing/head/helmet/space/void/mining/cryo = 1,
			/obj/item/clothing/mask/breath = 1,
			/obj/item/clothing/shoes/magboots = 1,
			/obj/item/tank/oxygen = 1
			)
	cost = 20
	container_type = /obj/structure/closet/crate/secure/nanotrasen
	container_name = "Mining cryosuit crate"
	access = ACCESS_SUPPLY_MINE
