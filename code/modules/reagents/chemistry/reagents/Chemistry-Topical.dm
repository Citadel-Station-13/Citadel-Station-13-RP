//topical object, a child of reagent
//topical reagents are meant to be applied via patches from the chemMaster
//They inherent all variables from reagent, but topical isnt directly abstract(although you still should create it if you dont know what you are doing.)
/datum/reagent/topical
    name = "Topical Gel"
    id = "topical"
    description = "A gel meant to be applied to the skin."
    taste_description = "Sourness"
    taste_mult = 2

    metabolism = REM / 2//The skin is not directly connected to any filter organs so reagents are removed much slower

    overdose = REAGENTS_OVERDOSE //Usually we want topicals to overdose just as other chems do.
    overdose_mod = 0.5 // deals little damage on overdose, because the chem should only be applied via touch.
    can_overdose_touch = TRUE // They should only be applied on touch

    color = "#AAAAFF"//light blue
    color_weight = 1

    var/toxicity = 1//factor of toxin damage dealt by improper application

/datum/reagent/topical/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		M.adjustToxLoss(toxicity * removed)//if injected cause toxin damage

/datum/reagent/topical/affect_ingest(mob/living/carbon/M, alien, removed)
    if(alien != IS_DIONA)
        if(prob(10) && toxicity)//If ingested, either throw up
            M.vomit(1)
        else//or half the reagent passes through into blood(rest is filtered off) and alittle bit affects the inner skin
            affect_blood(M, alien, removed/2)
            affect_touch(M, alien, removed/10)

/datum/reagent/topical/affect_touch(mob/living/carbon/M, alien, removed)
    M.add_chemical_effect(CE_PAINKILLER, 1)//just so there is something here...

/datum/reagent/topical/bicarilaze
    name = "Bicarilaze"
    id = "bicarilaze"
    description = "A gel meant to be applied to the skin to heal bruises."
    color = "#FF2223"

    toxicity = 3

/datum/reagent/topical/bicarilaze/affect_touch(mob/living/carbon/M, alien, removed)
    if(alien != IS_DIONA)
        M.heal_organ_damage(6*removed,0)//Heal brute damage

/datum/reagent/topical/kelotalaze
    name = "Kelotalaze"
    id = "kelotalaze"
    description = "A gel meant to be applied to the skin to heal burns."
    color = "#FFFF00"

    toxicity = 2

/datum/reagent/topical/kelotalaze/affect_touch(mob/living/carbon/M, alien, removed)
    if(alien != IS_DIONA)
        M.heal_organ_damage(0,6*removed)//Heal burns

/datum/reagent/topical/tricoralaze
    name = "Tricoralaze"
    id = "tricoralaze"
    description =  "A gel meant to heal both bruises and burns"

    toxicity = 0

/datum/reagent/topical/tricoralaze/affect_touch(mob/living/carbon/M, alien, removed)
    if(alien != IS_DIONA)
        M.heal_organ_damage(3*removed,3*removed)//Heal both damage

/datum/reagent/topical/inaprovalaze
    name = "Inaprovalaze"
    id = "inaprovalaze"
    description = "A gel that stabalises the patient"

    toxicity = 0

/datum/reagent/topical/inaprovalaze/affect_touch(mob/living/carbon/M, alien, removed)
    if(alien != IS_DIONA)
        M.add_chemical_effect(CE_STABLE, 20)//Reduces bleeding rate, and allowes the patient to breath even when in shock
        M.add_chemical_effect(CE_PAINKILLER, 40)
        if(ishuman(M))
            var/mob/living/carbon/human/H = M
            for(var/obj/item/organ/external/O in H.bad_external_organs)
                for(var/datum/wound/W in O.wounds)
                    if(W.bleeding())
                        if(W.damage <= 20)//Bleed threshhold is 30
                            W.bandaged = 1//act as if bandaged
                        else if(W.damage <= 0)// healed wounds can be removed, not sure if this check is still needed as we dont heal with this.
                            O.wounds -= W

