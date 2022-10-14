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
/datum/sprite_accessory
	// Ckey of person allowed to use this, if defined.
	var/list/ckeys_allowed = null
	var/apply_restrictions = FALSE		//whether to apply restrictions for specific tails/ears/wings
	var/center = FALSE
	var/dimension_x = 32
	var/dimension_y = 32

	//! emissives
	/// allow emissives
	var/emissives_allowed = TRUE

#warn full shapeshifter tgui panel after this rework it won't be enough to use menu


#warn impl

/datum/sprite_accessory/proc/render_mob_appearance(mob/M, list/colors, )
