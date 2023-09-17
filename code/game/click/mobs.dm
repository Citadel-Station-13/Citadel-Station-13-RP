/**
 * Called when trying to click on someone we can Reachability() to without an item in hand.
 *
 * @params
 * - target - thing we're clicking
 * - clickchain_flags - see [code/__DEFINES/procs/clickcode.dm]
 * - params - parameters of click, as list
 */
/mob/proc/melee_attack_chain(atom/target, clickchain_flags, list/params)
	// todo: refactor cooldown handling
	if(ismob(target))
		setClickCooldown(get_attack_speed())
	UnarmedAttack(target, clickchain_flags & CLICKCHAIN_HAS_PROXIMITY)

/**
 * Called when trying to click on someone we can't Reachability() to without an item in hand.
 *
 * @params
 * - target - thing we're clicking
 * - clickchain_flags - see [code/__DEFINES/procs/clickcode.dm]
 * - params - parameters of click, as list
 */
/mob/proc/ranged_attack_chain(atom/target, clickchain_flags, list/params)
	// todo: NO. MORE. LIST. PARAMS. WHY. ARE. WE. UNPACKING. THE. LIST. MULTIPLE. TIMES?
	var/stupid_fucking_shim = list2params(params)
	RangedAttack(target, stupid_fucking_shim)
