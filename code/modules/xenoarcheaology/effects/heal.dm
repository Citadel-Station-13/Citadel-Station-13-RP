/datum/artifact_effect/heal
	name = "heal"
	effect_type = EFFECT_ORGANIC

/datum/artifact_effect/heal/DoEffectTouch(var/mob/toucher)
	//todo: check over this properly
	if(toucher && iscarbon(toucher))
		var/weakness = GetAnomalySusceptibility(toucher)
		if(prob(weakness * 100))
			var/mob/living/carbon/C = toucher
			to_chat(C, "<font color=#4F49AF>You feel a soothing energy invigorate you.</font>")

			if(ishuman(toucher))
				var/mob/living/carbon/human/H = toucher
				for(var/obj/item/organ/external/affecting in H.organs)
					if(affecting && istype(affecting))
						affecting.heal_damage(25 * weakness, 25 * weakness)
				//H:heal_organ_damage(25, 25)
				H.blood_holder.adjust_host_volume(5)
				H.nutrition += 50 * weakness
				H.adjustBrainLoss(-25 * weakness)
				H.cure_radiation(RAD_MOB_CURE_ANOMALY_BURST * weakness)
				H.bodytemperature = initial(H.bodytemperature)
				spawn(1)
					H.reset_blood_to_species()
			//
			C.adjustOxyLoss(-25 * weakness)
			C.adjustToxLoss(-25 * weakness)
			C.adjustBruteLoss(-25 * weakness)
			C.adjustFireLoss(-25 * weakness)
			//
			C.regenerate_icons()
			return 1

/datum/artifact_effect/heal/DoEffectAura()
	//todo: check over this properly
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/carbon/C in range(src.effectrange,T))
			var/weakness = GetAnomalySusceptibility(C)
			if(prob(weakness * 100))
				if(prob(10))
					to_chat(C, "<font color=#4F49AF>You feel a soothing energy radiating from something nearby.</font>")
				C.adjustBruteLoss(-1 * weakness)
				C.adjustFireLoss(-1 * weakness)
				C.adjustToxLoss(-1 * weakness)
				C.adjustOxyLoss(-1 * weakness)
				C.adjustBrainLoss(-1 * weakness)
				C.update_health()

/datum/artifact_effect/heal/DoEffectPulse()
	//todo: check over this properly
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/carbon/C in range(src.effectrange,T))
			var/weakness = GetAnomalySusceptibility(C)
			if(prob(weakness * 100))
				to_chat(C, "<font color=#4F49AF>A wave of energy invigorates you.</font>")
				C.adjustBruteLoss(-5 * weakness)
				C.adjustFireLoss(-5 * weakness)
				C.adjustToxLoss(-5 * weakness)
				C.adjustOxyLoss(-5 * weakness)
				C.adjustBrainLoss(-5 * weakness)
				C.update_health()
