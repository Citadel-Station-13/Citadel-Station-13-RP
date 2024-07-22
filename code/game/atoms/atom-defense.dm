//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

//! Welcome to hell.

// todo: everything needs comsigs comsigs comsigs

//? Hooks / External

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
 * @params
 * * user - person attacking
 * * weapon - weapon used
 * * target_zone - zone targeted
 * * mult - damage multiplier
 *
 * @return clickchain flags to append
 */
#warn run shieldcalls at obj/turf level manually because inflict_atom_damage doesn't
#warn mob-level shieldcalls
/atom/proc/melee_act(mob/user, obj/item/weapon, target_zone, mult = 1)
	return CLICKCHAIN_DO_NOT_ATTACK

/**
 * called on unarmed melee hit
 *
 * @params
 * * user - person attacking
 * * style - unarmed attack datum
 * * target_zone - zone targeted
 * * mult - damage multiplier
 *
 * @return clickchain flags to append
 */
#warn run shieldcalls at obj/turf level manually because inflict_atom_damage doesn't
#warn mob-level shieldcalls
/atom/proc/unarmed_act(mob/attacker, datum/unarmed_attack/style, target_zone, mult = 1)
	return CLICKCHAIN_DO_NOT_ATTACK

/**
 * Because this is the proc that calls on_impact(), handling is necessarily
 * done in here for a lot of things.
 *
 * Overrides should modify proc args directly (e.g. impact_flags) and then call ..()
 * if it needs to be taken account by default handling.
 *
 * Overrides can, but generally shouldn't modify the return value after ..() instead of before,
 * as the main processing will ignore said changes. Do not edit impact_flags arg after ..(),
 * as it won't propagate to the `.`  (default return) variable after.
 *
 * Things to keep in mind
 * * 'blocked' arg is **extremely** powerful. Please don't raise it to high values for no reason.
 * * use PROJECTILE_IMPACT_BLOCKED instead of setting blocked to 100 if an impact is entirely blocked
 * * semantically, blocked 100 means shield from all damaged, IMPACT_BLOCKED means it hit something else
 * * please return if `. & PROJECTILE_IMPACT_FLAGS_TARGET_ABORT` after `..()`, as that signals we are done and should stop.
 *
 * @params
 * * proj - the projectile
 * * impact_flags - PROJECTILE_IMPACT_* flags
 * * def_zone - impacting zone; calculated by projectile side, usually
 * * blocked - 0 to 100, inclusive; % block to enforce. this should affect most damage/stun/etc values
 *
 * todo: add PROJECTILE_IMPACT_DELETE_AFTER as opposed to DELETE? so rest of effects can still run
 * todo: shieldcalls still fire if target aborts without unconditional abort, they should not do that.
 *
 * @return new impact_flags
 */
#warn run shieldcalls at obj/turf level manually because inflict_atom_damage doesn't
#warn mob-level shieldcalls
/atom/proc/bullet_act(obj/projectile/proj, impact_flags, def_zone, blocked)
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
	var/shieldcall_returns = NONE
	for(var/datum/shieldcall/shieldcall as anything in shieldcalls)
		shieldcall_returns |= shieldcall.handle_bullet(src, args, shieldcall_returns)
		if(shieldcall_returns & SHIELDCALL_FLAGS_SHOULD_TERMINATE)
			break
	// check if we're still hitting
	if(impact_flags & PROJECTILE_IMPACT_FLAGS_UNCONDITIONAL_ABORT)
		return impact_flags
	// we are hitting; gather flags as needed
	return proj.on_impact_new(src, impact_flags, def_zone, blocked)

//? Hitsound API

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
	. = (I.damtype == BURN? hit_sound_burn : hit_sound_brute) || I.attack_sound
	if(.)
		return
	switch(I.damtype)
		if(BRUTE)
			return "swing_hit"
		if(BURN)
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
	. = (I.damtype == BURN? hit_sound_burn : hit_sound_brute)  || I.attack_sound
	if(.)
		return
	switch(I.damtype)
		if(BRUTE)
			return "swing_hit"
		if(BURN)
			return 'sound/items/welder.ogg'
		else
			return "swing_hit"

/atom/proc/hitsound_unarmed(mob/M, datum/unarmed_attack/style)
	//? todo: style gets final say
	. = hitsound_override(M, style.damage_mode, ATTACK_TYPE_UNARMED, style)
	if(.)
		return
	// todo: way to override this from style side? we don't just want hitsound brute/burn.
	. = (style.damage_type == BURN? hit_sound_burn : hit_sound_brute) || style.attack_sound


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
	run_armorcalls(args, TRUE)
	return args

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
	run_armorcalls(args, FALSE)
	return args

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
/atom/proc/atom_shieldcheck(SHIELDCALL_PROC_HEADER)
	run_shieldcalls(args, TRUE)
	return args

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
/atom/proc/atom_shieldcall(SHIELDCALL_PROC_HEADER)
	run_shieldcalls(args, FALSE)
	return args

/**
 * Runs a damage instance against shieldcalls
 *
 * * This is a low level proc. Make sure you undersatnd how shieldcalls work [__DEFINES/combat/shieldcall.dm].
 */
/atom/proc/run_shieldcalls(list/shieldcall_args, fake_attack)
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
	SEND_SIGNAL(src, COMSIG_ATOM_ARMORCALL, shieldcall_args, fake_attack)
	if(shieldcall_args[SHIELDCALL_ARG_FLAGS] & SHIELDCALL_FLAG_TERMINATE)
		return
	var/datum/armor/our_armor = fetch_armor()
	our_armor.handle_shieldcall(src, shieldcall_args, fake_attack)

/atom/proc/register_shieldcall(datum/shieldcall/delegate)
	LAZYINITLIST(shieldcalls)
	BINARY_INSERT(delegate, shieldcalls, /datum/shieldcall, delegate, priority, COMPARE_KEY)

/atom/proc/unregister_shieldcall(datum/shieldcall/delegate)
	LAZYREMOVE(shieldcalls, delegate)
