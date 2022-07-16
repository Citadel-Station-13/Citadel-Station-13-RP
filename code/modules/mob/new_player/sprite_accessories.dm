/**
 *
 * Hello and welcome to sprite_accessories: For sprite accessories, such as hair,
 * facial hair, and possibly tattoos and stuff somewhere along the line. This file is
 * intended to be friendly for people with little to no actual coding experience.
 * The process of adding in new hairstyles has been made pain-free and easy to do.
 * Enjoy! - Doohl
 *
 *
 * Notice: This all gets automatically compiled in a list in dna2.dm, so you do not
 * have to define any UI values for sprite accessories manually for hair and facial
 * hair. Just add in new hair types and the game will naturally adapt.
 *
 * !!WARNING!!: changing existing hair information can be VERY hazardous to savefiles,
 * to the point where you may completely corrupt a server's savefiles. Please refrain
 * from doing this unless you absolutely know what you are doing, and have defined a
 * conversion in savefile.dm
 */

// TODO: actual better way to do these
// TODO: actual better way to do "can we use this" checks because one whitelist list and a var is fucking horrible to maintain what the fuck

/datum/sprite_accessory

	/// The icon file the accessory is located in.
	var/icon
	/// The icon_state of the accessory.
	var/icon_state
	/// A custom preview state for whatever reason.
	var/preview_state

	/// The preview name of the accessory.
	var/name

	/// Determines if the accessory will be skipped or included in random hair generations.
	var/gender = NEUTER

	/// Restrict some styles to specific species.
	var/list/species_allowed = list(SPECIES_HUMAN,SPECIES_PROMETHEAN,SPECIES_HUMAN_VATBORN)

	/// Whether or not the accessory can be affected by colouration.
	var/do_colouration = 1

	var/color_blend_mode = ICON_MULTIPLY	// If checked.






/*
///////////////////////////////////
/  =---------------------------=  /
/  == Facial Hair Definitions ==  /
/  =---------------------------=  /
///////////////////////////////////
*/

