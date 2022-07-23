/*
////////////////////////////
/  =--------------------=  /
/  ==  Body Markings   ==  /
/  =--------------------=  /
////////////////////////////
*/
//Moved here from sprite_accessories.dm in the same folder

/datum/sprite_accessory/marking
	icon = "icons/mob/sprite_accessories/markings.dmi"
	do_colouration = 1 //Almost all of them have it, COLOR_ADD
	color_blend_mode = ICON_ADD

	///Empty list is unrestricted. Should only restrict the ones that make NO SENSE on other species,
	//like Tajaran inner-ear coloring overlay stuff.
	species_allowed = list()

	var/body_parts = list() //A list of bodyparts this covers, in organ_tag defines
	//Reminder: BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_GROIN,BP_HEAD


//////////////
/// Tatoos ///
//////////////
/datum/sprite_accessory/marking/tatoo
	icon = "icons/mob/sprite_accessories/markings/tatoos.dmi"

/datum/sprite_accessory/marking/tatoo/tat_rheart
	name = "Tattoo (Heart, R. Arm)"
	icon_state = "tat_rheart"
	body_parts = list(BP_R_ARM)

/datum/sprite_accessory/marking/tatoo/tat_lheart
	name = "Tattoo (Heart, L. Arm)"
	icon_state = "tat_lheart"
	body_parts = list(BP_L_ARM)

/datum/sprite_accessory/marking/tatoo/tat_hive
	name = "Tattoo (Hive, Back)"
	icon_state = "tat_hive"
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/tatoo/tat_nightling
	name = "Tattoo (Nightling, Back)"
	icon_state = "tat_nightling"
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/tatoo/tat_campbell
	name = "Tattoo (Campbell, R.Arm)"
	icon_state = "tat_campbell"
	body_parts = list(BP_R_ARM)

/datum/sprite_accessory/marking/tatoo/tat_campbell/left
	name = "Tattoo (Campbell, L.Arm)"
	body_parts = list(BP_L_ARM)

/datum/sprite_accessory/marking/tatoo/tat_campbell/rightleg
		name = "Tattoo (Campbell, R.Leg)"
		body_parts = list(BP_R_LEG)

/datum/sprite_accessory/marking/tatoo/tat_campbell/leftleg
		name = "Tattoo (Campbell, L.Leg)"
		body_parts = list (BP_L_LEG)

/datum/sprite_accessory/marking/tatoo/tat_silverburgh
	name = "Tattoo (Silverburgh, R.Leg)"
	icon_state = "tat_silverburgh"
	body_parts = list (BP_R_LEG)

/datum/sprite_accessory/marking/tatoo/tat_silverburgh/left
		name = "Tattoo (Silverburgh, L.Leg)"
		icon_state = "tat_silverburgh"
		body_parts = list (BP_L_LEG)

/datum/sprite_accessory/marking/tatoo/tat_tiger
	name = "Tattoo (Tiger Stripes, Body)"
	icon_state = "tat_tiger"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/tatoo/tat_inmon1
	name = "Tattoo (Inmon, Variant 1)"
	icon_state = "tat_inmon1"
	body_parts = list(BP_GROIN)

/datum/sprite_accessory/marking/tatoo/tat_inmon2
	name = "Tattoo (Inmon, Variant 2)"
	icon_state = "tat_inmon2"
	body_parts = list(BP_GROIN)

/datum/sprite_accessory/marking/tatoo/tat_inmon3
	name = "Tattoo (Inmon, Variant 3)"
	icon_state = "tat_inmon3"
	body_parts = list(BP_GROIN)


////////////////
/// Tanlines ///
////////////////
/datum/sprite_accessory/marking/tanline
	icon = "icons/mob/sprite_accessories/markings/tanlines.dmi"

/datum/sprite_accessory/marking/tanline/tanlines
	name = "Tan Lines (One Piece, F)"
	icon_state = "tan_op"
	body_parts = list(BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/tanline/tanlines_m
	name = "Tan Lines (One Piece, M)"
	icon_state = "tan_mop"
	body_parts = list(BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/tanline/tanlines_bikini
	name = "Tan Lines (Bikini)"
	icon_state = "tan_bikini"
	body_parts = list(BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/tanline/tanlines_b_strap
	name = "Tan Lines (Bikini, Strapless)"
	icon_state = "tan_bikini_strap"
	body_parts = list(BP_TORSO,BP_GROIN)


/////////////////
/// Taj stuff ///
/////////////////
	
/datum/sprite_accessory/marking/taj_paw_socks
	name = "Socks Coloration (Taj)"
	icon_state = "taj_pawsocks"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)
	species_allowed = list(SPECIES_TAJ)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/paw_socks
	name = "Socks Coloration (Generic)"
	icon_state = "pawsocks"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)
	species_allowed = list(SPECIES_TAJ, SPECIES_UNATHI)

/datum/sprite_accessory/marking/paw_socks_belly
	name = "Socks,Belly Coloration (Generic)"
	icon_state = "pawsocksbelly"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)
	species_allowed = list(SPECIES_TAJ, SPECIES_UNATHI)

