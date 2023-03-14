// Station voidsuits
//Engineering
/obj/item/clothing/head/helmet/space/void/engineering
	name = "engineering voidsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment. Has radiation shielding."
	icon_state = "rig0-engineering"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "eng_helm", SLOT_ID_LEFT_HAND = "eng_helm")
	r_armor_type = /datum/armor/engineering/space
	min_pressure_protection = 0  * ONE_ATMOSPHERE
	max_pressure_protection = 15 * ONE_ATMOSPHERE

/obj/item/clothing/suit/space/void/engineering
	name = "engineering voidsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has radiation shielding."
	icon_state = "rig-engineering"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "eng_voidsuit", SLOT_ID_LEFT_HAND = "eng_voidsuit")
	slowdown = 1
	r_armor_type = /datum/armor/engineering/space
	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/storage/bag/ore,/obj/item/t_scanner,/obj/item/pickaxe, /obj/item/rcd)
	min_pressure_protection = 0  * ONE_ATMOSPHERE
	max_pressure_protection = 15 * ONE_ATMOSPHERE

//Engineering HAZMAT Voidsuit

/obj/item/clothing/head/helmet/space/void/engineering/hazmat
	name = "HAZMAT voidsuit helmet"
	desc = "A engineering helmet designed for work in a low-pressure environment. Extra radiation shielding appears to have been installed at the price of comfort."
	icon_state = "rig0-engineering_rad"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "eng_helm_rad", SLOT_ID_LEFT_HAND = "eng_helm_rad")
	r_armor_type = /datum/armor/engineering/space/hazmat

/obj/item/clothing/suit/space/void/engineering/hazmat
	name = "HAZMAT voidsuit"
	desc = "A engineering voidsuit that protects against hazardous, low pressure environments. Has enhanced radiation shielding compared to regular engineering voidsuits."
	icon_state = "rig-engineering_rad"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "eng_voidsuit_rad", SLOT_ID_LEFT_HAND = "eng_voidsuit_rad")
	r_armor_type = /datum/armor/engineering/space/hazmat

//Engineering Construction Voidsuit

/obj/item/clothing/head/helmet/space/void/engineering/construction
	name = "construction voidsuit helmet"
	icon_state = "rig0-engineering_con"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "eng_helm_con", SLOT_ID_LEFT_HAND = "eng_helm_con")

/obj/item/clothing/suit/space/void/engineering/construction
	name = "construction voidsuit"
	icon_state = "rig-engineering_con"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "eng_voidsuit_con", SLOT_ID_LEFT_HAND = "eng_voidsuit_con")

//Engineering Surplus Voidsuits

/obj/item/clothing/head/helmet/space/void/engineering/alt
	name = "reinforced engineering voidsuit helmet"
	desc = "A heavy, radiation-shielded voidsuit helmet with a surprisingly comfortable interior."
	icon_state = "rig0-engineeringalt"
	r_armor_type = /datum/armor/engineering/space/heavy
	light_overlay = "helmet_light_dual"

/obj/item/clothing/suit/space/void/engineering/alt
	name = "reinforced engineering voidsuit"
	desc = "A bulky industrial voidsuit. It's a few generations old, but a reliable design and radiation shielding make up for the lack of climate control."
	icon_state = "rig-engineeringalt"
	r_armor_type = /datum/armor/engineering/space/heavy

/obj/item/clothing/head/helmet/space/void/engineering/salvage
	name = "salvage voidsuit helmet"
	desc = "A heavily modified salvage voidsuit helmet. It has been fitted with radiation-resistant plating."
	icon_state = "rig0-salvage"
	item_state_slots = list(
		SLOT_ID_LEFT_HAND = "eng_helm",
		SLOT_ID_RIGHT_HAND = "eng_helm",
		)
	r_armor_type = /datum/armor/engineering/space/salvage

/obj/item/clothing/suit/space/void/engineering/salvage
	name = "salvage voidsuit"
	desc = "A hand-me-down salvage voidsuit. It has obviously had a lot of repair work done to its radiation shielding."
	icon_state = "rig-engineeringsav"
	r_armor_type = /datum/armor/engineering/space/salvage
	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/storage/toolbox,/obj/item/storage/briefcase/inflatable,/obj/item/t_scanner,/obj/item/rcd)

