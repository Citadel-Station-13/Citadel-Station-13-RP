/datum/sprite_accessory/marking
	abstract_type = /datum/sprite_accessory/marking
	icon = "icons/mob/sprite_accessories/markings.dmi"
	do_colouration = 1 //Almost all of them have it, COLOR_ADD
	color_blend_mode = ICON_ADD

	///Empty list is unrestricted. Should only restrict the ones that make NO SENSE on other species,
	//like Tajaran inner-ear coloring overlay stuff.
	species_allowed = list()

	var/body_parts = list() //A list of bodyparts this covers, in organ_tag defines
	//Reminder: BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_GROIN,BP_HEAD

/datum/sprite_accessory/marking/bands
	name = "Color Bands"
	id = "marking_bands"
	icon_state = "bands"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/bandsface
	name = "Color Bands (Face)"
	id = "marking_bands_face"
	icon_state = "bandsface"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/tigerhead
	name = "Tiger Stripes (Head, Minor)"
	id = "marking_tiger_head"
	icon_state = "tigerhead"
	body_parts = list(BP_HEAD)


/datum/sprite_accessory/marking/backstripe
	name = "Back Stripe"
	id = "marking_back"
	icon_state = "backstripe"
	body_parts = list(BP_TORSO)

/// Misc
/datum/sprite_accessory/marking/abomination
	name = "Abomination"
	id = "marking_abomination"
	icon_state = "abomination"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/abomination_alt
	name = "Abomination Alternate"
	id = "marking_abomination2"
	icon_state = "abomination2"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/nevrean_female
	name = "Female Nevrean beak"
	id = "marking_nevrean_f"
	icon_state = "nevrean_f"
	body_parts = list(BP_HEAD)
	color_blend_mode = ICON_MULTIPLY
	gender = FEMALE

/datum/sprite_accessory/marking/nevrean_male
	name = "Male Nevrean beak"
	id = "marking_nevrean_m"
	icon_state = "nevrean_m"
	body_parts = list(BP_HEAD)
	color_blend_mode = ICON_MULTIPLY
	gender = MALE

/datum/sprite_accessory/marking/spots
	name = "Spots"
	id = "marking_spots"
	icon_state = "spots"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)

/datum/sprite_accessory/marking/shaggy_mane
	name = "Shaggy mane/feathers"
	id = "marking_shaggy"
	icon_state = "shaggy"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/jagged_teeth
	name = "Jagged teeth"
	id = "marking_teeth_jagged"
	icon_state = "jagged"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/blank_face
	name = "Blank round face (use with monster mouth)"
	id = "marking_face_blank"
	icon_state = "blankface"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/monster_mouth
	name = "Monster mouth"
	id = "marking_mouth_monster"
	icon_state = "monster"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/saber_teeth
	name = "Saber teeth"
	id = "marking_teeth_saber"
	icon_state = "saber"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/fangs
	name = "Fangs"
	id = "marking_teeth_fangs"
	icon_state = "fangs"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/tusks
	name = "Tusks"
	id = "marking_teeth_tusks"
	icon_state = "tusks"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/otie_face
	name = "Otie face"
	id = "marking_face_otie"
	icon_state = "otieface"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/otie_nose
	name = "Otie nose"
	id = "marking_nose_otie"
	icon_state = "otie_nose"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/otienose_lite
	name = "Short otie nose"
	id = "marking_nose_otie_short"
	icon_state = "otienose_lite"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/backstripes
	name = "Back stripes"
	id = "marking_stripes_otie"
	icon_state = "otiestripes"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO,BP_HEAD)

/datum/sprite_accessory/marking/belly_butt
	name = "Belly and butt"
	id = "marking_bellybutt"
	icon_state = "bellyandbutt"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_GROIN,BP_TORSO)

/datum/sprite_accessory/marking/fingers_toes
	name = "Fingers and toes"
	id = "marking_fingerstoes"
	icon_state = "fingerstoes"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_HAND,BP_R_HAND)

/datum/sprite_accessory/marking/otie_socks
	name = "Fingerless socks"
	id = "marking_socks_otie"
	icon_state = "otiesocks"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)

/datum/sprite_accessory/marking/corvid_beak
	name = "Corvid beak"
	id = "marking_beak_corvid"
	icon_state = "corvidbeak"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/corvid_belly
	name = "Corvid belly"
	id = "marking_belly_corvid"
	icon_state = "corvidbelly"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_GROIN,BP_TORSO,BP_HEAD)

/datum/sprite_accessory/marking/cow_body
	name = "Cow markings"
	id = "marking_body_cow"
	icon_state = "cowbody"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)

/datum/sprite_accessory/marking/cow_nose
	name = "Cow nose"
	id = "marking_nose_cow"
	icon_state = "cownose"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/zbody
	name = "Thick jagged stripes"
	id = "marking_jaggedstripes"
	icon_state = "zbody"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_R_LEG,BP_GROIN,BP_TORSO)

