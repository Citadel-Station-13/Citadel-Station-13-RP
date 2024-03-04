
/*
	apply_damage(a,b,c)
	args
	a:damage - How much damage to take
	b:damage_type - What type of damage to take, brute, burn
	c:def_zone - Where to take the damage if its brute or burn
	Returns
	standard 0 if fail
*/
/mob/living/proc/apply_damage(var/damage = 0,var/damagetype = BRUTE, var/def_zone = null, var/blocked = 0, var/soaked = 0, var/used_weapon = null, var/sharp = 0, var/edge = 0)
	if(GLOB.Debug2)
		log_world("## DEBUG: apply_damage() was called on [src], with [damage] damage, and an armor value of [blocked].")
	if(!damage || (blocked >= 100))
		return 0
	if(soaked)
		if(soaked >= round(damage*0.8))
			damage -= round(damage*0.8)
		else
			damage -= soaked
	blocked = (100-blocked)/100
	switch(damagetype)
		if(BRUTE)
			adjustBruteLoss(damage * blocked)
		if(BURN)
			if(MUTATION_COLD_RESIST in mutations)
				damage = 0
			adjustFireLoss(damage * blocked)
		if(SEARING)
			apply_damage(damage / 3, BURN, def_zone, blocked, soaked, used_weapon, sharp, edge)
			apply_damage(damage / 3 * 2, BRUTE, def_zone, blocked, soaked, used_weapon, sharp, edge)
		if(TOX)
			adjustToxLoss(damage * blocked)
		if(OXY)
			adjustOxyLoss(damage * blocked)
		if(CLONE)
			adjustCloneLoss(damage * blocked)
		if(HALLOSS)
			adjustHalLoss(damage * blocked)
		if(ELECTROCUTE)
			electrocute_act(damage, used_weapon, 1.0, def_zone)
		if(BIOACID)
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
	if(brute)	apply_damage(brute, BRUTE, def_zone, blocked)
	if(burn)	apply_damage(burn, BURN, def_zone, blocked)
	if(tox)		apply_damage(tox, TOX, def_zone, blocked)
	if(oxy)		apply_damage(oxy, OXY, def_zone, blocked)
	if(clone)	apply_damage(clone, CLONE, def_zone, blocked)
	if(halloss) apply_damage(halloss, HALLOSS, def_zone, blocked)
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

//* Afflictions *//

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

//* Unsorted *//

// Applies direct "cold" damage while checking protection against the cold.
/mob/living/proc/inflict_cold_damage(amount)
	amount *= 1 - get_cold_protection(50) // Within spacesuit protection.
	if(amount > 0)
		adjustFireLoss(amount)

// Ditto, but for "heat".
/mob/living/proc/inflict_heat_damage(amount)
	amount *= 1 - get_heat_protection(10000) // Within firesuit protection.
	if(amount > 0)
		adjustFireLoss(amount)

// and one for electricity because why not
/mob/living/proc/inflict_shock_damage(amount)
	electrocute_act(amount, null, 1 - get_shock_protection(), pick(BP_HEAD, BP_TORSO, BP_GROIN))

// also one for water (most things resist it entirely, except for slimes)
/mob/living/proc/inflict_water_damage(amount)
	amount *= 1 - get_water_protection()
	if(amount > 0)
		adjustToxLoss(amount)

// one for abstracted away ""poison"" (mostly because simplemobs shouldn't handle reagents)
/mob/living/proc/inflict_poison_damage(amount)
	if(isSynthetic())
		return
	amount *= 1 - get_poison_protection()
	if(amount > 0)
		adjustToxLoss(amount)

// heal ONE external organ, organ gets randomly selected from damaged ones.
/mob/living/proc/heal_organ_damage(var/brute, var/burn)
	adjustBruteLoss(-brute)
	adjustFireLoss(-burn)
	src.update_health()

/**
 * @return amount healed
 */
/mob/living/proc/heal_overall_damage(var/brute, var/burn)
	adjustBruteLoss(-brute)
	adjustFireLoss(-burn)
	. = brute + burn
	src.update_health()

/mob/living/proc/getBruteLoss()
	return bruteloss

/mob/living/proc/getShockBruteLoss()	//Only checks for things that'll actually hurt (not robolimbs)
	return bruteloss

/mob/living/proc/getActualBruteLoss()	// Mostly for humans with robolimbs.
	return getBruteLoss()

//'include_robo' only applies to healing, for legacy purposes, as all damage typically hurts both types of organs
/mob/living/proc/adjustBruteLoss(var/amount,var/include_robo)
	if(status_flags & STATUS_GODMODE)	return 0	//godmode

	if(amount > 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.incoming_damage_percent))
				amount *= M.incoming_damage_percent
			if(!isnull(M.incoming_brute_damage_percent))
				amount *= M.incoming_brute_damage_percent
	else if(amount < 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.incoming_healing_percent))
				amount *= M.incoming_healing_percent

	bruteloss = min(max(bruteloss + amount, 0),(getMaxHealth()*2))
	update_health()

