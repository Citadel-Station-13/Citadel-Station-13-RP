/*
///////////////////////////////////
/  =---------------------------=  /
/  == Facial Hair Definitions ==  /
/  =---------------------------=  /
///////////////////////////////////
*/

/datum/sprite_accessory/facial_hair
	icon = 'icons/mob/human_face_or_vr.dmi'
	color_blend_mode = ICON_MULTIPLY
	apply_restrictions = FALSE

/datum/sprite_accessory/facial_hairshaved
		name = "Shaved"
		icon_state = "bald"
		gender = NEUTER

/datum/sprite_accessory/facial_hairneck_fluff
		name = "Neck Fluff"
		icon = 'icons/mob/human_face_or_vr.dmi'
		icon_state = "facial_neckfluff"
		gender = NEUTER

/datum/sprite_accessory/facial_hairvulp_none
		name = "None"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "none"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)
		apply_restrictions = TRUE
		gender = NEUTER

/datum/sprite_accessory/facial_hairvulp_blaze
		name = "Blaze"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "vulp_facial_blaze"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)
		apply_restrictions = TRUE
		gender = NEUTER

/datum/sprite_accessory/facial_hairvulp_vulpine
		name = "Vulpine"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "vulp_facial_vulpine"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)
		apply_restrictions = TRUE
		gender = NEUTER

/datum/sprite_accessory/facial_hairvulp_earfluff
		name = "Earfluff"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "vulp_facial_earfluff"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)
		apply_restrictions = TRUE
		gender = NEUTER

/datum/sprite_accessory/facial_hairvulp_mask
		name = "Mask"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "vulp_facial_mask"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)
		apply_restrictions = TRUE
		gender = NEUTER

/datum/sprite_accessory/facial_hairvulp_patch
		name = "Patch"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "vulp_facial_patch"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)
		apply_restrictions = TRUE
		gender = NEUTER

/datum/sprite_accessory/facial_hairvulp_ruff
		name = "Ruff"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "vulp_facial_ruff"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)
		apply_restrictions = TRUE
		gender = NEUTER

/datum/sprite_accessory/facial_hairvulp_kita
		name = "Kita"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "vulp_facial_kita"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)
		apply_restrictions = TRUE
		gender = NEUTER

/datum/sprite_accessory/facial_hairvulp_swift
		name = "Swift"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "vulp_facial_swift"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)
		apply_restrictions = TRUE
		gender = NEUTER

/datum/sprite_accessory/facial_hairwatson
		name = "Watson Mustache"
		icon_state = "facial_watson"

/datum/sprite_accessory/facial_hairhogan
		name = "Hulk Hogan Mustache"
		icon_state = "facial_hogan" //-Neek

/datum/sprite_accessory/facial_hairvandyke
		name = "Van Dyke Mustache"
		icon_state = "facial_vandyke"

/datum/sprite_accessory/facial_hairchaplin
		name = "Square Mustache"
		icon_state = "facial_chaplin"

/datum/sprite_accessory/facial_hairselleck
		name = "Selleck Mustache"
		icon_state = "facial_selleck"

/datum/sprite_accessory/facial_hairneckbeard
		name = "Neckbeard"
		icon_state = "facial_neckbeard"

/datum/sprite_accessory/facial_hairfullbeard
		name = "Full Beard"
		icon_state = "facial_fullbeard"

/datum/sprite_accessory/facial_hairlongbeard
		name = "Long Beard"
		icon_state = "facial_longbeard"

/datum/sprite_accessory/facial_hairvlongbeard
		name = "Very Long Beard"
		icon_state = "facial_wise"

/datum/sprite_accessory/facial_hairelvis
		name = "Elvis Sideburns"
		icon_state = "facial_elvis"
		//Fuck it, everyone is Elvis. species_allowed = list(SPECIES_HUMAN,SPECIES_PROMETHEAN,SPECIES_HUMAN_VATBORN,SPECIES_UNATHI)

/datum/sprite_accessory/facial_hairabe
		name = "Abraham Lincoln Beard"
		icon_state = "facial_abe"

/datum/sprite_accessory/facial_hairchinstrap
		name = "Chinstrap"
		icon_state = "facial_chin"

/datum/sprite_accessory/facial_hairhip
		name = "Hipster Beard"
		icon_state = "facial_hip"

/datum/sprite_accessory/facial_hairgt
		name = "Goatee"
		icon_state = "facial_gt"

/datum/sprite_accessory/facial_hairjensen
		name = "Adam Jensen Beard"
		icon_state = "facial_jensen"

/datum/sprite_accessory/facial_hairvolaju
		name = "Volaju"
		icon_state = "facial_volaju"

/datum/sprite_accessory/facial_hairdwarf
		name = "Dwarf Beard"
		icon_state = "facial_dwarf"

/datum/sprite_accessory/facial_hairthreeOclock
		name = "3 O'clock Shadow"
		icon_state = "facial_3oclock"

/datum/sprite_accessory/facial_hairthreeOclockstache
		name = "3 O'clock Shadow and Moustache"
		icon_state = "facial_3oclockmoustache"

/datum/sprite_accessory/facial_hairfiveOclock
		name = "5 O'clock Shadow"
		icon_state = "facial_5oclock"

/datum/sprite_accessory/facial_hairfiveOclockstache
		name = "5 O'clock Shadow and Moustache"
		icon_state = "facial_5oclockmoustache"

/datum/sprite_accessory/facial_hairsevenOclock
		name = "7 O'clock Shadow"
		icon_state = "facial_7oclock"

/datum/sprite_accessory/facial_hairsevenOclockstache
		name = "7 O'clock Shadow and Moustache"
		icon_state = "facial_7oclockmoustache"

/datum/sprite_accessory/facial_hairmutton
		name = "Mutton Chops"
		icon_state = "facial_mutton"

/datum/sprite_accessory/facial_hairmuttonstache
		name = "Mutton Chops and Moustache"
		icon_state = "facial_muttonmus"

/datum/sprite_accessory/facial_hairwalrus
		name = "Walrus Moustache"
		icon_state = "facial_walrus"

/datum/sprite_accessory/facial_haircroppedbeard
		name = "Full Cropped Beard"
		icon_state = "facial_croppedfullbeard"

/datum/sprite_accessory/facial_hairchinless
		name = "Chinless Beard"
		icon_state = "facial_chinlessbeard"

/datum/sprite_accessory/facial_hairtribeard
		name = "Tribeard"
		icon_state = "facial_tribeard"

/datum/sprite_accessory/facial_hairmoonshiner
		name = "Moonshiner"
		icon_state = "facial_moonshiner"

/datum/sprite_accessory/facial_hairmartial
		name = "Martial Artist"
		icon_state = "facial_martialartist"
