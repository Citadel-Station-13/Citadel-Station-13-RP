// todo: this shouldn't be a /sprite_accessory.

#warn move all this over

/datum/bodyset_marking
	abstract_type = /datum/bodyset_marking
	icon = "icons/mob/sprite_accessories/markings.dmi"
	do_colouration = 1 //Almost all of them have it, COLOR_ADD
	legacy_use_additive_color_matrix = TRUE

/datum/bodyset_marking/bands
	name = "Color Bands"
	id = "marking_bands"
	icon_state = "bands"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_GROIN)

/datum/bodyset_marking/bandsface
	name = "Color Bands (Face)"
	id = "marking_bands_face"
	icon_state = "bandsface"
	body_parts = list(BP_HEAD)

/datum/bodyset_marking/tigerhead
	name = "Tiger Stripes (Head, Minor)"
	id = "marking_tiger_head"
	icon_state = "tigerhead"
	body_parts = list(BP_HEAD)


/datum/bodyset_marking/backstripe
	name = "Back Stripe"
	id = "marking_back"
	icon_state = "backstripe"
	body_parts = list(BP_TORSO)

/// Misc
/datum/bodyset_marking/abomination
	name = "Abomination"
	id = "marking_abomination"
	icon_state = "abomination"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_HEAD)

/datum/bodyset_marking/abomination_alt
	name = "Abomination Alternate"
	id = "marking_abomination2"
	icon_state = "abomination2"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_HEAD)

/datum/bodyset_marking/nevrean_female
	name = "Female Nevrean beak"
	id = "marking_nevrean_f"
	icon_state = "nevrean_f"
	body_parts = list(BP_HEAD)
	legacy_use_additive_color_matrix = FALSE
	random_generation_gender = FEMALE

/datum/bodyset_marking/nevrean_male
	name = "Male Nevrean beak"
	id = "marking_nevrean_m"
	icon_state = "nevrean_m"
	body_parts = list(BP_HEAD)
	legacy_use_additive_color_matrix = FALSE
	random_generation_gender = MALE

/datum/bodyset_marking/spots
	name = "Spots"
	id = "marking_spots"
	icon_state = "spots"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)

/datum/bodyset_marking/shaggy_mane
	name = "Shaggy mane/feathers"
	id = "marking_shaggy"
	icon_state = "shaggy"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_TORSO)

/datum/bodyset_marking/jagged_teeth
	name = "Jagged teeth"
	id = "marking_teeth_jagged"
	icon_state = "jagged"
	body_parts = list(BP_HEAD)

/datum/bodyset_marking/blank_face
	name = "Blank round face (use with monster mouth)"
	id = "marking_face_blank"
	icon_state = "blankface"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_HEAD)

/datum/bodyset_marking/monster_mouth
	name = "Monster mouth"
	id = "marking_mouth_monster"
	icon_state = "monster"
	body_parts = list(BP_HEAD)

/datum/bodyset_marking/saber_teeth
	name = "Saber teeth"
	id = "marking_teeth_saber"
	icon_state = "saber"
	body_parts = list(BP_HEAD)

/datum/bodyset_marking/fangs
	name = "Fangs"
	id = "marking_teeth_fangs"
	icon_state = "fangs"
	body_parts = list(BP_HEAD)

/datum/bodyset_marking/tusks
	name = "Tusks"
	id = "marking_teeth_tusks"
	icon_state = "tusks"
	body_parts = list(BP_HEAD)

/datum/bodyset_marking/otie_face
	name = "Otie face"
	id = "marking_face_otie"
	icon_state = "otieface"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_HEAD)

/datum/bodyset_marking/otie_nose
	name = "Otie nose"
	id = "marking_nose_otie"
	icon_state = "otie_nose"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_HEAD)

/datum/bodyset_marking/otienose_lite
	name = "Short otie nose"
	id = "marking_nose_otie_short"
	icon_state = "otienose_lite"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_HEAD)

/datum/bodyset_marking/backstripes
	name = "Back stripes"
	id = "marking_stripes_otie"
	icon_state = "otiestripes"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_TORSO,BP_HEAD)

/datum/bodyset_marking/belly_butt
	name = "Belly and butt"
	id = "marking_bellybutt"
	icon_state = "bellyandbutt"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_GROIN,BP_TORSO)

