/*
///////////////////////////////////
/  =---------------------------=  /
/  == Facial Hair Definitions ==  /
/  =---------------------------=  /
///////////////////////////////////
*/

/datum/sprite_accessory/facial_hair
	abstract_type = /datum/sprite_accessory/facial_hair
	icon = 'icons/mob/human_face_or_vr.dmi'
	legacy_use_additive_color_matrix = FALSE
	apply_restrictions = FALSE

	/// without this, we don't put the _s at the end of the state
	/// added to allow legacy hairs to work.
	var/append_s_at_end = FALSE

/datum/sprite_accessory/facial_hair/New()
	..()
	if(append_s_at_end)
		icon_state = "[icon_state]_s"

/datum/sprite_accessory/facial_hair/legacy
	abstract_type = /datum/sprite_accessory/facial_hair/legacy
	append_s_at_end = TRUE

/datum/sprite_accessory/facial_hair/legacy/shaved
	name = "Shaved"
	id = "fhair_shaved"
	icon_state = "bald"
	random_generation_gender = null

/datum/sprite_accessory/facial_hair/legacy/neck_fluff
	name = "Neck Fluff"
	id = "fhair_neckfluff"
	icon = 'icons/mob/human_face_or_vr.dmi'
	icon_state = "facial_neckfluff"
	random_generation_gender = null

/datum/sprite_accessory/facial_hair/legacy/neck_fluff/cryptid
	name = "Neck Fluff (Cryptid)"
	id = "fhair_neckfluff_cryptid"
	icon_state = "facial_neckfluff_cryptid"

/datum/sprite_accessory/facial_hair/legacy/watson
	name = "Watson Mustache"
	id = "fhair_watson"
	icon_state = "facial_watson"

/datum/sprite_accessory/facial_hair/legacy/hogan
	name = "Hulk Hogan Mustache"
	id = "fhair_hogan"
	icon_state = "facial_hogan" //-Neek

/datum/sprite_accessory/facial_hair/legacy/vandyke
	name = "Van Dyke Mustache"
	id = "fhair_vandyke"
	icon_state = "facial_vandyke"

/datum/sprite_accessory/facial_hair/legacy/chaplin
	name = "Square Mustache"
	id = "fhair_square"
	icon_state = "facial_chaplin"

/datum/sprite_accessory/facial_hair/legacy/selleck
	name = "Selleck Mustache"
	id = "fhair_selleck"
	icon_state = "facial_selleck"

/datum/sprite_accessory/facial_hair/legacy/neckbeard
	name = "Neckbeard"
	id = "fhair_neck"
	icon_state = "facial_neckbeard"

/datum/sprite_accessory/facial_hair/legacy/fullbeard
	name = "Full Beard"
	id = "fhair_full"
	icon_state = "facial_fullbeard"

/datum/sprite_accessory/facial_hair/legacy/longbeard
	name = "Long Beard"
	id = "fhair_long"
	icon_state = "facial_longbeard"

/datum/sprite_accessory/facial_hair/legacy/vlongbeard
	name = "Very Long Beard"
	id = "fhair_verylong"
	icon_state = "facial_wise"

/datum/sprite_accessory/facial_hair/legacy/elvis
	name = "Elvis Sideburns"
	id = "fhair_elvis"
	icon_state = "facial_elvis"
	//Fuck it, everyone is Elvis. species_allowed = list(SPECIES_HUMAN,SPECIES_PROMETHEAN,SPECIES_HUMAN_VATBORN,SPECIES_UNATHI)

/datum/sprite_accessory/facial_hair/legacy/abe
	name = "Abraham Lincoln Beard"
	id = "fhair_lincoln"
	icon_state = "facial_abe"

/datum/sprite_accessory/facial_hair/legacy/chinstrap
	name = "Chinstrap"
	id = "fhair_chinstrap"
	icon_state = "facial_chin"

/datum/sprite_accessory/facial_hair/legacy/hip
	name = "Hipster Beard"
	id = "fhair_hipster"
	icon_state = "facial_hip"

/datum/sprite_accessory/facial_hair/legacy/gt
	name = "Goatee"
	id = "fhair_goatee"
	icon_state = "facial_gt"

/datum/sprite_accessory/facial_hair/legacy/jensen
	name = "Adam Jensen Beard"
	id = "fhair_jensen"
	icon_state = "facial_jensen"

/datum/sprite_accessory/facial_hair/legacy/volaju
	name = "Volaju"
	id = "fhair_volaju"
	icon_state = "facial_volaju"

/datum/sprite_accessory/facial_hair/legacy/dwarf
	name = "Dwarf Beard"
	id = "fhair_dwarf"
	icon_state = "facial_dwarf"

/datum/sprite_accessory/facial_hair/legacy/threeOclock
	name = "3 O'clock Shadow"
	id = "fhair_3oclock"
	icon_state = "facial_3oclock"

/datum/sprite_accessory/facial_hair/legacy/threeOclockstache
	name = "3 O'clock Shadow and Moustache"
	id = "fhair_3oclock_mous"
	icon_state = "facial_3oclockmoustache"

/datum/sprite_accessory/facial_hair/legacy/fiveOclock
	name = "5 O'clock Shadow"
	id = "fhair_5oclock"
	icon_state = "facial_5oclock"

/datum/sprite_accessory/facial_hair/legacy/fiveOclockstache
	name = "5 O'clock Shadow and Moustache"
	id = "fhair_5oclock_mous"
	icon_state = "facial_5oclockmoustache"

/datum/sprite_accessory/facial_hair/legacy/sevenOclock
	name = "7 O'clock Shadow"
	id = "fhair_7oclock"
	icon_state = "facial_7oclock"

/datum/sprite_accessory/facial_hair/legacy/sevenOclockstache
	name = "7 O'clock Shadow and Moustache"
	id = "fhair_7oclock_mous"
	icon_state = "facial_7oclockmoustache"

/datum/sprite_accessory/facial_hair/legacy/mutton
	name = "Mutton Chops"
	id = "fhair_mutton"
	icon_state = "facial_mutton"

/datum/sprite_accessory/facial_hair/legacy/muttonstache
	name = "Mutton Chops and Moustache"
	id = "fhair_mutton_mous"
	icon_state = "facial_muttonmus"

/datum/sprite_accessory/facial_hair/legacy/walrus
	name = "Walrus Moustache"
	id = "fhair_walrus"
	icon_state = "facial_walrus"

/datum/sprite_accessory/facial_hair/legacy/croppedbeard
	name = "Full Cropped Beard"
	id = "fhair_fullcrop"
	icon_state = "facial_croppedfullbeard"

/datum/sprite_accessory/facial_hair/legacy/chinless
	name = "Chinless Beard"
	id = "fhair_chinless"
	icon_state = "facial_chinlessbeard"

/datum/sprite_accessory/facial_hair/legacy/tribeard
	name = "Tribeard"
	id = "fhair_tribeard"
	icon_state = "facial_tribeard"

/datum/sprite_accessory/facial_hair/legacy/moonshiner
	name = "Moonshiner"
	id = "fhair_moonshiner"
	icon_state = "facial_moonshiner"

/datum/sprite_accessory/facial_hair/legacy/martial
	name = "Martial Artist"
	id = "fhair_martial"
	icon_state = "facial_martialartist"
