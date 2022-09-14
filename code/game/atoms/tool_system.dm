/**
 * ? Atom Tool API
 *
 * ! Tool System:
 * static tool usage: only react to the default tool type of something used on us
 * dynamic tool usage: provide list of act-able functions, so dynamic tools and static tools may both work
 *
 * prefer dynamic tool usage whenever possible.
 * this lets us make things like switchtools much more natural to use for the user.
 *
 * ! APIs:
 *
 * intended api for static tool usage:
 *
 * - override necessary <function>_act for that tool type
 * .../function_act(...)
 *     if(use_<function>(...))
 *         # success code
 *     else
 *         # failure code
 *     return TRUE // halt attack chain
 *
 * intended api for dynamic tool usage:
 * - override dynamic_tool_functions() to return the functions and minimal qualities for a user
 * - override dynamic_tool_act() if needed, otherwise it will simply go into tool_act
 * - override dynamic_tool_image() to return the image to render for a specific tool function for radials
 * - realistically, you just need to override dynamic_tool_functions.
 *
 * It's That Simple (tm)!
 */

#warn bad tool api, rework

//! Primary Tool API
/atom/proc/_tool_act(obj/item/I, mob/user, function, flags)
	SEND_SIGNAL(src, COMSIG_ATOM_TOOL_ACT, I, user, function, flags)
	return tool_act(I, uesr, function, flags)

/**
 * primary proc to be used when calling an interaction with a tool with an atom
 *
 * everything in this proc and procs it calls:
 * - should not verify that the item is on the user
 * - can, but doesn't need to verify that the item has the function in question (assumed it does)
 * - should not require a user to run (do not runtime without user)
 * - should handle functions with helpers in tihs file whenever possibl
 *
 * default behaviour: route the call to <function>_act, which interrupts the melee attack chain if it returns TRUE.
 *
 * @params
 * - I - the tool in question
 * - user - the user in question, if they exist
 * - function - the tool function used
 * - flags - tool operation flags
 */
/atom/proc/tool_act(obj/item/I, mob/user, function, flags)
	switch(function)
		if(TOOL_CROWBAR)
			return crowbar_act(I, user, flags)? CLICKCHAIN_DO_NOT_PROPAGATE : NONE
		if(TOOL_MULTITOOL)
			return multitool_act(I, user, flags)? CLICKCHAIN_DO_NOT_PROPAGATE : NONE
		if(TOOL_SCREWDRIVER)
			return screwdriver_act(I, user, flags)? CLICKCHAIN_DO_NOT_PROPAGATE : NONE
		if(TOOL_WRENCH)
			return wrench_act(I, user, flags)? CLICKCHAIN_DO_NOT_PROPAGATE : NONE
		if(TOOL_WELDER)
			return welder_act(I, user, flags)? CLICKCHAIN_DO_NOT_PROPAGATE : NONE
		if(TOOL_WIRECUTTER)
			return wirecutter_act(I, user, flags)? CLICKCHAIN_DO_NOT_PROPAGATE : NONE
		if(TOOL_ANALYZER)
			return analyzer_act(I, user, flags)? CLICKCHAIN_DO_NOT_PROPAGATE : NONE
		//? Add more tool_acts as necessary.

/**
 * primary proc called by wrappers to use a tool on us
 */
/atom/proc/use_tool(obj/item/I, mob/user, function, flags, delay, msg, self_msg)
	var/quality = I.tool_check(function, user, src)
	if(!quality)
		return FALSE
	var/speed = I.tool_speed(function, user, src)
	delay = delay * speed
	if(!I.using_as_tool(function, flags, user, src, delay))
		return FALSE
	I.standard_tool_feedback_start(function, flags, user, src, delay, msg, self_msg)
	if(!do_after(user, delay, src))
		I.standard_tool_feedback_end(function, flags, user, src, delay, FALSE, msg, self_msg)
		return FALSE
	I.standard_tool_feedback_end(function, flags, user, src, delay, TRUE, msg, self_msg)
	return TRUE

//! Dynamic Tool API

/atom/proc/dynamic_tool_functions(obj/item/I, mob/user)

/atom/proc/dynamic_tool_act(obj/item/I, mob/user, function, flags)

/atom/proc/dynamic_tool_image(function)
	switch(function)
