//! Welcome to the atom damage module.
//! Enjoy the bitfield and #define vomit.

//? Hooks / External

/**
 * React to being hit by an explosion
 *
 * Should be called through the [EX_ACT] wrapper macro.
 * The wrapper takes care of the [COMSIG_ATOM_EX_ACT] signal.
 * as well as calling [/atom/proc/contents_explosion].
 */
/atom/proc/legacy_ex_act(severity, target)
	set waitfor = FALSE

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

/atom/proc/emp_act(var/severity)
	// todo: SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_ATOM_EMP_ACT, severity)

/atom/proc/bullet_act(obj/projectile/P, def_zone)
	P.on_hit(src, 0, def_zone)
	. = 0

// Called when a blob expands onto the tile the atom occupies.
/atom/proc/blob_act()
	return

/**
 * called when being burned in a fire
 *
 * this is explicitly for ZAS only
 *
 * todo: make params (air, temperature, dt), so this is more generic
 */
/atom/proc/fire_act(datum/gas_mixture/air, temperature, volume)
	return

/**
 * called on melee hit
 *
 * @params
 * * user - person attacking
 * * weapon - weapon used
 * * target_zone - zone targeted
 * * mult - damage multiplier
 *
 * @return did the hit process? a miss is still a process, return FALSE if we shouldn't be acted against at all.
 */
/atom/proc/melee_act(mob/user, obj/item/weapon, target_zone, mult = 1)
	return

/**
 * called on unarmed melee hit
 *
 * @params
 * * user - person attacking
 * * style - unarmed attack datum
 * * target_zone - zone targeted
 * * mult - damage multiplier
 *
 * @return did the hit process? a miss is still a process, return FALSE if we shouldn't be acted against at all.
 */
/atom/proc/unarmed_act(mob/attacker, datum/unarmed_attack/style, target_zone, mult = 1)
	return

	#warn ipl



//? Damage API

/**
 * takes damage from a generic attack, taking into account armor but not shields.
 * this does not handle playing sounds / anything, this is strictly generic damage handling
 * usable by anything.
 *
 * @params
 * * damage - raw damage
 * * tier - penetration / attack tier
 * * flag - armor flag as seen in [code/__DEFINES/combat/armor.dm]
 * * mode - damage_mode
 * * attack_type - (optional) attack type flags from [code/__DEFINES/combat/attack_types.dm]
 * * weapon - (optional) attacking /obj/item for melee or thrown, /obj/projectile for ranged, /mob for unarmed
 * * gradual - loud effects like glass clanging should not happen. use for stuff like acid and fire.
 *
 * @return raw damage taken
 */
/atom/proc/inflict_atom_damage(damage, tier, flag, mode, attack_type, datum/weapon, gradual)
	if(!integrity_enabled)
		CRASH("attempted to take_atom_damage without [NAMEOF(src, integrity_enabled)] being on.")
	if(integrity_flags & INTEGRITY_INDESTRUCTIBLE)
		return 0
	if(flag)
		var/list/returned = run_armor(arglist(args))
		damage = returned[1]
		mode = returned[4]
	if(!damage)
		return
	. = integrity
	damage_integrity(damage)
	. = . - integrity

//? Hitsound API

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
	. = hitsound_override(I.damtype, I.damage_mode, ATTACK_TYPE_MELEE, I)
	if(.)
		return
	. = hit_sound || I.attack_sound
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
	. = hitsound_override(P.damtype, P.damage_mode, ATTACK_TYPE_PROJECTILE, P)
	if(.)
		return
	#warn impl

/atom/proc/hitsound_throwhit(obj/item/I)
	. = hitsound_override(I.damtype, I.damage_mode, ATTACK_TYPE_THROWN, I)
	if(.)
		return
	. = hit_sound || I.attack_sound
	if(.)
		return
	switch(I.damtype)
		if(BRUTE)
			return "swing_hit"
		if(BURN)
			return "'sound/items/welder.ogg"
		else
			return "swing_hit"

/atom/proc/hitsound_unarmed(mob/M, datum/unarmed_attack/style)
	. = hitsound_override(M, style.damage_mode, ATTACK_TYPE_UNARMED, style)
	if(.)
		return
	. = hit_sound || style.attack_sound

//? Direct Integrity

/**
 * damages integrity directly, ignoring armor / shields
 *
 * @params
 * * amount - how much
 * * gradual - burst or gradual? if you want to play a sound or something, you usually want to check this.
 */
/atom/proc/damage_integrity(amount, gradual)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/was_working = integrity > integrity_failure
	integrity = max(0, integrity - amount)
	if(was_working && integrity <= integrity_failure)
		atom_break()
	if(!integrity)
		atom_destruction()

/**
 * heals integrity directly
 *
 * @params
 * * amount - how much
 * * gradual - burst or gradual? if you want to play a sound or something, you usually want to check this.
 *
 * @return amount healed
 */
/atom/proc/heal_integrity(amount, gradual)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/was_failing = integrity <= integrity_failure
	. = integrity
	integrity = min(integrity_max, integrity + amount)
	. = integrity - .
	if(was_failing && integrity > integrity_failure)
		atom_fix()

/**
 * directly sets integrity - ignores armor / sihelds
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
	if(!integrity)
		atom_destruction()

/**
 * adjusts integrity - routes directly to [damage_integrity] and [heal_integrity]
 *
 * @params
 * * amount - how much
 * * gradual - burst or gradual?
 */
