/*
////////////////////////////
/  =--------------------=  /
/  == Wing Definitions ==  /
/  =--------------------=  /
////////////////////////////
*/
/datum/sprite_accessory_meta/wing
	name = "You should not see this..."
	icon = 'icons/mob/sprite_accessories/wings.dmi'
	dimension_x = 64
	do_colouration = 0 //Set to 1 to enable coloration using the tail color.

	color_blend_mode = ICON_ADD // Only appliciable if do_coloration = 1
	var/extra_overlay // Icon state of an additional overlay to blend in.
	var/extra_overlay2
	var/clothing_can_hide = 1 // If true, clothing with HIDETAIL hides it. If the clothing is bulky enough to hide a tail, it should also hide wings.
	var/ani_state // State when flapping/animated
	var/spr_state // State when spreading wings w/o anim
	var/extra_overlay_w // Flapping state for extra overlay
	var/extra_overlay2_w

/datum/sprite_accessory_meta/wing/bat_black
	name = "bat wings, black"
	desc = ""
	icon_state = "bat-black"

/datum/sprite_accessory_meta/wing/bat_color
	name = "bat wings, colorable"
	desc = ""
	icon_state = "bat-color"
	do_colouration = 1

/datum/sprite_accessory_meta/wing/bat_red
	name = "bat wings, red"
	desc = ""
	icon_state = "bat-red"

/datum/sprite_accessory_meta/wing/beewings
	name = "bee wings"
	desc = ""
	icon_state = "beewings"

/datum/sprite_accessory_meta/wing/cyberdoe
	name = "Cyber doe wing"
	desc = ""
	icon_state = "cyberdoe_s"
	do_colouration = 0

/datum/sprite_accessory_meta/wing/cyberdragon
	name = "Cyber dragon wing (colorable)"
	desc = ""
	icon_state = "cyberdragon_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/wing/cyberdragon_red
	name = "Cyber dragon wing (red)"
	desc = ""
	icon_state = "cyberdragon_red_s"
	do_colouration = 0

/datum/sprite_accessory_meta/wing/drago_wing
	name = "Cybernetic Dragon wings"
	desc = ""
	icon_state = "drago_wing"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "drago_wing_2"

/datum/sprite_accessory_meta/wing/dragonfly
	name = "dragonfly"
	desc = ""
	icon_state = "dragonfly"
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/wing/feathered
	name = "feathered wings (colorable)"
	desc = ""
	icon_state = "feathered"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/wing/feathered_medium
	name = "medium feathered wings (colorable)" // Keekenox made these feathery things with a little bit more shape to them than the other wings. They are medium sized wing boys.
	desc = ""
	icon_state = "feathered2"
	spr_state = "feathered2_spr"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/wing/feathered_large //Made by Natje!
	name = "large feathered wings (colorable)"
	desc = ""
	icon_state = "feathered3"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/wing/harpywings
	name = "harpy wings (colorable)"
	desc = ""
	icon_state = "harpywings"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/wing/Harpywings_alt
	name = "harpy wings alt, archeopteryx"
	desc = ""
	icon_state = "Harpywings_alt"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "Neckfur"
	extra_overlay2 = "Harpywings_altmarkings"

/datum/sprite_accessory_meta/wing/harpywings_alt
	name = "harpy wings alt, archeopteryx"
	desc = ""
	icon_state = "harpywings_alt"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "harpywings_altmarkings"

/datum/sprite_accessory_meta/wing/harpywings_alt_neckfur
	name = "harpy wings alt, archeopteryx & neckfur"
	desc = ""
	icon_state = "harpywings_alt"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "harpywings_altmarkings"
	extra_overlay2 = "neckfur"

/datum/sprite_accessory_meta/wing/Harpywings_Bat
	name = "harpy wings, bat"
	desc = ""
	icon_state = "Harpywings_Bat"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "Neckfur"
	extra_overlay2 = "Harpywings_BatMarkings"

/datum/sprite_accessory_meta/wing/harpywings_bat
	name = "harpy wings, bat"
	desc = ""
	icon_state = "harpywings_bat"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "harpywings_batmarkings"

/datum/sprite_accessory_meta/wing/harpywings_bat_neckfur
	name = "harpy wings, bat & neckfur"
	desc = ""
	icon_state = "harpywings_bat"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "harpywings_batmarkings"
	extra_overlay2 = "neckfur"

/datum/sprite_accessory_meta/wing/leafeon
	name = "Leaf Offshoots"
	desc = ""
	icon_state = "leaf_markings"

/datum/sprite_accessory_meta/wing/liquidfirefly_gazer //I g-guess this could be considered wings?
	name = "gazer eyestalks"
	desc = ""
	icon_state = "liquidfirefly-eyestalks"
	//ckeys_allowed = list("liquidfirefly","seiga") //At request.

