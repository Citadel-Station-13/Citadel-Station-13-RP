
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
//? Raw "damage"

// todo: better name
// /mob/living/proc/damage_brute()

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