//Mining
/obj/item/clothing/head/helmet/space/void/mining
	name = "mining voidsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. Has reinforced plating."
	icon_state = "rig0-mining"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "mining_helm", SLOT_ID_LEFT_HAND = "mining_helm")
	r_armor_type = /datum/armor/cargo/mining/space
	light_overlay = "helmet_light_dual"

/obj/item/clothing/suit/space/void/mining
	name = "mining voidsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has reinforced plating."
	icon_state = "rig-mining"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "mining_voidsuit", SLOT_ID_LEFT_HAND = "mining_voidsuit")
	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/pickaxe)
	r_armor_type = /datum/armor/cargo/mining/space

//Mining Surplus Voidsuit

/obj/item/clothing/head/helmet/space/void/mining/alt
	name = "frontier mining voidsuit helmet"
	desc = "An armored cheap voidsuit helmet. Someone must have through they were pretty cool when they painted a mohawk on it."
	icon_state = "rig0-miningalt"
	r_armor_type = /datum/armor/cargo/mining/space/frontier

/obj/item/clothing/suit/space/void/mining/alt
	icon_state = "rig-miningalt"
	name = "frontier mining voidsuit"
	desc = "A cheap prospecting voidsuit. What it lacks in comfort it makes up for in armor plating and street cred."
	r_armor_type = /datum/armor/cargo/mining/space/frontier

//Medical
/obj/item/clothing/head/helmet/space/void/medical
	name = "medical voidsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. Has minor radiation shielding."
	icon_state = "rig0-medical"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "medical_helm", SLOT_ID_LEFT_HAND = "medical_helm")
	r_armor_type = /datum/armor/medical/space

/obj/item/clothing/suit/space/void/medical
	name = "medical voidsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has minor radiation shielding."
	icon_state = "rig-medical"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "medical_voidsuit", SLOT_ID_LEFT_HAND = "medical_voidsuit")
	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/storage/firstaid,/obj/item/healthanalyzer,/obj/item/stack/medical)
	r_armor_type = /datum/armor/medical/space

//Medical EMT Voidsuit

/obj/item/clothing/head/helmet/space/void/medical/emt
	name = "emergency medical response voidsuit helmet"
	icon_state = "rig0-medical_emt"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "medical_helm_emt", SLOT_ID_LEFT_HAND = "medical_helm_emt")

/obj/item/clothing/suit/space/void/medical/emt
	name = "emergency medical response voidsuit"
	icon_state = "rig-medical_emt"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "medical_voidsuit_emt", SLOT_ID_LEFT_HAND = "medical_voidsuit_emt")

//Medical Biohazard Voidsuit

/obj/item/clothing/head/helmet/space/void/medical/bio
	name = "biohazard voidsuit helmet"
	desc = "A special helmet that protects against hazardous environments. Has minor radiation shielding."
	icon_state = "rig0-medical_bio"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "medical_helm_bio", SLOT_ID_LEFT_HAND = "medical_helm_bio")
	r_armor_type = /datum/armor/medical/space

/obj/item/clothing/suit/space/void/medical/bio
	name = "biohazard voidsuit"
	desc = "A special suit that protects against hazardous, environments. It feels heavier than the standard suit with extra protection around the joints."
	icon_state = "rig-medical_bio"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "medical_voidsuit_bio", SLOT_ID_LEFT_HAND = "medical_voidsuit_bio")
	r_armor_type = /datum/armor/medical/space

//Medical Streamlined Voidsuit
/obj/item/clothing/head/helmet/space/void/medical/alt
	name = "streamlined medical voidsuit helmet"
	desc = "A trendy, lightly radiation-shielded voidsuit helmet trimmed in a sleek blue."
	icon_state = "rig0-medicalalt"
	r_armor_type = /datum/armor/medical/space
	light_overlay = "helmet_light_dual_blue"

