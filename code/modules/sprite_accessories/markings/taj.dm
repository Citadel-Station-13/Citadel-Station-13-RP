/datum/sprite_accessory/marking/taj
	abstract_type = /datum/sprite_accessory/marking/taj
	icon = "icons/mob/sprite_accessories/markings/taj.dmi"

/datum/sprite_accessory/marking/taj/taj_paw_socks
	name = "Socks Coloration (Taj)"
	id = "marking_tajaran_pawsocks"
	icon_state = "taj_pawsocks"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)
	species_allowed = list(SPECIES_TAJ)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/taj/paw_socks
	name = "Socks Coloration (Generic)"
	id = "marking_pawsocks"
	icon_state = "pawsocks"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)
	species_allowed = list(SPECIES_TAJ, SPECIES_UNATHI)

/datum/sprite_accessory/marking/taj/paw_socks_belly
	name = "Socks,Belly Coloration (Generic)"
	id = "marking_pawsocks_belly"
	icon_state = "pawsocksbelly"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)
	species_allowed = list(SPECIES_TAJ, SPECIES_UNATHI)

/datum/sprite_accessory/marking/taj/belly_hands_feet
	name = "Hands,Feet,Belly Color (Minor)"
	id = "marking_tajaran_bhf_min"
	icon_state = "bellyhandsfeetsmall"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)
	species_allowed = list(SPECIES_TAJ, SPECIES_UNATHI)

/datum/sprite_accessory/marking/taj/hands_feet_belly_full
	name = "Hands,Feet,Belly Color (Major)"
	id = "marking_tajaran_bhf_maj"
	icon_state = "bellyhandsfeet"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)
	species_allowed = list(SPECIES_TAJ, SPECIES_UNATHI)

/datum/sprite_accessory/marking/taj/hands_feet_belly_full_female
	name = "Hands,Feet,Belly Color (Major, Female)"
	id = "marking_tajaran_bhf_majf"
	icon_state = "bellyhandsfeet_female"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)
	species_allowed = list(SPECIES_TAJ)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/taj/patches
	name = "Color Patches"
	id = "marking_tajaran_patches"
	icon_state = "patches"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_GROIN)
	species_allowed = list(SPECIES_TAJ)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/taj/patchesface
	name = "Color Patches (Face)"
	id = "marking_tajaran_patches_face"
	icon_state = "patchesface"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_TAJ)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/taj/tiger_stripes
	name = "Tiger Stripes"
	id = "marking_tajaran_tiger"
	icon_state = "tiger"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_TORSO,BP_GROIN)
	species_allowed = list(SPECIES_TAJ) //There's a tattoo for non-cats

//Taj specific stuff
/datum/sprite_accessory/marking/taj/taj_belly
	name = "Belly Fur (Taj)"
	id = "marking_tajaran_belly"
	icon_state = "taj_belly"
	body_parts = list(BP_TORSO)
	species_allowed = list(SPECIES_TAJ)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/taj/taj_bellyfull
	name = "Belly Fur Wide (Taj)"
	id = "marking_tajaran_belly_wide"
	icon_state = "taj_bellyfull"
	body_parts = list(BP_TORSO)
	species_allowed = list(SPECIES_TAJ)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/taj/taj_earsout
	name = "Outer Ear (Taj)"
	id = "marking_tajaran_ears_out"
	icon_state = "taj_earsout"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_TAJ)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/taj/taj_earsin
	name = "Inner Ear (Taj)"
	id = "marking_tajaran_ears_in"
	icon_state = "taj_earsin"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_TAJ)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/taj/taj_nose
	name = "Nose Color (Taj)"
	id = "marking_tajaran_nose"
	icon_state = "taj_nose"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_TAJ)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/taj/taj_crest
	name = "Chest Fur Crest (Taj)"
	id = "marking_tajaran_crest"
	icon_state = "taj_crest"
	body_parts = list(BP_TORSO)
	species_allowed = list(SPECIES_TAJ)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/taj/taj_muzzle
	name = "Muzzle Color (Taj)"
	id = "marking_tajaran_muzzle"
	icon_state = "taj_muzzle"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_TAJ)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/taj/taj_face
	name = "Cheeks Color (Taj)"
	id = "marking_tajaran_cheeks"
	icon_state = "taj_face"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_TAJ)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/taj/taj_all
	name = "All Taj Head (Taj)"
	id = "marking_tajaran_head_all"
	icon_state = "taj_all"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_TAJ)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/taj/taj_nose_alt
	name = "Nose Color, alt. (Taj)"
	id = "marking_tajaran_nose_alt"
	icon_state = "taj_nosealt"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/taj/tigerface
	name = "Tiger Stripes (Head, Major)"
	id = "marking_tajaran_head_tiger"
	icon_state = "tigerface"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_TAJ) //There's a tattoo for non-cats
