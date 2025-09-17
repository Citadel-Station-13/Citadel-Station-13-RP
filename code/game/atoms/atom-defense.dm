//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//! Welcome to hell.

// todo: everything needs comsigs comsigs comsigs

//* Targeting *//

/**
 * Checks if we should be targetable in melee.
 */
/atom/proc/is_melee_targetable(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	return FALSE

//* External API / Damage Receiving *//

/**
 * todo: implement on most atoms/generic damage system
 * todo: replace legacy_ex_act entirely with this
 *
 * React to being hit by an explosive shockwave
 *
 * ? Tip for overrides: . = ..() when you want signal to be sent, mdify power before if you need to; to ignore parent
 * ? block power, just `return power` in your proc after . = ..().
 *
 * @params
 * - power - power our turf was hit with
 * - direction - DIR_BIT bits; can bwe null if it wasn't a wave explosion!!
 * - explosion - explosion automata datum; can be null
 *
 * @return power after falloff (e.g. hit with 30 power, return 20 to apply 10 falloff)
 */
/atom/proc/ex_act(power, dir, datum/automata/wave/explosion/E)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_ATOM_EX_ACT, power, dir, E)
	return power

//* External API / Damage Receiving - Melee *//

/**
 * called on incoming item melee
 *
 * * At this point, the item is processing a hit on us.
 * * check CLICKCHAIN_FLAGS_* as needed, especially MISSED, UNCONDITIONAL_ABORT, and ATTACK_ABORT
 * * clickchain flags are sent down through parent calls, so check `.` after `..()`
 *
 * @params
 * * attacker - person attacking
 * * weapon - weapon used, if any
 * * style - attack style
 * * target_zone - zone targeted
 * * clickchain - (optional) clickchain used
 * * clickchain_flags - (optional) clickchain flags used
 *
 * @return clickchain flags
 */