/datum/sprite_accessory/facial_hair
	icon = 'icons/mob/human_face_or_vr.dmi'
	color_blend_mode = ICON_MULTIPLY
	apply_restrictions = FALSE

	shaved
		name = "Shaved"
		icon_state = "bald"
		gender = NEUTER

	neck_fluff
		name = "Neck Fluff"
		icon = 'icons/mob/human_face_or_vr.dmi'
		icon_state = "facial_neckfluff"
		gender = NEUTER

	vulp_none
		name = "None"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "none"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)
		apply_restrictions = TRUE
		gender = NEUTER

	vulp_blaze
		name = "Blaze"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "vulp_facial_blaze"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)
		apply_restrictions = TRUE
		gender = NEUTER

	vulp_vulpine
		name = "Vulpine"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "vulp_facial_vulpine"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)
		apply_restrictions = TRUE
		gender = NEUTER

	vulp_earfluff
		name = "Earfluff"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "vulp_facial_earfluff"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)
		apply_restrictions = TRUE
		gender = NEUTER

	vulp_mask
		name = "Mask"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "vulp_facial_mask"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)
		apply_restrictions = TRUE
		gender = NEUTER

	vulp_patch
		name = "Patch"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "vulp_facial_patch"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)
		apply_restrictions = TRUE
		gender = NEUTER

	vulp_ruff
		name = "Ruff"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "vulp_facial_ruff"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)
		apply_restrictions = TRUE
		gender = NEUTER

	vulp_kita
		name = "Kita"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "vulp_facial_kita"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)
		apply_restrictions = TRUE
		gender = NEUTER

	vulp_swift
		name = "Swift"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "vulp_facial_swift"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)
		apply_restrictions = TRUE
		gender = NEUTER

	watson
		name = "Watson Mustache"
		icon_state = "facial_watson"

	hogan
		name = "Hulk Hogan Mustache"
		icon_state = "facial_hogan" //-Neek

	vandyke
		name = "Van Dyke Mustache"
		icon_state = "facial_vandyke"

	chaplin
		name = "Square Mustache"
		icon_state = "facial_chaplin"

	selleck
		name = "Selleck Mustache"
		icon_state = "facial_selleck"

	neckbeard
		name = "Neckbeard"
		icon_state = "facial_neckbeard"

	fullbeard
		name = "Full Beard"
		icon_state = "facial_fullbeard"

	longbeard
		name = "Long Beard"
		icon_state = "facial_longbeard"

	vlongbeard
		name = "Very Long Beard"
		icon_state = "facial_wise"

	elvis
		name = "Elvis Sideburns"
		icon_state = "facial_elvis"
		//Fuck it, everyone is Elvis. species_allowed = list(SPECIES_HUMAN,SPECIES_PROMETHEAN,SPECIES_HUMAN_VATBORN,SPECIES_UNATHI)

	abe
		name = "Abraham Lincoln Beard"
		icon_state = "facial_abe"

	chinstrap
		name = "Chinstrap"
		icon_state = "facial_chin"

	hip
		name = "Hipster Beard"
		icon_state = "facial_hip"

	gt
		name = "Goatee"
		icon_state = "facial_gt"

	jensen
		name = "Adam Jensen Beard"
		icon_state = "facial_jensen"

	volaju
		name = "Volaju"
		icon_state = "facial_volaju"

	dwarf
		name = "Dwarf Beard"
		icon_state = "facial_dwarf"

	threeOclock
		name = "3 O'clock Shadow"
		icon_state = "facial_3oclock"

	threeOclockstache
		name = "3 O'clock Shadow and Moustache"
		icon_state = "facial_3oclockmoustache"

	fiveOclock
		name = "5 O'clock Shadow"
		icon_state = "facial_5oclock"

	fiveOclockstache
		name = "5 O'clock Shadow and Moustache"
		icon_state = "facial_5oclockmoustache"

	sevenOclock
		name = "7 O'clock Shadow"
		icon_state = "facial_7oclock"

	sevenOclockstache
		name = "7 O'clock Shadow and Moustache"
		icon_state = "facial_7oclockmoustache"

	mutton
		name = "Mutton Chops"
		icon_state = "facial_mutton"

	muttonstache
		name = "Mutton Chops and Moustache"
		icon_state = "facial_muttonmus"

	walrus
		name = "Walrus Moustache"
		icon_state = "facial_walrus"

	croppedbeard
		name = "Full Cropped Beard"
		icon_state = "facial_croppedfullbeard"

	chinless
		name = "Chinless Beard"
		icon_state = "facial_chinlessbeard"

	tribeard
		name = "Tribeard"
		icon_state = "facial_tribeard"

	moonshiner
		name = "Moonshiner"
		icon_state = "facial_moonshiner"

	martial
		name = "Martial Artist"
		icon_state = "facial_martialartist"
/*
///////////////////////////////////
/  =---------------------------=  /
/  == Alien Style Definitions ==  /
/  =---------------------------=  /
///////////////////////////////////
*/

/datum/sprite_accessory/hair
	//Unathi stuff
	una_hood
		name = "Cobra Hood"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "soghun_hood"

	una_spines_long
		name = "Long Unathi Spines"
		icon_state = "soghun_longspines"
		species_allowed = list(SPECIES_UNATHI, SPECIES_XENOCHIMERA, SPECIES_PROTEAN) //Xenochimera get most hairstyles since they're abominations.
		apply_restrictions = TRUE

	una_spines_short
		name = "Short Unathi Spines"
		icon_state = "soghun_shortspines"
		species_allowed = list(SPECIES_UNATHI, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)
		apply_restrictions = TRUE


	una_frills_long
		name = "Long Unathi Frills"
		icon_state = "soghun_longfrills"
		species_allowed = list(SPECIES_UNATHI, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)
		apply_restrictions = TRUE

	una_frills_short
		name = "Short Unathi Frills"
		icon_state = "soghun_shortfrills"
		species_allowed = list(SPECIES_UNATHI, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)
		apply_restrictions = TRUE

	una_horns
		name = "Unathi Horns"
		icon_state = "soghun_horns"
		species_allowed = list(SPECIES_UNATHI, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)
		apply_restrictions = TRUE

	una_bighorns
		name = "Unathi Big Horns"
		icon_state = "unathi_bighorn"
		species_allowed = list(SPECIES_UNATHI, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)
		apply_restrictions = TRUE

	una_smallhorns
		name = "Unathi Small Horns"
		icon_state = "unathi_smallhorn"
		species_allowed = list(SPECIES_UNATHI, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)
		apply_restrictions = TRUE

	una_ramhorns
		name = "Unathi Ram Horns"
		icon_state = "unathi_ramhorn"
		species_allowed = list(SPECIES_UNATHI, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)
		apply_restrictions = TRUE

	una_sidefrills
		name = "Unathi Side Frills"
		icon_state = "unathi_sidefrills"
		species_allowed = list(SPECIES_UNATHI, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)
		apply_restrictions = TRUE

	una_doublehorns
		name = "Double Unathi Horns"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "soghun_dubhorns"
		species_allowed = list(SPECIES_UNATHI, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)
		apply_restrictions = TRUE

