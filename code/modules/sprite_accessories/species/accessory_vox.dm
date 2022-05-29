/**
 * =------------------------=
 * == Vox Hair Definitions ==
 * =------------------------=
 */

/datum/sprite_accessory/hair/vox
	name = "Long Vox braid"
	icon_state = "vox_longbraid"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	species_allowed = list(SPECIES_VOX)

/datum/sprite_accessory/hair/vox/quills_bald
	name = "Vox Bald"
	icon_state = "vox_bald"

/datum/sprite_accessory/hair/vox/braid_short
	name = "Short Vox Braid"
	icon_state = "vox_shortbraid"

/datum/sprite_accessory/hair/vox/quills_short
	name = "Short Vox Quills"
	icon_state = "vox_shortquills"

/datum/sprite_accessory/hair/vox/quills_kingly
	name = "Kingly Vox Quills"
	icon_state = "vox_kingly"

/datum/sprite_accessory/hair/vox/quills_mohawk
	name = "Quill Mohawk"
	icon_state = "vox_mohawk"

/datum/sprite_accessory/hair/vox/quills_afro
	name = "Vox Afro"
	icon_state = "vox_afro"

/datum/sprite_accessory/hair/vox/quills_mohawk
	name = "Vox Mohawk"
	icon_state = "vox_mohawk"

/datum/sprite_accessory/hair/vox/quills_yasu
	name = "Vox Yasuhiro"
	icon_state = "vox_yasu"

/datum/sprite_accessory/hair/vox/quills_horns
	name = "Vox Quorns"
	icon_state = "vox_horns"

/datum/sprite_accessory/hair/vox/quills_nights
	name = "Vox Nights"
	icon_state = "vox_nights"

/datum/sprite_accessory/hair/vox/quills_surf
	name = "Vox Surf"
	icon_state = "vox_surf"

/datum/sprite_accessory/hair/vox/quills_cropped
	name = "Vox Cropped"
	icon_state = "vox_cropped"

/datum/sprite_accessory/hair/vox/quills_ruffhawk
	name = "Vox Ruffhawk"
	icon_state = "vox_ruff_hawk"

/datum/sprite_accessory/hair/vox/quills_rows
	name = "Vox Rows"
	icon_state = "vox_rows"

/datum/sprite_accessory/hair/vox/quills_mange
	name = "Vox Mange"
	icon_state = "vox_mange"

/datum/sprite_accessory/hair/vox/quills_pony
	name = "Vox Pony"
	icon_state = "vox_pony"



/**
 * =-------------------------------=
 * == Vox Facial Hair Definitions ==
 * =-------------------------------=
 */

/datum/sprite_accessory/facial_hair/vox
	name = "Vox Shaved"
	icon_state = "vox_bald"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	species_allowed = list(SPECIES_VOX)

/datum/sprite_accessory/facial_hair/vox/neck
	name = "Neck Quills"
	icon_state = "vox_neck"

/datum/sprite_accessory/facial_hair/vox/beard
	name = "Quill Beard"
	icon_state = "vox_beard"

/datum/sprite_accessory/facial_hair/vox/ruff_beard
	name = "Ruff Beard"
	icon_state = "vox_ruff_beard"

/datum/sprite_accessory/facial_hair/vox/fu
	name = "Quill Fu"
	icon_state = "vox_fu"

/datum/sprite_accessory/facial_hair/vox/colonel
	name = "Vox Colonel"
	icon_state = "vox_colonel"



/**
 * =---------------------------=
 * == Vox Marking Definitions ==
 * =---------------------------=
 */

/datum/sprite_accessory/marking/vox
	name = "Vox Two Tone"
	icon_state = "vox_two_tone"
	body_parts = list(BP_HEAD,BP_L_HAND,BP_R_HAND,BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM)
	species_allowed = list(SPECIES_VOX)

/datum/sprite_accessory/marking/vox/alt
	name = "Vox Alternate"
	icon_state = "bay_vox"
	body_parts = list (BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_GROIN,BP_HEAD)

/datum/sprite_accessory/marking/vox/alt_eyes
	name = "Alternate Vox Eyes"
	icon_state = "bay_vox_eyes"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vox/scales
	name = "Vox Scales"
	icon_state = "Voxscales"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_HEAD)

/datum/sprite_accessory/marking/vox/claws
	name = "Vox Claws"
	icon_state = "Voxclaws"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_HAND,BP_R_HAND)

/datum/sprite_accessory/marking/vox/beak
	name = "Vox Beak"
	icon_state = "Voxscales"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)