/atom/proc/melee_act(mob/attacker, obj/item/weapon, datum/melee_attack/weapon/style, target_zone, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = clickchain_flags
	var/shieldcall_returns = atom_shieldcall_handle_melee(clickchain, ., weapon, style, FALSE, NONE)
	if(shieldcall_returns & SHIELDCALL_FLAGS_BLOCK_ATTACK)
		. |= CLICKCHAIN_FULL_BLOCKED
	// todo: shieldcall being able to force a miss

/**
 * Called on a melee going through, whether or not it was blocked
 *
 * * This is in charge of calling the actual attack impact.
 *
 * @params
 * * attacker - person attacking
 * * weapon - weapon used, if any
 * * style - attack style
 * * target_zone - zone targeted
 * * clickchain - (optional) clickchain used
 * * clickchain_flags - (optional) clickchain flags used
 *
 * @return clickchain flags
 */
/atom/proc/on_melee_act(mob/attacker, obj/item/weapon, datum/melee_attack/attack_style, target_zone, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = attack_style.perform_attack_impact(attacker, src, clickchain_flags & CLICKCHAIN_ATTACK_MISSED, weapon, clickchain, clickchain_flags)

/**
 * Called to react to a melee damage instance.
 *
 * * Treated as an optional call; legacy code will generally not call this.
 * * Normally called from attack_style's standard damage instance handling
 * * This is called after the damage instance is applied; this means 'damage instance reuslts' are read only.
 *
 * @params
 * * attacker - person attacking
 * * weapon - (optional) weapon used, if any
 * * style - attack style
 * * target_zone - zone targeted
 * * clickchain - (optional) clickchain used
 * * clickchain_flags - (optional) clickchain flags used
 * * damage_instance_results - (optional) (read-only) SHIELDCALL_ARG_* indexed arg returns from the damage instance resolving
 */
/atom/proc/on_melee_impact(mob/attacker, obj/item/weapon, datum/melee_attack/attack_style, target_zone, datum/event_args/actor/clickchain/clickchain, clickchain_flags, list/damage_instance_results)
	return

//* External API / Damage Receiving - Projectiles *//

/**
 * Because this is the proc that calls on_impact(), handling is necessarily
 * done in here for a lot of things.
 *
 * * Overrides should modify proc args directly (e.g. impact_flags) and then call ..()
 *   if it needs to be taken account by default handling.
 * * Overrides should not edit args after ..(), as args are only passed up, not down.
 * * Overrides should, for that reason, always call ..() last.
 * * This semantically means 'we are **about** to be hit, do anything for special processing'.
 * * If you need to delete a projectile on impact, use `on_bullet_act()`; that's called after the contact actually happens.
 *
 * Things to keep in mind
 * * 'efficiency' arg is **extremely** powerful. Please don't lower it to dismal values for no reason.
 * * use PROJECTILE_IMPACT_BLOCKED instead of setting efficiency to 0 if an impact is entirely blocked
 * * semantically, efficiency 0 means shield from all damages, IMPACT_BLOCKED means it hit something else
 * * bullet_act is this way because we don't make a `/datum/event_args/actor/clickchain` with every call, so it needs a way of propagating blocking behavior and impact flags up/down the chain.
 *
 * @params
 * * proj - the projectile
 * * impact_flags - PROJECTILE_IMPACT_* flags
 * * def_zone - impacting zone; calculated by projectile side, usually
 * * efficiency - 0 to 1, inclusive. ratio of effects, including damage, to pass through.
 *
 * todo: add PROJECTILE_IMPACT_DELETE_AFTER as opposed to DELETE? so rest of effects can still run
 * todo: shieldcalls still fire if target aborts without unconditional abort, they should not do that.
 *
 * @return new impact_flags
 */
/atom/proc/bullet_act(obj/projectile/proj, impact_flags, def_zone, efficiency = 1)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)
	// lower calls can change flags before we trigger
	// check if we're still hitting
	if(impact_flags & PROJECTILE_IMPACT_FLAGS_UNCONDITIONAL_ABORT)
		return impact_flags
	// 0. fire signal
	SEND_SIGNAL(src, COMSIG_ATOM_BULLET_ACT, args)
	// check if we're still hitting
	if(impact_flags & PROJECTILE_IMPACT_FLAGS_UNCONDITIONAL_ABORT)
		return impact_flags
	// 1. fire shieldcalls
	atom_shieldcall_handle_bullet(args, FALSE, NONE)
	// check if we're still hitting
	if(impact_flags & PROJECTILE_IMPACT_FLAGS_UNCONDITIONAL_ABORT)
		return impact_flags
	// 2. fire on_bullet_act
	impact_flags |= on_bullet_act(proj, impact_flags, args)
	if(impact_flags & PROJECTILE_IMPACT_FLAGS_UNCONDITIONAL_ABORT)
		return impact_flags
	// 3. fire projectile-side on_impact
	return proj.on_impact(src, impact_flags, def_zone, efficiency)

/**
 * So, turns out, BYOND passes `args` list **down** on a ..() via arglist(args) equivalent but not back up.
 *
 * This means that modified bullet act args can't actually propagate through.
 * To handle this, we have this function to actually perform the effects of said bullet act.
 *
 * * This basically semantically means 'we are being hit, do effects for it'.
 * * This is called before the projectile-side impact, which is where the damage is usually inflicted.
 * * Modify `impact_flags` directly before ..(), and via the `.` variable after ..()
 * * Check `.` after ..() if it isn't the last call so you know when to abort the processing as needed.
 * * Args will propagate **up** (closer to /atom) `..()` calls, but not back down (if base `/atom` changes something you won't get it on your sub-type)
 * * For this reason `bullet_act_args` is provided so you can mutably edit it. Do **not** edit the projectile or the impact flags; return the impact flags for automatic addition.
 *
 * @params
 * * proj - hitting projectile; immutable
 * * impact_flags - impact flags; immutable. edit directly before ..() call, return edited values after.
 * * bullet_act_args - access to the rest of the args in `bullet_act`. Mutable, except for the projectile and the impact flags.
 *
 * @return mutated impact flags
 */
/atom/proc/on_bullet_act(obj/projectile/proj, impact_flags, list/bullet_act_args)
	SHOULD_NOT_SLEEP(TRUE)
	var/resolved_impact_sound = hitsound_projectile(proj, impact_flags, bullet_act_args)
	if(resolved_impact_sound)
		playsound(src, resolved_impact_sound, 75, TRUE)
	if(!(impact_flags & (PROJECTILE_IMPACT_BLOCKED | PROJECTILE_IMPACT_SKIP_STANDARD_DAMAGE)))
		impact_flags |= proj.inflict_impact_damage(src, bullet_act_args[BULLET_ACT_ARG_EFFICIENCY], impact_flags, bullet_act_args[BULLET_ACT_ARG_ZONE])
	return impact_flags

//* External API / Damage Receiving - Electric *//

/**
 * Called to inflict an electrical shock on this atom.
 *
 * * Passing in no damage / stun power is perfectly valid; you can get calculated 'efficiency' / energy used
 *   by getting returned args.
 *
 * @params
 * * energy - energy, in **kilojoules**
 * * damage - 'intended' burn damage.
 *            this should be scaled to an intent of being used on a carbon-type.
 *            do not scale this to things like walls / high-hp structures. most structures
 *            don't get damaged by electric shocks anyways.
 * * stun_power - 'intended' agony / pain / stun force
 *            this should be scaled to an intent of being used on a carbon-type as pain damage.
 *            that said, not only carbon-types are allowed to use this.
 * * flags - ELECTROCUTE_ACT_* flags
 * * hit_zone - if specified and non-internal, this zone will be used to check armor.
 * * source - the source of the electric shock, if provided.
 *            any movable is a valid value; you are expected to handle touch (unspecified / obj / mob),
 *            and projectile sources if you are using this.
 * * shared_blackboard - (optional) list to both inject into and retrieve data from.
 *                as a word of warning, this list **will** be a shared list if being used
 *                in things like multi-hit lightning bolts; we do not make a new list per atom.
 *
 * @return modified `electrocute_act` args list, indiced with `ELECTROCUTE_ACT_ARG_*` #define indices.
 */
/atom/proc/electrocute(energy, damage, stun_power, flags, hit_zone, atom/movable/source, list/shared_blackboard)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)
	return electrocute_act(1, energy, damage, stun_power, flags, hit_zone, source, shared_blackboard, 0)