/obj/item/clothing/head/helmet/space/void/medical/alt_plated
	name = "streamlined medical voidsuit helmet"
	desc = "A trendy, fully biohazard and radiation-shielded voidsuit helmet trimmed in a sleek blue."
	icon_state = "rig0-medicalalt2"
	r_armor_type = /datum/armor/medical/space/upgraded
	light_overlay = "helmet_light_dual_blue"

/obj/item/clothing/suit/space/void/medical/alt
	icon_state = "rig-medicalalt"
	name = "streamlined medical voidsuit"
	desc = "A more recent model of Vey-Med voidsuit, exchanging physical protection for fully unencumbered movement and a complete range of motion."
	slowdown = 0
	r_armor_type = /datum/armor/medical/space

/obj/item/clothing/suit/space/void/medical/alt_plated
	icon_state = "rig-medicalalt2"
	name = "plated medical voidsuit"
	desc = "An iteration of an existing Vey-Med voidsuit, allowing full biohazard, radiation and increased close-quarters protection, at the expense of projectile and ranged layers."
	slowdown = 0
	r_armor_type = /datum/armor/medical/space/upgraded

//Security
/obj/item/clothing/head/helmet/space/void/security
	name = "security voidsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. Has an additional layer of armor."
	icon_state = "rig0-sec"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "sec_helm", SLOT_ID_LEFT_HAND = "sec_helm")
	r_armor_type = /datum/armor/security/space
	siemens_coefficient = 0.7
	light_overlay = "helmet_light_dual"

/obj/item/clothing/suit/space/void/security
	name = "security voidsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has an additional layer of armor."
	icon_state = "rig-sec"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "sec_voidsuit", SLOT_ID_LEFT_HAND = "sec_voidsuit")
	r_armor_type = /datum/armor/security/space
	allowed = list(/obj/item/gun,/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/melee/baton)
	siemens_coefficient = 0.7

//Security Crowd Control Voidsuit

/obj/item/clothing/head/helmet/space/void/security/riot
	name = "crowd control voidsuit helmet"
	icon_state = "rig0-sec_riot"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "sec_helm_riot", SLOT_ID_LEFT_HAND = "sec_helm_riot")

/obj/item/clothing/suit/space/void/security/riot
	name = "crowd control voidsuit"
	icon_state = "rig-sec_riot"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "sec_voidsuit_riot", SLOT_ID_LEFT_HAND = "sec_voidsuit_riot")

//Security Surplus Voidsuit
/obj/item/clothing/head/helmet/space/void/security/alt
	name = "riot security voidsuit helmet"
	desc = "A somewhat tacky voidsuit helmet, a fact mitigated by heavy armor plating."
	icon_state = "rig0-secalt"
	r_armor_type = /datum/armor/security/space/riot

/obj/item/clothing/suit/space/void/security/alt
	icon_state = "rig-secalt"
	name = "riot security voidsuit"
	desc = "A heavily armored voidsuit, designed to intimidate people who find black intimidating. Surprisingly slimming."
	r_armor_type = /datum/armor/security/space/riot
	allowed = list(/obj/item/gun,/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/melee/baton)

//Cydonia Armor
/obj/item/clothing/head/helmet/space/void/security/cydonia
	name = "cydonian helmet"
	desc = "A special helmet designed with form and function in mind, capable of protecting the wearer from trauma and hazardous environments."
	icon_state = "knight_cydonia"
	light_overlay = "ck_overlay"

/obj/item/clothing/suit/space/void/security/cydonia
	name = "cydonian voidsuit"
	desc = "A bulky, but well armored suit capable of protecting the wearer from both trauma and hazardous environments."
	icon_state = "knight_cydonia"

//Atmospherics
/obj/item/clothing/head/helmet/space/void/atmos
	desc = "A special helmet designed for work in a hazardous, low pressure environments. Has improved thermal protection and minor radiation shielding."
	name = "atmospherics voidsuit helmet"
	icon_state = "rig0-atmos"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "atmos_helm", SLOT_ID_LEFT_HAND = "atmos_helm")
	r_armor_type = /datum/armor/engineering/space/atmos
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	light_overlay = "helmet_light_dual"
	min_pressure_protection = 0 * ONE_ATMOSPHERE
	max_pressure_protection = 20* ONE_ATMOSPHERE

