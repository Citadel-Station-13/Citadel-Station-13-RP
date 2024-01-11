/* General medicine */
/datum/reagent/vermicetol//Moved from Chemistry-Reagents-Medicine_vr.dm
	name = "Vermicetol"
	id = "vermicetol"
	description = "A potent chemical that treats physical damage at an exceptional rate."
	taste_description = "heavy metals"
	taste_mult = 3
	reagent_state = REAGENT_SOLID
	color = "#964e06"
	bloodstream_overdose_threshold = REAGENTS_OVERDOSE_MEDICINE * 0.5

/datum/reagent/vermicetol/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		return

	var/chem_effective = 1
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_PROMETHEAN)])
		chem_effective = 0.75

	entity.heal_organ_damage(8 * removed * chem_effective)

/datum/reagent/calciumcarbonate
	name = "calcium carbonate"
	id = "calciumcarbonate"
	description = "Calcium carbonate is a calcium salt commonly used as an antacid."
	taste_description = "chalk"
	reagent_state = REAGENT_SOLID
	color = "#eae6e3"
	ingested_overdose_threshold = REAGENTS_OVERDOSE_MEDICINE * 0.8
	ingested_metabolism_multiplier = 0.4
	ingested_absorption_multiplier = 0

/datum/reagent/calciumcarbonate/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		return
	entity.adjustToxLoss(3 * removed)

/datum/reagent/calciumcarbonate/on_metabolize_ingested(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed, obj/item/organ/internal/container)
	. = ..()
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		return
	entity.add_chemical_effect(CHEMICAL_EFFECT_ANTACID, 3)//Antipuke effect

/datum/reagent/carthatoline
	name = "Carthatoline"
	id = "carthatoline"
	description = "Carthatoline is strong evacuant used to treat severe poisoning."
	reagent_state = REAGENT_LIQUID
	color = "#225722"

/datum/reagent/carthatoline/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		return
	var/mob/living/carbon/M = entity
	if(M.getToxLoss() && prob(10))//if the patient has toxin damage 10% chance to cause vomiting
		M.vomit(1)
	M.adjustToxLoss(-8 * removed)
	if(prob(30))
		M.remove_a_modifier_of_type(/datum/modifier/poisoned)//better chance to remove the poisoned effect
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/liver/L = H.internal_organs_by_name[O_LIVER]
		if(istype(L))
			if(L.robotic >= ORGAN_ROBOT)
				return
			if(L.damage > 0)
				L.heal_damage_i(2 * removed, can_revive = TRUE)
		if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_PROMETHEAN)])
			H.druggy = max(M.druggy, 5)

/datum/reagent/earthsblood
	name = "Earthsblood"
	id = "earthsblood"
	description = "A rare plant extract with immense, almost magical healing capabilities. Induces a potent psychoactive state, damaging neurons with prolonged use."
	taste_description = "the sweet highs of life"
	reagent_state = REAGENT_LIQUID
	color = "#ffb500"
	overdose_threshold = REAGENTS_OVERDOSE_MEDICINE * 0.50


/datum/reagent/earthsblood/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	var/chem_effective = 1
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_ALRAUNE)])
		chem_effective = 1.1 //Plant to Plant Restoration
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		chem_effective = 1.1
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_PROMETHEAN)])
		chem_effective = 0.7 //It just goes right through them ... right onto the floor
	entity.heal_organ_damage (4 * removed * chem_effective, 4 * removed * chem_effective)
	entity.adjustOxyLoss(-10 * removed * chem_effective)
	entity.adjustToxLoss(-4 * removed * chem_effective)
	entity.adjustCloneLoss(-2 * removed * chem_effective)
	entity.druggy = max(entity.druggy, 40)
	entity.adjustBrainLoss(1 * removed) //your life for your mind. The Earthmother's Tithe.
	entity.ceiling_chemical_effect(CHEMICAL_EFFECT_PAINKILLER, 120 * chem_effective) //It's just a burning memory. The pain, I mean.


/* Painkillers */

/datum/reagent/numbing_enzyme//Moved from Chemistry-Reagents-Medicine_vr.dm
	name = "Numbing Enzyme"//Obtained from vore bellies, and numbing bite trait custom species
	id = "numbenzyme"
	description = "Some sort of organic painkiller."
	taste_description = "sourness"
	reagent_state = REAGENT_LIQUID
	color = "#800080"
	bloodstream_metabolism_multiplier = 0.5
	mrate_static = TRUE
	bloodstream_overdose_threshold = 20
	reagent_flags = REAGENT_NO_SYNTH

/datum/reagent/numbing_enzyme/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	entity.max_reagent_cycle_effect(CHEMICAL_EFFECT_PAINKILLER, 200)//Similar to Oxycodone
	if(prob(0.01)) //1 in 10000 chance per tick. Extremely rare.
		to_chat(entity,"<span class='warning'>Your body feels numb as a light, tingly sensation spreads throughout it, like some odd warmth.</span>")
	//Not noted here, but a movement debuff of 1.5 is handed out in human_movement.dm when numbing_enzyme is in a person's bloodstream!

/datum/reagent/numbing_enzyme/overdose(mob/living/carbon/M, alien)
	//..() //Add this if you want it to do toxin damage. Personally, let's allow them to have the horrid effects below without toxin damage.
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(prob(1))
			to_chat(H,"<span class='warning'>Your entire body feels numb and the sensation of pins and needles continually assaults you. You blink and the next thing you know, your legs give out momentarily!</span>")
			H.adjust_paralyzed(20 * 5) //Fall onto the floor for a few moments.
			H.Confuse(15) //Be unable to walk correctly for a bit longer.
		if(prob(1))
			if(H.losebreath <= 1 && H.oxyloss <= 20) //Let's not suffocate them to the point that they pass out.
				to_chat(H,"<span class='warning'>You feel a sharp stabbing pain in your chest and quickly realize that your lungs have stopped functioning!</span>") //Let's scare them a bit.
				H.losebreath = 10
				H.adjustOxyLoss(5)
		if(prob(2))
			to_chat(H,"<span class='warning'>You feel a dull pain behind your eyes and at thee back of your head...</span>")
			H.hallucination += 20 //It messes with your mind for some reason.
			H.eye_blurry += 20 //Groggy vision for a small bit.
		if(prob(3))
			to_chat(H,"<span class='warning'>You shiver, your body continually being assaulted by the sensation of pins and needles.</span>")
			H.emote("shiver")
			H.make_jittery(10)
		if(prob(3))
			to_chat(H,"<span class='warning'>Your tongue feels numb and unresponsive.</span>")
			H.stuttering += 20