/**
 * Called upon receiving an electrical shock of any kind
 *
 * * This proc-chain should modify arguments directly before calling ..()
 * * Effects are handled at the base by calling on_electrocute_act()
 *
 * @params
 * * efficiency - effect multiplier. this should be multiplied to damage / agony / energy / etc
 *                to get the approximate amount that actually hit us.
 * * energy - energy, in **kilojoules**
 * * damage - 'intended' burn damage.
 *            this should be scaled to an intent of being used on a carbon-type.
 *            do not scale this to things like walls / high-hp structures. most structures
 *            don't get damaged by electric shocks anyways.
 * * stun_power - 'intended' agony / pain / stun force
 *            this should be scaled to an intent of being used on a carbon-type as pain damage.
 *            that said, not only carbon-types are allowed to use this.
 * * flags - ELECTROCUTE_ACT_* flags
 * * hit_zone - if specified and non-internal, this zone will be used to check armor.
 * * source - the source of the electric shock, if provided.
 *            any movable is a valid value; you are expected to handle touch (unspecified / obj / mob),
 *            and projectile sources if you are using this.
 * * shared_blackboard - (optional) list to both inject into and retrieve data from.
 *                as a word of warning, this list **will** be a shared list if being used
 *                in things like multi-hit lightning bolts; we do not make a new list per atom.
 * * out_energy_consumed - This will be set to the return value of `on_electrocute_act()`.
 *
 * @return modified args
 */
/atom/proc/electrocute_act(efficiency, energy, damage, stun_power, flags, hit_zone, atom/movable/source, list/shared_blackboard, out_energy_consumed)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	PROTECTED_PROC(TRUE)
	out_energy_consumed = on_electrocute_act(efficiency, energy, damage, stun_power, flags, hit_zone, source, shared_blackboard, out_energy_consumed)
	return args.Copy()

