/*
	SHOO! GO USE EXAMINE!
*/

#define EXAMINE_PANEL_PADDING "        "

/atom
	var/description_info = null //Helpful blue text.
	var/description_fluff = null //Green text about the atom's fluff, if any exists.
	var/description_antag = null //Malicious red text, for the antags.

//Override these if you need special behaviour for a specific type.
/atom/proc/get_description_info()
	if(description_info)
		return description_info
	return

/atom/proc/get_description_fluff()
	if(description_fluff)
		return description_fluff
	return

/atom/proc/get_description_antag()
	if(description_antag)
		return description_antag
	return

// This one is slightly different, in that it must return a list.
/atom/proc/get_description_interaction(mob/user)
	. = list()

// Quickly adds the boilerplate code to add an image and padding for the image.
/proc/desc_panel_image(icon_state, mob/user)
	if(!(icon_state in description_icons))
		return "UNKNOWN "
	return "[icon2html(description_icons[icon_state], user)][EXAMINE_PANEL_PADDING]" //this is only for tool icon and things

/mob/living/get_description_fluff()
	if(flavor_text) //Get flavor text for the green text.
		return flavor_text
	else //No flavor text?  Try for hardcoded fluff instead.
		return ..()

/mob/living/carbon/human/get_description_fluff()
	return print_flavor_text(0)

/client
	var/list/desc_holder = list()

/client/proc/update_description_holders(mob/user, atom/A, update_antag_info) //user is needed for icon2html
	var/istate = A.icon_state ? A.icon_state : null //needed because apparently mappers don't use subtypes
	desc_holder["name"] = "[icon2html(A, user, istate)][EXAMINE_PANEL_PADDING]<font size='4'>[A.name]</font>"
	desc_holder["desc"] = A.desc //the default examine text.
	desc_holder["atom_info"] = A.get_description_info()
	desc_holder["atom_interaction"] = A.get_description_interaction(user)
	desc_holder["atom_fluff"] = A.get_description_fluff()
	if(!update_antag_info)
		return
	desc_holder["atom_antag"] = A.get_description_antag()

//override examinate verb to update description holders when things are examined
/mob/examinate(atom/A as mob|obj|turf in view())
	. = ..()
	if(. == FALSE)
		client.desc_holder = list()
	else
		var/is_antag = ((mind && mind.special_role) || isobserver(src)) //ghosts don't have minds (plus people can just check the code to see this)
		client.update_description_holders(src, A, is_antag)

/mob/proc/update_examine_panel(atom/A)
	if(!A)
		client.desc_holder = list()
	else if(client)
		var/is_antag = ((mind && mind.special_role) || isobserver(src)) //ghosts don't have minds
		client.update_description_holders(src, A, is_antag)
