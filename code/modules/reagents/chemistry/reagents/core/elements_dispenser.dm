//* Stuff in here is mostly free. *//

/datum/reagent/aluminum
	name = "Aluminum"
	id = "aluminum"
	description = "A silvery white and ductile member of the boron group of chemical elements."
	taste_description = "metal"
	taste_mult = 1.1
	reagent_state = REAGENT_SOLID
	color = "#A8A8A8"

/datum/reagent/calcium
	name = "Calcium"
	id = "calcium"
	description = "A chemical element, the building block of bones."
	taste_description = "metallic chalk" // Apparently, calcium tastes like calcium.
	taste_mult = 1.3
	reagent_state = REAGENT_SOLID
	color = "#e9e6e4"

/datum/reagent/carbon
	name = "Carbon"
	id = "carbon"
	description = "A chemical element, the building block of life."
	taste_description = "sour chalk"
	taste_mult = 1.5
	reagent_state = REAGENT_SOLID
	color = "#1C1300"
	ingested_metabolism_multiplier = 1

/datum/reagent/carbon/on_metabolize_ingested(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed, obj/item/organ/internal/container)
	. = ..()

	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		return
	entity.reagents_ingested.remove_any(removed * 2)
	return 0

/datum/reagent/carbon/contact_expose_turf(turf/target, volume, temperature, list/data, vapor)
	. = ..()

	var/turf/T = target
	if(!istype(T, /turf/space))
		var/obj/effect/debris/cleanable/dirt/dirtoverlay = locate(/obj/effect/debris/cleanable/dirt, T)
		if (!dirtoverlay)
			dirtoverlay = new/obj/effect/debris/cleanable/dirt(T)
			dirtoverlay.alpha = volume * 30
		else
			dirtoverlay.alpha = min(dirtoverlay.alpha + volume * 30, 255)

/datum/reagent/chlorine
	name = "Chlorine"
	id = "chlorine"
	description = "A chemical element with a characteristic odour."
	taste_description = "pool water"
	reagent_state = REAGENT_GAS
	color = "#d1db77"

/datum/reagent/chlorine/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()
	entity.take_random_targeted_damage(removed, 0)

/datum/reagent/chlorine/touch_expose_mob(mob/target, volume, temperature, list/data, organ_tag)
	. = ..()

	var/mob/living/carbon/M = target
	if(!istype(M))
		return
	M.take_random_targeted_damage(volume, 0)

/datum/reagent/copper
	name = "Copper"
	id = "copper"
	description = "A highly ductile metal."
	taste_description = "pennies"
	color = "#6E3B08"

/datum/reagent/fluorine
	name = "Fluorine"
	id = "fluorine"
	description = "A highly-reactive chemical element."
	taste_description = "acid"
	reagent_state = REAGENT_GAS
	color = "#808080"

/datum/reagent/fluorine/touch_expose_mob(mob/target, volume, temperature, list/data, organ_tag)
	. = ..()
	if(!isliving(target))
		return
	var/mob/living/L = target
	L.adjustToxLoss(volume)

/datum/reagent/fluorine/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	var/mob/living/carbon/M = entity
	M.adjustToxLoss(removed)

/datum/reagent/hydrogen
	name = "Hydrogen"
	id = "hydrogen"
	description = "A colorless, odorless, nonmetallic, tasteless, highly combustible diatomic gas."
	taste_mult = 0 //no taste
	reagent_state = REAGENT_GAS
	color = "#808080"

/datum/reagent/iron
	name = "Iron"
	id = "iron"
	description = "Pure iron is a metal."
	taste_description = "metal"
	reagent_state = REAGENT_SOLID
	color = "#353535"
	ingested_metabolism_multiplier = 1

/datum/reagent/iron/on_metabolize_ingested(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed, obj/item/organ/internal/container)
	. = ..()

	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		return

	entity.add_reagent_cycle_effect(CHEMICAL_EFFECT_BLOODRESTORE, 8 * removed)

/datum/reagent/lithium
	name = "Lithium"
	id = "lithium"
	description = "A chemical element, used as antidepressant."
	taste_description = "metal"
	reagent_state = REAGENT_SOLID
	color = "#808080"

