/* Things that didn't fit anywhere else */

/datum/reagent/adrenaline
	name = "Adrenaline"
	id = "adrenaline"
	description = "Adrenaline is a hormone used as a drug to treat cardiac arrest and other cardiac dysrhythmias resulting in diminished or absent cardiac output."
	taste_description = "bitterness"
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC"
	mrate_static = TRUE

/datum/reagent/adrenaline/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(alien == IS_DIONA)
		return
	M.set_unconscious(0)
	M.set_paralyzed(0)
	M.adjustToxLoss(rand(3))


/datum/reagent/ammonia
	name = "Ammonia"
	id = "ammonia"
	description = "A caustic substance commonly used in fertilizer or household cleaners."
	taste_description = "mordant"
	taste_mult = 2
	reagent_state = REAGENT_GAS
	color = "#404030"

/datum/reagent/ammonia/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(alien == IS_ALRAUNE)
		M.nutrition += removed * 2 //cit change: fertilizer is waste for plants
		return

/datum/reagent/diethylamine
	name = "Diethylamine"
	id = "diethylamine"
	description = "A secondary amine, mildly corrosive."
	taste_description = "iron"
	reagent_state = REAGENT_LIQUID
	color = "#604030"

/datum/reagent/diethylamine/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(alien == IS_ALRAUNE)
		M.nutrition += removed * 5 //cit change: fertilizer is waste for plants
		return

/datum/reagent/fluorosurfactant // Foam precursor
	name = "Fluorosurfactant"
	id = "fluorosurfactant"
	description = "A perfluoronated sulfonic acid that forms a foam when mixed with water."
	taste_description = "metal"
	reagent_state = REAGENT_LIQUID
	color = "#9E6B38"

/datum/reagent/foaming_agent // Metal foaming agent. This is lithium hydride. Add other recipes (e.g. LiH + H2O -> LiOH + H2) eventually.
	name = "Foaming agent"
	id = "foaming_agent"
	description = "A agent that yields metallic foam when mixed with light metal and a strong acid."
	taste_description = "metal"
	reagent_state = REAGENT_SOLID
	color = "#664B63"

/datum/reagent/lube // TODO: spraying on borgs speeds them up
	name = "Space Lube"
	id = "lube"
	description = "Lubricant is a substance introduced between two moving surfaces to reduce the friction and wear between them. giggity."
	taste_description = "slime"
	reagent_state = REAGENT_LIQUID
	color = "#009CA8"

/datum/reagent/lube/on_touch_turf(turf/target, remaining, allocated, data)
	. = ..()
	if(!istype(target, /turf/simulated))
		return
	var/turf/simulated/T = target
	if(allocated >= 1)
		T.wet_floor(2)

/datum/reagent/silicate
	name = "Silicate"
	id = "silicate"
	description = "A compound that can be used to reinforce glass."
	taste_description = "plastic"
	reagent_state = REAGENT_LIQUID
	color = "#C7FFFF"

/datum/reagent/silicate/on_touch_obj(obj/target, remaining, allocated, data)
	. = ..()
	if(istype(target, /obj/structure/window))
		var/obj/structure/window/W = target
		W.apply_silicate(allocated)
		. = max(., allocated)

/datum/reagent/glycerol
	name = "Glycerol"
	id = "glycerol"
	description = "Glycerol is a simple polyol compound. Glycerol is sweet-tasting and of low toxicity."
	taste_description = "sweetness"
	reagent_state = REAGENT_LIQUID
	color = "#808080"

/datum/reagent/nitroglycerin
	name = "Nitroglycerin"
	id = "nitroglycerin"
	description = "Nitroglycerin is a heavy, colorless, oily, explosive liquid obtained by nitrating glycerol."
	taste_description = "oil"
	reagent_state = REAGENT_LIQUID
	color = "#808080"

/datum/reagent/coolant
	name = "Coolant"
	id = "coolant"
	description = "Industrial cooling substance."
	taste_description = "sourness"
	taste_mult = 1.1
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC"
	affects_robots = TRUE

/datum/reagent/ultraglue
	name = "Ultra Glue"
	id = "glue"
	description = "An extremely powerful bonding agent."
	taste_description = "a special education class"
	color = "#FFFFCC"

/datum/reagent/woodpulp
	name = "Wood Pulp"
	id = "woodpulp"
	description = "A mass of wood fibers."
	taste_description = "wood"
	reagent_state = REAGENT_LIQUID
	color = "#B97A57"

