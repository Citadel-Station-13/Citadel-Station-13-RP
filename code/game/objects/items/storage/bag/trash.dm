/obj/item/storage/bag/trash
	name = "trash bag"
	desc = "It's the heavy-duty black polymer kind. Time to take out the trash!"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "trashbag"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "trashbag", SLOT_ID_LEFT_HAND = "trashbag")
	drop_sound = 'sound/items/drop/wrapper.ogg'
	pickup_sound = 'sound/items/pickup/wrapper.ogg'

	w_class = WEIGHT_CLASS_SMALL
	max_single_weight_class = WEIGHT_CLASS_NORMAL
	max_combined_volume = WEIGHT_VOLUME_SMALL * 48

/obj/item/storage/bag/trash/initialize_storage()
	. = ..()
	obj_storage.update_icon_on_item_change = TRUE
	obj_storage.limited_random_access_amount = 8
	obj_storage.limited_random_access_total_weight_volume = WEIGHT_VOLUME_NORMAL * 3
	// needed for LRA to work
	obj_storage.ui_force_slot_mode = TRUE

/obj/item/storage/bag/trash/update_icon_state()
	switch(w_class)
		if(3)
			icon_state = "[initial(icon_state)]1"
		if(4)
			icon_state = "[initial(icon_state)]2"
		if(5 to INFINITY)
			icon_state = "[initial(icon_state)]3"
		else
			icon_state = "[initial(icon_state)]"
	return ..()

/obj/item/storage/bag/trash/throw_land(atom/A, datum/thrownthing/TT)
	. = ..()
	// let them shuffle the contents so they can grab other stuff with this if they really want
	obj_storage?.hide()
	var/list/athena_event_balancing_patch = contents.Copy()
	shuffle_inplace(athena_event_balancing_patch)
	contents = athena_event_balancing_patch

/obj/item/storage/bag/trash/bluespace
	name = "trash bag of holding"
	max_single_weight_class = WEIGHT_CLASS_NORMAL
	max_combined_volume = WEIGHT_VOLUME_SMALL * 48 * 3
	desc = "The latest and greatest in custodial convenience, a trashbag that is capable of holding vast quantities of garbage."
	icon_state = "bluetrashbag"

/obj/item/storage/bag/trash/plasticbag
	name = "plastic bag"
	desc = "It's a very flimsy, very noisy alternative to a bag."
	icon = 'icons/obj/trash.dmi'
	icon_state = "plasticbag"
	drop_sound = 'sound/items/drop/wrapper.ogg'
	pickup_sound = 'sound/items/pickup/wrapper.ogg'

	w_class = WEIGHT_CLASS_BULKY
	max_single_weight_class = WEIGHT_CLASS_NORMAL
	max_combined_volume = WEIGHT_VOLUME_NORMAL * 3