/obj/item/clothing/suit/space/void/atmos
	name = "atmos voidsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has improved thermal protection and minor radiation shielding."
	icon_state = "rig-atmos"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "atmos_voidsuit", SLOT_ID_LEFT_HAND = "atmos_voidsuit")
	r_armor_type = /datum/armor/engineering/space/atmos
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	min_pressure_protection = 0 * ONE_ATMOSPHERE
	max_pressure_protection = 20* ONE_ATMOSPHERE

//Atmospherics Surplus Voidsuit

/obj/item/clothing/head/helmet/space/void/atmos/alt
	desc = "A special voidsuit helmet designed for work in hazardous, low pressure environments.This one has been plated with an expensive heat and radiation resistant ceramic."
	name = "heavy duty atmospherics voidsuit helmet"
	icon_state = "rig0-atmosalt"
	r_armor_type = /datum/armor/engineering/space/atmos/heavy
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	light_overlay = "hardhat_light"

/obj/item/clothing/suit/space/void/atmos/alt
	desc = "A special suit that protects against hazardous, low pressure environments. Fits better than the standard atmospheric voidsuit while still rated to withstand extreme heat and even minor radiation."
	icon_state = "rig-atmosalt"
	name = "heavy duty atmos voidsuit"
	r_armor_type = /datum/armor/engineering/space/atmos/heavy
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE

//Exploration
/obj/item/clothing/head/helmet/space/void/exploration
	name = "exploration voidsuit helmet"
	desc = "A radiation-resistant helmet made especially for exploring unknown planetary environments."
	icon_state = "helm_explorer"
	item_state = "helm_explorer"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "syndicate-helm-black", SLOT_ID_LEFT_HAND = "syndicate-helm-black")
	r_armor_type = /datum/armor/exploration/space
	light_overlay = "helmet_light_dual" //explorer_light
	camera_networks = list(NETWORK_EXPLO_HELMETS)

/obj/item/clothing/suit/space/void/exploration
	name = "exploration voidsuit"
	desc = "A lightweight, radiation-resistant voidsuit, featuring the Explorer emblem on its chest plate. Designed for exploring unknown planetary environments."
	icon_state = "void_explorer"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "skrell_suit_black", SLOT_ID_LEFT_HAND = "skrell_suit_black")
	r_armor_type = /datum/armor/exploration/space
	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/stack/flag,/obj/item/healthanalyzer,/obj/item/gps,/obj/item/radio/beacon, \
	/obj/item/shovel,/obj/item/ammo_magazine,/obj/item/gun)

/obj/item/clothing/head/helmet/space/void/exploration/alt
	desc = "A radiation-resistant helmet made especially for exploring unknown planetary environments."
	icon_state = "helm_explorer2"
	item_state = "helm_explorer2"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "mining_helm", SLOT_ID_LEFT_HAND = "mining_helm")

/obj/item/clothing/suit/space/void/exploration/alt
	desc = "A lightweight, radiation-resistant voidsuit. Designed for exploring unknown planetary environments."
	icon_state = "void_explorer2"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "skrell_suit_white", SLOT_ID_LEFT_HAND = "skrell_suit_white")

/obj/item/clothing/head/helmet/space/void/exploration/pathfinder
	name = "pathfinder voidsuit helmet"
	desc = "A comfortable helmet designed to provide protection for Pathfinder units on long-term operations."
	icon_state = "helm_explorer_pf"
	item_state = "helm_explorer_pf"
	r_armor_type = /datum/armor/exploration/space/pathfinder

