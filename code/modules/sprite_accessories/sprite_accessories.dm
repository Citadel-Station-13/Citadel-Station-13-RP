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

/datum/sprite_accessory_meta
	/// Whether or not the accessory can be affected by colouration.
	var/do_colouration = 1
	var/color_blend_mode = ICON_MULTIPLY	// If checked.

/*
	Hello and welcome to VOREStation sprite_accessories: For a more general overview
	please read sprite_accessories.dm. This file is for ears and tails.
	This is intended to be friendly for people with little to no actual coding experience.
	!!WARNING!!: changing existing accessory information can be VERY hazardous to savefiles,
	to the point where you may completely corrupt a server's savefiles. Please refrain
	from doing this unless you absolutely know what you are doing, and have defined a
	conversion in savefile.dm
*/

// Add Additional variable onto sprite_accessory
/datum/sprite_accessory_meta
	var/apply_restrictions = FALSE		//whether to apply restrictions for specific tails/ears/wings


#warn full shapeshifter tgui panel after this rework it won't be enough to use menu


#warn impl
