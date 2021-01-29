//helper that ensures the reaction rate holds after iterating
//Ex. REACTION_RATE(0.3) means that 30% of the reagents will react each chemistry tick (~2 seconds by default).
#define REACTION_RATE(rate) (1.0 - (1.0-rate)**(1.0/PROCESS_REACTION_ITER))

//helper to define reaction rate in terms of half-life
//Ex.
//HALF_LIFE(0) -> Reaction completes immediately (default chems)
//HALF_LIFE(1) -> Half of the reagents react immediately, the rest over the following ticks.
//HALF_LIFE(2) -> Half of the reagents are consumed after 2 chemistry ticks.
//HALF_LIFE(3) -> Half of the reagents are consumed after 3 chemistry ticks.
#define HALF_LIFE(ticks) (ticks? 1.0 - (0.5)**(1.0/(ticks*PROCESS_REACTION_ITER)) : 1.0)

/datum/chemical_reaction
	var/name = null
	var/id = null
	var/result = null
	var/list/required_reagents = list()
	var/list/catalysts = list()
	var/list/inhibitors = list()
	var/result_amount = 0

	//how far the reaction proceeds each time it is processed. Used with either REACTION_RATE or HALF_LIFE macros.
	var/reaction_rate = HALF_LIFE(0)

	//if less than 1, the reaction will be inhibited if the ratio of products/reagents is too high.
	//0.5 = 50% yield -> reaction will only proceed halfway until products are removed.
	var/yield = 1.0

	//If limits on reaction rate would leave less than this amount of any reagent (adjusted by the reaction ratios),
	//the reaction goes to completion. This is to prevent reactions from going on forever with tiny reagent amounts.
	var/min_reaction = 2

	var/mix_message = "The solution begins to bubble."
	var/reaction_sound = 'sound/effects/bubbles.ogg'

	var/log_is_important = 0 // If this reaction should be considered important for logging. Important recipes message admins when mixed, non-important ones just log to file.

/datum/chemical_reaction/proc/can_happen(var/datum/reagents/holder)
	//check that all the required reagents are present
	if(!holder.has_all_reagents(required_reagents))
		return 0

	//check that all the required catalysts are present in the required amount
	if(!holder.has_all_reagents(catalysts))
		return 0

	//check that none of the inhibitors are present in the required amount
	if(holder.has_any_reagent(inhibitors))
		return 0

	return 1

/datum/chemical_reaction/proc/calc_reaction_progress(var/datum/reagents/holder, var/reaction_limit)
	var/progress = reaction_limit * reaction_rate //simple exponential progression

	//calculate yield
	if(1-yield > 0.001) //if yield ratio is big enough just assume it goes to completion
		/*
			Determine the max amount of product by applying the yield condition:
			(max_product/result_amount) / reaction_limit == yield/(1-yield)

			We make use of the fact that:
			reaction_limit = (holder.get_reagent_amount(reactant) / required_reagents[reactant]) of the limiting reagent.
		*/
		var/yield_ratio = yield/(1-yield)
		var/max_product = yield_ratio * reaction_limit * result_amount //rearrange to obtain max_product
		var/yield_limit = max(0, max_product - holder.get_reagent_amount(result))/result_amount

		progress = min(progress, yield_limit) //apply yield limit

	//apply min reaction progress - wasn't sure if this should go before or after applying yield
	//I guess people can just have their miniscule reactions go to completion regardless of yield.
	for(var/reactant in required_reagents)
		var/remainder = holder.get_reagent_amount(reactant) - progress*required_reagents[reactant]
		if(remainder <= min_reaction*required_reagents[reactant])
			progress = reaction_limit
			break

	return progress

