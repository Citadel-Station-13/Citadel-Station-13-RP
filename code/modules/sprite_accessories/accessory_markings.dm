/**
 * =------------------------=
 * == Markings Definitions ==
 * =------------------------=
 */

/datum/sprite_accessory/marking/
	icon = "icons/mob/human_races/markings.dmi"
	do_colouration = FALSE
	color_blend_mode = ICON_ADD

	//Empty list is unrestricted. Should only restrict the ones that make NO SENSE on other species,
	//like Tajaran inner-ear coloring overlay stuff.
	species_allowed = list()

	/// A list of other marking types to ban from adding when this marking is already added.
	var/list/disallows = list()
	/// A list of bodyparts this covers, in organ_tag defines.
	var/body_parts = list()
	// Reminder: BP_L_FOOT, BP_R_FOOT, BP_L_LEG, BP_R_LEG, BP_L_ARM, BP_R_ARM, BP_L_HAND, BP_R_HAND, BP_TORSO, BP_GROIN, BP_HEAD
	/// A number used to sort markings before they are added to a sprite. Lower is earlier.
	var/draw_order = 100
	var/draw_target = MARKING_TARGET_SKIN

/datum/sprite_accessory/marking/tat_rheart
	name = "Tattoo (Heart, R. Arm)"
	icon_state = "tat_rheart"
	body_parts = list(BP_R_ARM)

/datum/sprite_accessory/marking/tat_lheart
	name = "Tattoo (Heart, L. Arm)"
	icon_state = "tat_lheart"
	body_parts = list(BP_L_ARM)

/datum/sprite_accessory/marking/tat_hive
	name = "Tattoo (Hive, Back)"
	icon_state = "tat_hive"
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/tat_nightling
	name = "Tattoo (Nightling, Back)"
	icon_state = "tat_nightling"
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/tat_campbell
	name = "Tattoo (Campbell, R.Arm)"
	icon_state = "tat_campbell"
	body_parts = list(BP_R_ARM)

/datum/sprite_accessory/marking/tat_campbell/left
	name = "Tattoo (Campbell, L.Arm)"
	body_parts = list(BP_L_ARM)

/datum/sprite_accessory/marking/tat_campbell/rightleg
	name = "Tattoo (Campbell, R.Leg)"
	body_parts = list(BP_R_LEG)

/datum/sprite_accessory/marking/tat_campbell/leftleg
	name = "Tattoo (Campbell, L.Leg)"
	body_parts = list(BP_L_LEG)

/datum/sprite_accessory/marking/tat_silverburgh
	name = "Tattoo (Silverburgh, R.Leg)"
	icon_state = "tat_silverburgh"
	body_parts = list (BP_R_LEG)

/datum/sprite_accessory/marking/tat_silverburgh/left
	name = "Tattoo (Silverburgh, L.Leg)"
	icon_state = "tat_silverburgh"
	body_parts = list (BP_L_LEG)

/datum/sprite_accessory/marking/tat_tiger
	name = "Tattoo (Tiger Stripes, Body)"
	icon_state = "tat_tiger"
	body_parts = BP_ALL_STANDARD

/datum/sprite_accessory/marking/tat_inmon1
	name = "Tattoo (Inmon, Variant 1)"
	icon_state = "tat_inmon1"
	body_parts = list(BP_GROIN)

/datum/sprite_accessory/marking/tat_inmon2
	name = "Tattoo (Inmon, Variant 2)"
	icon_state = "tat_inmon2"
	body_parts = list(BP_GROIN)

/datum/sprite_accessory/marking/tat_inmon3
	name = "Tattoo (Inmon, Variant 3)"
	icon_state = "tat_inmon3"
	body_parts = list(BP_GROIN)

/datum/sprite_accessory/marking/tanlines
	name = "Tan Lines (One Piece, F)"
	icon_state = "tan_op"
	body_parts = list(BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/tanlines_m
	name = "Tan Lines (One Piece, M)"
	icon_state = "tan_mop"
	body_parts = list(BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/tanlines_bikini
	name = "Tan Lines (Bikini)"
	icon_state = "tan_bikini"
	body_parts = list(BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/tanlines_b_strap
	name = "Tan Lines (Bikini, Strapless)"
	icon_state = "tan_bikini_strap"
	body_parts = list(BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/paw_socks
	name = "Socks Coloration (Generic)"
	icon_state = "pawsocks"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)

/datum/sprite_accessory/marking/paw_socks_belly
	name = "Socks,Belly Coloration (Generic)"
	icon_state = "pawsocksbelly"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)

/datum/sprite_accessory/marking/belly_hands_feet
	name = "Hands,Feet,Belly Color (Minor)"
	icon_state = "bellyhandsfeetsmall"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)

/datum/sprite_accessory/marking/hands_feet_belly_full
	name = "Hands,Feet,Belly Color (Major)"
	icon_state = "bellyhandsfeet"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)