/datum/bodyset_marking/fingers_toes
	name = "Fingers and toes"
	id = "marking_fingerstoes"
	icon_state = "fingerstoes"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_HAND,BP_R_HAND)

/datum/bodyset_marking/otie_socks
	name = "Fingerless socks"
	id = "marking_socks_otie"
	icon_state = "otiesocks"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)

/datum/bodyset_marking/corvid_beak
	name = "Corvid beak"
	id = "marking_beak_corvid"
	icon_state = "corvidbeak"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_HEAD)

/datum/bodyset_marking/corvid_belly
	name = "Corvid belly"
	id = "marking_belly_corvid"
	icon_state = "corvidbelly"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_GROIN,BP_TORSO,BP_HEAD)

/datum/bodyset_marking/cow_body
	name = "Cow markings"
	id = "marking_body_cow"
	icon_state = "cowbody"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)

/datum/bodyset_marking/cow_nose
	name = "Cow nose"
	id = "marking_nose_cow"
	icon_state = "cownose"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_HEAD)

/datum/bodyset_marking/zbody
	name = "Thick jagged stripes"
	id = "marking_jaggedstripes"
	icon_state = "zbody"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_L_LEG,BP_R_LEG,BP_GROIN,BP_TORSO)

/datum/bodyset_marking/znose
	name = "Jagged snout"
	id = "marking_nose_jagged"
	icon_state = "znose"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_HEAD)

/datum/bodyset_marking/otter_nose
	name = "Otter nose"
	id = "marking_nose_otter"
	icon_state = "otternose"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_HEAD)

/datum/bodyset_marking/otter_face
	name = "Otter face"
	id = "marking_face_otter"
	icon_state = "otterface"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_HEAD)

/datum/bodyset_marking/deer_face
	name = "Deer face"
	id = "marking_face_deer"
	icon_state = "deerface"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_HEAD)

/datum/bodyset_marking/sharkface
	name = "Akula snout"
	id = "marking_face_akula"
	icon_state = "sharkface"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_HEAD)

/datum/bodyset_marking/sheppy_face
	name = "Shepherd snout"
	id = "marking_face_shepherd"
	icon_state = "shepface"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_HEAD)

/datum/bodyset_marking/sheppy_back
	name = "Shepherd back"
	id = "marking_back_shepherd"
	icon_state = "shepback"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_TORSO,BP_GROIN)

/datum/bodyset_marking/harpy_feathers
	name = "Rapala leg Feather"
	id = "marking_leg_rapala"
	icon_state = "harpy-feathers"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_L_LEG,BP_R_LEG)

/datum/bodyset_marking/harpy_legs
	name = "Rapala leg coloring"
	id = "marking_leg_harpy"
	icon_state = "harpy-leg"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG)

/datum/bodyset_marking/chooves
	name = "Cloven hooves"
	id = "marking_hooves_cloven"
	icon_state = "chooves"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_L_FOOT,BP_R_FOOT)

/datum/bodyset_marking/alurane
	name = "Alraune Body"
	id = "marking_body_alraune"
	icon_state = "alurane"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)

/datum/bodyset_marking/body_tone
	name = "Body toning (for emergency contrast loss)"
	id = "marking_body_tone"
	icon_state = "btone"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)

/datum/bodyset_marking/body_tone_alt
	name = "Body toning Alt"
	id = "marking_body_tone_alt"
	icon_state = "btonealt"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)

/datum/bodyset_marking/skrell_highlight
	name = "Skrell Highlight"
	id = "marking_hightlight_skrell"
	icon_state = "skrellhighlight"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)

/datum/bodyset_marking/skrell_chest
	name = "Skrell Chest"
	id = "marking_chest_skrell"
	icon_state = "skrellchest"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_TORSO)

/datum/bodyset_marking/skrell_leg
	name = "Skrell Leg Marking"
	id = "marking_leg_skrell"
	icon_state = "skrellleg"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG)

/datum/bodyset_marking/gloss
	name = "Full body gloss"
	id = "marking_body_gloss"
	icon_state = "gloss"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)

/datum/bodyset_marking/osocks_rarm
	name = "Modular Longsock (right arm)"
	id = "marking_sock_rarm"
	icon_state = "osocks"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_R_ARM,BP_R_HAND)

