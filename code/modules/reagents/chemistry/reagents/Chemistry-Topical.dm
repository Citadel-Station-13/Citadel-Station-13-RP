//topical object, a child of reagent
//topical reagents are meant to be applied via patches from the chemMaster
//They inherent all variables from reagent, but topical isnt directly abstract(although you still should create it if you dont know what you are doing.)
/datum/reagent/topical
	name = "Topical Gel"
	id = "topical"
	description = "A gel meant to be applied to the skin."
	taste_description = "Sourness"
	taste_mult = 2

	dermal_absorption_multiplier = 0
	dermal_overdose_threshold = REAGENTS_OVERDOSE_MEDICINE
	dermal_overdose_toxin_scaling = 0.5

	bloodstream_overdose_threshold = REAGENTS_OVERDOSE_MEDICINE
	bloodstream_overdose_toxin_scaling = 1

	color = "#AAAAFF"//light blue
	color_weight = 1

	var/bloodstream_toxicity = 1//factor of toxin damage dealt by improper application

/datum/reagent/topical/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	if(!entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		entity.adjustToxLoss(bloodstream_toxicity * removed)//if injected cause toxin damage

/datum/reagent/topical/bicarilaze
	name = "Bicarilaze"
	id = "bicarilaze"
	description = "A gel meant to be applied to the skin to heal bruises."
	color = "#FF2223"

	bloodstream_toxicity = 3

/datum/reagent/topical/bicarilaze/on_metabolize_dermal(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed, obj/item/organ/external/bodypart)
	. = ..()
	if(!entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		entity.heal_organ_damage(6*removed,0)//Heal brute damage

/datum/reagent/topical/kelotalaze
	name = "Kelotalaze"
	id = "kelotalaze"
	description = "A gel meant to be applied to the skin to heal burns."
	color = "#FFFF00"

	bloodstream_toxicity = 2

/datum/reagent/topical/kelotalaze/on_metabolize_dermal(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed, obj/item/organ/external/bodypart)
	. = ..()
	if(!entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		entity.heal_organ_damage(0,6*removed)//Heal burns

/datum/reagent/topical/tricoralaze
	name = "Tricoralaze"
	id = "tricoralaze"
	description =  "A gel meant to heal both bruises and burns"

	bloodstream_toxicity = 0

/datum/reagent/topical/tricoralaze/on_metabolize_dermal(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed, obj/item/organ/external/bodypart)
	. = ..()
	if(!entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		entity.heal_organ_damage(3*removed,3*removed)//Heal both damage

/datum/reagent/topical/inaprovalaze
	name = "Inaprovalaze"
	id = "inaprovalaze"
	description = "A gel that stabalises the patient"

	bloodstream_toxicity = 0

/datum/reagent/topical/inaprovalaze/on_metabolize_dermal(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed, obj/item/organ/external/bodypart)
	. = ..()
	if(!entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		entity.add_reagent_cycle_effect(CHEMICAL_EFFECT_STABLE, 20)//Reduces bleeding rate, and allowes the patient to breath even when in shock
		entity.max_reagent_cycle_effect(CHEMICAL_EFFECT_PAINKILLER, 40)
		if(ishuman(entity))
			var/mob/living/carbon/human/H = entity
			for(var/obj/item/organ/external/O in H.bad_external_organs)
				for(var/datum/wound/W as anything in O.wounds)
					if(!W.bleeding())
						continue
					if(W.damage <= 20)//Bleed threshhold is 30
						W.bandaged = 1//act as if bandaged
					else if(W.damage <= 0)// healed wounds can be removed, not sure if this check is still needed as we dont heal with this.
						O.cure_exact_wound(W)
						continue

/datum/reagent/topical/neurolaze
	name = "Neurolaze"
	id = "neurolaze"
	description = "Superficial painkiller, do not inject or ingest"
	dermal_overdose_threshold = REAGENTS_OVERDOSE_MEDICINE * 0.5

	color = "#000000"

	bloodstream_toxicity = 5
	ingested_elimination_multiplier = 4

/datum/reagent/topical/neurolaze/on_metabolize_dermal(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed, obj/item/organ/external/bodypart)
	. = ..()
	if(!entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		entity.max_reagent_cycle_effect(CHEMICAL_EFFECT_PAINKILLER, 100)//Half oxycodone
		entity.make_jittery(50*removed)//Your nerves are itching
		entity.make_dizzy(80*removed)//Screenshake.
		entity.add_reagent_cycle_effect(CHEMICAL_EFFECT_SPEEDBOOST, 1)
		if(prob(5))// Speed boost and emotes
			entity.emote(pick("twitch", "blink_r", "shiver"))
		if(world.time > (data + (60*10)))
			data = world.time
			to_chat(entity, "<span class='warning'>You feel like all your nerves are itching.</span>")

/datum/reagent/topical/neurolaze/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	if(!entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		entity.apply_damage(5 * removed, HALLOSS)//holodeck boxing glove damage
		entity.make_jittery(200)

/datum/reagent/topical/neurolaze/on_metabolize_ingested(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed, obj/item/organ/internal/container)
	. = ..()
	if(!entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		entity.vomit()

/datum/reagent/topical/sterilaze
	name = "Sterilaze"
	id = "sterilaze"
	description = "A gel meant for sterilizing patients wounds."

	bloodstream_toxicity = 3

/datum/reagent/topical/sterilaze/on_metabolize_dermal(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed, obj/item/organ/external/bodypart)
	. = ..()
	if(ishuman(entity))
		var/mob/living/carbon/human/H = entity
		for(var/obj/item/organ/external/O in H.bad_external_organs)
			for(var/datum/wound/W in O.wounds)
				W.disinfected = 1

/datum/reagent/topical/cleansalaze
	name = "Cleansalaze"
	id = "cleansalaze"
	description = "This gel purges radioactive contaminates from the skin"

	bloodstream_toxicity = 1

/datum/reagent/topical/cleansalaze/on_metabolize_dermal(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed, obj/item/organ/external/bodypart)
	. = ..()
	if(!entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		entity.cure_radiation(RAD_MOB_CURE_STRENGTH_CLEANSALAZE(removed))

/datum/reagent/topical/lotion//Because chemistry should have some recreational uses
	name = "Lotion"
	id = "lotion"
	description = "A Lotion to treat your skin and relax alittle."

	bloodstream_toxicity = 0

/datum/reagent/topical/lotion/on_metabolize_dermal(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed, obj/item/organ/external/bodypart)
	. = ..()
	if (!entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		entity.max_reagent_cycle_effect(CHEMICAL_EFFECT_PAINKILLER, 5)//Not really usefull but I guess a lotion would help alittle with pain
		if(world.time > (data + (5*60*10)))
			data = world.time
			to_chat(entity, "<span class='notice'>Your skin feels refreshed and sooth.</span>")

//Remove before merge
/obj/item/storage/box/touch_bottles
	name = "Box of Touch-Medicine"
	desc = "A box with already prepared Medicine for application via touch."
	starts_with = list(
		/obj/item/reagent_containers/glass/bottle/inaprovalaze = 1,
		/obj/item/reagent_containers/glass/bottle/bicarilaze = 1,
		/obj/item/reagent_containers/glass/bottle/kelotalaze = 1,
		/obj/item/reagent_containers/glass/bottle/tricoralaze = 1,
		/obj/item/reagent_containers/glass/bottle/neurolaze = 1,
		/obj/item/reagent_containers/glass/bottle/sterilaze = 1,
		/obj/item/reagent_containers/glass/bottle/cleansalaze = 1,
		/obj/item/reagent_containers/glass/bottle/lotion = 1
	)

/obj/item/reagent_containers/glass/bottle/inaprovalaze
	name = "Inaprovalaze bottle"
	desc = "A small bottle of Inaprovalaze. Do NOT drink."
	icon = 'icons/obj/medical/chemical.dmi'
	icon_state = "bottle-2"
	prefill = list("inaprovalaze" = 60)

/obj/item/reagent_containers/glass/bottle/bicarilaze
	name = "Bicarilaze bottle"
	desc = "A small bottle of Bicarilaze. Do NOT drink."
	icon = 'icons/obj/medical/chemical.dmi'
	icon_state = "bottle-2"
	prefill = list("bicarilaze" = 60)

/obj/item/reagent_containers/glass/bottle/kelotalaze
	name = "Kelotalaze bottle"
	desc = "A small bottle of Kelotalaze. Do NOT drink."
	icon = 'icons/obj/medical/chemical.dmi'
	icon_state = "bottle-2"
	prefill = list("kelotalaze" = 60)

/obj/item/reagent_containers/glass/bottle/tricoralaze
	name = "Tricoralaze bottle"
	desc = "A small bottle of Tricoralaze. Do NOT drink."
	icon = 'icons/obj/medical/chemical.dmi'
	icon_state = "bottle-2"
	prefill = list("tricoralaze" = 60)

/obj/item/reagent_containers/glass/bottle/neurolaze
	name = "Neurolaze bottle"
	desc = "A small bottle of Neurolaze. Do NOT drink."
	icon = 'icons/obj/medical/chemical.dmi'
	icon_state = "bottle-2"
	prefill = list("neurolaze" = 60)

/obj/item/reagent_containers/glass/bottle/sterilaze
	name = "Sterilaze bottle"
	desc = "A small bottle of Sterilaze. Do NOT drink."
	icon = 'icons/obj/medical/chemical.dmi'
	icon_state = "bottle-2"
	prefill = list("sterilaze" = 60)

/obj/item/reagent_containers/glass/bottle/cleansalaze
	name = "Cleansalaze bottle"
	desc = "A small bottle of Cleansalaze. Do NOT drink."
	icon = 'icons/obj/medical/chemical.dmi'
	icon_state = "bottle-2"
	prefill = list("cleansalaze" = 60)

/obj/item/reagent_containers/glass/bottle/lotion
	name = "Lotion bottle"
	desc = "A small bottle of Lotion. Do NOT drink."
	icon = 'icons/obj/medical/chemical.dmi'
	icon_state = "bottle-2"
	prefill = list("lotion" = 60)