//Skrell 'hairstyles' - these were requested for a chimera and screw it, if one wants to eat seafood, go nuts
	skr_tentacle_veryshort
		name = "Skrell Very Short Tentacles"
		icon_state = "skrell_hair_veryshort"
		species_allowed = list(SPECIES_SKRELL, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)
		apply_restrictions = TRUE
		gender = MALE

	skr_tentacle_short
		name = "Skrell Short Tentacles"
		icon_state = "skrell_hair_short"
		species_allowed = list(SPECIES_SKRELL, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)
		apply_restrictions = TRUE

	skr_tentacle_average
		name = "Skrell Average Tentacles"
		icon_state = "skrell_hair_average"
		species_allowed = list(SPECIES_SKRELL, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)
		apply_restrictions = TRUE

	skr_tentacle_verylong
		name = "Skrell Long Tentacles"
		icon_state = "skrell_hair_verylong"
		species_allowed = list(SPECIES_SKRELL, SPECIES_XENOCHIMERA, SPECIES_PROTEAN)
		apply_restrictions = TRUE
		gender = FEMALE

//Tajaran hairstyles
	taj_ears
		name = "Tajaran Ears"
		icon_state = "ears_plain"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
		apply_restrictions = TRUE

	taj_ears_clean
		name = "Tajara Clean"
		icon_state = "hair_clean"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
		apply_restrictions = TRUE

	taj_ears_bangs
		name = "Tajara Bangs"
		icon_state = "hair_bangs"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
		apply_restrictions = TRUE

	taj_ears_braid
		name = "Tajara Braid"
		icon_state = "hair_tbraid"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
		apply_restrictions = TRUE

	taj_ears_shaggy
		name = "Tajara Shaggy"
		icon_state = "hair_shaggy"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
		apply_restrictions = TRUE

	taj_ears_mohawk
		name = "Tajaran Mohawk"
		icon_state = "hair_mohawk"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
		apply_restrictions = TRUE

	taj_ears_plait
		name = "Tajara Plait"
		icon_state = "hair_plait"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
		apply_restrictions = TRUE

	taj_ears_straight
		name = "Tajara Straight"
		icon_state = "hair_straight"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
		apply_restrictions = TRUE

	taj_ears_long
		name = "Tajara Long"
		icon_state = "hair_long"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
		apply_restrictions = TRUE

	taj_ears_rattail
		name = "Tajara Rat Tail"
		icon_state = "hair_rattail"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
		apply_restrictions = TRUE

	taj_ears_spiky
		name = "Tajara Spiky"
		icon_state = "hair_tajspiky"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
		apply_restrictions = TRUE

	taj_ears_messy
		name = "Tajara Messy"
		icon_state = "hair_messy"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
		apply_restrictions = TRUE

	taj_ears_curls
		name = "Tajaran Curly"
		icon_state = "hair_curly"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
		apply_restrictions = TRUE

	taj_ears_wife
		name = "Tajaran Housewife"
		icon_state = "hair_wife"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
		apply_restrictions = TRUE

	taj_ears_victory
		name = "Tajaran Victory Curls"
		icon_state = "hair_victory"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
		apply_restrictions = TRUE

	taj_ears_bob
		name = "Tajaran Bob"
		icon_state = "hair_tbob"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
		apply_restrictions = TRUE

	taj_ears_fingercurl
		name = "Tajaran Finger Curls"
		icon_state = "hair_fingerwave"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
		apply_restrictions = TRUE

