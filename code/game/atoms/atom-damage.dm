//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Damage Instance Handling *//

/**
 * standard damage handling - process an instance of damage
 *
 * args are the same as shieldcall args, because this directly invokes shield/armorcalls
 *
 * * additional args past the normal shieldcall args are allowed, but not before!
 * * the entire args list is extracted via return, allowing for handling by caller.
 * * damage is assumed to be zone'd if def_zone is set; otherwise it's overall
 * * please note that overall damage generally doesn't check armor properly for speed reasons!
 *
 * @return modified args
 */
/atom/proc/run_damage_instance(SHIELDCALL_PROC_HEADER)
	SHOULD_NOT_OVERRIDE(TRUE)
	process_damage_instance(args, hit_zone)
	if(shieldcall_flags & SHIELDCALL_FLAGS_BLOCK_ATTACK)
		return args.Copy() // args are only valid during a call; it's destroyed after.
	inflict_damage_instance(arglist(args))
	return args.Copy() // args are only valid during a call; it's destroyed after.

/**
 * [/atom/proc/run_damage_instance()], but doesn't actually do damage.
 *
 * @return modified args
 */
/atom/proc/check_damage_instance(SHIELDCALL_PROC_HEADER)
	SHOULD_NOT_OVERRIDE(TRUE)
	process_damage_instance(args, hit_zone, TRUE)
	return args.Copy() // args are only valid during a call; it's destroyed after.

/**
 * process an instance of damage through defense handling.
 */
/atom/proc/process_damage_instance(list/shieldcall_args, filter_zone, fake_attack)
	if(!(shieldcall_args[SHIELDCALL_ARG_FLAGS] & SHIELDCALL_FLAG_SKIP_SHIELDCALLS))
		run_shieldcalls(shieldcall_args, fake_attack)
	if(shieldcall_args[SHIELDCALL_ARG_FLAGS] & (SHIELDCALL_FLAGS_SHOULD_TERMINATE | SHIELDCALL_FLAGS_BLOCK_ATTACK))
		return
	if(!(shieldcall_args[SHIELDCALL_ARG_FLAGS] & SHIELDCALL_FLAG_SKIP_ARMORCALLS))
		run_armorcalls(shieldcall_args, fake_attack, filter_zone)

/**
 * inflict an instance of damage.
 *
 * * this happens after shieldcalls, armor checks, etc, all resolve.
 * * at this point, nothing should modify damage
 * * for things like limb damage and armor handling, check the armor/etc in process_damage_instance
 * * for this reason, we do not allow any returns.
 * * if hit_zone is not specified, this is considered overall damage.
 * * overall damage is implementation-defined, so it's recommended to, ironically, not try to standardize that too much.
 * * this is pretty much the hand-off proc where damage goes from hit processing / defense checks to the damage system for an entity
 * * the damage system can be a medical system or just the atom integrity system.
 */
/atom/proc/inflict_damage_instance(SHIELDCALL_PROC_HEADER)
	if(!integrity_enabled)
		return
	if(inflict_damage_type_special(args))
		return
	switch(damage_type)
		if(DAMAGE_TYPE_BRUTE)
		if(DAMAGE_TYPE_BURN)
		else
			return // normal atoms can't take non brute-burn damage

	#ifdef CF_VISUALIZE_DAMAGE_TICKS
	visualize_atom_damage(damage, damage_type)
	#endif

	// default atom damage handling
	inflict_atom_damage(
		damage,
		damage_type,
		damage_tier,
		damage_flag,
		damage_mode,
		hit_zone,
		attack_type,
		attack_source,
	)

/**
 * decodes damage type to what it should actually do
 *
 * * this is for hybrid / semantic damage types like bio-acid and searing damage to work
 * * for the love of god make sure you are not infinite looping here; never use a compound damage type in this.
 * * this gets a direct reference to args; you can just modify it and pass it back.
 *
 * TODO: can we datumize damage types already?
 *
 * @return TRUE to handle the damage type.
 */
