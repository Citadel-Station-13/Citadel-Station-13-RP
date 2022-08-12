/////////////////
/// Taj stuff ///
/////////////////
/datum/sprite_accessory/marking/taj
	icon = "icons/mob/sprite_accessories/markings/taj.dmi"

/datum/sprite_accessory/marking/taj/taj_paw_socks
	name = "Socks Coloration (Taj)"
	icon_state = "taj_pawsocks"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)
	species_allowed = list(SPECIES_TAJ)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/taj/paw_socks
	name = "Socks Coloration (Generic)"
	icon_state = "pawsocks"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)
	species_allowed = list(SPECIES_TAJ, SPECIES_UNATHI)

/datum/sprite_accessory/marking/taj/paw_socks_belly
	name = "Socks,Belly Coloration (Generic)"
	icon_state = "pawsocksbelly"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)
	species_allowed = list(SPECIES_TAJ, SPECIES_UNATHI)

/datum/sprite_accessory/marking/taj/belly_hands_feet
	name = "Hands,Feet,Belly Color (Minor)"
	icon_state = "bellyhandsfeetsmall"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)
	species_allowed = list(SPECIES_TAJ, SPECIES_UNATHI)

/datum/sprite_accessory/marking/taj/hands_feet_belly_full
	name = "Hands,Feet,Belly Color (Major)"
	icon_state = "bellyhandsfeet"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)
	species_allowed = list(SPECIES_TAJ, SPECIES_UNATHI)

/datum/sprite_accessory/marking/taj/hands_feet_belly_full_female
	name = "Hands,Feet,Belly Color (Major, Female)"
	icon_state = "bellyhandsfeet_female"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)
	species_allowed = list(SPECIES_TAJ)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/taj/patches
	name = "Color Patches"
	icon_state = "patches"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_GROIN)
	species_allowed = list(SPECIES_TAJ)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/taj/patchesface
	name = "Color Patches (Face)"
	icon_state = "patchesface"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_TAJ)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/taj/tiger_stripes
	name = "Tiger Stripes"
	icon_state = "tiger"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_TORSO,BP_GROIN)
	species_allowed = list(SPECIES_TAJ) //There's a tattoo for non-cats

//Taj specific stuff
/datum/sprite_accessory/marking/taj/taj_belly
	name = "Belly Fur (Taj)"
	icon_state = "taj_belly"
	body_parts = list(BP_TORSO)
	species_allowed = list(SPECIES_TAJ)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/taj/taj_bellyfull
	name = "Belly Fur Wide (Taj)"
	icon_state = "taj_bellyfull"
	body_parts = list(BP_TORSO)
	species_allowed = list(SPECIES_TAJ)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/taj/taj_earsout
	name = "Outer Ear (Taj)"
	icon_state = "taj_earsout"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_TAJ)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/taj/taj_earsin
	name = "Inner Ear (Taj)"
	icon_state = "taj_earsin"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_TAJ)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/taj/taj_nose
	name = "Nose Color (Taj)"
	icon_state = "taj_nose"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_TAJ)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/taj/taj_crest
	name = "Chest Fur Crest (Taj)"
	icon_state = "taj_crest"
	body_parts = list(BP_TORSO)
	species_allowed = list(SPECIES_TAJ)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/taj/taj_muzzle
	name = "Muzzle Color (Taj)"
	icon_state = "taj_muzzle"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_TAJ)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/taj/taj_face
	name = "Cheeks Color (Taj)"
	icon_state = "taj_face"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_TAJ)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/taj/taj_all
	name = "All Taj Head (Taj)"
	icon_state = "taj_all"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_TAJ)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/taj/taj_nose_alt
	name = "Nose Color, alt. (Taj)"
	icon_state = "taj_nosealt"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/taj/tigerface
	name = "Tiger Stripes (Head, Major)"
	icon_state = "tigerface"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_TAJ) //There's a tattoo for non-cats
