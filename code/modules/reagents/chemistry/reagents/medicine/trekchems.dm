//* star-trek inspired medicines, also known as: "unsorted, but also kinda sorted because it's star trek" *//

/datum/reagent/inaprovaline
	name = "Inaprovaline"
	id = "inaprovaline"
	description = "Inaprovaline is a synaptic stimulant and cardiostimulant. Commonly used to stabilize patients."
	taste_description = "bitterness"
	reagent_state = REAGENT_LIQUID
	color = "#00BFFF"
	bloodstream_overdose_threshold = REAGENTS_OVERDOSE_MEDICINE * 2
	bloodstream_metabolism_multiplier = 0.5

/datum/reagent/inaprovaline/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	if(!entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		entity.add_reagent_cycle_effect(CHEMICAL_EFFECT_STABLE, 15)//Reduces bleeding rate, and allowes the patient to breath even when in shock
		entity.max_reagent_cycle_effect(CHEMICAL_EFFECT_PAINKILLER, 10)

/datum/reagent/bicaridine
	name = "Bicaridine"
	id = "bicaridine"
	description = "Bicaridine is an analgesic medication and can be used to treat blunt trauma."
	taste_description = "bitterness"
	taste_mult = 3
	reagent_state = REAGENT_LIQUID
	color = "#BF0000"
	bloodstream_overdose_threshold = REAGENTS_OVERDOSE_MEDICINE

/datum/reagent/bicaridine/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	var/chem_effective = 1
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_PROMETHEAN)])
		chem_effective = 0.75
	if(!entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		entity.heal_organ_damage(4 * removed * chem_effective, 0) //The first Parameter of the function is brute, the second burn damage

	if(metabolism.overdosing)
		var/mob/living/carbon/M = entity
		var/wound_heal = 1.5 * removed//Overdose enhances the healing effects
		M.eye_blurry = min(M.eye_blurry + wound_heal, 250)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			for(var/obj/item/organ/external/O in H.bad_external_organs)//for-loop that covers all injured external organs
				for(var/datum/wound/W as anything in O.wounds)//for-loop that covers all wounds in the organ we are currently looking at.
					if(W.bleeding() || W.internal)//Checks if the wound is bleeding or internal
						W.damage = max(W.damage - wound_heal, 0)//reduces the damage, and sets it to 0 if its lower than 0
						if(W.damage <= 0)//If the wound is healed,
							O.cure_exact_wound(W)
							continue

/datum/reagent/kelotane
	name = "Kelotane"
	id = "kelotane"
	description = "Kelotane is a drug used to treat burns."
	taste_description = "bitterness"
	reagent_state = REAGENT_LIQUID
	color = "#FFA800"
	bloodstream_overdose_threshold = REAGENTS_OVERDOSE_MEDICINE

/datum/reagent/kelotane/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	var/chem_effective = 1
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_PROMETHEAN)])
		chem_effective = 0.5
		entity.adjustBruteLoss(2 * removed) //Mends burns, but has negative effects with a Promethean's skeletal structure.
	if(!entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		entity.heal_organ_damage(0, 4 * removed * chem_effective)
/datum/reagent/dermaline
	name = "Dermaline"
	id = "dermaline"
	description = "Dermaline is the next step in burn medication. Works twice as good as kelotane and enables the body to restore even the direst heat-damaged tissue."
	taste_description = "bitterness"
	taste_mult = 1.5
	reagent_state = REAGENT_LIQUID
	color = "#FF8000"
	bloodstream_overdose_threshold = REAGENTS_OVERDOSE_MEDICINE * 0.5

/datum/reagent/dermaline/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	var/chem_effective = 1
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_PROMETHEAN)])
		chem_effective = 0.75
	if(!entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		entity.heal_organ_damage(0, 8 * removed * chem_effective)

/datum/reagent/dylovene
	name = "Dylovene"
	id = "anti_toxin"
	description = "Dylovene is a broad-spectrum antitoxin."
	taste_description = "a roll of gauze"
	reagent_state = REAGENT_LIQUID
	color = "#00A000"

/datum/reagent/dylovene/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	var/chem_effective = 1
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_PROMETHEAN)])
		chem_effective = 0.66
		if(metabolism.dose >= 15)
			entity.druggy = max(entity.druggy, 5)
	if(!entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		entity.drowsyness = max(0, entity.drowsyness - 6 * removed * chem_effective)//reduces drowsyness to zero
		entity.hallucination = max(0, entity.hallucination - 9 * removed * chem_effective)//reduces hallucination to 0
		entity.adjustToxLoss(-4 * removed * chem_effective)//Removes toxin damage
		if(prob(10))
			entity.remove_a_modifier_of_type(/datum/modifier/poisoned)//Removes the poisoned effect, which is super rare of its own

/datum/reagent/dexalin
	name = "Dexalin"
	id = "dexalin"
	description = "Dexalin is used in the treatment of oxygen deprivation."
	taste_description = "bitterness"
	reagent_state = REAGENT_LIQUID
	color = "#0080FF"
	bloodstream_overdose_threshold = REAGENTS_OVERDOSE_MEDICINE
	bloodstream_metabolism_multiplier = 0.25

/datum/reagent/dexalin/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_VOX)])
		entity.adjustToxLoss(removed * 24) //Vox breath phoron, oxygen is rather deadly to them
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_ALRAUNE)])
		entity.adjustToxLoss(removed * 10) //cit change: oxygen is waste for plants
	else if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_PROMETHEAN)] && metabolism.dose >= 15)
		entity.max_reagent_cycle_effect(CHEMICAL_EFFECT_PAINKILLER, 15)
		if(prob(15))
			to_chat(entity, "<span class='notice'>You have a moment of clarity as you collapse.</span>")
			entity.adjustBrainLoss(-20 * removed) //Deals braindamage to promethians
			entity.afflict_paralyze(20 * 6)
	else if(!entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		entity.adjustOxyLoss(-60 * removed) //Heals alot of oxyloss damage/but
		//keep in mind that Dexaline has a metabolism rate of 0.25*REM meaning only 0.25 units are removed every tick(if your metabolism takes usuall 1u per tick)

	entity.reagents_bloodstream.remove_reagent(/datum/reagent/lexorin, 8 * removed)

/datum/reagent/dexalinp
	name = "Dexalin Plus"
	id = "dexalinp"
	description = "Dexalin Plus is used in the treatment of oxygen deprivation. It is highly effective."
	taste_description = "bitterness"
	reagent_state = REAGENT_LIQUID
	color = "#0040FF"
	bloodstream_overdose_threshold = REAGENTS_OVERDOSE_MEDICINE * 0.5

/datum/reagent/dexalinp/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_VOX)])
		entity.adjustToxLoss(removed * 9)//Again, vox dont like O2
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_ALRAUNE)])
		entity.adjustToxLoss(removed * 5) //cit change: oxygen is waste for plants
	else if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_PROMETHEAN)] && metabolism.dose >= 10)
		entity.max_reagent_cycle_effect(CHEMICAL_EFFECT_PAINKILLER, 25)
		if(prob(25))
			to_chat(entity, "<span class='notice'>You have a moment of clarity, as you feel your tubes lose pressure rapidly.</span>")
			entity.adjustBrainLoss(-8 * removed)//deals less braindamage than Dex
			entity.afflict_paralyze(20 * 3)
	else if(!entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		entity.adjustOxyLoss(-150 * removed)//Heals more oxyloss than Dex and has no metabolism reduction

	entity.reagents_bloodstream.remove_reagent(/datum/reagent/lexorin, 8 * removed)

/datum/reagent/tricordrazine
	name = "Tricordrazine"
	id = "tricordrazine"
	description = "Tricordrazine is a highly potent stimulant, originally derived from cordrazine. Can be used to treat a wide range of injuries."
	taste_description = "bitterness"
	reagent_state = REAGENT_LIQUID
	color = "#8040FF"

/datum/reagent/tricordrazine/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	if(!entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])//Heals everyone besides diona on all 4 base damage types.
		var/chem_effective = 1
		if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_PROMETHEAN)])
			chem_effective = 0.5
		entity.adjustOxyLoss(-3 * removed * chem_effective)
		entity.heal_organ_damage(1.5 * removed, 1.5 * removed * chem_effective)
		entity.adjustToxLoss(-1.5 * removed * chem_effective)
