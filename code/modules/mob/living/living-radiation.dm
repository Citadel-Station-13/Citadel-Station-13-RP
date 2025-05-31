/mob/living/rad_act(strength, datum/radiation_wave/wave)
	. = ..()
	afflict_radiation(strength * RAD_MOB_ACT_COEFFICIENT - RAD_MOB_ACT_PROTECTION_PER_WAVE_SOURCE, TRUE)