/datum/bodyset_marking/osocks_larm
	name = "Modular Longsock (left arm)"
	id = "marking_sock_larm"
	icon_state = "osocks"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_L_ARM,BP_L_HAND)

/datum/bodyset_marking/osocks_rleg
	name = "Modular Longsock (right leg)"
	id = "marking_sock_rleg"
	icon_state = "osocks"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_R_FOOT,BP_R_LEG)

/datum/bodyset_marking/osocks_lleg
	name = "Modular Longsock (left leg)"
	id = "marking_sock_lleg"
	icon_state = "osocks"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_L_FOOT,BP_L_LEG)

/datum/bodyset_marking/catwomantorso
	name = "Catwoman chest stripes"
	id = "marking_chest_catwoman"
	icon_state = "catwomanchest"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_TORSO)

/datum/bodyset_marking/catwomangroin
	name = "Catwoman groin stripes"
	id = "marking_groin_catwoman"
	icon_state = "catwomangroin"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_GROIN)

/datum/bodyset_marking/catwoman_rleg
	name = "Catwoman right leg stripes"
	id = "marking_catwoman_rleg"
	icon_state = "catwomanright"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_R_LEG)

/datum/bodyset_marking/catwoman_lleg
	name = "Catwoman left leg stripes"
	id = "marking_catwoman_lleg"
	icon_state = "catwomanleft"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_L_LEG)

/datum/bodyset_marking/tentacle_head
	name = "Squid Head"
	id = "marking_head_squid"
	icon_state = "tentaclehead"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_HEAD)

/datum/bodyset_marking/tentacle_mouth
	name = "Tentacle Mouth"
	id = "marking_mouth_tentacles"
	icon_state = "tentaclemouth"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_HEAD)

/datum/bodyset_marking/rosette
	name = "Rosettes"
	id = "marking_rosettes"
	icon_state = "rosette"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)

/datum/bodyset_marking/shadekin_snoot
	name = "Shadekin Snoot"
	id = "marking_face_shadekin"
	icon_state = "shadekin-snoot"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_SHADEKIN, SPECIES_SHADEKIN_CREW)
	apply_restrictions = TRUE

/datum/bodyset_marking/talons
	name = "Talons"
	id = "marking_talons"
	icon_state = "talons"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG)

/datum/bodyset_marking/claws
	name = "Claws"
	id = "marking_claws"
	icon_state = "claws"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_L_HAND,BP_R_HAND)

/datum/bodyset_marking/equine_snout //Why the long face? Works best with sergal bodytype.
	name = "Equine Snout"
	id = "marking_face_donkey"
	icon_state = "donkey"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_HEAD)

/datum/bodyset_marking/equine_nose
	name = "Equine Nose"
	id = "marking_nose_equine"
	icon_state = "dnose"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_HEAD)

/datum/bodyset_marking/short_snoot
	name = "Short Snout"
	id = "marking_snout_short"
	icon_state = "shortsnoot"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_HEAD)

/datum/bodyset_marking/short_snoot_nose
	name = "Short Snout Nose"
	id = "marking_snout_short_nose"
	icon_state = "snootnose"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_HEAD)

/datum/bodyset_marking/fullhead
	name = "Full Head Color"
	id = "marking_head_full"
	icon_state = "fullhead"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_HEAD)

/datum/bodyset_marking/nosehuman
	name = "Human Nose Color"
	id = "marking_nose"
	icon_state = "nose"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_HEAD)

/datum/bodyset_marking/lipcolorhuman
	name = "Humanoid Lip Colour"
	id = "marking_lip"
	icon_state = "lipcolor"
	body_parts = list(BP_HEAD)

/datum/bodyset_marking/jackal_backpattern
	name = "Jackal Backpattern"
	id = "marking_back_jackal"
	icon_state = "jackal_backpattern"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_L_ARM,BP_R_ARM,BP_TORSO)

/datum/bodyset_marking/jackal_bareback
	name = "Jackal Bareback"
	id = "marking_back_jackal2"
	icon_state = "jackal_bareback"
	legacy_use_additive_color_matrix = FALSE
	body_parts = list(BP_L_ARM,BP_R_ARM,BP_GROIN,BP_TORSO)
