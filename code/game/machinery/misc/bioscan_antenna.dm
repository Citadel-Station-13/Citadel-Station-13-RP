GLOBAL_LIST_EMPTY(bioscan_antenna_list)
/obj/machinery/bioscan_antenna
	name = "Bioscan Antenna"
	desc = "A fragile antenna used to locate nearby biosignatures."
	allow_deconstruct = TRUE
	allow_unanchor = TRUE
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

/obj/machinery/bioscan_antenna/Initialize(mapload)
	. = ..()
	id = "[++id_next]"
	if(network_key_obfuscated)
		network_key = SSmapping.subtly_obfuscated_id(network_key_obfuscated, "bioscan_network")
	change_network(network_key)

/obj/machinery/bioscan_antenna/Destroy()
	change_network(null)
	return ..()

/obj/machinery/bioscan_antenna/crowbar_act(obj/item/I, mob/user, flags, hint)
	if(!allow_deconstruct || !panel_open)
		return ..()
	if(default_deconstruction_crowbar(user, I))
		user.visible_message(SPAN_NOTICE("[user] dismantles [src]."), range = MESSAGE_RANGE_CONSTRUCTION)
		return TRUE
	return ..()

/obj/machinery/bioscan_antenna/screwdriver_act(obj/item/I, mob/user, flags, hint)
	if(!allow_deconstruct)
		return ..()
	if(default_deconstruction_screwdriver(user, I))
		user.visible_message(SPAN_NOTICE("[user] [panel_open? "opens" : "closes"] the panel on [src]."), range = MESSAGE_RANGE_CONSTRUCTION)
		return TRUE
	return ..()

/obj/machinery/bioscan_antenna/wrench_act(obj/item/I, mob/user, flags, hint)
	if(!allow_unanchor)
		return ..()
	if(default_unfasten_wrench(user, I, 4 SECONDS))
		user.visible_message(SPAN_NOTICE("[user] [anchored? "fastens [src] to the ground" : "unfastens [src] from the ground"]."), range = MESSAGE_RANGE_CONSTRUCTION)
		return TRUE
	return ..()

/obj/machinery/bioscan_antenna/multitool_act(obj/item/I, mob/user, flags, hint)
	if(!network_mutable)
		return ..()
	. = TRUE
	var/new_network = default_input_text(user, "What do you want to set the network key to?", "Modify Network", network_key)
	if(!user.Reachability(src) || isnull(new_network))
		return
	user.visible_message(SPAN_NOTICE("[user] reprograms the network on [src]."), range = MESSAGE_RANGE_CONFIGURATION)
	change_network(new_network)

/obj/machinery/bioscan_antenna/dynamic_tool_functions(obj/item/I, mob/user)
	. = list()
	if(network_mutable)
		.[TOOL_MULTITOOL] = "change network"
	if(allow_unanchor)
		.[TOOL_WRENCH] = anchored? "anchor" : "unanchor"
	if(allow_deconstruct)
		.[TOOL_SCREWDRIVER] = panel_open? "close panel" : "open panel"
		if(panel_open)
			.[TOOL_CROWBAR] = "deconstruct"

/obj/machinery/bioscan_antenna/dynamic_tool_image(function, hint)
	switch(function)
		if(TOOL_WRENCH)
			return anchored? dyntool_image_backward(TOOL_WRENCH) : dyntool_image_forward(TOOL_WRENCH)
		if(TOOL_SCREWDRIVER)
			return panel_open? dyntool_image_forward(TOOL_SCREWDRIVER) : dyntool_image_backward(TOOL_SCREWDRIVER)
	return ..()

/obj/machinery/bioscan_antenna/attack_hand(mob/user)
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
	allow_deconstruct = FALSE
	allow_unanchor = FALSE
