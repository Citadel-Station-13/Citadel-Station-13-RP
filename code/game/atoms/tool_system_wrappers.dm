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
 * @params
 * - I - the item
 * - user - the user, if any
 * - flags - tool operation flags
 * - hint - operation hint
 * - delay - how long this should take
 * - infinitive - infinitive verb, e.g. "pry"
 * - present - present ver, e.g. "pries"
 * - object - object of attention, can be atom or text, e.g. "window"
 * - target - what you're acting on/where the object is going/coming from, e.g. "frame"
 * - prepositional - what you're doing with it, null this out to be `object's target` instead of `object preposition \the target`, e.g. "into the"
 * - append - if TRUE, will include "with the bonecutters" or whatever phrase is describing the tool.
 * - cost - multiplier for cost, standard tool "cost" is 1 per second of usage.
 * - usage - usage flags for skill system checks.
 */
/atom/proc/use_crowbar(obj/item/I, mob/user, flags, hint, delay, infinitive, present, object, target, preposition, append, cost, usage)
	return use_tool(I, user, flags, TOOL_CROWBAR, hint, delay, infinitive, present, object, target, preposition, append, cost, usage)

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
 * @params
 * - I - the item
 * - user - the user, if any
 * - flags - tool operation flags
 * - hint - operation hint
 * - delay - how long this should take
 * - infinitive - infinitive verb, e.g. "pry"
 * - present - present ver, e.g. "pries"
 * - object - object of attention, can be atom or text, e.g. "window"
 * - target - what you're acting on/where the object is going/coming from, e.g. "frame"
 * - prepositional - what you're doing with it, null this out to be `object's target` instead of `object preposition \the target`, e.g. "into the"
 * - append - if TRUE, will include "with the bonecutters" or whatever phrase is describing the tool.
 * - cost - multiplier for cost, standard tool "cost" is 1 per second of usage.
 * - usage - usage flags for skill system checks.
 */
/atom/proc/use_wrecnh(obj/item/I, mob/user, flags, hint, delay, infinitive, present, object, target, preposition, append, cost, usage)
	return use_tool(I, user, flags, TOOL_WRENCH, hint, delay, infinitive, present, object, target, preposition, append, cost, usage)

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
 * @params
 * - I - the item
 * - user - the user, if any
 * - flags - tool operation flags
 * - hint - operation hint
 * - delay - how long this should take
 * - infinitive - infinitive verb, e.g. "pry"
 * - present - present ver, e.g. "pries"
 * - object - object of attention, can be atom or text, e.g. "window"
 * - target - what you're acting on/where the object is going/coming from, e.g. "frame"
 * - prepositional - what you're doing with it, null this out to be `object's target` instead of `object preposition \the target`, e.g. "into the"
 * - append - if TRUE, will include "with the bonecutters" or whatever phrase is describing the tool.
 * - cost - multiplier for cost, standard tool "cost" is 1 per second of usage.
 * - usage - usage flags for skill system checks.
 */
/atom/proc/use_welder(obj/item/I, mob/user, flags, hint, delay, infinitive, present, object, target, preposition, append, cost, usage)
	return use_tool(I, user, flags, TOOL_WELDER, hint, delay, infinitive, present, object, target, preposition, append, cost, usage)

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
 * @params
 * - I - the item
 * - user - the user, if any
 * - flags - tool operation flags
 * - hint - operation hint
 * - delay - how long this should take
 * - infinitive - infinitive verb, e.g. "pry"
 * - present - present ver, e.g. "pries"
 * - object - object of attention, can be atom or text, e.g. "window"
 * - target - what you're acting on/where the object is going/coming from, e.g. "frame"
 * - prepositional - what you're doing with it, null this out to be `object's target` instead of `object preposition \the target`, e.g. "into the"
 * - append - if TRUE, will include "with the bonecutters" or whatever phrase is describing the tool.
 * - cost - multiplier for cost, standard tool "cost" is 1 per second of usage.
 * - usage - usage flags for skill system checks.
 */
/atom/proc/use_wirecutter(obj/item/I, mob/user, flags, hint, delay, infinitive, present, object, target, preposition, append, cost, usage)
	return use_tool(I, user, flags, TOOL_WIRECUTTER, hint, delay, infinitive, present, object, target, preposition, append, cost, usage)

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
 * @params
 * - I - the item
 * - user - the user, if any
 * - flags - tool operation flags
 * - hint - operation hint
 * - delay - how long this should take
 * - infinitive - infinitive verb, e.g. "pry"
 * - present - present ver, e.g. "pries"
 * - object - object of attention, can be atom or text, e.g. "window"
 * - target - what you're acting on/where the object is going/coming from, e.g. "frame"
 * - prepositional - what you're doing with it, null this out to be `object's target` instead of `object preposition \the target`, e.g. "into the"
 * - append - if TRUE, will include "with the bonecutters" or whatever phrase is describing the tool.
 * - cost - multiplier for cost, standard tool "cost" is 1 per second of usage.
 * - usage - usage flags for skill system checks.
 */
/atom/proc/use_screwdriver(obj/item/I, mob/user, flags, hint, delay, infinitive, present, object, target, preposition, append, cost, usage)
	return use_tool(I, user, flags, TOOL_SCREWDRIVER, hint, delay, infinitive, present, object, target, preposition, append, cost, usage)

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
 * @params
 * - I - the item
 * - user - the user, if any
 * - flags - tool operation flags
 * - hint - operation hint
 * - delay - how long this should take
 * - infinitive - infinitive verb, e.g. "pry"
 * - present - present ver, e.g. "pries"
 * - object - object of attention, can be atom or text, e.g. "window"
 * - target - what you're acting on/where the object is going/coming from, e.g. "frame"
 * - prepositional - what you're doing with it, null this out to be `object's target` instead of `object preposition \the target`, e.g. "into the"
 * - append - if TRUE, will include "with the bonecutters" or whatever phrase is describing the tool.
 * - cost - multiplier for cost, standard tool "cost" is 1 per second of usage.
 * - usage - usage flags for skill system checks.
 */
/atom/proc/use_analyzer(obj/item/I, mob/user, flags, hint, delay, infinitive, present, object, target, preposition, append, cost, usage)
	return use_tool(I, user, flags, TOOL_ANALYZER, hint, delay, infinitive, present, object, target, preposition, append, cost, usage)


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
 * @params
 * - I - the item
 * - user - the user, if any
 * - flags - tool operation flags
 * - hint - operation hint
 * - delay - how long this should take
 * - infinitive - infinitive verb, e.g. "pry"
 * - present - present ver, e.g. "pries"
 * - object - object of attention, can be atom or text, e.g. "window"
 * - target - what you're acting on/where the object is going/coming from, e.g. "frame"
 * - prepositional - what you're doing with it, null this out to be `object's target` instead of `object preposition \the target`, e.g. "into the"
 * - append - if TRUE, will include "with the bonecutters" or whatever phrase is describing the tool.
 * - cost - multiplier for cost, standard tool "cost" is 1 per second of usage.
 * - usage - usage flags for skill system checks.
 */
/atom/proc/use_multitool(obj/item/I, mob/user, flags, hint, delay, infinitive, present, object, target, preposition, append, cost, usage)
	return use_tool(I, user, flags, TOOL_MULTITOOL, hint, delay, infinitive, present, object, target, preposition, append, cost, usage)