/atom/proc/inflict_damage_type_special(list/shieldcall_args)
	switch(shieldcall_args[SHIELDCALL_ARG_DAMAGE_TYPE])
		if(DAMAGE_TYPE_BIOACID)
			// hand it back
			shieldcall_args[SHIELDCALL_ARG_DAMAGE_TYPE] = DAMAGE_TYPE_BURN
			return FALSE
		if(DAMAGE_TYPE_SEARING)
			// split to two and call
			var/list/new_args = shieldcall_args.Copy()
			new_args[SHIELDCALL_ARG_DAMAGE] /= 2
			new_args[SHIELDCALL_ARG_DAMAGE_TYPE] = DAMAGE_TYPE_BRUTE
			inflict_damage_instance(arglist(new_args))
			new_args[SHIELDCALL_ARG_DAMAGE_TYPE] = DAMAGE_TYPE_BURN
			inflict_damage_instance(arglist(new_args))
			return TRUE
	return FALSE

//* Damage Processing API *//

/**
 * takes damage from a generic attack, taking into account armor but not shields.
 * this does not handle playing sounds / anything, this is strictly generic damage handling
 * usable by anything.
 *
 * * This does **not** invoke the shieldcall API!
 * * This does **not** invoke the armor API!
 * * This is because damage instance processing should be processing that.
 *
 * @params
 * * damage - raw damage
 * * damage_type - (optional) damage type to inflict
 * * damage_tier - (optional) resulting damage tier
 * * damage_flag - (optional) resulting damage armor flag from [code/__DEFINES/combat/armor.dm]
 * * damage_mode - (optional) DAMAGE_MODE_* flags
 * * hit_zone - (optional) the zone being hit
 * * attack_type - (optional) attack type flags from [code/__DEFINES/combat/attack_types.dm]
 * * weapon - (optional) attacking datum; same format as shieldcall API. See shieldcalls for more information.
 *
 * @return raw damage taken
 */
/atom/proc/inflict_atom_damage(damage, damage_type, damage_tier, damage_flag, damage_mode, hit_zone, attack_type, datum/attack_source)
	if(!integrity_enabled)
		return 0
	if(integrity_flags & INTEGRITY_INDESTRUCTIBLE)
		return 0
	if(!damage)
		return 0
	. = integrity
	damage_integrity(damage)
	. = . - integrity

/**
 * Visualizes a damage instance.
 *
 * @params
 * * damage - amount inflicted
 * * damage_type - (optional) damage type inflicted
 */
/atom/proc/visualize_atom_damage(damage, damage_type)
	var/atom/movable/render/damage_tick/damage_tick = new(loc, src, 0.75 SECOND)
	var/use_color = damage_type_to_visualized_color(damage_type)
	damage_tick.maptext = MAPTEXT_CENTER("<font color='[use_color]'>[damage]</font>")

//* Integrity - Direct Manipulation *//

/**
 * damages integrity directly, ignoring armor / shields
 *
 * @params
 * * amount - how much
 * * gradual - burst or gradual? if you want to play a sound or something, you usually want to check this.
 * * do_not_break - skip calling atom_break
 */
/atom/proc/damage_integrity(amount, gradual, do_not_break)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/was_working = integrity > integrity_failure
	integrity = max(0, integrity - amount)
	if(was_working && integrity <= integrity_failure && !do_not_break)
		atom_break()
	if(integrity <= 0)
		atom_destruction()

/**
 * heals integrity directly
 *
 * @params
 * * amount - how much
 * * gradual - burst or gradual? if you want to play a sound or something, you usually want to check this.
 * * do_not_fix - skip calling atom_fix
 *
 * @return amount healed
 */
/atom/proc/heal_integrity(amount, gradual, do_not_fix)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/was_failing = integrity <= integrity_failure
	. = integrity
	integrity = min(integrity_max, integrity + amount)
	. = integrity - .
	if(was_failing && integrity > integrity_failure && !do_not_fix)
		atom_fix()

/**
 * directly sets integrity - ignores armor / sihelds
 *
 * will not call [damage_integrity] or [heal_integrity]
 * will call [atom_break], [atom_fix], [atom_destruction]
 *
 * @params
 * * amount - how much to set to?
 */
/atom/proc/set_integrity(amount)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/was_failing = integrity <= integrity_failure
	integrity = clamp(amount, 0, integrity_max)
	if(!was_failing && integrity <= integrity_failure)
		atom_break()
	else if(was_failing && integrity > integrity_failure)
		atom_fix()
	if(integrity <= 0)
		atom_destruction()