/* Other medicine */

/datum/reagent/synaptizine
	name = "Synaptizine"//Used to treat hallucination and remove mindbreaker
	id = "synaptizine"
	description = "Synaptizine is used to treat various diseases."
	taste_description = "bitterness"
	reagent_state = REAGENT_LIQUID
	color = "#99CCFF"
	bloodstream_metabolism_multiplier = 0.05
	overdose_threshold = REAGENTS_OVERDOSE_MEDICINE

/datum/reagent/synaptizine/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	var/chem_effective = 1
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		return
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_PROMETHEAN)])
		if(dose >= 5) //Not effective in small doses, though it causes toxloss at higher ones, it will make the regeneration for brute and burn more 'efficient' at the cost of more nutrition.
			entity.nutrition -= removed * 2
			entity.adjustBruteLoss(-2 * removed)
			entity.adjustFireLoss(-1 * removed)
		chem_effective = 0.5
	entity.drowsyness = max(entity.drowsyness - 5, 0)
	entity.adjust_unconscious(20 * -1)
	entity.adjust_stunned(20 * -1)
	entity.adjust_paralyzed(20 * -1)
	holder.remove_reagent("mindbreaker", 5)
	entity.hallucination = max(0, entity.hallucination - 10)//Primary use
	entity.adjustToxLoss(5 * removed * chem_effective) // It used to be incredibly deadly due to an oversight. Not anymore!
	entity.ceiling_chemical_effect(CHEMICAL_EFFECT_PAINKILLER, 20 * chem_effective)

/datum/reagent/hyperzine
	name = "Hyperzine"
	id = "hyperzine"
	description = "Hyperzine is a highly effective, long lasting, muscle stimulant."
	taste_description = "bitterness"
	bloodstream_metabolism_multiplier = 0.25 // see "long lasting"
	reagent_state = REAGENT_LIQUID
	color = "#FF3300"
	overdose_threshold = REAGENTS_OVERDOSE_MEDICINE * 0.5

/datum/reagent/hyperzine/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_TAJARAN)])
		removed *= 1.25
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_PROMETHEAN)])
		entity.make_jittery(4) //Hyperactive fluid pumping results in unstable 'skeleton', resulting in vibration.
		if(dose >= 5)
			entity.nutrition = (entity.nutrition - (removed * 2)) //Sadly this movement starts burning food in higher doses.
	..()
	if(prob(5))
		entity.emote(pick("twitch", "blink_r", "shiver"))
	entity.add_chemical_effect(CHEMICAL_EFFECT_SPEEDBOOST, 1)

/datum/reagent/alkysine
	name = "Alkysine"
	id = "alkysine"
	description = "Alkysine is a drug used to lessen the damage to neurological tissue after a catastrophic injury. Can heal brain tissue."
	taste_description = "bitterness"
	reagent_state = REAGENT_LIQUID
	color = "#FFFF66"
	bloodstream_metabolism_multiplier = 0.25
	overdose_threshold = REAGENTS_OVERDOSE_MEDICINE

/datum/reagent/alkysine/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		return
	var/chem_effective = 1
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_PROMETHEAN)])
		chem_effective = 0.25
		if(entity.brainloss >= 10)
			entity.afflict_paralyze(20 * 5)
		if(dose >= 10 && entity.is_unconscious())
			entity.adjust_unconscious(20 * 1) //Messing with the core with a simple chemical probably isn't the best idea.
	entity.adjustBrainLoss(-8 * removed * chem_effective) //the Brain damage heal
	entity.ceiling_chemical_effect(CHEMICAL_EFFECT_PAINKILLER, 10 * chem_effective)

/datum/reagent/imidazoline
	name = "Imidazoline"
	id = "imidazoline"
	description = "Heals eye damage"
	taste_description = "dull toxin"
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC"
	overdose_threshold = REAGENTS_OVERDOSE_MEDICINE

/datum/reagent/imidazoline/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	entity.eye_blurry = max(entity.eye_blurry - 5, 0)
	entity.AdjustBlinded(-5)
	if(ishuman(entity))
		var/mob/living/carbon/human/H = entity
		var/obj/item/organ/internal/eyes/E = H.internal_organs_by_name[O_EYES]
		if(istype(E))
			if(E.robotic >= ORGAN_ROBOT)
				return
			if(E.damage > 0)
				E.heal_damage_i(5 * removed, can_revive = TRUE)
			if(E.damage <= 5 && E.organ_tag == O_EYES)
				H.sdisabilities &= ~SDISABILITY_NERVOUS

/datum/reagent/peridaxon
	name = "Peridaxon"
	id = "peridaxon"
	description = "Used to encourage recovery of internal organs and nervous systems. Medicate cautiously."
	taste_description = "bitterness"
	reagent_state = REAGENT_LIQUID
	color = "#561EC3"
	overdose_threshold = 10

/datum/reagent/peridaxon/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	if(ishuman(entity))
		var/mob/living/carbon/human/H = entity
		for(var/obj/item/organ/I in H.internal_organs)
			if(I.robotic >= ORGAN_ROBOT)
				continue
			if(I.damage > 0) //Peridaxon heals only non-robotic organs
				I.heal_damage_i(removed, can_revive = TRUE)
				H.Confuse(5)
			if(I.damage <= 5 && I.organ_tag == O_EYES)
				H.eye_blurry = min(entity.eye_blurry + 10, 100) //Eyes need to reset, or something
				H.sdisabilities &= ~SDISABILITY_NERVOUS
		if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_PROMETHEAN)])
			H.ceiling_chemical_effect(CHEMICAL_EFFECT_PAINKILLER, 20)
			if(prob(33))
				H.Confuse(10)

