// Various beakers

/datum/design/science/beaker/AssembleDesignName()
	name = "Beaker prototype ([build_name])"

/datum/design/science/beaker/noreact
	name = "cryostasis"
	desc = "A cryostasis beaker that allows for chemical storage without reactions. Can hold up to 50 units."
	identifier = "splitbeaker"
	req_tech = list(TECH_MATERIAL = 2)
	materials = list(MAT_STEEL = 3000)
	build_path = /obj/item/reagent_containers/glass/beaker/noreact

/datum/design/science/beaker/bluespace
	name = TECH_BLUESPACE
	desc = "A bluespace beaker, powered by experimental bluespace technology and Element Cuban combined with the Compound Pete. Can hold up to 300 units."
	identifier = "bluespacebeaker"
	req_tech = list(TECH_BLUESPACE = 2, TECH_MATERIAL = 6)
	materials = list(MAT_STEEL = 3000, MAT_PHORON = 3000, MAT_DIAMOND = 500)
	build_path = /obj/item/reagent_containers/glass/beaker/bluespace