/**
 * sets max integrity - will automatically reduce integrity if it's above max.
 *
 * will not call [damage_integrity]
 * will call [atom_break], [atom_fix], [atom_destruction]
 *
 * @params
 * * amount - how much to set to
 */
/atom/proc/set_max_integrity(amount)
	integrity_max = max(amount, 0)
	if(integrity < integrity_max)
		return
	var/was_broken = integrity <= integrity_failure
	integrity = integrity_max
	if(!was_broken && (integrity <= integrity_failure))
		atom_break()
	if(integrity <= 0)
		atom_destruction()

/**
 * sets integrity and max integrity - will automatically reduce integrity if it's above max.
 *
 * will not call [damage_integrity]
 * will call [atom_break], [atom_fix], [atom_destruction]
 *
 * @params
 * * integrity - how much to set integrity to
 * * integrity_max - how much to set integrity_max to
 */
/atom/proc/set_full_integrity(integrity, integrity_max)
	src.integrity_max = max(integrity_max, 0)
	var/was_broken = src.integrity <= integrity_failure
	src.integrity = clamp(integrity, 0, integrity_max)
	var/now_broken = integrity <= integrity_failure
	if(!was_broken && now_broken)
		atom_break()
	else if(was_broken && !now_broken)
		atom_fix()
	if(integrity <= 0)
		atom_destruction()

/**
 * Set integrity to a multiple of initial.
 *
 * And fully restore it if specified.
 * Otherwise, will retain the last percentage.
 */
/atom/proc/set_multiplied_integrity(factor, restore)
	var/was_broken = src.integrity <= integrity_failure
	if(restore)
		integrity = integrity_max = initial(integrity_max) * factor
		if(was_broken && integrity > integrity_failure)
			atom_fix()
		return
	var/ratio = integrity / integrity_max
	integrity_max = initial(integrity_max) * factor
	integrity = integrity_max * ratio
	var/now_broken = integrity <= integrity_failure
	if(!was_broken && now_broken)
		atom_break()
	else if(was_broken && !now_broken)
		atom_fix()
	if(integrity <= 0)
		atom_destruction()

/**
 * adjusts integrity - routes directly to [damage_integrity] and [heal_integrity]
 *
 * will call [damage_integrity]
 * will call [atom_break], [atom_fix], [atom_destruction]
 *
 * @params
 * * amount - how much
 * * gradual - burst or gradual?
 * * no_checks - do not call fix/break
 */
/atom/proc/adjust_integrity(amount, gradual, no_checks)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	if(amount > 0)
		return heal_integrity(amount, gradual, no_checks)
	else
		return damage_integrity(amount, gradual, no_checks)

/**
 * adjusts max integrity - will automatically reduce integrity if it's above max.
 *
 * will call [damage_integrity]
 * will call [atom_break], [atom_fix], [atom_destruction]
 *
 * @params
 * * amount - how much to adjust by
 * * gradual - burst or gradual?
 */
/atom/proc/adjust_max_integrity(amount, gradual)
	// lazy route lmao
	set_max_integrity(integrity_max + amount)

//* Integrity - Check / Getters *//

/**
 * percent integrity, rounded.
 */
/atom/proc/percent_integrity(round_to = 0.1)
	return integrity_max? round(integrity / integrity_max, round_to) : 0

/atom/proc/is_integrity_broken()
	return atom_flags & ATOM_BROKEN

/atom/proc/is_integrity_damaged()
	return integrity < integrity_max

//* Integrity - Events *//

/**
 * called when integrity reaches 0 from a non 0 value
 */
/atom/proc/atom_destruction()
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	if(!(integrity_flags & INTEGRITY_NO_DECONSTRUCT))
		deconstruct(ATOM_DECONSTRUCT_DESTROYED)

/**
 * called when integrity drops below or at integrity_failure
 *
 * if integrity_failure is 0, this is called before destruction.
 */
/atom/proc/atom_break()
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	if(integrity > integrity_failure)
		damage_integrity(integrity - integrity_failure, do_not_break = TRUE)
	atom_flags |= ATOM_BROKEN

/**
 * called when integrity rises above integrity_failure
 *
 * if integrity_failure is 0, this still works.
 */
/atom/proc/atom_fix()
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	if(integrity < integrity_failure)
		heal_integrity(integrity_failure - integrity + 1, do_not_fix = TRUE)
	atom_flags &= ~ATOM_BROKEN