/datum/sprite_accessory_meta/wing/mantis_arms //Same rationale as spider legs.
	name = "mantis arms"
	desc = ""
	icon_state = "mantis-arms"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/wing/mantis_arms_saturated
	name = "mantis arms (saturated)"
	desc = ""
	icon_state = "mantis-arms_saturated"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/wing/neckfur
	name = "neck fur"
	desc = ""
	icon_state = "neckfur"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/wing/nevrean
	name = "nevrean wings/fantail"
	desc = ""
	icon_state = "nevrean_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/wing/robo
	name = "Robotic Wings"
	desc = ""
	icon_state = "Drago_wing"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/wing/sepulchre_c_yw
	name = "demon wings (colorable)"
	desc = ""
	icon_state = "sepulchre_wingsc"
	do_colouration = 1

/datum/sprite_accessory_meta/wing/snag
	name = "xenomorph backplate"
	desc = ""
	icon_state = "snag-backplate"

/datum/sprite_accessory_meta/wing/spider_legs //Not really /WINGS/ but they protrude from the back, kinda. Might as well have them here.
	name = "spider legs"
	desc = ""
	icon_state = "spider-legs"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/wing/succubus
	name = "succubus wings, black"
	desc = ""
	icon_state = "succubus-black"

/datum/sprite_accessory_meta/wing/succubus_purple
	name = "succubus wings, purple"
	desc = ""
	icon_state = "succubus-purple"

/datum/sprite_accessory_meta/wing/succubus_red
	name = "succubus wings, red"
	desc = ""
	icon_state = "succubus-red"

//Moth Wings (We have a lot!)
/datum/sprite_accessory_meta/wing/moth
	name = "moth wings"
	desc = ""
	icon_state = "moth"
	clothing_can_hide = FALSE

/datum/sprite_accessory_meta/wing/mothc
	name = "moth wings (colorable)"
	desc = ""
	icon_state = "moth"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory_meta/wing/moth_atlas
	name = "atlas moth wings"
	desc = ""
	icon_state = "moth_atlas"

/datum/sprite_accessory_meta/wing/moth_burnt
	name = "burnt moth wings"
	desc = ""
	icon_state = "moth_burnt"

/datum/sprite_accessory_meta/wing/moth_deathhead
	name = "death's-head hawkmoth wings"
	desc = ""
	icon_state = "moth_deathhead"

/datum/sprite_accessory_meta/wing/moth_firewatch
	name = "firewatch moth wings"
	desc = ""
	icon_state = "moth_firewatch"
	front_behind_system = TRUE

/datum/sprite_accessory_meta/wing/moth_full
	name = "moth antenna and wings"
	desc = ""
	icon_state = "moth_full"

/datum/sprite_accessory_meta/wing/moth_gothic
	name = "gothic moth wings"
	desc = ""
	icon_state = "moth_gothic"

/datum/sprite_accessory_meta/wing/moth_jungle
	name = "jungle moth wings"
	desc = ""
	icon_state = "moth_jungle"

/datum/sprite_accessory_meta/wing/moth_lover
	name = "lover moth wings"
	desc = ""
	icon_state = "moth_lover"

/datum/sprite_accessory_meta/wing/moth_luna
	name = "luna moth wings"
	desc = ""
	icon_state = "moth_luna"

/datum/sprite_accessory_meta/wing/moth_monarch
	name = "monarch moth wings"
	desc = ""
	icon_state = "moth_monarch"

/datum/sprite_accessory_meta/wing/moth_moonfly
	name = "moonfly moth wings"
	desc = ""
	icon_state = "moth_moonfly"

/datum/sprite_accessory_meta/wing/moth_oakworm
	name = "oakworm moth wings"
	desc = ""
	icon_state = "moth_oakworm"

/datum/sprite_accessory_meta/wing/moth_plain
	name = "plain moth wings"
	desc = ""
	icon_state = "moth_plain"

/datum/sprite_accessory_meta/wing/moth_poison
	name = "poison moth wings"
	desc = ""
	icon_state = "moth_poison"

/datum/sprite_accessory_meta/wing/moth_ragged
	name = "ragged moth wings"
	desc = ""
	icon_state = "moth_ragged"

/datum/sprite_accessory_meta/wing/moth_red
	name = "red moth wings"
	desc = ""
	icon_state = "moth_red"

/datum/sprite_accessory_meta/wing/moth_royal
	name = "royal moth wings"
	desc = ""
	icon_state = "moth_royal"

/datum/sprite_accessory_meta/wing/moth_snowy
	name = "snowy moth wings"
	desc = ""
	icon_state = "moth_snowy"

/datum/sprite_accessory_meta/wing/moth_white
	name = "white moth wings"
	desc = ""
	icon_state = "moth_white"

/datum/sprite_accessory_meta/wing/moth_whitefly
	name = "whitefly moth wings"
	desc = ""
	icon_state = "moth_whitefly"

/datum/sprite_accessory_meta/wing/moth_witchwing
	name = "witchwing moth wings"
	desc = ""
	icon_state = "moth_witchwing"
