/*
 * Trinket Box - READDING SOON
 */
/obj/item/storage/trinketbox
	name = "trinket box"
	desc = "A box that can hold small trinkets, such as a ring."
	icon = 'icons/obj/items.dmi'
	icon_state = "trinketbox"
	var/open = 0
	max_items = 1
	insertion_whitelist = list(
		/obj/item/clothing/gloves/ring,
		/obj/item/coin,
		/obj/item/clothing/accessory/medal
		)
	var/open_state
	var/closed_state

/obj/item/storage/trinketbox/update_icon()
	cut_overlays()
	. = ..()
	if(open)
		icon_state = open_state

		if(contents.len >= 1)
			var/contained_image = null
			if(istype(contents[1],  /obj/item/clothing/gloves/ring))
				contained_image = "ring_trinket"
			else if(istype(contents[1], /obj/item/coin))
				contained_image = "coin_trinket"
			else if(istype(contents[1], /obj/item/clothing/accessory/medal))
				contained_image = "medal_trinket"
			if(contained_image)
				add_overlay(contained_image)
	else
		icon_state = closed_state

/obj/item/storage/trinketbox/Initialize(mapload)
	if(!open_state)
		open_state = "[initial(icon_state)]_open"
	if(!closed_state)
		closed_state = "[initial(icon_state)]"
	. = ..()

/obj/item/storage/trinketbox/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	open = !open
	update_icon()
	..()

/obj/item/storage/trinketbox/examine(mob/user, dist)
	. = ..()
	if(open && contents.len)
		var/display_item = contents[1]
		. += "<span class='notice'>\The [src] contains \the [display_item]!</span>"
