//* Pharmaceutical painkillers go in here *//

/datum/reagent/paracetamol
	name = "Paracetamol"
	id = "paracetamol"
	description = "Most probably know this as Tylenol, but this chemical is a mild, simple painkiller."
	taste_description = "bitterness"
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC"
	overdose_threshold = 60
	metabolism = 0.02
	mrate_static = TRUE

/datum/reagent/paracetamol/affect_blood(mob/living/carbon/M, alien, removed)
	var/chem_effective = 1
	if(alien == IS_SLIME)
		chem_effective = 0.75
	M.ceiling_chemical_effect(CHEMICAL_EFFECT_PAINKILLER, 25 * chem_effective)//kinda weak painkilling, for non life threatening injuries

/datum/reagent/paracetamol/overdose(mob/living/carbon/M, alien)
	..()
	if(alien == IS_SLIME)
		M.add_chemical_effect(CHEMICAL_EFFECT_SLOWDOWN, 1)
	M.hallucination = max(M.hallucination, 2)

/datum/reagent/tramadol
	name = "Tramadol"
	id = "tramadol"
	description = "A simple, yet effective painkiller."
	taste_description = "sourness"
	reagent_state = REAGENT_LIQUID
	color = "#CB68FC"
	overdose_threshold = 30
	metabolism = 0.02
	mrate_static = TRUE

/datum/reagent/tramadol/affect_blood(mob/living/carbon/M, alien, removed)
	var/chem_effective = 1
	if(alien == IS_SLIME)
		chem_effective = 0.8
		M.add_chemical_effect(CHEMICAL_EFFECT_SLOWDOWN, 1)
	M.ceiling_chemical_effect(CHEMICAL_EFFECT_PAINKILLER, 80 * chem_effective)//more potent painkilling, for close to fatal injuries

/datum/reagent/tramadol/overdose(mob/living/carbon/M, alien)
	..()
	M.hallucination = max(M.hallucination, 2)

/datum/reagent/oxycodone
	name = "Oxycodone"
	id = "oxycodone"
	description = "An effective and very addictive painkiller."
	taste_description = "bitterness"
	reagent_state = REAGENT_LIQUID
	color = "#800080"
	overdose_threshold = 20
	metabolism = 0.02
	mrate_static = TRUE

/datum/reagent/oxycodone/affect_blood(mob/living/carbon/M, alien, removed)
	var/chem_effective = 1
	if(alien == IS_SLIME)
		chem_effective = 0.75
		M.stuttering = min(50, max(0, M.stuttering + 5)) //If you can't feel yourself, and your main mode of speech is resonation, there's a problem.
	M.ceiling_chemical_effect(CHEMICAL_EFFECT_PAINKILLER, 200 * chem_effective)//Bad boy painkiller, for you and the fact that she left you
	M.add_chemical_effect(CHEMICAL_EFFECT_SLOWDOWN, 1)
	M.eye_blurry = min(M.eye_blurry + 10, 250 * chem_effective)

/datum/reagent/oxycodone/overdose(mob/living/carbon/M, alien)
	..()
	M.druggy = max(M.druggy, 10)
	M.hallucination = max(M.hallucination, 3)