/**
 * Called to handle effects of receiving an electrical shock.
 *
 * * This is called by `electrocute_act` to inflict effects.
 * * Modifying args is still allowed here, but will **not** be returned to the caller.
 *
 * @params
 * * efficiency - effect multiplier. this should be multiplied to damage / agony / energy / etc
 *                to get the approximate amount that actually hit us.
 * * energy - energy, in **kilojoules**
 * * damage - 'intended' burn damage.
 *            this should be scaled to an intent of being used on a carbon-type as pain damage.
 *            do not scale this to things like walls / high-hp structures. most structures
 *            don't get damaged by electric shocks anyways.
 * * stun_power - 'intended' agony / pain / stun force
 *            this should be scaled to an intent of being used on a carbon-type.
 *            that said, not only carbon-types are allowed to use this.
 * * flags - ELECTROCUTE_ACT_* flags
 * * hit_zone - if specified and non-internal, this zone will be used to check armor.
 * * source - the source of the electric shock, if provided.
 *            any movable is a valid value; you are expected to handle touch (unspecified / obj / mob),
 *            and projectile sources if you are using this.
 * * shared_blackboard - (optional) list to both inject into and retrieve data from.
 *                as a word of warning, this list **will** be a shared list if being used
 *                in things like multi-hit lightning bolts; we do not make a new list per atom.
 *
 * @return used energy in kilojoules
 */
/atom/proc/on_electrocute_act(efficiency, energy, damage, stun_power, flags, hit_zone, atom/movable/source, list/shared_blackboard)
	SHOULD_CALL_PARENT(TRUE)
	PROTECTED_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	return 0

//* FX API *//

/**
 * Gets the COMBAT_FX_* enum that we count as for a given hit
 *
 * @params
 * * attack_type - ATTACK_TYPE_* enum
 * * weapon - (optional) the value of this depends on the attack type; check defines folder for attack type
 * * target_zone - (optional) where were we hit
 *
 * @return COMBAT_IMPACT_FX_* classifier
 */
/atom/proc/get_combat_fx_classifier(attack_type, datum/attack_source, target_zone)
	return COMBAT_IMPACT_FX_GENERIC

//* Hitsound API *//

// todo: stuff like metal limbs punching walls making special sounds
// todo: this probably needs a rework

/**
 * gets hitsound override. return a value to be fed into playsound, or null for default.
 *
 * @params
 * * damage_type - damage type like brute / burn / etc
 * * damage_mode - damage mode for piercing / whatnot
 * * attack_type - attack type enum like melee / projectile / thrown / unarmed / etc
 * * weapon - attacking /obj/item for melee / thrown, /obj/projectile for ranged, /mob for unarmed
 */
/atom/proc/hitsound_override(damage_type, damage_mode, attack_type, datum/attack_source)
	return // default is null

/atom/proc/hitsound_melee(obj/item/I)
	. = I.attacksound_override(src, ATTACK_TYPE_MELEE)
	if(!isnull(.))
		return
	. = hitsound_override(I.damage_type, I.damage_mode, ATTACK_TYPE_MELEE)
	if(.)
		return
	. = (I.damage_type == DAMAGE_TYPE_BURN? hit_sound_burn : hit_sound_brute) || I.attack_sound
	if(.)
		return
	switch(I.damage_type)
		if(DAMAGE_TYPE_BRUTE)
			return "swing_hit"
		if(DAMAGE_TYPE_BURN)
			return "'sound/items/welder.ogg"
		else
			return "swing_hit"

/atom/proc/hitsound_projectile(obj/projectile/P, impact_flags, list/bullet_act_args)
	//? todo: projectile gets final say
	. = hitsound_override(P.damage_type, P.damage_mode, ATTACK_TYPE_PROJECTILE, P)
	if(.)
		return
	return P.resolve_impact_sfx(get_combat_fx_classifier(ATTACK_TYPE_PROJECTILE, P, bullet_act_args[BULLET_ACT_ARG_ZONE]), src)