/datum/sprite_accessory/marking/belly_hands_feet
	name = "Hands,Feet,Belly Color (Minor)"
	icon_state = "bellyhandsfeetsmall"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)
	species_allowed = list(SPECIES_TAJ, SPECIES_UNATHI)

/datum/sprite_accessory/marking/hands_feet_belly_full
	name = "Hands,Feet,Belly Color (Major)"
	icon_state = "bellyhandsfeet"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)
	species_allowed = list(SPECIES_TAJ, SPECIES_UNATHI)

/datum/sprite_accessory/marking/hands_feet_belly_full_female
	name = "Hands,Feet,Belly Color (Major, Female)"
	icon_state = "bellyhandsfeet_female"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)
	species_allowed = list(SPECIES_TAJ)
	apply_restrictions = TRUE



/datum/sprite_accessory/marking/patches
	name = "Color Patches"
	icon_state = "patches"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_GROIN)
	species_allowed = list(SPECIES_TAJ)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/patchesface
	name = "Color Patches (Face)"
	icon_state = "patchesface"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_TAJ)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/bands
	name = "Color Bands"
	icon_state = "bands"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/bandsface
	name = "Color Bands (Face)"
	icon_state = "bandsface"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/tiger_stripes
	name = "Tiger Stripes"
	icon_state = "tiger"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_TORSO,BP_GROIN)
	species_allowed = list(SPECIES_TAJ) //There's a tattoo for non-cats

/datum/sprite_accessory/marking/tigerhead
	name = "Tiger Stripes (Head, Minor)"
	icon_state = "tigerhead"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/tigerface
	name = "Tiger Stripes (Head, Major)"
	icon_state = "tigerface"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_TAJ) //There's a tattoo for non-cats

/datum/sprite_accessory/marking/backstripe
	name = "Back Stripe"
	icon_state = "backstripe"
	body_parts = list(BP_TORSO)

//Taj specific stuff
/datum/sprite_accessory/marking/taj_belly
	name = "Belly Fur (Taj)"
	icon_state = "taj_belly"
	body_parts = list(BP_TORSO)
	species_allowed = list(SPECIES_TAJ)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/taj_bellyfull
	name = "Belly Fur Wide (Taj)"
	icon_state = "taj_bellyfull"
	body_parts = list(BP_TORSO)
	species_allowed = list(SPECIES_TAJ)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/taj_earsout
	name = "Outer Ear (Taj)"
	icon_state = "taj_earsout"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_TAJ)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/taj_earsin
	name = "Inner Ear (Taj)"
	icon_state = "taj_earsin"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_TAJ)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/taj_nose
	name = "Nose Color (Taj)"
	icon_state = "taj_nose"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_TAJ)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/taj_crest
	name = "Chest Fur Crest (Taj)"
	icon_state = "taj_crest"
	body_parts = list(BP_TORSO)
	species_allowed = list(SPECIES_TAJ)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/taj_muzzle
	name = "Muzzle Color (Taj)"
	icon_state = "taj_muzzle"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_TAJ)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/taj_face
	name = "Cheeks Color (Taj)"
	icon_state = "taj_face"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_TAJ)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/taj_all
	name = "All Taj Head (Taj)"
	icon_state = "taj_all"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_TAJ)
	apply_restrictions = TRUE

/// Misc
/datum/sprite_accessory/marking/c_beast_body
	name = "Cyber Body"
	icon_state = "c_beast_body"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/c_beast_plating
	name = "Cyber Plating (Use with Cyber Body)"
	icon_state = "c_beast_plating"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM)

/datum/sprite_accessory/marking/c_beast_band
	name = "Cyber Band (Use with Cybertech head)"
	icon_state = "c_beast_band"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/c_beast_cheek_a
	name = "Cyber Beast Cheeks A (Use A, B and C)"
	icon_state = "c_beast_a"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/c_beast_cheek_b
	name = "Cyber Beast Cheeks B (Use A, B and C)"
	icon_state = "c_beast_b"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/c_beast_cheek_c
	name = "Cyber Beast Cheeks c (Use A, B and C)"
	icon_state = "c_beast_c"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)
	
