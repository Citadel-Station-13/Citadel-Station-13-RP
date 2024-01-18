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

	if(entity.bodytemperature < 170)
		var/chem_effective = 1
		if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_PROMETHEAN)])
			chem_effective = 0.25
			to_chat(entity, "<span class='danger'>It's cold. Something causes your cellular mass to harden occasionally, resulting in vibration.</span>")
			entity.afflict_paralyze(20 * 10)
			entity.silent = max(entity.silent, 10)
			entity.make_jittery(4)
		entity.adjustCloneLoss(-10 * removed * chem_effective)//Clone damage, either occured during cloning or from xenobiology slimes.
		entity.adjustOxyLoss(-10 * removed * chem_effective)//Also heals the standard damages
		entity.heal_organ_damage(10 * removed, 10 * removed * chem_effective)
		entity.adjustToxLoss(-10 * removed * chem_effective)

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

	if(entity.bodytemperature < 170)
		var/chem_effective = 1
		if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_PROMETHEAN)])
			if(prob(10))
				to_chat(entity, "<span class='danger'>It's so cold. Something causes your cellular mass to harden sporadically, resulting in seizure-like twitching.</span>")
			chem_effective = 0.5
			entity.afflict_paralyze(20 * 20)
			entity.silent = max(entity.silent, 20)
			entity.make_jittery(4)
		entity.adjustCloneLoss(-30 * removed * chem_effective)//Better version of cryox, but they can work at the same time
		entity.adjustOxyLoss(-30 * removed * chem_effective)
		entity.heal_organ_damage(30 * removed, 30 * removed * chem_effective)
		entity.adjustToxLoss(-30 * removed * chem_effective)

/datum/reagent/necroxadone
	name = "Necroxadone"
	id = "necroxadone"
	description = "A liquid compound based upon that which is used in the cloning process. Utilized primarily in severe cases of toxic shock."
	taste_description = "meat"
	reagent_state = REAGENT_LIQUID
	color = "#94B21C"
	bloodstream_metabolism_multiplier = 0.5
	metabolize_while_dead = TRUE

/datum/reagent/necroxadone/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	if(entity.bodytemperature < 170 || (entity.stat == DEAD && entity.has_modifier_of_type(/datum/modifier/bloodpump_corpse)))
		var/chem_effective = 1
		if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_PROMETHEAN)])
			if(prob(10))
				to_chat(entity, "<span class='danger'>It's so cold. Something causes your cellular mass to harden sporadically, resulting in seizure-like twitching.</span>")
			chem_effective = 0.5
			entity.afflict_paralyze(20 * 20)
			entity.silent = max(entity.silent, 20)
			entity.make_jittery(4)
		if(entity.stat != DEAD)
			entity.adjustCloneLoss(-5 * removed * chem_effective)
		entity.adjustOxyLoss(-20 * removed * chem_effective)//dehusking for cool people
		entity.adjustToxLoss(-40 * removed * chem_effective)