/datum/reagent/topical/neurolaze
    name = "Neurolaze"
    id = "neurolaze"
    description = "Superficial painkiller, do not inject or ingest"
    metabolism = REM * 2 //Nervocells absorb this chem super fast so much faster metabolism...
    overdose = REAGENTS_OVERDOSE * 0.5

    color = "#000000"

    toxicity = 5

/datum/reagent/topical/neurolaze/affect_touch(mob/living/carbon/M, alien, removed)
    if(alien != IS_DIONA)
        M.add_chemical_effect(CE_PAINKILLER, 100)//Half oxycodone
        M.make_jittery(50*removed)//Your nerves are itching
        M.make_dizzy(80*removed)//Screenshake.
        M.add_chemical_effect(CE_SPEEDBOOST, 1)
        if(prob(5))// Speed boost and emotes
            M.emote(pick("twitch", "blink_r", "shiver"))
        if(world.time > (data + (60*10)))
            data = world.time
            to_chat(M, "<span class='warning'>You feel like all your nerves are itching.</span>")

/datum/reagent/topical/neurolaze/affect_blood(mob/living/carbon/M, alien, removed)
    if(alien != IS_DIONA)
        M.apply_damage(5 * removed, HALLOSS)//holodeck boxing glove damage
        M.make_jittery(200)

/datum/reagent/topical/neurolaze/affect_ingest(mob/living/carbon/M, alien, removed)
    if(alien != IS_DIONA)
        M.vomit()
        holder.remove_reagent("neurolaze", 10 * removed)//purges itself...

/datum/reagent/topical/neurolaze/overdose(var/mob/living/carbon/M, var/alien)
    if(alien != IS_DIONA)
        M.adjustBrainLoss(0.1)//deals braindamage on overdose

/datum/reagent/topical/sterilaze
    name = "Sterilaze"
    id = "sterilaze"
    description = "A gel meant for sterilizing patients wounds."

    toxicity = 3

/datum/reagent/topical/sterilaze/affect_touch(mob/living/carbon/M, alien, removed)
    if(ishuman(M))
        var/mob/living/carbon/human/H = M
        for(var/obj/item/organ/external/O in H.bad_external_organs)
            for(var/datum/wound/W in O.wounds)
                W.disinfected = 1

/datum/reagent/topical/cleansalaze
    name = "Cleansalaze"
    id = "cleansalaze"
    description = "This gel purges radioactive contaminates from the skin"

    toxicity = 1

/datum/reagent/topical/cleansalaze/affect_touch(mob/living/carbon/M, alien, removed)
    if(alien != IS_DIONA)
        M.radiation = max(M.radiation - 15 * removed, 0)//Half as potent as hyroaline

/datum/reagent/topical/lotion//Because chemistry should have some recreational uses
    name = "Lotion"
    id = "lotion"
    description = "A Lotion to treat your skin and relax alittle."

    toxicity = 0

/datum/reagent/topical/lotion/affect_touch(mob/living/carbon/M, alien, removed)
    if (alien != IS_DIONA)
        M.add_chemical_effect(CE_PAINKILLER, 5)//Not really usefull but I guess a lotion would help alittle with pain
        if(world.time > (data + (5*60*10)))
            data = world.time
            to_chat(M, "<span class='notice'>Your skin feels refreshed and sooth.</span>")

//Remove before merge
/obj/item/storage/box/touch_bottles
	name = "Box of Touch-Medicine"
	desc = "A box with already prepared Medicine for application via touch."
	starts_with = list(/obj/item/reagent_containers/glass/bottle/inaprovalaze = 1,
                        /obj/item/reagent_containers/glass/bottle/bicarilaze = 1,
                        /obj/item/reagent_containers/glass/bottle/kelotalaze = 1,
                        /obj/item/reagent_containers/glass/bottle/tricoralaze = 1,
                        /obj/item/reagent_containers/glass/bottle/neurolaze = 1,
                        /obj/item/reagent_containers/glass/bottle/sterilaze = 1,
                        /obj/item/reagent_containers/glass/bottle/cleansalaze = 1,
                        /obj/item/reagent_containers/glass/bottle/lotion = 1)

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