//Teshari things
	teshari
		name = "Teshari Default"
		icon_state = "teshari_default"
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		species_allowed = list(SPECIES_TESHARI)
		apply_restrictions = TRUE

	teshari_altdefault
		name = "Teshari Alt. Default"
		icon_state = "teshari_ears"
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		species_allowed = list(SPECIES_TESHARI)
		apply_restrictions = TRUE

	teshari_tight
		name = "Teshari Tight"
		icon_state = "teshari_tight"
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		species_allowed = list(SPECIES_TESHARI)
		apply_restrictions = TRUE

	teshari_excited
		name = "Teshari Spiky"
		icon_state = "teshari_spiky"
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		species_allowed = list(SPECIES_TESHARI)
		apply_restrictions = TRUE

	teshari_spike
		name = "Teshari Spike"
		icon_state = "teshari_spike"
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		species_allowed = list(SPECIES_TESHARI)
		apply_restrictions = TRUE

	teshari_long
		name = "Teshari Overgrown"
		icon_state = "teshari_long"
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		species_allowed = list(SPECIES_TESHARI)
		apply_restrictions = TRUE

	teshari_burst
		name = "Teshari Starburst"
		icon_state = "teshari_burst"
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		species_allowed = list(SPECIES_TESHARI)
		apply_restrictions = TRUE

	teshari_shortburst
		name = "Teshari Short Starburst"
		icon_state = "teshari_burst_short"
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		species_allowed = list(SPECIES_TESHARI)
		apply_restrictions = TRUE

	teshari_mohawk
		name = "Teshari Mohawk"
		icon_state = "teshari_mohawk"
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		species_allowed = list(SPECIES_TESHARI)
		apply_restrictions = TRUE

	teshari_pointy
		name = "Teshari Pointy"
		icon_state = "teshari_pointy"
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		species_allowed = list(SPECIES_TESHARI)
		apply_restrictions = TRUE

	teshari_upright
		name = "Teshari Upright"
		icon_state = "teshari_upright"
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		species_allowed = list(SPECIES_TESHARI)
		apply_restrictions = TRUE

	teshari_mane
		name = "Teshari Mane"
		icon_state = "teshari_mane"
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		species_allowed = list(SPECIES_TESHARI)
		apply_restrictions = TRUE

	teshari_droopy
		name = "Teshari Droopy"
		icon_state = "teshari_droopy"
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		species_allowed = list(SPECIES_TESHARI)
		apply_restrictions = TRUE

	teshari_mushroom
		name = "Teshari Mushroom"
		icon_state = "teshari_mushroom"
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		species_allowed = list(SPECIES_TESHARI)
		apply_restrictions = TRUE

	teshari_twies
		name = "Teshari Twies"
		icon_state = "teshari_twies"
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		species_allowed = list(SPECIES_TESHARI)
		apply_restrictions = TRUE

	teshari_backstrafe
		name = "Teshari Backstrafe"
		icon_state = "teshari_backstrafe"
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		species_allowed = list(SPECIES_TESHARI)
		apply_restrictions = TRUE

	teshari_longway
		name = "Teshari Long way"
		icon_state = "teshari_longway"
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		species_allowed = list(SPECIES_TESHARI)
		apply_restrictions = TRUE

	teshari_tree
		name = "Teshari Tree"
		icon_state = "teshari_tree"
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		species_allowed = list(SPECIES_TESHARI)
		apply_restrictions = TRUE

	teshari_fluffymohawk
		name = "Teshari Fluffy Mohawk"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "teshari_fluffymohawk"
		species_allowed = list(SPECIES_TESHARI)
		apply_restrictions = TRUE

