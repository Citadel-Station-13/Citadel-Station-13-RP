/datum/unit_test/accidental_alcoholism/Run()
    SSchemistry.initialize_chemical_reactions()
    SSchemistry.initialize_chemical_reagents()
    for(var/datum/chemical_reaction/D as anything in SSchemistry.chemical_reactions)
        if(istype(D,/datum/chemical_reaction/distilling)) // all distilling recipes should be passed, if alcoholic-making
            continue
        if(D.catalysts && D.catalysts.len > 0) // there isn't a catalyzed recipe around as of this writing that makes alcohol erroneously, so...
            continue
        var/datum/reagent/ethanol/E = SSchemistry.reagent_lookup[D.result]
        if(istype(E))
            var/any_ethanol = FALSE
            for(var/R in D.required_reagents)
                var/datum/reagent/reagent = SSchemistry.reagent_lookup[R]
                if(istype(reagent, /datum/reagent/ethanol))
                    any_ethanol=TRUE
                if(istype(reagent, /datum/reagent/toxin)) // anything made from literal toxins is unsafe anyway, we don't care
                    any_ethanol=TRUE
            if(!any_ethanol)
                Fail("[D.result] is alcoholic but can be made with only non-alcoholic ingredients")
