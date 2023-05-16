//! ON GOD, READ tool_system.dm's use_tool_standard to learn how to use these!

/**
 * Called when a crowbar is used on us.
 *
 * @params
 * - I - tool
 * - user - user, can be null
 * - flags - tool operation flags
 * - hint - operation hint, if using dynamic tool system
 */
/atom/proc/crowbar_act(obj/item/I, mob/user, flags, hint)
	return FALSE

/**
 * Standard helper to have a timed crowbar usage.
 *
 * See tool_system.dm's use_tool_standard to know how to use this.
 *
 * The system handles sound playback for you unless you specify to skip that, but you must manually give visible_message feedback.
 *
 * @params
 * - I - the item
 * - user - the user, if any
 * - flags - tool operation flags
 * - delay - how long this should take
 * - cost - multiplier for cost, standard tool "cost" is 1 per second of usage.
 * - usage - usage flags for skill system checks.
 */
/atom/proc/use_crowbar(obj/item/I, mob/user, flags, delay, cost, usage)
	return use_tool_standard(TOOL_CROWBAR, I, user, flags, delay, cost, usage)

/**
 * Called when a wrench is used on us.
 *
 * @params
 * - I - tool
 * - user - user, can be null
 * - flags - tool operation flags
 * - hint - operation hint, if using dynamic tool system
 */
/atom/proc/wrench_act(obj/item/I, mob/user, flags, hint)
	return FALSE

/**
 * Standard helper to have a timed wrench usage.
 *
 * See tool_system.dm's use_tool_standard to know how to use this.
 *
 * The system handles sound playback for you unless you specify to skip that, but you must manually give visible_message feedback.
 *
 * @params
 * - I - the item
 * - user - the user, if any
 * - flags - tool operation flags
 * - delay - how long this should take
 * - cost - multiplier for cost, standard tool "cost" is 1 per second of usage.
 * - usage - usage flags for skill system checks.
 */
/atom/proc/use_wrench(obj/item/I, mob/user, flags, delay, cost, usage)
	return use_tool_standard(TOOL_WRENCH, I, user, flags, delay, cost, usage)

/**
 * Called when a welder is used on us.
 *
 * @params
 * - I - tool
 * - user - user, can be null
 * - flags - tool operation flags
 * - hint - operation hint, if using dynamic tool system
 */
/atom/proc/welder_act(obj/item/I, mob/user, flags, hint)
	return FALSE

/**
 * Standard helper to have a timed welder usage.
 *
 * See tool_system.dm's use_tool_standard to know how to use this.
 *
 * The system handles sound playback for you unless you specify to skip that, but you must manually give visible_message feedback.
 *
 * @params
 * - I - the item
 * - user - the user, if any
 * - flags - tool operation flags
 * - delay - how long this should take
 * - cost - multiplier for cost, standard tool "cost" is 1 per second of usage.
 * - usage - usage flags for skill system checks.
 */
/atom/proc/use_welder(obj/item/I, mob/user, flags, delay, cost, usage)
	return use_tool_standard(TOOL_WELDER, I, user, flags, delay, cost, usage)

/**
 * Called when a pair of wirecutters is used on us.
 *
 * @params
 * - I - tool
 * - user - user, can be null
 * - flags - tool operation flags
 * - hint - operation hint, if using dynamic tool system
 */
/atom/proc/wirecutter_act(obj/item/I, mob/user, flags, hint)
	return FALSE

/**
 * Standard helper to have a timed usage of wirecutters.
 *
 * See tool_system.dm's use_tool_standard to know how to use this.
 *
 * The system handles sound playback for you unless you specify to skip that, but you must manually give visible_message feedback.
 *
 * @params
 * - I - the item
 * - user - the user, if any
 * - flags - tool operation flags
 * - delay - how long this should take
 * - cost - multiplier for cost, standard tool "cost" is 1 per second of usage.
 * - usage - usage flags for skill system checks.
 */
/atom/proc/use_wirecutter(obj/item/I, mob/user, flags, delay, cost, usage)
	return use_tool_standard(TOOL_WIRECUTTER, I, user, flags, delay, cost, usage)

/**
 * Called when a screwdriver is used on us.
 *
 * @params
 * - I - tool
 * - user - user, can be null
 * - flags - tool operation flags
 * - hint - operation hint, if using dynamic tool system
 */
/atom/proc/screwdriver_act(obj/item/I, mob/user, flags, hint)
	return FALSE

/**
 * Standard helper to have a timed screwdriver usage.
 *
 * See tool_system.dm's use_tool_standard to know how to use this.
 *
 * The system handles sound playback for you unless you specify to skip that, but you must manually give visible_message feedback.
 *
 * @params
 * - I - the item
 * - user - the user, if any
 * - flags - tool operation flags
 * - delay - how long this should take
 * - cost - multiplier for cost, standard tool "cost" is 1 per second of usage.
 * - usage - usage flags for skill system checks.
 */
/atom/proc/use_screwdriver(obj/item/I, mob/user, flags, delay, cost, usage)
	return use_tool_standard(TOOL_SCREWDRIVER, I, user, flags, delay, cost, usage)

/**
 * Called when a analyzer is used on us.
 *
 * @params
 * - I - tool
 * - user - user, can be null
 * - flags - tool operation flags
 * - hint - operation hint, if using dynamic tool system
 */
/atom/proc/analyzer_act(obj/item/I, mob/user, flags, hint)
	return FALSE

/**
 * Standard helper to have a timed analyzer usage.
 *
 * See tool_system.dm's use_tool_standard to know how to use this.
 *
 * The system handles sound playback for you unless you specify to skip that, but you must manually give visible_message feedback.
 *
 * @params
 * - I - the item
 * - user - the user, if any
 * - flags - tool operation flags
 * - delay - how long this should take
 * - cost - multiplier for cost, standard tool "cost" is 1 per second of usage.
 * - usage - usage flags for skill system checks.
 */
/atom/proc/use_analyzer(obj/item/I, mob/user, flags, delay, cost, usage)
	return use_tool_standard(TOOL_ANALYZER, I, user, flags, delay, cost, usage)


/**
 * Called when a multitool is used on us.
 *
 * @params
 * - I - tool
 * - user - user, can be null
 * - flags - tool operation flags
 * - hint - operation hint, if using dynamic tool system
 */
/atom/proc/multitool_act(obj/item/I, mob/user, flags, hint)
	return FALSE

/**
 * Standard helper to have a timed multitool usage.
 *
 * See tool_system.dm's use_tool_standard to know how to use this.
 *
 * The system handles sound playback for you unless you specify to skip that, but you must manually give visible_message feedback.
 *
 * @params
 * - I - the item
 * - user - the user, if any
 * - flags - tool operation flags
 * - delay - how long this should take
 * - cost - multiplier for cost, standard tool "cost" is 1 per second of usage.
 * - usage - usage flags for skill system checks.
 */
/atom/proc/use_multitool(obj/item/I, mob/user, flags, delay, cost, usage)
	return use_tool_standard(TOOL_MULTITOOL, I, user, flags, delay, cost, usage)

