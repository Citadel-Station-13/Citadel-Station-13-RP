/datum/unit_test/accidental_alcoholism/Run()
    SSchemistry.initialize_chemical_reactions()
    SSchemistry.initialize_chemical_reagents()
    for(var/datum/chemical_reaction/D as anything in SSchemistry.chemical_reactions)
        var/datum/reagent/ethanol/E = SSchemistry.reagent_lookup[D.result]
        if(istype(E))
            var/any_ethanol = FALSE
            for(var/R in D.required_reagents)
                var/datum/reagent/ethanol/reagent = SSchemistry.reagent_lookup[R]
                if(istype(reagent))
                    any_ethanol=TRUE
            for(var/R in D.catalysts)
                if(R=="enzyme")  // a lot of alcoholic drinks are made with enzyme and some non-alcoholic ingredient
                    any_ethanol=TRUE
                var/datum/reagent/ethanol/reagent = SSchemistry.reagent_lookup[R]
                if(istype(reagent))
                    any_ethanol=TRUE
            if(!any_ethanol)
                Fail("[D.result] is alcoholic but can be made with only non-alcoholic ingredients")
