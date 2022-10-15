/**
 * Earmuffs
 */
/obj/item/clothing/ears/earmuffs
	name = "earmuffs"
	desc = "Protects your hearing from loud noises, and quiet ones as well."
	slot_flags = SLOT_EARS | SLOT_TWOEARS
	ear_protection = 2

	worn_render_flags = NONE
	worn_bodytypes = BODYTYPE_TESHARI

	icon = 'icons/modules/clothing/ears/earmuffs.dmi'
	icon_state   = "earmuffs"
	inhand_state = "earmuffs"

/**
 * Headphones
 */
/obj/item/clothing/ears/earmuffs/headphones
	name = "headphones"
	desc = "Unce unce unce unce."
	slot_flags = SLOT_EARS
	ear_protection = 0
	var/headphones_on = FALSE

	worn_render_flags = NONE
	worn_bodytypes = BODYTYPE_TESHARI

	icon = 'icons/modules/clothing/ears/headphones.dmi'
	icon_state   = "headphones-off"
	inhand_state = "headphones-off"

	base_icon_state = "headphones"
	base_item_state = "headphones"

/obj/item/clothing/ears/earmuffs/headphones/verb/togglemusic()
	set name = "Toggle Headphone Music"
	set category = "Object"
	set src in usr

	if(!istype(usr, /mob/living))
		return
	if(usr.stat)
		return

	headphones_on = !headphones_on

	icon_state   = "[base_icon_state]-[headphones_on ? "on" : "off"]"
	inhand_state = "[base_item_state]-[headphones_on ? "on" : "off"]"

	to_chat(usr, SPAN_NOTICE("[headphones_on ? "You turn the music on." : "You turn the music off."]"))
	update_worn_icon()

/obj/item/clothing/ears/earmuffs/headphones/AltClick(mob/user)
	if(!Adjacent(user))
		return
	else if(!headphones_on)
		togglemusic()
	else
		togglemusic()