// Vox things
	vox_braid_long
		name = "Long Vox braid"
		icon_state = "vox_longbraid"
		species_allowed = list(SPECIES_VOX)
		apply_restrictions = TRUE

	vox_braid_short
		name = "Short Vox Braid"
		icon_state = "vox_shortbraid"
		species_allowed = list(SPECIES_VOX)
		apply_restrictions = TRUE

	vox_quills_short
		name = "Short Vox Quills"
		icon_state = "vox_shortquills"
		species_allowed = list(SPECIES_VOX)
		apply_restrictions = TRUE

	vox_quills_kingly
		name = "Kingly Vox Quills"
		icon_state = "vox_kingly"
		species_allowed = list(SPECIES_VOX)
		apply_restrictions = TRUE

	vox_quills_mohawk
		name = "Quill Mohawk"
		icon_state = "vox_mohawk"
		species_allowed = list(SPECIES_VOX)
		apply_restrictions = TRUE

	vox_quills_afro
		name = "Vox Afro"
		icon_state = "vox_afro"
		species_allowed = list(SPECIES_VOX)
		apply_restrictions = TRUE

	vox_quills_mohawk
		name = "Vox Mohawk"
		icon_state = "vox_mohawk"
		species_allowed = list(SPECIES_VOX)
		apply_restrictions = TRUE

	vox_quills_yasu
		name = "Vox Yasuhiro"
		icon_state = "vox_yasu"
		species_allowed = list(SPECIES_VOX)
		apply_restrictions = TRUE

	vox_quills_horns
		name = "Vox Quorns"
		icon_state = "vox_horns"
		species_allowed = list(SPECIES_VOX)
		apply_restrictions = TRUE

	vox_quills_nights
		name = "Vox Nights"
		icon_state = "vox_nights"
		species_allowed = list(SPECIES_VOX)
		apply_restrictions = TRUE

	vox_quills_surf
		name = "Vox Surf"
		icon_state = "vox_surf"
		species_allowed = list(SPECIES_VOX)
		apply_restrictions = TRUE

	vox_quills_cropped
		name = "Vox Cropped"
		icon_state = "vox_cropped"
		species_allowed = list(SPECIES_VOX)
		apply_restrictions = TRUE

	vox_quills_bald
		name = "Vox Bald"
		icon_state = "vox_bald"
		species_allowed = list(SPECIES_VOX)
		apply_restrictions = TRUE

	vox_quills_ruffhawk
		name = "Vox Ruffhawk"
		icon_state = "vox_ruff_hawk"
		species_allowed = list(SPECIES_VOX)
		apply_restrictions = TRUE

	vox_quills_rows
		name = "Vox Rows"
		icon_state = "vox_rows"
		species_allowed = list(SPECIES_VOX)
		apply_restrictions = TRUE

	vox_quills_mange
		name = "Vox Mange"
		icon_state = "vox_mange"
		species_allowed = list(SPECIES_VOX)
		apply_restrictions = TRUE

	vox_quills_pony
		name = "Vox Pony"
		icon_state = "vox_pony"
		species_allowed = list(SPECIES_VOX)
		apply_restrictions = TRUE

//Cheesewedge things
	sergal_plain
		name = "Sergal Plain"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "serg_plain"
		species_allowed = list(SPECIES_SERGAL)
		apply_restrictions = TRUE

	sergal_medicore
		name = "Sergal Medicore"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "serg_medicore"
		species_allowed = list(SPECIES_SERGAL)
		apply_restrictions = TRUE

	sergal_tapered
		name = "Sergal Tapered"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "serg_tapered"
		species_allowed = list(SPECIES_SERGAL)
		apply_restrictions = TRUE

	sergal_fairytail
		name = "Sergal Fairytail"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "serg_fairytail"
		species_allowed = list(SPECIES_SERGAL)
		apply_restrictions = TRUE