/datum/reagent/nanoperidaxon
	name = "Nano-Peridaxon"
	id = "nanoperidaxon"
	description = "Nanite cultures have been mixed into this peridaxon, increasing its efficacy range. Medicate cautiously."
	taste_description = "bitterness and iron"
	reagent_state = REAGENT_LIQUID
	color = "#664B9B"
	overdose_threshold = 10

/datum/reagent/nanoperidaxon/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	if(ishuman(entity))
		var/mob/living/carbon/human/H = entity
		for(var/obj/item/organ/I in H.internal_organs)
			if(I.damage > 0)
				I.heal_damage_i(removed, can_revive = TRUE)
				H.Confuse(5)
			if(I.damage <= 5 && I.organ_tag == O_EYES)
				H.eye_blurry = min(entity.eye_blurry + 10, 100) //Eyes need to reset, or something
				H.sdisabilities &= ~SDISABILITY_NERVOUS
		if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_PROMETHEAN)])
			H.ceiling_chemical_effect(CHEMICAL_EFFECT_PAINKILLER, 20)
			if(prob(33))
				H.Confuse(10)

/datum/reagent/osteodaxon
	name = "Osteodaxon"
	id = "osteodaxon"
	description = "An experimental drug used to heal bone fractures."
	reagent_state = REAGENT_LIQUID
	color = "#C9BCE3"
	bloodstream_metabolism_multiplier = 0.5
	overdose_threshold = REAGENTS_OVERDOSE_MEDICINE * 0.5

/datum/reagent/osteodaxon/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		return
	entity.heal_organ_damage(3 * removed, 0)	//Gives the bones a chance to set properly even without other meds
	if(ishuman(entity))
		var/mob/living/carbon/human/H = entity
		for(var/obj/item/organ/external/O in H.bad_external_organs)
			if(O.status & ORGAN_BROKEN)
				O.mend_fracture()		//Only works if the bone won't rebreak, as usual
				H.custom_pain("You feel a terrible agony tear through your bones!",60)
				H.adjust_paralyzed(20 * 1)		//Bones being regrown will knock you over

/datum/reagent/myelamine
	name = "Myelamine"
	id = "myelamine"
	description = "Used to rapidly clot internal hemorrhages by increasing the effectiveness of platelets."
	reagent_state = REAGENT_LIQUID
	color = "#4246C7"
	bloodstream_metabolism_multiplier = 0.5
	overdose_threshold = REAGENTS_OVERDOSE_MEDICINE * 0.5
	var/repair_strength = 3

/datum/reagent/myelamine/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		return
	entity.eye_blurry += min(entity.eye_blurry + (repair_strength * removed), 250)
	if(ishuman(entity))
		var/mob/living/carbon/human/H = entity
		var/wound_heal = removed * repair_strength
		for(var/obj/item/organ/external/O in H.bad_external_organs)
			for(var/datum/wound/W as anything in O.wounds)
				if(W.bleeding())
					W.damage = max(W.damage - wound_heal, 0)
					if(W.damage <= 0)
						O.cure_exact_wound(W)
						continue
				if(W.internal)
					W.damage = max(W.damage - wound_heal, 0)
					if(W.damage <= 0)
						O.cure_exact_wound(W)
						continue

/datum/reagent/respirodaxon
	name = "Respirodaxon"
	id = "respirodaxon"
	description = "Used to repair the tissue of the lungs and similar organs."
	taste_description = "metallic"
	reagent_state = REAGENT_LIQUID
	color = "#4444FF"
	bloodstream_metabolism_multiplier = 1.5
	overdose_threshold = 10

/datum/reagent/respirodaxon/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	var/repair_strength = 1
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_PROMETHEAN)])
		repair_strength = 0.6
	if(ishuman(entity))
		var/mob/living/carbon/human/H = entity
		for(var/obj/item/organ/I in H.internal_organs)
			if(I.robotic >= ORGAN_ROBOT || !(I.organ_tag in list(O_LUNGS, O_VOICE, O_GBLADDER)))
				continue
			if(I.damage > 0)
				I.heal_damage_i(4 * removed * repair_strength, can_revive = TRUE)
				H.Confuse(2)
		if(entity.reagents.has_reagent("gastirodaxon") || entity.reagents.has_reagent("peridaxon"))
			if(H.losebreath >= 15 && prob(H.losebreath))
				H.afflict_stun(20 * 2)
			else
				H.losebreath = clamp(H.losebreath + 3, 0, 20)
		else
			H.losebreath = max(H.losebreath - 4, 0)

/datum/reagent/gastirodaxon
	name = "Gastirodaxon"
	id = "gastirodaxon"
	description = "Used to repair the tissues of the digestive system."
	taste_description = "chalk"
	reagent_state = REAGENT_LIQUID
	color = "#8B4513"
	bloodstream_metabolism_multiplier = 1.5
	overdose_threshold = 10

/datum/reagent/gastirodaxon/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	var/repair_strength = 1
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_PROMETHEAN)])
		repair_strength = 0.6
	if(ishuman(entity))
		var/mob/living/carbon/human/H = entity
		for(var/obj/item/organ/I in H.internal_organs)
			if(I.robotic >= ORGAN_ROBOT || !(I.organ_tag in list(O_APPENDIX, O_STOMACH, O_INTESTINE, O_NUTRIENT, O_PLASMA, O_POLYP)))
				continue
			if(I.damage > 0)
				I.heal_damage_i(4 * removed * repair_strength, can_revive = TRUE)
				H.Confuse(2)
		if(entity.reagents.has_reagent("hepanephrodaxon") || entity.reagents.has_reagent("peridaxon"))
			if(prob(10))
				H.vomit(1)
			else if(H.nutrition > 30)
				H.nutrition = max(0, H.nutrition - round(30 * removed))
		else
			H.adjustToxLoss(-10 * removed) // Carthatoline based, considering cost.

/datum/reagent/hepanephrodaxon
	name = "Hepanephrodaxon"
	id = "hepanephrodaxon"
	description = "Used to repair the common tissues involved in filtration."
	taste_description = "glue"
	reagent_state = REAGENT_LIQUID
	color = "#D2691E"
	bloodstream_metabolism_multiplier = 1.5
	overdose_threshold = 10