/mob/living/proc/getOxyLoss()
	return oxyloss

/mob/living/proc/adjustOxyLoss(var/amount)
	if(status_flags & STATUS_GODMODE)	return 0	//godmode

	if(amount > 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.incoming_damage_percent))
				amount *= M.incoming_damage_percent
			if(!isnull(M.incoming_oxy_damage_percent))
				amount *= M.incoming_oxy_damage_percent
	else if(amount < 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.incoming_healing_percent))
				amount *= M.incoming_healing_percent

	oxyloss = min(max(oxyloss + amount, 0),(getMaxHealth()*2))
	update_health()

/mob/living/proc/setOxyLoss(var/amount)
	if(status_flags & STATUS_GODMODE)	return 0	//godmode
	oxyloss = amount

/mob/living/proc/getToxLoss()
	return toxloss

/mob/living/proc/adjustToxLoss(var/amount)
	if(status_flags & STATUS_GODMODE)	return 0	//godmode

	if(amount > 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.incoming_damage_percent))
				amount *= M.incoming_damage_percent
			if(!isnull(M.incoming_tox_damage_percent))
				amount *= M.incoming_tox_damage_percent
	else if(amount < 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.incoming_healing_percent))
				amount *= M.incoming_healing_percent

	toxloss = min(max(toxloss + amount, 0),(getMaxHealth()*2))
	update_health()

/mob/living/proc/setToxLoss(var/amount)
	if(status_flags & STATUS_GODMODE)	return 0	//godmode
	toxloss = amount

/mob/living/proc/getFireLoss()
	return fireloss

/mob/living/proc/getShockFireLoss()	//Only checks for things that'll actually hurt (not robolimbs)
	return fireloss

/mob/living/proc/getActualFireLoss()	// Mostly for humans with robolimbs.
	return getFireLoss()

//'include_robo' only applies to healing, for legacy purposes, as all damage typically hurts both types of organs
/mob/living/proc/adjustFireLoss(var/amount,var/include_robo)
	if(status_flags & STATUS_GODMODE)	return 0	//godmode
	if(amount > 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.incoming_damage_percent))
				amount *= M.incoming_damage_percent
			if(!isnull(M.incoming_fire_damage_percent))
				amount *= M.incoming_fire_damage_percent
	else if(amount < 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.incoming_healing_percent))
				amount *= M.incoming_healing_percent

	fireloss = min(max(fireloss + amount, 0),(getMaxHealth()*2))
	update_health()

/mob/living/proc/getCloneLoss()
	return cloneloss

/mob/living/proc/adjustCloneLoss(var/amount)
	if(status_flags & STATUS_GODMODE)	return 0	//godmode

	if(amount > 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.incoming_damage_percent))
				amount *= M.incoming_damage_percent
			if(!isnull(M.incoming_clone_damage_percent))
				amount *= M.incoming_clone_damage_percent
	else if(amount < 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.incoming_healing_percent))
				amount *= M.incoming_healing_percent

	cloneloss = min(max(cloneloss + amount, 0),(getMaxHealth()*2))
	update_health()

/mob/living/proc/setCloneLoss(var/amount)
	if(status_flags & STATUS_GODMODE)	return 0	//godmode
	cloneloss = amount

/mob/living/proc/getBrainLoss()
	return brainloss

/mob/living/proc/adjustBrainLoss(var/amount)
	if(status_flags & STATUS_GODMODE)	return 0	//godmode
	brainloss = min(max(brainloss + amount, 0),(getMaxHealth()*2))

/mob/living/proc/setBrainLoss(var/amount)
	if(status_flags & STATUS_GODMODE)	return 0	//godmode
	brainloss = amount

/mob/living/proc/getHalLoss()
	return halloss

/mob/living/proc/adjustHalLoss(var/amount)
	if(status_flags & STATUS_GODMODE)	return 0	//godmode
	if(amount > 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.incoming_damage_percent))
				amount *= M.incoming_damage_percent
			if(!isnull(M.incoming_hal_damage_percent))
				amount *= M.incoming_hal_damage_percent
			if(!isnull(M.disable_duration_percent))
				amount *= M.incoming_hal_damage_percent
	else if(amount < 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.incoming_healing_percent))
				amount *= M.incoming_healing_percent
	halloss = min(max(halloss + amount, 0),(getMaxHealth()*2))
	update_health()

/mob/living/proc/setHalLoss(var/amount)
	if(status_flags & STATUS_GODMODE)	return 0	//godmode
	halloss = amount
