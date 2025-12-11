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
	if(robotic >= ORGAN_ROBOT || (istype(owner) && (owner.species && (owner.species.species_flags & (IS_PLANT | NO_INFECT)))))
		germ_level = 0
		return

	if(owner?.bodytemperature >= 170)	//cryo stops germs from moving and doing their bad stuffs
		//** Handle antibiotics and curing infections
		/obj/item/organ/proc/handle_rejection()

		// infections always start on external limbs
		if(owner.istype(src, /obj/item/organ/external) && owner.getBruteLoss() > 50 || owner.getBurnLoss() > 35)
			handle_infections()

/datum/bacteria/proc/bacteria_roulette(owner, active_infection)


/obj/item/organ/proc/handle_infections()
	if(robotic >= ORGAN_ROBOT)
		return 0

	var/list/active_infection = list()
	if(!owner.infected)
		bacteria_roulette(owner, active_infection)




/obj/item/organ/proc/handle_antibiotics()
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

/obj/item/organ/proc/handle_infections()
	//* Handle the effects of infections
	if(robotic >= ORGAN_ROBOT) //Just in case!
		germ_level = 0
		return 0

	var/antibiotics = iscarbon(owner) ? owner.chem_effects[CE_ANTIBIOTIC] || 0 : 0

	var/infection_damage = 0

	//* Infection damage *//

	//If the organ is dead, for the sake of organs that may have died due to non-infection, we'll only do damage if they have at least L1 infection (built up below)
	if((status & ORGAN_DEAD) && antibiotics < ANTIBIO_OD && germ_level >= INFECTION_LEVEL_ONE)
		infection_damage = max(1, 1 + round((germ_level - INFECTION_LEVEL_THREE)/200,0.25)) //1 Tox plus a little based on germ level

	else if(germ_level > INFECTION_LEVEL_TWO && antibiotics < ANTIBIO_OD)
		infection_damage = max(0.25, 0.25 + round((germ_level - INFECTION_LEVEL_TWO)/200,0.25))

	if(infection_damage)
		owner.adjustToxLoss(infection_damage)

	if (germ_level > 0 && germ_level < INFECTION_LEVEL_ONE/2 && prob(30))
		adjust_germ_level(-antibiotics)

	//* Germ Accumulation

	//Dead organs accumulate germs indefinitely
	if(status & ORGAN_DEAD)
		adjust_germ_level(1)

	//Half of level 1 is growing but harmless
	if (germ_level >= INFECTION_LEVEL_ONE/2)
		//aiming for germ level to go from ambient to INFECTION_LEVEL_TWO in an average of 15 minutes
		if(!antibiotics && prob(round(germ_level/6)))
			adjust_germ_level(1)

	//Level 1 qualifies for specific organ processing effects
	if(germ_level >= INFECTION_LEVEL_ONE)
		. = 1 //Organ qualifies for effect-specific processing
		//var/fever_temperature = (owner.species.heat_level_1 - owner.species.body_temperature - 5)* min(germ_level/INFECTION_LEVEL_TWO, 1) + owner.species.body_temperature
		//owner.bodytemperature += between(0, (fever_temperature - T20C)/BODYTEMP_COLD_DIVISOR + 1, fever_temperature - owner.bodytemperature)
		var/fever_temperature = owner?.species.heat_discomfort_level * 1.10 //Heat discomfort level plus 10%
		if(owner?.bodytemperature < fever_temperature)
			owner?.bodytemperature += min(0.2,(fever_temperature - owner?.bodytemperature) / 10) //Will usually climb by 0.2, else 10% of the difference if less

	//Level two qualifies for further processing effects
	if (germ_level >= INFECTION_LEVEL_TWO)
		. = 2 //Organ qualifies for effect-specific processing
		//No particular effect on the general 'organ' at 3

	//Level three qualifies for significant growth and further effects
	if (germ_level >= INFECTION_LEVEL_THREE && antibiotics < ANTIBIO_OD)
		. = 3 //Organ qualifies for effect-specific processing
		adjust_germ_level(rand(5,10)) //Germ_level increases without overdose of antibiotics


















