//This file contains miscellaneous recipes that dont fit the other categories
//or categories that are to warrant their own file

/datum/chemical_reaction/mutagen
	name = "Unstable mutagen"
	id = "mutagen"
	result = "mutagen"
	required_reagents = list("radium" = 1, "phosphorus" = 1, "chlorine" = 1)
	result_amount = 3


/datum/chemical_reaction/space_drugs
	name = "Space Drugs"
	id = "space_drugs"
	result = "space_drugs"
	required_reagents = list("mercury" = 1, "sugar" = 1, "lithium" = 1)
	result_amount = 3

/datum/chemical_reaction/lube
	name = "Space Lube"
	id = "lube"
	result = "lube"
	required_reagents = list("water" = 1, "silicon" = 1, "oxygen" = 1)
	result_amount = 4

/datum/chemical_reaction/pacid
	name = "Polytrinic acid"
	id = "pacid"
	result = "pacid"
	required_reagents = list("sacid" = 1, "chlorine" = 1, "potassium" = 1)
	result_amount = 3

/datum/chemical_reaction/water
	name = "Water"
	id = "water"
	result = "water"
	required_reagents = list("oxygen" = 1, "hydrogen" = 2)
	result_amount = 1

/datum/chemical_reaction/thermite
	name = "Thermite"
	id = "thermite"
	result = "thermite"
	required_reagents = list("aluminum" = 1, MAT_IRON = 1, "oxygen" = 1)
	result_amount = 3

/datum/chemical_reaction/silicate
	name = "Silicate"
	id = "silicate"
	result = "silicate"
	required_reagents = list("aluminum" = 1, "silicon" = 1, "oxygen" = 1)
	result_amount = 3


/datum/chemical_reaction/condensedcapsaicin
	name = "Condensed Capsaicin"
	id = "condensedcapsaicin"
	result = "condensedcapsaicin"
	required_reagents = list("capsaicin" = 2)
	catalysts = list(MAT_PHORON = 5)
	result_amount = 1

/datum/chemical_reaction/coolant
	name = "Coolant"
	id = "coolant"
	result = "coolant"
	required_reagents = list("tungsten" = 1, "oxygen" = 1, "water" = 1)
	result_amount = 3

/datum/chemical_reaction/luminol
	name = "Luminol"
	id = "luminol"
	result = "luminol"
	required_reagents = list("hydrogen" = 2, MAT_CARBON = 2, "ammonia" = 2)
	result_amount = 6

/datum/chemical_reaction/surfactant
	name = "Foam surfactant"
	id = "foam surfactant"
	result = "fluorosurfactant"
	required_reagents = list("fluorine" = 2, MAT_CARBON = 2, "sacid" = 1)
	result_amount = 5

/datum/chemical_reaction/ammonia
	name = "Ammonia"
	id = "ammonia"
	result = "ammonia"
	required_reagents = list("hydrogen" = 3, "nitrogen" = 1)
	result_amount = 3

/datum/chemical_reaction/diethylamine
	name = "Diethylamine"
	id = "diethylamine"
	result = "diethylamine"
	required_reagents = list ("ammonia" = 1, "ethanol" = 1)
	result_amount = 2

/datum/chemical_reaction/space_cleaner
	name = "Space cleaner"
	id = "cleaner"
	result = "cleaner"
	required_reagents = list("ammonia" = 1, "water" = 1)
	result_amount = 2

/datum/chemical_reaction/plantbgone
	name = "Plant-B-Gone"
	id = "plantbgone"
	result = "plantbgone"
	required_reagents = list("toxin" = 1, "water" = 4)
	result_amount = 5

/datum/chemical_reaction/pestbgone
	name = "Pest-B-Gone"
	id = "pestbgone"
	result = "pestbgone"
	required_reagents = list("toxin" = 1, "ammonium" = 4)
	result_amount = 5

/datum/chemical_reaction/foaming_agent
	name = "Foaming Agent"
	id = "foaming_agent"
	result = "foaming_agent"
	required_reagents = list("lithium" = 1, "hydrogen" = 1)
	result_amount = 1

