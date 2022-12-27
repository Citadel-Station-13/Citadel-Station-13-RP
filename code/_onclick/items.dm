/**
 * Called when trying to click something that the user can Reachability() to.
 *
 * @params
 * - target - thing hitting
 * - user - user using us
 * - clickchain_flags - see [code/__DEFINES/procs/clickcode.dm]
 * - params - params as list.
 */
/obj/item/proc/melee_attack_chain(atom/target, mob/user, clickchain_flags, list/params)
	. = clickchain_flags

	if((. |= tool_attack_chain(target, user, ., params)) & CLICKCHAIN_DO_NOT_PROPAGATE)
		return

	// todo: NO. MORE. LIST. PARAMS. WHY. ARE. WE. UNPACKING. THE. LIST. MULTIPLE. TIMES?
	var/stupid_fucking_shim = list2params(params)

	// todo: refactor
	// todo: attackby/whatever signals first, use abstract entrypoint
	if(resolve_attackby(target, user, stupid_fucking_shim))
		return CLICKCHAIN_DO_NOT_PROPAGATE

	// todo: afterattack signal first
	. |= afterattack(target, user, clickchain_flags, params)

/**
 * Called when trying to click something that the user can't Reachability() to.
 *
 * @params
 * - target - thing hitting
 * - user - user using us
 * - clickchain_flags - see [code/__DEFINES/procs/clickcode.dm]
 * - params - params as list.
 */
/obj/item/proc/ranged_attack_chain(atom/target, mob/user, clickchain_flags, list/params)
	. = clickchain_flags

	// todo: afterattack signal first
	. |= afterattack(target, user, clickchain_flags, params)

/**
 * Called when trying to click something that the user can Reachability() to,
 * to allow for the tool system to intercept the attack as a tool action.
 */
/obj/item/proc/tool_attack_chain(atom/target, mob/user, clickchain_flags, list/params)
	// are we on harm intent? if so, lol no
	if(user && (user.a_intent == INTENT_HARM))
		return NONE
	return target.tool_interaction(src, user, clickchain_flags | CLICKCHAIN_TOOL_ACT)

/**
 * Called after normal mob/object attack/attackby are resolved, whether or not it's ranged or melee.
 *
 * we do **not** have to call parent.
 *
 * @return clickchain flags to add
 *
 * @params
 * - target - thing targeted
 * - user - mob attacking with us
 * - clickchain_flags - see [code/__DEFINES/procs/clickcode.dm]
 * - params - params as list.
 */
/obj/item/proc/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	return NONE
