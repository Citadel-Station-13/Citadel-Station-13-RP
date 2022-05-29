/**
 * =----------------------------=
 * == Teshari Hair Definitions ==
 * =----------------------------=
 */

/datum/sprite_accessory/hair/teshari
	name = "Teshari Default"
	icon_state = "teshari_default"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/hair/teshari/altdefault
	name = "Teshari Alt. Default"
	icon_state = "teshari_ears"

/datum/sprite_accessory/hair/teshari/tight
	name = "Teshari Tight"
	icon_state = "teshari_tight"

/datum/sprite_accessory/hair/teshari/excited
	name = "Teshari Spiky"
	icon_state = "teshari_spiky"

/datum/sprite_accessory/hair/teshari/spike
	name = "Teshari Spike"
	icon_state = "teshari_spike"

/datum/sprite_accessory/hair/teshari/long
	name = "Teshari Overgrown"
	icon_state = "teshari_long"

/datum/sprite_accessory/hair/teshari/burst
	name = "Teshari Starburst"
	icon_state = "teshari_burst"

/datum/sprite_accessory/hair/teshari/shortburst
	name = "Teshari Short Starburst"
	icon_state = "teshari_burst_short"

/datum/sprite_accessory/hair/teshari/mohawk
	name = "Teshari Mohawk"
	icon_state = "teshari_mohawk"

/datum/sprite_accessory/hair/teshari/pointy
	name = "Teshari Pointy"
	icon_state = "teshari_pointy"

/datum/sprite_accessory/hair/teshari/upright
	name = "Teshari Upright"
	icon_state = "teshari_upright"

/datum/sprite_accessory/hair/teshari/mane
	name = "Teshari Mane"
	icon_state = "teshari_mane"

/datum/sprite_accessory/hair/teshari/droopy
	name = "Teshari Droopy"
	icon_state = "teshari_droopy"

/datum/sprite_accessory/hair/teshari/mushroom
	name = "Teshari Mushroom"
	icon_state = "teshari_mushroom"

/datum/sprite_accessory/hair/teshari/twies
	name = "Teshari Twies"
	icon_state = "teshari_twies"

/datum/sprite_accessory/hair/teshari/backstrafe
	name = "Teshari Backstrafe"
	icon_state = "teshari_backstrafe"

/datum/sprite_accessory/hair/teshari/longway
	name = "Teshari Long way"
	icon_state = "teshari_longway"

/datum/sprite_accessory/hair/teshari/tree
	name = "Teshari Tree"
	icon_state = "teshari_tree"

/datum/sprite_accessory/hair/teshari/fluffymohawk
	name = "Teshari Fluffy Mohawk"
	icon_state = "teshari_fluffymohawk"



/**
 * =-----------------------------------=
 * == Teshari Facial Hair Definitions ==
 * =-----------------------------------=
 */

/datum/sprite_accessory/facial_hair/teshari
	name = "Teshari Beard"
	icon_state = "teshari_chin"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	species_allowed = list(SPECIES_TESHARI)
	gender = NEUTER

/datum/sprite_accessory/facial_hair/teshari/scraggly
	name = "Teshari Scraggly"
	icon_state = "teshari_scraggly"

/datum/sprite_accessory/facial_hair/teshari/chops
	name = "Teshari Chops"
	icon_state = "teshari_gap"



/**
 * =-------------------------------=
 * == Teshari Marking Definitions ==
 * =-------------------------------=
 */

/datum/sprite_accessory/marking/teshari/heterochromia
	name = "Teshari Heterochromia"
	icon_state = "teshi_heterochromia"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/teshari/large_eyes
	name = "Teshari large eyes"
	icon_state = "teshlarge_eyes"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/teshari/coat
	name = "Teshari coat"
	icon_state = "tesh_coat"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_TORSO,BP_HEAD)

/datum/sprite_accessory/marking/teshari/pattern_male
	name = "Teshari male pattern"
	icon_state = "tesh-pattern-male"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_GROIN,BP_HEAD)

/datum/sprite_accessory/marking/teshari/pattern_female
	name = "Teshari female pattern"
	icon_state = "tesh-pattern-fem"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_R_LEG,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_GROIN,BP_HEAD)

/datum/sprite_accessory/marking/teshari/fluff
	name = "Teshari underfluff"
	icon_state = "teshi_fluff"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_GROIN,BP_TORSO,BP_HEAD)

/datum/sprite_accessory/marking/teshari/feathers
	name = "Teshari Feathers"
	icon_state = "tesh-feathers"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_HAND,BP_R_HAND)

/datum/sprite_accessory/marking/teshari/small_feathers
	name = "Teshari small wingfeathers"
	icon_state = "teshi_sf"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_HAND,BP_R_HAND,BP_TORSO)