/datum/reagent/lithium/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		return

	var/mob/living/carbon/M = entity
	if(CHECK_MOBILITY(M, MOBILITY_CAN_MOVE) && istype(M.loc, /turf/space))
		step(M, pick(GLOB.cardinal))
	if(prob(5))
		M.emote(pick("twitch", "drool", "moan"))

/datum/reagent/mercury
	name = "Mercury"
	id = "mercury"
	description = "A chemical element."
	taste_mult = 0 //mercury apparently is tasteless. IDK
	reagent_state = REAGENT_LIQUID
	color = "#484848"

/datum/reagent/mercury/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		return

	var/mob/living/carbon/M = entity
	if(CHECK_MOBILITY(M, MOBILITY_CAN_MOVE) && istype(M.loc, /turf/space))
		step(M, pick(GLOB.cardinal))
	if(prob(5))
		M.emote(pick("twitch", "drool", "moan"))
	M.adjustBrainLoss(0.1)

/datum/reagent/nitrogen
	name = "Nitrogen"
	id = "nitrogen"
	description = "A colorless, odorless, tasteless gas."
	taste_mult = 0 //no taste
	reagent_state = REAGENT_GAS
	color = "#808080"

/datum/reagent/oxygen
	name = "Oxygen"
	id = "oxygen"
	description = "A colorless, odorless gas."
	taste_mult = 0
	reagent_state = REAGENT_GAS
	color = "#808080"

/datum/reagent/oxygen/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	if(!entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_VOX)])
		return

	var/mob/living/carbon/M = entity
	M.adjustToxLoss(removed * 3)

/datum/reagent/phosphorus
	name = "Phosphorus"
	id = "phosphorus"
	description = "A chemical element, the backbone of biological energy carriers."
	taste_description = "vinegar"
	reagent_state = REAGENT_SOLID
	color = "#832828"

/datum/reagent/phosphorus/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	if(!entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_ALRAUNE)] && !entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		return

	var/mob/living/carbon/M = entity
	M.nutrition += removed * 2 //cit change - phosphorus is good for plants

/datum/reagent/potassium
	name = "Potassium"
	id = "potassium"
	description = "A soft, low-melting solid that can easily be cut with a knife. Reacts violently with water."
	taste_description = "sweetness" //potassium is bitter in higher doses but sweet in lower ones.
	reagent_state = REAGENT_SOLID
	color = "#A0A0A0"

/datum/reagent/radium
	name = "Radium"
	id = "radium"
	description = "Radium is an alkaline earth metal. It is extremely radioactive."
	taste_mult = 0	//Apparently radium is tasteless
	reagent_state = REAGENT_SOLID
	color = "#C7C7C7"

/datum/reagent/radium/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	var/mob/living/carbon/M = entity
	M.afflict_radiation(RAD_MOB_AFFLICT_STRENGTH_RADIUM(removed))
	if(M.virus2.len)
		for(var/ID in M.virus2)
			var/datum/disease2/disease/V = M.virus2[ID]
			if(prob(5))
				M.antibodies |= V.antigen

/datum/reagent/radium/contact_expose_turf(turf/target, volume, temperature, list/data, vapor)
	. = ..()

	var/turf/T = target
	if(volume >= 3)
		if(!istype(T, /turf/space))
			var/obj/effect/debris/cleanable/greenglow/glow = locate(/obj/effect/debris/cleanable/greenglow, T)
			if(!glow)
				new /obj/effect/debris/cleanable/greenglow(T)
			return

/datum/reagent/silicon
	name = "Silicon"
	id = "silicon"
	description = "A tetravalent metalloid, silicon is less reactive than its chemical analog carbon."
	taste_mult = 0
	reagent_state = REAGENT_SOLID
	color = "#A8A8A8"

/datum/reagent/sodium
	name = "Sodium"
	id = "sodium"
	description = "A chemical element, readily reacts with water."
	taste_description = "salty metal"
	reagent_state = REAGENT_SOLID
	color = "#808080"

/datum/reagent/sulfur
	name = "Sulfur"
	id = "sulfur"
	description = "A chemical element with a pungent smell."
	taste_description = "old eggs"
	reagent_state = REAGENT_SOLID
	color = "#BF8C00"

/datum/reagent/tungsten
	name = "Tungsten"
	id = "tungsten"
	description = "A chemical element, and a strong oxidising agent."
	taste_description = "metal"
	taste_mult = 0 //no taste
	reagent_state = REAGENT_SOLID
	color = "#DCDCDC"