/atom/proc/hitsound_throwhit(atom/movable/impacting)
	var/resolved_damage_type = DAMAGE_TYPE_BRUTE
	var/resolved_damage_mode = NONE
	var/resolved_impacting_attack_sound
	if(isitem(impacting))
		var/obj/item/casted_item = impacting
		resolved_damage_type = casted_item.damage_type
		resolved_damage_mode = casted_item.damage_mode
		resolved_impacting_attack_sound = casted_item.attack_sound
		. = casted_item.attacksound_override(src, ATTACK_TYPE_THROWN)
	if(!isnull(.))
		return
	. = hitsound_override(resolved_damage_type, resolved_damage_mode, ATTACK_TYPE_THROWN, impacting)
	if(.)
		return
	. = (resolved_damage_type == DAMAGE_TYPE_BURN? hit_sound_burn : hit_sound_brute) || resolved_impacting_attack_sound
	if(.)
		return
	switch(resolved_damage_type)
		if(DAMAGE_TYPE_BRUTE)
			return "swing_hit"
		if(DAMAGE_TYPE_BURN)
			return 'sound/items/welder.ogg'
		else
			return "swing_hit"

/atom/proc/hitsound_unarmed(mob/M, datum/melee_attack/unarmed/style)
	//? todo: style gets final say
	. = hitsound_override(M, style.damage_mode, ATTACK_TYPE_MELEE)
	if(.)
		return
	// todo: way to override this from style side? we don't just want hitsound brute/burn.
	. = (style.damage_type == DAMAGE_TYPE_BURN? hit_sound_burn : hit_sound_brute) || style.attack_sound


//* Armor *//

/**
 * resets our armor to initial values
 */
/atom/proc/reset_armor()
	set_armor(initial(armor_type))

/**
 * sets our armor
 *
 * @params
 * * what - list of armor values or a /datum/armor path
 */
/atom/proc/set_armor(what)
	armor = fetch_armor_struct(what)

/**
 * gets our armor datum or otherwise make sure it exists
 */
/atom/proc/fetch_armor()
	RETURN_TYPE(/datum/armor)
	return armor || (armor = generate_armor())

/**
 * get default armor datum
 */
/atom/proc/generate_armor()
	return fetch_armor_struct(armor_type)

/**
 * runs an attack against armor
 *
 * * side effects are **not** allowed
 * * this is the 'just checking' version.
 *
 * params are modified and then returned as a list
 *
 * * See [atom_shieldcall()] for what is going on here.
 * * SHIELDCALL_ARG_* are used as the return list's indices.
 *
 * @params
 * * damage - raw damage
 * * damage_type - damage type
 * * tier - penetration / attack tier
 * * flag - armor flag as seen in [code/__DEFINES/combat/armor.dm]
 * * mode - damage_mode
 * * attack_type - (optional) attack type flags from [code/__DEFINES/combat/attack_types.dm]
 * * weapon - (optional) the attacking weapon datum; see [code/__DEFINES/combat/shieldcall.dm]
 * * flags - shieldcall flags passed through components. [code/__DEFINES/combat/shieldcall.dm]
 * * hit_zone - where were they hit?
 * * additional - a way to retrieve data out of the shieldcall, passed in by attacks. [code/__DEFINES/combat/shieldcall.dm]
 * * clickchain - the clickchain for melee attacks.
 *
 * @return args, modified, as list.
 */
/atom/proc/check_armor(SHIELDCALL_PROC_HEADER)
	SHOULD_NOT_SLEEP(TRUE)
	run_armorcalls(args, TRUE)
	return args.Copy()

