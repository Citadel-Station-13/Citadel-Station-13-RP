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
 * - if you don't override dynamic_tool_image you are a lemming and it'll probably be ugly.
 *
 * It's That Simple (tm)!
 */

//! Entrypoint
/**
 * call to have the user attempt a tool interaction with the given item.
 *
 * returns a set of clickchain flags
 *
 * warning: this proc is not necessarily called only within clickcode.
 *
 * @params
 * - I - the item
 * - user - the user
 * - clickchain_flags - the clickchain flags given
 * - function - forced function - used in automation
 * - hint - forced hint - used in automation
 * - reachability_check - a callback used for reachability checks. if none, defaults to item.attack_can_reach when in clickcode, can always reach otherwise.
 */
/atom/proc/tool_interaction(obj/item/I, mob/user, clickchain_flags, function, hint, datum/callback/reachability_check)
	SHOULD_NOT_OVERRIDE(TRUE)
	return _tool_interaction_entrypoint(I, user, clickchain_flags, function, hint, reachability_check)

/atom/proc/_tool_interaction_entrypoint(obj/item/provided_item, mob/user, clickchain_flags, function, hint, datum/callback/reachability_check)
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)
	if(isnull(reachability_check))
		if(clickchain_flags & CLICKCHAIN_TOOL_ACT)
			// provided_item should never be null
			reachability_check = CALLBACK(provided_item, /obj/item/proc/attack_can_reach)
	if(reachability_check && !reachability_check.Invoke())
		return NONE
	// from click chain
	if(provided_item)
		if(function)
			// automation, just go
			return _dynamic_tool_act(I, user, function, TOOL_OP_AUTOPILOT, hint)
		// used in clickchain
		var/list/possibilities = dynamic_tool_functions(provided_item, user)
		var/function
		if(!length(possibilities))
			// no dynamic tool functionality, route normally.
			function = provided_item.tool_behaviour()
			return _tool_act(provided_item, user, function)
		// dynamic tool system:
		if(provided_item.tool_locked)
			// item is locked to one behaviour
			function = provided_item.tool_behaviour()
			if(!(function in possibilities))
				// not in it
				return NONE
			// ayo
			possibilities = list(function = possibilities[function])
		else
			// enumerate
			var/list/functions = provided_item.tool_query(user, src)
			for(var/i in possibilities)
				if(functions[i])
					continue
				possibilities -= i
		// everything in possibilities is valid for the tool
		var/list/transformed = list()
		for(var/i in possibilities)
			transformed[i] = dynamic_tool_image(i)
		var/function = show_radial_menu(user, src, transformed, require_near = provided_item.reach)
		if(reachability_check && !reachability_check.Invoke())
			return CLICKCHAIN_DO_NOT_PROPAGATE
		// determine hint
		var/list/hints = possibilities[function]
		if(!length(hints))
			// none, just go
			return _dynamic_tool_act(I, user, function)
		transformed.len = 0
		for(var/i in hints)
			transformed[i] = dynamic_tool_image(function, i)
		var/hint = show_radial_menu(user, src, transformed, require_near = provided_item.reach)
		if(reachability_check && !reachability_check.Invoke())
			return CLICKCHAIN_DO_NOT_PROPAGATE
		// use hint
		return _dynamic_tool_act(I, user, function, hint = hint)
	else
		// in the future, we might have situations where clicking something with an empty hand
		// yet having organs that server as built-in tools can do something with
		// the dynamic tool system. for now, this does nothing.
		return NONE

//! Primary Tool API
/atom/proc/_tool_act(obj/item/I, mob/user, function, flags, hint)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)
	SEND_SIGNAL(src, COMSIG_ATOM_TOOL_ACT, I, user, function, flags, hint)
	return tool_act(I, user, function, flags, hint)

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
 * - hint - the operation hint, if the calling system is the dynamic tool system.
 */