/datum/sprite_accessory/marking/abomination
	name = "Abomination"
	icon_state = "abomination"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/abomination_alt
	name = "Abomination Alternate"
	icon_state = "abomination2"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vulp_belly
	name = "belly fur (Vulp)"
	icon_state = "vulp_belly"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/vulp_fullbelly
	name = "full belly fur (Vulp)"
	icon_state = "vulp_fullbelly"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/vulp_crest
	name = "belly crest (Vulp)"
	icon_state = "vulp_crest"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/vulp_nose
	name = "nose (Vulp)"
	icon_state = "vulp_nose"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vulp_short_nose
	name = "nose, short (Vulp)"
	icon_state = "vulp_short_nose"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/snoutstripe
	name = "snout stripe (Vulp)"
	icon_state = "snoutstripe"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vulp_face
	name = "face (Vulp)"
	icon_state = "vulp_face"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vulp_facealt
	name = "face, alt. (Vulp)"
	icon_state = "vulp_facealt"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vulp_earsface
	name = "ears and face (Vulp)"
	icon_state = "vulp_earsface"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vulp_all
	name = "all head highlights (Vulp)"
	icon_state = "vulp_all"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/sergal_full
	name = "Sergal Markings"
	icon_state = "sergal_full"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)
	species_allowed = list(SPECIES_SERGAL)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/sergal_full_female
	name = "Sergal Markings (Female)"
	icon_state = "sergal_full_female"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)
	species_allowed = list(SPECIES_SERGAL)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/monoeye
	name = "Monoeye"
	icon_state = "monoeye"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/spidereyes
	name = "Spider Eyes"
	icon_state = "spidereyes"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/sergaleyes
	name = "Sergal Eyes"
	icon_state = "eyes_sergal"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/brows
	name = "Eyebrows"
	icon_state = "brows"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/nevrean_female
	name = "Female Nevrean beak"
	icon_state = "nevrean_f"
	body_parts = list(BP_HEAD)
	color_blend_mode = ICON_MULTIPLY
	gender = FEMALE

/datum/sprite_accessory/marking/nevrean_male
	name = "Male Nevrean beak"
	icon_state = "nevrean_m"
	body_parts = list(BP_HEAD)
	color_blend_mode = ICON_MULTIPLY
	gender = MALE

/datum/sprite_accessory/marking/spots
	name = "Spots"
	icon_state = "spots"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)

/datum/sprite_accessory/marking/shaggy_mane
	name = "Shaggy mane/feathers"
	icon_state = "shaggy"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/jagged_teeth
	name = "Jagged teeth"
	icon_state = "jagged"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/blank_face
	name = "Blank round face (use with monster mouth)"
	icon_state = "blankface"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/monster_mouth
	name = "Monster mouth"
	icon_state = "monster"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/saber_teeth
	name = "Saber teeth"
	icon_state = "saber"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/fangs
	name = "Fangs"
	icon_state = "fangs"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/tusks
	name = "Tusks"
	icon_state = "tusks"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/otie_face
	name = "Otie face"
	icon_state = "otieface"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/otie_nose
	name = "Otie nose"
	icon_state = "otie_nose"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/otienose_lite
	name = "Short otie nose"
	icon_state = "otienose_lite"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/backstripes
	name = "Back stripes"
	icon_state = "otiestripes"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO,BP_HEAD)

/datum/sprite_accessory/marking/belly_butt
	name = "Belly and butt"
	icon_state = "bellyandbutt"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_GROIN,BP_TORSO)

/datum/sprite_accessory/marking/fingers_toes
	name = "Fingers and toes"
	icon_state = "fingerstoes"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_HAND,BP_R_HAND)

/datum/sprite_accessory/marking/otie_socks
	name = "Fingerless socks"
	icon_state = "otiesocks"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)

/datum/sprite_accessory/marking/corvid_beak
	name = "Corvid beak"
	icon_state = "corvidbeak"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/corvid_belly
	name = "Corvid belly"
	icon_state = "corvidbelly"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_GROIN,BP_TORSO,BP_HEAD)

/datum/sprite_accessory/marking/cow_body
	name = "Cow markings"
	icon_state = "cowbody"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)