/**
 * runs an attack against armor
 *
 * * side effects are allowed
 *
 * params are modified and then returned as a list
 *
 * * See [atom_shieldcall()] for what is going on here.
 * * SHIELDCALL_ARG_* are used as the return list's indices.
 *
 * @params
 * * damage - raw damage
 * * damage_type - damage type
 * * tier - penetration / attack tier
 * * flag - armor flag as seen in [code/__DEFINES/combat/armor.dm]
 * * mode - damage_mode
 * * attack_type - (optional) attack type flags from [code/__DEFINES/combat/attack_types.dm]
 * * weapon - (optional) the attacking weapon datum; see [code/__DEFINES/combat/shieldcall.dm]
 * * flags - shieldcall flags passed through components. [code/__DEFINES/combat/shieldcall.dm]
 * * hit_zone - where were they hit?
 * * additional - a way to retrieve data out of the shieldcall, passed in by attacks. [code/__DEFINES/combat/shieldcall.dm]
 * * clickchain - the clickchain for melee attacks.
 *
 * @return args, modified, as list.
 */
/atom/proc/run_armor(SHIELDCALL_PROC_HEADER)
	SHOULD_NOT_SLEEP(TRUE)
	run_armorcalls(args, FALSE)
	return args.Copy()

/**
 * Runs a damage instance against armor
 *
 * * This is a low level proc. Make sure you undersatnd how shieldcalls work [__DEFINES/combat/shieldcall.dm].
 */
/atom/proc/run_armorcalls(list/shieldcall_args, fake_attack)
	SHOULD_NOT_SLEEP(TRUE)
	PROTECTED_PROC(TRUE)
	SEND_SIGNAL(src, COMSIG_ATOM_ARMORCALL, shieldcall_args, fake_attack)
	if(shieldcall_args[SHIELDCALL_ARG_FLAGS] & SHIELDCALL_FLAG_TERMINATE)
		return
	var/datum/armor/our_armor = fetch_armor()
	our_armor.handle_shieldcall(shieldcall_args, fake_attack)

//* Shieldcalls *//

/**
 * runs an attack against shields
 *
 * * side effects are **not** allowed
 * * this is the 'just checking' version.
 *
 * params are modified and then returned as a list
 *
 * * This is the dynamic shieldcall system. It's best to do what you want in specific shieldcall hooks if possible.
 * * What this means is that this can't, say, redirect or delete a projectile, because bullet act handling is where that happens.
 * * This more or less just lets you modify incoming damage instances sometimes.
 * * The args are not copied! They're passed back directly. This has implications.
 * * Make sure you pass in SHIELDCALL_FLAG_SECOND_CALL if **any** kind of shieldcall invocation has happened during this attack.
 * * SECOND_CALL is required to tell things that something is not the first time, so you don't get doubled blocking efficiency.
 *
 * @params
 * * damage - raw damage
 * * damage_type - damage type
 * * damage_tier - penetration / attack tier
 * * damage_flag - armor flag as seen in [code/__DEFINES/combat/armor.dm]
 * * damage_mode - damage_mode
 * * attack_type - (optional) attack type flags from [code/__DEFINES/combat/attack_types.dm]
 * * weapon - (optional) the attacking weapon datum; see [code/__DEFINES/combat/shieldcall.dm]
 * * shieldcall_flags - shieldcall flags passed through components. [code/__DEFINES/combat/shieldcall.dm]
 * * hit_zone - where were they hit?
 * * additional - a way to retrieve data out of the shieldcall, passed in by attacks. [code/__DEFINES/combat/shieldcall.dm]
 * * clickchain - the clickchain for melee attacks.
 *
 * @return args, modified, as list.
 */
/atom/proc/atom_shieldcheck(SHIELDCALL_PROC_HEADER)
	SHOULD_NOT_SLEEP(TRUE)
	run_shieldcalls(args, TRUE)
	return args.Copy()

