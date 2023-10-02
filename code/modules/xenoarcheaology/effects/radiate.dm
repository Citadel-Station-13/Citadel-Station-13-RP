/datum/artifact_effect/radiate
	name = "radiation"
	var/radiation_amount

/datum/artifact_effect/radiate/New()
	..()
	radiation_amount = rand(RAD_INTENSITY_ANOMALY_PULSE_LOW, RAD_INTENSITY_ANOMALY_PULSE_LOW)
	effect_type = pick(EFFECT_PARTICLE, EFFECT_ORGANIC)

/datum/artifact_effect/radiate/DoEffectTouch(var/mob/living/user)
	radiation_pulse(holder, radiation_amount, RAD_FALLOFF_ANOMALY)
	return 1

/datum/artifact_effect/radiate/DoEffectAura()
	if(holder)
		radiation_pulse(holder, radiation_amount, RAD_FALLOFF_ANOMALY)
		return 1

/datum/artifact_effect/radiate/DoEffectPulse()
	if(holder)
		radiation_pulse(holder, radiation_amount, RAD_FALLOFF_ANOMALY)
		return 1