/datum/sprite_accessory/marking/cow_nose
	name = "Cow nose"
	icon_state = "cownose"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/zmask
	name = "Eye mask"
	icon_state = "zmask"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/zbody
	name = "Thick jagged stripes"
	icon_state = "zbody"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_R_LEG,BP_GROIN,BP_TORSO)

/datum/sprite_accessory/marking/znose
	name = "Jagged snout"
	icon_state = "znose"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/otter_nose
	name = "Otter nose"
	icon_state = "otternose"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/otter_face
	name = "Otter face"
	icon_state = "otterface"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/deer_face
	name = "Deer face"
	icon_state = "deerface"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/sharkface
	name = "Akula snout"
	icon_state = "sharkface"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/sheppy_face
	name = "Shepherd snout"
	icon_state = "shepface"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/sheppy_back
	name = "Shepherd back"
	icon_state = "shepback"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/zorren_belly_male
	name = "Zorren Male Torso"
	icon_state = "zorren_belly"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/zorren_belly_female
	name = "Zorren Female Torso"
	icon_state = "zorren_belly_female"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/zorren_back_patch
	name = "Zorren Back Patch"
	icon_state = "zorren_backpatch"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/zorren_face_male
	name = "Zorren Male Face"
	icon_state = "zorren_face"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)
	gender = MALE

/datum/sprite_accessory/marking/zorren_face_female
	name = "Zorren Female Face"
	icon_state = "zorren_face_female"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)
	gender = FEMALE

/datum/sprite_accessory/marking/zorren_muzzle_male
	name = "Zorren Male Muzzle"
	icon_state = "zorren_muzzle"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)
	gender = MALE

/datum/sprite_accessory/marking/zorren_muzzle_female
	name = "Zorren Female Muzzle"
	icon_state = "zorren_muzzle_female"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)
	gender = FEMALE

/datum/sprite_accessory/marking/zorren_socks
	name = "Zorren Socks"
	icon_state = "zorren_socks"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)

/datum/sprite_accessory/marking/zorren_longsocks
	name = "Zorren Longsocks"
	icon_state = "zorren_longsocks"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)


/datum/sprite_accessory/marking/harpy_feathers
	name = "Rapala leg Feather"
	icon_state = "harpy-feathers"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_R_LEG)

/datum/sprite_accessory/marking/harpy_legs
	name = "Rapala leg coloring"
	icon_state = "harpy-leg"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG)

/datum/sprite_accessory/marking/chooves
	name = "Cloven hooves"
	icon_state = "chooves"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT)

/datum/sprite_accessory/marking/alurane
	name = "Alraune Body"
	icon_state = "alurane"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)

/datum/sprite_accessory/marking/body_tone
	name = "Body toning (for emergency contrast loss)"
	icon_state = "btone"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)

/datum/sprite_accessory/marking/gloss
	name = "Full body gloss"
	icon_state = "gloss"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)

/datum/sprite_accessory/marking/eboop_panels
	name = "Eggnerd FBP panels"
	icon_state = "eboop"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)

/datum/sprite_accessory/marking/osocks_rarm
	name = "Modular Longsock (right arm)"
	icon_state = "osocks"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_R_ARM,BP_R_HAND)

/datum/sprite_accessory/marking/osocks_larm
	name = "Modular Longsock (left arm)"
	icon_state = "osocks"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_ARM,BP_L_HAND)

/datum/sprite_accessory/marking/osocks_rleg
	name = "Modular Longsock (right leg)"
	icon_state = "osocks"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_R_FOOT,BP_R_LEG)

/datum/sprite_accessory/marking/osocks_lleg
	name = "Modular Longsock (left leg)"
	icon_state = "osocks"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_L_LEG)

/datum/sprite_accessory/marking/motheyes
	name = "Moth Eyes"
	icon_state = "motheyes"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/animeeyesinner
	name = "Anime Eyes Inner"
	icon_state = "animeeyesinner"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/animeeyesouter
	name = "Anime Eyes Outer"
	icon_state = "animeeyesouter"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/panda_eye_marks
	name = "Panda Eye Markings"
	icon_state = "eyes_panda"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_HUMAN)

/datum/sprite_accessory/marking/catwomantorso
	name = "Catwoman chest stripes"
	icon_state = "catwomanchest"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/catwomangroin
	name = "Catwoman groin stripes"
	icon_state = "catwomangroin"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_GROIN)

/datum/sprite_accessory/marking/catwoman_rleg
	name = "Catwoman right leg stripes"
	icon_state = "catwomanright"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_R_LEG)

/datum/sprite_accessory/marking/catwoman_lleg
	name = "Catwoman left leg stripes"
	icon_state = "catwomanleft"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG)