/datum/chemical_reaction/process(var/datum/reagents/holder)
	//determine how far the reaction can proceed
	var/list/reaction_limits = list()
	for(var/reactant in required_reagents)
		reaction_limits += holder.get_reagent_amount(reactant) / required_reagents[reactant]

	//determine how far the reaction proceeds
	var/reaction_limit = min(reaction_limits)
	var/progress_limit = calc_reaction_progress(holder, reaction_limit)

	var/reaction_progress = min(reaction_limit, progress_limit) //no matter what, the reaction progress cannot exceed the stoichiometric limit.

	//need to obtain the new reagent's data before anything is altered
	var/data = send_data(holder, reaction_progress)

	//remove the reactants
	for(var/reactant in required_reagents)
		var/amt_used = required_reagents[reactant] * reaction_progress
		holder.remove_reagent(reactant, amt_used, safety = 1)

	//add the product
	var/amt_produced = result_amount * reaction_progress
	if(result)
		holder.add_reagent(result, amt_produced, data, safety = 1)

	on_reaction(holder, amt_produced)

	return reaction_progress

//called when a reaction processes
/datum/chemical_reaction/proc/on_reaction(var/datum/reagents/holder, var/created_volume)
	return

//called after processing reactions, if they occurred
/datum/chemical_reaction/proc/post_reaction(var/datum/reagents/holder)
	var/atom/container = holder.my_atom
	if(mix_message && container && !ismob(container))
		var/turf/T = get_turf(container)
		var/list/seen = viewers(4, T)
		for(var/mob/M in seen)
			M.show_message("<span class='notice'>\icon[container] [mix_message]</span>", 1)
		playsound(T, reaction_sound, 80, 1)

//obtains any special data that will be provided to the reaction products
//this is called just before reactants are removed.
/datum/chemical_reaction/proc/send_data(var/datum/reagents/holder, var/reaction_limit)
	return null

/* Most medication reactions, and their precursors */

//Standard First Aid Medication

/datum/chemical_reaction/inaprovaline
	//Helps the patient breath in shock, very weak painkiller, and reduces bleeding
	name = "Inaprovaline"
	id = "inaprovaline"
	result = "inaprovaline"
	required_reagents = list("oxygen" = 1, "carbon" = 1, "sugar" = 1)
	result_amount = 3

/datum/chemical_reaction/inaprovaline/topical
	//Goes onto the patient
	name = "Inaprovalaze"
	id = "inaprovalaze"
	result = "inaprovalaze"
	required_reagents = list("inaprovaline" = 2, "sterilizine" = 1, "foaming_agent" = 1) //Main way to obtain is destiller
	result_amount = 2

/datum/chemical_reaction/tricordrazine
	//Heals the four standards slowly
	name = "Tricordrazine"
	id = "tricordrazine"
	result = "tricordrazine"
	required_reagents = list("inaprovaline" = 1, "anti_toxin" = 1)
	result_amount = 2

/datum/chemical_reaction/tricorlidaze
	//Apply onto Patient
	name = "Tricorlidaze"
	id = "tricorlidaze"
	result = "tricorlidaze"
	required_reagents = list("tricordrazine" = 2, "sterilizine" = 1, "foaming_agent" = 1)//Main way to obtain is destiller
	result_amount = 2
/datum/chemical_reaction/dylovene
	//Heals toxin
	name = "Dylovene"
	id = "anti_toxin"
	result = "anti_toxin"
	required_reagents = list("silicon" = 1, "potassium" = 1, "nitrogen" = 1)
	result_amount = 3

/datum/chemical_reaction/carthatoline
	//heals toxin
	name = "Carthatoline"
	id = "carthatoline"
	result = "carthatoline"
	required_reagents = list("anti_toxin" = 1, "carbon" = 2, "phoron" = 0.1)
	catalysts = list("phoron" = 1)
	result_amount = 2

/datum/chemical_reaction/bicaridine
	//heals brute
	name = "Bicaridine"
	id = "bicaridine"
	result = "bicaridine"
	required_reagents = list("inaprovaline" = 1, "carbon" = 1)
	inhibitors = list("sugar" = 1) // Messes up with inaprovaline
	result_amount = 2