/datum/reagent/nutriment/biomass
	name = "Biomass"
	id = "biomass"
	description = "A slurry of compounds that contains the basic requirements for life."
	taste_description = "salty meat"
	reagent_state = REAGENT_LIQUID
	color = "#DF9FBF"

// The opposite to healing nanites, exists to make unidentified hypos implied to have nanites not be 100% safe.
/datum/reagent/defective_nanites
	name = "Defective Nanites"
	id = "defective_nanites"
	description = "Miniature medical robots that are malfunctioning and cause bodily harm. Fortunately, they cannot self-replicate."
	taste_description = "metal"
	reagent_state = REAGENT_SOLID
	color = "#333333"
	metabolism_rate = REM * 3 // Broken nanomachines go a bit slower.
	scannable = 1

/datum/reagent/defective_nanites/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	M.take_random_targeted_damage(brute = 2 * removed, brute = 2 * removed)
	M.adjustOxyLoss(4 * removed)
	M.adjustToxLoss(2 * removed)
	M.adjustCloneLoss(2 * removed)

/datum/reagent/fishbait
	name = "Fish Bait"
	id = "fishbait"
	description = "A natural slurry that particularily appeals to fish."
	taste_description = "earthy"
	reagent_state = REAGENT_LIQUID
	color = "#62764E"

/datum/reagent/crude_oil
	name = "Oil"
	id = "oil"
	description = "Burns in a small smoky fire, mostly used to get Ash."
	reagent_state = REAGENT_LIQUID
	color = "#292929"
	taste_description = "oil"

/datum/reagent/ash_powder
	name = "Ash"
	id = "ash"
	description = "Supposedly phoenixes rise from these, but you've never seen it."
	reagent_state = REAGENT_LIQUID
	color = "#665c56"
	taste_description = "ash"

/datum/reagent/gunpowder
	name = "Gunpowder"
	id = "gunpowder"
	description = "A primitive explosive chemical."
	reagent_state = REAGENT_SOLID
	color = "#464650"
	taste_description = "salt"

/datum/reagent/galena
	name = "Galena"
	id = "galena"
	description = "Powdered unprocessed lead."
	reagent_state = REAGENT_SOLID
	color = "#273956"
	taste_description = "metal"

/datum/reagent/hematite
	name = "Hematite"
	id = "hematite"
	description = "Powdered unprocessed iron. It's mostly iron oxide."
	reagent_state = REAGENT_SOLID
	color = "#353535"
	taste_description = "rust"

/datum/reagent/uraninite
	name = "Uraninite"
	id = "uraninite"
	description = "Powdered unprocessed uranium."
	reagent_state = REAGENT_SOLID
	color = "#B8B8C0"
	taste_description = "metal"

