//Syndicate rig
/obj/item/clothing/head/helmet/space/void/merc
	name = "blood-red voidsuit helmet"
	desc = "An advanced helmet designed for work in special operations. Property of Gorlex Marauders."
	icon_state = "rig0-syndie"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "syndie_helm", SLOT_ID_LEFT_HAND = "syndie_helm")
	armor_type = /datum/armor/merc/space
	siemens_coefficient = 0.6
	encumbrance = ITEM_ENCUMBRANCE_VOIDSUIT_HELMET
	weight = ITEM_WEIGHT_VOIDSUIT_HELMET
	camera_networks = list(NETWORK_MERCENARY)
	light_overlay = "helmet_light_green" //todo: species-specific light overlays

/obj/item/clothing/suit/space/void/merc
	icon_state = "rig-syndie"
	name = "blood-red voidsuit"
	desc = "An advanced suit that protects against injuries during special operations. Property of Gorlex Marauders."
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "syndie_voidsuit", SLOT_ID_LEFT_HAND = "syndie_voidsuit")
	encumbrance = ITEM_ENCUMBRANCE_VOIDSUIT
	weight = ITEM_WEIGHT_VOIDSUIT
	w_class = WEIGHT_CLASS_NORMAL
	armor_type = /datum/armor/merc/space
	siemens_coefficient = 0.6

/obj/item/clothing/head/helmet/space/void/merc/fire
	icon_state = "rig0-firebug"
	name = "soot-covered voidsuit helmet"
	desc = "A blackened helmet that has had many of its protective plates coated in or replaced with high-grade thermal insulation, to protect against incineration. Property of Gorlex Marauders."
	armor_type = /datum/armor/merc/space/ghostrider
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.7
	light_overlay = "helmet_light_fire"

/obj/item/clothing/suit/space/void/merc/fire
	icon_state = "rig-firebug"
	name = "soot-covered voidsuit"
	desc = "A blackened suit that has had many of its protective plates coated in or replaced with high-grade thermal insulation, to protect against incineration. Property of Gorlex Marauders."
	armor_type = /datum/armor/merc/space/ghostrider
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.7

//Soviet Void Suit
/obj/item/clothing/head/helmet/space/void/merc/soviet
	name = "ancient red helmet"
	desc = "An antique helmet which served as one of the inspirations for Gorlex's designs, a faded logo on the interior resembles a shattered sickle."
	icon_state = "void_soviet"
	armor_type = /datum/armor/merc/space/soviet
	light_overlay = "sr_overlay"

/obj/item/clothing/suit/space/void/merc/soviet
	name = "antique red voidsuit"
	desc = "A well maintained antique voidsuit, the scent of stale sweat and vodka is impossible to remove. Many features of this suit bear morphological similarities to more modern Gorlex voidsuits."
	icon_state = "void_soviet"
	armor_type = /datum/armor/merc/space/soviet

//'Werewolf' Void Suit
/obj/item/clothing/head/helmet/space/void/merc/wulf
	name = "antique werwulf helmet"
	desc = "An antique helmet designed by a long-forgotten corporation. Their dreams of conquest were no match against their competitors. Few of these helmets remain."
	icon_state = "void_wulf"
	armor_type = /datum/armor/merc/space/wulf
	light_overlay = "sr_overlay"

/obj/item/clothing/suit/space/void/merc/wulf
	name = "antique werwulf voidsuit"
	desc = "A well maintained antique, this armored voidsuit cuts an imposing silhouette. Many such suits used to be found in scrap heaps across the Frontier, although few now remain."
	icon_state = "void_wulf"
	armor_type = /datum/armor/merc/space/wulf

// Honk Op Rig
/obj/item/clothing/head/helmet/space/void/clownop
	name = "clown commando voidsuit helmet"
	desc = "An advanced helmet designed for work in special operations. An intricate bananium wafer in the shape of a banana bears the crest of Columbina."
	icon_state = "rig0-clownop"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "syndie_helm", SLOT_ID_LEFT_HAND = "syndie_helm")
	armor_type = /datum/armor/merc/space/clown
	siemens_coefficient = 0.6
	camera_networks = list(NETWORK_MERCENARY)
	light_overlay = "gk_overlay" //todo: species-specific light overlays

/obj/item/clothing/head/helmet/space/void/clownop/alt
	name = "sexy clown commando voidsuit helmet"
	icon_state = "rig0-clownop_alt"

/obj/item/clothing/suit/space/void/clownop
	icon_state = "rig-clownop"
	name = "clown commando voidsuit"
	desc = "An advanced suit that protects against injuries during special operations. An intricate bananium wafer in the shape of a banana bears the crest of Columbina."
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "syndie_voidsuit", SLOT_ID_LEFT_HAND = "syndie_voidsuit")
	w_class = WEIGHT_CLASS_NORMAL
	armor_type = /datum/armor/merc/space/clown
	siemens_coefficient = 0.6

//Four below avalible through cargo

/obj/item/clothing/head/helmet/space/void/odst
	name = "hephaestus icarus helmet"
	desc = "One of the few combat-grade helmets avalible in the frontier, and the poster-child of Hephaestus Industries."
	icon_state = "odst"
	armor_type = /datum/armor/station/secsuit
	siemens_coefficient = 0.6
	camera_networks = list(NETWORK_EXPLO_HELMETS)
	species_restricted = null