/datum/reagent/hepanephrodaxon/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	var/repair_strength = 1
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_PROMETHEAN)])
		repair_strength = 0.4
	if(ishuman(entity))
		var/mob/living/carbon/human/H = entity
		for(var/obj/item/organ/I in H.internal_organs)
			if(I.robotic >= ORGAN_ROBOT || !(I.organ_tag in list(O_LIVER, O_KIDNEYS, O_APPENDIX, O_ACID, O_HIVE)))
				continue
			if(I.damage > 0)
				I.heal_damage_i(4 * removed * repair_strength, can_revive = TRUE)
				H.Confuse(2)
		if(entity.reagents.has_reagent("cordradaxon") || entity.reagents.has_reagent("peridaxon"))
			if(prob(5))
				H.vomit(1)
			else if(prob(5))
				to_chat(H,"<span class='danger'>Something churns inside you.</span>")
				H.adjustToxLoss(10 * removed)
				H.vomit(0, 1)
		else
			H.adjustToxLoss(-12 * removed) // Carthatoline based, considering cost.

/datum/reagent/cordradaxon
	name = "Cordradaxon"
	id = "cordradaxon"
	description = "Used to repair the specialized tissues involved in the circulatory system."
	taste_description = "rust"
	reagent_state = REAGENT_LIQUID
	color = "#FF4444"
	bloodstream_metabolism_multiplier = 1.5
	overdose_threshold = 10

/datum/reagent/cordradaxon/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	var/repair_strength = 1
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_PROMETHEAN)])
		repair_strength = 0.6
	if(ishuman(entity))
		var/mob/living/carbon/human/H = entity
		for(var/obj/item/organ/I in H.internal_organs)
			if(I.robotic >= ORGAN_ROBOT || !(I.organ_tag in list(O_HEART, O_SPLEEN, O_RESPONSE, O_ANCHOR, O_EGG)))
				continue
			if(I.damage > 0)
				I.heal_damage_i(4 * removed * repair_strength, can_revive = TRUE)
				H.Confuse(2)
		if(entity.reagents.has_reagent("respirodaxon") || entity.reagents.has_reagent("peridaxon"))
			H.losebreath = clamp(H.losebreath + 1, 0, 10)
		else
			H.adjustOxyLoss(-30 * removed) // Deals with blood oxygenation.

/datum/reagent/immunosuprizine
	name = "Immunosuprizine"
	id = "immunosuprizine"
	description = "An experimental powder believed to have the ability to prevent any organ rejection."
	taste_description = "flesh"
	reagent_state = REAGENT_SOLID
	color = "#7B4D4F"
	overdose_threshold = 20

/datum/reagent/immunosuprizine/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	var/strength_mod = 1

	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])	// It's a tree.
		strength_mod = 0.25

	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_PROMETHEAN)])	// Diffculty bonding with internal cellular structure.
		strength_mod = 0.75

	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_SKRELL)])	// Natural inclination toward toxins.
		strength_mod = 1.5

	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_UNATHI)])	// Natural regeneration, robust biology.
		strength_mod = 1.75

	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_TAJARAN)])	// Highest metabolism.
		strength_mod = 2

	if(ishuman(entity))
		var/mob/living/carbon/human/H = entity
		if(!entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
			H.adjustToxLoss((30 / strength_mod) * removed)

		var/list/organtotal = list()
		organtotal |= H.organs
		organtotal |= H.internal_organs

		for(var/obj/item/organ/I in organtotal)	// Don't mess with robot bits, they don't reject.
			if(I.robotic >= ORGAN_ROBOT)
				organtotal -= I

		if(dose >= 15)
			for(var/obj/item/organ/I in organtotal)
				if(I.transplant_data && prob(round(15 * strength_mod)))	// Reset the rejection process, toggle it to not reject.
					I.rejecting = 0
					I.can_reject = FALSE

		if(H.reagents_bloodstream.has_reagent("spaceacillin") || H.reagents_bloodstream.has_reagent("corophizine"))	// Chemicals that increase your immune system's aggressiveness make this chemical's job harder.
			for(var/obj/item/organ/I in organtotal)
				if(I.transplant_data)
					var/rejectmem = I.can_reject
					I.can_reject = initial(I.can_reject)
					if(rejectmem != I.can_reject)
						H.adjustToxLoss((15 / strength_mod))
						I.take_damage(1)

/datum/reagent/skrellimmuno
	name = "Malish-Qualem"
	id = "malish-qualem"
	description = "A strange, oily powder used by Malish-Katish to prevent organ rejection."
	taste_description = "mordant"
	reagent_state = REAGENT_SOLID
	color = "#84B2B0"
	bloodstream_metabolism_multiplier = 0.75
	overdose_threshold = 20

/datum/reagent/skrellimmuno/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	var/strength_mod = 0.5

	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_SKRELL)])
		strength_mod = 1

	if(ishuman(entity))
		var/mob/living/carbon/human/H = entity
		if(!entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_SKRELL)])
			H.adjustToxLoss(20 * removed)

		var/list/organtotal = list()
		organtotal |= H.organs
		organtotal |= H.internal_organs

		for(var/obj/item/organ/I in organtotal)	// Don't mess with robot bits, they don't reject.
			if(I.robotic >= ORGAN_ROBOT)
				organtotal -= I

		if(dose >= 15)
			for(var/obj/item/organ/I in organtotal)
				if(I.transplant_data && prob(round(15 * strength_mod)))
					I.rejecting = 0
					I.can_reject = FALSE

		if(H.reagents_bloodstream.has_reagent("spaceacillin") || H.reagents_bloodstream.has_reagent("corophizine"))
			for(var/obj/item/organ/I in organtotal)
				if(I.transplant_data)
					var/rejectmem = I.can_reject
					I.can_reject = initial(I.can_reject)
					if(rejectmem != I.can_reject)
						H.adjustToxLoss((10 / strength_mod))
						I.take_damage(1)

/datum/reagent/ryetalyn
	name = "Ryetalyn"
	id = "ryetalyn"
	description = "Ryetalyn can cure all genetic abnomalities via a catalytic process."
	taste_description = "acid"
	reagent_state = REAGENT_SOLID
	color = "#004000"
	overdose_threshold = REAGENTS_OVERDOSE_MEDICINE