/datum/sprite_accessory/marking/hands_feet_belly_full_female
	name = "Hands,Feet,Belly Color (Major, Female)"
	icon_state = "bellyhandsfeet_female"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)

/datum/sprite_accessory/marking/patches
	name = "Color Patches"
	icon_state = "patches"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/patchesface
	name = "Color Patches (Face)"
	icon_state = "patchesface"
	body_parts = list(BP_HEAD)

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

/datum/sprite_accessory/marking/tigerhead
	name = "Tiger Stripes (Head, Minor)"
	icon_state = "tigerhead"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/tigerface
	name = "Tiger Stripes (Head, Major)"
	icon_state = "tigerface"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/backstripe
	name = "Back Stripe"
	icon_state = "backstripe"
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/heterochromia
	name = "Heterochromia (right eye)"
	icon_state = "heterochromia"
	body_parts = list(BP_HEAD)

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



//! ## SPECIAL MARKINGS

/datum/sprite_accessory/marking/special
	icon = 'icons/mob/human_races/markings_vr.dmi'

/datum/sprite_accessory/marking/special/abomination
	name = "Abomination"
	icon_state = "abomination"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/special/abomination_alt
	name = "Abomination Alternate"
	icon_state = "abomination2"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)



//! ## UNSORTED MARKINGS

/datum/sprite_accessory/marking/vr
	icon = 'icons/mob/human_races/markings_vr.dmi'

/datum/sprite_accessory/marking/vr/monoeye
	name = "Monoeye"
	icon_state = "monoeye"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/spidereyes
	name = "Spider Eyes"
	icon_state = "spidereyes"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/brows
	name = "Eyebrows"
	icon_state = "brows"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/nevrean_female
	name = "Female Nevrean beak"
	icon_state = "nevrean_f"
	body_parts = list(BP_HEAD)
	color_blend_mode = ICON_MULTIPLY
	gender = FEMALE

/datum/sprite_accessory/marking/vr/nevrean_male
	name = "Male Nevrean beak"
	icon_state = "nevrean_m"
	body_parts = list(BP_HEAD)
	color_blend_mode = ICON_MULTIPLY
	gender = MALE

/datum/sprite_accessory/marking/vr/spots
	name = "Spots"
	icon_state = "spots"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)

/datum/sprite_accessory/marking/vr/shaggy_mane
	name = "Shaggy mane/feathers"
	icon_state = "shaggy"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/vr/jagged_teeth
	name = "Jagged teeth"
	icon_state = "jagged"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/blank_face
	name = "Blank round face (use with monster mouth)"
	icon_state = "blankface"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/monster_mouth
	name = "Monster mouth"
	icon_state = "monster"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/saber_teeth
	name = "Saber teeth"
	icon_state = "saber"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/fangs
	name = "Fangs"
	icon_state = "fangs"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/tusks
	name = "Tusks"
	icon_state = "tusks"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/otie_face
	name = "Otie face"
	icon_state = "otieface"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/otie_nose
	name = "Otie nose"
	icon_state = "otie_nose"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/otienose_lite
	name = "Short otie nose"
	icon_state = "otienose_lite"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/backstripes
	name = "Back stripes"
	icon_state = "otiestripes"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO,BP_HEAD)

/datum/sprite_accessory/marking/vr/belly_butt
	name = "Belly and butt"
	icon_state = "bellyandbutt"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_GROIN,BP_TORSO)

/datum/sprite_accessory/marking/vr/fingers_toes
	name = "Fingers and toes"
	icon_state = "fingerstoes"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_HAND,BP_R_HAND)

/datum/sprite_accessory/marking/vr/otie_socks
	name = "Fingerless socks"
	icon_state = "otiesocks"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)

