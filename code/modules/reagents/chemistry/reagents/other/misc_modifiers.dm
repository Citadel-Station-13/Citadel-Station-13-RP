/*
 * Modifier-applying chemicals.
 */

// todo: this is all shit we need to add like, physiology / status effect inducing ones instead lmao?

/datum/reagent/modapplying
	name = "brute juice"
	id = "berserkmed"
	description = "A liquid that is capable of causing a prolonged state of heightened aggression and durability."
	taste_description = "metal"
	reagent_state = REAGENT_LIQUID
	color = "#ff5555"

	var/modifier_to_add = /datum/modifier/berserk
	var/modifier_duration = 2 SECONDS	// How long, per unit dose, will this last?

/datum/reagent/modapplying/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()
	
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		return
	M.add_modifier(modifier_to_add, removed * modifier_duration)

/datum/reagent/modapplying/cryofluid
	name = "cryogenic slurry"
	id = "cryoslurry"
	description = "An incredibly strange liquid that rapidly absorbs thermal energy from materials it contacts."
	taste_description = "siberian hellscape"
	color = "#4CDBDB"
	metabolism = REM * 0.5

	modifier_to_add = /datum/modifier/cryogelled
	modifier_duration = 3 SECONDS
	
	ingested_elimination_multiplier = 0
	dermal_elimination_multiplier = 0

/datum/reagent/modapplying/cryofluid/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()
	
	var/mob/living/carbon/M = entity
	M.adjust_bodytemperature(-removed * 20)

/datum/reagent/modapplying/cryofluid/touch_expose_mob(mob/target, volume, list/data, organ_tag)
	. = ..()
	
	var/mob/living/M = target
	if(isliving(M))
		var/mob/living/L = M
		for(var/I = 1 to rand(1, round(amount + 1)))
			L.add_modifier(modifier_to_add, amount * rand(modifier_duration / 2, modifier_duration * 2))

/datum/reagent/modapplying/cryofluid/contact_expose_turf(turf/target, volume, list/data, vapor)
	. = ..()
	
	var/turf/T = target
	if(istype(T, /turf/simulated/floor/water) && prob(amount))
		T.visible_message("<span class='danger'>\The [T] crackles loudly as the cryogenic fluid causes it to boil away, leaving behind a hard layer of ice.</span>")
		T.ChangeTurf(/turf/simulated/floor/outdoors/ice, 1, 1, TRUE)
	else
		if(istype(T, /turf/simulated))
			var/turf/simulated/S = T
			S.freeze_floor()
	return
