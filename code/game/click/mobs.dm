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

/**
 * called to try to hit something in melee
 */
/mob/proc/standard_melee_attack(atom/what, datum/event_args/actor/clickchain/clickchain, datum/unarmed_attack/style = /datum/unarmed_attack/default, clickchain_flags, target_zone, mult = 1)
	if(isnull(clickchain))
		clickchain = new(src, target = what, intent = a_intent)
	// too complciated to be put in proc header
	if(isnull(target_zone))
		target_zone = user.zone_sel?.selecting
	// end
	if(clickchain_flags & CLICKCHAIN_DO_NOT_ATTACK)
		return NONE
	// todo: not hardcoding this
	if(IS_PRONE(user))
		mult *= 0.66
	// is mob, go to that
	// todo: signals for both
	if(ismob(target))
		. |= melee_mob(what, clickchain, style, clickchain_flags, target_zone, mult)
		if(. & CLICKCHAIN_DO_NOT_PROPAGATE)
			return
		return . | melee_mob_finalize(what, clickchain, style, clickchain_flags, target_zone, mult)
	// is obj, go to that
	. |= melee_object(what, clickchain, style, clickchain_flags, target_zone, mult)
	if(. & CLICKCHAIN_DO_NOT_PROPAGATE)
		return
	return . | melee_object_finalize(what, clickchain, style, clickchain_flags, target_zone, mult)

/mob/proc/melee_object(atom/target, datum/event_args/actor/clickchain/clickchain, datum/unarmed_attack/style, clickchain_flags, target_zone, mult)
	SHOULD_CALL_PARENT(TRUE)
	//? legacy: decloak
	clickchain.performer.break_cloak()

/mob/proc/melee_object_hit(atom/target, datum/event_args/actor/clickchain/clickchain, datum/unarmed_attack/style, clickchain_flags, target_zone, mult)

/mob/proc/melee_object_miss(atom/target, datum/event_args/actor/clickchain/clickchain, datum/unarmed_attack/style, clickchain_flags, target_zone, mult)
	return NONE

/mob/proc/melee_object_finalize(atom/target, datum/event_args/actor/clickchain/clickchain, datum/unarmed_attack/style, clickchain_flags, target_zone, mult)
	return NONE

/mob/proc/melee_mob(mob/target, datum/event_args/actor/clickchain/clickchain, datum/unarmed_attack/style, clickchain_flags, target_zone, mult)
	SHOULD_CALL_PARENT(TRUE)
	//? legacy: decloak
	clickchain.performer.break_cloak()
	//? legacy: for now no attacking nonliving
	if(!isliving(target))
		return

/mob/proc/melee_mob_hit(mob/target, datum/event_args/actor/clickchain/clickchain, datum/unarmed_attack/style, clickchain_flags, target_zone, mult)

/mob/proc/melee_mob_miss(mob/target, datum/event_args/actor/clickchain/clickchain, datum/unarmed_attack/style, clickchain_flags, target_zone, mult)
	return NONE

/mob/proc/melee_mob_finalize(atom/target, datum/event_args/actor/clickchain/clickchain, datum/unarmed_attack/style, clickchain_flags, target_zone, mult)
	return NONE

#warn impl all