/datum/sprite_accessory/marking/vr/corvid_beak
	name = "Corvid beak"
	icon_state = "corvidbeak"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/corvid_belly
	name = "Corvid belly"
	icon_state = "corvidbelly"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_GROIN,BP_TORSO,BP_HEAD)

/datum/sprite_accessory/marking/vr/cow_body
	name = "Cow markings"
	icon_state = "cowbody"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)

/datum/sprite_accessory/marking/vr/cow_nose
	name = "Cow nose"
	icon_state = "cownose"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/zmask
	name = "Eye mask"
	icon_state = "zmask"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/zbody
	name = "Thick jagged stripes"
	icon_state = "zbody"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_R_LEG,BP_GROIN,BP_TORSO)

/datum/sprite_accessory/marking/vr/znose
	name = "Jagged snout"
	icon_state = "znose"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/otter_nose
	name = "Otter nose"
	icon_state = "otternose"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/otter_face
	name = "Otter face"
	icon_state = "otterface"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/deer_face
	name = "Deer face"
	icon_state = "deerface"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/sharkface
	name = "Akula snout"
	icon_state = "sharkface"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/sheppy_face
	name = "Shepherd snout"
	icon_state = "shepface"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/sheppy_back
	name = "Shepherd back"
	icon_state = "shepback"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/vr/zorren_belly_male
	name = "Zorren Male Torso"
	icon_state = "zorren_belly"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/vr/zorren_belly_female
	name = "Zorren Female Torso"
	icon_state = "zorren_belly_female"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/vr/zorren_back_patch
	name = "Zorren Back Patch"
	icon_state = "zorren_backpatch"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/vr/zorren_face_male
	name = "Zorren Male Face"
	icon_state = "zorren_face"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)
	gender = MALE

/datum/sprite_accessory/marking/vr/zorren_face_female
	name = "Zorren Female Face"
	icon_state = "zorren_face_female"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)
	gender = FEMALE

/datum/sprite_accessory/marking/vr/zorren_muzzle_male
	name = "Zorren Male Muzzle"
	icon_state = "zorren_muzzle"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)
	gender = MALE

/datum/sprite_accessory/marking/vr/zorren_muzzle_female
	name = "Zorren Female Muzzle"
	icon_state = "zorren_muzzle_female"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)
	gender = FEMALE

/datum/sprite_accessory/marking/vr/zorren_socks
	name = "Zorren Socks"
	icon_state = "zorren_socks"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)

/datum/sprite_accessory/marking/vr/zorren_longsocks
	name = "Zorren Longsocks"
	icon_state = "zorren_longsocks"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)

/datum/sprite_accessory/marking/vr/harpy_feathers
	name = "Rapala leg Feather"
	icon_state = "harpy-feathers"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_R_LEG)

/datum/sprite_accessory/marking/vr/harpy_legs
	name = "Rapala leg coloring"
	icon_state = "harpy-leg"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG)

/datum/sprite_accessory/marking/vr/chooves
	name = "Cloven hooves"
	icon_state = "chooves"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT)

/datum/sprite_accessory/marking/vr/alurane
	name = "Alraune Body"
	icon_state = "alurane"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)

/datum/sprite_accessory/marking/vr/body_tone
	name = "Body toning (for emergency contrast loss)"
	icon_state = "btone"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)

/datum/sprite_accessory/marking/vr/gloss
	name = "Full body gloss"
	icon_state = "gloss"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)

/datum/sprite_accessory/marking/vr/eboop_panels
	name = "Eggnerd FBP panels"
	icon_state = "eboop"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)

/datum/sprite_accessory/marking/vr/osocks_rarm
	name = "Modular Longsock (right arm)"
	icon_state = "osocks"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_R_ARM,BP_R_HAND)

/datum/sprite_accessory/marking/vr/osocks_larm
	name = "Modular Longsock (left arm)"
	icon_state = "osocks"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_ARM,BP_L_HAND)

/datum/sprite_accessory/marking/vr/osocks_rleg
	name = "Modular Longsock (right leg)"
	icon_state = "osocks"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_R_FOOT,BP_R_LEG)

/datum/sprite_accessory/marking/vr/osocks_lleg
	name = "Modular Longsock (left leg)"
	icon_state = "osocks"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_L_LEG)

