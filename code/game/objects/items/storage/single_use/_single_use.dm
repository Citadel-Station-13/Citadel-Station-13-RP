
/obj/item/storage/single_use
	var/sfx_tear = "rip"
	var/torn_open = FALSE

/obj/item/storage/single_use/object_storage_opened(mob/user)
	if(torn_open)
		return
	torn_open = TRUE

	if(sfx_tear)
		playsound(src, sfx_tear, 50, TRUE, -5)

	user.visible_message(
		SPAN_NOTICE("[user] tears open [src]'s seal."),
		SPAN_NOTICE("You tear open [src]'s seals."),
		SPAN_HEAR("You hear something being torn open."),
	)

	update_icon()

/obj/item/storage/single_use/update_icon_state()
	icon_state = "[base_icon_state || initial(icon_state)][torn_open]"
	return ..()