/datum/reagent/ryetalyn/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	var/needs_update = entity.mutations.len > 0

	entity.mutations = list()
	entity.disabilities = 0
	entity.sdisabilities = 0

	var/mob/living/carbon/human/H = entity
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_PROMETHEAN)] && istype(H)) //Shifts them toward white, faster than Rezadone does toward grey.
		if(prob(50))
			if(H.r_skin)
				H.r_skin = round((H.r_skin + 510)/3)
			if(H.r_hair)
				H.r_hair = round((H.r_hair + 510)/3)
			if(H.r_facial)
				H.r_facial = round((H.r_facial + 510)/3)
			H.adjustToxLoss(6 * removed)
		if(prob(50))
			if(H.g_skin)
				H.g_skin = round((H.g_skin + 510)/3)
			if(H.g_hair)
				H.g_hair = round((H.g_hair + 510)/3)
			if(H.g_facial)
				H.g_facial = round((H.g_facial + 510)/3)
			H.adjustToxLoss(6 * removed)
		if(prob(50))
			if(H.b_skin)
				H.b_skin = round((H.b_skin + 510)/3)
			if(H.b_hair)
				H.b_hair = round((H.b_hair + 510)/3)
			if(H.b_facial)
				H.b_facial = round((H.b_facial + 510)/3)
			H.adjustToxLoss(6 * removed)

	// Might need to update appearance for hulk etc.
	if(needs_update && ishuman(entity))
		H.update_mutations()

/datum/reagent/ethylredoxrazine
	name = "Ethylredoxrazine"
	id = "ethylredoxrazine"
	description = "A powerful oxidizer that reacts with ethanol."
	taste_description = "bitterness"
	reagent_state = REAGENT_SOLID
	color = "#605048"
	overdose_threshold = REAGENTS_OVERDOSE_MEDICINE

/datum/reagent/ethylredoxrazine/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		return
	entity.dizziness = 0
	entity.drowsyness = 0
	entity.stuttering = 0
	entity.SetConfused(0)
	if(entity.ingested)
		for(var/datum/reagent/ethanol/R in entity.ingested.reagent_list)
			R.remove_self(removed * 30)
	if(entity.bloodstr)
		for(var/datum/reagent/ethanol/R in entity.bloodstr.reagent_list)
			R.remove_self(removed * 20)

/datum/reagent/hyronalin
	name = "Hyronalin"
	id = "hyronalin"
	description = "Hyronalin is a medicinal drug used to counter the effect of radiation poisoning."
	taste_description = "bitterness"
	reagent_state = REAGENT_LIQUID
	color = "#408000"
	bloodstream_metabolism_multiplier = 0.25
	overdose_threshold = REAGENTS_OVERDOSE_MEDICINE

/datum/reagent/hyronalin/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		return
	entity.cure_radiation(RAD_MOB_CURE_STRENGTH_HYRONALIN(removed))

/datum/reagent/arithrazine
	name = "Arithrazine"
	id = "arithrazine"
	description = "Arithrazine is an unstable medication used for the most extreme cases of radiation poisoning."
	taste_description = "bitterness"
	reagent_state = REAGENT_LIQUID
	color = "#008000"
	bloodstream_metabolism_multiplier = 0.25
	overdose_threshold = REAGENTS_OVERDOSE_MEDICINE

/datum/reagent/arithrazine/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		return
	entity.cure_radiation(RAD_MOB_CURE_STRENGTH_ARITHRAZINE(removed))
	entity.adjustToxLoss(-10 * removed)
	if(prob(60))
		entity.take_organ_damage(4 * removed, 0)

/datum/reagent/spaceacillin
	name = "Spaceacillin"
	id = "spaceacillin"
	description = "An all-purpose antiviral agent."
	taste_description = "bitterness"
	reagent_state = REAGENT_LIQUID
	color = "#C1C1C1"
	bloodstream_metabolism_multiplier = 0.25
	mrate_static = TRUE
	overdose_threshold = REAGENTS_OVERDOSE_MEDICINE
	data = 0

/datum/reagent/spaceacillin/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_PROMETHEAN)])
		if(volume <= 0.1 && data != -1)
			data = -1
			to_chat(entity, "<span class='notice'>You regain focus...</span>")
		else
			var/delay = (5 MINUTES)
			if(world.time > data + delay)
				data = world.time
				to_chat(entity, "<span class='warning'>Your senses feel unfocused, and divided.</span>")
	entity.add_chemical_effect(CHEMICAL_EFFECT_ANTIBIOTIC, dose >= overdose ? ANTIBIO_OD : ANTIBIO_NORM)

/datum/reagent/spaceacillin/affect_touch(mob/living/carbon/M, alien, removed)
	affect_blood(M, alien, removed * 0.8) // Not 100% as effective as injections, though still useful.

/datum/reagent/corophizine
	name = "Corophizine"
	id = "corophizine"
	description = "A wide-spectrum antibiotic drug. Powerful and uncomfortable in equal doses."
	taste_description = "burnt toast"
	reagent_state = REAGENT_LIQUID
	color = "#FFB0B0"
	mrate_static = TRUE
	overdose_threshold = 10
	data = 0

