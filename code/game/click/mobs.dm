/**
 * Called when trying to click on someone we can Reachability() to without an item in hand.
 *
 * todo: this should allow passing in a clickchain datum instead.
 * todo: lazy_melee_attack() for when you don't want to.
 *
 * @params
 * - target - thing we're clicking
 * - clickchain_flags - see [code/__DEFINES/procs/clickcode.dm]
 * - params - parameters of click, as list
 */
/mob/proc/melee_interaction_chain(atom/target, clickchain_flags, list/params)
	// todo: refactor cooldown handling
	if(ismob(target))
		setClickCooldownLegacy(get_attack_speed_legacy())
	UnarmedAttack(target, clickchain_flags & CLICKCHAIN_HAS_PROXIMITY)

/**
 * Called when trying to click on someone we can't Reachability() to without an item in hand.
 *
 * @params
 * - target - thing we're clicking
 * - clickchain_flags - see [code/__DEFINES/procs/clickcode.dm]
 * - params - parameters of click, as list
 */
/mob/proc/ranged_interaction_chain(atom/target, clickchain_flags, list/params)
	// todo: NO. MORE. TEXT. PARAMS. WHY. ARE. WE. UNPACKING. THE. LIST. MULTIPLE. TIMES?
	var/stupid_fucking_shim = list2params(params)
	RangedAttack(target, stupid_fucking_shim)

// i'm sorry
/mob/proc/sort_of_legacy_imprint_upon_melee_clickchain(datum/event_args/actor/clickchain/clickchain)
	if(IS_PRONE(src))
		clickchain.melee_damage_multiplier *= (2 / 3)

/**
 * default current unarmed attack style
 *
 * todo: kinda shitycodey but w/e
 */
/mob/proc/unarmed_attack_style()
	// none by default
	return null

// todo: melee_special for overrides (?)

/mob/proc/melee_attack(atom/target, datum/event_args/actor/clickchain/clickchain, datum/melee_attack/unarmed/style, clickchain_flags, target_zone, mult)
	SHOULD_CALL_PARENT(TRUE)
	// todo: move this somewhere else
	if(!target.integrity_enabled)
		// no targeting
		return NONE
	if(isobj(target))
		var/obj/casted = target
		if(!(casted.obj_flags & OBJ_MELEE_TARGETABLE))
			// no targeting
			return NONE

	// todo: clickcd rework
	clickchain.performer.setClickCooldownLegacy(clickchain.performer.get_attack_speed_legacy())

	. = melee_attack_hit(target, clickchain, style, clickchain_flags, target_zone, mult)

	// todo: better logging
	// todo: entity ids?
	var/newhp
	if(isliving(target))
		var/mob/living/casted = target
		newhp = casted.health
	else
		newhp = target.integrity

	. |= melee_attack_finalize(target, clickchain, style, clickchain_flags, target_zone, mult)

	log_attack(key_name(src), ismob(target)? key_name(target) : "[target] ([ref(target)])", "attacked with [style.attack_name] newhp ~[newhp || "unknown"]")

/mob/proc/melee_attack_hit(atom/target, datum/event_args/actor/clickchain/clickchain, datum/melee_attack/unarmed/style, clickchain_flags, target_zone, mult)
	. = target.unarmed_melee_act(src, style, target_zone, clickchain)
	if(. & CLICKCHAIN_ATTACK_MISSED)
		return . | melee_attack_miss(target, clickchain, style, clickchain_flags, target_zone, mult)
	// todo: the rest of this proc not qdel-safe
	playsound(src, target.hitsound_unarmed(src, style), 50, TRUE, -1)
	// todo: better feedback
	clickchain.visible_feedback(
		target = target,
		range = MESSAGE_RANGE_COMBAT_LOUD,
		visible = SPAN_DANGER("[target] has been [islist(style.verb_past_participle)? pick(style.verb_past_participle) : style.verb_past_participle] by [clickchain.performer]!")
	)
	// target.animate_hit_by_attack(style.animation_type)

/mob/proc/melee_attack_miss(atom/target, datum/event_args/actor/clickchain/clickchain, datum/melee_attack/unarmed/style, clickchain_flags, target_zone, mult)
	playsound(src, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
	clickchain.visible_feedback(
		target = target,
		range = MESSAGE_RANGE_COMBAT_LOUD,
		visible = SPAN_WARNING("[src] swings for [target], but misses!"),
	)
	return NONE

/mob/proc/melee_attack_finalize(atom/target, datum/event_args/actor/clickchain/clickchain, datum/melee_attack/unarmed/style, clickchain_flags, target_zone, mult)
	return NONE

/**
 * construct default event args for what we're doing to a target
 *
 * todo: this is semi-legacy
 */
/mob/proc/default_clickchain_event_args(atom/target, unarmed = FALSE)
	var/datum/event_args/actor/clickchain/constructed = new
	constructed.initiator = src
	constructed.performer = src
	constructed.target = target
	constructed.click_params = list()
	constructed.using_intent = a_intent
	constructed.using_hand_index = active_hand
	if(!unarmed)
		constructed.using_item = get_active_held_item()
	return constructed
