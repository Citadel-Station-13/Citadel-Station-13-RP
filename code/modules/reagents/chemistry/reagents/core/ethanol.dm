#define ETHANOL_MET_DIVISOR 20

/datum/reagent/ethanol
	name = "Ethanol" //Parent class for all alcoholic reagents.
	id = "ethanol"
	description = "A well-known alcohol with a variety of applications."
	taste_description = "pure alcohol"
	reagent_state = REAGENT_LIQUID
	color = "#404030"

	metabolism_rate = REM/ETHANOL_MET_DIVISOR

	ingest_met = REM * 5

	scannable = TRUE

	var/nutriment_factor = 0
	var/hydration_factor = 0
	var/proof = 200
	var/toxicity = 1

	var/druggy = 0
	var/adj_temp = 0
	var/targ_temp = 310
	var/halluci = 0

	glass_name = "ethanol"
	glass_desc = "A well-known alcohol with a variety of applications."

/datum/reagent/ethanol/on_touch_mob(mob/target, remaining, allocated, data, zone)
	. = ..()
	var/mob/living/L = target
	if(istype(L))
		L.adjust_fire_stacks(allocated / 15)

#define ABV (proof/200)

/datum/reagent/ethanol/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism) //This used to do just toxin. That's boring. Let's make this FUN.
	var/strength_mod = 1 //Alcohol is 3x stronger when injected into the veins.
	if(alien == IS_SKRELL)
		strength_mod *= 5
	if(alien == IS_TAJARA)
		strength_mod *= 1.25
	if(alien == IS_UNATHI)
		strength_mod *= 0.75
	if(alien == IS_DIONA)
		strength_mod = 0
	if(alien == IS_SLIME)
		strength_mod *= 2
	if(alien == IS_ALRAUNE)
		if(prob(5))
			to_chat(M, "<span class='danger'>You feel your leaves start to wilt.</span>")
		strength_mod *=5 //cit change - alcohol ain't good for plants

	var/effective_dose = metabolism.legacy_volume_remaining * strength_mod * ABV * min(1,metabolism.total_processed_dose*(ETHANOL_MET_DIVISOR/10)) // give it 50 ticks to ramp up
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
	if(effect_level != metabolism.blackboard["last-effect-level"])
		var/lowering=(metabolism.blackboard["last-effect-level"]>effect_level)
		metabolism.blackboard["last-effect-level"]=effect_level
		if(lowering)
			switch(effect_level)
				if(0)
					to_chat(M,SPAN_NOTICE("You no longer feel under the influence."))
				if(1)
					to_chat(M,SPAN_DANGER("You are no longer slurring your words as much."))
				if(2)
					to_chat(M,SPAN_DANGER("You're not seeing double anymore."))
				if(3)
					to_chat(M,SPAN_DANGER("You can walk straight again."))
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
					to_chat(M,SPAN_DANGER("You're getting drunk.[hydration_str] Use the Feign Impairment verb if you want slurring."))
				if(3)
					to_chat(M,SPAN_DANGER("You're seeing double![hydration_str]"))
					M.eye_blurry=max(M.eye_blurry,30)
				if(4)
					to_chat(M,SPAN_DANGER("You can barely walk straight![hydration_str]"))
				if(5)
					to_chat(M,SPAN_USERDANGER("You feel like you might puke...[hydration_str]"))
				if(6)
					to_chat(M,SPAN_USERDANGER("Your eyelids feel heavy![hydration_str]"))
				if(7)
					to_chat(M,SPAN_USERDANGER("You are getting dangerously drunk![hydration_str]"))
	var/hydration_removal=(clamp((M.hydration-150)/300,0,1)*effect_level) + max(0,(M.hydration-450)/300)
	var/metabolized = 0
	if(hydration_removal>0)
		M.adjust_hydration(-hydration_removal)
		metabolized += removed*hydration_removal*3
	if(effect_level>=4 && prob(effect_level-2))
		M.Confuse(60)
	if(effect_level>=5 && prob(effect_level-4) && !M.lastpuke)
		M.vomit(1,0)
		if(M.nutrition>=100)
			metabolized += DOSE_LEVEL/4
	if(effect_level>=6 && prob(effect_level-5))
		M.drowsyness=max(M.drowsyness,60)
	if(effect_level>=7)
		M.add_chemical_effect(CE_ALCOHOL_TOXIC, toxicity*strength_mod)
		if(metabolism.legacy_volume_remaining>DOSE_LEVEL*7)
			metabolized += REM // liver working overtime, or whatever (mostly to prevent people from always just dying from this)
	if(metabolized)
		metabolism.legacy_current_holder.remove_reagent(id, metabolized)
	#undef DOSE_LEVEL

/datum/reagent/ethanol/legacy_affect_ingest(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(issmall(M)) removed *= 2
	M.adjust_nutrition(nutriment_factor * removed)
	M.adjust_hydration(hydration_factor * removed)
	M.bloodstr.add_reagent("ethanol", removed * ABV)
	if(druggy != 0)
		M.druggy = max(M.druggy, druggy)

	if(adj_temp > 0 && M.bodytemperature < targ_temp) // 310 is the normal bodytemp. 310.055
		M.bodytemperature = min(targ_temp, M.bodytemperature + (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))
	if(adj_temp < 0 && M.bodytemperature > targ_temp)
		M.bodytemperature = min(targ_temp, M.bodytemperature - (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))

	if(halluci)
		M.setHallucination(max(M.hallucination, halluci))
	return

/datum/reagent/ethanol/on_touch_obj(obj/target, remaining, allocated, data)
	. = ..()

	var/obj/O = target
	if(istype(O, /obj/item/paper))
		var/obj/item/paper/paperaffected = O
		paperaffected.clearpaper()
		to_chat(usr, "The solution dissolves the ink on the paper.")
		return
	if(istype(O, /obj/item/book))
		if(allocated < 5)
			return
		if(istype(O, /obj/item/book/tome))
			to_chat(usr, "<span class='notice'>The solution does nothing. Whatever this is, it isn't normal ink.</span>")
			return
		var/obj/item/book/affectedbook = O
		affectedbook.dat = null
		to_chat(usr, "<span class='notice'>The solution dissolves the ink on the book.</span>")
	return

#undef ABV