/datum/reagent/corophizine/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	entity.add_chemical_effect(CHEMICAL_EFFECT_ANTIBIOTIC, ANTIBIO_SUPER)

	var/mob/living/carbon/human/H = entity

	if(ishuman(entity) && alien == IS_SLIME) //Everything about them is treated like a targetted organism. Widespread bodily function begins to fail.
		if(volume <= 0.1 && data != -1)
			data = -1
			to_chat(entity, "<span class='notice'>Your body ceases its revolt.</span>")
		else
			var/delay = (3 MINUTES)
			if(world.time > data + delay)
				data = world.time
				to_chat(entity, "<span class='critical'>It feels like your body is revolting!</span>")
		entity.Confuse(7)
		entity.adjustFireLoss(removed * 2)
		entity.adjustToxLoss(removed * 2)
		if(dose >= 5 && entity.toxloss >= 10) //It all starts going wrong.
			entity.adjustBruteLoss(removed * 3)
			entity.eye_blurry = min(20, max(0, entity.eye_blurry + 10))
			if(prob(25))
				if(prob(25))
					to_chat(entity, "<span class='danger'>Your pneumatic fluids seize for a moment.</span>")
				entity.afflict_stun(20 * 2)
				spawn(30)
					entity.afflict_paralyze(20 * 2)
		if(dose >= 10 || entity.toxloss >= 25) //Internal skeletal tubes are rupturing, allowing the chemical to breach them.
			entity.adjustToxLoss(removed * 4)
			entity.make_jittery(5)
		if(dose >= 20 || entity.toxloss >= 60) //Core disentigration, cellular mass begins treating itself as an enemy, while maintaining regeneration. Slime-cancer.
			entity.adjustBrainLoss(2 * removed)
			entity.nutrition = max(H.nutrition - 20, 0)
		if(entity.bruteloss >= 60 && entity.toxloss >= 60 && entity.brainloss >= 30) //Total Structural Failure. Limbs start splattering.
			var/obj/item/organ/external/O = pick(H.organs)
			if(prob(20) && !istype(O, /obj/item/organ/external/chest/unbreakable/slime) && !istype(O, /obj/item/organ/external/groin/unbreakable/slime))
				to_chat(entity, "<span class='critical'>You feel your [O] begin to dissolve, before it sloughs from your body.</span>")
				O.droplimb() //Splat.
		return

	//Based roughly on Levofloxacin's rather severe side-effects
	if(prob(20))
		entity.Confuse(5)
	if(prob(20))
		entity.afflict_paralyze(20 * 5)
	if(prob(20))
		entity.make_dizzy(5)
	if(prob(20))
		entity.hallucination = max(entity.hallucination, 10)

	//One of the levofloxacin side effects is 'spontaneous tendon rupture', which I'll immitate here. 1:1000 chance, so, pretty darn rare.
	if(ishuman(entity) && rand(1,10000) == 1)
		var/obj/item/organ/external/eo = pick(H.organs) //Misleading variable name, 'organs' is only external organs
		eo.fracture()

/datum/reagent/spacomycaze
	name = "Spacomycaze"
	id = "spacomycaze"
	description = "An all-purpose painkilling antibiotic gel."
	taste_description = "oil"
	reagent_state = REAGENT_SOLID
	color = "#C1C1C8"
	bloodstream_metabolism_multiplier = 0.4
	mrate_static = TRUE
	overdose_threshold = REAGENTS_OVERDOSE_MEDICINE
	data = 0
	can_overdose_touch = TRUE

/datum/reagent/spacomycaze/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	entity.ceiling_chemical_effect(CHEMICAL_EFFECT_PAINKILLER, 10)
	entity.adjustToxLoss(3 * removed)

/datum/reagent/spacomycaze/affect_ingest(mob/living/carbon/M, alien, removed)
	affect_blood(M, alien, removed * 0.8)

/datum/reagent/spacomycaze/affect_touch(mob/living/carbon/M, alien, removed)
	..()
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_PROMETHEAN)])
		if(volume <= 0.1 && data != -1)
			data = -1
			to_chat(M, "<span class='notice'>The itching fades...</span>")
		else
			var/delay = (2 MINUTES)
			if(world.time > data + delay)
				data = world.time
				to_chat(M, "<span class='warning'>Your skin itches.</span>")

	M.add_chemical_effect(CHEMICAL_EFFECT_ANTIBIOTIC, dose >= overdose ? ANTIBIO_OD : ANTIBIO_NORM)
	M.ceiling_chemical_effect(CHEMICAL_EFFECT_PAINKILLER, 20) // 5 less than paracetamol.

/datum/reagent/spacomycaze/touch_obj(obj/O)
	if(istype(O, /obj/item/stack/medical/crude_pack) && round(volume) >= 1)
		var/obj/item/stack/medical/crude_pack/C = O
		var/packname = C.name
		var/to_produce = min(C.amount, round(volume))

		var/obj/item/stack/medical/M = C.upgrade_stack(to_produce)

		if(M && M.amount)
			holder.my_atom.visible_message("<span class='notice'>\The [packname] bubbles.</span>")
			remove_self(to_produce)

/datum/reagent/sterilizine
	name = "Sterilizine"
	id = "sterilizine"
	description = "Sterilizes wounds in preparation for surgery and thoroughly removes blood."
	taste_description = "bitterness"
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC"
	touch_met = 5

/datum/reagent/sterilizine/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_PROMETHEAN)])
		entity.adjustFireLoss(removed)
		entity.adjustToxLoss(2 * removed)
	return

/datum/reagent/sterilizine/affect_touch(mob/living/carbon/M, alien, removed)
	M.germ_level -= min(removed*20, M.germ_level)
	for(var/obj/item/I in M.contents)
		I.was_bloodied = null
	M.was_bloodied = null
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_PROMETHEAN)])
		M.adjustFireLoss(removed)
		M.adjustToxLoss(2 * removed)

/datum/reagent/sterilizine/touch_obj(obj/O)
	O.germ_level -= min(volume*20, O.germ_level)
	O.was_bloodied = null

/datum/reagent/sterilizine/touch_turf(turf/T)
	T.germ_level -= min(volume*20, T.germ_level)
	for(var/obj/item/I in T.contents)
		I.was_bloodied = null
	for(var/obj/effect/debris/cleanable/blood/B in T)
		qdel(B)

/datum/reagent/sterilizine/touch_mob(mob/living/L, amount)
	if(istype(L))
		if(istype(L, /mob/living/simple_mob/slime))
			var/mob/living/simple_mob/slime/S = L
			var/amt = rand(15, 25) * amount * (1-S.water_resist)
			if(amt>0)
				S.adjustToxLoss(rand(15, 25) * amount)	// Does more damage than water.
				S.visible_message("<span class='warning'>[S]'s flesh sizzles where the fluid touches it!</span>", "<span class='danger'>Your flesh burns in the fluid!</span>")
		remove_self(amount)

/datum/reagent/leporazine
	name = "Leporazine"
	id = "leporazine"
	description = "Leporazine can be use to stabilize an individuals body temperature."
	taste_description = "bitterness"
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC"
	overdose_threshold = REAGENTS_OVERDOSE_MEDICINE

