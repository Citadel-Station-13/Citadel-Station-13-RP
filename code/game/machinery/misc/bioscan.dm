GLOBAL_LIST_EMPTY(bioscan_anntena_list)
/obj/machinery/bioscan_antenna
	name = "Bioscan Antenna"
	desc = "A fragile antenna used to locate nearby biosignatures."
	can_be_unanchored = TRUE
	#warn sprite

	/// network key
	var/network_key
	/// can be reprogrammed
	var/network_mutable = TRUE

/obj/machinery/bioscan_antenna/Initialize(mapload)
	. = ..()
	change_network(network_key)

/obj/machinery/bioscan_antenna/Destroy()
	change_network(null)
	return ..()

/obj/machinery/bioscan_antenna/attackby(obj/item/I, mob/living/user, params, clickchain_flags, damage_multiplier)

/obj/machinery/bioscan_antenna/wrench_act(obj/item/I, mob/user, flags, hint)
	#warn impl

/obj/machinery/bioscan_antenna/multitool_act(obj/item/I, mob/user, flags, hint)
	#warn impl

/obj/machinery/bioscan_antenna/dynamic_tool_functions(obj/item/I, mob/user)
	. = list()
	if(network_mutable)
		. += TOOL_MULTITOOL
	if(can_be_unanchored)
		.[TOOL_WRENCH] = anchored? TOOL_HINT_WRENCH_GENERIC_UNFASTEN : TOOL_HINT_WRENCH_GENERIC_FASTEN

/obj/machinery/bioscan_antenna/proc/change_network(key)
	#warn impl

/obj/machinery/bioscan_anntena/permanent
	desc = "A less fragile antenna used to locate nearby biosignatures. This one cannot be anchored or moved, only reprogrammed."
	can_be_unanchored = FALSE
