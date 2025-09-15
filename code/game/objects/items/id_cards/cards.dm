/* Cards
 * Contains:
 *		DATA CARD
 *		ID CARD
 *		FINGERPRINT CARD HOLDER
 *		FINGERPRINT CARD
 */

/*
 * DATA CARDS - Used for the teleporter
 */
/obj/item/card
	name = "card"
	desc = "Does card things."
	icon = 'icons/obj/card_cit.dmi'
	icon_state = "generic"
	w_class = WEIGHT_CLASS_TINY
	slot_flags = SLOT_ID | SLOT_EARS
	var/associated_account_number = 0

	var/list/initial_sprite_stack = list("")
	var/base_icon = 'icons/obj/card_cit.dmi'
	var/list/sprite_stack

	var/list/files = list(  )
	pickup_sound = 'sound/items/pickup/card.ogg'

/obj/item/card/Initialize(mapload)
	. = ..()
	initial_sprite_stack = typelist(NAMEOF(src, initial_sprite_stack), initial_sprite_stack)
	if(isnull(base_icon_state))
		base_icon_state = icon_state
	reset_icon()

/obj/item/card/proc/reset_icon()
	sprite_stack = initial_sprite_stack.Copy()
	update_icon()

/obj/item/card/update_icon()
	cut_overlays()
	. = ..()
	for(var/state in sprite_stack)
		if(state == "")
			state = base_icon_state
		add_overlay(state)

/obj/item/card/data
	name = "data disk"
	desc = "A disk of data."
	icon_state = "data"
	var/function = "storage"
	var/data = "null"
	var/special = null
	item_state = "card-id"
	drop_sound = 'sound/items/drop/disk.ogg'
	pickup_sound = 'sound/items/pickup/disk.ogg'

/obj/item/card/data/verb/label(t as text)
	set name = "Label Disk"
	set category = VERB_CATEGORY_OBJECT
	set src in usr

	if (t)
		name = "data disk- '[t]'"
	else
		name = "data disk"
	add_fingerprint(usr)
	return

/obj/item/card/data/clown
	name = "\proper the coordinates to clown planet"
	icon_state = "rainbow"
	item_state = "card-id"
	desc = "This card contains coordinates to the fabled Clown Planet. Handle with care."
	function = "teleporter"
	data = "Clown Land"

/// FLUFF PERMIT

/obj/item/card_fluff
	name = "fluff card"
	desc = "A tiny plaque of plastic. Purely decorative?"
	description_fluff = "This permit was not issued by any branch of Nanotrasen, and as such it is not formally recognized at any Nanotrasen-operated installations. The bearer is not - under any circumstances - entitled to ownership of any items or allowed to perform any acts that would normally be restricted or illegal for their current position, regardless of what they or this permit may claim."
	icon = 'icons/obj/card_fluff.dmi'
	item_state = "card-id"
	item_state_slots = list(
		SLOT_ID_WORN_ID = "id"
	)
	w_class = WEIGHT_CLASS_TINY
	slot_flags = SLOT_EARS

	var/list/initial_sprite_stack = list("")
	var/base_icon = 'icons/obj/card_fluff.dmi'
	var/list/sprite_stack = list("")

	drop_sound = 'sound/items/drop/card.ogg'
	pickup_sound = 'sound/items/pickup/card.ogg'

/obj/item/card_fluff/proc/reset_icon()
	sprite_stack = list("")
	update_icon()

/obj/item/card_fluff/update_icon()
	. = ..()
	if(!sprite_stack || !istype(sprite_stack) || sprite_stack == list(""))
		icon = base_icon
		icon_state = initial(icon_state)

	var/icon/I = null
	for(var/iconstate in sprite_stack)
		if(!iconstate)
			iconstate = icon_state
		if(I)
			var/icon/IC = new(base_icon, iconstate)
			I.Blend(IC, ICON_OVERLAY)
		else
			I = new/icon(base_icon, iconstate)
	if(I)
		icon = I

/obj/item/card_fluff/attack_self(mob/user, datum/event_args/actor/actor)

	var/choice = tgui_input_list(usr, "What element would you like to customize?", "Customize Card", list("Band","Stamp","Reset"))
	if(!choice) return

	if(choice == "Band")
		var/bandchoice = tgui_input_list(usr, "Select colour", "Band colour", list("red","orange","green","dark green","medical blue","dark blue","purple","tan","pink","gold","white","black"))
		if(!bandchoice) return

		if(bandchoice == "red")
			sprite_stack.Add("bar-red")
		else if(bandchoice == "orange")
			sprite_stack.Add("bar-orange")
		else if(bandchoice == "green")
			sprite_stack.Add("bar-green")
		else if(bandchoice == "dark green")
			sprite_stack.Add("bar-darkgreen")
		else if(bandchoice == "medical blue")
			sprite_stack.Add("bar-medblue")
		else if(bandchoice == "dark blue")
			sprite_stack.Add("bar-blue")
		else if(bandchoice == "purple")
			sprite_stack.Add("bar-purple")
		else if(bandchoice == "ran")
			sprite_stack.Add("bar-tan")
		else if(bandchoice == "pink")
			sprite_stack.Add("bar-pink")
		else if(bandchoice == "gold")
			sprite_stack.Add("bar-gold")
		else if(bandchoice == "white")
			sprite_stack.Add("bar-white")
		else if(bandchoice == "black")
			sprite_stack.Add("bar-black")

		update_icon()
		return
	else if(choice == "Stamp")
		var/stampchoice = tgui_input_list(usr, "Select image", "Stamp image", list("ship","cross","big ears","shield","circle-cross","target","smile","frown","peace","exclamation"))
		if(!stampchoice) return

		if(stampchoice == "ship")
			sprite_stack.Add("stamp-starship")
		else if(stampchoice == "cross")
			sprite_stack.Add("stamp-cross")
		else if(stampchoice == "big ears")
			sprite_stack.Add("stamp-bigears")	//get 'em outta the caption, wiseguy!!
		else if(stampchoice == "shield")
			sprite_stack.Add("stamp-shield")
		else if(stampchoice == "circle-cross")
			sprite_stack.Add("stamp-circlecross")
		else if(stampchoice == "target")
			sprite_stack.Add("stamp-target")
		else if(stampchoice == "smile")
			sprite_stack.Add("stamp-smile")
		else if(stampchoice == "frown")
			sprite_stack.Add("stamp-frown")
		else if(stampchoice == "peace")
			sprite_stack.Add("stamp-peace")
		else if(stampchoice == "exclamation")
			sprite_stack.Add("stamp-exclaim")

		update_icon()
		return
	else if(choice == "Reset")
		reset_icon()
		return
	return