/datum/chemical_reaction/glycerol
	name = "Glycerol"
	id = "glycerol"
	result = "glycerol"
	required_reagents = list("cornoil" = 3, "sacid" = 1)
	result_amount = 1

/datum/chemical_reaction/sodiumchloride
	name = "Sodium Chloride"
	id = "sodiumchloride"
	result = "sodiumchloride"
	required_reagents = list("sodium" = 1, "chlorine" = 1)
	result_amount = 2

/datum/chemical_reaction/potassium_chloride
	name = "Potassium Chloride"
	id = "potassium_chloride"
	result = "potassium_chloride"
	required_reagents = list("sodiumchloride" = 1, "potassium" = 1)
	result_amount = 2

/datum/chemical_reaction/potassium_chlorophoride
	name = "Potassium Chlorophoride"
	id = "potassium_chlorophoride"
	result = "potassium_chlorophoride"
	required_reagents = list("potassium_chloride" = 1, MAT_PHORON = 1, "chloralhydrate" = 1)
	result_amount = 4

/datum/chemical_reaction/zombiepowder
	name = "Zombie Powder"
	id = "zombiepowder"
	result = "zombiepowder"
	required_reagents = list("carpotoxin" = 5, "stoxin" = 5, MAT_COPPER = 5)
	result_amount = 2


/datum/chemical_reaction/mindbreaker
	name = "Mindbreaker Toxin"
	id = "mindbreaker"
	result = "mindbreaker"
	required_reagents = list("silicon" = 1, "hydrogen" = 1, "anti_toxin" = 1)
	result_amount = 3

/datum/chemical_reaction/lexorin
	name = "Lexorin"
	id = "lexorin"
	result = "lexorin"
	required_reagents = list(
		/datum/reagent/toxin/phoron = 1,
		/datum/reagent/ammonia = 2,
	)
	result_amount = 3

/* Toxins and neutralisations */
/datum/chemical_reaction/impedrezene
	name = "Impedrezene"
	id = "impedrezene"
	result = "impedrezene"
	required_reagents = list("mercury" = 1, "oxygen" = 1, "sugar" = 1)
	result_amount = 2

/datum/chemical_reaction/carpotoxin
	name = "Carpotoxin"
	id = "carpotoxin"
	result = "carpotoxin"
	required_reagents = list("spidertoxin" = 2, "biomass" = 1, "sifsap" = 2)
	catalysts = list("sifsap" = 10)
	inhibitors = list("radium" = 1)
	result_amount = 2

/datum/chemical_reaction/neurotoxin
	name = "Neurotoxin"
	id = "neurotoxin"
	result = "neurotoxin"
	required_reagents = list("gargleblaster" = 1, "stoxin" = 1)
	result_amount = 2

/datum/chemical_reaction/neutralize_carpotoxin
	name = "Neutralize Carpotoxin"
	id = "carpotoxin_neutral"
	result = "protein"
	required_reagents = list("radium" = 1, "carpotoxin" = 1, "sifsap" = 1)
	catalysts = list("sifsap" = 10)
	result_amount = 2

/datum/chemical_reaction/neutralize_spidertoxin
	name = "Neutralize Spidertoxin"
	id = "spidertoxin_neutral"
	result = "protein"
	required_reagents = list("radium" = 1, "spidertoxin" = 1, "sifsap" = 1)
	catalysts = list("sifsap" = 10)
	result_amount = 2

/datum/chemical_reaction/neutralize_neurotoxic_protein
	name = "Neutralize Toxic Proteins"
	id = "neurotoxic_protein_neutral"
	result = "protein"
	required_reagents = list("anti_toxin" = 1, "neurotoxic_protein" = 2)
	result_amount = 2

/datum/chemical_reaction/hyrdophoron
	name = "Hydrophoron"
	id = "hydrophoron"
	result = "hydrophoron"
	required_reagents = list(
		/datum/reagent/hydrogen = 1,
		/datum/reagent/toxin/phoron = 1,
	)
	result_amount = 2

