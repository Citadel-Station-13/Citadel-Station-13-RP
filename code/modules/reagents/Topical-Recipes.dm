//Recipes for the topical gels, mostly they are simple mixtures, distiller recipes may follow
/datum/chemical_reaction/topical
    name = "Topical Gel"
    id = "topical"
    result = "topical"
    required_reagents = list("sterilizine" = 5, "foaming_agent" = 5)
    catalysts = list("tungsten" = 5)
    result_amount = 2//Shitty amounts because you should use the distiller

/datum/chemical_reaction/distilling/topical //distiller recipe.
	name = "Distilling topical"
	id = "distill_topical"
	result = "topical"
	required_reagents = list("sterilizine" = 1, "foaming_agent" = 1)
	result_amount = 1

	reaction_rate = HALF_LIFE(10)

	temp_range = list(T0C + 100, T0C + 120)


/datum/chemical_reaction/topical/bicarilaze
    name = "Bicarilaze"
    id = "bicarilaze"
    result = "bicarilaze"
    required_reagents = list("topical" = 1, "bicaridine" = 2)
    catalysts = list()
    result_amount = 2

/datum/chemical_reaction/topical/kelotalaze
    name = "Kelotalaze"
    id = "kelotalaze"
    result = "kelotalaze"
    required_reagents = list("topical" = 1, "kelotane" = 2)
    catalysts = list()
    result_amount = 2

/datum/chemical_reaction/topical/tricoralaze
    name = "Tricoralaze"
    id = "tricoralaze"
    result = "tricoralaze"
    required_reagents = list("topical" = 1, "tricordrazine" = 2)
    catalysts = list()
    result_amount = 2

/datum/chemical_reaction/inaprovalaze
    name = "Inaprovalaze"
    id = "inaprovalaze"
    result = "inaprovalaze"
    required_reagents = list("topical" = 1, "inaprovaline" = 2)
    catalysts = list()
    result_amount = 2

/datum/chemical_reaction/topical/neurolaze
    name = "Neurolaze"
    id = "neurolaze"
    result = "neurolaze"
    required_reagents = list("topical" = 1, "oxycodone" = 1, "hyperzine" = 1)
    catalysts = list(MAT_PHORON = 5)
    result_amount = 2

/datum/chemical_reaction/topical/sterilaze
    name = "Sterilaze"
    id = "sterilaze"
    result = "sterilaze"
    required_reagents = list("topical" = 1, "sterilizine" = 2)
    catalysts = list("ethanol" = 5)//To prevent it from forming during the initial creation of topical
    result_amount = 2

/datum/chemical_reaction/topical/cleansalaze
    name = "Cleansalaze"
    id = "cleansalaze"
    result = "cleansalaze"
    required_reagents = list("topical" = 1, "hyronalin" = 2)
    catalysts = list()
    result_amount = 2

/datum/chemical_reaction/topical/lotion
    name = "Lotion"
    id = "lotion"
    result = "lotion"
    required_reagents = list("topical" = 1,"milk" = 1, "honey" = 1)
    catalysts = list("milk" = 5)
    result_amount = 5//Its not really helpfull and more meant for people to feel nice...
