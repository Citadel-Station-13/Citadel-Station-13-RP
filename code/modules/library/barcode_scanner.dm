#define BARCODE_SCANNER_CHECKIN "check_in"
#define BARCODE_SCANNER_INVENTORY "inventory"

/obj/item/barcodescanner
	name = "barcode scanner"
	icon = 'icons/modules/library/items/barcode_scanner.dmi'
	icon_state ="scanner"
	desc = "A fabulous tool if you need to scan a barcode."
	worn_render_flags = WORN_RENDER_INHAND_NO_RENDER | WORN_RENDER_SLOT_NO_RENDER
	throw_speed = 1
	throw_range = 5
	w_class = WEIGHT_CLASS_TINY

	///Weakref to the library computer we are connected to.
	var/datum/weakref/computer_ref
	///The current scanning mode (BARCODE_SCANNER_CHECKIN|BARCODE_SCANNER_INVENTORY)
	var/scan_mode = BARCODE_SCANNER_CHECKIN

/obj/item/barcodescanner/attackby(obj/item/tool, mob/user)
	if(istype(tool, /obj/item/book))
		return interact_with_book(tool, user)
	return ..()

/obj/item/barcodescanner/proc/interact_with_book(obj/item/book/target_book, mob/living/user)
	var/obj/machinery/computer/libraryconsole/bookmanagement/linked_computer = computer_ref?.resolve()
	if(isnull(linked_computer))
		user.balloon_alert(user, "not connected to computer!")
		return CLICKCHAIN_DO_NOT_PROPAGATE

	switch(scan_mode)
		if(BARCODE_SCANNER_CHECKIN)
			var/list/checkouts = linked_computer.checkouts
			for(var/checkout_ref in checkouts)
				var/datum/borrowbook/maybe_ours = checkouts[checkout_ref]
				if(!target_book.book_data.compare(maybe_ours.book_data))
					continue
				checkouts -= checkout_ref
				linked_computer.checkout_update()
				balloon_alert(user, "checked in")
				playsound(src, 'sound/machines/beep.ogg', 20, FALSE)
				return CLICKCHAIN_DID_SOMETHING

			user.balloon_alert(user, "isn't checked out!")
			return CLICKCHAIN_DO_NOT_PROPAGATE

		if(BARCODE_SCANNER_INVENTORY)
			var/datum/book_info/our_copy = target_book.book_data.return_copy()
			linked_computer.inventory[ref(our_copy)] = our_copy
			linked_computer.inventory_update()
			balloon_alert(user, "added to inventory")
			playsound(src, 'sound/machines/beep.ogg', 20, FALSE)
			return CLICKCHAIN_DID_SOMETHING

	return NONE

/obj/item/barcodescanner/attack_self(mob/user)
	. = ..()
	if(.)
		return
	if(!computer_ref?.resolve())
		balloon_alert(user, "connect to computer!")
		return
	switch(scan_mode)
		if(BARCODE_SCANNER_CHECKIN)
			scan_mode = BARCODE_SCANNER_INVENTORY
			balloon_alert(user, "inventory adding mode")
		if(BARCODE_SCANNER_INVENTORY)
			scan_mode = BARCODE_SCANNER_CHECKIN
			balloon_alert(user, "check-in mode")
	playsound(loc, 'sound/machines/click.ogg', 20, TRUE)

#undef BARCODE_SCANNER_CHECKIN
#undef BARCODE_SCANNER_INVENTORY
