/obj/item
	/// static tool behavior
	var/tool_behaviour = NONE
	/// static tool speed - multiplies delay (e.g. 0.5 for twixe as fast)
	var/tool_speed = 1
	/// static tool quality
	var/tool_quality = TOOL_QUALITY_DEFAULT
	#warn switch system?
	/// override for dynamic tool support - varedit only
	VAR_PRIVATE/list/dynamic_tool_override

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

/**
 * queries for tool functions
 * returns a list of functions associated to their qualities
 * returns null if there are no functions
 *
 * @params
 * - user - person using tool, can be null
 * - target - atom being used on, can be null
 */
/obj/item/proc/dynamic_tool_query(mob/user, atom/target)
	SHOULD_CALL_PARENT(TRUE)
	. = list()
	// if normal tool behavior
	if(tool_behaviour)
		.[tool_behaviour] = tool_quality
	// if overriding, overwrite
	if(dynamic_tool_override)
		. |= dynamic_tool_override


/* draft notes
/obj/item
  var/tool_behavior
  var/tool_quality
  var/tool_speed

/obj/item/proc/tool_attack_chain(mob/user, atom/target, flags, params)
/obj/item/proc/standard_use_tool(mob/user, atom/target, flags, params)
/obj/item/proc/dynamic_tool_query(mob/user optional, atom/target optional, flags optional, params optional)
  <return list of tool behaviors>
/obj/item/proc/dynamic_tool_check(requested_function, mob/user optional, atom/target optional, flags optional, params optional)
  return true/false
/obj/item/proc/dynamic_tool_speed(requested_function, mob/user optional, atom/target optional, flags optional, params optional)
/obj/item/proc/dynamic_tool_quality(requested_function, mob/user optional, atom/target optional, flags optional, params optional)
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