/atom/proc/tool_act(obj/item/I, mob/user, function, flags, hint)
	switch(function)
		if(TOOL_CROWBAR)
			return crowbar_act(I, user, flags, hint)? CLICKCHAIN_DO_NOT_PROPAGATE : NONE
		if(TOOL_MULTITOOL)
			return multitool_act(I, user, flags, hint)? CLICKCHAIN_DO_NOT_PROPAGATE : NONE
		if(TOOL_SCREWDRIVER)
			return screwdriver_act(I, user, flags, hint)? CLICKCHAIN_DO_NOT_PROPAGATE : NONE
		if(TOOL_WRENCH)
			return wrench_act(I, user, flags, hint)? CLICKCHAIN_DO_NOT_PROPAGATE : NONE
		if(TOOL_WELDER)
			return welder_act(I, user, flags, hint)? CLICKCHAIN_DO_NOT_PROPAGATE : NONE
		if(TOOL_WIRECUTTER)
			return wirecutter_act(I, user, flags, hint)? CLICKCHAIN_DO_NOT_PROPAGATE : NONE
		if(TOOL_ANALYZER)
			return analyzer_act(I, user, flags, hint)? CLICKCHAIN_DO_NOT_PROPAGATE : NONE
		//? Add more tool_acts as necessary.

/**
 * primary proc called by wrappers to use a tool on us
 */
/atom/proc/use_tool(obj/item/I, mob/user, function, flags, delay, msg, self_msg, cost = 1)
	var/quality = I.tool_check(function, user, src)
	if(!quality)
		return FALSE
	var/speed = I.tool_speed(function, user, src)
	delay = delay * speed
	if(!I.using_as_tool(function, flags, user, src, delay, cost))
		return FALSE
	I.standard_tool_feedback_start(function, flags, user, src, delay, msg, self_msg)
	if(!do_after(user, delay, src))
		I.standard_tool_feedback_end(function, flags, user, src, delay, FALSE, msg, self_msg)
		I.used_as_tool(function, flags, user, src, delay, cost, FALSE)
		return FALSE
	I.standard_tool_feedback_end(function, flags, user, src, delay, TRUE, msg, self_msg)
	if(!I.used_as_tool(function, flags, user, src, delay, cost, TRUE))
		return FALSE
	return TRUE

//! Dynamic Tool API
/**
 * returns a list of behaviours that can be used on us in our current state
 * the behaviour may be associated to a list of "hints" for multiple possible actions per behaviour.
 * the hint should be human readable.
 *
 * @params
 * - I - the tool used, if any
 * - user - the user, if any
 */
/atom/proc/dynamic_tool_functions(obj/item/I, mob/user)
	return list()

/atom/proc/_dynamic_tool_act(obj/item/I, mob/user, function, flags, hint)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)
	flags |= TOOL_OP_DYNAMIC
	SEND_SIGNAL(src, COMSIG_ATOM_TOOL_ACT, I, user, function, flags, hint)
	return dynamic_tool_act(I, user, function, flags, hint)

/**
 * called when we are acted on by the dynamic tool system
 * defualt behaviour: just call tool_act
 *
 * this must return a set of clickchain flags!
 *
 * @params
 * - I - the tool used
 * - user - the user, if any
 * - function - the tool behaviour used
 * - flags - tool operation flags
 * - hint - the hint of what operation to do
 */
/atom/proc/dynamic_tool_act(obj/item/I, mob/user, function, flags, hint)
	return tool_act(I, user, function, flags, hint)

/**
 * builds the image used for the radial icon
 *
 * WARNING: If you use tool **and** hint, you need to implement a hintless, or return to base to use the default.
 *
 * @params
 * - function - the tool behaviour
 * - hint - the context provided when you want to implement multiple actions for a tool
 */
/atom/proc/dynamic_tool_image(function, hint)
	var/static/list/default_states = list(
		TOOL_SCREWDRIVER = "screwdriver",
		TOOL_CROWBAR = "crowbar"
	)
	var/icon/default_icon = 'icons/screen/radial/tools/generic.dmi'
	. = default_states[function]
	if(!.)
		. = ""
	return image(default_icon, icon_state = .)
