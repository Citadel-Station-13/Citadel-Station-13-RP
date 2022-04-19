/datum/component/ntos/device
	var/expected_type = /obj/item/modular_computer

/datum/component/ntos/device/host_status()
	var/obj/item/modular_computer/C = get_physical_host()
	return C.enabled

/datum/component/ntos/device/get_hardware_flag()
	var/obj/item/modular_computer/C = get_physical_host()
	return C.hardware_flag

/datum/component/ntos/device/get_power_usage()
	var/obj/item/modular_computer/C = get_physical_host()
	return C.last_power_usage

/datum/component/ntos/device/recalc_power_usage()
	var/obj/item/modular_computer/C = get_physical_host()
	C.handle_power()
	
/datum/component/ntos/device/emagged()
	var/obj/item/modular_computer/C = get_physical_host()
	return C.computer_emagged

/datum/component/ntos/device/system_shutdown()
	var/obj/item/modular_computer/C = get_physical_host()
	C.enabled = FALSE
	..()

/datum/component/ntos/device/system_boot()
	var/obj/item/modular_computer/C = get_physical_host()
	C.enabled = TRUE
	..()

/datum/component/ntos/device/extension_act(href, href_list, user)
	. = ..()
	var/obj/item/modular_computer/C = get_physical_host()
	if(istype(C) && LAZYLEN(C.interact_sounds) && CanPhysicallyInteractWith(user, C))
		playsound(C, pick(C.interact_sounds), 40)

// Hack to make status bar work

/obj/item/modular_computer/initial_data()
	. = ..()
	var/datum/component/ntos/os = GetComponent(src, /datum/component/ntos)
	if(os)
		. += os.get_header_data()

/obj/item/modular_computer/check_eye()
	var/datum/component/ntos/os = GetComponent(src, /datum/component/ntos)
	if(os)
		return os.check_eye()
	else 
		return ..()
