
/*
	apply_damage(a,b,c)
	args
	a:damage - How much damage to take
	b:damage_type - What type of damage to take, brute, burn
	c:def_zone - Where to take the damage if its brute or burn
	Returns
	standard 0 if fail
*/
/mob/living/proc/apply_damage(var/damage = 0,var/damagetype = DAMAGE_TYPE_BRUTE, var/def_zone = null, var/blocked = 0, var/soaked = 0, var/used_weapon = null, var/sharp = 0, var/edge = 0)
	if(!damage || (blocked >= 100))
		return 0
	if(soaked)
		if(soaked >= round(damage*0.8))
			damage -= round(damage*0.8)
		else
			damage -= soaked
	blocked = (100-blocked)/100
	switch(damagetype)
		if(DAMAGE_TYPE_BRUTE)
			adjustBruteLoss(damage * blocked)
		if(DAMAGE_TYPE_BURN)
			if(MUTATION_COLD_RESIST in mutations)
				damage = 0
			adjustFireLoss(damage * blocked)
		if(DAMAGE_TYPE_SEARING)
			apply_damage(damage / 3, DAMAGE_TYPE_BURN, def_zone, blocked, soaked, used_weapon, sharp, edge)
			apply_damage(damage / 3 * 2, DAMAGE_TYPE_BRUTE, def_zone, blocked, soaked, used_weapon, sharp, edge)
		if(DAMAGE_TYPE_TOX)
			adjustToxLoss(damage * blocked)
		if(DAMAGE_TYPE_OXY)
			adjustOxyLoss(damage * blocked)
		if(DAMAGE_TYPE_CLONE)
			adjustCloneLoss(damage * blocked)
		if(DAMAGE_TYPE_HALLOSS)
			adjustHalLoss(damage * blocked)
		if(DAMAGE_TYPE_BIOACID)
			if(isSynthetic())
				adjustFireLoss(damage * blocked)
			else
				adjustToxLoss(damage * blocked)
	flash_weak_pain()
	update_health()
	return 1


/mob/living/proc/apply_damages(var/brute = 0, var/burn = 0, var/tox = 0, var/oxy = 0, var/clone = 0, var/halloss = 0, var/def_zone = null, var/blocked = 0)
	if(blocked >= 100)
		return 0
	if(brute)	apply_damage(brute, DAMAGE_TYPE_BRUTE, def_zone, blocked)
	if(burn)	apply_damage(burn, DAMAGE_TYPE_BURN, def_zone, blocked)
	if(tox)		apply_damage(tox, DAMAGE_TYPE_TOX, def_zone, blocked)
	if(oxy)		apply_damage(oxy, DAMAGE_TYPE_OXY, def_zone, blocked)
	if(clone)	apply_damage(clone, DAMAGE_TYPE_CLONE, def_zone, blocked)
	if(halloss) apply_damage(halloss, DAMAGE_TYPE_HALLOSS, def_zone, blocked)
	return 1



/mob/living/proc/apply_effect(var/effect = 0,var/effecttype = STUN, var/blocked = 0, var/check_protection = 1)
	if(GLOB.Debug2)
		log_world("## DEBUG: apply_effect() was called.  The type of effect is [effecttype].  Blocked by [blocked].")
	if(!effect || (blocked >= 100))
		return 0
	blocked = (100-blocked)/100

	switch(effecttype)
		if(STUN)
			afflict_stun(20 * effect * blocked)
		if(WEAKEN)
			afflict_paralyze(20 * effect * blocked)
		if(PARALYZE)
			afflict_unconscious(20 * effect * blocked)
		if(AGONY)
			halloss += max((effect * blocked), 0) // Useful for objects that cause "subdual" damage. PAIN!
		if(IRRADIATE)
			afflict_radiation(effect, TRUE)
		if(STUTTER)
			if(status_flags & STATUS_CAN_STUN) // stun is usually associated with stutter
				stuttering = max(stuttering,(effect * blocked))
		if(EYE_BLUR)
			eye_blurry = max(eye_blurry,(effect * blocked))
		if(DROWSY)
			drowsyness = max(drowsyness,(effect * blocked))
	update_health()
	return 1