// Vulpa stuffs
	vulp_hair_none
		name = "None"
		icon_state = "bald"
		species_allowed = list(SPECIES_VULPKANIN)
		apply_restrictions = TRUE
		gender = NEUTER

	vulp_hair_kajam
		name = "Kajam"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "kajam"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
		apply_restrictions = TRUE
		gender = NEUTER

	vulp_hair_keid
		name = "Keid"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "keid"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
		apply_restrictions = TRUE
		gender = NEUTER

	vulp_hair_adhara
		name = "Adhara"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "adhara"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
		apply_restrictions = TRUE
		gender = NEUTER

	vulp_hair_kleeia
		name = "Kleeia"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "kleeia"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
		apply_restrictions = TRUE
		gender = NEUTER

	vulp_hair_mizar
		name = "Mizar"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "mizar"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
		apply_restrictions = TRUE
		gender = NEUTER

	vulp_hair_apollo
		name = "Apollo"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "apollo"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
		apply_restrictions = TRUE
		gender = NEUTER

	vulp_hair_belle
		name = "Belle"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "belle"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
		apply_restrictions = TRUE
		gender = NEUTER

	vulp_hair_bun
		name = "Bun"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "bun"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
		apply_restrictions = TRUE
		gender = NEUTER

	vulp_hair_jagged
		name = "Jagged"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "jagged"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
		apply_restrictions = TRUE
		gender = NEUTER

	vulp_hair_curl
		name = "Curl"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "curl"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
		apply_restrictions = TRUE
		gender = NEUTER

	vulp_hair_hawk
		name = "Hawk"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "hawk"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
		apply_restrictions = TRUE
		gender = NEUTER

	vulp_hair_anita
		name = "Anita"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "anita"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
		apply_restrictions = TRUE
		gender = NEUTER

	vulp_hair_short
		name = "Short"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "short"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
		apply_restrictions = TRUE
		gender = NEUTER

	vulp_hair_spike
		name = "Spike"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "spike"
		species_allowed = list(SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_TAJ, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_PROTEAN)
		apply_restrictions = TRUE
		gender = NEUTER

//xeno stuffs
	xeno_head_drone_color
		name = "Drone dome"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "cxeno_drone"
		species_allowed = list(SPECIES_XENOHYBRID)
		gender = NEUTER
// figure this one out for better coloring
	xeno_head_sentinel_color
		name = "Sentinal dome"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "cxeno_sentinel"
		species_allowed = list(SPECIES_XENOHYBRID)
		gender = NEUTER

	xeno_head_queen_color
		name = "Queen dome"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "cxeno_queen"
		species_allowed = list(SPECIES_XENOHYBRID)
		gender = NEUTER

	xeno_head_hunter_color
		name = "Hunter dome"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "cxeno_hunter"
		species_allowed = list(SPECIES_XENOHYBRID)
		gender = NEUTER

	xeno_head_praetorian_color
		name = "Praetorian dome"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "cxeno_praetorian"
		species_allowed = list(SPECIES_XENOHYBRID)
		gender = NEUTER

	xeno_head_hybrid_color1
		name = "Xenohybrid dome 1"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "cxeno_hybrid1"
		species_allowed = list(SPECIES_XENOHYBRID)
		gender = NEUTER
// Shadekin stuffs
	shadekin_hair_short
		name = "Shadekin Short Hair"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "shadekin_short"
		species_allowed = list(SPECIES_SHADEKIN, SPECIES_SHADEKIN_CREW)
		apply_restrictions = TRUE
		gender = NEUTER

	shadekin_hair_poofy
		name = "Shadekin Poofy Hair"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "shadekin_poofy"
		species_allowed = list(SPECIES_SHADEKIN, SPECIES_SHADEKIN_CREW)
		apply_restrictions = TRUE
		gender = NEUTER

	shadekin_hair_long
		name = "Shadekin Long Hair"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "shadekin_long"
		species_allowed = list(SPECIES_SHADEKIN, SPECIES_SHADEKIN_CREW)
		apply_restrictions = TRUE
		gender = NEUTER

	shadekin_hair_rivyr
		name = "Rivyr Hair"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_add = 'icons/mob/human_face_vr_add.dmi'
		icon_state = "shadekin_rivyr"
		ckeys_allowed = list("verysoft")
		species_allowed = list(SPECIES_SHADEKIN, SPECIES_SHADEKIN_CREW)
		apply_restrictions = TRUE
		gender = NEUTER

/datum/sprite_accessory/facial_hair

	taj_sideburns
		name = "Tajaran Sideburns"
		icon_state = "facial_sideburns"
		species_allowed = list(SPECIES_TAJ)
		apply_restrictions = TRUE

	taj_mutton
		name = "Tajaran Mutton"
		icon_state = "facial_mutton"
		species_allowed = list(SPECIES_TAJ)
		apply_restrictions = TRUE

	taj_pencilstache
		name = "Tajaran Pencilstache"
		icon_state = "facial_pencilstache"
		species_allowed = list(SPECIES_TAJ)
		apply_restrictions = TRUE

	taj_moustache
		name = "Tajaran Moustache"
		icon_state = "facial_moustache"
		species_allowed = list(SPECIES_TAJ)
		apply_restrictions = TRUE

	taj_goatee
		name = "Tajaran Goatee"
		icon_state = "facial_goatee"
		species_allowed = list(SPECIES_TAJ)
		apply_restrictions = TRUE

	taj_smallstache
		name = "Tajaran Smallsatche"
		icon_state = "facial_smallstache"
		species_allowed = list(SPECIES_TAJ)
		apply_restrictions = TRUE

