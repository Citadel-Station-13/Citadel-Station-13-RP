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
/  == Alien Style Definitions ==  /
/  =---------------------------=  /
///////////////////////////////////
*/

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
