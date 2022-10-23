// Alien larva are quite simple.
/mob/living/carbon/alien/Life(seconds, times_fired)
	blinded = null
	. = ..()
	if(.)
		return

	if(!transforming)
		update_icons()

/mob/living/carbon/alien/BiologicalLife(seconds, times_fired)
	if((. = ..()))
		return

	if(stat != DEAD)
		update_progression()

/mob/living/carbon/alien/handle_mutations_and_radiation()

	// Currently both Dionaea and larvae like to eat radiation, so I'm defining the
	// rad absorbtion here. This will need to be changed if other baby aliens are added.

	if(!radiation)
		return

	var/rads = radiation/25
	radiation -= rads
	nutrition += rads
	heal_overall_damage(rads,rads)
	adjustOxyLoss(-(rads))
	adjustToxLoss(-(rads))
	return

/mob/living/carbon/alien/handle_regular_UI_updates()

	if(status_flags & GODMODE)	return 0

	if(stat == DEAD)
		blinded = 1
		silent = 0
	else
		updatehealth()
		if(health <= 0)
			death()
			blinded = 1
			silent = 0
			return 1

		if(paralysis && paralysis > 0)
			blinded = 1
			set_stat(UNCONSCIOUS)
			if(halloss > 0)
				adjustHalLoss(-3)

		if(sleeping)
			adjustHalLoss(-3)
			if (mind)
				if(mind.active && client != null)
					AdjustSleeping(-1)
			blinded = 1
			set_stat(UNCONSCIOUS)
		else if(resting)
			if(halloss > 0)
				adjustHalLoss(-3)

		else
			set_stat(CONSCIOUS)
			if(halloss > 0)
				adjustHalLoss(-1)

		// Eyes and blindness.
		if(!has_eyes())
			SetBlinded(1)
			blinded =    1
			eye_blurry = 1
		else if(eye_blind)
			AdjustBlinded(-1)
			blinded =    1
		else if(eye_blurry)
			eye_blurry = max(eye_blurry-1, 0)

		update_icons()

	return 1

/mob/living/carbon/alien/handle_regular_hud_updates()
	if (stat == 2 || (MUTATION_XRAY in src.mutations))
		AddSightSelf(SEE_TURFS | SEE_MOBS | SEE_OBJS)
		SetSeeInDarkSelf(8)
		SetSeeInvisibleSelf(SEE_INVISIBLE_LEVEL_TWO)
	else if (stat != 2)
		RemoveSightSelf(SEE_TURFS | SEE_MOBS | SEE_OBJS)
		SetSeeInDarkSelf(2)
		SetSeeInvisibleSelf(SEE_INVISIBLE_LIVING)

	if (healths)
		if (stat != 2)
			switch(health)
				if(100 to INFINITY)
					healths.icon_state = "health0"
				if(80 to 100)
					healths.icon_state = "health1"
				if(60 to 80)
					healths.icon_state = "health2"
				if(40 to 60)
					healths.icon_state = "health3"
				if(20 to 40)
					healths.icon_state = "health4"
				if(0 to 20)
					healths.icon_state = "health5"
				else
					healths.icon_state = "health6"
		else
			healths.icon_state = "health7"

	if ( stat != 2)
		if(blinded)
			overlay_fullscreen("blind", /atom/movable/screen/fullscreen/scaled/blind)
		else
			clear_fullscreen("blind")
		if(disabilities & DISABILITY_NEARSIGHTED)
			overlay_fullscreen("impaired", /atom/movable/screen/fullscreen/scaled/impaired, 1)
		else
			clear_fullscreen("impaired")
		if(eye_blurry)
			overlay_fullscreen("blurry", /atom/movable/screen/fullscreen/tiled/blurry)
		else
			clear_fullscreen("blurry")
		if(druggy)
			overlay_fullscreen("high", /atom/movable/screen/fullscreen/tiled/high)
		else
			clear_fullscreen("high")

		if(IsRemoteViewing())
			if(machine && machine.check_eye(src) < 0)
				reset_perspective()

	return 1

/mob/living/carbon/alien/handle_environment(var/datum/gas_mixture/environment)
	// Both alien subtypes survive in vacuum and suffer in high temperatures,
	// so I'll just define this once, for both (see radiation comment above)
	if(!environment) return

	if(environment.temperature > (T0C+66))
		adjustFireLoss((environment.temperature - (T0C+66))/5) // Might be too high, check in testing.
		if (fire) fire.icon_state = "fire2"
		if(prob(20))
			to_chat(src, "<font color='red'>You feel a searing heat!</font>")
	else
		if (fire) fire.icon_state = "fire0"

/mob/living/carbon/alien/handle_fire()
	if(..())
		return
	bodytemperature += BODYTEMP_HEATING_MAX //If you're on fire, you heat up!
	return