/datum/reagent/leporazine/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		return
	if(entity.bodytemperature > 310)
		entity.bodytemperature = max(310, entity.bodytemperature - (40 * TEMPERATURE_DAMAGE_COEFFICIENT))
	else if(entity.bodytemperature < 311)
		entity.bodytemperature = min(310, entity.bodytemperature + (40 * TEMPERATURE_DAMAGE_COEFFICIENT))

/datum/reagent/rezadone
	name = "Rezadone"
	id = "rezadone"
	description = "A powder with almost magical properties, this substance can effectively treat genetic damage in humanoids, though excessive consumption has side effects."
	taste_description = "bitterness"
	reagent_state = REAGENT_SOLID
	color = "#669900"
	overdose_threshold = REAGENTS_OVERDOSE_MEDICINE

/datum/reagent/rezadone/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		return
	var/mob/living/carbon/human/H = entity
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_PROMETHEAN)] && istype(H))
		if(prob(50))
			if(H.r_skin)
				H.r_skin = round((H.r_skin + 50)/2)
			if(H.r_hair)
				H.r_hair = round((H.r_hair + 50)/2)
			if(H.r_facial)
				H.r_facial = round((H.r_facial + 50)/2)
		if(prob(50))
			if(H.g_skin)
				H.g_skin = round((H.g_skin + 50)/2)
			if(H.g_hair)
				H.g_hair = round((H.g_hair + 50)/2)
			if(H.g_facial)
				H.g_facial = round((H.g_facial + 50)/2)
		if(prob(50))
			if(H.b_skin)
				H.b_skin = round((H.b_skin + 50)/2)
			if(H.b_hair)
				H.b_hair = round((H.b_hair + 50)/2)
			if(H.b_facial)
				H.b_facial = round((H.b_facial + 50)/2)
	entity.adjustCloneLoss(-20 * removed)
	entity.adjustOxyLoss(-2 * removed)
	entity.heal_organ_damage(20 * removed, 20 * removed)
	entity.adjustToxLoss(-20 * removed)
	if(dose > 10)
		entity.make_dizzy(5)
		entity.make_jittery(5)

/* Antidepressants */

#define ANTIDEPRESSANT_MESSAGE_DELAY 5*60*10

/datum/reagent/methylphenidate
	name = "Methylphenidate"
	id = "methylphenidate"
	description = "Improves the ability to concentrate."
	taste_description = "bitterness"
	reagent_state = REAGENT_LIQUID
	color = "#BF80BF"
	metabolism = 0.01
	ingest_met = 0.25
	mrate_static = TRUE
	data = 0

/datum/reagent/methylphenidate/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		return
	if(volume <= 0.1 && data != -1)
		data = -1
		to_chat(entity, "<span class='warning'>You lose focus...</span>")
	else
		if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
			data = world.time
			to_chat(entity, "<span class='notice'>Your mind feels focused and undivided.</span>")

/datum/reagent/citalopram
	name = "Citalopram"
	id = "citalopram"
	description = "Stabilizes the mind a little."
	taste_description = "bitterness"
	reagent_state = REAGENT_LIQUID
	color = "#FF80FF"
	metabolism = 0.01
	ingest_met = 0.25
	mrate_static = TRUE
	data = 0

/datum/reagent/citalopram/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		return
	if(volume <= 0.1 && data != -1)
		data = -1
		to_chat(entity, "<span class='warning'>Your mind feels a little less stable...</span>")
	else
		if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
			data = world.time
			to_chat(entity, "<span class='notice'>Your mind feels stable... a little stable.</span>")

/datum/reagent/paroxetine
	name = "Paroxetine"
	id = "paroxetine"
	description = "Stabilizes the mind greatly, but has a chance of adverse effects."
	taste_description = "bitterness"
	reagent_state = REAGENT_LIQUID
	color = "#FF80BF"
	metabolism = 0.01
	ingest_met = 0.25
	mrate_static = TRUE
	data = 0

/datum/reagent/paroxetine/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		return
	if(volume <= 0.1 && data != -1)
		data = -1
		to_chat(entity, "<span class='warning'>Your mind feels much less stable...</span>")
	else
		if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
			data = world.time
			if(prob(90))
				to_chat(entity, "<span class='notice'>Your mind feels much more stable.</span>")
			else
				to_chat(entity, "<span class='warning'>Your mind breaks apart...</span>")
				entity.hallucination += 200

/datum/reagent/adranol//Moved from Chemistry-Reagents-Medicine_vr.dm
	name = "Adranol"
	id = "adranol"
	description = "A mild sedative that calms the nerves and relaxes the patient."
	taste_description = "milk"
	reagent_state = REAGENT_SOLID
	color = "#d5e2e5"

/datum/reagent/adranol/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		return
	if(entity.confused)
		entity.Confuse(-8*removed)
	if(entity.eye_blurry)
		entity.eye_blurry = max(entity.eye_blurry - 8*removed, 0)
	if(entity.jitteriness)
		entity.make_jittery(-8 * removed)

/datum/reagent/qerr_quem
	name = "Qerr-quem"
	id = "querr_quem"
	description = "A potent stimulant and anti-anxiety medication, made for the Qerr-Katish."
	taste_description = "mint"
	reagent_state = REAGENT_LIQUID
	color = "#e6efe3"
	metabolism = 0.01
	ingest_met = 0.25
	mrate_static = TRUE
	data = 0

/datum/reagent/qerr_quem/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		return
	if(volume <= 0.1 && data != -1)
		data = -1
		to_chat(entity, "<span class='warning'>You feel antsy, your concentration wavers...</span>")
	else
		if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
			data = world.time
			to_chat(entity, "<span class='notice'>You feel invigorated and calm.</span>")

// This exists to cut the number of chemicals a merc borg has to juggle on their hypo.
/datum/reagent/healing_nanites
	name = "Restorative Nanites"
	id = "healing_nanites"
	description = "Miniature medical robots that swiftly restore bodily damage."
	taste_description = "metal"
	reagent_state = REAGENT_SOLID
	color = "#555555"
	bloodstream_metabolism_multiplier = 4 // Nanomachines gotta go fast.
	scannable = TRUE
	affects_robots = TRUE

/datum/reagent/healing_nanites/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	entity.heal_organ_damage(2 * removed, 2 * removed)
	entity.adjustOxyLoss(-4 * removed)
	entity.adjustToxLoss(-2 * removed)
	entity.adjustCloneLoss(-2 * removed)

