/datum/chemical_reaction/dylovene
	name = "Dylovene"
	id = "anti_toxin"
	result = /datum/reagent/dylovene
	required_reagents = list(
		/datum/reagent/silicon = 1,
		/datum/reagent/potassium = 1,
		/datum/reagent/nitrogen = 1,
	)
	result_amount = 3

/datum/chemical_reaction/inaprovaline
	name = "Inaprovaline"
	id = "inaprovaline"
	result = /datum/reagent/inaprovaline
	required_reagents = list(
		/datum/reagent/oxygen = 1,
		/datum/reagent/carbon = 1,
		/datum/reagent/sugar = 1,
	)
	result_amount = 3
	priority = 50

/datum/chemical_reaction/tricordrazine
	name = "Tricordrazine"
	id = "tricordrazine"
	result = /datum/reagent/tricordrazine
	required_reagents = list(
		/datum/reagent/inaprovaline = 1,
		/datum/reagent/dylovene = 1,
	)
	result_amount = 2

/datum/chemical_reaction/peridaxon
	name = "Peridaxon"
	id = "peridaxon"
	result = /datum/reagent/peridaxon
	required_reagents = list(
		/datum/reagent/bicaridine = 2,
		/datum/reagent/clonexadone = 2,
	)
	catalysts = list(
		/datum/reagent/toxin/phoron = 5,
	)
	result_amount = 2
	priority = 100