//Ashlander Chemistry!
/datum/chemical_reaction/alchemybase
	name = "Alchemical Base"
	id = "alchemybase"
	result = "alchemybase"
	required_reagents = list("ash" = 1, "sacid" = 1)
	result_amount = 2

//This reaction creates tallow, just like /datum/chemical_reaction/food/tallow, but by a different vector.
/datum/chemical_reaction/tallow
	name = "Tallow"
	id = "tallow-2"
	result = "tallow"
	required_reagents = list("triglyceride" = 1, "protein" = 1, "alchemybase" = 1)
	result_amount = 3

/datum/chemical_reaction/soap
	name = "Soap"
	id = "soap"
	required_reagents = list("tallow" = 1, "water" = 1, "ash" = 1)

/datum/chemical_reaction/soap/on_reaction_instant(datum/reagent_holder/holder, multiplier)
	. = ..()
	new /obj/item/soap/primitive(get_turf(holder.my_atom))

// todo: why is this a chemical reaction? make a chalkcrafting system or something...

// you know what fuck you; this trips up unit tests. i'm just commenting it out.
// /datum/chemical_reaction/charcoal_stick
// 	name = "Charcoal Stick"
// 	id = "charcoal-stick"
// 	required_reagents = list("tallow" = 1, "alchemybase" = 1)

// /datum/chemical_reaction/charcoal_stick/on_reaction_instant(datum/reagent_holder/holder, multiplier)
// 	. = ..()
// 	new /obj/item/pen/charcoal(get_turf(holder.my_atom))

/datum/chemical_reaction/fertilizer
	name = "Fertilizer"
	id = "fertilizer"
	result = "fertilizer"
	required_reagents = list("tallow" = 1, "ash" = 1, "alchemybase" = 1)
	result_amount = 3

/datum/chemical_reaction/poultice_brute
	name = "Poultice (Juhtak)"
	id = "poulticebrute"
	required_reagents = list("alchemybase" = 1, "bicaridine" = 1)
	require_whole_numbers = TRUE

/datum/chemical_reaction/poultice_brute/on_reaction_instant(datum/reagent_holder/holder, multiplier)
	. = ..()
	new /obj/item/stack/medical/poultice_brute(get_turf(holder.my_atom), multiplier)
	return

/datum/chemical_reaction/poultice_burn
	name = "Poultice (Pyrrhlea)"
	id = "poulticeburn"
	required_reagents = list("alchemybase" = 1, "kelotane" = 1)
	require_whole_numbers = TRUE

/datum/chemical_reaction/poultice_burn/on_reaction_instant(datum/reagent_holder/holder, multiplier)
	. = ..()
	new /obj/item/stack/medical/poultice_burn(get_turf(holder.my_atom), multiplier)

// todo: this is in the way of chemistry dev, why the hell are ashlander recipes in here and not namespaced?
/datum/chemical_reaction/phlogiston
	name = "Phlogiston"
	id = "phlogiston"
	result = "phlogiston"
	required_reagents = list("gunpowder" = 2, "alchemybase" = 1)
	result_amount = 3

/datum/chemical_reaction/condensedphlogiston
	name = "Condensed Phlogiston"
	id = "condensedphlogiston"
	required_reagents = list("phlogiston" = 5, "ash" = 5, "alchemybase" = 3)

/datum/chemical_reaction/condensedphlogiston/on_reaction_instant(datum/reagent_holder/holder, multiplier)
	. = ..()
	for(var/i in 1 to multiplier)
		new /obj/item/condensedphlogiston(get_turf(holder.my_atom))

/datum/chemical_reaction/bitterash
	name = "Bitter Ash"
	id = "bitterash"
	required_reagents = list("nicotine" = 5, "ash" = 5, "alchemybase" = 3)

/datum/chemical_reaction/bitterash/on_reaction_instant(datum/reagent_holder/holder, multiplier)
	. = ..()
	for(var/i in 1 to multiplier)
		new /obj/item/bitterash(get_turf(holder.my_atom))

