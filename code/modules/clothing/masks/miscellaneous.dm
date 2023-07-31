/obj/item/clothing/mask/muzzle
	name = "muzzle"
	desc = "To stop that awful noise."
	icon_state = "muzzle"
	body_cover_flags = FACE
	w_class = ITEMSIZE_SMALL
	gas_transfer_coefficient = 0.90
	voicechange = 1

/obj/item/clothing/mask/muzzle/tape
	name = "length of tape"
	desc = "It's a robust DIY muzzle!"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "tape_cross"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = null, SLOT_ID_LEFT_HAND = null)
	w_class = ITEMSIZE_TINY

/obj/item/clothing/mask/muzzle/Initialize(mapload)
	. = ..()
	say_messages = list("Mmfph!", "Mmmf mrrfff!", "Mmmf mnnf!")
	say_verbs = list("mumbles", "says")

// Clumsy folks can't take the mask off themselves.
/obj/item/clothing/mask/muzzle/attack_hand(mob/user, list/params)
	if(user.item_by_slot(SLOT_ID_MASK) == src && !user.IsAdvancedToolUser())
		return 0
	..()
/obj/item/clothing/mask/surgical
	name = "sterile mask"
	desc = "A sterile mask designed to help prevent the spread of diseases."
	icon_state = "sterile"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "sterile", SLOT_ID_LEFT_HAND = "sterile")
	w_class = ITEMSIZE_SMALL
	body_cover_flags = FACE
	clothing_flags = FLEXIBLEMATERIAL
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.01
	armor_type = /datum/armor/mask/surgical
	var/hanging = 0

/obj/item/clothing/mask/surgical/proc/adjust_mask(mob_user)
	if(!CHECK_MOBILITY(usr, MOBILITY_CAN_USE))
		src.hanging = !src.hanging
		if (src.hanging)
			gas_transfer_coefficient = 1
			body_cover_flags = body_cover_flags & ~FACE
			set_armor(/datum/armor/none)
			icon_state = "steriledown"
			to_chat(usr, "You pull the mask below your chin.")
		else
			gas_transfer_coefficient = initial(gas_transfer_coefficient)
			body_cover_flags = initial(body_cover_flags)
			icon_state = initial(icon_state)
			reset_armor()
			to_chat(usr, "You pull the mask up to cover your face.")
		update_worn_icon()

/obj/item/clothing/mask/surgical/verb/toggle()
	set category = "Object"
	set name = "Adjust mask"
	set src in usr

	adjust_mask(usr)

/obj/item/clothing/mask/fakemoustache
	name = "fake moustache"
	desc = "Warning: moustache is fake."
	icon_state = "fake-moustache"
	inv_hide_flags = HIDEFACE
	w_class = ITEMSIZE_SMALL
	body_cover_flags = 0

/obj/item/clothing/mask/snorkel
	name = "Snorkel"
	desc = "For the Swimming Savant."
	icon_state = "snorkel"
	inv_hide_flags = HIDEFACE
	body_cover_flags = 0

//scarves (fit in in mask slot)
//None of these actually have on-mob sprites...
/obj/item/clothing/mask/bluescarf
	name = "blue neck scarf"
	desc = "A blue neck scarf."
	icon_state = "blueneckscarf"
	body_cover_flags = FACE
	clothing_flags = FLEXIBLEMATERIAL
	w_class = ITEMSIZE_SMALL
	gas_transfer_coefficient = 0.90

/obj/item/clothing/mask/redscarf
	name = "red scarf"
	desc = "A red and white checkered neck scarf."
	icon_state = "redwhite_scarf"
	body_cover_flags = FACE
	clothing_flags = FLEXIBLEMATERIAL
	w_class = ITEMSIZE_SMALL
	gas_transfer_coefficient = 0.90

/obj/item/clothing/mask/greenscarf
	name = "green scarf"
	desc = "A green neck scarf."
	icon_state = "green_scarf"
	body_cover_flags = FACE
	clothing_flags = FLEXIBLEMATERIAL
	w_class = ITEMSIZE_SMALL
	gas_transfer_coefficient = 0.90

/obj/item/clothing/mask/ninjascarf
	name = "ninja scarf"
	desc = "A stealthy, dark scarf."
	icon_state = "ninja_scarf"
	body_cover_flags = FACE
	clothing_flags = FLEXIBLEMATERIAL
	w_class = ITEMSIZE_SMALL
	gas_transfer_coefficient = 0.90
	siemens_coefficient = 0

//Nock Masks?
/obj/item/clothing/mask/nock_scarab
	name = "nock mask (blue, scarab)"
	desc = "To Nock followers, masks symbolize rebirth and a new persona. Damaging the wearer's mask is generally considered an attack on their person itself."
	icon_state = "nock_scarab"
	w_class = ITEMSIZE_SMALL
	body_cover_flags = HEAD|FACE