/datum/chemical_reaction/bicaridine/topical
	//Apply onto patient
	name = "Bicaridaze"
	id = "bicaridaze"
	result = "bicaridaze"
	required_reagents = list("bicaridine" = 2, "sterilizine" = 1, "foaming_agent" = 1)//Main way to obtain is destiller
	result_amount = 2

/datum/chemical_reaction/vermicetol
	//heals brute
	name = "Vermicetol"
	id = "vermicetol"
	result = "vermicetol"
	required_reagents = list("bicaridine" = 2, "shockchem" = 1, "phoron" = 0.1)
	catalysts = list("phoron" = 5)
	result_amount = 3

/datum/chemical_reaction/kelotane
	//Heals burns
	name = "Kelotane"
	id = "kelotane"
	result = "kelotane"
	required_reagents = list("silicon" = 1, "carbon" = 1)
	result_amount = 2

/datum/chemical_reaction/dermaline
	//Heals burns
	name = "Dermaline"
	id = "dermaline"
	result = "dermaline"
	required_reagents = list("oxygen" = 1, "phosphorus" = 1, "kelotane" = 1)
	result_amount = 3

/datum/chemical_reaction/dermaline/topical
	//Apply onto Patient NOT into
	name = "Dermalaze"
	id = "dermalaze"
	result = "dermalaze"
	required_reagents = list("dermaline" = 2, "sterilizine" = 1, "foaming_agent" = 1)//Main way to obtain is destiller
	result_amount = 2

/datum/chemical_reaction/dexalin
	//fixes oxyloss
	name = "Dexalin"
	id = "dexalin"
	result = "dexalin"
	required_reagents = list("oxygen" = 2, "phoron" = 0.1)
	catalysts = list("phoron" = 1)
	inhibitors = list("water" = 1) // Messes with cryox
	result_amount = 1


/datum/chemical_reaction/dexalinp
	//fixes Oxyloss
	name = "Dexalin Plus"
	id = "dexalinp"
	result = "dexalinp"
	required_reagents = list("dexalin" = 1, "carbon" = 1, "iron" = 1)
	result_amount = 3



//Painkiller

/datum/chemical_reaction/paracetamol
	name = "Paracetamol"
	id = "paracetamol"
	result = "paracetamol"
	required_reagents = list("inaprovaline" = 1, "nitrogen" = 1, "water" = 1)
	result_amount = 2

/datum/chemical_reaction/tramadol
	name = "Tramadol"
	id = "tramadol"
	result = "tramadol"
	required_reagents = list("paracetamol" = 1, "ethanol" = 1, "oxygen" = 1)
	result_amount = 3

/datum/chemical_reaction/oxycodone
	name = "Oxycodone"
	id = "oxycodone"
	result = "oxycodone"
	required_reagents = list("ethanol" = 1, "tramadol" = 1)
	catalysts = list("phoron" = 5)
	result_amount = 1

//Radiation Treatment

/datum/chemical_reaction/hyronalin
	//Calm radiation treatment
	name = "Hyronalin"
	id = "hyronalin"
	result = "hyronalin"
	required_reagents = list("radium" = 1, "anti_toxin" = 1)
	result_amount = 2

/datum/chemical_reaction/arithrazine
	//Angry radiation treatment
	name = "Arithrazine"
	id = "arithrazine"
	result = "arithrazine"
	required_reagents = list("hyronalin" = 1, "hydrogen" = 1)
	result_amount = 2

//The Daxon Family

/datum/chemical_reaction/peridaxon
	//Heals all organs
	name = "Peridaxon"
	id = "peridaxon"
	result = "peridaxon"
	required_reagents = list("bicaridine" = 2, "clonexadone" = 2)
	catalysts = list("phoron" = 5)
	result_amount = 2

