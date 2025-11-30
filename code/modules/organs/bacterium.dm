//bacterium
/obj/item/organs/bacteria
	name = "bacteria"
	morphology = ""
	group = ""
	germ_level = 0
	var/trait_list[6]
	var/true_traits = list()
	sensitivity = 0 // infectious diseases dont start out resistant to any treatment


	// we add the standard trait names
	trait_list[0] = "Hemolysis Type"
	trait_list[1] = "Glucose Fermentation"
	trait_list[2] = "Lactose Fermentation"
	trait_list[3] = "Motility"
	trait_list[4] = "Oxidase Production"
	trait_list[5] = "Nitrate Reduction"
	trait_list[6] = "Factor X/V Utilization"

	// each bacteria type will have its own true_traits with booleans from 0 to 6 for each trait respectively
	// this will be used by our latter microbiology machines for identification of bacteria types
	// we will try to keep this consistent

/obj/item/organs/bacteria/strep
	morphology = "Streptococcus"
	group = "Gram-Positive, Anaerobic"
	true_traits = (FALSE,FALSE,TRUE,TRUE,FALSE,TRUE,FALSE)

