/atom/proc/adjust_integrity(amount, gradual)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	if(amount > 0)
		return heal_integrity(amount, gradual)
	else
		return damage_integrity(amount, gradual)

/**
 * percent integrity, rounded.
 */
/atom/proc/percent_integrity(round_to = 0.1)
	return integrity_max? round(integrity / integrity_max, round_to) : 0

//? Thresholds & Events

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
	atom_flags |= ATOM_BROKEN

/**
 * called when integrity rises above integrity_failure
 *
 * if integrity_failure is 0, this still works.
 */
/atom/proc/atom_fix()
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	atom_flags &= ~ATOM_BROKEN

//? Deconstruction

/**
 * called to semantically deconstruct an atom
 *
 * @params
 * - method - how we were deconstructed
 */
/atom/proc/deconstruct(method = ATOM_DECONSTRUCT_DISASSEMBLED)
	SHOULD_NOT_OVERRIDE(TRUE)

	// send signal
	// todo: signal
	// do da funny logic
	deconstructed(method)
	// drop things after so things that rely on having objects don't break
	drop_products(method)
	// goodbye, cruel world
	qdel(src)

/**
 * called when we are deconstructed
 *
 * **do not drop products in here**
 *
 * @params
 * - method - how we were deconstructed
 */
/atom/proc/deconstructed(method)
	return

/**
 * called to drop the products of deconstruction
 *
 * @params
 * * method - how we were deconstructed
 */
/atom/proc/drop_products(method)
	return

/**
 * called to move a product to a place
 *
 * @params
 * * method - how we were deconstructed
 * * dropping - movable in question
 * * where - where to move to
 */
/atom/proc/drop_product(method, atom/movable/dropping, atom/where)
	dropping.forceMove(where || drop_location())

//? Armor

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
	return armor || (armor = fetch_armor_struct(armor_type))

/**
 * calculates the resulting damage from an attack, taking into account our armor and soak
 *
 * @params
 * * damage - raw damage
 * * tier - penetration / attack tier
 * * flag - armor flag as seen in [code/__DEFINES/combat/armor.dm]
 * * mode - damage_mode
 * * attack_type - (optional) attack type flags from [code/__DEFINES/combat/attack_types.dm]
 * * weapon - (optional) attacking /obj/item for melee or thrown, /obj/projectile for ranged, /mob for unarmed
 *
 * @return args as list.
 */
/atom/proc/check_armor(damage, tier, flag, mode, attack_type, datum/weapon)
	damage = fetch_armor().resultant_damage(damage, tier, flag)
	return args.Copy()

/**
 * runs armor against an incoming attack
 * this proc can have side effects
 *
 * @params
 * * damage - raw damage
 * * tier - penetration / attack tier
 * * flag - armor flag as seen in [code/__DEFINES/combat/armor.dm]
 * * mode - damage_mode
 * * attack_type - (optional) attack type flags from [code/__DEFINES/combat/attack_types.dm]
 * * weapon - (optional) attacking /obj/item for melee or thrown, /obj/projectile for ranged, /mob for unarmed
 *
 * @return args as list.
 */
/atom/proc/run_armor(damage, tier, flag, mode, attack_type, datum/weapon)
	damage = fetch_armor().resultant_damage(damage, tier, flag)
	return args.Copy()

//? shieldcalls

/**
 * checks for shields
 * not always accurate
 *
 * params are modified and then returned as a list.
 *
 * @params
 * * damage - raw damage
 * * tier - penetration / attack tier
 * * flag - armor flag as seen in [code/__DEFINES/combat/armor.dm]
 * * mode - damage_mode
 * * attack_type - (optional) attack type flags from [code/__DEFINES/combat/attack_types.dm]
 * * weapon - (optional) attacking /obj/item for melee or thrown, /obj/projectile for ranged, /mob for unarmed
 * * additional - a way to retrieve data out of the shieldcall, passed in by attacks. [code/__DEFINES/dcs/signals/atoms/signals_atom_defense.dm]
 * * retval - shieldcall flags passed through components. [code/__DEFINES/dcs/signals/atoms/signals_atom_defense.dm]
 *
 * @return modified args as list
 */
/atom/proc/atom_shieldcheck(damage, tier, flag, mode, attack_type, datum/weapon, list/additional = list(), retval = NONE)
	retval |= SHIELDCALL_JUST_CHECKING
	SEND_SIGNAL(src, COMSIG_ATOM_SHIELDCALL, args)
	return args.Copy()

/**
 * runs an attack against shields
 * side effects are allowed
 *
 * params are modified and then returned as a list
 *
 * @params
 * * damage - raw damage
 * * tier - penetration / attack tier
 * * flag - armor flag as seen in [code/__DEFINES/combat/armor.dm]
 * * mode - damage_mode
 * * attack_type - (optional) attack type flags from [code/__DEFINES/combat/attack_types.dm]
 * * weapon - (optional) attacking /obj/item for melee or thrown, /obj/projectile for ranged, /mob for unarmed
 * * additional - a way to retrieve data out of the shieldcall, passed in by attacks. [code/__DEFINES/dcs/signals/atoms/signals_atom_defense.dm]
 * * retval - shieldcall flags passed through components. [code/__DEFINES/dcs/signals/atoms/signals_atom_defense.dm]
 *
 * @return modified args as list
 */
/atom/proc/atom_shieldcall(damage, tier, flag, mode, attack_type, datum/weapon, list/additional = list(), retval = NONE)
	SEND_SIGNAL(src, COMSIG_ATOM_SHIELDCALL, args)
	return args.Copy()