/obj/item/clothing/mask/nock_demon
	name = "nock mask (purple, demon)"
	desc = "To Nock followers, masks symbolize rebirth and a new persona. Damaging the wearer's mask is generally considered an attack on their person itself."
	icon_state = "nock_demon"
	w_class = ITEMSIZE_SMALL
	body_cover_flags = HEAD|FACE

/obj/item/clothing/mask/nock_life
	name = "nock mask (green, life)"
	desc = "To Nock followers, masks symbolize rebirth and a new persona. Damaging the wearer's mask is generally considered an attack on their person itself."
	icon_state = "nock_life"
	w_class = ITEMSIZE_SMALL
	body_cover_flags = HEAD|FACE

/obj/item/clothing/mask/nock_ornate
	name = "nock mask (red, ornate)"
	desc = "To Nock followers, masks symbolize rebirth and a new persona. Damaging the wearer's mask is generally considered an attack on their person itself."
	icon_state = "nock_ornate"
	w_class = ITEMSIZE_SMALL
	body_cover_flags = HEAD|FACE

/obj/item/clothing/mask/horsehead/Initialize(mapload)
	. = ..()
	// The horse mask doesn't cause voice changes by default, the wizard spell changes the flag as necessary
	say_messages = list("NEEIIGGGHHHH!", "NEEEIIIIGHH!", "NEIIIGGHH!", "HAAWWWWW!", "HAAAWWW!")
	say_verbs = list("whinnies", "neighs", "says")

/obj/item/clothing/mask/ai
	name = "camera MIU"
	desc = "Allows for direct mental connection to accessible camera networks."
	icon_state = "s-ninja"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "mime", SLOT_ID_LEFT_HAND = "mime")
	inv_hide_flags = HIDEFACE
	body_cover_flags = 0
	var/mob/observer/eye/aiEye/eye

/obj/item/clothing/mask/ai/Initialize(mapload)
	. = ..()
	eye = new(src)

/obj/item/clothing/mask/ai/equipped(var/mob/user, var/slot)
	..(user, slot)
	if(slot == SLOT_ID_MASK)
		eye.owner = user
		user.eyeobj = eye

		for(var/datum/chunk/c in eye.visibleChunks)
			c.remove(eye)
		eye.setLoc(user)

/obj/item/clothing/mask/ai/dropped(mob/user, flags, atom/newLoc)
	..()
	if(eye.owner == user)
		for(var/datum/chunk/c in eye.visibleChunks)
			c.remove(eye)

		eye.owner.eyeobj = null
		eye.owner = null

//Samurai
/obj/item/clothing/mask/samurai
	name = "menpo"
	desc = "Antique facial armor hailing from old Earth. Designed to protect against sword blows and potentially arrows. This version has been carefully retrofitted to provide air."
	icon_state = "menpo"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "bandblack", SLOT_ID_LEFT_HAND = "bandblack")
	clothing_flags = ALLOWINTERNALS|FLEXIBLEMATERIAL
	body_cover_flags = FACE
	w_class = ITEMSIZE_SMALL
	gas_transfer_coefficient = 0.10
	permeability_coefficient = 0.50

/obj/item/clothing/mask/samurai/colorable
	name = "menpo (colorable)"
	icon_state = "menpo_colorable"

//Bandanas
/obj/item/clothing/mask/bandana
	name = "black bandana"
	desc = "A fine black bandana with nanotech lining. Can be worn on the head or face."
	w_class = ITEMSIZE_TINY
	inv_hide_flags = HIDEFACE
	slot_flags = SLOT_MASK|SLOT_HEAD
	body_cover_flags = FACE
	icon_state = "bandblack"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "bandblack", SLOT_ID_LEFT_HAND = "bandblack")

/obj/item/clothing/mask/bandana/attack_self(mob/user)
	. = ..()
	if(src.icon_state == initial(icon_state))
		src.icon_state = "[icon_state]_up"
		to_chat(user, "You fold the bandana into a cap.")
		body_cover_flags = HEAD
	else
		src.icon_state = initial(icon_state)
		to_chat(user, "You untie the bandana and spread it out.")
		slot_flags = "[initial(slot_flags)]"
		body_cover_flags = "[initial(body_cover_flags)]"
	update_worn_icon()	//so our mob-overlays update

/*
/obj/item/clothing/mask/bandana/equipped(var/mob/user, var/slot)
	switch(slot)
		if(SLOT_ID_MASK) //Mask is the default for all the settings
			inv_hide_flags = initial(inv_hide_flags)
			body_cover_flags = initial(body_cover_flags)
			icon_state = initial(icon_state)

		if(SLOT_ID_HEAD)
			inv_hide_flags = 0
			body_cover_flags = HEAD
			icon_state = "[initial(icon_state)]_up"
	return ..()
*/

/obj/item/clothing/mask/bandana/red
	name = "red bandana"
	desc = "A fine red bandana with nanotech lining. Can be worn on the head or face."
	icon_state = "bandred"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "bandred", SLOT_ID_LEFT_HAND = "bandred")

