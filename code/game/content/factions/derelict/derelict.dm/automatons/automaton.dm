/mob/living/simple_mob/mechanical/derelict
	var/self_rejuvination = FALSE
	vision_innate = /datum/vision/baseline/species_tier_3

	response_help = "shoves aside"
	response_disarm = "forces aside"
	response_harm = "smashes into"


/mob/living/simple_mob/mechanical/derelict/Process_Spacemove(var/check_drift = 0)
	return TRUE


/mob/living/simple_mob/mechanical/derelict/handle_special()
	if(self_rejuvination)
		adjustBruteLoss(-2)
		adjustFireLoss(-2)
		adjustToxLoss(-2)
		adjustOxyLoss(-2)
		adjustCloneLoss(-2)
	..()
