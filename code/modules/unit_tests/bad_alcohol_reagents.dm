/datum/unit_test/accidental_alcoholism/Run()
    var/obj/item/reagent_synth/drink/soda_disp = new
    var/obj/item/reagent_synth/cafe/coff_disp = new
    var/list/soda_reagents = soda_disp.reagents_provided
    var/list/coffee_reagents = coff_disp.reagents_provided
    var/list/checked_reactions = list()
    var/list/open = list()
    for(var/datum/reagent/R as anything in soda_reagents | coffee_reagents)
        open += initial(R.id)
    while(length(open))
        var/top = open[1]
        closed += top
        all += top
        open.Cut(1, 2)
        for(var/datum/chemical_reaction/reaction as anything in reactions_by_reagent[top])
            if(!(reaction in checked_reactions))
                if(!(reaction.result in closed))
                    open += reaction.result
            checked_reactions |= reaction
    for(var/R in all)
        var/datum/reagent/ethanol/E = SSchemistry.reagent_lookup[R]
        if(istype(E))
           Fail("[reagent] is alcoholic but can be made with only soda/coffee dispensers")
