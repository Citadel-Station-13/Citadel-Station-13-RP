// -----------------------------
//        Laundry Basket
// -----------------------------
// An item designed for hauling the belongings of a character.
// So this cannot be abused for other uses, we make it two-handed and inable to have its storage looked into.
/obj/item/storage/laundry_basket
	name = "laundry basket"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "laundry-empty"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "laundry", SLOT_ID_LEFT_HAND = "laundry")
	desc = "The peak of thousands of years of laundry evolution."

	w_class = WEIGHT_CLASS_HUGE
	max_single_weight_class = WEIGHT_CLASS_BULKY
	max_combined_volume = WEIGHT_VOLUME_NORMAL * 8
	max_items = 20
	allow_mass_gather = TRUE
	allow_quick_empty = 1
	allow_quick_gather = 1
	collection_mode = 1
	var/linked

/obj/item/storage/laundry_basket/update_icon_state()
	. = ..()
	if(contents.len)
		icon_state = "laundry-full"
	else
		icon_state = "laundry-empty"

/obj/item/storage/laundry_basket/OnMouseDropLegacy(obj/over_object as obj)
	if(over_object == usr)
		return
	else
		return ..()

/obj/item/storage/laundry_basket/dropped(mob/user, flags, atom/newLoc)
	if(use_to_pickup)	// sigh refactor this shit when
		QDEL_NULL(linked)
	return ..()

/obj/item/storage/laundry_basket/show_to(mob/user as mob)
	return

/obj/item/storage/laundry_basket/open(mob/user as mob)