/obj/item/clothing/suit/space/void/odst
	icon_state = "odst"
	name = "hephaestus icarus suit"
	desc = "One of the few combat-grade suits avalible in the frontier, and the poster-child of Hephaestus Industries. Comes equipped with a wrist-bound oxygen timer."
	w_class = WEIGHT_CLASS_NORMAL
	armor_type = /datum/armor/station/secsuit
	siemens_coefficient = 0.6
	species_restricted = null
	helmet_type = /obj/item/clothing/head/helmet/space/void/odst

/obj/item/clothing/head/helmet/space/void/odst_med
	name = "hephaestus icarus medic helmet"
	desc = "Part of the Icarus Medic suit."
	icon_state = "odst_mil"
	armor_type = /datum/armor/exploration/space
	siemens_coefficient = 0.6
	camera_networks = list(NETWORK_EXPLO_HELMETS)
	species_restricted = null

/obj/item/clothing/suit/space/void/odst_med
	icon_state = "odst_corps"
	name = "hephaestus icarus medic suit"
	desc = "A standard Icarus line suit that has been repourposed to protect from heavier biohazards."
	w_class = WEIGHT_CLASS_NORMAL
	armor_type = /datum/armor/exploration/space
	siemens_coefficient = 0.6
	species_restricted = null
	helmet_type = /obj/item/clothing/head/helmet/space/void/odst_med

/obj/item/clothing/head/helmet/space/void/odst_eng
	name = "hephaestus icarus engineer helmet"
	desc = "Part of the Icarus Engineer suit."
	icon_state = "odst_orange"
	armor_type = /datum/armor/engineering/space
	siemens_coefficient = 0.6
	camera_networks = list(NETWORK_EXPLO_HELMETS)
	species_restricted = null

/obj/item/clothing/suit/space/void/odst_eng
	icon_state = "odst_orange"
	name = "hephaestus icarus engineer suit"
	desc = "Favoured suit of deep-space engineers, comfortable and comparable to suits avalible to Nanotrasen Engineers. Comes equipped with a wrist-bound oxygen timer."
	w_class = WEIGHT_CLASS_NORMAL
	armor_type = /datum/armor/engineering/space
	siemens_coefficient = 0.6
	species_restricted = null
	helmet_type = /obj/item/clothing/head/helmet/space/void/odst_eng

/obj/item/clothing/head/helmet/space/void/odst_exp
	name = "hephaestus icarus frontier helmet"
	desc = "Part of the Icarus Frontier suit."
	icon_state = "odst_purple"
	armor_type = /datum/armor/exploration/space
	siemens_coefficient = 0.6
	camera_networks = list(NETWORK_EXPLO_HELMETS)
	species_restricted = null

/obj/item/clothing/suit/space/void/odst_exp
	icon_state = "odst_purple"
	name = "hephaestus icarus frontier suit"
	desc = "Cheaper version of the main Icarus line, often marketed to Frontier settlements. Perfect for Expeditions."
	w_class = WEIGHT_CLASS_NORMAL
	armor_type = /datum/armor/exploration/space
	siemens_coefficient = 0.6
	species_restricted = null
	helmet_type = /obj/item/clothing/head/helmet/space/void/odst_exp

// Admin spawn only, Necropolis Industries event gear

/obj/item/clothing/head/helmet/space/void/odst_necro
	name = "necropolis operations helmet"
	desc = "Part of the Operations suit. Equipped with IFF sensors that send information directly to the user's implants."
	icon_state = "odst_red"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "syndie_helm", SLOT_ID_LEFT_HAND = "syndie_helm")
	armor_type = /datum/armor/merc/space
	siemens_coefficient = 0.6
	camera_networks = list(NETWORK_MERCENARY)
	species_restricted = null

/obj/item/clothing/suit/space/void/odst_necro
	icon_state = "odst_red"
	name = "necropolis operations suit"
	desc = "The main suit used by Necropolis Industries security division, a heavily modified Hephaestus Icarus suit emblazoned with the Necropolis logo on the left shoulder. Equipped with direct connections to the user's implants and prosthetics, making it function as a second skin."
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "syndie_voidsuit", SLOT_ID_LEFT_HAND = "syndie_voidsuit")
	w_class = WEIGHT_CLASS_NORMAL
	armor_type = /datum/armor/merc/space
	siemens_coefficient = 0.6
	species_restricted = null
	helmet_type = /obj/item/clothing/head/helmet/space/void/odst_necro

/obj/item/clothing/suit/space/void/odst_necromed
	icon_state = "odst_red_mil"
	name = "necropolis field medic suit"
	desc = "The main suit used by Necropolis Industries security division, a heavily modified Hephaestheus Icarus suit emblazoned with the Necropolis logo on the left shoulder and a blue cross on the right arm. Equipped with direct connections to the user's implants and prosthetics, making it function as a second skin."
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "syndie_voidsuit", SLOT_ID_LEFT_HAND = "syndie_voidsuit")
	w_class = WEIGHT_CLASS_NORMAL
	armor_type = /datum/armor/merc/space
	siemens_coefficient = 0.6
	species_restricted = null
