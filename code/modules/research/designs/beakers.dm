/datum/prototype/design/science/beaker
	category = DESIGN_CATEGORY_MEDICAL
	abstract_type = /datum/prototype/design/science/beaker

/datum/prototype/design/science/beaker/noreact
	desc = "A cryostasis beaker that allows for chemical storage without reactions. Can hold up to 50 units."
	id = "stasisbeaker"
	req_tech = list(TECH_MATERIAL = 2)
	materials_base = list(MAT_STEEL = 300)
	build_path = /obj/item/reagent_containers/glass/beaker/noreact

/datum/prototype/design/science/beaker/bluespace
	desc = "A bluespace beaker, powered by experimental bluespace technology and Element Cuban combined with the Compound Pete. Can hold up to 300 units."
	id = "bsbeaker"
	req_tech = list(TECH_BLUESPACE = 2, TECH_MATERIAL = 6)
	materials_base = list(MAT_STEEL = 300, MAT_PHORON = 300, MAT_DIAMOND = 250)
	build_path = /obj/item/reagent_containers/glass/beaker/bluespace
