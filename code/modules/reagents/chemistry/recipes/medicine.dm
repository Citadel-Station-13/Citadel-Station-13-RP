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

/datum/chemical_reaction/tricordrazine
	name = "Tricordrazine"
	id = "tricordrazine"
	result = /datum/reagent/tricordrazine
	required_reagents = list(
		/datum/reagent/inaprovaline = 1,
		/datum/reagent/tricordrazine = 1,
	)
	result_amount = 2