/datum/chemical_reaction/osteodaxon
	//Heals bone fractures
	name = "Osteodaxon"
	id = "osteodaxon"
	result = "osteodaxon"
	required_reagents = list("bicaridine" = 2, "phoron" = 0.1, "carpotoxin" = 1)
	catalysts = list("phoron" = 5)
	inhibitors = list("clonexadone" = 1) // Messes with cryox
	result_amount = 2

/datum/chemical_reaction/respirodaxon
	//heals lungs
	name = "Respirodaxon"
	id = "respirodaxon"
	result = "respirodaxon"
	required_reagents = list("dexalinp" = 2, "biomass" = 2, "phoron" = 1)
	catalysts = list("phoron" = 5)
	inhibitors = list("dexalin" = 1)
	result_amount = 2

/datum/chemical_reaction/gastirodaxon
	//Heals stomach
	name = "Gastirodaxon"
	id = "gastirodaxon"
	result = "gastirodaxon"
	required_reagents = list("carthatoline" = 1, "biomass" = 2, "tungsten" = 2)
	catalysts = list("phoron" = 5)
	inhibitors = list("lithium" = 1)
	result_amount = 3

/datum/chemical_reaction/hepanephrodaxon
	//heals liver and kidneys(or species equivalent)
	name = "Hepanephrodaxon"
	id = "hepanephrodaxon"
	result = "hepanephrodaxon"
	required_reagents = list("carthatoline" = 2, "biomass" = 2, "lithium" = 1)
	catalysts = list("phoron" = 5)
	inhibitors = list("tungsten" = 1)
	result_amount = 2

/datum/chemical_reaction/cordradaxon
	//Heals Heart(or species equilvalent)
	name = "Cordradaxon"
	id = "cordradaxon"
	result = "cordradaxon"
	required_reagents = list("potassium_chlorophoride" = 1, "biomass" = 2, "bicaridine" = 2)
	catalysts = list("phoron" = 5)
	inhibitors = list("clonexadone" = 1)
	result_amount = 2

//Psych Drugs and hallucination Treatment

/datum/chemical_reaction/synaptizine
	name = "Synaptizine"
	id = "synaptizine"
	result = "synaptizine"
	required_reagents = list("sugar" = 1, "lithium" = 1, "water" = 1)
	result_amount = 3

/datum/chemical_reaction/methylphenidate
	name = "Methylphenidate"
	id = "methylphenidate"
	result = "methylphenidate"
	required_reagents = list("mindbreaker" = 1, "hydrogen" = 1)
	result_amount = 3

/datum/chemical_reaction/citalopram
	name = "Citalopram"
	id = "citalopram"
	result = "citalopram"
	required_reagents = list("mindbreaker" = 1, "carbon" = 1)
	result_amount = 3

/datum/chemical_reaction/paroxetine
	//Gives you the strength to fight on
	name = "Paroxetine"
	id = "paroxetine"
	result = "paroxetine"
	required_reagents = list("mindbreaker" = 1, "oxygen" = 1, "inaprovaline" = 1)
	result_amount = 3

//Advanced Healing

/datum/chemical_reaction/alkysine
	//Heals brain damage
	name = "Alkysine"
	id = "alkysine"
	result = "alkysine"
	required_reagents = list("chlorine" = 1, "nitrogen" = 1, "anti_toxin" = 1)
	result_amount = 2


/datum/chemical_reaction/myelamine
	//Heals internal bleeding
	name = "Myelamine"
	id = "myelamine"
	result = "myelamine"
	required_reagents = list("bicaridine" = 1, "iron" = 2, "spidertoxin" = 1)
	result_amount = 2

/datum/chemical_reaction/imidazoline
	//Heals the eyes and fixes blindness
	name = "imidazoline"
	id = "imidazoline"
	result = "imidazoline"
	required_reagents = list("carbon" = 1, "hydrogen" = 1, "anti_toxin" = 1)
	result_amount = 2