/obj/item/clothing/suit/space/void/exploration/pathfinder
	name = "pathfinder voidsuit"
	desc = "A versatile, armored voidsuit, featuring the Pathfinder emblem on its chest plate. Designed for long deployments in unknown planetary environments."
	icon_state = "void_explorer_pf"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "skrell_suit_black", SLOT_ID_LEFT_HAND = "skrell_suit_black")
	r_armor_type = /datum/armor/exploration/space/pathfinder
	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/stack/flag,/obj/item/healthanalyzer,/obj/item/gps,/obj/item/radio/beacon, \
	/obj/item/shovel,/obj/item/ammo_magazine,/obj/item/gun)

//Pilot
/obj/item/clothing/head/helmet/space/void/pilot
	desc = "An atmos resistant helmet for space and planet exploration."
	name = "pilot voidsuit helmet"
	icon_state = "rig0_pilot"
	item_state = "pilot_helm"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "atmos_helm", SLOT_ID_LEFT_HAND = "atmos_helm")
	r_armor_type = /datum/armor/exploration/space/pilot
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	light_overlay = "helmet_light_dual"
	camera_networks = list(NETWORK_EXPLO_HELMETS)

/obj/item/clothing/suit/space/void/pilot
	desc = "An atmos resistant voidsuit for space and planet exploration."
	icon_state = "rig-pilot"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "atmos_voidsuit", SLOT_ID_LEFT_HAND = "atmos_voidsuit")
	name = "pilot voidsuit"
	r_armor_type = /datum/armor/exploration/space/pilot
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/storage/toolbox,/obj/item/storage/briefcase/inflatable)

/obj/item/clothing/head/helmet/space/void/pilot/alt
	icon_state = "rig0_pilot2"
	item_state = "pilot_helm2"

/obj/item/clothing/suit/space/void/pilot/alt
	desc = "An atmos resistant voidsuit for space."
	icon_state = "rig-pilot2"
	item_state = "rig-pilot2"

//Captain (cit addition, the idea is to replace the "Facility Director armor" which doesnt function like a voidsuit
/obj/item/clothing/head/helmet/space/void/captain
	desc = "Shiny blue helmet, complete with far-too-big golden visor. It probably doesn't protects from bright flashes."
	name = "Facility Director voidsuit helmet"
	icon_state = "capvoid"
	r_armor_type = /datum/armor/security/high/captain

/obj/item/clothing/suit/space/void/captain
	desc = "Sleek, blue and gold suit, fitted with spaceproofing and protective inserts. Fits like an oversized, shiny glove."
	name = "Facility Director voidsuit"
	icon_state = "capsuit_void"
	r_armor_type = /datum/armor/security/high/captain
	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/gun)
	slowdown = 1.5

//Head of Security - update to the snowflake suit
/obj/item/clothing/head/helmet/space/void/headofsecurity
	desc = "A customized security voidsuit helmet. Has additional composite armor."
	name = "head of security protosuit helmet"
	icon_state = "hosproto"
	r_armor_type = /datum/armor/security/hos/space

/obj/item/clothing/suit/space/void/headofsecurity
	desc = "A customized security voidsuit. Has additional composite armor."
	name = "head of security protosuit"
	icon_state = "hosproto_void"
	r_armor_type = /datum/armor/security/hos/space
	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/gun)
	slowdown = 1.5

//PARA
/obj/item/clothing/head/helmet/space/void/para
	name = "PARA void helmet"
	desc = "A voidsuit helmet bearing the icon of the PMD. Much like the 'MAW' system, this shields from memetic effects."
	icon_state = "para_ert_void"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "sec_helm", SLOT_ID_LEFT_HAND = "sec_helm")
	r_armor_type = /datum/armor/security/ert/paracausal
	siemens_coefficient = 0.7
	light_overlay = "helmet_light_dual" //explorer_light
	flash_protection = FLASH_PROTECTION_MAJOR


/obj/item/clothing/suit/space/void/para
	name = "PARA void suit"
	desc = "A spaceproof suit covered in foreign spells and magical protection, meant to defend a trained wearer in more than one way."
	icon_state = "para_ert_void"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "sec_voidsuit", SLOT_ID_LEFT_HAND = "sec_voidsuit")
	r_armor_type = /datum/armor/security/ert/paracausal
	allowed = list(/obj/item/gun,/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/melee/baton,/obj/item/ammo_magazine,/obj/item/nullrod)
	siemens_coefficient = 0.7
	var/anti_magic = TRUE

