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
	/// dynamic tool locking - if set, dynamic tool behaviour (including confirmation radials) are entirely disregarded to use this item as a normal tool with whatever tool_behaviour() returns.
	var/tool_locked = TOOL_LOCKING_AUTO
	/// the sound to play (compatible with getsfx()) when we are used as a tool, if the function is the same as tool_behaviour.
	var/tool_sound
	/// override for dynamic tool support - varedit only, and not always supported.
	VAR_PRIVATE/list/tool_override

/**
 * queries for tool functions
 * returns a list of functions associated to their qualities, or null.
 *
 * when overriding, make sure to take into account tool_quality_transform()!
 * that's where things like skill checks are done.
 *
 * @params
 * - user - person using tool, can be null
 * - target - atom being used on, can be null
 * - flags - tool operation flags
 * - usage - what we're being used for, bitfield
 */
/obj/item/proc/tool_query(mob/user, atom/target, flags, usage)
	RETURN_TYPE(/list)
	. = list()
	// if normal tool behavior
	if(tool_behaviour)
		.[tool_behaviour] = tool_quality
	// if overriding, overwrite
	if(tool_override)
		. |= tool_override
	for(var/i in .)
		.[i] = tool_quality_transform(.[i], user, target, flags, usage)

/**
 * checks for a tool function
 * returns quality of function, or null if not found
 *
 * when overriding, make sure to take into account tool_quality_transform()!
 * that's where things like skill checks are done.
 *
 * @params
 * - function - tool function enum
 * - user - person using tool, if any
 * - target - atom tool being used on, if any
 * - flags - tool operation flags
 * - usage - what we're being used for, bitfield
 */
/obj/item/proc/tool_check(function, mob/user, atom/target, flags, usage)
	ASSERT(function)
	if(tool_override && tool_override[function])
		return tool_quality_transform(tool_override[function], user, target, flags, usage)
	return (function == tool_behaviour)? tool_quality_transform(tool_quality, user, target, flags, usage) : null

/**
 * transforms tool quality according to a user's skill
 *
 * @params
 * - original - original quality
 *
 * - user - user, if any
 * - target - target, if any
 * - flags - tool operation flags
 * - usage - what we're being used for, bitfield
 */
/obj/item/proc/tool_quality_transform(original, user, target, flags, usage)
	return original

/**
 * gets our tool speed
 * returns float in (0, infinity]
 *
 * when overriding, make sure to take into account previous calls!
 * that is where things like skill checks are done.
 *
 * @params
 * - function - tool function enum
 * - user - person using tool, if any
 * - target - atom tool being used on, if any
 * - flags - tool operation flags
 * - usage - what we're being used for, bitfield
 */
/obj/item/proc/tool_speed(function, mob/user, atom/target, flags, usage)
	SHOULD_CALL_PARENT(TRUE)
	return (flags & TOOL_OP_INSTANT)? 0 : tool_speed

/**
 * gets the static functionality of this tool.
 * used for legacy wrappers as well. make sure this is defined on your dynamic tool,
 * or only dynamic tools will work.
 *
 * some dynamic tools will return the locked-in behaviour if locking is enabled
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
 * - flags - tool operation flags
 * - usage - what we're being used for
 */
/obj/item/proc/tool_quality(function = tool_behaviour(), mob/user, atom/target, flags, usage)
	// this is just a wrapper, the only difference is function is automatically provided.
	return tool_check(function, user, target, flags, usage)

/**
 * called when we start being used as a tool
 * return FALSE to cancel
 *
 * @params
 * - function - tool function enum
 * - flags - tool operation flags
 * - user - person using tool, if any
 * - target - atom tool being used on, if any
 * - time - approximated duration of the action in deciseconds
 * - cost - cost multiplier
 * - usage - usage flags, if any
 */
/obj/item/proc/using_as_tool(function, flags, mob/user, atom/target, time, cost, usage)
	SHOULD_CALL_PARENT(TRUE)
	return TRUE

/**
 * called when we stop being used as a tool (aka finish of say, a window unfasten)
 * return FALSE to cancel
 *
 * @params
 * - function - tool function enum
 * - flags - tool operation flags
 * - user - person using tool, if any
 * - target - atom tool being used on, if any
 * - time - duration of the action in deciseconds
 * - cost - cost multiplier
 * - usage - usage flags, if any
 * - success - was it successful?
 */
/obj/item/proc/used_as_tool(function, flags, mob/user, atom/target, time, cost, usage, success)
	SHOULD_CALL_PARENT(TRUE)
	return TRUE

/**
 * standard feedback for starting a tool usage
 *
 * @params
 * - function - tool function enum
 * - flags - tool operation flags
 * - user - person using tool, if any
 * - target - atom tool being used on, if any
 * - time - duration of the action in deciseconds
 * - cost - cost multiplier
 * - usage - usage flags, if any
 */
/obj/item/proc/tool_feedback_start(function, flags, mob/user, atom/target, time, cost, usage)
	SHOULD_CALL_PARENT(TRUE)
	if(!(flags & TOOL_OP_NO_STANDARD_AUDIO))
		standard_tool_feedback_sound(function, flags, user, target, time, cost, usage)

/**
 * standard feedback for ending a tool usage
 *
 * @params
 * - function - tool function enum
 * - flags - tool operation flags
 * - user - person using tool, if any
 * - target - atom tool being used on, if any
 * - time - duration of the action in deciseconds
 * - cost - cost multiplier
 * - usage - usage flags, if any
 * - success - was it successful?
 */
/obj/item/proc/tool_feedback_end(function, flags, mob/user, atom/target, time, cost, usage, success)
	SHOULD_CALL_PARENT(TRUE)
	if(!(flags & TOOL_OP_NO_STANDARD_AUDIO))
		standard_tool_feedback_sound(function, flags, user, target, time, cost, usage, success)

/**
 * plays tool sound
 *
 * @params
 * - function - tool function enum
 * - flags - tool operation flags
 * - user - person using tool, if any
 * - target - atom tool being used on, if any
 * - time - duration of the action in deciseconds
 * - cost - cost multiplier
 * - usage - usage flags, if any
 * - success - was it successful? null if we're just starting
 */
/obj/item/proc/standard_tool_feedback_sound(function, flags, mob/user, atom/target, time, cost, usage, success)
	if(isnull(success))
		// starting
		playsound(src, tool_sound(function, flags, user, target, time, cost, usage, success), 50, TRUE)
	else
		// finishing
		if(time >= MIN_TOOL_SOUND_DELAY)
			playsound(src, tool_sound(function, flags, user, target, time, cost, usage, success), 50, TRUE)

/**
 * gets sound to play on tool usage
 *
 * @params
 * - function - tool function enum
 * - flags - tool operation flags
 * - user - person using tool, if any
 * - target - atom tool being used on, if any
 * - time - duration of the action in deciseconds
 * - cost - cost multiplier
 * - usage - usage flags, if any
 * - success - was it successful? null if we're just starting
 */
/obj/item/proc/tool_sound(function, flags, mob/user, atom/target, time, cost, usage, success)
	if(tool_sound)
		return tool_sound
	// return default
	switch(function)
		if(TOOL_SCREWDRIVER)
			return 'sound/items/screwdriver.ogg'
		if(TOOL_WIRECUTTER)
			return 'sound/items/wirecutter.ogg'
		if(TOOL_CROWBAR)
			return 'sound/items/crowbar.ogg'
		if(TOOL_WELDER)
			return 'sound/items/Welder2.ogg'
		if(TOOL_WRENCH)
			return 'sound/items/ratchet.ogg'
