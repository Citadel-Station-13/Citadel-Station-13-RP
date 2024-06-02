#define ETHANOL_MET_DIVISOR 20

/datum/reagent/ethanol
	name = "Ethanol" //Parent class for all alcoholic reagents.
	id = "ethanol"
	description = "A well-known alcohol with a variety of applications."
	taste_description = "pure alcohol"
	reagent_state = REAGENT_LIQUID
	color = "#404030"

	ingested_metabolism_multiplier = 5

	metabolism = REM/ETHANOL_MET_DIVISOR

	var/nutriment_factor = 0
	var/hydration_factor = 0
	var/proof = 200
	var/toxicity = 1

	var/druggy = 0
	var/adj_temp = 0
	var/targ_temp = 310
	var/halluci = 0

	data=0

	glass_name = "ethanol"
	glass_desc = "A well-known alcohol with a variety of applications."

/datum/reagent/ethanol/touch_expose_mob(mob/target, volume, temperature, list/data, organ_tag)
	. = ..()
	var/mob/living/L = target
	if(istype(L))
		L.adjust_fire_stacks(volume / 15)

#define ABV (proof/200)

/datum/reagent/ethanol/affect_blood(mob/living/carbon/M, alien, removed) //This used to do just toxin. That's boring. Let's make this FUN.
	var/strength_mod = 1 //Alcohol is 3x stronger when injected into the veins.
	if(alien == IS_SKRELL)
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

	var/effective_dose = volume * strength_mod * ABV * min(1,dose*(ETHANOL_MET_DIVISOR/10)) // give it 50 ticks to ramp up
	M.add_chemical_effect(CE_ALCOHOL, 1)
	if(HAS_TRAIT(M, TRAIT_ALCOHOL_INTOLERANT))
		if(proof > 0)
			var/intolerant_dose = strength_mod*removed*ABV*10
			if(prob((intolerant_dose)))
				M.add_chemical_effect(CE_ALCOHOL_TOXIC, 1)
			M.adjustToxLoss(intolerant_dose)
		return 0
	#define DOSE_LEVEL 6
	var/effect_level=round(effective_dose/DOSE_LEVEL)
	if(effect_level != data)
		var/lowering=(data>effect_level)
		data=effect_level
		if(lowering)
			switch(effect_level)
				if(0)
					to_chat(M,SPAN_NOTICE("You no longer feel under the influence."))
				if(1)
					to_chat(M,SPAN_DANGER("You are no longer slurring your words as much."))
				if(2)
					to_chat(M,SPAN_DANGER("You can walk straight again."))
				if(3)
					to_chat(M,SPAN_DANGER("You're not seeing double anymore."))
				if(4)
					to_chat(M,SPAN_DANGER("You no longer feel like you're going to puke."))
				if(5)
					to_chat(M,SPAN_DANGER("You don't feel like you're going to pass out anymore."))
				if(6)
					to_chat(M,SPAN_DANGER("You feel like you're out of the danger zone."))
		else
			var/hydration_str=""
			if(M.hydration<250)
				hydration_str=" You're feeling a little dehydrated, too."
			switch(effect_level)
				if(1)
					to_chat(M,SPAN_DANGER("You're starting to feel a little tipsy.[hydration_str]"))
					M.dizziness=max(M.dizziness,150)
				if(2)
					to_chat(M,SPAN_DANGER("You're starting to slur your words.[hydration_str]"))
				if(3)
					to_chat(M,SPAN_DANGER("You can barely walk straight![hydration_str]"))
				if(4)
					to_chat(M,SPAN_DANGER("You're seeing double!.[hydration_str]"))
					M.eye_blurry=max(M.eye_blurry,30)
				if(5)
					to_chat(M,SPAN_USERDANGER("You feel like you might puke...[hydration_str]"))
				if(6)
					to_chat(M,SPAN_USERDANGER("Your eyelids feel heavy![hydration_str]"))
				if(7)
					to_chat(M,SPAN_USERDANGER("You are getting dangerously drunk![hydration_str]"))
	var/hydration_removal=(clamp((M.hydration-150)/300,0,1)*effect_level) + max(0,(M.hydration-450)/300)
	if(hydration_removal>0)
		M.adjust_hydration(-hydration_removal)
		volume-=removed*hydration_removal*3
	if(effect_level>=2)
		M.slurring=max(M.slurring,10)
	if(effect_level>=3 && prob(effect_level-2))
		M.Confuse(60)
	if(effect_level>=5 && prob(effect_level-4) && !M.lastpuke)
		M.vomit(1,0)
		if(M.nutrition>=100)
			volume-=DOSE_LEVEL/4
	if(effect_level>=6 && prob(effect_level-5))
		M.drowsyness=max(M.drowsyness,60)
	if(effect_level>=7)
		M.add_chemical_effect(CE_ALCOHOL_TOXIC, toxicity*strength_mod)
		if(volume>DOSE_LEVEL*7)
			volume-=REM // liver working overtime, or whatever (mostly to prevent people from always just dying from this)
	#undef DOSE_LEVEL
	return

/datum/reagent/ethanol/affect_ingest(mob/living/carbon/M, alien, removed)
	if(issmall(M)) removed *= 2
	M.adjust_nutrition(nutriment_factor * removed)
	M.adjust_hydration(hydration_factor * removed)
	M.bloodstr.add_reagent("ethanol", removed * ABV)
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
	dermal_distribution_multiplier = 0
	var/power = 5
	var/meltdose = 10 // How much is needed to melt

/datum/reagent/acid/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()
	entity.take_random_targeted_damage(brute = 0, brute = removed * power * 2)

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
		M.take_random_targeted_damage(brute = 0, brute = volume * power * 0.2) //burn damage, since it causes chemical burns. Acid doesn't make bones shatter, like brute trauma would.
		return
	if(!M.unacidable && volume > 0)
		if(istype(M, /mob/living/carbon/human) && volume >= meltdose)
			var/mob/living/carbon/human/H = M
			var/obj/item/organ/external/affecting = H.get_organ(BP_HEAD)
			if(affecting)
				affecting.inflict_bodypart_damage(
					burn = volume * power * 0.1,
				)
				if(prob(100 * volume / meltdose)) // Applies disfigurement
					if (affecting.organ_can_feel_pain())
						H.emote("scream")
		else
			M.take_random_targeted_damage(brute = 0, brute = volume * power * 0.1) // Balance. The damage is instant, so it's weaker. 10 units -> 5 damage, double for pacid. 120 units beaker could deal 60, but a) it's burn, which is not as dangerous, b) it's a one-use weapon, c) missing with it will splash it over the ground and d) clothes give some protection, so not everything will hit

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