/**
 * runs an attack against shields
 *
 * * side effects are allowed
 * * this is run during an actual attack
 *
 * params are modified and then returned as a list
 *
 * * This is the dynamic shieldcall system. It's best to do what you want in specific shieldcall hooks if possible.
 * * What this means is that this can't, say, redirect or delete a projectile, because bullet act handling is where that happens.
 * * This more or less just lets you modify incoming damage instances sometimes.
 * * The args are not copied! They're passed back directly. This has implications.
 * * Make sure you pass in SHIELDCALL_FLAG_SECOND_CALL if **any** kind of shieldcall invocation has happened during this attack.
 * * SECOND_CALL is required to tell things that something is not the first time, so you don't get doubled blocking efficiency.
 *
 * @params
 * * damage - raw damage
 * * damage_type - damage type
 * * damage_tier - penetration / attack tier
 * * damage_flag - armor flag as seen in [code/__DEFINES/combat/armor.dm]
 * * damage_mode - damage_mode
 * * attack_type - (optional) attack type flags from [code/__DEFINES/combat/attack_types.dm]
 * * weapon - (optional) the attacking weapon datum; see [code/__DEFINES/combat/shieldcall.dm]
 * * shieldcall_flags - shieldcall flags passed through components. [code/__DEFINES/combat/shieldcall.dm]
 * * hit_zone - where were they hit?
 * * additional - a way to retrieve data out of the shieldcall, passed in by attacks. [code/__DEFINES/combat/shieldcall.dm]
 * * clickchain - the clickchain for melee attacks.
 *
 * @return args, modified, as list.
 */
/atom/proc/atom_shieldcall(SHIELDCALL_PROC_HEADER)
	SHOULD_NOT_SLEEP(TRUE)
	run_shieldcalls(args, FALSE)
	return args.Copy()

/**
 * Runs a damage instance against shieldcalls
 *
 * * This is a low level proc. Make sure you understand how shieldcalls work [__DEFINES/combat/shieldcall.dm].
 */
/atom/proc/run_shieldcalls(list/shieldcall_args, fake_attack)
	SHOULD_NOT_SLEEP(TRUE)
	PROTECTED_PROC(TRUE)
	SEND_SIGNAL(src, COMSIG_ATOM_SHIELDCALL, shieldcall_args, fake_attack)
	if(shieldcall_args[SHIELDCALL_ARG_FLAGS] & SHIELDCALL_FLAG_TERMINATE)
		return
	for(var/datum/shieldcall/calling as anything in shieldcalls)
		if(!calling.low_level_intercept)
			continue
		calling.handle_shieldcall(src, args, fake_attack)
		if(shieldcall_args[SHIELDCALL_ARG_FLAGS] & SHIELDCALL_FLAG_TERMINATE)
			break

/atom/proc/register_shieldcall(datum/shieldcall/delegate)
	SHOULD_NOT_SLEEP(TRUE)
	LAZYINITLIST(shieldcalls)
	BINARY_INSERT(delegate, shieldcalls, /datum/shieldcall, delegate, priority, COMPARE_KEY)

/atom/proc/unregister_shieldcall(datum/shieldcall/delegate)
	SHOULD_NOT_SLEEP(TRUE)
	LAZYREMOVE(shieldcalls, delegate)

//* Shieldcalls - Focused / High-Level *//

/**
 * Runs shieldcalls for handle_touch
 *
 * * Use this instead of manually looping, as it fires a signal that makes things like /datum/passive_parry spin up.
 *
 * @params
 * * clickchain (optional) the clickchain event, if any; **This is mutable.**
 * * clickchain_flags (optional) the clickchain flags being used
 * * contact_flags - SHIELDCALL_CONTACT_FLAG_*
 * * contact_specific - SHIELDCALL_CONTACT_SPECIFIC_*
 * * fake_attack - just checking!
 * * shieldcall_flags - shieldcall flags. [code/__DEFINES/combat/shieldcall.dm]
 *
 * @return SHIELDCALL_FLAG_* flags
 */
/atom/proc/atom_shieldcall_handle_touch(datum/event_args/actor/clickchain/clickchain, clickchain_flags, contact_flags, contact_specific, fake_attack, shieldcall_flags)
	SHOULD_NOT_SLEEP(TRUE)
	// cannot parry yourself
	if(clickchain?.performer == src)
		return shieldcall_flags
	// send query signal
	SEND_SIGNAL(src, COMSIG_ATOM_SHIELDCALL_ITERATION, ATOM_SHIELDCALL_ITERATING_TOUCH)
	. = shieldcall_flags
	for(var/datum/shieldcall/shieldcall as anything in shieldcalls)
		. |= shieldcall.handle_touch(src, ., fake_attack, clickchain, clickchain_flags, contact_flags, contact_specific)

