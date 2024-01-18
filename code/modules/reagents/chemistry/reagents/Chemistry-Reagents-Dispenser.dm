

/datum/reagent/ethanol
	name = "Ethanol" //Parent class for all alcoholic reagents.
	id = "ethanol"
	description = "A well-known alcohol with a variety of applications."
	taste_description = "pure alcohol"
	reagent_state = REAGENT_LIQUID
	color = "#404030"

	ingested_metabolism_multiplier = 2

	var/nutriment_factor = 0
	var/hydration_factor = 0
	// todo: this is awful why is strength lower when higher?
	var/strength = 10 // This is, essentially, units between stages - the lower, the stronger. Less fine tuning, more clarity.
	var/toxicity = 1

	var/druggy = 0
	var/adj_temp = 0
	var/targ_temp = 310
	var/halluci = 0

	glass_name = "ethanol"
	glass_desc = "A well-known alcohol with a variety of applications."

/datum/reagent/ethanol/touch_expose_mob(mob/target, volume, temperature, list/data, organ_tag)
	. = ..()
	var/mob/living/L = target
	if(istype(L))
		L.adjust_fire_stacks(volume / 15)

/datum/reagent/ethanol/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	if(issmall(entity)) removed *= 2
	var/strength_mod = 3 //Alcohol is 3x stronger when injected into the veins.
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_SKRELL)])
		strength_mod *= 5
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_TAJARAN)])
		strength_mod *= 1.25
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_UNATHI)])
		strength_mod *= 0.75
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		strength_mod = 0
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_PROMETHEAN)])
		strength_mod *= 2
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_ALRAUNE)])
		if(prob(5))
			to_chat(entity, "<span class='danger'>You feel your leaves start to wilt.</span>")
		strength_mod *=5 //cit change - alcohol ain't good for plants

	var/effective_dose = metabolism.highest_so_far * strength_mod * (1 + entity.reagents_bloodstream.get_reagent_amount(src)/60) //drinking a LOT will make you go down faster
	entity.add_reagent_cycle_effect(CHEMICAL_EFFECT_ALCOHOL, 1)
	if(HAS_TRAIT(entity, TRAIT_ALCOHOL_INTOLERANT))
		if(prob(effective_dose/10))
			entity.add_reagent_cycle_effect(CHEMICAL_EFFECT_ALCOHOL_TOXIC, 1)
		entity.adjustToxLoss(effective_dose/10)
		return 0
	if(effective_dose >= strength) // Early warning
		entity.make_dizzy(18) // It is decreased at the speed of 3 per tick
	if(effective_dose >= strength * 2) // Slurring
		entity.slurring = max(entity.slurring, 90)
	if(effective_dose >= strength * 3) // Confusion - walking in random directions
		entity.Confuse(60)
	if(effective_dose >= strength * 4) // Blurry vision
		entity.eye_blurry = max(entity.eye_blurry, 30)
	if(effective_dose >= strength * 5) // Drowsyness - periodically falling asleep
		entity.drowsyness = max(entity.drowsyness, 60)
	if(effective_dose >= strength * 6) // Toxic dose
		entity.add_reagent_cycle_effect(CHEMICAL_EFFECT_ALCOHOL_TOXIC, toxicity*3)
	if(effective_dose >= strength * 7) // Pass out
		entity.afflict_unconscious(20 * 60)
		entity.afflict_sleeping(20 * 90)

	if(druggy != 0)
		entity.druggy = max(entity.druggy, druggy*3)

	if(adj_temp > 0 && entity.bodytemperature < targ_temp) // 310 is the normal bodytemp. 310.055
		entity.bodytemperature = min(targ_temp, entity.bodytemperature + (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))
	if(adj_temp < 0 && entity.bodytemperature > targ_temp)
		entity.bodytemperature = min(targ_temp, entity.bodytemperature - (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))

	if(halluci)
		entity.hallucination = max(entity.hallucination, halluci*3)
	return effective_dose

