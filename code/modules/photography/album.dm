// todo: refactor everything for persistence

/obj/item/storage/photo_album
	name = "Photo album"
	icon = 'icons/obj/items.dmi'
	icon_state = "album"
	item_state = "briefcase"
	can_hold = list(/obj/item/photo)

/obj/item/storage/photo_album/OnMouseDropLegacy(obj/over_object as obj)
	if((istype(usr, /mob/living/carbon/human)))
		if(!( istype(over_object, /atom/movable/screen) ))
			return ..()
		playsound(loc, "rustle", 50, 1, -5)
		if(over_object == usr && in_range(src, usr) || usr.contents.Find(src))
			if(usr.s_active)
				usr.s_active.close(usr)
			show_to(usr)
