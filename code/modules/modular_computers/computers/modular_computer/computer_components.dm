/obj/item/modular_computer/proc/can_install_component(obj/item/computer_hardware/H, mob/living/user = null)
	if(!H.can_install(src, user))
		return FALSE

	if(H.w_class > max_hardware_size)
		to_chat(user, SPAN_WARNING("This component is too large for \the [src]!"))
		return FALSE

	if(H.expansion_hw)
		if(LAZYLEN(expansion_bays) >= max_bays)
			to_chat(user, SPAN_WARNING("All of the computer's expansion bays are filled."))
			return FALSE
		if(LAZYACCESS(expansion_bays, H.device_type))
			to_chat(user, SPAN_WARNING("The computer immediately ejects /the [H] and flashes an error: \"Hardware Address Conflict\"."))
			return FALSE

	if(all_components[H.device_type])
		to_chat(user, SPAN_WARNING("This computer's hardware slot is already occupied by \the [all_components[H.device_type]]."))
		return FALSE
	return TRUE


// Installs component.
/obj/item/modular_computer/proc/install_component(obj/item/computer_hardware/H, mob/living/user = null)
	if(!can_install_component(H, user))
		return FALSE

	if(user && !user.transfer_item_to_loc(H, src))
		return FALSE

	if(H.expansion_hw)
		LAZYSET(expansion_bays, H.device_type, H)
	all_components[H.device_type] = H

	to_chat(user, SPAN_NOTICE("You install \the [H] into \the [src]."))
	H.holder = src
	H.forceMove(src)
	H.on_install(src, user)


// Uninstalls component.
/obj/item/modular_computer/proc/uninstall_component(obj/item/computer_hardware/H, mob/living/user = null)
	if(H.holder != src) // Not our component at all.
		return FALSE
	if(H.expansion_hw)

		LAZYREMOVE(expansion_bays, H.device_type)
	all_components.Remove(H.device_type)

	to_chat(user, SPAN_NOTICE("You remove \the [H] from \the [src]."))

	H.forceMove(get_turf(src))
	H.holder = null
	H.on_remove(src, user)
	if(enabled && !use_power())
		shutdown_computer()
	update_appearance()
	return TRUE


// Checks all hardware pieces to determine if name matches, if yes, returns the hardware piece, otherwise returns null
/obj/item/modular_computer/proc/find_hardware_by_name(name)
	for(var/i in all_components)
		var/obj/O = all_components[i]
		if(O.name == name)
			return O
	return null