/datum/sprite_accessory/marking/znose
	name = "Jagged snout"
	id = "marking_nose_jagged"
	icon_state = "znose"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/otter_nose
	name = "Otter nose"
	id = "marking_nose_otter"
	icon_state = "otternose"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/otter_face
	name = "Otter face"
	id = "marking_face_otter"
	icon_state = "otterface"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/deer_face
	name = "Deer face"
	id = "marking_face_deer"
	icon_state = "deerface"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/sharkface
	name = "Akula snout"
	id = "marking_face_akula"
	icon_state = "sharkface"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/sheppy_face
	name = "Shepherd snout"
	id = "marking_face_shepherd"
	icon_state = "shepface"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/sheppy_back
	name = "Shepherd back"
	id = "marking_back_shepherd"
	icon_state = "shepback"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/harpy_feathers
	name = "Rapala leg Feather"
	id = "marking_leg_rapala"
	icon_state = "harpy-feathers"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_R_LEG)

/datum/sprite_accessory/marking/harpy_legs
	name = "Rapala leg coloring"
	id = "marking_leg_harpy"
	icon_state = "harpy-leg"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG)

/datum/sprite_accessory/marking/chooves
	name = "Cloven hooves"
	id = "marking_hooves_cloven"
	icon_state = "chooves"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT)

/datum/sprite_accessory/marking/alurane
	name = "Alraune Body"
	id = "marking_body_alraune"
	icon_state = "alurane"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)

/datum/sprite_accessory/marking/body_tone
	name = "Body toning (for emergency contrast loss)"
	id = "marking_body_tone"
	icon_state = "btone"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)

/datum/sprite_accessory/marking/gloss
	name = "Full body gloss"
	id = "marking_body_gloss"
	icon_state = "gloss"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)

/datum/sprite_accessory/marking/osocks_rarm
	name = "Modular Longsock (right arm)"
	id = "marking_sock_rarm"
	icon_state = "osocks"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_R_ARM,BP_R_HAND)

/datum/sprite_accessory/marking/osocks_larm
	name = "Modular Longsock (left arm)"
	id = "marking_sock_larm"
	icon_state = "osocks"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_ARM,BP_L_HAND)

/datum/sprite_accessory/marking/osocks_rleg
	name = "Modular Longsock (right leg)"
	id = "marking_sock_rleg"
	icon_state = "osocks"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_R_FOOT,BP_R_LEG)

/datum/sprite_accessory/marking/osocks_lleg
	name = "Modular Longsock (left leg)"
	id = "marking_sock_lleg"
	icon_state = "osocks"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_L_LEG)

/datum/sprite_accessory/marking/catwomantorso
	name = "Catwoman chest stripes"
	id = "marking_chest_catwoman"
	icon_state = "catwomanchest"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/catwomangroin
	name = "Catwoman groin stripes"
	id = "marking_groin_catwoman"
	icon_state = "catwomangroin"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_GROIN)

/datum/sprite_accessory/marking/catwoman_rleg
	name = "Catwoman right leg stripes"
	id = "marking_catwoman_rleg"
	icon_state = "catwomanright"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_R_LEG)

/datum/sprite_accessory/marking/catwoman_lleg
	name = "Catwoman left leg stripes"
	id = "marking_catwoman_lleg"
	icon_state = "catwomanleft"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG)

/datum/sprite_accessory/marking/tentacle_head
	name = "Squid Head"
	id = "marking_head_squid"
	icon_state = "tentaclehead"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/tentacle_mouth
	name = "Tentacle Mouth"
	id = "marking_mouth_tentacles"
	icon_state = "tentaclemouth"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/rosette
	name = "Rosettes"
	id = "marking_rosettes"
	icon_state = "rosette"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)

/datum/sprite_accessory/marking/shadekin_snoot
	name = "Shadekin Snoot"
	id = "marking_face_shadekin"
	icon_state = "shadekin-snoot"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_SHADEKIN, SPECIES_SHADEKIN_CREW)
	apply_restrictions = TRUE

/datum/sprite_accessory/marking/talons
	name = "Talons"
	id = "marking_talons"
	icon_state = "talons"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG)

/datum/sprite_accessory/marking/claws
	name = "Claws"
	id = "marking_claws"
	icon_state = "claws"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_HAND,BP_R_HAND)

/datum/sprite_accessory/marking/equine_snout //Why the long face? Works best with sergal bodytype.
	name = "Equine Snout"
	id = "marking_face_donkey"
	icon_state = "donkey"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/equine_nose
	name = "Equine Nose"
	id = "marking_nose_equine"
	icon_state = "dnose"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/short_snoot
	name = "Short Snout"
	id = "marking_snout_short"
	icon_state = "shortsnoot"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/short_snoot_nose
	name = "Short Snout Nose"
	id = "marking_snout_short_nose"
	icon_state = "snootnose"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/fullhead
	name = "Full Head Color"
	id = "marking_head_full"
	icon_state = "fullhead"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/nosehuman
	name = "Human Nose Color"
	id = "marking_nose"
	icon_state = "nose"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/jackal_backpattern
	name = "Jackal Backpattern"
	id = "marking_back_jackal"
	icon_state = "jackal_backpattern"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_ARM,BP_R_ARM,BP_TORSO)

/datum/sprite_accessory/marking/jackal_bareback
	name = "Jackal Bareback"
	id = "marking_back_jackal2"
	icon_state = "jackal_bareback"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_ARM,BP_R_ARM,BP_GROIN,BP_TORSO)
