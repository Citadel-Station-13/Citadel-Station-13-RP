/// Attempts to install the hardware into apropriate slot.
/obj/item/modular_computer/proc/try_install_component(mob/living/user, obj/item/computer_hardware/H, found = FALSE)
	// "USB" flash drive.
	if(istype(H, /obj/item/computer_hardware/hard_drive/portable))
		if(portable_drive)
			to_chat(user, "This computer's portable drive slot is already occupied by \the [portable_drive].")
			return
		found = TRUE
		portable_drive = H
	else if(istype(H, /obj/item/computer_hardware/hard_drive))
		if(hard_drive)
			to_chat(user, "This computer's hard drive slot is already occupied by \the [hard_drive].")
			return
		found = TRUE
		hard_drive = H
	else if(istype(H, /obj/item/computer_hardware/network_card))
		if(network_card)
			to_chat(user, "This computer's network card slot is already occupied by \the [network_card].")
			return
		found = TRUE
		network_card = H
	else if(istype(H, /obj/item/computer_hardware/nano_printer))
		if(nano_printer)
			to_chat(user, "This computer's nano printer slot is already occupied by \the [nano_printer].")
			return
		found = TRUE
		nano_printer = H
	else if(istype(H, /obj/item/computer_hardware/card_slot))
		if(card_slot)
			to_chat(user, "This computer's card slot is already occupied by \the [card_slot].")
			return
		found = TRUE
		card_slot = H
	else if(istype(H, /obj/item/computer_hardware/battery_module))
		if(battery_module)
			to_chat(user, "This computer's battery slot is already occupied by \the [battery_module].")
			return
		found = TRUE
		battery_module = H
	else if(istype(H, /obj/item/computer_hardware/processor_unit))
		if(processor_unit)
			to_chat(user, "This computer's processor slot is already occupied by \the [processor_unit].")
			return
		found = TRUE
		processor_unit = H
	else if(istype(H, /obj/item/computer_hardware/tesla_link))
		if(tesla_link)
			to_chat(user, "This computer's tesla link slot is already occupied by \the [tesla_link].")
			return
		found = TRUE
		tesla_link = H
	if(found)
		if(!user.attempt_insert_item_for_installation(H, src))
			return
		to_chat(user, "You install \the [H] into \the [src]")
		H.holder2 = src
		update_verbs()

/// Uninstalls component. Found and Critical vars may be passed by parent types, if they have additional hardware.
/obj/item/modular_computer/proc/uninstall_component(mob/living/user, obj/item/computer_hardware/H, found = FALSE, critical = FALSE)
	if(portable_drive == H)
		portable_drive = null
		found = TRUE
	if(hard_drive == H)
		hard_drive = null
		found = TRUE
		critical = TRUE
	if(network_card == H)
		network_card = null
		found = TRUE
	if(nano_printer == H)
		nano_printer = null
		found = TRUE
	if(card_slot == H)
		card_slot = null
		found = TRUE
	if(battery_module == H)
		battery_module = null
		found = TRUE
	if(processor_unit == H)
		processor_unit = null
		found = TRUE
		critical = TRUE
	if(tesla_link == H)
		tesla_link = null
		found = TRUE
	if(found)
		if(user)
			to_chat(user, "You remove \the [H] from \the [src].")
		H.forceMove(get_turf(src))
		H.holder2 = null
		update_verbs()
	if(critical && enabled)
		if(user)
			to_chat(user, SPAN_DANGER("\The [src]'s screen freezes for few seconds and then displays an \"HARDWARE ERROR: Critical component disconnected. Please verify component connection and reboot the device. If the problem persists contact technical support for assistance.\" warning."))
		shutdown_computer()
		update_icon()


/// Checks all hardware pieces to determine if name matches, if yes, returns the hardware piece, otherwise returns null.
/obj/item/modular_computer/proc/find_hardware_by_name(name)
	if(portable_drive && (portable_drive.name == name))
		return portable_drive
	if(hard_drive && (hard_drive.name == name))
		return hard_drive
	if(network_card && (network_card.name == name))
		return network_card
	if(nano_printer && (nano_printer.name == name))
		return nano_printer
	if(card_slot && (card_slot.name == name))
		return card_slot
	if(battery_module && (battery_module.name == name))
		return battery_module
	if(processor_unit && (processor_unit.name == name))
		return processor_unit
	if(tesla_link && (tesla_link.name == name))
		return tesla_link
	return null

/// Returns list of all components.
/obj/item/modular_computer/proc/get_all_components()
	var/list/all_components = list()
	if(hard_drive)
		all_components.Add(hard_drive)
	if(network_card)
		all_components.Add(network_card)
	if(portable_drive)
		all_components.Add(portable_drive)
	if(nano_printer)
		all_components.Add(nano_printer)
	if(card_slot)
		all_components.Add(card_slot)
	if(battery_module)
		all_components.Add(battery_module)
	if(processor_unit)
		all_components.Add(processor_unit)
	if(tesla_link)
		all_components.Add(tesla_link)
	return all_components
