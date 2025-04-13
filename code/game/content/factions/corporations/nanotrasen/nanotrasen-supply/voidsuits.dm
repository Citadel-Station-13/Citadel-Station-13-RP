/datum/supply_pack/nanotrasen/voidsuit
	category = "Voidsuits"

/**
 * for single types of voidsuits
 *
 * * voidsuit & its helmet must have worth set
 * * voidsuit must have its helmet_type var set
 */
/datum/supply_pack/nanotrasen/voidsuit/single
	var/voidsuit_type = /obj/item/clothing/suit/space/void
	var/amount = 1
	/// if it doesn't start with boots, spawn boots in the package
	var/automatically_include_boots = TRUE
	/// if it doesn't start with an oxygen tank or cooler, spawn life support in the package
	var/automatically_include_life_support = TRUE

/datum/supply_pack/nanotrasen/voidsuit/single/populate()
	..()
	var/obj/item/clothing/suit/space/void/casted = voidsuit_type
	contains[voidsuit_type] = amount + contains[voidsuit_type]

	if(!initial(casted.starts_with_helmet))
		contains[initial(casted.helmet_type)] = amount + contains[initial(casted.helmet_type)]
	if(!initial(casted.starts_with_boots) && automatically_include_boots)
		contains[initial(casted.boots_type)] = amount + contains[initial(casted.boots_type)]
	if(!initial(casted.starts_with_life_support) && automatically_include_life_support)
		contains[initial(casted.tank_type)] = amount + contains[initial(casted.tank_type)]

//Engineering
/datum/supply_pack/nanotrasen/voidsuit/single/atmos
	name = "Atmospherics voidsuits"
	voidsuit_type = /obj/item/clothing/suit/space/void/atmos
	amount = 2
	container_type = /obj/structure/closet/crate/secure/corporate/aether
	container_name = "atmospherics voidsuit crate"

/datum/supply_pack/nanotrasen/voidsuit/single/atmos/alt
	name = "Heavy Duty Atmospherics voidsuits"
	voidsuit_type = /obj/item/clothing/suit/space/void/atmos/alt
	amount = 2
	container_type = /obj/structure/closet/crate/secure/corporate/aether
	container_name = "heavy duty atmospherics voidsuit crate"

/datum/supply_pack/nanotrasen/voidsuit/single/engineering
	name = "Engineering voidsuits"
	voidsuit_type = /obj/item/clothing/suit/space/void/engineering
	amount = 2
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Engineering voidsuit crate"

/datum/supply_pack/nanotrasen/voidsuit/single/engineering/construction
	name = "Engineering Construction voidsuits"
	voidsuit_type = /obj/item/clothing/suit/space/void/engineering/construction
	amount = 2
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Engineering Construction voidsuit crate"

/datum/supply_pack/nanotrasen/voidsuit/single/engineering/hazmat
	name = "Engineering Hazmat voidsuits"
	voidsuit_type = /obj/item/clothing/suit/space/void/engineering/hazmat
	amount = 2
	container_type = /obj/structure/closet/crate/secure/corporate/aether
	container_name = "Engineering Hazmat voidsuit crate"

/datum/supply_pack/nanotrasen/voidsuit/single/engineering/alt
	name = "Reinforced Engineering voidsuits"
	voidsuit_type = /obj/item/clothing/suit/space/void/engineering/alt
	amount = 2
	container_type = /obj/structure/closet/crate/secure/corporate/aether
	container_name = "Reinforced Engineering voidsuit crate"

//Medical
/datum/supply_pack/nanotrasen/voidsuit/single/medical
	name = "Medical voidsuits"
	voidsuit_type = /obj/item/clothing/suit/space/void/medical
	amount = 2
	container_type = /obj/structure/closet/crate/secure
	container_name = "Medical voidsuit crate"

/datum/supply_pack/nanotrasen/voidsuit/single/medical/emt
	name = "Medical EMT voidsuits"
	voidsuit_type = /obj/item/clothing/suit/space/void/medical/emt
	amount = 2
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Medical EMT voidsuit crate"

/datum/supply_pack/nanotrasen/voidsuit/single/medical/bio
	name = "Medical Biohazard voidsuits"
	voidsuit_type = /obj/item/clothing/suit/space/void/medical/bio
	amount = 2
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Medical Biohazard voidsuit crate"

/datum/supply_pack/nanotrasen/voidsuit/single/medical/alt
	name = "Vey-Med Medical voidsuits"
	voidsuit_type = /obj/item/clothing/suit/space/void/medical/alt
	amount = 2
	container_type = /obj/structure/closet/crate/secure/corporate/veymed
	container_name = "Vey-Med Medical voidsuit crate"

/datum/supply_pack/nanotrasen/voidsuit/single/medical/alt2
	name = "Vey-Med Plated Medical voidsuits"
	voidsuit_type = /obj/item/clothing/suit/space/void/medical/alt_plated
	amount = 2
	container_type = /obj/structure/closet/crate/secure/corporate/veymed
	container_name = "Vey-Med Medical voidsuit crate"

