/mob/living/simple_mob/boss/hierophant
	#warn name, desc
	#warn icon stuff


	/// our vortex magic holder
	var/datum/vortex_magic/vortex

/mob/living/simple_mob/boss/hierophant/Initialize(mapload)
	vortex = new /datum/vortex_magic/boss
	return ..()

#warn impl

/datum/ai_holder/special/hierophant
	expected_type = /mob/living/simple_mob/boss/hierophant
	var/atom/movable/holder
	#warn just a placeholder..

	var/rage = 0
	var/next_engagement = 0
	var/list/atom/movable/contestants
	var/violence_level = HIEROPHANT_VIOLENCE_TRIAL
	var/difficulty = 1
	/// cached instance when we initialize - allows for cleaner code and faster access
	var/datum/vortex_magic/vortex

/datum/ai_holder/special/hierophant/tick(cycles)

/datum/ai_holder/special/hierophant/proc/prelude(list/atom/movable/gamers)
	src.contestants = gamers.Copy()
	#warn impl
	resume()
	opener()

/datum/ai_holder/special/hierophant/proc/engagement(mob/focused)

/datum/ai_holder/special/hierophant/proc/will_enrage(atom/target)
	if(!ishuman(target))
		return FALSE
	var/mob/living/carbon/human/H = target
	return istype(H.species, /datum/species/shapeshifter/xenochimera) || istype(H.species, /datum/species/protean)

/datum/ai_holder/special/hierophant/proc/tracer_swarm(atom/target, amount = 4, delay = 2, speed = 1.5)

/datum/ai_holder/special/hierophant/proc/alternating_sweep(full = TRUE, width = 2, spacing = 2)

/datum/ai_holder/special/hierophant/proc/disco_blasts(atom/target, amount = 6, delay = 2)

/datum/ai_holder/special/hierophant/proc/beam_sweep(atom/target)

/datum/ai_holder/special/hierophant/proc/opener()
