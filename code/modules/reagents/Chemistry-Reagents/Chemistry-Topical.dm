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
        if(prob(10))//If ingested, either throw up
            M.vomit(1)
        else//or half the reagent passes through into blood(rest is filtered off) and alittle bit affects the inner skin
            affect_blood(M, alien, removed/2)
            affect_touch(M, alien, removed/10)
    
/datum/reagent/topical/affect_touch(mob/living/carbon/M, alien, removed)
    . = ..()//do healy stuff here
    