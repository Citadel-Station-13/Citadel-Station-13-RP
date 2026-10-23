/datum/infection
	var/datum/bacteria/bacteria
	var/obj/item/organ/owner


//bacterium
/datum/bacteria
	name = "bacteria"
	morphology = ""
	group = ""
	germ_level = 0
	var/trait_list[6]
	var/true_traits = list()
	sensitivity = 0 // infectious diseases dont start out resistant to any treatment
	virulence = 0 // how strong a bacteria can be when causing infections


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

/datum/bacteria/strep
	morphology = "Streptococcus"
	group = "Gram-Positive, Anaerobic"
	true_traits = (FALSE,FALSE,TRUE,TRUE,FALSE,TRUE,FALSE)
	weak_to_antibiotics = list(/datum/antibiotic_class/penicillin::id)
	virulence = 1

/datum/bacteria/ecoli
	morphology = "Escherichia coli"
	group = "Gram-Negative"
	true_traits = (TRUE,FALSE,TRUE,FALSE,FALSE,TRUE,TRUE)
	weak_to_antibiotics = list(/datum/antibiotic_class/amoxicillin::id, /datum/antibiotic_class/penicillin::id)
	virulence = 1.2

/datum/antibiotic_class
	var/id = ""

/datum/antibiotic_class/penicillin
	var/id = "penicillin"

/datum/antibiotic_class/amoxicillin
	var/id = "amoxicillin"

/obj/item/organ/proc/tick_life(dt)
	if(loc != owner)
		stack_trace("organ outside of owner automatically yanked from owner. owner was [owner] ([REF(owner)]), src was [src] ([REF(src)])")
		owner = null
		return

	handle_organ_proc_special()

	//Process infections
//	if(robotic >= ORGAN_ROBOT || (istype(owner) && (owner.species && (owner.species.species_flags & (IS_PLANT | NO_INFECT)))))
//		germ_level = 0
//		return

//	if(owner?.bodytemperature >= 170)	//cryo stops germs from moving and doing their bad stuffs
//		//** Handle antibiotics and curing infections
//		/obj/item/organ/proc/handle_rejection()

		// infections always start on external limbs
		if(owner.istype(src, /obj/item/organ/external) && owner.getBruteLoss() > 50 || owner.getBurnLoss() > 35 || owner.infected)
			handle_infections()


/datum/bacteria/proc/bacteria_roulette(owner, active_infection)
	// more virulent bacteria are less likely to appear
	active_infection["bacteria"] = pick(prob(50); /datum/bacteria/ecoli, prob(100); /datum/bacteria/strep)
	owner.infected = TRUE
	return active_infection


/obj/item/organ/proc/handle_infections()
	if(robotic >= ORGAN_ROBOT)
		return 0
	var/obj/item/organ/owner/active_infection = list()
	// if you left your wounds unattended for 5 minutes, on average, this should fire
	// but you can also be unlucky and eat it early
	if(!owner.infected && prob(0.5**(1/5 MINUTES)))
		bacteria_roulette(owner, active_infection)

	// very simple effects just to demonstrate what this should work like
	// let us assume we have these flags

	var/infection_damage = 0
	var/infection_spread = 1

	infection_damage = max(1, infection_spread*active_infection["bacteria"].virulence, 0.25)

	owner.adjustToxLoss(infection_damage)

	if(prob(0.5**(1 MINUTES))) //does this usually advance every minute? i dont know. do you?
		infection_spread++

// todo: rework antibiotics

/* /obj/item/organ/proc/handle_antibiotics()
	if(istype(owner))
		var/antibiotics = owner.chem_effects[CE_ANTIBIOTIC] || 0

		if (!germ_level || antibiotics < ANTIBIO_NORM)
			return

		// Cure instantly
		if (germ_level < INFECTION_LEVEL_ONE)
			germ_level = 0

		/// At germ_level < 500, this should cure the infection in a minute
		else if (germ_level < INFECTION_LEVEL_TWO)
			adjust_germ_level(-antibiotics*4)

		/// At germ_level < 1000, this will cure the infection in 5 minutes
		else if (germ_level < INFECTION_LEVEL_THREE)
			adjust_germ_level(-antibiotics*2)

		else
			/// You waited this long to get treated, you don't really deserve this organ.
			adjust_germ_level(-antibiotics)
*/
