/datum/chemical_reaction/rezadone
	//Heals clone(20), oxyloss(2), brute,burn&toxin(20) more than 3 units diefigure the patient
	name = "Rezadone"
	id = "rezadone"
	result = "rezadone"
	required_reagents = list("carpotoxin" = 1, "cryptobiolin" = 1, "copper" = 1)
	result_amount = 3

/datum/chemical_reaction/ryetalyn
	//Fixes disabilities(those caused by mutations)
	name = "Ryetalyn"
	id = "ryetalyn"
	result = "ryetalyn"
	required_reagents = list("arithrazine" = 1, "carbon" = 1)
	result_amount = 2

//Immunsystem (Anti-)Boosters
/datum/chemical_reaction/spaceacillin
	//simple antibiotic, no mentionable side effects
	name = "Spaceacillin"
	id = "spaceacillin"
	result = "spaceacillin"
	required_reagents = list("cryptobiolin" = 1, "inaprovaline" = 1)
	result_amount = 2

/datum/chemical_reaction/corophizine
	//sehr potentes antibiotic, has a low chance to break bones
	name = "Corophizine"
	id = "corophizine"
	result = "corophizine"
	required_reagents = list("spaceacillin" = 1, "carbon" = 1, "phoron" = 0.1)
	catalysts = list("phoron" = 5)
	result_amount = 2

/datum/chemical_reaction/immunosuprizine
	//Very toxic substance that prevents Organ rejection after transplanation, not sure why we still need this
	name = "Immunosuprizine"
	id = "immunosuprizine"
	result = "immunosuprizine"
	required_reagents = list("corophizine" = 1, "tungsten" = 1, "sacid" = 1)
	catalysts = list("phoron" = 5)
	result_amount = 2


//Cryo meds

/datum/chemical_reaction/cryoxadone
	//The starter Cryo med, heals all four standard Damages
	name = "Cryoxadone"
	id = "cryoxadone"
	result = "cryoxadone"
	required_reagents = list("dexalin" = 1, "water" = 1, "oxygen" = 1)
	result_amount = 3

/datum/chemical_reaction/clonexadone
	//The advanced Cryo med, same as Cryox but 3 times as potent
	name = "Clonexadone"
	id = "clonexadone"
	result = "clonexadone"
	required_reagents = list("cryoxadone" = 1, "sodium" = 1, "phoron" = 0.1)
	catalysts = list("phoron" = 5)
	result_amount = 2

/datum/chemical_reaction/leporazine
	//not directly a Cryocell medication but help thawn the patient afterwards
	name = "Leporazine"
	id = "leporazine"
	result = "leporazine"
	required_reagents = list("silicon" = 1, "copper" = 1)
	catalysts = list("phoron" = 5)
	result_amount = 2

//Utility chems that are precursors, or have no direct healing properties of their own, but should be found in a medical environment
/datum/chemical_reaction/sterilizine
	name = "Sterilizine"
	id = "sterilizine"
	result = "sterilizine"
	required_reagents = list("ethanol" = 1, "anti_toxin" = 1, "chlorine" = 1)
	result_amount = 3

/datum/chemical_reaction/virus_food
	name = "Virus Food"
	id = "virusfood"
	result = "virusfood"
	required_reagents = list("water" = 1, "milk" = 1)
	result_amount = 5

/datum/chemical_reaction/cryptobiolin
	//Precursor for spaceacillin
	name = "Cryptobiolin"
	id = "cryptobiolin"
	result = "cryptobiolin"
	required_reagents = list("potassium" = 1, "oxygen" = 1, "sugar" = 1)
	result_amount = 3

/datum/chemical_reaction/ethylredoxrazine
	//Helps with alcohol in the blood stream
	name = "Ethylredoxrazine"
	id = "ethylredoxrazine"
	result = "ethylredoxrazine"
	required_reagents = list("oxygen" = 1, "anti_toxin" = 1, "carbon" = 1)
	result_amount = 3