////////////////////////// Anti-Noms Drugs //////////////////////////
/datum/reagent/ickypak
	name = "Ickypak"
	id = "ickypak"
	description = "A foul-smelling green liquid, for inducing muscle contractions to expel accidentally ingested things."
	reagent_state = REAGENT_LIQUID
	color = "#0E900E"
	overdose_threshold = REAGENTS_OVERDOSE_MEDICINE

/datum/reagent/ickypak/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	entity.make_dizzy(1)
	entity.adjustHalLoss(2)

	for(var/belly in entity.vore_organs)
		var/obj/belly/B = belly
		for(var/atom/movable/A in B)
			if(isliving(A))
				var/mob/living/P = A
				if(P.absorbed)
					continue
			if(prob(5))
				playsound(entity, 'sound/effects/splat.ogg', 50, 1)
				B.release_specific_contents(A)

/datum/reagent/unsorbitol
	name = "Unsorbitol"
	id = "unsorbitol"
	description = "A frothy pink liquid, for causing cellular-level hetrogenous structure separation."
	reagent_state = REAGENT_LIQUID
	color = "#EF77E5"
	overdose_threshold = REAGENTS_OVERDOSE_MEDICINE

/datum/reagent/unsorbitol/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	entity.make_dizzy(1)
	entity.adjustHalLoss(1)
	if(!entity.confused) entity.confused = 1
	entity.confused = max(entity.confused, 20)
	entity.hallucination += 15

	for(var/belly in entity.vore_organs)
		var/obj/belly/B = belly

		if(B.digest_mode == DM_ABSORB) //Turn off absorbing on bellies
			B.digest_mode = DM_HOLD

		for(var/mob/living/P in B)
			if(!P.absorbed)
				continue

			else if(prob(1))
				playsound(entity, 'sound/vore/schlorp.ogg', 50, 1)
				P.absorbed = 0
				entity.visible_message("<font color='green'><b>Something spills into [entity]'s [lowertext(B.name)]!</b></font>")

//Nif repair juice
/datum/reagent/nif_repair_nanites
	name = "Programmed Nanomachines"
	id = "nifrepairnanites"
	description = "A thick grey slurry of NIF repair nanomachines."
	taste_description = "metallic"
	reagent_state = REAGENT_LIQUID
	color = "#333333"

/datum/reagent/nif_repair_nanites/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	if(ishuman(entity))
		var/mob/living/carbon/human/H = entity
		if(H.nif)
			var/obj/item/nif/nif = H.nif //L o c a l
			if(nif.stat == NIF_TEMPFAIL)
				nif.stat = NIF_INSTALLING
			nif.durability = min(nif.durability + removed, initial(nif.durability))

/datum/reagent/firefighting_foam
	name = "Firefighting Foam"
	id = "firefoam"
	description = "A historical fire suppressant. Originally believed to simply displace oxygen to starve fires, it actually interferes with the combustion reaction itself. Vastly superior to the cheap water-based extinguishers found on most NT vessels."
	reagent_state = REAGENT_LIQUID
	color = "#A6FAFF"
	taste_description = "the inside of a fire extinguisher"

/datum/reagent/firefighting_foam/touch_turf(turf/T, reac_volume)
	if(reac_volume >= 1)
		var/obj/effect/foam/firefighting/F = (locate(/obj/effect/foam/firefighting) in T)
		if(!F)
			F = new(T)
		else if(istype(F))
			F.lifetime = initial(F.lifetime) //reduce object churn a little bit when using smoke by keeping existing foam alive a bit longer

	var/datum/gas_mixture/environment = T.return_air()
	var/min_temperature = T0C + 100 // 100C, the boiling point of water

	var/hotspot = (locate(/atom/movable/fire) in T)
	if(hotspot && !isspaceturf(T))
		var/datum/gas_mixture/lowertemp = T.remove_cell_volume()
		lowertemp.temperature = max(min(lowertemp.temperature-2000, lowertemp.temperature / 2), 0)
		lowertemp.react()
		T.assume_air(lowertemp)
		qdel(hotspot)

	if (environment && environment.temperature > min_temperature) // Abstracted as steam or something
		var/removed_heat = between(0, volume * 19000, -environment.get_thermal_energy_change(min_temperature))
		environment.adjust_thermal_energy(-removed_heat)
		if(prob(5))
			T.visible_message("<span class='warning'>The foam sizzles as it lands on \the [T]!</span>")

/datum/reagent/firefighting_foam/touch_obj(obj/O, reac_volume)
	O.water_act(reac_volume / 5)

/datum/reagent/firefighting_foam/touch_mob(mob/living/M, reac_volume)
	if(istype(M, /mob/living/simple_mob/slime)) //I'm sure foam is water-based!
		var/mob/living/simple_mob/slime/S = M
		var/amt = 15 * reac_volume * (1-S.water_resist)
		if(amt>0)
			S.adjustToxLoss(amt)
			S.visible_message("<span class='warning'>[S]'s flesh sizzles where the foam touches it!</span>", "<span class='danger'>Your flesh burns in the foam!</span>")

	M.adjust_fire_stacks(-reac_volume)
	M.ExtinguishMob()

//CRS (Cyberpsychosis) Medication
/datum/reagent/neuratrextate
	name = "Neuratrextate"
	id = "neuratrextate"
	description = "This military grade chemical compound functions as both a powerful immunosuppressant and a potent antipsychotic. Its trademark lime green coloration makes it easy to identify."
	taste_description = "sour metal"
	taste_mult = 2
	reagent_state = REAGENT_LIQUID
	bloodstream_metabolism_multiplier = 0.016
	mrate_static = TRUE
	color = "#52ca22"
	overdose_threshold = 16

/datum/reagent/neuratrextate/affect_ingest(mob/living/carbon/M)
	remove_self(30)
	to_chat(M, "<span class='warning'>It feels like there's a pile of knives in your stomach!</span>")
	M.druggy += 10
	M.vomit()

/datum/reagent/neuratrextate/overdose(mob/living/carbon/M)
	..()
	M.druggy += 30
	M.hallucination += 20
