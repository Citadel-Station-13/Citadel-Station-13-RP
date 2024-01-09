//* Medicines intended for use within a cryotube. This usually means they have temperature requirements. *//

/datum/reagent/cryoxadone
	name = "Cryoxadone"
	id = "cryoxadone"
	description = "A chemical mixture with almost magical healing powers. Its main limitation is that the targets body temperature must be under 170K for it to metabolise correctly."
	taste_description = "overripe bananas"
	reagent_state = REAGENT_LIQUID
	color = "#8080FF"
	bloodstream_metabolism_multiplier = 0.5
	mrate_static = TRUE

/datum/reagent/cryoxadone/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()
	
	if(M.bodytemperature < 170)
		var/chem_effective = 1
		if(alien == IS_SLIME)
			chem_effective = 0.25
			to_chat(M, "<span class='danger'>It's cold. Something causes your cellular mass to harden occasionally, resulting in vibration.</span>")
			M.afflict_paralyze(20 * 10)
			M.silent = max(M.silent, 10)
			M.make_jittery(4)
		M.adjustCloneLoss(-10 * removed * chem_effective)//Clone damage, either occured during cloning or from xenobiology slimes.
		M.adjustOxyLoss(-10 * removed * chem_effective)//Also heals the standard damages
		M.heal_organ_damage(10 * removed, 10 * removed * chem_effective)
		M.adjustToxLoss(-10 * removed * chem_effective)

/datum/reagent/clonexadone
	name = "Clonexadone"
	id = "clonexadone"
	description = "A liquid compound similar to that used in the cloning process. Can be used to 'finish' the cloning process when used in conjunction with a cryo tube."
	taste_description = "rotten bananas"
	reagent_state = REAGENT_LIQUID
	color = "#80BFFF"
	bloodstream_metabolism_multiplier = 0.5
	mrate_static = TRUE

/datum/reagent/clonexadone/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()
	
	if(M.bodytemperature < 170)
		var/chem_effective = 1
		if(alien == IS_SLIME)
			if(prob(10))
				to_chat(M, "<span class='danger'>It's so cold. Something causes your cellular mass to harden sporadically, resulting in seizure-like twitching.</span>")
			chem_effective = 0.5
			M.afflict_paralyze(20 * 20)
			M.silent = max(M.silent, 20)
			M.make_jittery(4)
		M.adjustCloneLoss(-30 * removed * chem_effective)//Better version of cryox, but they can work at the same time
		M.adjustOxyLoss(-30 * removed * chem_effective)
		M.heal_organ_damage(30 * removed, 30 * removed * chem_effective)
		M.adjustToxLoss(-30 * removed * chem_effective)

/datum/reagent/necroxadone
	name = "Necroxadone"
	id = "necroxadone"
	description = "A liquid compound based upon that which is used in the cloning process. Utilized primarily in severe cases of toxic shock."
	taste_description = "meat"
	reagent_state = REAGENT_LIQUID
	color = "#94B21C"
	bloodstream_metabolism_multiplier = 0.5
	mrate_static = TRUE

/datum/reagent/necroxadone/on_mob_life(mob/living/carbon/M, alien, datum/reagent_holder/metabolism/location)
	if(M.stat == DEAD && M.has_modifier_of_type(/datum/modifier/bloodpump_corpse))
		affects_dead = TRUE
	else
		affects_dead = FALSE

	. = ..(M, alien, location)

/datum/reagent/necroxadone/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()
	
	if(M.bodytemperature < 170 || (M.stat == DEAD && M.has_modifier_of_type(/datum/modifier/bloodpump_corpse)))
		var/chem_effective = 1
		if(alien == IS_SLIME)
			if(prob(10))
				to_chat(M, "<span class='danger'>It's so cold. Something causes your cellular mass to harden sporadically, resulting in seizure-like twitching.</span>")
			chem_effective = 0.5
			M.afflict_paralyze(20 * 20)
			M.silent = max(M.silent, 20)
			M.make_jittery(4)
		if(M.stat != DEAD)
			M.adjustCloneLoss(-5 * removed * chem_effective)
		M.adjustOxyLoss(-20 * removed * chem_effective)//dehusking for cool people
		M.adjustToxLoss(-40 * removed * chem_effective)