/**
 * Runs shieldcalls for handle_melee
 *
 * * Use this instead of manually looping, as it fires a signal that makes things like /datum/passive_parry spin up.
 *
 * @params
 * * clickchain (optional) the clickchain event, if any; **This is mutable.**
 * * clickchain_flags (optional) the clickchain flags being used
 * * weapon - (optional) the item being used to swing with
 * * style - the melee_attack/weapon datum being used
 * * fake_attack - (optional) just checking!
 * * shieldcall_flags - (optional) shieldcall flags. [code/__DEFINES/combat/shieldcall.dm]
 *
 * @return SHIELDCALL_FLAG_* flags
 */
/atom/proc/atom_shieldcall_handle_melee(datum/event_args/actor/clickchain/clickchain, clickchain_flags, obj/item/weapon, datum/melee_attack/weapon/style, fake_attack, shieldcall_flags)
	SHOULD_NOT_SLEEP(TRUE)
	// cannot parry yourself
	if(clickchain.performer == src)
		return shieldcall_flags
	// send query signal
	SEND_SIGNAL(src, COMSIG_ATOM_SHIELDCALL_ITERATION, ATOM_SHIELDCALL_ITERATING_MELEE)
	. = shieldcall_flags
	for(var/datum/shieldcall/shieldcall as anything in shieldcalls)
		. |= shieldcall.handle_melee(src, ., fake_attack, clickchain, clickchain_flags, weapon, style)

/**
 * Runs shieldcalls for handle_bullet
 *
 * * Use this instead of manually looping, as it fires a signal that makes things like /datum/passive_parry spin up.
 *
 * @params
 * * bullet_act_args - indexed list of bullet_act args.
 * * fake_attack - just checking!
 * * shieldcall_flags - shieldcall flags. [code/__DEFINES/combat/shieldcall.dm]
 *
 * @return SHIELDCALL_FLAG_TERMINATE or NONE
 */
/atom/proc/atom_shieldcall_handle_bullet(list/bullet_act_args, fake_attack, shieldcall_flags)
	SHOULD_NOT_SLEEP(TRUE)
	// cannot parry yourself
	var/obj/projectile/proj = bullet_act_args[BULLET_ACT_ARG_PROJECTILE]
	if(proj.firer == src && (bullet_act_args[BULLET_ACT_ARG_FLAGS] & PROJECTILE_IMPACT_POINT_BLANK))
		return shieldcall_flags
	// send query signal
	SEND_SIGNAL(src, COMSIG_ATOM_SHIELDCALL_ITERATION, ATOM_SHIELDCALL_ITERATING_BULLET_ACT)
	. = shieldcall_flags
	for(var/datum/shieldcall/shieldcall as anything in shieldcalls)
		. |= shieldcall.handle_bullet(src, ., fake_attack, bullet_act_args)

/**
 * Runs shieldcalls for handle_throw_impact
 *
 * @params
 * * thrown - the thrown object's data
 * * fake_attack - just checking!
 * * shieldcall_flags - shieldcall flags. [code/__DEFINES/combat/shieldcall.dm]
 *
 * @return SHIELDCALL_FLAG_* flags
 */
/atom/proc/atom_shieldcall_handle_throw_impact(datum/thrownthing/thrown, fake_attack, shieldcall_flags)
	SHOULD_NOT_SLEEP(TRUE)
	// cannot parry yourself
	if(thrown.thrower == src && thrown.dist_travelled <= 1)
		return shieldcall_flags
	// send query signal
	SEND_SIGNAL(src, COMSIG_ATOM_SHIELDCALL_ITERATION, ATOM_SHIELDCALL_ITERATING_THROW_IMPACT)
	. = shieldcall_flags
	for(var/datum/shieldcall/shieldcall as anything in shieldcalls)
		. |= shieldcall.handle_throw_impact(src, ., fake_attack, thrown)