/datum/chemical_reaction/calciumcarbonate
	//prevents people from throwing up
	name = "Calcium Carbonate"
	id = "calciumcarbonate"
	result = "calciumcarbonate"
	required_reagents = list("oxygen" = 3, "calcium" = 1, "carbon" = 1)
	result_amount = 2

/datum/chemical_reaction/soporific
	//Sedative to make people sleepy and keep the sleeping
	name = "Soporific"
	id = "stoxin"
	result = "stoxin"
	required_reagents = list("chloralhydrate" = 1, "sugar" = 4)
	inhibitors = list("phosphorus") // Messes with the smoke
	result_amount = 5

/datum/chemical_reaction/chloralhydrate
	//OD is very toxic, otherwise sedative like soporific
	name = "Chloral Hydrate"
	id = "chloralhydrate"
	result = "chloralhydrate"
	required_reagents = list("ethanol" = 1, "chlorine" = 3, "water" = 1)
	result_amount = 1

/datum/chemical_reaction/lipozine
	//Reduces Nutrients in the patient
	name = "Lipozine"
	id = "Lipozine"
	result = "lipozine"
	required_reagents = list("sodiumchloride" = 1, "ethanol" = 1, "radium" = 1)
	result_amount = 3

/datum/chemical_reaction/adranol
	//Helps with blurry vision, jitters, and confusion
	name = "Adranol"
	id = "adranol"
	result = "adranol"
	required_reagents = list("milk" = 2, "hydrogen" = 1, "potassium" = 1)
	result_amount = 3

/datum/chemical_reaction/biomass
	// Biomass, for cloning and bioprinters
	name = "Biomass"
	id = "biomass"
	result = "biomass"
	required_reagents = list("protein" = 1, "sugar" = 1, "phoron" = 1)
	result_amount = 6	// Roughly 120u per phoron sheet


//Boosters

/datum/chemical_reaction/hyperzine
	//the Proper booster, no direct damage caused by it
	name = "Hyperzine"
	id = "hyperzine"
	result = "hyperzine"
	required_reagents = list("sugar" = 1, "phosphorus" = 1, "sulfur" = 1)
	result_amount = 3

/datum/chemical_reaction/stimm
	//The makeshift booster, inherently toxic
	name = "Stimm"
	id = "stimm"
	result = "stimm"
	required_reagents = list("left4zed" = 1, "fuel" = 1)
	catalysts = list("fuel" = 5)
	result_amount = 2


//Skrellian meds, because we have so many skrells running around.

/datum/chemical_reaction/talum_quem
	name = "Talum-quem"
	id = "talum_quem"
	result = "talum_quem"
	required_reagents = list("space_drugs" = 2, "sugar" = 1, "amatoxin" = 1)
	result_amount = 4

/datum/chemical_reaction/qerr_quem
	name = "Qerr-quem"
	id = "qerr_quem"
	result = "qerr_quem"
	required_reagents = list("nicotine" = 1, "carbon" = 1, "sugar" = 2)
	result_amount = 4

/datum/chemical_reaction/malish_qualem
	name = "Malish-Qualem"
	id = "malish-qualem"
	result = "malish-qualem"
	required_reagents = list("immunosuprizine" = 1, "qerr_quem" = 1, "inaprovaline" = 1)
	catalysts = list("phoron" = 5)
	result_amount = 2

//Vore - Medication
/datum/chemical_reaction/ickypak
	name = "Ickypak"
	id = "ickypak"
	result = "ickypak"
	required_reagents = list("hyperzine" = 4, "fluorosurfactant" = 1)
	result_amount = 5

/datum/chemical_reaction/unsorbitol
	name = "Unsorbitol"
	id = "unsorbitol"
	result = "unsorbitol"
	required_reagents = list("mutagen" = 3, "lipozine" = 2)
	result_amount = 5








