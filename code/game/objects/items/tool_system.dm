/**
 * item tool API: allows items to be one or more types of generic tool-functionalities
 * with arbitrary tool speeds and qualities, while allowing the item to hook usages.
 *
 * ! Warning: Unlike other things, the standard API for this only promises to return specific types
 * ! 	of values; not to obey original variables like tool_behaviour and tool_override.
 * ! 	This is a necessary drawback of optimizaiton.
 */
/obj/item
	/// static tool behavior
	var/tool_behaviour
	/// static tool quality
	var/tool_quality = TOOL_QUALITY_DEFAULT
	/// tool speed - multiplies delay (e.g. 0.5 for twixe as fast). also the default for dynamic tools.
	var/tool_speed = TOOL_SPEED_DEFAULT
	/// override for dynamic tool support - varedit only, and not always supported.
	VAR_PRIVATE/list/tool_override

/**
 * queries for tool functions
 * returns a list of functions associated to their qualities, or null.
 *
 * @params
 * - user - person using tool, can be null
 * - target - atom being used on, can be null
 */
/obj/item/proc/tool_query(mob/user, atom/target)
	RETURN_TYPE(/list)
	. = list()
	// if normal tool behavior
	if(tool_behaviour)
		.[tool_behaviour] = tool_quality
	// if overriding, overwrite
	if(tool_override)
		. |= tool_override

/**
 * checks for a tool function
 * returns quality of function, or null if not found
 *
 * @params
 * - function - tool function enum
 * - user - person using tool, if any
 * - target - atom tool being used on, if any
 */
/obj/item/proc/tool_check(function, mob/user, atom/target)
	ASSERT(function)
	if(tool_override && tool_override[function])
		return tool_override[function]
	return (function == tool_behaviour)? tool_quality : null

/**
 * gets our tool speed
 * returns float in (0, infinity]
 *
 * @params
 * - function - tool function enum
 * - user - person using tool, if any
 * - target - atom tool being used on, if any
 */
/obj/item/proc/tool_speed(function, mob/user, atom/target)
	return tool_speed

/**
 * gets the static functionality of this tool.
 *
 * some dynamic tools will return null even if it supports it.
 */
/obj/item/proc/tool_behaviour()
	return tool_behaviour

/**
 * gets the quality of this tool
 * returns number, or null if non existant.
 *
 * @params
 * - function - tool function enum; if null, defaults to static tool behaviour.
 * - user - person using tool, if any
 * - target - atom tool being used on, if any
 */
/obj/item/proc/tool_quality(function = tool_behaviour(), mob/user, atom/target)
	// this is just a wrapper, the only difference is function is automatically provided.
	return tool_check(function, user, target)

/**
 * called when we start being used as a tool
 * return FALSE to cancel
 *
 * @params
 * - function - tool function enum; if null, defaults to static tool behaviour
 * - flags - tool operation flags
 * - user - person using tool, if any
 * - target - atom tool being used on, if any
 * - time - approximated duration of the action in deciseconds
 */
/obj/item/proc/using_as_tool(function, flags, mob/user, atom/target, time)
	SHOULD_CALL_PARENT(TRUE)

/**
 * called when we stop being used as a tool (aka finish of say, a window unfasten)
 * return FALSE to cancel
 *
 * @params
 * - function - tool function enum; if null, defaults to static tool behavior
 * - flags - tool operation flags
 * - user - person using tool, if any
 * - target - atom tool being used on, if any
 * - time - duration of the action in deciseconds
 */
/obj/item/proc/used_as_tool(function, flags, mob/user, atom/target, time)
	SHOULD_CALL_PARENT(TRUE)

/**
 * standard feedback for starting a tool usage
 *
 * @params
 * - function - tool function enum; if null, defaults to static tool behavior
 * - flags - tool operation flags
 * - user - person using tool, if any
 * - target - atom tool being used on, if any
 * - time - estimated duration of the action in deciseconds
 */
/obj/item/proc/standard_tool_feedback_start(function, flags, mob/user, atom/target, time, )

/**
 * standard feedback for ending a tool usage
 *
 * @params
 * - function - tool function enum; if null, defaults to static tool behavior
 * - flags - tool operation flags
 * - user - person using tool, if any
 * - target - atom tool being used on, if any
 * - time - duration of the action in deciseconds
 * - success - did we finish successfully?
 */
/obj/item/proc/standard_tool_feedback_start(function, flags, mob/user, atom/target, time, success, )

#warn ughh

/*
 *	Assorted tool procs, so any item can emulate any tool, if coded
*/
/obj/item/proc/is_screwdriver()
	return FALSE

/obj/item/proc/is_wrench()
	return FALSE

/obj/item/proc/is_crowbar()
	return FALSE

/obj/item/proc/is_wirecutter()
	return FALSE

/obj/item/proc/is_cable_coil()
	return FALSE

/obj/item/proc/is_multitool()
	return FALSE

/obj/item/proc/is_welder()
	return FALSE

#warn impl

/* draft notes

/obj/item/proc/tool_attack_chain(mob/user, atom/target, flags, params)
/obj/item/proc/standard_use_tool(mob/user, atom/target, flags, params)
/obj/item/proc/dynamic_tool_radial(list/functions, mob/user, atom/target)
  // do radial menu
  return function
/obj/item/proc/dynamic_use_tool(function, mob/user, atom/target, flags, params)

/atom/proc/tool_act(mob/user, obj/item/I, function, flags, params)
/atom/proc/screwdriver_act(mob/user, obj/item/I, flags, params)
/atom/proc/wrench_act...
/atom/proc/crowbar_act...
...

/atom/proc/attempt_dynamic_tool(mob/user, obj/item/I, flags, params)
  var/list/functions = requested_tool_functions()
  if(istext(functions))
    return I.dynamic_use_tool with function
  else
    functions = I.dynamic_tool_radial(functions, user, src)
    return I.dynamic use tool with function

/atom/proc/requested_tool_functions()
  return usable tool functions
  */
