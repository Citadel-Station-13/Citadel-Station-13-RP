/**
 * =------------------------------=
 * == Vulpkanin Hair Definitions ==
 * =------------------------------=
 */

/datum/sprite_accessory/hair/vulp
	name = "Kajam"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	icon_state = "kajam"
	species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
	gender = NEUTER

/datum/sprite_accessory/hair/vulp/keid
	name = "Keid"
	icon_state = "keid"

/datum/sprite_accessory/hair/vulp/adhara
	name = "Adhara"
	icon_state = "adhara"

/datum/sprite_accessory/hair/vulp/kleeia
	name = "Kleeia"
	icon_state = "kleeia"

/datum/sprite_accessory/hair/vulp/mizar
	name = "Mizar"
	icon_state = "mizar"

/datum/sprite_accessory/hair/vulp/apollo
	name = "Apollo"
	icon_state = "apollo"

/datum/sprite_accessory/hair/vulp/belle
	name = "Belle"
	icon_state = "belle"

/datum/sprite_accessory/hair/vulp/bun
	name = "Bun"
	icon_state = "bun"

/datum/sprite_accessory/hair/vulp/jagged
	name = "Jagged"
	icon_state = "jagged"

/datum/sprite_accessory/hair/vulp/curl
	name = "Curl"
	icon_state = "curl"

/datum/sprite_accessory/hair/vulp/hawk
	name = "Hawk"
	icon_state = "hawk"

/datum/sprite_accessory/hair/vulp/anita
	name = "Anita"
	icon_state = "anita"

/datum/sprite_accessory/hair/vulp/short
	name = "Short"
	icon_state = "short"

/datum/sprite_accessory/hair/vulp/spike
	name = "Spike"
	icon_state = "spike"




/**
 * =---------------------------------=
 * == Vulpkanin Marking Definitions ==
 * =---------------------------------=
 */

/datum/sprite_accessory/marking/vulp
	name = "belly fur (Vulp)"
	icon_state = "vulp_belly"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO,BP_GROIN)
	species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)

/datum/sprite_accessory/marking/vulp/fullbelly
	name = "full belly fur (Vulp)"
	icon_state = "vulp_fullbelly"
	body_parts = list(BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/vulp/crest
	name = "belly crest (Vulp)"
	icon_state = "vulp_crest"
	body_parts = list(BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/vulp/nose
	name = "nose (Vulp)"
	icon_state = "vulp_nose"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vulp/short_nose
	name = "nose, short (Vulp)"
	icon_state = "vulp_short_nose"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vulp/snoutstripe
	name = "snout stripe (Vulp)"
	icon_state = "snoutstripe"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vulp/face
	name = "face (Vulp)"
	icon_state = "vulp_face"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vulp/facealt
	name = "face, alt. (Vulp)"
	icon_state = "vulp_facealt"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vulp/earsface
	name = "ears and face (Vulp)"
	icon_state = "vulp_earsface"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vulp/all
	name = "all head highlights (Vulp)"
	icon_state = "vulp_all"
	body_parts = list(BP_HEAD)
