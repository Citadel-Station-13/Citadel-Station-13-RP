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
	helmet_type = /obj/item/clothing/head/helmet/space/void/security/cydonia

//PARA
/obj/item/clothing/head/helmet/space/void/para
	name = "PARA void helmet"
	desc = "A voidsuit helmet bearing the icon of the PMD. Much like the 'MAW' system, this shields from memetic effects."
	icon_state = "para_ert_void"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "sec_helm", SLOT_ID_LEFT_HAND = "sec_helm")
	armor_type = /datum/armor/centcom/ert/paracausal
	siemens_coefficient = 0.7
	light_overlay = "helmet_light_dual" //explorer_light
	flash_protection = FLASH_PROTECTION_MAJOR


/obj/item/clothing/suit/space/void/para
	name = "PARA void suit"
	desc = "A spaceproof suit covered in foreign spells and magical protection, meant to defend a trained wearer in more than one way."
	icon_state = "para_ert_void"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "sec_voidsuit", SLOT_ID_LEFT_HAND = "sec_voidsuit")
	armor_type = /datum/armor/centcom/ert/paracausal
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
	icon = 'icons/clothing/gearsets/cryosuit/sec.dmi'
	icon_state = "cryohelm_sec"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	RENDER_LEGACY_PATCH_NO_CYCLING

/obj/item/clothing/suit/space/void/security/cryo
	name = "security cryosuit"
	desc = "A fur-lined suit with built-in heating systems, designed for work in dangerously cold environments. Has an additional layer of armor."
	icon = 'icons/clothing/gearsets/cryosuit/sec.dmi'
	icon_state = "cryo_sec"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	RENDER_LEGACY_PATCH_NO_CYCLING
	helmet_type = /obj/item/clothing/head/helmet/space/void/security/cryo

//Engi
/obj/item/clothing/head/helmet/space/void/engineering/cryo
	name = "engineering cryosuit helmet"
	desc = "A reinforced helmet designed for work in especially cold environments. Has radiation shielding"
	icon = 'icons/clothing/gearsets/cryosuit/engi.dmi'
	icon_state = "cryohelm_engi"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	RENDER_LEGACY_PATCH_NO_CYCLING

/obj/item/clothing/suit/space/void/engineering/cryo
	name = "engineering cryosuit"
	desc = "A fur-lined suit with built-in heating systems, designed for work in dangerously cold environments. Has radiation shielding."
	icon = 'icons/clothing/gearsets/cryosuit/engi.dmi'
	icon_state = "cryo_engi"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	RENDER_LEGACY_PATCH_NO_CYCLING
	helmet_type = /obj/item/clothing/head/helmet/space/void/engineering/cryo

//Atmospherics
/obj/item/clothing/head/helmet/space/void/atmos/cryo
	name = "atmospherics cryosuit helmet"
	desc = "A reinforced helmet designed for work in especially cold environments. Has improved thermal protection and minor radiation shielding."
	icon = 'icons/clothing/gearsets/cryosuit/atmos.dmi'
	icon_state = "cryohelm_atmos"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	RENDER_LEGACY_PATCH_NO_CYCLING

/obj/item/clothing/suit/space/void/atmos/cryo
	name = "atmos cryosuit"
	desc = "A fur-lined suit with built-in heating systems, designed for work in dangerously cold environments. Has improved thermal protection and minor radiation shielding."
	icon = 'icons/clothing/gearsets/cryosuit/atmos.dmi'
	icon_state = "cryo_atmos"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	RENDER_LEGACY_PATCH_NO_CYCLING
	helmet_type = /obj/item/clothing/head/helmet/space/void/atmos/cryo

//Mining
/obj/item/clothing/head/helmet/space/void/mining/cryo
	name = "mining cryosuit helmet"
	desc = "A reinforced helmet designed for work in especially cold environments. Has reinforced plating."
	icon = 'icons/clothing/gearsets/cryosuit/mining.dmi'
	icon_state = "cryohelm_mining"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	RENDER_LEGACY_PATCH_NO_CYCLING

/obj/item/clothing/suit/space/void/mining/cryo
	name = "mining cryosuit"
	desc = "A fur-lined suit with built-in heating systems, designed for work in dangerously cold environments. Has reinforced plating."
	icon = 'icons/clothing/gearsets/cryosuit/mining.dmi'
	icon_state = "cryo_mining"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	RENDER_LEGACY_PATCH_NO_CYCLING
	helmet_type = /obj/item/clothing/head/helmet/space/void/mining/cryo