//Gimmick and "Costume" Tier Voidsuits

/obj/item/clothing/head/helmet/space/void/para/soror
	name = "inquisitorial bodyguard helmet"
	desc = "A voidsuit helmet bearing the icon of the PMD. Much like the 'MAW' system, this shields from memetic effects."
	icon_state = "knight_inq"
	light_overlay = "ik_overlay"

/obj/item/clothing/suit/space/void/para/soror
	name = "inquisitorial bodyguard suit"
	desc = "A spaceproof suit provided to PARA attached to Inquisitorial escort duty."
	icon_state = "knight_inq"

/obj/item/clothing/head/helmet/space/void/para/grey_knight
	name = "spell knight helmet"
	desc = "A bulky silver helmet sometimes worn by PMD agents due to its arcane utility."
	icon_state = "knight_grey"
	light_overlay = "gk_overlay"

/obj/item/clothing/suit/space/void/para/grey_knight
	name = "spell knight voidsuit"
	desc = "An icredibly heavy suit of anti-magic armor worn by augmented PMD agents."
	icon_state = "knight_grey"

//Cryosuits - These have a Dead Space 3 vibe to them. Had to port them for our ICE PLANET MAP.
//Security
/obj/item/clothing/head/helmet/space/void/security/cryo
	name = "security cryosuit helmet"
	desc = "A reinforced helmet designed for work in especially cold environments. Has an additional layer of armor."
	icon = 'icons/clothing/suit/space/cryosuit.dmi'
	icon_state = "cryohelm_sec"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

/obj/item/clothing/suit/space/void/security/cryo
	name = "security cryosuit"
	desc = "A fur-lined suit with built-in heating systems, designed for work in dangerously cold environments. Has an additional layer of armor."
	icon = 'icons/clothing/suit/space/cryosuit.dmi'
	icon_state = "cryo_sec"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

//Engi
/obj/item/clothing/head/helmet/space/void/engineering/cryo
	name = "engineering cryosuit helmet"
	desc = "A reinforced helmet designed for work in especially cold environments. Has radiation shielding"
	icon = 'icons/clothing/suit/space/cryosuit.dmi'
	icon_state = "cryohelm_engi"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

/obj/item/clothing/suit/space/void/engineering/cryo
	name = "engineering cryosuit"
	desc = "A fur-lined suit with built-in heating systems, designed for work in dangerously cold environments. Has radiation shielding."
	icon = 'icons/clothing/suit/space/cryosuit.dmi'
	icon_state = "cryo_engi"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

//Atmospherics
/obj/item/clothing/head/helmet/space/void/atmos/cryo
	name = "atmospherics cryosuit helmet"
	desc = "A reinforced helmet designed for work in especially cold environments. Has improved thermal protection and minor radiation shielding."
	icon = 'icons/clothing/suit/space/cryosuit.dmi'
	icon_state = "cryohelm_atmos"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

/obj/item/clothing/suit/space/void/atmos/cryo
	name = "atmos cryosuit"
	desc = "A fur-lined suit with built-in heating systems, designed for work in dangerously cold environments. Has improved thermal protection and minor radiation shielding."
	icon = 'icons/clothing/suit/space/cryosuit.dmi'
	icon_state = "cryo_atmos"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

//Mining
/obj/item/clothing/head/helmet/space/void/mining/cryo
	name = "mining cryosuit helmet"
	desc = "A reinforced helmet designed for work in especially cold environments. Has reinforced plating."
	icon = 'icons/clothing/suit/space/cryosuit.dmi'
	icon_state = "cryohelm_mining"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

/obj/item/clothing/suit/space/void/mining/cryo
	name = "mining cryosuit"
	desc = "A fur-lined suit with built-in heating systems, designed for work in dangerously cold environments. Has reinforced plating."
	icon = 'icons/clothing/suit/space/cryosuit.dmi'
	icon_state = "cryo_mining"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