/mob/living/proc/apply_effects(var/stun = 0, var/weaken = 0, var/paralyze = 0, var/irradiate = 0, var/stutter = 0, var/eyeblur = 0, var/drowsy = 0, var/agony = 0, var/blocked = 0, var/ignite = 0, var/flammable = 0)
	if(blocked >= 100)
		return 0
	if(stun)		apply_effect(stun, STUN, blocked)
	if(weaken)		apply_effect(weaken, WEAKEN, blocked)
	if(paralyze)	apply_effect(paralyze, PARALYZE, blocked)
	if(irradiate)	apply_effect(irradiate, IRRADIATE, blocked)
	if(stutter)		apply_effect(stutter, STUTTER, blocked)
	if(eyeblur)		apply_effect(eyeblur, EYE_BLUR, blocked)
	if(drowsy)		apply_effect(drowsy, DROWSY, blocked)
	if(agony)		apply_effect(agony, AGONY, blocked)
	if(flammable)	adjust_fire_stacks(flammable)
	if(ignite)		IgniteMob()
	return 1

// todo: refactor above

//* Damage *//

/**
 * @return amount healed
 */
/mob/living/proc/heal_brute_loss(amount)
	return 0

/**
 * @return amount healed
 */
/mob/living/proc/heal_fire_loss(amount)
	return 0

/**
 * @return amount healed
 */
/mob/living/proc/heal_tox_loss(amount)
	return 0

/**
 * @return amount healed
 */
/mob/living/proc/heal_oxy_loss(amount)
	return 0

//* Raw Damage *//

/**
 * @params
 * * brute - brute damage to take
 * * burn - burn damage to take
 * * damage_mode - DAMAGE_MODE_* flags for the form of this damage
 * * weapon_descriptor - a string describing how it happened ("flash burns", "multiple precision cuts", etc)
 *
 * @return amount taken
 */
/mob/living/proc/take_random_targeted_damage(brute, burn, damage_mode, weapon_descriptor)
	return take_targeted_damage(brute, burn, damage_mode, pick(GLOB.body_zones), weapon_descriptor)

/**
 * @params
 * * brute - brute damage to take
 * * burn - burn damage to take
 * * damage_mode - DAMAGE_MODE_* flags for the form of this damage
 * * body_zone - body zone define (BP_*)
 * * weapon_descriptor - a string describing how it happened ("flash burns", "multiple precision cuts", etc)
 * * defer_updates - update health / perform damage checks?
 *
 * @return amount taken
 */
/mob/living/proc/take_targeted_damage(brute, burn, damage_mode, body_zone, weapon_descriptor, defer_updates)
	if(status_flags & STATUS_GODMODE)
		return 0
	// todo: don't update health immediately
	. = adjustBruteLoss(brute) + adjustFireLoss(burn)

/**
 * @params
 * * brute - brute damage to take
 * * burn - burn damage to take
 * * damage_mode - DAMAG_EMODE_* flags for the form of this damage
 * * weapon descriptor - a string describing how it happened ("flash burns", "multiple precision cuts", etc)
 * * defer_updates - update health / perform damage checks?
 *
 * @return amount taken
 */
/mob/living/proc/take_overall_damage(brute, burn, damage_mode, weapon_descriptor, defer_updates)
	if(status_flags & STATUS_GODMODE)
		return 0
	// todo: don't update health immediately
	. = adjustBruteLoss(brute) + adjustFireLoss(burn)

//? Afflictions
/**
 * inflicts radiation.
 * will not heal it.
 *
 * @params
 * - amt - how much
 * - check_armor - do'th we care about armor?
 * - def_zone - zone to check if we do
 */
/mob/living/proc/afflict_radiation(amt, run_armor, def_zone)
	if(amt <= 0)
		return
	if(run_armor)
		amt *= 1 - ((legacy_mob_armor(def_zone, ARMOR_RAD)) / 100)
	radiation += max(0, RAD_MOB_ADDITIONAL(amt, radiation))

/**
 * heals radiation.
 *
 * @params
 * - amt - how much
 */
/mob/living/proc/cure_radiation(amt)
	if(amt <= 0)
		return
	radiation = max(0, radiation - amt)

//* Damage Instance Handling *//

/mob/living/inflict_damage_instance(SHIELDCALL_PROC_HEADER)
	if(inflict_damage_type_special(args))
		return

	var/weapon_descriptor = RESOLVE_SHIELDCALL_WEAPON_DESCRIPTOR(args)
	var/brute = damage_type == DAMAGE_TYPE_BRUTE? damage : 0
	var/burn = damage_type == DAMAGE_TYPE_BURN? damage : 0

	if(hit_zone)
		take_targeted_damage(brute, burn, damage_mode, hit_zone, weapon_descriptor)
	else
		take_overall_damage(brute, burn, damage_mode, weapon_descriptor)
