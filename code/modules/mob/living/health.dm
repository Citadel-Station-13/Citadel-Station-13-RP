//? Health / Stat

/mob/living/update_health()
	if(status_flags & STATUS_GODMODE)
		health = 100
		set_stat(CONSCIOUS)
	else
		health = getMaxHealth() - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss() - getCloneLoss() - halloss

/mob/living/update_stat(forced, update_mobility)
	if(stat == DEAD)
		return stat
	if(is_unconscious() || is_sleeping() || HAS_TRAIT(src, TRAIT_MOB_UNCONSCIOUS) || HAS_TRAIT(src, TRAIT_MOB_SLEEPING) || (status_flags & STATUS_FAKEDEATH))
		. = UNCONSCIOUS
	else
		. = CONSCIOUS
	. = max(., isnull(forced)? initial(stat) : forced)
	if(. != stat)
		set_stat(., update_mobility)

/mob/living/set_stat(new_stat, update_mobility)
	. = ..()
	if(!.)
		return
	GLOB.cultnet.updateVisibility(src, FALSE)

/mob/living/revive(force, full_heal)
	. = ..()
	if(!.)
		return
	#warn impl

/mob/living/rejuvenate(fix_missing, reset_to_slot)
	. = ..()
	if(!.)
		return
	// deal with tox/oxy/clone
	setToxLoss(0)
	setOxyLoss(0)
	setCloneLoss(0)
	// deal with breathing
	losebreath = 0
	// deal with brain
	// todo: brain should be carbon only, or maybe just make the numerical variant simplemob?
	setBrainLoss(0)
	// clear stuns
	clear_all_incapacitation_effects()
	// deal with radiation
	radiation = 0
	// fix nutrition
	// todo: species?
	nutrition = 40
	// deal with temperature
	set_bodytemperature(nominal_bodytemperature())
	// extinguish fires
	ExtinguishMob()
	fire_stacks = 0
	// clear reagents
	// todo: only bad reagents
	reagents?.clear_reagents()
	//! WARNING: LEGACY CODE
	sdisabilities = 0 // ???
	disabilities = 0 // ???
	blinded = 0
	SetBlinded(0)
	eye_blind = 0
	ear_deaf = 0
	ear_damage = 0
	failed_last_breath = 0
	reload_fullscreen() // LEAVE THIS AT THE END UNTIL WE REWORK HUD RENDERING
	//! END
	// update hud after overrides of rejuvenate() fire
	addtimer(CALLBACK(src, TYPE_PROC_REF(/mob, update_hud_med_all)), 0)
	// update all icons just in case
	// todo: we shouldn't have to do this
	addtimer(CALLBACK(src, TYPE_PROC_REF(/mob, regenerate_icons)))

	#warn impl

//? Body Temperature

/**
 * set body temperature
 */
/mob/living/proc/set_bodytemperature(amt)
	bodytemperature = amt
/**
 * adjust body temperature
 */
/mob/living/proc/adjust_bodytemperature(amt)
	set_bodytemperature(bodytemperature + amt)

/**
 * get normal bodytemperature
 */
/mob/living/proc/nominal_bodytemperature()
	return T20C

/**
 * stabliize bodytemperature towards normal
 */
/mob/living/proc/normalize_bodytemperature(adj, mult)
	var/diff = nominal_bodytemperature() - bodytemperature
	var/adjust = SIGN(diff) * min(adj, abs(diff))
	adjust_bodytemperature(adjust + (diff - adjust) * mult)