/datum/sprite_accessory/marking/spirit_lights
	name = "Ward - Spirit FBP Lights"
	icon_state = "lights"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_HEAD)

/datum/sprite_accessory/marking/spirit_lights_body
	name = "Ward - Spirit FBP Lights (body)"
	icon_state = "lights"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO)

/datum/sprite_accessory/marking/spirit_lights_head
	name = "Ward - Spirit FBP Lights (head)"
	icon_state = "lights"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/spirit_panels
	name = "Ward - Spirit FBP Panels"
	icon_state = "panels"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)

/datum/sprite_accessory/marking/spirit_panels_body
	name = "Ward - Spirit FBP Panels (body)"
	icon_state = "panels"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)

/datum/sprite_accessory/marking/spirit_panels_head
	name = "Ward - Spirit FBP Panels (head)"
	icon_state = "panels"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/tentacle_head
	name = "Squid Head"
	icon_state = "tentaclehead"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/tentacle_mouth
	name = "Tentacle Mouth"
	icon_state = "tentaclemouth"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/rosette
	name = "Rosettes"
	icon_state = "rosette"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)

/datum/sprite_accessory/marking/heterochromia
	name = "Heterochromia"
	icon_state = "heterochromia"//something is odd about these two markings, needs more investigation
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/heterochromia_r
	name = "Heterochromia (right eye)"
	icon_state = "heterochromia_r"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/markering/werebeast
	name = "empty accessory, nothing changed"
	icon = 'icons/mob/clothing/species/werebeast/werebeast_markings.dmi'
	color_blend_mode = ICON_MULTIPLY
	species_allowed = list(SPECIES_WEREBEAST)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/werebeast/werewolf_nose
	name = "Werewolf nose"
	icon_state = "werewolf_nose"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/werebeast/werewolf_face
	name = "Werewolf face"
	icon = 'icons/mob/clothing/species/werebeast/werebeast_markings.dmi'
	icon_state = "werewolf"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_WEREBEAST)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/werebeast/werewolf_belly
	name = "Werewolf belly"
	icon = 'icons/mob/clothing/species/werebeast/werebeast_markings.dmi'
	icon_state = "werewolf"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_GROIN,BP_TORSO)
	species_allowed = list(SPECIES_WEREBEAST)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/werebeast/werewolf_socks
	name = "Werewolf socks"
	icon = 'icons/mob/clothing/species/werebeast/werebeast_markings.dmi'
	icon_state = "werewolf"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)
	species_allowed = list(SPECIES_WEREBEAST)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/shadekin_snoot
	name = "Shadekin Snoot"
	icon_state = "shadekin-snoot"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_SHADEKIN, SPECIES_SHADEKIN_CREW)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/taj_nose_alt
	name = "Nose Color, alt. (Taj)"
	icon_state = "taj_nosealt"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/talons
	name = "Talons"
	icon_state = "talons"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG)

/datum/sprite_accessory/marking/claws
	name = "Claws"
	icon_state = "claws"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_HAND,BP_R_HAND)

/datum/sprite_accessory/marking/equine_snout //Why the long face? Works best with sergal bodytype.
	name = "Equine Snout"
	icon_state = "donkey"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/equine_nose
	name = "Equine Nose"
	icon_state = "dnose"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/short_snoot
	name = "Short Snout"
	icon_state = "shortsnoot"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/short_snoot_nose
	name = "Short Snout Nose"
	icon_state = "snootnose"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/thirdeye
	name = "Third Eye"
	icon_state = "thirdeye"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/fullhead
	name = "Full Head Color"
	icon_state = "fullhead"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/panda_full
	name = "Panda Limbs"
	icon_state = "panda"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)
	color_blend_mode = ICON_ADD

/datum/sprite_accessory/marking/jackal_backpattern
	name = "Jackal Backpattern"
	icon_state = "jackal_backpattern"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_ARM,BP_R_ARM,BP_TORSO)

/datum/sprite_accessory/marking/jackal_bareback
	name = "Jackal Bareback"
	icon_state = "jackal_bareback"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_ARM,BP_R_ARM,BP_GROIN,BP_TORSO)

//Tesh stuff.
/datum/sprite_accessory/marking/tesh
	icon = "icons/mob/sprite_accessories/markings/tesh_stuff.dmi"

/datum/sprite_accessory/marking/tesh/teshi_heterochromia
	name = "Teshari Heterochromia"
	icon_state = "teshi_heterochromia"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_TESHARI)
	apply_restrictions = TRUE
