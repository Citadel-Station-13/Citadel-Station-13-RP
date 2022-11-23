/datum/artifact_effect/radiate
	name = "radiation"
	var/radiation_amount

/datum/artifact_effect/radiate/New()
	..()
	radiation_amount = rand(RAD_INTENSITY_ANOMALY_PULSE_LOW, RAD_INTENSITY_ANOMALY_PULSE_LOW)
	effect_type = pick(EFFECT_PARTICLE, EFFECT_ORGANIC)

/datum/artifact_effect/radiate/DoEffectTouch(var/mob/living/user)
	if(user)
		user.apply_effect(radiation_amount * 5,IRRADIATE,0)
		user.updatehealth()
		return 1
#warn radiation

/datum/artifact_effect/radiate/DoEffectAura()
	if(holder)
		radiation_pulse(src, radiation_amount, RAD_FALLOFF_ANOMALY)
		return 1

/datum/artifact_effect/radiate/DoEffectPulse()
	if(holder)
		radiation_pulse(src, radiation_amount, RAD_FALLOFF_ANOMALY)
		return 1