//Slime related
/datum/chemical_reaction/slimeify
	name = "Advanced Mutation Toxin"
	id = "advmutationtoxin2"
	result = "advmutationtoxin"
	required_reagents = list(MAT_PHORON = 15, "slimejelly" = 15, "mutationtoxin" = 15) //In case a xenobiologist wants to become a fully fledged slime person.
	result_amount = 1

/datum/chemical_reaction/slimejelly //decided to keep this one around, but making it cheaper - making it at xenobiology is the better option still for better yield.
	name = "Slime Jam"
	id = "m_jam"
	result = "slimejelly"
	required_reagents = list(MAT_PHORON = 10, "sugar" = 50, "lithium" = 50)
	result_amount = 5

//Xenochimera revival
// todo: rework this
/datum/chemical_reaction/xenolazarus
	name = "Discount Lazarus"
	id = "discountlazarus"
	required_reagents = list("monstertamer" = 5, "clonexadone" = 5)
	required_container_path = /mob/living/carbon/human

/datum/chemical_reaction/xenolazarus/on_reaction_instant(datum/reagent_holder/holder, multiplier)
	. = ..()
	if(ishuman(holder.my_atom))
		var/mob/living/carbon/human/H = holder.my_atom
		if(H.stat == DEAD && (/mob/living/carbon/human/proc/reconstitute_form in H.verbs)) //no magical regen for non-regenners, and can't force the reaction on live ones
			if(H.hasnutriment()) // make sure it actually has the conditions to revive
				if(H.revive_ready >= 1) // if it's not reviving, start doing so
					H.revive_ready = REVIVING_READY // overrides the normal cooldown
					H.visible_message("<span class='info'>[H] shudders briefly, then relaxes, faint movements stirring within.</span>")
					H.chimera_regenerate()
				else if (/mob/living/carbon/human/proc/hatch in H.verbs)// already reviving, check if they're ready to hatch
					H.chimera_hatch()
					H.visible_message("<span class='danger'><p><font size=4>[H] violently convulses and then bursts open, revealing a new, intact copy in the pool of viscera.</font></p></span>") // Hope you were wearing waterproofs, doc...
					H.adjustBrainLoss(10) // they're reviving from dead, so take 10 brainloss
				else //they're already reviving but haven't hatched. Give a little message to tell them to wait.
					H.visible_message("<span class='info'>[H] stirs faintly, but doesn't appear to be ready to wake up yet.</span>")
			else
				H.visible_message("<span class='info'>[H] twitches for a moment, but remains still.</span>") // no nutriment

/datum/chemical_reaction/gunpowder
	name = "Gunpowder"
	id = "gunpowder"
	result = "gunpowder"
	result_amount = 1
	required_reagents = list("sulfur" = 1, "carbon" = 1, "potassium" = 1)

/datum/chemical_reaction/asbestos
	name = "Asbestos"
	id = "asbestos"
	result = "asbestos"
	result_amount = 3
	required_reagents = list("iron" = 1, "silicon" = 1, "oxygen" = 1)

/datum/chemical_reaction/depolo //Or De-Polonium swaps unremovable polonium for removeable nuclear waste
	name = "Polonium Removal"
	id = "polremove"
	result = "nuclearwaste"
	result_amount = 3
	required_reagents = list(
	"polonium" = 1,
	"nicotine" = 1,
	"arithrazine" = 1
	)

/datum/chemical_reaction/unsuperhol //Neutralizes Superhol making it water
	name = "Superhol Neutralization"
	id = "unsuperhol"
	result = "water"
	result_amount = 1
	required_reagents = list(
	"superhol" = 1,
	"ethylredoxrazine" = 1,
	"hepanephrodaxon" = 1
	)

/datum/chemical_reaction/lessershock //May belong in medicine, in miscellaneous since that is where its product's parent chem 200 V is.
	name = "Lesser Shockchem"
	id = "lessershock"
	result = "lessershock"
	result_amount = 1
	required_reagents = list(
	"phosphorus" = 1,
	"iron" = 1,
	"lithium" = 1,
	"carbon" = 1
	)
