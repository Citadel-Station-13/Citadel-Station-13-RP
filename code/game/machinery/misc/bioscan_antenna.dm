GLOBAL_LIST_EMPTY(bioscan_antenna_list)
/obj/machinery/bioscan_antenna
	name = "Bioscan Antenna"
	desc = "A fragile antenna used to locate nearby biosignatures."
	default_deconstruct = 0 SECONDS
	default_unanchor = 5 SECONDS
	default_panel = 0 SECONDS
	icon = 'icons/machinery/bioscan.dmi'
	base_icon_state = "antenna"
	icon_state = "antenna"

	/// network key
	var/network_key
	/// automatically generate an obfuscated key - used by mappers
	var/network_key_obfuscated
	/// can be reprogrammed
	var/network_mutable = TRUE
	/// id
	var/id
	/// next id
	var/static/id_next = 0

	// todo: scaling levels of how accurate they are
	// todo: multiz / world-sector functionality; for now one must be there for each zlevel

/obj/machinery/bioscan_antenna/preloading_instance(datum/dmm_context/context)
	. = ..()
	if(network_key_obfuscated && !network_key)
		network_key = SSmapping.obfuscated_round_local_id(network_key_obfuscated, context.mangling_id, "bioscan")

/obj/machinery/bioscan_antenna/Initialize(mapload)
	. = ..()
	id = "[++id_next]"
	change_network(network_key)

/obj/machinery/bioscan_antenna/Destroy()
	change_network(null)
	return ..()

/obj/machinery/bioscan_antenna/multitool_act(obj/item/I, datum/event_args/actor/clickchain/e_args, flags, hint)
	if(!network_mutable)
		return ..()
	. = TRUE
	var/new_network = tgui_input_text(e_args.initiator, "What do you want to set the network key to?", "Modify Network", network_key)
	if(!e_args.performer.Reachability(src) || isnull(new_network))
		return
	e_args.visible_feedback(
		target = src,
		visible = SPAN_NOTICE("[e_args.performer] reprograms the network on [src]."),
		range = MESSAGE_RANGE_CONFIGURATION,
		otherwise_self = SPAN_NOTICE("You reprogram the network on [src]."),
	)
	change_network(new_network)

/obj/machinery/bioscan_antenna/dynamic_tool_query(obj/item/I, datum/event_args/actor/clickchain/e_args, list/hint_images = list())
	. = list()
	if(network_mutable)
		.[TOOL_MULTITOOL] = "change network"
	return merge_double_lazy_assoc_list(., ..())

/obj/machinery/bioscan_antenna/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	// todo: better xenomorphs
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(istype(H.species, /datum/species/xenos))
			if(!network_key)
				to_chat(H, SPAN_WARNING("[src] is already de-programmed."))
			else
				change_network(null)
				H.visible_message(SPAN_WARNING("[H] violently tears apart [src]'s wires."))
			return
	return ..()

/obj/machinery/bioscan_antenna/proc/change_network(key)
	if(src.network_key)
		if(GLOB.bioscan_antenna_list[src.network_key])
			GLOB.bioscan_antenna_list[src.network_key] -= src
			if(!length(GLOB.bioscan_antenna_list[src.network_key]))
				GLOB.bioscan_antenna_list -= src.network_key
	src.network_key = key
	if(src.network_key)
		if(!GLOB.bioscan_antenna_list[src.network_key])
			GLOB.bioscan_antenna_list[src.network_key] = list()
		GLOB.bioscan_antenna_list[src.network_key] += src
	update_icon()

/obj/machinery/bioscan_antenna/update_icon_state()
	icon_state = "[base_icon_state][network_key? "_active" : ""]"
	return ..()

/obj/machinery/bioscan_antenna/permanent
	desc = "A less fragile antenna used to locate nearby biosignatures. This one cannot be anchored or moved, only reprogrammed."
	default_deconstruct = null
	default_unanchor = null