/datum/sprite_accessory/marking/vr/motheyes
	name = "Moth Eyes"
	icon_state = "motheyes"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/animeeyesinner
	name = "Anime Eyes Inner"
	icon_state = "animeeyesinner"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/animeeyesouter
	name = "Anime Eyes Outer"
	icon_state = "animeeyesouter"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/panda_eye_marks
	name = "Panda Eye Markings"
	icon_state = "eyes_panda"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_HUMAN)

/datum/sprite_accessory/marking/vr/catwomantorso
	name = "Catwoman chest stripes"
	icon_state = "catwomanchest"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/vr/catwomangroin
	name = "Catwoman groin stripes"
	icon_state = "catwomangroin"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_GROIN)

/datum/sprite_accessory/marking/vr/catwoman_rleg
	name = "Catwoman right leg stripes"
	icon_state = "catwomanright"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_R_LEG)

/datum/sprite_accessory/marking/vr/catwoman_lleg
	name = "Catwoman left leg stripes"
	icon_state = "catwomanleft"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG)

/datum/sprite_accessory/marking/vr/spirit_lights
	name = "Ward - Spirit FBP Lights"
	icon_state = "lights"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_HEAD)

/datum/sprite_accessory/marking/vr/spirit_lights_body
	name = "Ward - Spirit FBP Lights (body)"
	icon_state = "lights"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO)

/datum/sprite_accessory/marking/vr/spirit_lights_head
	name = "Ward - Spirit FBP Lights (head)"
	icon_state = "lights"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/spirit_panels
	name = "Ward - Spirit FBP Panels"
	icon_state = "panels"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)

/datum/sprite_accessory/marking/vr/spirit_panels_body
	name = "Ward - Spirit FBP Panels (body)"
	icon_state = "panels"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)

/datum/sprite_accessory/marking/vr/spirit_panels_head
	name = "Ward - Spirit FBP Panels (head)"
	icon_state = "panels"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/tentacle_head
	name = "Squid Head"
	icon_state = "tentaclehead"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/tentacle_mouth
	name = "Tentacle Mouth"
	icon_state = "tentaclemouth"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/rosette
	name = "Rosettes"
	icon_state = "rosette"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)

/datum/sprite_accessory/marking/vr/heterochromia
	name = "Heterochromia"
	icon_state = "heterochromia"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_HUMAN, SPECIES_UNATHI, SPECIES_TAJ, SPECIES_NEVREAN, SPECIES_AKULA, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_XENOHYBRID, SPECIES_VASILISSAN, SPECIES_RAPALA, SPECIES_PROTEAN, SPECIES_ALRAUNE, SPECIES_WEREBEAST, SPECIES_SHADEKIN, SPECIES_APIDAEN, SPECIES_VETALA_PALE, SPECIES_VETALA_RUDDY, SPECIES_AURIL, SPECIES_DREMACHIR) //This lets all races use the default hairstyles.

/datum/sprite_accessory/marking/vr/taj_nose_alt
	name = "Nose Color, alt. (Taj)"
	icon_state = "taj_nosealt"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/talons
	name = "Talons"
	icon_state = "talons"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG)

/datum/sprite_accessory/marking/vr/claws
	name = "Claws"
	icon_state = "claws"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_HAND,BP_R_HAND)

/datum/sprite_accessory/marking/vr/equine_snout //Why the long face? Works best with sergal bodytype.
	name = "Equine Snout"
	icon_state = "donkey"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/equine_nose
	name = "Equine Nose"
	icon_state = "dnose"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/short_snoot
	name = "Short Snout"
	icon_state = "shortsnoot"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/short_snoot_nose
	name = "Short Snout Nose"
	icon_state = "snootnose"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/thirdeye
	name = "Third Eye"
	icon_state = "thirdeye"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/fullhead
	name = "Full Head Color"
	icon_state = "fullhead"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr/panda_full
	name = "Panda Limbs"
	icon_state = "panda"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)
	color_blend_mode = ICON_ADD

/datum/sprite_accessory/marking/vr/jackal_backpattern
	name = "Jackal Backpattern"
	icon_state = "jackal_backpattern"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_ARM,BP_R_ARM,BP_TORSO)

/datum/sprite_accessory/marking/vr/jackal_bareback
	name = "Jackal Bareback"
	icon_state = "jackal_bareback"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_ARM,BP_R_ARM,BP_GROIN,BP_TORSO)