/datum/reagent/uraninite/legacy_affect_touch(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	legacy_affect_ingest(M, alien, removed, metabolism)

/datum/reagent/uraninite/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	M.apply_effect(5 * removed, IRRADIATE, 0)

/datum/reagent/phoronite
	name = "Phoronite"
	id = "phoronite"
	description = "Powdered unprocessed phoron. The crystals haven't been forced into their reactive form."
	reagent_state = REAGENT_SOLID
	color = "#9D14DB"
	taste_description = "tingly sand"

/datum/reagent/hydronite
	name = "Hydronite"
	id = "hydronite"
	description = "Powdered unprocessed metallic hydrogen."
	reagent_state = REAGENT_SOLID
	color = "#808080"
	taste_mult = 0

//Ashlander Alchemy!
/datum/reagent/alchemybase
	name = "Alchemical Base"
	id = "alchemybase"
	description = "A compound of ash and sulphuric acid, used on Surt as a base for alchemical processes."
	reagent_state = REAGENT_LIQUID
	color = "#5a5e3c"
	taste_description = "sour ash"

/datum/reagent/phlogiston
	name = "Phlogiston"
	id = "phlogiston"
	description = "A solution of gunpowder and alchemical base, reduced into a sticky tar. It is immensely volatile."
	reagent_state = REAGENT_LIQUID
	color = "#522222"
	taste_description = "sulphurous sand"

/datum/reagent/bitterash
	name = "Bitter Ash"
	id = "bitterash"
	description = "A finely granulated mixture of ash and pokalea, rendered into a pungent slurry by alchemical base."
	reagent_state = REAGENT_SOLID
	color = "#302f2f"
	taste_description = "sour wax and sulphur"

/datum/reagent/bentarjuice
	name = "Bentar Juice"
	id = "bentarjuice"
	description = "The sickly sweet juice of the bentar plant."
	reagent_state = REAGENT_LIQUID
	color = "#9d23aa"
	taste_description = "sweetness with a medicinal aftertaste"

/datum/reagent/bentarjuice/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	var/chem_effective = 1
	if(alien == IS_SLIME)
		chem_effective = 0.75
	if(alien != IS_DIONA)
		M.adjustToxLoss(-2 * removed * chem_effective)// Herbal Dylovene. Heals less toxin and loses other benefits.

/datum/reagent/cersutpaste
	name = "Cersut Paste"
	id = "cersutpaste"
	description = "Ground up paste of a cersut leaf. It's highly acidic."
	reagent_state = REAGENT_LIQUID
	color = "#e0f569"
	taste_description = "your tongue melting and teeth falling out"

/datum/reagent/cersutpaste/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(alien == IS_XENOHYBRID)
		return
	if(alien != IS_SCORI)
		M.take_random_targeted_damage(burn = 0, burn = removed * 4)
	if(prob(50))
		M.apply_effect(4, AGONY, 0)
		if(prob(20))
			to_chat(M,"<span class='danger'>You feel like your insides are melting!</span>")
		else if(prob(20))
			M.visible_message("<span class='warning'>[M] [pick("dry heaves!","coughs!","splutters!")]</span>")



/datum/reagent/juhtakpulp
	name = "Juhtak Pulp"
	id = "juhtakpulp"
	description = "Pulp extracted from a juhtak plant."
	reagent_state = REAGENT_LIQUID
	color = "#684f32"
	taste_description = "bitter plant grit"

/datum/reagent/juhtakpulp/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	var/chem_effective = 1
	if(alien == IS_SLIME)
		chem_effective = 0.75
	if(alien != IS_DIONA)
		M.heal_organ_damage(2 * removed * chem_effective, 0) // Herbal Bicaridine, less effective. Use alchemy to make it better.

/datum/reagent/pokaleapaste
	name = "Pokalea Paste"
	id = "pokaleapaste"
	description = "Ground up pokalea leaves."
	reagent_state = REAGENT_LIQUID
	color = "#684c34"
	taste_description = "bitterness"

/datum/reagent/pokaleapaste/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(alien == IS_DIONA)
		return
	if(M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (10 * TEMPERATURE_DAMAGE_COEFFICIENT)) // Herbal Leporazine, less effective.
	else if(M.bodytemperature < 311)
		M.bodytemperature = min(310, M.bodytemperature + (10 * TEMPERATURE_DAMAGE_COEFFICIENT))

/datum/reagent/pyrrhleanectar
	name = "Pyrrhlea Nectar"
	id = "pyrrhleanectar"
	description = "The nectar of a pyrrhlea flower."
	reagent_state = REAGENT_LIQUID
	color = "#f0d74c"
	taste_description = "bitter nectar"

/datum/reagent/pyrrhleanectar/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(alien != IS_DIONA)
		M.add_chemical_effect(CE_STABLE, 7) // Herbal kelotane. Less effective
		M.heal_organ_damage(0, 2 * removed)

/datum/reagent/shimashpulp
	name = "Shimash Pulp"
	id = "shimashpulp"
	description = "Pulp extracted from a shimash plant."
	reagent_state = REAGENT_LIQUID
	color = "#f2f0ef"
	taste_description = "sour plant grit"

/datum/reagent/shimashpulp/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	var/chem_effective = 1
	if(alien == IS_SLIME)
		chem_effective = 0.75
	M.ceiling_chemical_effect(CE_PAINKILLER, 20 * chem_effective) //Herbal tramadol, much less effective.

/datum/reagent/bonemeal
	name = "Bonemeal"
	id = "bonemeal"
	description = "Ground up bones."
	reagent_state = REAGENT_SOLID
	color = "#f2f0ef"
	taste_description = "gritty sand"

/datum/reagent/catalyst
	name = "Catalyst"
	id = "catalyst"
	description = "Semi-anomalous powder. Properties unknown." // Powdered Elder Stone, for use in more advanced alchemy.
	reagent_state = REAGENT_SOLID
	color = "#9D14DB"
	taste_description = "forever"
