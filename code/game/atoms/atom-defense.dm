//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//! Welcome to hell.

// todo: everything needs comsigs comsigs comsigs

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

/**
 * called on melee hit
 *
 * todo: add clickchain datum, instead of multiplier
 *
 * * check CLICKCHAIN_FLAGS_* as needed, especially UNCONDITIONAL_ABORT and ATTACK_ABORT
 * * clickchain flags are sent down through parent calls.
 *
 * @params
 * * user - person attacking
 * * weapon - weapon used
 * * target_zone - zone targeted
 * * mult - damage multiplier
 *
 * @return clickchain flags to append
 */
/atom/proc/melee_act(mob/user, obj/item/weapon, target_zone, datum/event_args/actor/clickchain/clickchain)
	return CLICKCHAIN_DO_NOT_ATTACK

/**
 * called on unarmed melee hit
 *
 * todo: add clickchain datum, instead of multiplier
 *
 * @params
 * * user - person attacking
 * * style - unarmed attack datum
 * * target_zone - zone targeted
 * * mult - damage multiplier
 *
 * @return clickchain flags to append
 */
/atom/proc/unarmed_act(mob/attacker, datum/unarmed_attack/style, target_zone, datum/event_args/actor/clickchain/clickchain)
	return CLICKCHAIN_DO_NOT_ATTACK

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
 * * Modify `impact_flags` directly before ..(), and `.` after ..()
 * * Check `.` after ..() if it isn't the last call so you know when to abort the processing as needed.
 * * Args will propagate **up** (closer to /atom) `..()` calls, but not back down (if base `/atom` changes something you won't get it on your sub-type)
 * * For this reason `bullet_act_args` is provided so you can mutably edit it. Do **not** edit the projectile or the impact flags; return the impact flags for automatic addition.
 *
 * @params
 * * proj - hitting projectile; immutable
 * * impact_flags - impact flags; immutable. edit directly before ..() call, return edited values after.
 * * bullet_act_args - access to the rest of the args in `bullet_act`. Mutable, except for the projectile and the impact flags.
 */
/atom/proc/on_bullet_act(obj/projectile/proj, impact_flags, list/bullet_act_args)
	return impact_flags

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
/atom/proc/hitsound_override(damage_type, damage_mode, attack_type, datum/weapon)
	return // default is null

/atom/proc/hitsound_melee(obj/item/I)
	. = I.attacksound_override(src, ATTACK_TYPE_MELEE)
	if(!isnull(.))
		return
	. = hitsound_override(I.damtype, I.damage_mode, ATTACK_TYPE_MELEE, I)
	if(.)
		return
	. = (I.damtype == DAMAGE_TYPE_BURN? hit_sound_burn : hit_sound_brute) || I.attack_sound
	if(.)
		return
	switch(I.damtype)
		if(DAMAGE_TYPE_BRUTE)
			return "swing_hit"
		if(DAMAGE_TYPE_BURN)
			return "'sound/items/welder.ogg"
		else
			return "swing_hit"

/atom/proc/hitsound_projectile(obj/projectile/P)
	//? todo: projectile gets final say
	. = hitsound_override(P.damtype, P.damage_mode, ATTACK_TYPE_PROJECTILE, P)
	if(.)
		return
	return islist(P.impact_sounds)? pick(P.impact_sounds) : P.impact_sounds

/atom/proc/hitsound_throwhit(obj/item/I)
	. = I.attacksound_override(src, ATTACK_TYPE_THROWN)
	if(!isnull(.))
		return
	. = hitsound_override(I.damtype, I.damage_mode, ATTACK_TYPE_THROWN, I)
	if(.)
		return
	. = (I.damtype == DAMAGE_TYPE_BURN? hit_sound_burn : hit_sound_brute)  || I.attack_sound
	if(.)
		return
	switch(I.damtype)
		if(DAMAGE_TYPE_BRUTE)
			return "swing_hit"
		if(DAMAGE_TYPE_BURN)
			return 'sound/items/welder.ogg'
		else
			return "swing_hit"

/atom/proc/hitsound_unarmed(mob/M, datum/unarmed_attack/style)
	//? todo: style gets final say
	. = hitsound_override(M, style.damage_mode, ATTACK_TYPE_UNARMED, style)
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
 * * damtype - damage type
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
 * * damtype - damage type
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
 * * damtype - damage type
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
 * * damtype - damage type
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
 * * This is a low level proc. Make sure you undersatnd how shieldcalls work [__DEFINES/combat/shieldcall.dm].
 */
/atom/proc/run_shieldcalls(list/shieldcall_args, fake_attack)
	SHOULD_NOT_SLEEP(TRUE)
	SEND_SIGNAL(src, COMSIG_ATOM_SHIELDCALL, shieldcall_args, fake_attack)
	if(shieldcall_args[SHIELDCALL_ARG_FLAGS] & SHIELDCALL_FLAG_TERMINATE)
		return
	for(var/datum/shieldcall/calling as anything in shieldcalls)
		if(!calling.low_level_intercept)
			continue
		calling.handle_shieldcall(src, args, fake_attack)
		if(shieldcall_args[SHIELDCALL_ARG_FLAGS] & SHIELDCALL_FLAG_TERMINATE)
			break

/**
 * Runs a damage instance against armor
 *
 * * This is a low level proc. Make sure you undersatnd how shieldcalls work [__DEFINES/combat/shieldcall.dm].
 */
/atom/proc/run_armorcalls(list/shieldcall_args, fake_attack)
	SHOULD_NOT_SLEEP(TRUE)
	SEND_SIGNAL(src, COMSIG_ATOM_ARMORCALL, shieldcall_args, fake_attack)
	if(shieldcall_args[SHIELDCALL_ARG_FLAGS] & SHIELDCALL_FLAG_TERMINATE)
		return
	var/datum/armor/our_armor = fetch_armor()
	our_armor.handle_shieldcall(shieldcall_args, fake_attack)

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
 * * e_args (optional) the clickchain event, if any; **This is mutable.**
 * * contact_flags - SHIELDCALL_CONTACT_FLAG_*
 * * contact_specific - SHIELDCALL_CONTACT_SPECIFIC_*
 * * fake_attack - just checking!
 * * shieldcall_flags - shieldcall flags. [code/__DEFINES/combat/shieldcall.dm]
 * * clickchain_flags - clickchain flags. [code/__DEFINES/procs/clickcode.dm]
 *
 * @return SHIELDCALL_FLAG_* flags
 */
/atom/proc/atom_shieldcall_handle_touch(datum/event_args/actor/clickchain/e_args, contact_flags, contact_specific, fake_attack, shieldcall_flags)
	SHOULD_NOT_SLEEP(TRUE)
	// cannot parry yourself
	if(e_args.performer == src)
		return shieldcall_flags
	// send query signal
	SEND_SIGNAL(src, COMSIG_ATOM_SHIELDCALL_ITERATION, ATOM_SHIELDCALL_ITERATING_TOUCH)
	. = shieldcall_flags
	for(var/datum/shieldcall/shieldcall as anything in shieldcalls)
		. |= shieldcall.handle_touch(src, ., fake_attack, e_args, contact_flags, contact_specific)

/**
 * Runs shieldcalls for handle_unarmed_melee
 *
 * * Use this instead of manually looping, as it fires a signal that makes things like /datum/passive_parry spin up.
 *
 * @params
 * * style - the unarmed_attack datum being used
 * * e_args (optional) the clickchain event, if any; **This is mutable.**
 * * fake_attack - (optional) just checking!
 * * shieldcall_flags - (optional) shieldcall flags. [code/__DEFINES/combat/shieldcall.dm]
 * * clickchain_flags - (optional) clickchain flags. [code/__DEFINES/procs/clickcode.dm]
 *
 * @return SHIELDCALL_FLAG_* flags
 */
/atom/proc/atom_shieldcall_handle_unarmed_melee(datum/unarmed_attack/style, datum/event_args/actor/clickchain/e_args, fake_attack, shieldcall_flags, clickchain_flags)
	SHOULD_NOT_SLEEP(TRUE)
	// cannot parry yourself
	if(e_args.performer == src)
		return shieldcall_flags
	// send query signal
	SEND_SIGNAL(src, COMSIG_ATOM_SHIELDCALL_ITERATION, ATOM_SHIELDCALL_ITERATING_UNARMED_MELEE)
	. = shieldcall_flags
	for(var/datum/shieldcall/shieldcall as anything in shieldcalls)
		. |= shieldcall.handle_unarmed_melee(src, ., fake_attack, style, e_args)

/**
 * Runs shieldcalls for handle_item_melee
 *
 * * Use this instead of manually looping, as it fires a signal that makes things like /datum/passive_parry spin up.
 *
 * @params
 * * weapon - the item being used to swing with
 * * e_args - (optional) the clickchain event, if any; **This is mutable.**
 * * fake_attack - (optional) just checking!
 * * shieldcall_flags - (optional) shieldcall flags. [code/__DEFINES/combat/shieldcall.dm]
 * * clickchain_flags - (optional) clickchain flags. [code/__DEFINES/procs/clickcode.dm]
 *
 * @return SHIELDCALL_FLAG_* flags
 */
/atom/proc/atom_shieldcall_handle_item_melee(obj/item/weapon, datum/event_args/actor/clickchain/e_args, fake_attack, shieldcall_flags, clickchain_flags)
	SHOULD_NOT_SLEEP(TRUE)
	// cannot parry yourself
	if(e_args.performer == src)
		return shieldcall_flags
	// send query signal
	SEND_SIGNAL(src, COMSIG_ATOM_SHIELDCALL_ITERATION, ATOM_SHIELDCALL_ITERATING_ITEM_MELEE)
	. = shieldcall_flags
	for(var/datum/shieldcall/shieldcall as anything in shieldcalls)
		. |= shieldcall.handle_item_melee(src, ., fake_attack, weapon, e_args)

/**
 * Runs shieldcalls for handle_bullet
 *
 * * Use this instead of manually looping, as it fires a signal that makes things like /datum/passive_parry spin up.
 *
 * @params
 * * bullet_act_args - indexed list of bullet_act args.
 * * shieldcall_returns - existing returns from other shieldcalls
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