/datum/sprite_accessory/marking/tesh/tesh_feathers
	name = "Teshari Feathers"
	icon_state = "tesh-feathers"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_HAND,BP_R_HAND)
/datum/sprite_accessory/marking/tesh/teshi_fluff
	name = "Teshari underfluff"
	icon_state = "teshi_fluff"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_GROIN,BP_TORSO,BP_HEAD)

/datum/sprite_accessory/marking/tesh/teshi_small_feathers
	name = "Teshari small wingfeathers"
	icon_state = "teshi_sf"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_HAND,BP_R_HAND,BP_TORSO)
/datum/sprite_accessory/marking/tesh/teshari_large_eyes
	name = "Teshari large eyes"
	icon_state = "teshlarge_eyes"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_TESHARI)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/tesh/teshari_coat
	name = "Teshari coat"
	icon_state = "tesh_coat"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_TORSO,BP_HEAD)
	species_allowed = list(SPECIES_TESHARI)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/tesh/teshari_pattern_male
	name = "Teshari male pattern"
	icon_state = "tesh-pattern-male"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_GROIN,BP_HEAD)
	species_allowed = list(SPECIES_TESHARI)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/tesh/teshari_pattern_female
	name = "Teshari female pattern"
	icon_state = "tesh-pattern-fem"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_R_LEG,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_GROIN,BP_HEAD)
	species_allowed = list(SPECIES_TESHARI)
	apply_restrictions = TRUE

/////////////
//Vox stuff//
/////////////

/datum/sprite_accessory/marking/vox
	icon = "icons/mob/sprite_accessories/markings/vox_stuff.dmi"

/datum/sprite_accessory/marking/vox/vox_coloration
	name = "Vox Two Tone"
	icon_state = "vox_two_tone"
	body_parts = list(BP_HEAD,BP_L_HAND,BP_R_HAND,BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM)
	species_allowed = list(SPECIES_VOX)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/vox/vox_alt
	name = "Vox Alternate"
	icon_state = "bay_vox"
	body_parts = list (BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_GROIN,BP_HEAD)
	species_allowed = list(SPECIES_VOX)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/vox/vox_alt_eyes
	name = "Alternate Vox Eyes"
	icon_state = "bay_vox_eyes"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_VOX)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/vox/voxscales
	name = "Vox Scales"
	icon_state = "Voxscales"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_HEAD)

/datum/sprite_accessory/marking/vox/voxclaws
	name = "Vox Claws"
	icon_state = "Voxclaws"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_HAND,BP_R_HAND)

/datum/sprite_accessory/marking/vox/voxbeak
	name = "Vox Beak"
	icon_state = "Voxscales"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

//Una specific stuff
/datum/sprite_accessory/marking/unathi
	icon = "icons/mob/sprite_accessories/markings/unathi_stuff.dmi"

/datum/sprite_accessory/marking/unathi/una_paw_socks
	name = "Socks Coloration (Una)"
	icon_state = "una_pawsocks"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)
	species_allowed = list(SPECIES_UNATHI)

/datum/sprite_accessory/marking/unathi/una_face
	name = "Face Color (Una)"
	icon_state = "una_face"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_UNATHI)

/datum/sprite_accessory/marking/unathi/una_facelow
	name = "Face Color Low (Una)"
	icon_state = "una_facelow"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_UNATHI)

/datum/sprite_accessory/marking/unathi/una_scutes
	name = "Scutes (Una)"
	icon_state = "una_scutes"
	body_parts = list(BP_TORSO)
	species_allowed = list(SPECIES_UNATHI)

/datum/sprite_accessory/marking/unathi/unathihood
	name = "Cobra Hood"
	icon_state = "unathihood"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/unathi/unathidoublehorns
	name = "Double Unathi Horns"
	icon_state = "unathidoublehorns"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/unathi/unathihorns
	name = "Unathi Horns"
	icon_state = "unathihorns"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/unathi/unathiramhorns
	name = "Unathi Ram Horns"
	icon_state = "unathiramhorns"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/unathi/unathishortspines
	name = "Unathi Short Spines"
	icon_state = "unathishortspines"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/unathi/unathilongspines
	name = "Unathi Long Spines"
	icon_state = "unathilongspines"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/unathi/unathishortfrills
	name = "Unathi Short Frills"
	icon_state = "unathishortfrills"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/unathi/unathilongfrills
	name = "Unathi Long Frills"
	icon_state = "unathilongfrills"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)
