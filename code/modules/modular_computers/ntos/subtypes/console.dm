/datum/component/ntos/console
	expected_type = /obj/machinery
	screen_icon_file = 'icons/obj/modular_console.dmi'
	
/datum/component/ntos/console/get_hardware_flag()
	return PROGRAM_CONSOLE

/datum/component/ntos/console/get_component(var/part_type)
	var/obj/machinery/M = holder
	return M.get_component_of_type(part_type)

/datum/component/ntos/console/get_all_components()
	var/obj/machinery/M = holder
	return M.component_parts.Copy()

/datum/component/ntos/console/get_power_usage()
	var/obj/machinery/M = holder
	return M.get_power_usage()

/datum/component/ntos/console/recalc_power_usage()
	var/obj/machinery/M = holder
	M.RefreshParts()

/datum/component/ntos/console/emagged()
	var/obj/machinery/M = holder
	var/obj/item/stock_parts/circuitboard/modular_computer/MB = M.get_component_of_type(/obj/item/stock_parts/circuitboard/modular_computer)
	return MB && MB.emagged

/datum/component/ntos/console/system_boot()
	..()
	var/obj/machinery/M = holder
	M.update_use_power(POWER_USE_ACTIVE)

/datum/component/ntos/console/system_shutdown()
	..()
	var/obj/machinery/M = holder
	M.update_use_power(POWER_USE_IDLE)

/datum/component/ntos/console/host_status()
	var/obj/machinery/M = holder
	return !(M.stat & NOPOWER)

/datum/component/ntos/console/extension_act(href, href_list, user)
	. = ..()
	var/obj/machinery/M = holder
	if(istype(M) && M.clicksound && CanPhysicallyInteractWith(user, M))
		playsound(M, M.clicksound, 40)

// Hack to make status bar work

/obj/machinery/initial_data()
	. = ..()
	var/datum/component/ntos/os = GetComponent(src, /datum/component/ntos)
	if(os)
		. += os.get_header_data()

/obj/machinery/check_eye()
	var/datum/component/ntos/os = GetComponent(src, /datum/component/ntos)
	if(os)
		return os.check_eye()
	else 
		return ..()