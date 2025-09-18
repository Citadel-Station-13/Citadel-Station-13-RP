//? Health / Stat

/mob/living/update_health()
	if(status_flags & STATUS_GODMODE)
		health = 100
		set_stat(CONSCIOUS)
	else
		var/old_health = health
		health = getMaxHealth() - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss() - getCloneLoss() - halloss
		if(old_health != health)
			update_hud_med_health()

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

/mob/living/revive(force, full_heal, restore_nutrition = TRUE)
	. = ..()
	if(!.)
		return
	//! WARNING: LEGACY CODE
	tod = null
	timeofdeath = 0
	if(istype(ai_holder, /datum/ai_holder/polaris))
		var/datum/ai_holder/polaris/ai_holder = src.ai_holder
		ai_holder?.go_wake()
	failed_last_breath = 0
	reload_fullscreen() // LEAVE THIS AT THE END UNTIL WE REWORK HUD RENDERING
	//! END

/mob/living/rejuvenate(fix_missing, reset_to_slot, restore_nutrition = TRUE)
	. = ..()
	if(!.)
		return
	// deal with brute/burn
	// todo: this is shitcode, fix it in organs update.
	heal_overall_damage(INFINITY, INFINITY, TRUE)
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
	if(restore_nutrition)
		nutrition = 400
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
	remove_status_effect(/datum/status_effect/sight/blindness)
	ear_deaf = 0
	ear_damage = 0
	failed_last_breath = 0
	mutations?.Remove(
		MUTATION_HUSK,
		MUTATION_CLUMSY,
		MUTATION_FAT,
		MUTATION_HALLUCINATION,
	)
	reload_fullscreen() // LEAVE THIS AT THE END UNTIL WE REWORK HUD RENDERING
	//! END
	// update hud after overrides of rejuvenate() fire
	addtimer(CALLBACK(src, TYPE_PROC_REF(/mob, update_hud_med_all)), 0)
	// update all icons just in case
	// todo: we shouldn't have to do this
	addtimer(CALLBACK(src, TYPE_PROC_REF(/mob, regenerate_icons)))

//? Body Temperature

/**
 * set body temperature
 */
/mob/living/proc/set_bodytemperature(amt)
	bodytemperature = max(TCMB, amt)
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