/datum/reagent/ethanol/on_metabolize_ingested(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed, obj/item/organ/internal/container)
	. = ..()

	entity.adjust_nutrition(nutriment_factor * removed)
	entity.adjust_hydration(hydration_factor * removed)
	var/strength_mod = 1
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_SKRELL)])
		strength_mod *= 5
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_TAJARAN)])
		strength_mod *= 1.25
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_UNATHI)])
		strength_mod *= 0.75
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		strength_mod = 0
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_PROMETHEAN)])
		strength_mod *= 2
	handle_vampire(entity, removed)

	var/effective_dose = strength_mod * entity.reagents_bloodstream.get_reagent_amount(src) // this was being recalculated a bunch before--why?
	if(HAS_TRAIT(entity, TRAIT_ALCOHOL_INTOLERANT))
		if(prob(effective_dose/10))
			entity.add_reagent_cycle_effect(CHEMICAL_EFFECT_ALCOHOL_TOXIC, 1)
		entity.adjustToxLoss(effective_dose/10)
		return 0
	entity.add_reagent_cycle_effect(CHEMICAL_EFFECT_ALCOHOL, 1)
	if(effective_dose >= strength) // Early warning
		entity.make_dizzy(6) // It is decreased at the speed of 3 per tick
	if(effective_dose >= strength * 2) // Slurring
		entity.slurring = max(entity.slurring, 30)
	if(effective_dose >= strength * 3) // Confusion - walking in random directions
		entity.Confuse(20)
	if(effective_dose >= strength * 4) // Blurry vision
		entity.eye_blurry = max(entity.eye_blurry, 10)
	if(effective_dose >= strength * 5) // Drowsyness - periodically falling asleep
		entity.drowsyness = max(entity.drowsyness, 20)
	if(effective_dose >= strength * 6) // Toxic dose
		entity.add_reagent_cycle_effect(CHEMICAL_EFFECT_ALCOHOL_TOXIC, toxicity)
	if(effective_dose >= strength * 7) // Pass out
		entity.afflict_unconscious(20 * 20)
		entity.afflict_sleeping(20 * 30)

	if(druggy != 0)
		entity.druggy = max(entity.druggy, druggy)

	if(adj_temp > 0 && entity.bodytemperature < targ_temp) // 310 is the normal bodytemp. 310.055
		entity.bodytemperature = min(targ_temp, entity.bodytemperature + (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))
	if(adj_temp < 0 && entity.bodytemperature > targ_temp)
		entity.bodytemperature = min(targ_temp, entity.bodytemperature - (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))

	if(halluci)
		entity.hallucination = max(entity.hallucination, halluci)
	return effective_dose

/datum/reagent/ethanol/contact_expose_obj(obj/target, volume, list/data, vapor)
	. = ..()

	var/obj/O = target
	if(istype(O, /obj/item/paper))
		var/obj/item/paper/paperaffected = O
		paperaffected.clearpaper()
		to_chat(usr, "The solution dissolves the ink on the paper.")
		return
	if(istype(O, /obj/item/book))
		if(volume < 5)
			return
		if(istype(O, /obj/item/book/tome))
			to_chat(usr, "<span class='notice'>The solution does nothing. Whatever this is, it isn't normal ink.</span>")
			return
		var/obj/item/book/affectedbook = O
		affectedbook.dat = null
		to_chat(usr, "<span class='notice'>The solution dissolves the ink on the book.</span>")

/datum/reagent/acid
	name = "Sulphuric acid"
	id = "sacid"
	description = "A very corrosive mineral acid with the molecular formula H2SO4."
	taste_description = "acid"
	reagent_state = REAGENT_LIQUID
	color = "#DB5008"
	bloodstream_metabolism_multiplier = 2
	dermal_absorption_multiplier = 0
	var/power = 5
	var/meltdose = 10 // How much is needed to melt

/datum/reagent/acid/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	entity.take_organ_damage(0, removed * power * 2)

