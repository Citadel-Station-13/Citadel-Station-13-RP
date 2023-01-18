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
	w_class = ITEMSIZE_TINY
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
	set category = "Object"
	set src in usr

	if (t)
		src.name = text("data disk- '[]'", t)
	else
		src.name = "data disk"
	src.add_fingerprint(usr)
	return

/obj/item/card/data/clown
	name = "\proper the coordinates to clown planet"
	icon_state = "rainbow"
	item_state = "card-id"
	level = 2
	desc = "This card contains coordinates to the fabled Clown Planet. Handle with care."
	function = "teleporter"
	data = "Clown Land"
