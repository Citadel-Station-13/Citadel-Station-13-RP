/obj/machinery/fishing_portal
	name = "fish-porter 3000"
	desc = "Fish anywhere, any-time! Wait, how does this even work..?"

	icon = 'icons/modules/fishing/fishing_portal.dmi'
	icon_state = "portal_off"

	idle_power_usage = 0
	active_power_usage = 0

	allow_unanchor = TRUE
	anchored = FALSE
	density = TRUE

	var/active = FALSE
	var/fishing_source = /datum/fish_source/portal

/obj/machinery/fishing_portal/dynamic_tool_functions(obj/item/I, mob/user)
	. = ..()
	if(allow_unanchor)
		.[TOOL_WRENCH] = anchored? "anchor" : "unanchor"

/obj/machinery/fishing_portal/dynamic_tool_image(function, hint)
	switch(function)
		if(TOOL_WRENCH)
			return anchored? dyntool_image_backward(TOOL_WRENCH) : dyntool_image_forward(TOOL_WRENCH)
	return ..()

/obj/machinery/fishing_portal/wrench_act(obj/item/I, mob/user, flags, hint)
	if(!allow_unanchor)
		return ..()
	if(default_unfasten_wrench(user, I, 4 SECONDS))
		user.visible_message(SPAN_NOTICE("[user] [anchored? "fastens [src] to the ground" : "unfastens [src] from the ground"]."), range = MESSAGE_RANGE_CONSTRUCTION)
		return TRUE
	return ..()

/obj/machinery/fishing_portal/interact(mob/user, special_state)
	. = ..()
	if(active)
		deactivate()
	else
		activate()

/obj/machinery/fishing_portal/update_icon_state()
	if(active)
		icon_state = "portal_on"
	else
		icon_state = "portal_off"
	return ..()

/obj/machinery/fishing_portal/proc/activate()
	active = TRUE
	AddComponent(/datum/component/fishing_spot, fishing_source)
	update_icon()

/obj/machinery/fishing_portal/proc/deactivate()
	active = FALSE
	var/datum/component/fishing_spot/fishing_component = GetComponent(/datum/component/fishing_spot)
	if(fishing_component)
		QDEL_NULL(fishing_component)
	update_icon()

/datum/fish_source/portal
	fish_table = list(
		FISHING_DUD = 2.5,
		/obj/item/fish/goldfish = 10,
		/obj/item/fish/guppy = 10,
	)
	catalog_description = "Fish dimension (Fishing portal generator)"
