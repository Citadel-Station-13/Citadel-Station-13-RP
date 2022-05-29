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
	species_allowed = list() //This lets all races use the facial hair styles.

	var/icon_add

/datum/sprite_accessory/shaved
	name = "Shaved"
	icon_state = "bald"
	gender = NEUTER

/datum/sprite_accessory/neck_fluff
	name = "Neck Fluff"
	icon = 'icons/mob/human_face_or_vr.dmi'
	icon_state = "facial_neckfluff"
	gender = NEUTER

/datum/sprite_accessory/vulp_none
	name = "None"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_state = "none"
	species_allowed = list(SPECIES_VULPKANIN)
	gender = NEUTER

/datum/sprite_accessory/vulp_blaze
	name = "Blaze"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_state = "vulp_facial_blaze"
	species_allowed = list(SPECIES_VULPKANIN)
	gender = NEUTER

/datum/sprite_accessory/vulp_vulpine
	name = "Vulpine"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_state = "vulp_facial_vulpine"
	species_allowed = list(SPECIES_VULPKANIN)
	gender = NEUTER

/datum/sprite_accessory/vulp_earfluff
	name = "Earfluff"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_state = "vulp_facial_earfluff"
	species_allowed = list(SPECIES_VULPKANIN)
	gender = NEUTER

/datum/sprite_accessory/vulp_mask
	name = "Mask"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_state = "vulp_facial_mask"
	species_allowed = list(SPECIES_VULPKANIN)
	gender = NEUTER

/datum/sprite_accessory/vulp_patch
	name = "Patch"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_state = "vulp_facial_patch"
	species_allowed = list(SPECIES_VULPKANIN)
	gender = NEUTER

/datum/sprite_accessory/vulp_ruff
	name = "Ruff"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_state = "vulp_facial_ruff"
	species_allowed = list(SPECIES_VULPKANIN)
	gender = NEUTER

/datum/sprite_accessory/vulp_kita
	name = "Kita"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_state = "vulp_facial_kita"
	species_allowed = list(SPECIES_VULPKANIN)
	gender = NEUTER

/datum/sprite_accessory/vulp_swift
	name = "Swift"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_state = "vulp_facial_swift"
	species_allowed = list(SPECIES_VULPKANIN)
	gender = NEUTER

/datum/sprite_accessory/watson
	name = "Watson Mustache"
	icon_state = "facial_watson"

/datum/sprite_accessory/hogan
	name = "Hulk Hogan Mustache"
	icon_state = "facial_hogan"

/datum/sprite_accessory/vandyke
	name = "Van Dyke Mustache"
	icon_state = "facial_vandyke"

/datum/sprite_accessory/chaplin
	name = "Square Mustache"
	icon_state = "facial_chaplin"

/datum/sprite_accessory/selleck
	name = "Selleck Mustache"
	icon_state = "facial_selleck"

/datum/sprite_accessory/neckbeard
	name = "Neckbeard"
	icon_state = "facial_neckbeard"

/datum/sprite_accessory/fullbeard
	name = "Full Beard"
	icon_state = "facial_fullbeard"

/datum/sprite_accessory/longbeard
	name = "Long Beard"
	icon_state = "facial_longbeard"

/datum/sprite_accessory/vlongbeard
	name = "Very Long Beard"
	icon_state = "facial_wise"

/datum/sprite_accessory/elvis
	name = "Elvis Sideburns"
	icon_state = "facial_elvis"

/datum/sprite_accessory/abe
	name = "Abraham Lincoln Beard"
	icon_state = "facial_abe"

/datum/sprite_accessory/chinstrap
	name = "Chinstrap"
	icon_state = "facial_chin"

/datum/sprite_accessory/hip
	name = "Hipster Beard"
	icon_state = "facial_hip"

/datum/sprite_accessory/gt
	name = "Goatee"
	icon_state = "facial_gt"

/datum/sprite_accessory/jensen
	name = "Adam Jensen Beard"
	icon_state = "facial_jensen"

/datum/sprite_accessory/volaju
	name = "Volaju"
	icon_state = "facial_volaju"

/datum/sprite_accessory/dwarf
	name = "Dwarf Beard"
	icon_state = "facial_dwarf"

/datum/sprite_accessory/threeOclock
	name = "3 O'clock Shadow"
	icon_state = "facial_3oclock"

/datum/sprite_accessory/threeOclockstache
	name = "3 O'clock Shadow and Moustache"
	icon_state = "facial_3oclockmoustache"

/datum/sprite_accessory/fiveOclock
	name = "5 O'clock Shadow"
	icon_state = "facial_5oclock"

/datum/sprite_accessory/fiveOclockstache
	name = "5 O'clock Shadow and Moustache"
	icon_state = "facial_5oclockmoustache"

/datum/sprite_accessory/sevenOclock
	name = "7 O'clock Shadow"
	icon_state = "facial_7oclock"

/datum/sprite_accessory/sevenOclockstache
	name = "7 O'clock Shadow and Moustache"
	icon_state = "facial_7oclockmoustache"

/datum/sprite_accessory/mutton
	name = "Mutton Chops"
	icon_state = "facial_mutton"

/datum/sprite_accessory/muttonstache
	name = "Mutton Chops and Moustache"
	icon_state = "facial_muttonmus"

/datum/sprite_accessory/walrus
	name = "Walrus Moustache"
	icon_state = "facial_walrus"

/datum/sprite_accessory/croppedbeard
	name = "Full Cropped Beard"
	icon_state = "facial_croppedfullbeard"

/datum/sprite_accessory/chinless
	name = "Chinless Beard"
	icon_state = "facial_chinlessbeard"

/datum/sprite_accessory/tribeard
	name = "Tribeard"
	icon_state = "facial_tribeard"

/datum/sprite_accessory/moonshiner
	name = "Moonshiner"
	icon_state = "facial_moonshiner"

/datum/sprite_accessory/martial
	name = "Martial Artist"
	icon_state = "facial_martialartist"
