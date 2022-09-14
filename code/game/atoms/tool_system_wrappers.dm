/**
 * Called when a crowbar is used on us.
 *
 * @params
 * - I - tool
 * - user - user, can be null
 * - flags - tool operation flags
 */
/atom/proc/crowbar_act(obj/item/I, mob/user, flags)
	return FALSE

/**
 * Standard helper to have a timed crowbar usage.
 *
 * @params
 * - I - the item
 * - user - the user, if any
 * - flags - tool operation flags
 * - delay - how long this should take
 * - msg - standard feedback message shown to everyone around the user
 * - self_msg - standard feedback message shown to the user
 */
/atom/proc/use_crowbar(obj/item/I, mob/user, flags, delay = 0, msg, self_msg)
	return use_tool(I, user, TOOL_CROWBAR, flags, delay, msg, self_msg)

/**
 * Called when a wrench is used on us.
 *
 * @params
 * - I - tool
 * - user - user, can be null
 * - flags - tool operation flags
 */
/atom/proc/wrench_act(obj/item/I, mob/user, flags)
	return FALSE

/**
 * Standard helper to have a timed wrench usage.
 *
 * @params
 * - I - the item
 * - user - the user, if any
 * - flags - tool operation flags
 * - delay - how long this should take
 * - msg - standard feedback message shown to everyone around the user
 * - self_msg - standard feedback message shown to the user
 */
/atom/proc/use_wrecn(obj/item/I, mob/user, flags, delay = 0, msg, self_msg)
	return use_tool(I, user, TOOL_WRENCH, flags, delay, msg, self_msg)

/**
 * Called when a welder is used on us.
 *
 * @params
 * - I - tool
 * - user - user, can be null
 * - flags - tool operation flags
 */
/atom/proc/welder_act(obj/item/I, mob/user, flags)
	return FALSE

/**
 * Standard helper to have a timed welder usage.
 *
 * @params
 * - I - the item
 * - user - the user, if any
 * - flags - tool operation flags
 * - delay - how long this should take
 * - msg - standard feedback message shown to everyone around the user
 * - self_msg - standard feedback message shown to the user
 */
/atom/proc/use_welder(obj/item/I, mob/user, flags, delay = 0, msg, self_msg)
	return use_tool(I, user, TOOL_WELDER, flags, delay, msg, self_msg)

/**
 * Called when a pair of wirecutters is used on us.
 *
 * @params
 * - I - tool
 * - user - user, can be null
 * - flags - tool operation flags
 */
/atom/proc/wirecutter_act(obj/item/I, mob/user, flags)
	return FALSE

/**
 * Standard helper to have a timed usage of wirecutters.
 *
 * @params
 * - I - the item
 * - user - the user, if any
 * - flags - tool operation flags
 * - delay - how long this should take
 * - msg - standard feedback message shown to everyone around the user
 * - self_msg - standard feedback message shown to the user
 */
/atom/proc/use_wirecutter(obj/item/I, mob/user, flags, delay = 0, msg, self_msg)
	return use_tool(I, user, TOOL_WIRECUTTER, flags, delay, msg, self_msg)

/**
 * Called when a screwdriver is used on us.
 *
 * @params
 * - I - tool
 * - user - user, can be null
 * - flags - tool operation flags
 */
/atom/proc/screwdriver_act(obj/item/I, mob/user, flags)
	return FALSE

/**
 * Standard helper to have a timed screwdriver usage.
 *
 * @params
 * - I - the item
 * - user - the user, if any
 * - flags - tool operation flags
 * - delay - how long this should take
 * - msg - standard feedback message shown to everyone around the user
 * - self_msg - standard feedback message shown to the user
 */
/atom/proc/use_screwdriver(obj/item/I, mob/user, flags, delay = 0, msg, self_msg)
	return use_tool(I, user, TOOL_SCREWDRIVER, flags, delay, msg, self_msg)

/**
 * Called when a analyzer is used on us.
 *
 * @params
 * - I - tool
 * - user - user, can be null
 * - flags - tool operation flags
 */
/atom/proc/analyzer_act(obj/item/I, mob/user, flags)
	return FALSE

/**
 * Standard helper to have a timed analyzer usage.
 *
 * @params
 * - I - the item
 * - user - the user, if any
 * - flags - tool operation flags
 * - delay - how long this should take
 * - msg - standard feedback message shown to everyone around the user
 * - self_msg - standard feedback message shown to the user
 */
/atom/proc/use_analyzer(obj/item/I, mob/user, flags, delay = 0, msg, self_msg)
	return use_tool(I, user, TOOL_ANALYZER, flags, delay, msg, self_msg)


/**
 * Called when a multitool is used on us.
 *
 * @params
 * - I - tool
 * - user - user, can be null
 * - flags - tool operation flags
 */
/atom/proc/multitool_act(obj/item/I, mob/user, flags)
	return FALSE

/**
 * Standard helper to have a timed multitool usage.
 *
 * @params
 * - I - the item
 * - user - the user, if any
 * - flags - tool operation flags
 * - delay - how long this should take
 * - msg - standard feedback message shown to everyone around the user
 * - self_msg - standard feedback message shown to the user
 */
/atom/proc/use_multitool(obj/item/I, mob/user, flags, delay = 0, msg, self_msg)
	return use_tool(I, user, TOOL_MULTITOOL, flags, delay, msg, self_msg)