// More Vox things

	vox_face_colonel
		name = "Vox Colonel"
		icon_state = "vox_colonel"
		species_allowed = list(SPECIES_VOX)
		apply_restrictions = TRUE

	vox_face_fu
		name = "Quill Fu"
		icon_state = "vox_fu"
		species_allowed = list(SPECIES_VOX)
		apply_restrictions = TRUE

	vox_face_neck
		name = "Neck Quills"
		icon_state = "vox_neck"
		species_allowed = list(SPECIES_VOX)
		apply_restrictions = TRUE

	vox_face_beard
		name = "Quill Beard"
		icon_state = "vox_beard"
		species_allowed = list(SPECIES_VOX)
		apply_restrictions = TRUE

	vox_ruff_beard
		name = "Ruff Beard"
		icon_state = "vox_ruff_beard"
		species_allowed = list(SPECIES_VOX)
		apply_restrictions = TRUE

	vox_shaved_beard
		name = "Vox Shaved"
		icon_state = "vox_bald"
		species_allowed = list(SPECIES_VOX)
		apply_restrictions = TRUE

//unathi horn beards and the like

	una_chinhorn
		name = "Unathi Chin Horn"
		icon_state = "facial_chinhorns"
		species_allowed = list(SPECIES_UNATHI)

	una_hornadorns
		name = "Unathi Horn Adorns"
		icon_state = "facial_hornadorns"
		species_allowed = list(SPECIES_UNATHI)

	una_spinespikes
		name = "Unathi Spine Spikes"
		icon_state = "facial_spikes"
		species_allowed = list(SPECIES_UNATHI)

	una_dorsalfrill
		name = "Unathi Dorsal Frill"
		icon_state = "facial_dorsalfrill"
		species_allowed = list(SPECIES_UNATHI)


//Teshari things
	teshari_beard
		name = "Teshari Beard"
		icon_state = "teshari_chin"
		species_allowed = list(SPECIES_TESHARI)
		apply_restrictions = TRUE
		gender = NEUTER

	teshari_scraggly
		name = "Teshari Scraggly"
		icon_state = "teshari_scraggly"
		species_allowed = list(SPECIES_TESHARI)
		apply_restrictions = TRUE
		gender = NEUTER

	teshari_chops
		name = "Teshari Chops"
		icon_state = "teshari_gap"
		species_allowed = list(SPECIES_TESHARI)
		apply_restrictions = TRUE
		gender = NEUTER

//skin styles - WIP
//going to have to re-integrate this with surgery
//let the icon_state hold an icon preview for now
/datum/sprite_accessory/skin
	icon = 'icons/mob/species/human/body.dmi'

/datum/sprite_accessory/skin/human
	name = "Default human skin"
	icon_state = "default"
	species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN)

/datum/sprite_accessory/skin/human_tatt01
	name = "Tatt01 human skin"
	icon_state = "tatt1"
	icon = 'icons/mob/species/human/tatt1.dmi'
	species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN)

/datum/sprite_accessory/skin/tajaran
	name = "Default tajaran skin"
	icon_state = "default"
	icon = 'icons/mob/species/tajaran/body.dmi'
	species_allowed = list(SPECIES_TAJ)
	apply_restrictions = TRUE

/datum/sprite_accessory/skin/unathi
	name = "Default Unathi skin"
	icon_state = "default"
	icon = 'icons/mob/species/unathi/body.dmi'
	species_allowed = list(SPECIES_UNATHI)

/datum/sprite_accessory/skin/skrell
	name = "Default skrell skin"
	icon_state = "default"
	icon = 'icons/mob/species/skrell/body.dmi'
	species_allowed = list(SPECIES_SKRELL)
