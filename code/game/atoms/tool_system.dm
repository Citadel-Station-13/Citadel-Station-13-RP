/**
 * atom tool API: allows unfiied handling of tool usage
 *
 * further, adds support for "tool usage chains" allowing for automated actions when an
 * user has the requisite tools.
 *
 * intended api for static tool usage:
 *
 * if(usable_tool(I, user, TOOL_SCREWDRIVER))
 *     if(use_tool(I, user, TOOL_SCREWDRIVER))
 *         # code on success
 *     else
 *         # code on failure
 *     return CLICKCHAIN_DO_NOT_PROPAGATE
 *
 * intended api for dynamic tool usage:
 * - override requested_tool_functions to return the functions and minimal qualities for a user
 * - override requested_tool_act if needed, otherwise it will simply go into tool_act
 * - override requested_tool_image to return the image to render for a specific tool function for radials
 *
 * .../requested_tool_act(...)
 *     switch(function)
 *
 */

#warn bad tool api, rework

/// Tool behavior procedure. Redirects to tool-specific procs by default.
/// You can override it to catch all tool interactions, for use in complex deconstruction procs.
/// Just don't forget to return ..() in the end.
/atom/proc/tool_act(mob/living/user, obj/item/I, tool_type)
	switch(tool_type)
		if(TOOL_CROWBAR)
			return crowbar_act(user, I)
		if(TOOL_MULTITOOL)
			return multitool_act(user, I)
		if(TOOL_SCREWDRIVER)
			return screwdriver_act(user, I)
		if(TOOL_WRENCH)
			return wrench_act(user, I)
		if(TOOL_WIRECUTTER)
			return wirecutter_act(user, I)
		if(TOOL_WELDER)
			return welder_act(user, I)
		if(TOOL_ANALYZER)
			return analyzer_act(user, I)

// Tool-specific behavior procs. To be overridden in subtypes.
/atom/proc/crowbar_act(mob/living/user, obj/item/I)
	return

/atom/proc/multitool_act(mob/living/user, obj/item/I)
	return

/atom/proc/multitool_check_buffer(user, obj/item/I, silent = FALSE)
	if(!I.tool_behaviour == TOOL_MULTITOOL)
		if(user && !silent)
			to_chat(user, SPAN_WARNING("[I] has no data buffer!"))
		return FALSE
	return TRUE

/atom/proc/screwdriver_act(mob/living/user, obj/item/I)
	SEND_SIGNAL(src, COMSIG_ATOM_SCREWDRIVER_ACT, user, I)

/atom/proc/wrench_act(mob/living/user, obj/item/I)
	return

/atom/proc/wirecutter_act(mob/living/user, obj/item/I)
	return

/atom/proc/welder_act(mob/living/user, obj/item/I)
	return

/atom/proc/analyzer_act(mob/living/user, obj/item/I)
	return
