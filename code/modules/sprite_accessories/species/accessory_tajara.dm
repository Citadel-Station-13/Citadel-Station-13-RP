/**
 * =------------------------=
 * == Taj Hair Definitions ==
 * =------------------------=
 */

/datum/sprite_accessory/hair/taj
	name = "Tajaran Ears"
	icon_state = "ears_plain"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)

/datum/sprite_accessory/hair/taj/ears_clean
	name = "Tajara Clean"
	icon_state = "hair_clean"

/datum/sprite_accessory/hair/taj/ears_bangs
	name = "Tajara Bangs"
	icon_state = "hair_bangs"

/datum/sprite_accessory/hair/taj/ears_braid
	name = "Tajara Braid"
	icon_state = "hair_tbraid"

/datum/sprite_accessory/hair/taj/ears_shaggy
	name = "Tajara Shaggy"
	icon_state = "hair_shaggy"

/datum/sprite_accessory/hair/taj/ears_mohawk
	name = "Tajaran Mohawk"
	icon_state = "hair_mohawk"

/datum/sprite_accessory/hair/taj/ears_plait
	name = "Tajara Plait"
	icon_state = "hair_plait"

/datum/sprite_accessory/hair/taj/ears_straight
	name = "Tajara Straight"
	icon_state = "hair_straight"

/datum/sprite_accessory/hair/taj/ears_long
	name = "Tajara Long"
	icon_state = "hair_long"

/datum/sprite_accessory/hair/taj/ears_rattail
	name = "Tajara Rat Tail"
	icon_state = "hair_rattail"

/datum/sprite_accessory/hair/taj/ears_spiky
	name = "Tajara Spiky"
	icon_state = "hair_tajspiky"

/datum/sprite_accessory/hair/taj/ears_messy
	name = "Tajara Messy"
	icon_state = "hair_messy"

/datum/sprite_accessory/hair/taj/ears_curls
	name = "Tajaran Curly"
	icon_state = "hair_curly"

/datum/sprite_accessory/hair/taj/ears_wife
	name = "Tajaran Housewife"
	icon_state = "hair_wife"

/datum/sprite_accessory/hair/taj/ears_victory
	name = "Tajaran Victory Curls"
	icon_state = "hair_victory"

/datum/sprite_accessory/hair/taj/ears_bob
	name = "Tajaran Bob"
	icon_state = "hair_tbob"

/datum/sprite_accessory/hair/taj/ears_fingercurl
	name = "Tajaran Finger Curls"
	icon_state = "hair_fingerwave"



/**
 * =-------------------------------=
 * == Taj Facial Hair Definitions ==
 * =-------------------------------=
 */

/datum/sprite_accessory/facial_hair/taj
	name = "Tajaran Sideburns"
	icon_state = "facial_sideburns"
	icon = 'icons/mob/human_face_vr.dmi'
	icon_add = 'icons/mob/human_face_vr_add.dmi'
	species_allowed = list(SPECIES_TAJ)
	gender = MALE

/datum/sprite_accessory/facial_hair/taj/mutton
	name = "Tajaran Mutton"
	icon_state = "facial_mutton"

/datum/sprite_accessory/facial_hair/taj/pencilstache
	name = "Tajaran Pencilstache"
	icon_state = "facial_pencilstache"

/datum/sprite_accessory/facial_hair/taj/moustache
	name = "Tajaran Moustache"
	icon_state = "facial_moustache"

/datum/sprite_accessory/facial_hair/taj/goatee
	name = "Tajaran Goatee"
	icon_state = "facial_goatee"

/datum/sprite_accessory/facial_hair/taj/smallstache
	name = "Tajaran Smallsatche"
	icon_state = "facial_smallstache"



/**
 * =---------------------------=
 * == Taj Marking Definitions ==
 * =---------------------------=
 */

/datum/sprite_accessory/marking/taj
	name = "Belly Fur (Taj)"
	icon_state = "taj_belly"
	body_parts = list(BP_TORSO)
	species_allowed = list(SPECIES_TAJ)

/datum/sprite_accessory/marking/taj/paw_socks
	name = "Socks Coloration (Taj)"
	icon_state = "taj_pawsocks"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)

/datum/sprite_accessory/marking/taj/bellyfull
	name = "Belly Fur Wide (Taj)"
	icon_state = "taj_bellyfull"
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/taj/earsin
	name = "Inner Ear (Taj)"
	icon_state = "taj_earsin"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/taj/earsout
	name = "Outer Ear (Taj)"
	icon_state = "taj_earsout"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/taj/nose
	name = "Nose Color (Taj)"
	icon_state = "taj_nose"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/taj/crest
	name = "Chest Fur Crest (Taj)"
	icon_state = "taj_crest"
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/taj/muzzle
	name = "Muzzle Color (Taj)"
	icon_state = "taj_muzzle"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/taj/face
	name = "Cheeks Color (Taj)"
	icon_state = "taj_face"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/taj/all
	name = "All Taj Head (Taj)"
	icon_state = "taj_all"
	body_parts = list(BP_HEAD)