/obj/item/clothing/mask/bandana/blue
	name = "blue bandana"
	desc = "A fine blue bandana with nanotech lining. Can be worn on the head or face."
	icon_state = "bandblue"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "bandblue", SLOT_ID_LEFT_HAND = "bandblue")

/obj/item/clothing/mask/bandana/green
	name = "green bandana"
	desc = "A fine green bandana with nanotech lining. Can be worn on the head or face."
	icon_state = "bandgreen"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "bandgreen", SLOT_ID_LEFT_HAND = "bandgreen")

/obj/item/clothing/mask/bandana/gold
	name = "gold bandana"
	desc = "A fine gold bandana with nanotech lining. Can be worn on the head or face."
	icon_state = "bandgold"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "bandgold", SLOT_ID_LEFT_HAND = "bandgold")

/obj/item/clothing/mask/bandana/skull
	name = "skull bandana"
	desc = "A fine black bandana with nanotech lining and a skull emblem. Can be worn on the head or face."
	icon_state = "bandskull"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "bandskull", SLOT_ID_LEFT_HAND = "bandskull")

/obj/item/clothing/mask/paper
	name = "paper mask"
	desc = "A neat, circular mask made out of paper."
	icon_state = "plainmask"
	inv_hide_flags = HIDEEARS|HIDEEYES|HIDEFACE

/obj/item/clothing/mask/paper/attack_self(mob/user)
	. = ..()
	if(.)
		return
	reskin_paper_mask(user)

/obj/item/clothing/mask/paper/proc/reskin_paper_mask(mob/living/L)
	var/obj/item/paper_mask
	var/list/paper_mask_list = subtypesof(/obj/item/clothing/mask/paper)
	var/list/display_names = list()
	var/list/paper_mask_icons = list()
	for(var/V in paper_mask_list)
		var/obj/item/clothing/mask/paper/masktype = V
		if (V)
			display_names[initial(masktype.name)] = masktype
			paper_mask_icons += list(initial(masktype.name) = image(icon = initial(masktype.icon), icon_state = initial(masktype.icon_state)))

	paper_mask_icons = sortList(paper_mask_icons)

	var/choice = show_radial_menu(L, src , paper_mask_icons, custom_check = CALLBACK(src, PROC_REF(check_menu), L), radius = 42, require_near = TRUE)
	if(!choice || !check_menu(L))
		return

	var/A = display_names[choice] // This needs to be on a separate var as list member access is not allowed for new
	paper_mask = new A

	if(paper_mask)
		qdel(src)
		L.put_in_active_hand(paper_mask)

/obj/item/clothing/mask/paper/proc/check_menu(mob/user)
	if(!istype(user))
		return FALSE
	if(QDELETED(src))
		return FALSE
	if(user.incapacitated())
		return FALSE
	return TRUE

/obj/item/clothing/mask/paper/blank
	name = "blank paper mask"
	icon_state = "plainmask"

/obj/item/clothing/mask/paper/neutral
	name = "neutral paper mask"
	icon_state = "neutralmask"

/obj/item/clothing/mask/paper/eye
	name = "eye paper mask"
	icon_state = "eyemask"

/obj/item/clothing/mask/paper/sleeping
	name = "sleeping paper mask"
	icon_state = "sleepingmask"

/obj/item/clothing/mask/paper/heart
	name = "heart paper mask"
	icon_state = "heartmask"

/obj/item/clothing/mask/paper/core
	name = "core paper mask"
	icon_state = "coremask"

/obj/item/clothing/mask/paper/plus
	name = "plus paper mask"
	icon_state = "plusmask"

/obj/item/clothing/mask/paper/square
	name = "square paper mask"
	icon_state = "squaremask"

/obj/item/clothing/mask/paper/bullseye
	name = "bullseye paper mask"
	icon_state = "bullseyemask"

/obj/item/clothing/mask/paper/vertical
	name = "vertical paper mask"
	icon_state = "verticalmask"

/obj/item/clothing/mask/paper/horizontal
	name = "horizontal paper mask"
	icon_state = "horizontalmask"

/obj/item/clothing/mask/paper/x
	name = "x paper mask"
	icon_state = "xmask"

/obj/item/clothing/mask/paper/bug
	name = "bug paper mask"
	icon_state = "bugmask"

/obj/item/clothing/mask/paper/double
	name = "double paper mask"
	icon_state = "doublemask"

/obj/item/clothing/mask/paper/mark
	name = "mark paper mask"
	icon_state = "markmask"

/obj/item/clothing/mask/skull
	name = "totemic skull mask"
	desc = "This bleached skull has been fitted with a band allowing it to be worn. Whether the foe was yours, or another's, you do feel a little more intimidating with this on."
	icon_state = "skull"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "beret_white", SLOT_ID_LEFT_HAND = "beret_white")
	body_cover_flags = 0
	inv_hide_flags = 0