//Security
/datum/supply_pack/nanotrasen/voidsuit/single/security
	name = "Security voidsuits"
	voidsuit_type = /obj/item/clothing/suit/space/void/security
	amount = 2
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Security voidsuit crate"
	container_access = list(
		/datum/access/station/security/equipment,
	)

/datum/supply_pack/nanotrasen/voidsuit/single/security/crowd
	name = "Security Crowd Control voidsuits"
	voidsuit_type = /obj/item/clothing/suit/space/void/security/riot
	amount = 2
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Security Crowd Control voidsuit crate"

/datum/supply_pack/nanotrasen/voidsuit/single/security/alt
	name = "Security EVA Riot voidsuits"
	voidsuit_type = /obj/item/clothing/suit/space/void/security/alt
	amount = 2
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Security EVA Riot voidsuit crate"

//Mining
/datum/supply_pack/nanotrasen/voidsuit/single/supply
	name = "Mining voidsuits"
	voidsuit_type = /obj/item/clothing/suit/space/void/mining
	amount = 2
	container_name = "Mining voidsuit crate"

/datum/supply_pack/nanotrasen/voidsuit/single/supply/alt
	name = "Frontier Mining voidsuits"
	voidsuit_type = /obj/item/clothing/suit/space/void/mining/alt
	amount = 2
	container_name = "Frontier Mining voidsuit crate"

/datum/supply_pack/nanotrasen/voidsuit/single/zaddat
	name = "Zaddat Shroud"
	voidsuit_type = /obj/item/clothing/suit/space/void/zaddat
	amount = 1

/datum/supply_pack/nanotrasen/voidsuit/single/supply
	name = "Mining voidsuits"
	voidsuit_type = /obj/item/clothing/suit/space/void/mining
	amount = 3

//Exploration
/datum/supply_pack/nanotrasen/voidsuit/single/explorer
	name = "Exploration voidsuits"
	voidsuit_type = /obj/item/clothing/suit/space/void/exploration
	amount = 3
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Exploration voidsuit crate"

/datum/supply_pack/nanotrasen/voidsuit/single/pilot
	name = "Pilot voidsuits"
	voidsuit_type = /obj/item/clothing/suit/space/void/pilot
	amount = 2
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Pilot voidsuit crate"

//Science
/datum/supply_pack/nanotrasen/voidsuit/single/phase
	name = "Hazard Bypass voidsuits"
	voidsuit_type = /obj/item/clothing/suit/space/void/science
	amount = 2
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Nanotrasen Science Division voidsuit crate"

//Cryosuits
/datum/supply_pack/nanotrasen/voidsuit/single/cryosec
	name = "Security cryosuits"
	voidsuit_type = /obj/item/clothing/suit/space/void/security/cryo
	amount = 1
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Security cryosuit crate"
	container_access = list(
		/datum/access/station/security/equipment,
	)

/datum/supply_pack/nanotrasen/voidsuit/single/cryoengi
	name = "Engineering cryosuits"
	voidsuit_type = /obj/item/clothing/suit/space/void/engineering/cryo
	amount = 1
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Engineering cryosuit crate"

/datum/supply_pack/nanotrasen/voidsuit/single/cryoatmos
	name = "Atmospherics cryosuits"
	voidsuit_type = /obj/item/clothing/suit/space/void/atmos/cryo
	amount = 1
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Atmospherics cryosuit crate"

/datum/supply_pack/nanotrasen/voidsuit/single/cryomining
	name = "Mining cryosuits"
	voidsuit_type = /obj/item/clothing/suit/space/void/mining/cryo
	amount = 1
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Mining cryosuit crate"

/datum/supply_pack/nanotrasen/voidsuit/single/odst
	name = "Hephaestus Icarus Combat Suits"
	voidsuit_type = /obj/item/clothing/suit/space/void/odst
	amount = 2
	container_type = /obj/structure/closet/crate/secure/corporate/heph
	container_name = "Icarus Combat Suit crate"

/datum/supply_pack/nanotrasen/voidsuit/single/odst_med
	name = "Hephaestus Icarus Medic Suits"
	voidsuit_type = /obj/item/clothing/suit/space/void/odst_med
	amount = 2
	container_type = /obj/structure/closet/crate/secure/corporate/heph
	container_name = "Hephaestheus Icarus Medic crate"

/datum/supply_pack/nanotrasen/voidsuit/single/odst_eng
	name = "Hephaestus Icarus Engineer Suits"
	voidsuit_type = /obj/item/clothing/suit/space/void/odst_eng
	amount = 2
	container_type = /obj/structure/closet/crate/secure/corporate/heph
	container_name = "Hephaestheus Icarus Engineer crate"

/datum/supply_pack/nanotrasen/voidsuit/single/odst_exp
	name = "Hephaestus Icarus Frontier Suits"
	voidsuit_type = /obj/item/clothing/suit/space/void/odst_exp
	amount = 2
	container_type = /obj/structure/closet/crate/secure/corporate/heph
	container_name = "Hephaestheus Icarus Frontier crate"