/datum/reagent/acid/touch_expose_mob(mob/target, volume, temperature, list/data, organ_tag)
	. = ..()

	var/mob/living/carbon/M = target
	if(!istype(M))
		return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.head)
			if(H.head.integrity_flags & INTEGRITY_ACIDPROOF)
				to_chat(H, "<span class='danger'>Your [H.head] protects you from the acid.</span>")
				return volume
			else if(volume > meltdose)
				to_chat(H, "<span class='danger'>Your [H.head] melts away!</span>")
				qdel(H.head)
				H.update_inv_head(1)
				H.update_hair(1)
				. += meltdose
		if(volume <= 0)
			return

		if(H.wear_mask)
			if(H.wear_mask.integrity_flags & INTEGRITY_ACIDPROOF)
				to_chat(H, "<span class='danger'>Your [H.wear_mask] protects you from the acid.</span>")
				return volume
			else if(volume > meltdose)
				to_chat(H, "<span class='danger'>Your [H.wear_mask] melts away!</span>")
				qdel(H.wear_mask)
				H.update_inv_wear_mask(1)
				H.update_hair(1)
				. += meltdose
		if(volume <= 0)
			return

		if(H.glasses)
			if(H.glasses.integrity_flags & INTEGRITY_ACIDPROOF)
				to_chat(H, "<span class='danger'>Your [H.glasses] partially protect you from the acid!</span>")
				. += volume / 2
				volume /= 2
			else if(volume > meltdose)
				to_chat(H, "<span class='danger'>Your [H.glasses] melt away!</span>")
				qdel(H.glasses)
				H.update_inv_glasses(1)
				. += meltdose / 2
		if(volume <= 0)
			return

	if(volume < meltdose) // Not enough to melt anything
		M.take_organ_damage(0, volume * power * 0.2) //burn damage, since it causes chemical burns. Acid doesn't make bones shatter, like brute trauma would.
		return
	if(!M.unacidable && volume > 0)
		if(istype(M, /mob/living/carbon/human) && volume >= meltdose)
			var/mob/living/carbon/human/H = M
			var/obj/item/organ/external/affecting = H.get_organ(BP_HEAD)
			if(affecting)
				if(affecting.take_damage(0, volume * power * 0.1))
					H.UpdateDamageIcon()
				if(prob(100 * volume / meltdose)) // Applies disfigurement
					if (affecting.organ_can_feel_pain())
						H.emote("scream")
		else
			M.take_organ_damage(0, volume * power * 0.1) // Balance. The damage is instant, so it's weaker. 10 units -> 5 damage, double for pacid. 120 units beaker could deal 60, but a) it's burn, which is not as dangerous, b) it's a one-use weapon, c) missing with it will splash it over the ground and d) clothes give some protection, so not everything will hit

/datum/reagent/acid/contact_expose_obj(obj/target, volume, list/data, vapor)
	. = ..()

	var/obj/O = target
	if(O.integrity_flags & INTEGRITY_INDESTRUCTIBLE)
		return
	// todo: newacid
	if((istype(O, /obj/item) || istype(O, /obj/effect/plant)) && (volume > meltdose))
		var/obj/effect/debris/cleanable/molten_item/I = new/obj/effect/debris/cleanable/molten_item(O.loc)
		I.desc = "Looks like this was \an [O] some time ago."
		for(var/mob/M in viewers(5, O))
			to_chat(M, "<span class='warning'>\The [O] melts.</span>")
		qdel(O)
		return . + meltdose

/datum/reagent/sugar
	name = "Sugar"
	id = "sugar"
	description = "The organic compound commonly known as table sugar and sometimes called saccharose. This white, odorless, crystalline powder has a pleasing, sweet taste."
	taste_description = "sugar"
	taste_mult = 1.8
	reagent_state = REAGENT_SOLID
	color = "#FFFFFF"

	glass_name = "sugar"
	glass_desc = "The organic compound commonly known as table sugar and sometimes called saccharose. This white, odorless, crystalline powder has a pleasing, sweet taste."
	glass_icon = DRINK_ICON_NOISY

/datum/reagent/sugar/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	entity.nutrition += removed * 3

	var/effective_dose = metabolism.highest_so_far

	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_UNATHI)])
		if(effective_dose < 2)
			if(effective_dose == metabolism * 2 || prob(5))
				entity.emote("yawn")
		else if(effective_dose < 5)
			entity.eye_blurry = max(entity.eye_blurry, 10)
		else if(effective_dose < 20)
			if(prob(50))
				entity.afflict_paralyze(20 * 2)
			entity.drowsyness = max(entity.drowsyness, 20)
		else
			entity.afflict_sleeping(20 * 20)
			entity.drowsyness = max(entity.drowsyness, 60)

	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_ALRAUNE)]) //cit change - too much sugar isn't good for plants
		if(effective_dose < 2)
			if(prob(5))
				to_chat(entity, "<span class='danger'>You feel an imbalance of energy.</span>")
			entity.make_jittery(4)
